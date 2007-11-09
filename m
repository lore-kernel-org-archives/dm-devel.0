From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Multipath blacklist exceptions issues
Date: Thu, 8 Nov 2007 18:23:47 -0600
Message-ID: <20071109002347.GG28113@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
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
To: dm-devel@redhat.com
Cc: Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've noticed some issues with how the blacklist exceptions are currently
working.  One is an obvious bug. Multipathd is treating paths that have
blacklist exceptions the same as paths that are blacklisted. The other
is also incorrect, but I'm not exactly sure what was intended.

If I recall correctly, blacklist exceptions were originally proposed as
a solution to the problem of not being able to remove the bl_product
lines from the default device configuration, without reentering the
whole configuration for that device.  They were specifically designed so
that you could still blacklist the device by wwid and devnode rules.

That is not currently the case.

Right now if you have in your multipath.conf file

blacklist {
	wwid "*"
}

blacklist_exceptions {
	devnode "sda"
}

You will create a multipath device on top of /dev/sda. This makes it
look like exceptions are now being used as a whitelist. However, if you
have

blacklist {
        devnode "*"
}

blacklist_exceptions {
        wwid "3600d0230000000000e13955cc3757800"
}

You will not create any multipath devices.  This doesn't make any sense,
if the earlier example was supposed to create a device. The attached
patch fixes the multipathd issue, and makes blacklist exceptions work
like they originally did, which I assume is what was intended.

-Ben

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="blacklist_exceptions_fix.patch"

diff -urpN a/libmultipath/blacklist.c b/libmultipath/blacklist.c
--- a/libmultipath/blacklist.c	2007-10-01 13:23:59.000000000 -0500
+++ b/libmultipath/blacklist.c	2007-11-08 17:57:05.000000000 -0600
@@ -297,14 +297,14 @@ _filter_path (struct config * conf, stru
 	int r;
 
 	r = _filter_devnode(conf->blist_devnode, conf->elist_devnode,pp->dev);
-	if (r)
+	if (r == MATCH_WWID_BLIST)
 		return r;
 	r = _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
-	if (r)
+	if (r == MATCH_WWID_BLIST)
 		return r;
 	r = _filter_device(conf->blist_device, conf->elist_device,
 		 	   pp->vendor_id, pp->product_id);
-	if (r)
+	if (r == MATCH_WWID_BLIST)
 		return r;
 	return 0;
 }
diff -urpN a/multipathd/main.c b/multipathd/main.c
--- a/multipathd/main.c	2007-08-15 17:18:27.000000000 -0500
+++ b/multipathd/main.c	2007-11-08 17:57:05.000000000 -0600
@@ -368,7 +368,7 @@ ev_add_path (char * devname, struct vect
 		condlog(0, "%s: failed to get path uid", devname);
 		return 1; /* leave path added to pathvec */
 	}
-	if (filter_path(conf, pp)){
+	if (filter_path(conf, pp) > 0){
 		int i = find_slot(vecs->pathvec, (void *)pp);
 		if (i != -1)
 			vector_del_slot(vecs->pathvec, i);
@@ -1062,7 +1062,7 @@ configure (struct vectors * vecs, int st
 	path_discovery(vecs->pathvec, conf, DI_ALL);
 
 	vector_foreach_slot (vecs->pathvec, pp, i){
-		if (filter_path(conf, pp)){
+		if (filter_path(conf, pp) > 0){
 			vector_del_slot(vecs->pathvec, i);
 			free_path(pp);
 			i--;

--huq684BweRXVnRxX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--huq684BweRXVnRxX--
