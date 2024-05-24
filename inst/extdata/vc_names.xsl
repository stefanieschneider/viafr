<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:vt="http://viaf.org/viaf/terms#"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:void="http://rdfs.org/ns/void#"
            xmlns:ns1="http://viaf.org/viaf/terms#"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
           xmlns:fn = "http://www.w3.org/2005/xpath-functions"
           exclude-result-prefixes="vt foaf owl rdf void ns1 xs"
version="1.0" type="text" >

<xsl:output method="xml" encoding="UTF-8" />

<xsl:param name="viafrversion" />
<xsl:param name="now" />
<xsl:variable name="viafUpdate" select="/ns1:VIAFCluster/ns1:creationtime" />

<xsl:template match="ns1:VIAFCluster">
<xsl:variable name="viafID" select="ns1:viafID" />
<xsl:variable name="viafType" select="ns1:nameType" />
<names>
    <xsl:attribute name="viafid"><xsl:value-of select="$viafID" /></xsl:attribute>
    <xsl:attribute name="viafrVersion"><xsl:value-of select="$viafrversion" /></xsl:attribute>
    <xsl:attribute name="processDate"><xsl:value-of select="$now" /></xsl:attribute>
    <xsl:apply-templates select="ns1:mainHeadings/ns1:mainHeadingEl">
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="'TRUE'" />
    </xsl:apply-templates>
    <xsl:apply-templates select="ns1:x400s/ns1:x400">
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="'FALSE'" />
    </xsl:apply-templates>
</names>
</xsl:template>

<xsl:template match="ns1:x400s/ns1:x400">
    <xsl:param name="viafID"/>
    <xsl:param name="viafType" />
    <xsl:param name="preferred"/>
    <xsl:variable name="dispName" >
        <xsl:apply-templates select="ns1:datafield" mode="naming"/>
    </xsl:variable>
    <xsl:variable name="normName" >
        <xsl:choose>
            <xsl:when test="ns1:datafield/ns1:normalized" >
                <xsl:value-of select="ns1:datafield/ns1:normalized" />
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tag" >
        <xsl:value-of select="ns1:datafield/@tag" />
    </xsl:variable>
    <xsl:variable name="linkcount" ><xsl:value-of select="count(ns1:links/ns1:link)" /></xsl:variable>
    <xsl:apply-templates select="ns1:sources/ns1:s" mode="naming" >
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="$preferred" />
        <xsl:with-param name="tag" select="$tag" />
        <xsl:with-param name="viafUpdate" select="$viafUpdate" />
        <xsl:with-param name="normName" select="$normName" />
        <xsl:with-param name="dispName" select="$dispName" />
        <xsl:with-param name="linkcount" select="$linkcount" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ns1:mainHeadings/ns1:mainHeadingEl">
    <xsl:param name="viafID"/>
    <xsl:param name="viafType" />
    <xsl:param name="preferred"/>
    <xsl:variable name="dispName" >
        <xsl:apply-templates select="ns1:datafield" mode="naming"/>
    </xsl:variable>
    <xsl:variable name="normName" >
        <xsl:choose>
            <xsl:when test="ns1:datafield/ns1:normalized" >
                <xsl:value-of select="ns1:datafield/ns1:normalized" />
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tag" >
        <xsl:value-of select="ns1:datafield/@tag" />
    </xsl:variable>
    <xsl:variable name="linkcount" ><xsl:value-of select="count(ns1:links/ns1:link)" /></xsl:variable>
    <xsl:apply-templates select="ns1:sources/ns1:s" mode="naming" >
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="$preferred" />
        <xsl:with-param name="tag" select="$tag" />
        <xsl:with-param name="viafUpdate" select="$viafUpdate" />
        <xsl:with-param name="normName" select="$normName" />
        <xsl:with-param name="dispName" select="$dispName" />
        <xsl:with-param name="linkcount" select="$linkcount" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ns1:sources/ns1:s" mode="naming" >
        <xsl:param name="viafID" />
        <xsl:param name="viafType" />
        <xsl:param name="preferred" />
        <xsl:param name="tag"  />
        <xsl:param name="viafUpdate" />
        <xsl:param name="normName" />
        <xsl:param name="dispName" />
        <xsl:param name="linkcount" />
        <xsl:variable name="src"><xsl:value-of select="." /></xsl:variable>
    <row>
    <viafID ct="character"><xsl:value-of select="$viafID" /></viafID>
    <viafType ct="character"><xsl:value-of select="$viafType" /></viafType>
    <preferred ct="logical"><xsl:value-of select="$preferred" /></preferred>
    <tag ct="character"><xsl:value-of select="$tag" /></tag>
    <normName ct="character">
        <xsl:choose>
            <xsl:when test="string-length($normName) = 0" >
                <xsl:attribute name="postnm">TRUE</xsl:attribute>
                <xsl:attribute name="src"><xsl:value-of select="$src" /></xsl:attribute>
                <xsl:value-of select="$dispName" />
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$normName" /></xsl:otherwise>
        </xsl:choose>
    </normName>
    <dispName ct="character"><xsl:value-of select="$dispName" /></dispName>
    <source ct="character"><xsl:value-of select="$src" /></source>
    <linkcount ct="integer"><xsl:value-of select="$linkcount" /></linkcount>
    <viaf-update ct="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
    <accessed ct="POSIXct"><xsl:value-of select="$now" /></accessed>
    </row>
</xsl:template>

<xsl:template match="ns1:datafield[@dtype='MARC21' and @tag='100']" mode="naming" >
    <xsl:apply-templates select="ns1:subfield" >
        <xsl:sort select="@code" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ns1:datafield[@dtype='MARC21' and @tag='400']" mode="naming" >
    <xsl:apply-templates select="ns1:subfield" >
        <xsl:sort select="@code" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ns1:datafield[@dtype='UNIMARC' and @tag='200']" mode="naming" >
    <xsl:apply-templates select="ns1:subfield" >
        <xsl:sort select="@code" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ns1:subfield[@code='a']" ><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns1:subfield[@code='b']" ><xsl:text>, </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns1:subfield[@code='c']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns1:subfield[@code='d']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns1:subfield[@code='f']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns1:subfield[@code='q']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns1:subfield[@code='7']" />
<xsl:template match="ns1:subfield[@code='8']" />
<xsl:template match="ns1:subfield[@code='9']" />

</xsl:stylesheet>
