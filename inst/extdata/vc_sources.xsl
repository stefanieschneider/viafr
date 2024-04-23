<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns="http://viaf.org/viaf/terms#"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:void="http://rdfs.org/ns/void#"
            xmlns:ns1="http://viaf.org/viaf/terms#"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
version="1.0" type="text" >

<xsl:output method="xml" encoding="UTF-8" />

<xsl:variable name="viafUpdate" select="/ns1:VIAFCluster/ns1:creationtime" />

<xsl:template match="ns1:sources/ns1:source" >
    <xsl:param name="viafID"/>
<row>
    <viafID class="character"><xsl:value-of select="$viafID" /></viafID>
    <nsid class="character"><xsl:value-of select="@nsid" /></nsid>
    <sparse class="logical"><xsl:value-of select="@sparse" /></sparse>
    <s class="character"><xsl:value-of select="substring-before(., '|')" /></s>
    <sid class="character"><xsl:value-of select="." /></sid>
    <viaf-update class="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
</row>
</xsl:template>

<xsl:template match="ns1:VIAFCluster">
<xsl:variable name="viafID" select="ns1:viafID" />
<sources>
    <xsl:apply-templates select="ns1:sources/ns1:source">
        <xsl:with-param name="viafID" select="$viafID" />
    </xsl:apply-templates>
</sources>
</xsl:template>

</xsl:stylesheet>