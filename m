From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: Make sure we store all the hwentry
	attributes.
Date: Wed, 23 May 2012 15:29:05 -0500
Message-ID: <20120523202905.GE9924@ether.msp.redhat.com>
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

Not all of the attributes from the hardware table entries were getting stored
when the built-in devices configurations were being setup.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: multipath-tools-120518/libmultipath/config.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/config.c
+++ multipath-tools-120518/libmultipath/config.c
@@ -379,6 +379,10 @@ store_hwe (vector hwtable, struct hwentr
 	hwe->no_path_retry = dhwe->no_path_retry;
 	hwe->minio = dhwe->minio;
 	hwe->minio_rq = dhwe->minio_rq;
+	hwe->pg_timeout = dhwe->pg_timeout;
+	hwe->flush_on_last_del = dhwe->flush_on_last_del;
+	hwe->fast_io_fail = dhwe->fast_io_fail;
+	hwe->dev_loss = dhwe->dev_loss;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
