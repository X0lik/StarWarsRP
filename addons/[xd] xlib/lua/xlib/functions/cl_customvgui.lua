XD = XD or {}
function XD:CreateFont( name, dfont, dsize, dweight )

  surface.CreateFont( name, {
    font = dfont,
    size = dsize,
    weight = dweight,
    extended = true,
  })

end
