part of dart_io;

// TODO: Fix the UINT8LIST stuff below
class DataOutput {
  List<int> data = new List();
  int offset = 0;
  int get fileLength => data.length; 
  
  Uint8List _buffer = new Uint8List(8);
  ByteData _view;
  
  DataOutput() {
    _view = new ByteData.view(_buffer.buffer);
  }
  
  void write (List<int> bytes) {
    int blength = bytes.length;
    data.addAll(bytes);
    offset += blength;
  }
    
  void writeBoolean (bool v, [Endian endian = Endian.big]) {
    writeByte(v ? 1 : 0, endian);
  }
  void writeByte(int v, [Endian endian = Endian.big]) {
    data.add(v);
    offset += 1;
  }
      
  void writeChar(int v, [Endian endian = Endian.big]) {
    writeShort(v, endian);
  }
  void writeChars(String s, [Endian endian = Endian.big]) {
    for (int x = 0; x <= s.length; x++) {
      writeChar(s.codeUnitAt(x), endian);
    }
  }
  

  void writeFloat(double v, [Endian endian = Endian.big]) {
    _view.setFloat32(0, v, endian);
    write(_buffer.getRange(0, 4).toList());
  }
  void writeDouble(double v, [Endian endian = Endian.big]) {
    _view.setFloat64(0, v, endian);
    write(_buffer.getRange(0, 8).toList());
  }

  void writeShort(int v, [Endian endian = Endian.big]) {
    _view.setInt16(0, v, endian);
    write(_buffer.getRange(0, 2).toList());
  }
  void writeInt(int v, [Endian endian = Endian.big]) {
    _view.setInt32(0, v, endian);
    write(_buffer.getRange(0, 4).toList());
  }

  void writeLong(int v, [Endian endian = Endian.big]) {
    _view.setInt64(0, v, endian);
    write(_buffer.getRange(0, 8).toList());
  }
 
  void writeUTF(String s, [Endian endian = Endian.big]) {
    if (s == null) throw new ArgumentError("String cannot be null");
    List<int> bytesNeeded = utf8.encode(s);
    if (bytesNeeded.length > 65535) throw new FormatException("Length cannot be greater than 65535");
    writeShort(bytesNeeded.length, endian);
    write(bytesNeeded);
  }
  
  List<int> getBytes () {
    return data;
  }
  
  List<int> getBytesGZip () {
    GZipEncoder ginf = new GZipEncoder();
    return ginf.encode(data);
  }
  
  List<int> getBytesZLib () {
    ZLibEncoder zenc = new ZLibEncoder();
    return zenc.encode(data);
  }
}
