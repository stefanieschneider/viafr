<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:vt="http://viaf.org/viaf/terms#"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:void="http://rdfs.org/ns/void#"
            xmlns:ns1="http://viaf.org/viaf/terms#"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
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
        <xsl:with-param name="inCluster" select="'TRUE'" />
    </xsl:apply-templates>
    <xsl:apply-templates select="ns1:x400s/ns1:x400">
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="inCluster" select="'FALSE'" />
    </xsl:apply-templates>
</names>
</xsl:template>

<xsl:template match="ns1:x400s/ns1:x400">
    <xsl:param name="viafID"/>
    <xsl:param name="viafType" />
    <xsl:param name="inCluster"/>
    <xsl:variable name="namevalue" >
        <xsl:apply-templates select="ns1:datafield" />
    </xsl:variable>
    <xsl:variable name="tag" >
        <xsl:value-of select="ns1:datafield/@tag" />
    </xsl:variable>
    <row>
    <viafID class="character"><xsl:value-of select="$viafID" /></viafID>
    <viafType class="character"><xsl:value-of select="$viafType" /></viafType>
    <inCluster class="logical"><xsl:value-of select="$inCluster" /></inCluster>
    <tag class="character"><xsl:value-of select="$tag" /></tag>
    <namevalue class="character"><xsl:value-of select="$namevalue" /></namevalue>
    <source class="character"><xsl:value-of select="ns1:sources/ns1:s[1]" /></source>
    <linkcount class="integer"><xsl:value-of select="count(ns1:links/ns1:link)" /></linkcount>
    <viaf-update class="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
    </row>
</xsl:template>

<xsl:template match="ns1:mainHeadings/ns1:mainHeadingEl">
    <xsl:param name="viafID"/>
    <xsl:param name="viafType" />
    <xsl:param name="inCluster"/>
    <xsl:variable name="namevalue" >
        <xsl:apply-templates select="ns1:datafield" />
    </xsl:variable>
    <xsl:variable name="tag" >
        <xsl:value-of select="ns1:datafield/@tag" />
    </xsl:variable>
    <row>
    <viafID class="character"><xsl:value-of select="$viafID" /></viafID>
    <viafType class="character"><xsl:value-of select="$viafType" /></viafType>
    <inCluster class="logical"><xsl:value-of select="$inCluster" /></inCluster>
    <tag class="character"><xsl:value-of select="$tag" /></tag>
    <namevalue class="character"><xsl:value-of select="$namevalue" /></namevalue>
    <source class="character"><xsl:value-of select="ns1:sources/ns1:s[1]" /></source>
    <linkcount class="integer"><xsl:value-of select="count(ns1:links/ns1:link)" /></linkcount>
    <viaf-update class="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
    </row>
</xsl:template>

<xsl:template match="ns1:datafield[@dtype='MARC21' and @tag='100']" >
    <xsl:value-of select="ns1:subfield[@code='a']" />
</xsl:template>

<xsl:template match="ns1:datafield[@dtype='MARC21' and @tag='400']" >
    <xsl:value-of select="ns1:subfield[@code='a']" />
</xsl:template>

<xsl:template match="ns1:datafield[@dtype='UNIMARC' and @tag='200']" >
    <xsl:value-of select="ns1:subfield[@code='a']" />, <xsl:value-of select="ns1:subfield[@code='b']" />
</xsl:template>

</xsl:stylesheet>
