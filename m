From: Volker Sameske <sameske@de.ibm.com>
Subject: [PATCH] mp-tools: multipathd product blacklisted message
Date: Tue, 9 Jan 2007 17:49:14 +0100
Message-ID: <20070109174914.58215fbb.sameske@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

mp-tools: multipathd product blacklisted message

Signed-off-by: Volker Sameske <sameske@de.ibm.com>
---

A simple patch which just changes a single multipathd debug message. 
I just added the block device name, similar to the devnode and wwid 
messages which already start with the blockdev name.
Now it should be more clear where a device is blacklisted.

old:
Jan 09 11:10:47 | IBM:S/390 DASD ECKD: blacklisted
Jan 09 11:10:47 | IBM:S/390 DASD ECKD: blacklisted
new:
Jan 09 17:15:53 | dasda: (IBM:S/390 DASD ECKD) blacklisted by product
Jan 09 17:15:53 | dasdb: (IBM:S/390 DASD ECKD) blacklisted by product

diff -Nurp --exclude='*~' multipath-tools-0.4.7.latest-20070108/libmultipath/blacklist.c multipath-tools-0.4.7.latest-20070109/libmultipath/blacklist.c
--- multipath-tools-0.4.7.latest-20070108/libmultipath/blacklist.c	2007-01-08 16:12:18.000000000 +0100
+++ multipath-tools-0.4.7.latest-20070109/libmultipath/blacklist.c	2007-01-09 17:12:16.000000000 +0100
@@ -174,7 +174,7 @@ blacklist (vector blist, vector elist, c
 }
 
 int
-blacklist_device (vector blist, char * vendor, char * product)
+blacklist_device (vector blist, char * str, char * vendor, char * product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -182,7 +182,8 @@ blacklist_device (vector blist, char * v
 	vector_foreach_slot (blist, ble, i) {
 		if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
 		    !regexec(&ble->product_reg, product, 0, NULL, 0)) {
-			condlog(3, "%s:%s: blacklisted", vendor, product);
+			condlog(3, "%s: (%s:%s) blacklisted by product", 
+				str, vendor, product);
 			return 1;
 		}
 	}
@@ -199,7 +200,8 @@ blacklist_path (struct config * conf, st
 		return 1;
 
 	if (pp->vendor_id && pp->product_id &&
-	    blacklist_device(conf->blist_device, pp->vendor_id, pp->product_id))
+	    blacklist_device(conf->blist_device, pp->dev, 
+			     pp->vendor_id, pp->product_id))
 		return 1;
 
 	return 0;
diff -Nurp --exclude='*~' multipath-tools-0.4.7.latest-20070108/libmultipath/blacklist.h multipath-tools-0.4.7.latest-20070109/libmultipath/blacklist.h
--- multipath-tools-0.4.7.latest-20070108/libmultipath/blacklist.h	2007-01-08 16:12:18.000000000 +0100
+++ multipath-tools-0.4.7.latest-20070109/libmultipath/blacklist.h	2007-01-09 17:12:37.000000000 +0100
@@ -20,7 +20,7 @@ struct blentry_device {
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
 int blacklist (vector, vector, char *);
-int blacklist_device (vector, char *, char *);
+int blacklist_device (vector, char *, char *, char *);
 int blacklist_path (struct config *, struct path *);
 int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
