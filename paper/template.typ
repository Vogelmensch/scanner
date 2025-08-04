#import "acm-copyright.typ": *

#let mainFont = "Linux Libertine O"
#let sfFont = "Linux Biolinum O"
#let mathFont = "Libertinus Math"

#let bigskipamount = 12pt
#let medskipamount = bigskipamount / 2
#let smallskipamount = medskipamount / 2

#let sf(body) = text(font: sfFont, body)

#let acmart(
  // Currently supported formats are:
  //  - acmsmall
  format: "acmsmall", 

  // Title, subtitle, authors, abstract, ACM ccs, keywords
  title: "Title",
  subtitle: none,
  shorttitle: none,
  authors: (),
  shortauthors: none,
  abstract: none, 
  ccs: (
    ([Do Not Use This Code], (
        (500, [Generate the Correct Terms for Your Paper]),
        (300, [Generate the Correct Terms for Your Paper]),
        (100, [Generate the Correct Terms for Your Paper]),
        (100, [Generate the Correct Terms for Your Paper]))),
  ),
  keywords:
    ("Do", "Not", "Us", "This", "Code", "Put", "the",
     "Correct", "Terms", "for", "Your", "Paper"),

  // acm journal
  acmJournal: none,
  acmVolume: 1,
  acmNumber: 1,
  acmArticle: none,
  acmMonth: 5,

  acmConference: none,
  acmConferenceAcronym: none,
  acmConferenceDate: none,
  acmConferenceLocation: none,

  // acm information
  acmYear: 2023,
  acmDOI: "XXXXXXX.XXXXXXX",

  // copyright
  copyright: none,
  copyrightYear: 2023,

  // paper's content
  body
) = {
  if type(authors) != array {
    authors = (authors,)
  }
  
  let journal = if acmJournal == "JACM" {
    (
      name: "Journal of the ACM",
      nameShort: "J. ACM"
    )
  } else { 
    none
  }

  let displayMonth(month) = (
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ).at(month - 1)

  if shorttitle == none {
    shorttitle = title
  }

  if shortauthors == none {
    shortauthors = authors.map(author => author.name).join(", ", last: " and ")
  }

  // Set document metadata
  set document(title: title, author: shortauthors)

  // Configure the page.
  set columns(gutter: 24pt)
  set page(
    columns: 2,
    width:  8.5in,
    height: 11in,
    margin: (
      top:    57pt + 27pt,
      bottom: 85pt,
      left:   53.5pt,
      right:  53.5pt
    ),
    header: context {
      set text(size: 7pt, font: sfFont)
      let (currentpage,) = counter(page).get()
      if currentpage == 1 {

      } else  {
        let acmArticlePage = [#acmArticle:#counter(page).display()]
        [
          #block(
            height: 10pt,
            width: 100%,
            if calc.rem(currentpage, 2) == 0 [
              #shorttitle
              #h(1fr)
              #shortauthors
            ] else [
              #shorttitle
              #h(1fr)
              #shortauthors
            ]
          )
          #v(17pt)
        ]
      }
    },
    header-ascent: 0%,
    footer-descent: 0%,
  )

  set text(font: mainFont, size: 9pt)
  // show math.equation: set text(font: mathFont)

  // set titlepage
  {
    set par(justify: true, leading: 0.555em, spacing: 0pt)

   place(top, float: true, scope: "parent", clearance:12.5pt,
    block(width: 100%, {
    set align(center)
    // Display title
    {
      set text(font: sfFont, size: 17.18pt, weight: "bold")
      par(title)
      if subtitle != none {
        v(12.5pt)
        set text(font: sfFont, size: 12pt, weight: "regular")
        par(subtitle)
      }
      v(15.5pt)
    }

    // Display authors
    {
      // set par(leading: 5.8pt)
      set par(leading: 0.555em)
      let displayAuthor(author) = [#text(size: 12pt, author.name)]
      let displayAuthors(authors) = authors.map(displayAuthor).join(", ", last: "\n")
      let displayEmails(emails) = emails.map(email => [#text(size: 10pt, email)]).join("\n")

      let displayAffiliation(affiliation) = [#text(size: 10pt)[
        #affiliation.institution,
        #if affiliation.at("city", default: none) != none [
          #affiliation.city,
        ]
        #if affiliation.at("state", default: none) != none [
          #affiliation.state,
        ]
        #affiliation.country
        ]\
      ]
      let authorArray = {
        let affiliation = none
        let currentAuthors = ()
        let currentEmails = ()
        for author in authors {
          // if affiliation changes, print author list and affiliation
          if author.affiliation != affiliation and affiliation != none {
            let authorBox = box({ 
              set par(leading: 5.5pt)
              displayAuthors(currentAuthors)
              text([\ ])
              displayAffiliation(affiliation)
              if currentEmails != () {
                text([\ ])
                displayEmails(currentEmails)
              }
              }
            )
            (authorBox,)
            currentAuthors = ()
            currentEmails = ()
          }
          currentAuthors.push(author)
          if author.at("email", default: none) != none {
            currentEmails.push(author.email)
          }
          affiliation = author.affiliation
        }
        let authorBox = box({
          displayAuthors(currentAuthors)
          text([\ ])
          if affiliation != none {
            displayAffiliation(affiliation)
          }
          if currentEmails != () {
            displayEmails(currentEmails)
          }
        })
        (authorBox,)
      }

      authorArray.chunks(3).map(authors => {
        grid(columns: range(authors.len()).map(_ => 32.65%), ..authors)
      }
      ).intersperse(v(14.0pt)).sum()
      // v(12pt)
    }
    })
  )

  let unnumberedHeading(head) = block(below: 0.775em, above: 1.8em, sticky: true, {
      set text(weight: "bold", size: 11pt)
      upper(head)
    })

    // Display abstract
    if abstract != none {
        set par(
          justify: true,
          leading: 4.5pt,
          first-line-indent: 11.5pt,
          spacing: 4.5pt)
      unnumberedHeading("Abstract")
      text(size: 9pt, abstract)
    }

    // Display CSS concepts:
    if ccs != none {
      unnumberedHeading("CCS Concepts")
      text(size: 9pt)[
        #ccs.fold((), (acc, concept) => {
          acc + ([
            #box(baseline: -50%, circle(radius: 1.25pt, fill: black))
            #strong(concept.at(0))
            #sym.arrow.r
            #{concept.at(1).fold((), (acc, subconcept) => {
                acc + (if subconcept.at(0) >= 500 {
                  [ *#subconcept.at(1)*]
                } else if subconcept.at(0) >= 300 {
                  [ _#subconcept.at(1)_]
                } else {
                  [ #subconcept.at(1)]
                }, )
              }).join(";")
            }],)
        }).join(";").
      ]
    }

    // Display keywords
    if keywords != none {
      unnumberedHeading("Keywords")
      text(size: 9pt, keywords.join(", "))
    }

    // Display ACM reference format
    // unnumberedHeading(text(size: 8pt, "ACM Reference Format:"))
    // v(-0.3em)
    // context [
    //   #text(size: 8pt, tracking: -0.08pt)[
    //   #authors.map(author => author.name).join(", ", last: ", and ").
    //   #acmYear.
    //   #title.
    //   In
    //   #emph([Proceedings of #acmConference (#acmConferenceAcronym).])
    //   ACM, New York, NY, USA,
    //   #counter(page).display((..nums) => [
    //     #nums.pos().last() page#if(nums.pos().last() > 1) { [s] }.
    //   ],both: true)
    //   https:\/\/doi.org\/#acmDOI
    //   ]
    // ]
    // v(1pt)

    // place footer
    set par(leading: 3.5pt)
    set text(size: 6.98pt)
    place(bottom, float: true, clearance: .5em)[
      #line(length: 100%, stroke: 0.4pt + black)
      #v(.6em)
      #let (copyright-short, copyright-text) = copyright-text(copyright)
      #copyright-text\
      #if copyright != "studentpaper" [
        #emph([#acmConferenceAcronym, #acmConferenceLocation])\
        #sym.copyright #acmYear #copyright-short\
        ACM ISBN 978-1-4503-XXXX-X/2018/08\
        https:\/\/doi.org\/#acmDOI
      ]
    ]
  }

  set heading(numbering: "1.1.1")
  show heading: it => if it.level <= 2 {
      block(below: 0.7em, above: 1.75em, sticky: true, {
        set text(size: 11pt, weight: "bold")
        if heading.numbering != none {
          counter(heading).get().map(str).join(".")
          h(10.5pt)
        }
        if it.level == 1 {
          upper(it.body)
        } else {
          it.body
        }
      })
  } else if it.level == 3 {
    block(below: 0.7em, above: 1.75em, sticky: true, {
      set text(size: 9pt, weight: "regular")
      emph({
        counter(heading).get().map(str).join(".")
        h(10.5pt)
        it.body
      })
    })
  } else {
    box({
      set text(size: 9pt, weight: "regular")
      if it.level == 4 { h(4.5pt) }
      emph(it.body + [.])
    })
  }

  set par(
    justify: true,
    leading: 4.5pt,
    first-line-indent: 11.5pt,
    spacing: 4.5pt)

  show figure: it => {
    if it.kind == table {
      show figure.caption: set align(center)
      show figure.caption: set text(size: 9pt, weight: "bold")
      it
    } else {
      show figure.caption: set align(top+start)
      show figure.caption: set text(size: 8.7pt, weight: "bold")
      it
    }
  }

  show figure.caption: it => {
    set par(justify: true, leading: 4.5pt, spacing: 0.8em)
      block(
        inset: if it.position == top {
            (bottom: 0.8em)
          } else {
            (top: 0.8em)
          },
        it
      )
  }

  set table.cell(inset: 0.4em)

  set list(indent: 1em)
  show list: it => {
    block(below: 0.7em, above: 0.75em, sticky: true, {
      it
    })
  }

  // Display content
  body
}
