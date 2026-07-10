<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"
    omit-xml-declaration="no"/>

  <xsl:param name="perseus-dir" select="'perseusdl/data'"/>
  <xsl:param name="perseus-sha" select="'master'"/>
  <xsl:param name="out-dir" select="'tei'"/>
  <xsl:param name="id" select="''"/>

  <xsl:template match="/">
    <xsl:apply-templates select="
      //play[@source and tei:titleStmt and ($id = '' or @id = $id)]"/>
  </xsl:template>

  <xsl:template match="play">
    <xsl:variable name="src-path"
      select="concat(resolve-uri($perseus-dir, base-uri(/)), '/', @source)"/>
    <xsl:variable name="out-path"
      select="concat(resolve-uri($out-dir, base-uri(/)), '/', @slug, '.xml')"/>
    <xsl:message>
      <xsl:value-of select="@source"/>
      <xsl:text> -- </xsl:text>
      <xsl:value-of select="@slug"/>
    </xsl:message>
    <xsl:choose>
      <xsl:when test="doc-available($src-path)">
        <xsl:variable name="src" select="doc($src-path)"/>
        <xsl:result-document href="{$out-path}" method="xml" indent="yes" encoding="UTF-8">
          <TEI type="dracor" xml:id="{@id}" xml:lang="grc">
            <teiHeader>
              <fileDesc>
                <xsl:copy-of select="tei:titleStmt"/>
                <publicationStmt>
                  <publisher xml:id="dracor">DraCor</publisher>
                  <availability>
                    <licence target="https://creativecommons.org/licenses/by-sa/4.0/">
                      <xsl:text>CC BY-SA 4.0</xsl:text>
                    </licence>
                  </availability>
                </publicationStmt>
                <sourceDesc>
                  <bibl type="digitalSource">
                    <ref>
                      <xsl:attribute name="target">
                        <xsl:text>https://github.com/PerseusDL/canonical-greekLit/blob/</xsl:text>
                        <xsl:value-of select="$perseus-sha"/>
                        <xsl:text>/data/</xsl:text>
                        <xsl:value-of select="@source"/>
                      </xsl:attribute>
                      <xsl:text>Perseus Digital Library</xsl:text>
                    </ref>
                    <availability>
                      <licence target="https://creativecommons.org/licenses/by-sa/4.0/">
                        CC BY-SA 4.0
                      </licence>
                    </availability>
                  </bibl>
                  <xsl:variable name="biblStruct"
                    select="$src//tei:sourceDesc/tei:biblStruct"/>
                  <xsl:variable name="monogr" select="$biblStruct/tei:monogr"/>
                  <xsl:variable name="mainTitle"
                    select="$monogr/tei:title[not(@type) or @type != 'sub'][1]"/>
                  <xsl:variable name="subTitle"
                    select="$monogr/tei:title[@type='sub']"/>
                  <xsl:variable name="author" select="$monogr/tei:author"/>
                  <xsl:variable name="editor" select="$monogr/tei:editor"/>
                  <xsl:variable name="pubPlaces"
                    select="$monogr//tei:pubPlace"/>
                  <xsl:variable name="publishers"
                    select="$monogr//tei:publisher"/>
                  <xsl:variable name="date" select="$monogr//tei:date"/>
                  <xsl:variable name="volume"
                    select="$monogr//tei:biblScope[@unit='volume']"/>
                  <bibl type="originalSource">
                    <xsl:if test="$author and normalize-space($author) != normalize-space($mainTitle)">
                      <xsl:copy-of select="$author"/>
                      <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:if test="$mainTitle">
                      <xsl:copy-of select="$mainTitle"/>
                      <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:if test="$volume">
                      <xsl:text>Vol. </xsl:text>
                      <xsl:copy-of select="$volume"/>
                      <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:for-each select="$subTitle">
                      <xsl:copy-of select="."/>
                      <xsl:text>. </xsl:text>
                    </xsl:for-each>
                    <xsl:if test="$editor">
                      <xsl:choose>
                        <xsl:when test="$editor[1]/@role='translator'">
                          <xsl:text>Translated by </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>Edited by </xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:for-each select="$editor">
                        <xsl:copy-of select="."/>
                        <xsl:choose>
                          <xsl:when test="position() = last()"/>
                          <xsl:when test="position() = last() - 1">
                            <xsl:text> and </xsl:text>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text>, </xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                      <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:for-each select="$pubPlaces">
                      <xsl:copy-of select="."/>
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:text>, </xsl:text>
                        </xsl:when>
                        <xsl:when test="$publishers">
                          <xsl:text>: </xsl:text>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="$publishers">
                      <xsl:copy-of select="."/>
                      <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="$date">
                      <xsl:if test="$publishers or $pubPlaces">
                        <xsl:text>, </xsl:text>
                      </xsl:if>
                      <xsl:copy-of select="$date"/>
                    </xsl:if>
                    <xsl:if test="$date or $publishers or $pubPlaces">
                      <xsl:text>.</xsl:text>
                    </xsl:if>
                  </bibl>
                  <xsl:if test="$biblStruct/tei:ref">
                    <bibl>
                      <xsl:for-each select="$biblStruct/tei:ref">
                        <xsl:copy-of select="."/>
                        <xsl:if test="position() != last()">
                          <xsl:text>; </xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                    </bibl>
                  </xsl:if>
                  <xsl:if test="@wikidata">
                    <bibl type="wikidata">
                      <idno><xsl:value-of select="@wikidata/string()"/></idno>
                    </bibl>
                  </xsl:if>
                  <xsl:copy-of select="tei:listEvent"/>
                </sourceDesc>
              </fileDesc>
              <profileDesc>
                <xsl:copy-of select="tei:particDesc"/>
                <xsl:if test="@textclass">
                  <textClass>
                    <xsl:choose>
                      <xsl:when test="@textclass eq 'Q1050848'">
                        <xsl:comment>satyr play</xsl:comment>
                      </xsl:when>
                      <xsl:when test="@textclass eq 'Q40831'">
                        <xsl:comment>comedy</xsl:comment>
                      </xsl:when>
                      <xsl:when test="@textclass eq 'Q80930'">
                        <xsl:comment>tragedy</xsl:comment>
                      </xsl:when>
                    </xsl:choose>
                    <classCode scheme="http://www.wikidata.org/entity/">
                      <xsl:value-of select="string(@textclass)"/>
                    </classCode>
                  </textClass>
                </xsl:if>
              </profileDesc>
              <revisionDesc>
                <change when="{format-date(current-date(), '[Y0001]-[M01]-[D01]')}">Transformed into DraCor TEI</change>
                <xsl:copy-of select="$src//tei:revisionDesc/tei:change"/>
              </revisionDesc>
            </teiHeader>
            <xsl:apply-templates select="$src//tei:text" mode="text">
              <xsl:with-param name="particDesc" select="tei:particDesc"
                tunnel="yes"/>
            </xsl:apply-templates>
          </TEI>
        </xsl:result-document>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Perseus source not found for slug "<xsl:value-of
          select="@slug"/>" at <xsl:value-of select="$src-path"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()" mode="text">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="text"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:l[@style='hidden' and not(node())]" mode="text"/>

  <xsl:template match="tei:sp" mode="text">
    <xsl:param name="particDesc" tunnel="yes"/>
    <xsl:variable name="speaker"
      select="normalize-unicode(normalize-space(tei:speaker))"/>
    <xsl:variable name="ids" select="
      $particDesc//*[self::tei:person or self::tei:personGrp][
        (tei:persName | tei:name)[
          normalize-unicode(normalize-space(.)) = $speaker
        ]
      ]/@xml:id"/>
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$ids">
          <xsl:apply-templates select="@* except @who" mode="text"/>
          <xsl:attribute name="who" select="
            string-join(for $i in $ids return concat('#', $i), ' ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*" mode="text"/>
          <xsl:if test="tei:speaker">
            <xsl:message>No particDesc match for speaker "<xsl:value-of
              select="$speaker"/>"</xsl:message>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="text"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
