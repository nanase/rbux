=begin
rbux - ux implementation for Ruby
Copyright (c) 2013 Tomona Nanase

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

require './envelopeState'
require './enums'
include EnvelopeState
include EnvelopeOperate

class Envelope
  def initialize(samplingRate)
    @samplingRate = samplingRate
    self.reset
  end
  
  def reset
    @attackTime = (0.05 * @samplingRate).to_i
    @peakTime = (0.0 * @samplingRate).to_i
    @decayTime = (0.0 * @samplingRate).to_i
    @sustainLevel = 1.0
    @releaseTime = (0.2 * @samplingRate).to_i
    @state = EnvelopeState::Silence
  end
  
  def attack
    @state = EnvelopeState::Attack
    
    #precalc
    @t2 = @attackTime + @peakTime
    @t3 = @t2 + @decayTime
    @da = 1.0 / @attackTime
    @dd = (1.0 - @sustainLevel) / @decayTime
  end
  
  def release(time)
    if @state == EnvelopeState::Attack then
      @state = EnvelopeState::Release
      @releaseStartTime = time
      
      #precalc
      @releaseStartLevel =
       (time < @attackTime) ? time * @da :
          (time < @t2) ? 1.0 :
          (time < @t3) ? 1.0 - (time - @t2) * @dd : @sustainLevel
      
      @t5 = time + @releaseTime
      @dr = @releaseStartLevel / @releaseTime
    end
  end
  
  def silence
    @state = EnvelopeState::Silence
  end
  
  def generate(time, envelopes, count)
    count.times do |i|
      if @state == EnvelopeState::Attack then
        res = (time < @attackTime) ? time * @da :
          (time < @t2) ? 1.0 :
          (time < @t3) ? 1.0 - (time - @t2) * @dd : @sustainLevel
      elsif @state == EnvelopeState::Release then
        if time < @t5 then
          res = @releaseStartLevel - (time - @releaseStartTime) * @dr
        else
          res = 0.0
          @state = EnvelopeState::Silence
        end
      else
        res = 0.0
      end
    
      envelopes[i] = res
      time += 1
    end
  end
  
  def setParamater(data1, data2)
    case data1
    when EnvelopeOperate::Attack then
      @attacktime = [data2, 0.0].max * @samplingRate
    when EnvelopeOperate::Peak then
      @peakTime = [data2, 0.0].max * @samplingRate
    when EnvelopeOperate::Decay then
      @decayTime = [data2, 0.0].max * @samplingRate
    when EnvelopeOperate::Sustain then
      @sustainLevel = [[1.0, data2].min, 0.0].max
    when EnvelopeOperate::Release then
      @releaseTime = [data2, 0.0].max * @samplingRate
    end
  end
end

