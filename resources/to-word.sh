#!/bin/bash
#
# converts the literature.bib to WORDs XML format, see
# https://stackoverflow.com/questions/14993017/how-do-i-convert-a-bibtex-bib-file-to-word-2010-xml


bib2xml literature.bib | xml2wordbib | sed \
    -e 's/ArticleInAPeriodical/JournalArticle/g' \
    -e 's/PeriodicalName/JournalName/g' \
    -e 's/>Proceedings/>ConferenceProceedings/g' > literature_word.xml

