(function () {
    "use strict";

    var KEYWORDS = ["and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"];
    var BUILTINS = ["game", "workspace", "script", "Instance", "Enum", "UDim2", "UDim", "Color3", "Vector2", "Vector3", "TweenInfo", "task", "string", "table", "math", "os", "pcall", "xpcall", "loadstring", "require", "getgenv", "request", "writefile", "readfile", "isfile", "delfile", "listfiles", "makefolder", "isfolder", "print", "warn", "error", "assert", "type", "tostring", "tonumber", "pairs", "ipairs", "next", "unpack", "self"];

    function escapeHtml(s) {
        return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    function highlightLua(src) {
        var out = "";
        var i = 0;
        var n = src.length;
        while (i < n) {
            var ch = src.charAt(i);
            if (ch === "-" && src.charAt(i + 1) === "-" && src.charAt(i + 2) === "[" && src.charAt(i + 3) === "[") {
                var endB = src.indexOf("]]", i + 4);
                if (endB === -1) endB = n - 2;
                out += '<span class="hl-comment">' + escapeHtml(src.slice(i, endB + 2)) + "</span>";
                i = endB + 2;
                continue;
            }
            if (ch === "-" && src.charAt(i + 1) === "-") {
                var endL = src.indexOf("\n", i);
                if (endL === -1) endL = n;
                out += '<span class="hl-comment">' + escapeHtml(src.slice(i, endL)) + "</span>";
                i = endL;
                continue;
            }
            if (ch === '"' || ch === "'") {
                var q = ch;
                var j = i + 1;
                while (j < n) {
                    if (src.charAt(j) === "\\") { j += 2; continue; }
                    if (src.charAt(j) === q) break;
                    j++;
                }
                out += '<span class="hl-string">' + escapeHtml(src.slice(i, j + 1)) + "</span>";
                i = j + 1;
                continue;
            }
            if (/[0-9]/.test(ch)) {
                var k = i;
                while (k < n && /[0-9.xXa-fA-F]/.test(src.charAt(k))) k++;
                out += '<span class="hl-number">' + escapeHtml(src.slice(i, k)) + "</span>";
                i = k;
                continue;
            }
            if (/[a-zA-Z_]/.test(ch)) {
                var m = i;
                while (m < n && /[a-zA-Z0-9_]/.test(src.charAt(m))) m++;
                var word = src.slice(i, m);
                if (KEYWORDS.indexOf(word) !== -1) {
                    out += '<span class="hl-keyword">' + word + "</span>";
                } else if (BUILTINS.indexOf(word) !== -1) {
                    out += '<span class="hl-builtin">' + word + "</span>";
                } else {
                    var p = m;
                    while (p < n && /\s/.test(src.charAt(p))) p++;
                    if (src.charAt(p) === "(") {
                        out += '<span class="hl-func">' + word + "</span>";
                    } else {
                        out += escapeHtml(word);
                    }
                }
                i = m;
                continue;
            }
            out += escapeHtml(ch);
            i++;
        }
        return out;
    }

    function highlightAll() {
        var blocks = document.querySelectorAll(".code-block pre code");
        for (var i = 0; i < blocks.length; i++) {
            blocks[i].innerHTML = highlightLua(blocks[i].textContent);
        }
    }

    function bindCopy() {
        var btns = document.querySelectorAll(".copy-btn");
        for (var i = 0; i < btns.length; i++) {
            (function (btn) {
                btn.addEventListener("click", function () {
                    var target = document.getElementById(btn.getAttribute("data-target"));
                    if (!target) return;
                    var text = target.textContent;
                    if (navigator.clipboard && navigator.clipboard.writeText) {
                        navigator.clipboard.writeText(text).then(function () {
                            btn.textContent = "Copied";
                            btn.classList.add("copied");
                            setTimeout(function () {
                                btn.textContent = "Copy";
                                btn.classList.remove("copied");
                            }, 1400);
                        });
                    }
                });
            })(btns[i]);
        }
    }

    var pages = Array.prototype.slice.call(document.querySelectorAll(".page"));
    var navLinks = Array.prototype.slice.call(document.querySelectorAll(".nav-group a"));
    var order = navLinks.map(function (a) { return a.getAttribute("href").slice(1); });
    var titles = {};
    navLinks.forEach(function (a) { titles[a.getAttribute("href").slice(1)] = a.textContent; });
    var pager = document.getElementById("pager");

    function renderPager(id) {
        var idx = order.indexOf(id);
        var html = "";
        if (idx > 0) {
            html += '<a class="pager-card prev" href="#' + order[idx - 1] + '"><span class="pager-label">Previous</span><span class="pager-title">' + titles[order[idx - 1]] + "</span></a>";
        } else {
            html += "<span></span>";
        }
        if (idx !== -1 && idx < order.length - 1) {
            html += '<a class="pager-card next" href="#' + order[idx + 1] + '"><span class="pager-label">Next</span><span class="pager-title">' + titles[order[idx + 1]] + "</span></a>";
        }
        pager.innerHTML = html;
    }

    function navigate() {
        var hash = (location.hash || "#about").slice(1);
        var target = document.getElementById(hash);
        if (!target) { hash = "about"; target = document.getElementById("about"); }
        pages.forEach(function (p) { p.classList.toggle("active", p === target); });
        navLinks.forEach(function (a) { a.classList.toggle("active", a.getAttribute("href") === "#" + hash); });
        renderPager(hash);
        window.scrollTo(0, 0);
        document.getElementById("sidebar").classList.remove("open");
    }

    function bindSearch() {
        var input = document.getElementById("search");
        input.addEventListener("input", function () {
            var q = input.value.toLowerCase().trim();
            var groups = document.querySelectorAll(".nav-group");
            for (var g = 0; g < groups.length; g++) {
                var links = groups[g].querySelectorAll("a");
                var visible = 0;
                for (var i = 0; i < links.length; i++) {
                    var show = !q || links[i].textContent.toLowerCase().indexOf(q) !== -1;
                    links[i].style.display = show ? "" : "none";
                    if (show) visible++;
                }
                groups[g].style.display = visible ? "" : "none";
            }
        });
    }

    function bindTheme() {
        var root = document.documentElement;
        var stored = null;
        try { stored = localStorage.getItem("eazy-docs-theme"); } catch (e) {}
        if (stored === "light" || stored === "dark") root.setAttribute("data-theme", stored);
        document.getElementById("themeToggle").addEventListener("click", function () {
            var next = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
            root.setAttribute("data-theme", next);
            try { localStorage.setItem("eazy-docs-theme", next); } catch (e) {}
        });
    }

    function bindMenu() {
        var btn = document.getElementById("menuToggle");
        var sidebar = document.getElementById("sidebar");
        btn.addEventListener("click", function (e) {
            e.stopPropagation();
            sidebar.classList.toggle("open");
        });
        document.addEventListener("click", function (e) {
            if (sidebar.classList.contains("open") && !sidebar.contains(e.target) && e.target !== btn) {
                sidebar.classList.remove("open");
            }
        });
    }

     function loadShowcase() {
        var code = document.getElementById("code-showcase");
        var status = document.getElementById("showcase-status");
        var url = "https://raw.githubusercontent.com/akiradv/eazyuilib/main/example.lua";
        if (typeof fetch !== "function") {
            status.textContent = "example.lua lives at the repository root. Paste the loadstring in your executor.";
            return;
        }
        fetch(url).then(function (r) {
            if (!r.ok) throw new Error("missing");
            return r.text();
        }).then(function () {
            status.textContent = "example.lua is live in the repository. Paste the loadstring in your executor.";
        }).catch(function () {
            status.textContent = "example.lua not found yet. The loadstring below will work once it is pushed.";
        });
    }

    function init() {
        highlightAll();
        bindCopy();
        bindSearch();
        bindTheme();
        bindMenu();
        loadShowcase();
        window.addEventListener("hashchange", navigate);
        navigate();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();