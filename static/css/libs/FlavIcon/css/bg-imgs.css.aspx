<%@ Page Language="C#" ContentType="text/css" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
    public int width = 64;

    protected void Page_Load(object sender, EventArgs e)
    {
        string plate = ".ico.fi-{0}, .ico.{0}{{background-image:url('//faculty.chemeketa.edu/ljohns10/online/static/img/flavicons/{0}.png');}}";
        string output = "";

        DirectoryInfo dir = new DirectoryInfo(Server.MapPath("../../../img/flavicons"));
        foreach (FileInfo f in dir.GetFiles("*.png"))
        {
            //Pop template
            output += String.Format(plate, f.Name.Replace(".png", ""));

        }
        Response.Write(output);
    }
</script>

