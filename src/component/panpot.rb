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

class Panpot
  attr_reader :l, :r
  
  def initialize(l, r)
    @l = [[1.0, l].min, 0.0].max
    @r = [[1.0, r].min, 0.0].max
  end
  
  def self.fromValue(value)
    Panpot.new (value >= 0.0 ? Math.sin(( value + 1.0) * Math::PI / 2.0) : 1.0),
               (value <= 0.0 ? Math.sin((-value + 1.0) * Math::PI / 2.0) : 1.0)
  end

  def to_s
    "[#{@l}, #{@r}]"
  end
end

