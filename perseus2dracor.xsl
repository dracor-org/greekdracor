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
                  <bibl type="originalSource">
                    <xsl:copy-of select="$src//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:author"/>
                    <xsl:copy-of select="$src//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:title"/>
                    <xsl:copy-of select="$src//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:editor"/>
                    <xsl:copy-of select="$src//tei:sourceDesc/tei:biblStruct/tei:monogr//(tei:publisher|tei:pubPlace|tei:date|tei:biblScope)"/>
                    <xsl:copy-of select="$src//tei:sourceDesc/tei:biblStruct/tei:ref"/>
                  </bibl>
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
