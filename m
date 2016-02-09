From: Todd Gill <tgill@redhat.com>
Subject: [PATCH v2 1/3] Add %g format specifier to 'multipathd
	show paths format' command
Date: Tue,  9 Feb 2016 14:49:16 -0500
Message-ID: <1455047358-18242-1-git-send-email-tgill@redhat.com>
References: <1454331207-380-1-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454331207-380-1-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Todd Gill <tgill@redhat.com>, Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

The %g specifier will print the group number of the path when used with
multipathd show paths format.

Signed-off-by: Todd Gill <tgill@redhat.com>
Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmultipath/print.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 6215d0b..c313e3e 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -293,6 +293,11 @@ snprint_path_uuid (char * buff, size_t len, struct path * pp)
 	return snprint_str(buff, len, pp->wwid);
 }
 
+static int snprint_path_groupnumber(char * buff, size_t len, struct path * pp)
+{
+	return snprint_int(buff, len, pp->pgindex);
+}
+
 static int
 snprint_hcil (char * buff, size_t len, struct path * pp)
 {
@@ -576,6 +581,7 @@ struct path_data pd[] = {
 	{'i', "hcil",          0, snprint_hcil},
 	{'d', "dev",           0, snprint_dev},
 	{'D', "dev_t",         0, snprint_dev_t},
+	{'g', "group",         0, snprint_path_groupnumber},
 	{'t', "dm_st",         0, snprint_dm_path_state},
 	{'o', "dev_st",        0, snprint_offline},
 	{'T', "chk_st",        0, snprint_chk_state},
-- 
2.5.0
