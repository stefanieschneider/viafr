<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet 
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:void="http://rdfs.org/ns/void#"
            xmlns:ns1="http://www.loc.gov/zing/srw/"
            xmlns:ns2="http://viaf.org/viaf/terms#"
            xmlns:ns4="http://www.loc.gov/zing/cql/xcql/"
           xmlns:xsd="http://www.w3.org/2001/XMLSchema"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
           exclude-result-prefixes="foaf owl rdf void ns1 xsi"
version="1.0" type="text" >

<xsl:output method="xml" encoding="UTF-8" />

<xsl:param name="viafrversion" />
<xsl:param name="now" />

<xsl:template match="searchRetrieveResponse" >
    <xsl:apply-templates select="ns1:records/ns1:record/ns1:recordData/ns2:VIAFCluster" />
</xsl:template>

<xsl:template match="ns1:version" />
<xsl:template match="ns1:numberOfRecords" />
<xsl:template match="ns1:resultSetIdleTime" />
<xsl:template match="ns1:recordSchema" />
<xsl:template match="ns1:recordPacking" />
<xsl:template match="ns1:recordPosition" />
<xsl:template match="ns1:extraResponseData" />
<xsl:template match="ns1:echoedSearchRetrieveRequest" />

<xsl:template match="ns2:VIAFCluster">
<xsl:variable name="viafID" select="ns2:viafID" />
<xsl:variable name="update"><xsl:value-of select="ns2:creationtime" /></xsl:variable>
<sources>
    <xsl:attribute name="viafid"><xsl:value-of select="$viafID" /></xsl:attribute>
    <xsl:attribute name="viafrVersion"><xsl:value-of select="$viafrversion" /></xsl:attribute>
    <xsl:attribute name="processDate"><xsl:value-of select="$now" /></xsl:attribute>
    <xsl:apply-templates select="ns2:sources/ns2:source">
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="update" select="$update" />
    </xsl:apply-templates>
</sources>
</xsl:template>

<xsl:template match="ns2:sources/ns2:source" >
    <xsl:param name="viafID"/>
    <xsl:param name="update"/>
<row>
    <viafID ct="character"><xsl:value-of select="$viafID" /></viafID>
    <sparse ct="logical"><xsl:value-of select="@sparse" /></sparse>
    <source ct="character"><xsl:value-of select="substring-before(., '|')" /></source>
    <sourceid ct="character"><xsl:value-of select="." /></sourceid>
    <viaf-update ct="POSIXct"><xsl:value-of select="$update" /></viaf-update>
    <accessed ct="POSIXct"><xsl:value-of select="$now" /></accessed>
</row>
</xsl:template>

</xsl:stylesheet>