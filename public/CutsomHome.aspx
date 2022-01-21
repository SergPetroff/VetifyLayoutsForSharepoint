<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ Page Language="C#" %> <%@ Register tagprefix="SharePoint"
namespace="Microsoft.SharePoint.WebControls" assembly="Microsoft.SharePoint,
Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<html dir="ltr" xmlns="http://www.w3.org/1999/xhtml">
  <head runat="server">
    <meta name="WebPartPageExpansion" content="full" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Vyelayouts</title>
    <meta http-equiv="X-UA-Compatible" content="IE=10" />
    <link
      rel="stylesheet"
      type="text/css"
      href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900"
    />

    <link
      rel="stylesheet"
      type="text/css"
      href="https://unpkg.com/vuetify@2.x/dist/vuetify.min.css"
    />

    <link
      rel="stylesheet"
      type="text/css"
      href="https://cdn.jsdelivr.net/npm/@mdi/font@latest/css/materialdesignicons.min.css"
    />

    <SharePoint:CssRegistration Name="default" runat="server" />
    <link
      rel="stylesheet"
      type="text/css"
      href="SiteAssets/VueMaster/css/app.css"
    />

    <script
      type="text/javascript"
      src="/_layouts/15/1033/initstrings.js"
    ></script>
    <script type="text/javascript" src="/_layouts/15/init.js"></script>
    <!-- <script type="text/javascript" src="/_layouts/15/msajaxbundle.js"></script> -->
    <script type="text/javascript" src="/_layouts/15/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.core.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>
  </head>

  <body>
    <div id="app"></div>
  </body>
  <!-- <SharePoint:Scriptlink runat="server" Name="~sitecollection/SiteAssets/VueMaster/main.js" Language="javascript" __designer:Preview="&lt;script type=&quot;text/javascript&quot; src=&quot;/sites/ui/siteassets/vuemaster/main.js&quot;&gt;&lt;/script&gt;
" __designer:Values="&lt;P N=&#39;Name&#39; T=&#39;~sitecollection/SiteAssets/VueMaster/main.js&#39; /&gt;&lt;P N=&#39;Language&#39; T=&#39;javascript&#39; /&gt;&lt;P N=&#39;InDesign&#39; T=&#39;False&#39; /&gt;&lt;P N=&#39;ID&#39; ID=&#39;1&#39; T=&#39;ctl01&#39; /&gt;&lt;P N=&#39;Page&#39; ID=&#39;2&#39; /&gt;&lt;P N=&#39;TemplateControl&#39; R=&#39;2&#39; /&gt;&lt;P N=&#39;AppRelativeTemplateSourceDirectory&#39; R=&#39;-1&#39; /&gt;"/> -->
  <script>
    // This function will add the vue application script the HTML's pages JavaScript's.
    function initVue() {
      console.log('init');
      // Create a empty script tag element.
      var scriptTag = document.createElement('script');

      // Assign the source for the new script tag to the vue application.
      scriptTag.src = 'SiteAssets/VueMaster/main.js';

      // Get the current loaded first script element.
      firstScriptTag = document.getElementsByTagName('script')[0];

      // Insert your new script before the current first.
      firstScriptTag.parentNode.insertBefore(scriptTag, firstScriptTag);
    }
    //console.log(document.getElementById("app"))
    // Run the initVue function immediately after the sp.js has be loaded.
    SP.SOD.executeFunc('sp.js', 'SP.ClientContext', initVue);
  </script>
</html>
