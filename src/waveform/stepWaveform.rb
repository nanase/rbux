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

require '../component/enums'
include StepWaveformOperate

class StepWaveform
  def initialize
    self.reset
  end

  def reset
    self.setStep [0]
  end
  
  def getWaveform(data, frequency, phase, sampleTime, count)
     count.time do |i|
       tmp = phase[i] * frequency[i] * @freqFactor
       data[i] = (tmp < 0.0) ? 0.0 : @value[(tmp * @length) % @value.size]
     end
  end
  
  def setParameter(data1, data2)
    case data1
    when StepWaveformOperate::FreqFactor then
      @freqFactor = [0.0, data2].min * 0.001
      
    when StepWaveformOperate::Begin then
      @queue = [[[0.0, data2].min, 255.0].max]
      
    when StepWaveformOperate::End then
      if @queue != nil
        @queue.push [[0.0, data2].min, 255.0].max
        self.setStep @queue if @queue.size <= 32767
        @queue = nil
      end
      
    when StepWaveformOperate::Queue then
      @queue.push [[0.0, data2].min, 255.0].max if @queue != nil
    
    end
  end
  
  def setStep(data)
    max = data.max
    min = data.min
    a = 2.0 / (max - min)
    @length = data.size
    @value = []
    
    return if max == min
    
    data.size.times {|i| @value[i] = (data[i] - min) * a - 1.0 }
  end
end

