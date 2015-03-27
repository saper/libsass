#serial 1
AC_DEFUN([CXX11_CHECK_HEADER],
[
  AC_REQUIRE([CXX11_STD_AVAILABLE])
  AH_TEMPLATE(AS_TR_CPP([HAVE_CXX_$1]),
    [Define to 1 if you have <$1> C++ header file.])
  AC_MSG_CHECKING([for <$1>])
  _CXX11_STD_TRY(m4_translit(AS_TR_CPP($1), [A-Z], [a-z]), [[#include <$1>]], $2, [ "" $cxx11_cv_prog_cxx_cxx11 ])
  AS_IF([test "x$cxx11_cv_prog_cxx_$1" != xno],
    [AC_DEFINE_UNQUOTED(AS_TR_CPP([HAVE_CXX_]$1))])
])
AC_DEFUN([CXX11_HEADER_SUCCESSION],
[
  CXX11_CHECK_HEADER([$1], [$2])
  AS_IF([test "x$cxx11_cv_prog_cxx_$1" = xno], [
    CXX11_CHECK_HEADER([$3], [$4])
  ])
])
AC_DEFUN([CXX11_TR1_HEADER],
[
  AH_TEMPLATE(AS_TR_CPP([[HAVE_CXX_ONLY_TR1_]m4_translit([$1], [a-z], [A-Z])]),
    [Define to 1 if you only have <tr1/$1> C++ header file working.])
  CXX11_HEADER_SUCCESSION([$1], [$2], [tr1/$1], [$3])
  AS_IF([test "x$cxx11_cv_prog_cxx_$1" = xno], [
    AS_IF([test "x$cxx11_cv_prog_cxx_tr1_$1" != xno],
      [AC_DEFINE_UNQUOTED(AS_TR_CPP([[HAVE_CXX_ONLY_TR1_]m4_translit([$1], [a-z], [A-Z])]))]
    )
  ])
])
AC_DEFUN([CXX11_RANDOM], [CXX11_TR1_HEADER([random],
  [[std::uniform_real_distribution<double> distributor(1, 30);]],
  [[std::tr1::uniform_real<double> distributor(1, 30);]])
])
AC_DEFUN([CXX11_UNORDERED_MAP], [CXX11_TR1_HEADER([unordered_map],
  [[ std::unordered_map<int, int> m; m.reserve(6); ]],
  [[ std::tr1::unordered_map<int, int> m; ]])
])
AC_DEFUN([CXX11_ATOMIC], [CXX11_HEADER_SUCCESSION(
  [atomic], [[ std::atomic_bool b1]],
  [cstdatomic], [[ std::atomic_bool b1]])
])
