#import "/template.typ": *

#[
  #set heading(numbering: none, supplement: [Phụ lục])
  = Phụ lục <phuluc>
]

#set heading(numbering: (..nums) => {
  nums = nums.pos()
  numbering("A.1.", ..nums.slice(1))
}, supplement: [Phụ lục])

#counter(heading).update(1)

== Kết quả phân tích bổ sung của các phiên bản MPBoot-RL <pl-aco-1>

#figure(
  image("/images/acomul_spr6.png"),
  caption: [So sánh kết quả của ACO-MUL với SPR6 trên 115 bộ dữ liệu TreeBASE],
  numbering: phuluc_numbering
) <acomul_spr6>

#figure(
  image("/images/acomul_tbr5.png"),
  caption: [So sánh kết quả của ACO-MUL với TBR5 trên 115 bộ dữ liệu TreeBASE],
  numbering: phuluc_numbering
) <acomul_tbr5>

#figure(
  image("/images/acomul_tbr5_better.png"),
  caption: [So sánh kết quả của ACO-MUL với TBR5-BETTER trên 115 bộ dữ liệu TreeBASE],
  numbering: phuluc_numbering
) <acomul_tbr5better>

#figure(
  image("/images/acoonce_spr6.png"),
  caption: [So sánh kết quả của ACO-ONCE với SPR6 trên 115 bộ dữ liệu TreeBASE],
  numbering: phuluc_numbering
) <acoonce_spr6>

#figure(
  image("/images/acoonce_tbr5.png"),
  caption: [So sánh kết quả của ACO-ONCE với TBR5 trên 115 bộ dữ liệu TreeBASE],
  numbering: phuluc_numbering
)

#figure(
  image("/images/acoonce_tbr5_better.png"),
  caption: [So sánh kết quả của ACO-ONCE với TBR5-BETTER trên 115 bộ dữ liệu TreeBASE],
  numbering: phuluc_numbering
)
== Kết quả bổ sung của các phiên bản MPBoot-RL với các bộ siêu tham số khác nhau <pl-aco>
