From: Lars Marowsky-Bree <lmb@suse.de>
Subject: [patch] handle reada errors
Date: Fri, 21 Jan 2005 18:26:14 +0100
Message-ID: <20050121172614.GR25714@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Silently ignore 'errors' for read ahead bios. They can fail in
__make_request with a EWOULDBLOCK. 

Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>

Index: linux-2.6.5/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.5.orig/drivers/md/dm-mpath.c	2005-01-19 14:41:17.000000000 +0100
+++ linux-2.6.5/drivers/md/dm-mpath.c	2005-01-21 18:23:07.053071996 +0100
@@ -962,7 +975,9 @@ static int do_end_io(struct multipath *m
 	struct hw_handler *hwh = &m->hw_handler;
 	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 
-	if (!error)
+	/* Silently drop reada errors, since they don't indicate real IO
+	 * errors */
+	if (!error || bio_rw_ahead(bio))
 		return 0;	/* I/O complete */
 
 	spin_lock(&m->lock);

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
