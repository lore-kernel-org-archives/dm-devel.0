From: "David Guyon Martin" <david.guyonmartin@gmail.com>
Subject: New dm filters and patch format for kernel config
Date: Thu, 12 Oct 2006 10:49:45 +0200
Message-ID: <2c53b31c0610120149r577bd90cy6e67466b8a96e87e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

Regarding new filters:
dm-delay patch add the filter and its entries for menuconfig and make,
but dm-loop do not.
Let us have a look to the missing diffs for dm-loop <once dm-delay applied> :

--- orig/Makefile       2006-10-11 17:14:46.988454352 +0200
+++ drivers/md/Makefile 2006-10-11 17:15:08.804137864 +0200
@@ -32,6 +32,7 @@
 obj-$(CONFIG_BLK_DEV_DM)       += dm-mod.o
 obj-$(CONFIG_DM_CRYPT)         += dm-crypt.o
 obj-$(CONFIG_DM_DELAY)         += dm-delay.o
+obj-$(CONFIG_DM_LOOP)          += dm-loop.o
 obj-$(CONFIG_DM_MULTIPATH)     += dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC) += dm-emc.o
 obj-$(CONFIG_DM_SNAPSHOT)      += dm-snapshot.o

--- orig/Kconfig        2006-10-11 17:14:53.251502224 +0200
+++ drivers/md/Kconfig  2006-10-11 17:15:08.307213408 +0200
@@ -258,5 +258,13 @@

          If unsure, say N.

+config DM_LOOP
+       tristate "Loop target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       ---help---
+         A target that replace losetup or mount -o loop
+
+         If unsure, say N.
+
 endmenu


I think an other patch format (ed?) to add the Kconfig entries would
be more convenient:
**diffs may not work** on Kconfig or Makefile, depending on what new
filter is already
patched in.
I'll have a look on how to tell the patch util:  "Just add those lines
before the last one" ,
 but I'm sure many of you already know :-) hum ?

David G.M.
