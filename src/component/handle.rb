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

require './handleType'
include HandleType

class Handle
  attr_reader :targetPart, :type, :data1, :data2
  
  def initialize(targetPart, type, data1 = 0, data2 = 0.0)
    @targetPart = targetPart
    @type = type
    @data1 = data1
    @data2 = data2
  end
  
  def self.fromHandle(handle, newTargetPart)
    Handle.new newTargetPart, handle.type, handle.data1, handle.data2
  end
  
  def to_s
    "#{HandleType.name @type} Part:#{@targetPart} Data1:#{@data1} Data2:#{@data2}"
  end
end

