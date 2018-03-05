From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/23] libmultipath: print: use generic API
	for get_x_layout()
Date: Tue,  6 Mar 2018 00:14:58 +0100
Message-ID: <20180305231507.10386-15-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Introduce new functions _get_path_layout and _get_multipath_layout
using the new "generic" API to determine field widths, and map the
old API to them.

Furthermore, replace the boolean "header" by an enum with 3 possible
values. The new value LAYOUT_RESET_NOT allows calling the get_x_layout
function several times and determine the overall field width.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 73 ++++++++++++++++++++++++++++++++++++++++------------
 libmultipath/print.h |  8 ++++++
 2 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 8701a3584859..01e7483e3e44 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -697,20 +697,48 @@ snprint_wildcards (char * buff, int len)
 }
 
 void
-get_path_layout (vector pathvec, int header)
+get_path_layout(vector pathvec, int header)
+{
+	vector gpvec = vector_convert(NULL, pathvec, struct path,
+				      dm_path_to_gen);
+	_get_path_layout(gpvec,
+			 header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO);
+	vector_free(gpvec);
+}
+
+static void
+reset_width(int *width, enum layout_reset reset, const char *header)
+{
+	switch (reset) {
+	case LAYOUT_RESET_HEADER:
+		*width = strlen(header);
+		break;
+	case LAYOUT_RESET_ZERO:
+		*width = 0;
+		break;
+	default:
+		/* don't reset */
+		break;
+	}
+}
+
+void
+_get_path_layout (const struct _vector *gpvec, enum layout_reset reset)
 {
 	int i, j;
 	char buff[MAX_FIELD_LEN];
-	struct path * pp;
+	const struct gen_path *gp;
 
 	for (j = 0; pd[j].header; j++) {
-		if (header)
-			pd[j].width = strlen(pd[j].header);
-		else
-			pd[j].width = 0;
 
-		vector_foreach_slot (pathvec, pp, i) {
-			pd[j].snprint(buff, MAX_FIELD_LEN, pp);
+		reset_width(&pd[j].width, reset, pd[j].header);
+
+		if (gpvec == NULL)
+			continue;
+
+		vector_foreach_slot (gpvec, gp, i) {
+			gp->ops->snprint(gp, buff, MAX_FIELD_LEN,
+					 pd[j].wildcard);
 			pd[j].width = MAX(pd[j].width, strlen(buff));
 		}
 	}
@@ -726,22 +754,35 @@ reset_multipath_layout (void)
 }
 
 void
-get_multipath_layout (vector mpvec, int header)
+get_multipath_layout (vector mpvec, int header) {
+	vector gmvec = vector_convert(NULL, mpvec, struct multipath,
+				      dm_multipath_to_gen);
+	_get_multipath_layout(gmvec,
+			 header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO);
+	vector_free(gmvec);
+}
+
+void
+_get_multipath_layout (const struct _vector *gmvec,
+			    enum layout_reset reset)
 {
 	int i, j;
 	char buff[MAX_FIELD_LEN];
-	struct multipath * mpp;
+	const struct gen_multipath * gm;
 
 	for (j = 0; mpd[j].header; j++) {
-		if (header)
-			mpd[j].width = strlen(mpd[j].header);
-		else
-			mpd[j].width = 0;
 
-		vector_foreach_slot (mpvec, mpp, i) {
-			mpd[j].snprint(buff, MAX_FIELD_LEN, mpp);
+		reset_width(&mpd[j].width, reset, mpd[j].header);
+
+		if (gmvec == NULL)
+			continue;
+
+		vector_foreach_slot (gmvec, gm, i) {
+			gm->ops->snprint(gm, buff, MAX_FIELD_LEN,
+					 mpd[j].wildcard);
 			mpd[j].width = MAX(mpd[j].width, strlen(buff));
 		}
+		condlog(4, "%s: width %d", mpd[j].header, mpd[j].width);
 	}
 }
 
diff --git a/libmultipath/print.h b/libmultipath/print.h
index b8b9ecbd204f..7ba643892579 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -94,7 +94,15 @@ struct pathgroup_data {
 	int (*snprint)(char * buff, size_t len, const struct pathgroup * pgp);
 };
 
+enum layout_reset {
+	LAYOUT_RESET_NOT,
+	LAYOUT_RESET_ZERO,
+	LAYOUT_RESET_HEADER,
+};
+
+void _get_path_layout (const struct _vector *gpvec, enum layout_reset);
 void get_path_layout (vector pathvec, int header);
+void _get_multipath_layout (const struct _vector *gmvec, enum layout_reset);
 void get_multipath_layout (vector mpvec, int header);
 int snprint_path_header (char *, int, const char *);
 int snprint_multipath_header (char *, int, const char *);
-- 
2.16.1
