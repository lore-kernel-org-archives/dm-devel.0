From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/2] multipathd: add failures path format wildcard
Date: Tue, 24 Apr 2018 15:15:30 -0500
Message-ID: <1524600931-14920-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

multipath already tracks this, so it should be able to print it out.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index d532994..b1844c9 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -632,6 +632,12 @@ snprint_path_foreign (char * buff, size_t len, const struct path * pp)
 	return snprintf(buff, len, "%s", "--");
 }
 
+static int
+snprint_path_failures(char * buff, size_t len, const struct path * pp)
+{
+	return snprint_int(buff, len, pp->failcount);
+}
+
 struct multipath_data mpd[] = {
 	{'n', "name",          0, snprint_name},
 	{'w', "uuid",          0, snprint_multipath_uuid},
@@ -680,6 +686,7 @@ struct path_data pd[] = {
 	{'r', "target WWPN",   0, snprint_tgt_wwpn},
 	{'a', "host adapter",  0, snprint_host_adapter},
 	{'G', "foreign",       0, snprint_path_foreign},
+	{'0', "failures",      0, snprint_path_failures},
 	{0, NULL, 0 , NULL}
 };
 
-- 
2.7.4
