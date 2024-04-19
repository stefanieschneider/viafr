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

<xsl:template match="ns1:VIAFCluster">
<xsl:variable name="viafID" select="ns1:viafID" />
<xsl:variable name="nameType" select="ns1:nameType" />
<xsl:variable name="name" select="ns1:mainHeadings[1]/ns1:data[1]/ns1:text" />
<xsl:variable name="affiliations" select="count(ns1:x500s/ns1:x500/ns1:datafield[@tag='510'])" />
<xsl:variable name="sourceCount" select="count(ns1:sources/ns1:source)" />
<xsl:variable name="gender" >
    <xsl:choose>
    <xsl:when test="ns1:fixed/ns1:gender='a'">female</xsl:when>
    <xsl:when test="ns1:fixed/ns1:gender='b'">male</xsl:when>
    <xsl:otherwise />
    </xsl:choose>
</xsl:variable>
<xsl:variable name="birthDate" select="ns1:birthDate" />
<xsl:variable name="deathDate" select="ns1:deathDate" />
<xsl:variable name="dateType" select="ns1:dateType" />
<xsl:variable name="uniqueISBNs" select="ns1:ISBNs/@unique" />
<xsl:variable name="titleCount" select="count(ns1:titles/ns1:work)" />
<xsl:variable name="coauthorsPersonal" select="count(ns1:coauthors/ns1:data[@tag='950'])" />
<xsl:variable name="coauthorsCorp" select="count(ns1:coauthors/ns1:data[@tag='951'])" />
<xsl:variable name="nationalities"><xsl:call-template name="make-list">
    <xsl:with-param name="nodes" 
        select="ns1:nationalityOfEntity/ns1:data/ns1:text[string-length(translate(.,'abcdefghijklmnopqrstuvwxyz',''))=2]" />
</xsl:call-template></xsl:variable>
<summary>
    <row>
        <viafID class="character"><xsl:value-of select="$viafID" /></viafID>
        <viafType class="character"><xsl:value-of select="$nameType" /></viafType>
        <name class="character"><xsl:value-of select="$name" /></name>
        <gender class="character"><xsl:value-of select="$gender" /></gender>
        <birthDate class="Date"><xsl:value-of select="$birthDate" /></birthDate>
        <deathDate class="Date"><xsl:value-of select="$deathDate" /></deathDate>
        <dateType class="character"><xsl:value-of select="$dateType" /></dateType>
        <nationalities class="character"><xsl:value-of select="$nationalities" /></nationalities>
        <affiliations class="integer"><xsl:value-of select="$affiliations" /></affiliations>
        <sourceCount class="integer"><xsl:value-of select="$sourceCount" /></sourceCount>
        <uniqueISBNs class="integer"><xsl:value-of select="$uniqueISBNs" /></uniqueISBNs>
        <coauthorsPersonal class="integer"><xsl:value-of select="$coauthorsPersonal" /></coauthorsPersonal>
        <coauthorsCorp class="integer"><xsl:value-of select="$coauthorsCorp" /></coauthorsCorp>
        <viaf-update class="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
    </row>
</summary>
</xsl:template>

<xsl:template name="make-list">
    <xsl:param name="nodes" />
    <xsl:for-each select="$nodes" >
    <xsl:value-of select="." />
    <xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
