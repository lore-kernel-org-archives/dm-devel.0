From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] [RFC] switch DM tables to readonly automatically
Date: Fri, 25 Apr 2008 16:32:37 +0200
Message-ID: <4811EB85.8090505@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000607020402030605090801"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.
--------------000607020402030605090801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi all,

this patch switches the device-mapper table to read-only
status automatically if one underlying device returns -EROFS.

Rationale:
Whenever a SCSI device is switched to read-only a table
reload from multipath-tools fails, without any indication
about the reason. And it's actually quite tricky to detect
the read-only status from userland. And quite pointless, too,
as the kernel already knows about it.

And we now can create tables for CD-ROMs, too, without
having to use the '-r' flag to dmsetup ...

Christophe, this might also fix your problem.

As usual, comments etc are welcome.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------000607020402030605090801
Content-Type: text/plain;
 name="dm-table-switch-to-readonly"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-table-switch-to-readonly"

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e75b143..f615e85 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -501,11 +501,19 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
 		dd->mode = mode;
 		dd->bdev = NULL;
 
-		if ((r = open_dev(dd, dev, t->md))) {
+		r = open_dev(dd, dev, t->md);
+		if (r == -EROFS) {
+			dd->mode &= ~FMODE_WRITE;
+			r = open_dev(dd, dev, t->md);
+		}
+		if (r) {
 			kfree(dd);
 			return r;
 		}
 
+		if (dd->mode != mode)
+			t->mode = dd->mode;
+
 		format_dev_t(dd->name, dev);
 
 		atomic_set(&dd->count, 0);

--------------000607020402030605090801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000607020402030605090801--
