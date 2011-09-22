function init()
{
    var xmlData = XmlDocument("cdcatalog.xml");
    var xslDoc = xslProcessor("http://www.w3schools.com/xsl/cdcatalog.xsl", "http://www.w3schools.com/xsl/cdcatalog.xml", "output");
    var out = document.getElementById("output");
    out.appendChild(xslDoc);
}

function XmlDocument(xml) 
{
    var xmlDoc;
    if (window.ActiveXObject)
    {
        xmlDoc = new ActiveXObject("Msxml2.DOMDocument.3.0");
    }
    else if (document.implementation && document.implementation.createDocument)
    {
        xmlDoc = document.implementation.createDocument("","",null);
    }
    else
    {
        return false;
    }
    //xmlDoc.async=false;
    xmlDoc.load(xml);
    return xmlDoc;
}
function xslProcessor(xsl, xml, parentId)
{
    var xslDoc = (typeof xsl != String) ? XmlDocument(xsl) : xsl;
    var xmlDoc = (typeof xml != String) ? XmlDocument(xml) : xml;
    var parentElm = document.getElementById(parentId);
    
    var xsltProcessor;
    if (window.ActiveXObject)
    {  
        /*
        var xslTemplate = new ActiveXObject("Msxml2.XSLTemplate.3.0");
        var xsltDoc = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.3.0");
        xsltDoc.async=false;
        xsltDoc.load(xsl);
        xslTemplate.stylesheet = xsltDoc;
        xslProcessor = xslTemplate.createProcessor();
        xsltProcessor.input = xmlDoc;
        xsltProcessor.transform();
        if(parentElm){parentElm.innerHTML=xsltProcessor.output;}        
        */
        var output = xmlDoc.transformNode(xslDoc);
        if(parentElm){parentElm.innerHTML=output;}        
    }
    else if (document.implementation && document.implementation.createDocument)
    {
        xsltProcessor=new XSLTProcessor();
        xsltProcessor.importStylesheet(xslDoc);
        var output = xsltProcessor.transformToFragment(xmlDoc,document);
        if(parentElm){parentElm.appendChild(output);}
    }
} 
init();