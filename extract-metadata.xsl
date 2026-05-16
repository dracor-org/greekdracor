<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:param name="tei-dir" select="'tei'"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="play[@source]">
    <xsl:variable name="path"
      select="concat(resolve-uri($tei-dir, base-uri(/)), '/', @slug, '.xml')"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="doc-available($path)">
          <xsl:copy-of select="doc($path)//tei:titleStmt"/>
          <xsl:copy-of select="doc($path)//tei:standOff/tei:listEvent"/>
          <xsl:apply-templates select="doc($path)//tei:particDesc" mode="enrich"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>No TEI file found for slug "<xsl:value-of select="@slug"/>" at <xsl:value-of select="$path"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="enrich">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="enrich"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:person | tei:personGrp" mode="enrich">
    <xsl:variable name="id" select="@xml:id"/>
    <xsl:variable name="doc" select="root(.)"/>
    <xsl:variable name="child-name"
      select="if (self::tei:person) then 'persName' else 'name'"/>
    <xsl:variable name="existing"
      select="*[local-name() = $child-name]/normalize-space(.)"/>
    <xsl:variable name="speakers" select="
      distinct-values(
        $doc//tei:sp[
          some $t in tokenize(normalize-space(@who), '\s+')
          satisfies $t = concat('#', $id)
        ]/tei:speaker/normalize-space(.)
      )"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="enrich"/>
      <xsl:for-each select="$speakers[not(. = $existing)]">
        <xsl:element name="{$child-name}" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:attribute name="type">variant</xsl:attribute>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
