From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/23] libmultipath/print: add "%G - foreign"
	wildcard
Date: Tue,  6 Mar 2018 00:15:00 +0100
Message-ID: <20180305231507.10386-17-mwilck@suse.com>
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

This adds a format field to identify foreign maps as such, and
uses it in default-formatted topology output (generic_style()).

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/generic.c |  2 +-
 libmultipath/print.c   | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/libmultipath/generic.c b/libmultipath/generic.c
index 45012d0e1d95..6f7a2cdcad3e 100644
--- a/libmultipath/generic.c
+++ b/libmultipath/generic.c
@@ -32,7 +32,7 @@ int generic_style(const struct gen_multipath* gm,
 	gm->ops->snprint(gm, alias_buf, sizeof(alias_buf), 'n');
 	gm->ops->snprint(gm, wwid_buf, sizeof(wwid_buf), 'w');
 
-	n += snprintf(buf, len, "%%n %s%%d %%s",
+	n += snprintf(buf, len, "%%n %s[%%G]:%%d %%s",
 		      strcmp(alias_buf, wwid_buf) ? "(%w) " : "");
 
 	return (n < len ? n : len - 1);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 01e7483e3e44..d5329942e795 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -341,6 +341,12 @@ snprint_multipath_rev (char * buff, size_t len, const struct multipath * mpp)
 	return snprintf(buff, len, "##");
 }
 
+static int
+snprint_multipath_foreign (char * buff, size_t len, const struct multipath * pp)
+{
+	return snprintf(buff, len, "%s", "--");
+}
+
 static int
 snprint_action (char * buff, size_t len, const struct multipath * mpp)
 {
@@ -620,6 +626,12 @@ snprint_path_checker (char * buff, size_t len, const struct path * pp)
 	return snprint_str(buff, len, c->name);
 }
 
+static int
+snprint_path_foreign (char * buff, size_t len, const struct path * pp)
+{
+	return snprintf(buff, len, "%s", "--");
+}
+
 struct multipath_data mpd[] = {
 	{'n', "name",          0, snprint_name},
 	{'w', "uuid",          0, snprint_multipath_uuid},
@@ -643,6 +655,7 @@ struct multipath_data mpd[] = {
 	{'v', "vend",          0, snprint_multipath_vend},
 	{'p', "prod",          0, snprint_multipath_prod},
 	{'e', "rev",           0, snprint_multipath_rev},
+	{'G', "foreign",       0, snprint_multipath_foreign},
 	{0, NULL, 0 , NULL}
 };
 
@@ -666,6 +679,7 @@ struct path_data pd[] = {
 	{'R', "host WWPN",     0, snprint_host_wwpn},
 	{'r', "target WWPN",   0, snprint_tgt_wwpn},
 	{'a', "host adapter",  0, snprint_host_adapter},
+	{'G', "foreign",       0, snprint_path_foreign},
 	{0, NULL, 0 , NULL}
 };
 
-- 
2.16.1
