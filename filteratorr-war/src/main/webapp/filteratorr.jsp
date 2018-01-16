<%@ page contentType="text/html;charset=UTF-8" language="java" %><%
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><%@ page import="
    java.io.ByteArrayInputStream,
    java.io.PrintWriter,
    java.io.Writer,
    org.apache.jackrabbit.vault.fs.config.DefaultWorkspaceFilter, org.apache.commons.lang3.StringEscapeUtils" %><%
%><%!
    private void printColored(Writer out, boolean good, String goodMsg, String badMsg) {
        String msg = good ? goodMsg : badMsg;
        String cls = good ? "valid" : "error";
        PrintWriter w = new PrintWriter(out);
        w.printf("<span class=\"%s\">%s</span>", cls, msg);
    }

    private String def(String str, String def) {
        if (str == null) {
            return def;
        }
        return str;
    }

    private static class Example {
        private final String name;
        private final String filter;
        private final String path;

        public Example(String name, String path, String filter) {
            this.name = StringEscapeUtils.escapeHtml4(name);
            this.filter = StringEscapeUtils.escapeHtml4(filter);
            this.path = StringEscapeUtils.escapeHtml4(path);
        }

        private void print(Writer out) {
            PrintWriter w = new PrintWriter(out);
            w.printf("<form class=\"example\" method=\"POST\">");
            w.printf("<input type=\"hidden\" name=\"filter\" value=\"%s\">", filter);
            w.printf("<input type=\"hidden\" name=\"path\" value=\"%s\">", path);
            w.printf("<input type=\"submit\" name=\"submit\" value=\"%s\">", name);
            w.printf("</form>");
        }
    }

    private static final Example[] EXAMPLES = new Example[]{
            new Example("empty", "/",
                    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                            "<workspaceFilter version=\"1.0\">\n" +
                            "</workspaceFilter>\n"),
            new Example("all", "/foo/bar",
                    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                            "<workspaceFilter version=\"1.0\">\n" +
                            "  <filter root=\"/\" />\n" +
                            "</workspaceFilter>\n"),
            new Example("include", "/tmp/bar",
                    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                            "<workspaceFilter version=\"1.0\">\n" +
                            "\n" +
                            "  <filter root=\"/tmp\">\n" +
                            "    <!-- the first pattern is an include, so the default is exclude -->\n" +
                            "    <include pattern=\"/tmp/foo\" />\n" +
                            "  </filter>\n" +
                            "</workspaceFilter>"),
            new Example("exclude", "/tmp/bar",
                    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                            "<workspaceFilter version=\"1.0\">\n" +
                            "\n" +
                            "  <filter root=\"/tmp\">\n" +
                            "    <!-- the first pattern is an exclude, so the default is include -->\n" +
                            "    <exclude pattern=\"/tmp/foo\" />\n" +
                            "  </filter>\n" +
                            "</workspaceFilter>\n"),
            new Example("subtree", "/tmp/foo/subnode",
                    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                            "<workspaceFilter version=\"1.0\">\n" +
                            "\n" +
                            "  <filter root=\"/tmp\">\n" +
                            "    <!-- include node and subtree -->\n" +
                            "    <include pattern=\"/tmp/foo(/.*)?\" />\n" +
                            "  </filter>\n" +
                            "</workspaceFilter>\n")
    };

%><%
    final String filterStr = def(request.getParameter("filter"), EXAMPLES[0].filter);
    final String path = def(request.getParameter("path"), EXAMPLES[0].path);
%><html>
<head>
    <title>filteratorr</title>
    <link type="text/css" rel="stylesheet" href="github-markdown.css" />
    <link type="text/css" rel="stylesheet" href="stylish.css" />
</head>

<body>
<article class="markdown-body">

    <h2>Filteratorr&trade;</h2>
    Validate and test <a href="jackrabbit.apache.org/filevault/">filevault</a> filter. Enter the filter and path below or, try out some
    examples: <br><% for (Example e: EXAMPLES) { e.print(out);}%>

    <h2>Filter</h2>
    <form method="POST">
        <textarea name="filter" rows="20"><%= filterStr %></textarea>
        <br>
        <b>Test path</b><br>
        <input class="input-path" name="path" value="<%= path %>">
        <br>
        <input type="submit" value="Validate">
    </form>

    <h2>Result</h2>
        <%
            DefaultWorkspaceFilter filter = new DefaultWorkspaceFilter();
            Exception error = null;
            try {
                filter.load(new ByteArrayInputStream(filterStr.getBytes("utf-8")));
            } catch (Exception e) {
                error = e;
            }

            if (error == null) {
                %>
                <div class="filter-result">
                    <b>Filter</b>: <span class="valid">valid</span><br>
                    <b>Path</b>: <code><%= path %></code><br>
                    <b>Covered</b>: <% printColored(out, filter.covers(path), "true", "false"); %><br>
                    <b>Contains</b>: <% printColored(out, filter.contains(path), "true", "false"); %><br>
                    <b>Import Mode</b>: <%= filter.getImportMode(path).name() %><br>

                </div>
                <%
            } else {
                %>
                <div class="filter-result">
                    <b>Filter</b>: <span class="error">error: <%= error.getMessage()%></span>
                </div>
                <%
            }
        %>

    <footer>
        <a href="https://github.com/tripodsan/filteratorr">Code on github</a>
    </footer>

</article>
</body>
</html>