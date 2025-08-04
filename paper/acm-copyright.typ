
#let copyright-text(copyright) = {
  let entries = (
    "acmcopyright": (
      [ACM],
      [
        Permission to make digital or hard copies of all or part of this
        work for personal or classroom use is granted without fee provided
        that copies are not made or distributed for profit or commercial
        advantage and that copies bear this notice and the full citation on
        the first page. Copyrights for components of this work owned by
        others than ACM must be honored. Abstracting with credit is
        permitted. To copy otherwise, or republish, to post on servers or
        to redistribute to lists, requires prior specific permission
        and/or a fee. Request permissions from permissions\@acm.org.
      ]
    ),
    "acmlicensed": (
      [Copyright held by the owner/author(s). Publication rights licensed to ACM.],
      [
        Permission to make digital or hard copies of all or part of this
        work for personal or classroom use is granted without fee provided
        that copies are not made or distributed for profit or commercial
        advantage and that copies bear this notice and the full citation on
        the first page. Copyrights for components of this work owned by
        others than the author(s) must be honored. Abstracting with credit
        is permitted. To copy otherwise, or republish, to post on servers
        or to redistribute to lists, requires prior specific permission
        and/or a fee. Request permissions from permissions\@acm.org.
      ]
    ),
    "rightsretained": (
      [Copyright held by the owner/author(s).],
      [
        Permission to make digital or hard copies of all or part of this
        work for personal or classroom use is granted without fee provided
        that copies are not made or distributed for profit or commercial
        advantage and that copies bear this notice and the full citation on
        the first page. Copyrights for third-party components of this work
        must be honored. For all other uses, contact the
        owner/author(s).
      ]
    ),
    "studentpaper": (
      [],
      [
        #image("cc-by.svg", height: 15pt)\
        
        #link("https://creativecommons.org/licenses/by-sa/4.0/legalcode")[This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.]
      ]
    )
  )

  if entries.at(copyright, default: none) != none {
    entries.at(copyright)
  } else {
    panic("Unknown copyright type: " + copyright)
  }
}

