meta:
  id: djvu
  file-extension: djvu
  endian: be
seq:
  - id: signature
    type: signature
  - id: form
    type: form
#instances:
#  file:
#    pos: 2286
#    type: form

#instances:
#  file_bodies:
#    pos: ofs_files[_index]
#    size: len_files[_index]
#    repeat: expr
#    repeat-expr: chunk.dirm.nfiles

types:
  signature:
    seq:
      - id: magic
        contents: 'AT&T'
  form:
    seq:
      - id: header
        contents: 'FORM'
      - id: size
        type: u4
      - id: chunk
        type: chunk
  chunk:
    seq:
    - id: chunk_type
      type: str
      encoding: ascii
      size: 8
    - id: len
      type: u4
    - id: body
      size: len
      type:
        switch-on: chunk_type
        cases:
          '"DJVUINFO"': info
          '"DJVMDIRM"': dirm
          '"DJVIDjbz"': djbz
  dirm: # Page 12
    seq:
      - id: bundled
        type: b1
      - id: version
        type: b7
      - id: nfiles
        type: u2
      - id: offsets
        type: u4
        repeat: expr
        repeat-expr: 2 # nfiles
    instances:
      files:
        io: _root._io
        #pos: offsets[_index]
        pos: offsets[0]
        type: form
        #size: offsets[_index + 1] - offsets[_index]
        repeat: expr
        repeat-expr: 2 #nfiles - 1
      poop:
        io: _root._io
        pos: offsets[1]
        type: form
  djbz: # Shared shape table
    seq:
      - id: poop
        type: u4
  info: # Page 24
    seq:
      - id: width
        type: u2
      - id: height
        type: u2
      - id: minor_version
        type: u1
      - id: major_version
        type: u1
      - id: dpi
        type: u2
      - id: gamma
        type: u1
      - id: unused
        type: b5
      - id: rotation
        type: b3
        # Rotation:
        #  1 – 0° (rightside up)
        #  6 – 90° Counter Clockwise
        #  2 – 180° (unside down)
        #  5 – 90° Clockwise

      #- id: poop
      #  type: u1
      #  repeat: eos
        
