From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: make sure all the hwe attributes get
	merged
Date: Tue, 4 Oct 2011 23:13:49 -0500
Message-ID: <20111005041349.GP24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Not all of the hwe attributes were getting merged.  Also,
multipathd show config was putting an extra set of quotes around the entries
in the devices section.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c |    4 ++++
 libmultipath/print.c  |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: multipath-tools-110916/libmultipath/config.c
===================================================================
--- multipath-tools-110916.orig/libmultipath/config.c
+++ multipath-tools-110916/libmultipath/config.c
@@ -320,6 +320,10 @@ merge_hwe (struct hwentry * dst, struct
 	merge_num(no_path_retry);
 	merge_num(minio);
 	merge_num(minio_rq);
+	merge_num(pg_timeout);
+	merge_num(flush_on_last_del);
+	merge_num(fast_io_fail);
+	merge_num(dev_loss);
 
 	return 0;
 }
Index: multipath-tools-110916/libmultipath/print.c
===================================================================
--- multipath-tools-110916.orig/libmultipath/print.c
+++ multipath-tools-110916/libmultipath/print.c
@@ -860,7 +860,7 @@ snprint_hwentry (char * buff, int len, s
 	if (fwd > len)
 		return len;
 	iterate_sub_keywords(rootkw, kw, i) {
-		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k \"%v\"\n",
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
 				kw, hwe);
 		if (fwd > len)
 			return len;
