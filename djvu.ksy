meta:
  id: djvu
  file-extension: djvu
  endian: be
seq:
  - id: signature
    type: signature
  - id: form
    type: form
instances:
  file:
    pos: 2286
    type: form
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
      type: strz
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
  dirm: # Page 12
    seq:
      - id: bundled
        type: b1
      - id: version
        type: b7
      - id: nfiles
        type: u2
      - id: offset
        type: u4
        repeat: expr
        repeat-expr: nfiles
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
        
