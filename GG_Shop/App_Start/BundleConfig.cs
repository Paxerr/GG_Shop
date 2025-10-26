using System.Web.Optimization;

public class BundleConfig
{
    public static void RegisterBundles(BundleCollection bundles)
    {
        // CSS Bundle
        bundles.Add(new StyleBundle("~/Content/css").Include(
            "~/Content/css/bootstrap.min.css",
            "~/Content/css/font-awesome.min.css",
            "~/Content/css/elegant-icons.css",
            "~/Content/css/nice-select.css",
            "~/Content/css/owl.carousel.min.css",
            "~/Content/css/style.css"));

        // JS Bundle
        bundles.Add(new ScriptBundle("~/bundles/malefashion").Include(
            "~/Scripts/jquery-3.3.1.min.js",
            "~/Scripts/bootstrap.min.js",
            "~/Scripts/jquery.nice-select.min.js",
            "~/Scripts/owl.carousel.min.js",
            "~/Scripts/main.js"));
    }
}
