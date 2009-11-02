From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 02/18] Export outnl and indent functions for
	modules
Date: Mon,  2 Nov 2009 15:20:06 +0100
Message-ID: <1257171622-8380-3-git-send-email-zkabelac@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-2-git-send-email-zkabelac@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Exporting functions out_inc_indent(), out_dec_indent() for creating
indented metadata lines. Macro outnl() is using out_newline()
instead of direct f->fn() that required the visibility of internal
struct formatter.

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 lib/format_text/export.c      |   18 ++++++++++++++++++
 lib/format_text/text_export.h |    6 +++++-
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/lib/format_text/export.c b/lib/format_text/export.c
index 889992b..7f7d0de 100644
--- a/lib/format_text/export.c
+++ b/lib/format_text/export.c
@@ -235,6 +235,24 @@ static int _sectors_to_units(uint64_t sectors, char *buffer, size_t s)
 	return dm_snprintf(buffer, s, "# %g %s", d, _units[i]) > 0;
 }
 
+/* increment indention level */
+void out_inc_indent(struct formatter *f)
+{
+	_inc_indent(f);
+}
+
+/* decrement indention level */
+void out_dec_indent(struct formatter *f)
+{
+	_dec_indent(f);
+}
+
+/* insert new line */
+int out_newline(struct formatter *f)
+{
+	return f->nl(f);
+}
+
 /*
  * Appends a comment giving a size in more easily
  * readable form (eg, 4M instead of 8096).
diff --git a/lib/format_text/text_export.h b/lib/format_text/text_export.h
index 1cd42a9..cdba82f 100644
--- a/lib/format_text/text_export.h
+++ b/lib/format_text/text_export.h
@@ -17,7 +17,7 @@
 #define _LVM_TEXT_EXPORT_H
 
 #define outf(args...) do {if (!out_text(args)) return_0;} while (0)
-#define outnl(f) do {if (!f->nl(f)) return_0;} while (0)
+#define outnl(f) do {if (!out_newline(f)) return_0;} while (0)
 
 struct formatter;
 struct lv_segment;
@@ -37,4 +37,8 @@ int out_config_node(struct formatter *f, const struct config_node *cn);
 int out_areas(struct formatter *f, const struct lv_segment *seg,
 	      const char *type);
 
+void out_inc_indent(struct formatter *f);
+void out_dec_indent(struct formatter *f);
+int out_newline(struct formatter *f);
+
 #endif
-- 
1.6.5.1
