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

<xsl:template match="ns1:sources/ns1:source" >
    <xsl:param name="viafID"/>
<row>
    <viafID ct="character"><xsl:value-of select="$viafID" /></viafID>
    <nsid ct="character"><xsl:value-of select="@nsid" /></nsid>
    <sparse ct="logical"><xsl:value-of select="@sparse" /></sparse>
    <s ct="character"><xsl:value-of select="substring-before(., '|')" /></s>
    <sid ct="character"><xsl:value-of select="." /></sid>
    <viaf-update ct="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
    <accessed ct="POSIXct"><xsl:value-of select="$now" /></accessed>
</row>
</xsl:template>

<xsl:template match="ns1:VIAFCluster">
<xsl:variable name="viafID" select="ns1:viafID" />
<sources>
    <xsl:attribute name="viafid"><xsl:value-of select="$viafID" /></xsl:attribute>
    <xsl:attribute name="viafrVersion"><xsl:value-of select="$viafrversion" /></xsl:attribute>
    <xsl:attribute name="processDate"><xsl:value-of select="$now" /></xsl:attribute>
    <xsl:apply-templates select="ns1:sources/ns1:source">
        <xsl:with-param name="viafID" select="$viafID" />
    </xsl:apply-templates>
</sources>
</xsl:template>

</xsl:stylesheet>