From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v4 2/3] libmultipath: move
	filter_property|devnode() from path_discover() into pathinfo()
Date: Wed, 14 Dec 2016 11:05:30 -0200
Message-ID: <1481720731-22503-3-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1481720731-22503-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1481720731-22503-1-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, bmarzins@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de
List-Id: dm-devel.ids

The udev property blacklisting is ignored on 'add' uevents
because uev_add_path() calls pathinfo() directly - but the
filter_property() check is only performed in path_discover().

So, move the call out from path_discover() into pathinfo().
While in there, do that for filter_devnode() too.

Since path_discover() always calls pathinfo() to return,
either directly or via store_pathinfo(), the change is
equivalent for callers of path_discover(), which turns
out to be only path_discovery().

Interestingly, multipathd calls path_discovery() without
DI_BLACKLIST and then calls filter_path() to remove paths.
Thus, in order to guarantee equivalency (and prevent lots
of more debug messages for discovery of devices that will
be removed afterward), perform filter_property|devnode()
without checking for DI_BLACKLIST; and make sure that
filter_path() checks filter_property() (it already checks
filter_devnode()).

Test-case:

  # cat /etc/multipath.conf
  blacklist {
      property "ID_SERIAL"
  }

  # multipathd -d -s -v3 &
  ...
  sdb: udev property ID_SERIAL blacklisted
  ...

  # echo add > /sys/block/sdb/uevent

Before:

  uevent 'add' from '/devices/.../block/sdb'
  Forwarding 1 uevents
  sdb: add path (uevent)
  ...
  0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1: load table [0 4194304 multipath 1
  retain_attached_hw_handler 0 1 1 service-time 0 1 1 8:16 1]
  ...
  sdb [8:16]: path added to devmap 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1

After:

  uevent 'add' from '/devices/.../block/sdb'
  Forwarding 1 uevents
  sdb: add path (uevent)
  sdb: udev property ID_SERIAL blacklisted

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Reported-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/blacklist.c |  4 ++++
 libmultipath/discovery.c | 21 ++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 676225f9c2e0..36af28213212 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -327,6 +327,10 @@ _filter_path (struct config * conf, struct path * pp)
 {
 	int r;
 
+	r = filter_property(conf, pp->udev);
+	if (r > 0)
+		return r;
+
 	r = _filter_devnode(conf->blist_devnode, conf->elist_devnode,pp->dev);
 	if (r > 0)
 		return r;
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3c5c808436b2..d1aec31ea0f8 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -117,13 +117,6 @@ path_discover (vector pathvec, struct config * conf,
 	if (!devname)
 		return PATHINFO_FAILED;
 
-	if (filter_property(conf, udevice) > 0)
-		return PATHINFO_SKIPPED;
-
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   (char *)devname) > 0)
-		return PATHINFO_SKIPPED;
-
 	pp = find_path_by_dev(pathvec, (char *)devname);
 	if (!pp) {
 		return store_pathinfo(pathvec, conf,
@@ -1745,6 +1738,20 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	if (!pp)
 		return PATHINFO_FAILED;
 
+	/*
+	 * For behavior backward-compatibility with multipathd,
+	 * the blacklisting by filter_property|devnode() is not
+	 * limited by DI_BLACKLIST and occurs before this debug
+	 * message with the mask value.
+	 */
+	if (pp->udev && filter_property(conf, pp->udev) > 0)
+		return PATHINFO_SKIPPED;
+
+	if (filter_devnode(conf->blist_devnode,
+			   conf->elist_devnode,
+			   pp->dev) > 0)
+		return PATHINFO_SKIPPED;
+
 	condlog(3, "%s: mask = 0x%x", pp->dev, mask);
 
 	/*
-- 
1.8.3.1
