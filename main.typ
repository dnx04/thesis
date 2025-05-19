#import "template.typ": *

#show: project.with(
  title: "Xây dựng hệ thống quản lý bề mặt tấn công cho kiểm thử xâm nhập",
  authors: ((name: "Nguyễn Hoàng Dương"), ),
  subtitle: "Báo cáo dự án công nghệ - INT3132",
  entries: (
    (name: "Ngành", value: "Khoa học máy tính"),
    (name: "Lớp khoá học", value: "QH-2022-I/CQ-I-CS4"),
    (name: "Mã sinh viên", value: "22028007"),
    (name: "Cán bộ hướng dẫn", value: "TS. Nguyễn Đại Thọ"),
  ) ,
)

// #include "src/05_bang_thuat_ngu.typ"
// #include "chapters/05_trang_thong_tin_do_an_en.typ"

#counter(page).update(1)
#set page(numbering: "1")
#set heading(numbering: "1.1.", supplement: "Chương")

#include "src/06_chuong_1.typ"
#include "src/07_chuong_2.typ"
#include "src/08_chuong_3.typ"
#include "src/09_chuong_4.typ"
#include "src/10_chuong_5.typ"
// #include "src/11_ket_luan.typ"
// #include "src/12_cong_bo_lien_quan.typ"
#bibliography("ref.bib", style: "elsevier-vancouver")
