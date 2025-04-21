#let trang_bia(title, authors, subtitle, entries) = {
  rect(
    stroke: 5pt,
    inset: 7pt,
  rect(
    width: 100%,
    height: 100%,
    inset: 15pt,
    stroke: 1.7pt,
    [
      #align(center)[
      #text(12pt, strong("ĐẠI HỌC QUỐC GIA HÀ NỘI"))
  
      #text(12pt, strong("TRƯỜNG ĐẠI HỌC CÔNG NGHỆ"))
      ]
      #v(0.6cm)
      #align(center)[
        #image("/images/UET.png", width: 25%)
      ]
      #v(0.7cm)
      
      #align(center)[
        #text(14pt, strong(authors.map(a => a.name).join(", ")))
      ]
      
      #v(1.2cm)
      #align(center)[
        #text(18pt,  upper(strong(title)))
      ]

      #align(center)[
        #text(14pt, strong(subtitle))
      ]
      #v(1cm)
      #for entry in entries {
        align(center)[
          #text(14pt, strong(entry.name) + ": " + entry.value)
        ]
      }
      #v(1fr)
      #align(center)[
        #text(12pt, strong("HÀ NỘI - " + datetime.today().display("[year]")) )
      ]
    ]  
  ))
}
