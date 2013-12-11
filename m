From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 01/16] Add multipath path format wildcard
Date: Wed, 11 Dec 2013 00:42:55 -0600
Message-ID: <1386744190-1295-2-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This adds a new format wildcard, 'm', to be used with

multipathd show paths format

It prints the multipath device associated with the path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7feeb26..3c526c2 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -426,6 +426,16 @@ snprint_path_serial (char * buff, size_t len, struct path * pp)
 }
 
 static int
+snprint_path_mpp (char * buff, size_t len, struct path * pp)
+{
+	if (!pp->mpp)
+		return snprintf(buff, len, "[orphan]");
+	if (!pp->mpp->alias)
+		return snprintf(buff, len, "[unknown]");
+	return snprint_str(buff, len, pp->mpp->alias);
+}
+
+static int
 snprint_path_checker (char * buff, size_t len, struct path * pp)
 {
 	struct checker * c = &pp->checker;
@@ -468,6 +478,7 @@ struct path_data pd[] = {
 	{'p', "pri",           0, snprint_pri},
 	{'S', "size",          0, snprint_path_size},
 	{'z', "serial",        0, snprint_path_serial},
+	{'m', "multipath",     0, snprint_path_mpp},
 	{0, NULL, 0 , NULL}
 };
 
-- 
1.8.4.2
