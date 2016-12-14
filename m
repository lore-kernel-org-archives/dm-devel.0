From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v3 2/3] libmultipath: move filter_property() from
	path_discover() into pathinfo()
Date: Wed, 14 Dec 2016 00:02:00 -0200
Message-ID: <1481680921-6489-2-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1481680921-6489-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1481680921-6489-1-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, bmarzins@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

The udev property blacklisting is ignored on 'add' uevents
because uev_add_path() calls pathinfo() directly - but the
filter_property() check is only performed in path_discover().

So, move the call out from path_discover() into pathinfo().

Since path_discover() always calls pathinfo() to return,
either directly or via store_pathinfo(), the change is
equivalent for callers of path_discover(), which turns
out to be only path_discovery().

Interestingly, multipathd calls path_discovery() without
DI_BLACKLIST and then calls filter_path() to remove paths,
so make sure filter_path() also considers filter_property().

Test-case:

  # cat /etc/multipath.conf
  blacklist {
      property "ID_SERIAL"
  }

  # udevadm info --query=property /dev/sdb | grep ID_SERIAL=
  ID_SERIAL=0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1

  # multipathd -d -s -v3 &

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
  sdb: mask = 0x3f
  sdb: udev property ID_SERIAL blacklisted

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c | 4 ++++
 libmultipath/discovery.c | 7 ++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

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
index 3c5c808436b2..52abd4e75c89 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -117,9 +117,6 @@ path_discover (vector pathvec, struct config * conf,
 	if (!devname)
 		return PATHINFO_FAILED;
 
-	if (filter_property(conf, udevice) > 0)
-		return PATHINFO_SKIPPED;
-
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
 			   (char *)devname) > 0)
 		return PATHINFO_SKIPPED;
@@ -1747,6 +1744,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	condlog(3, "%s: mask = 0x%x", pp->dev, mask);
 
+	if (mask & DI_BLACKLIST && pp->udev)
+		if (filter_property(conf, pp->udev) > 0)
+			return PATHINFO_SKIPPED;
+
 	/*
 	 * Sanity check: we need the device number to
 	 * avoid inconsistent information in
-- 
1.8.3.1
