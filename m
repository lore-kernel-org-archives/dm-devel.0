From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/4] multipath-tools: remove FAQ
Date: Wed, 27 Apr 2016 17:14:34 +0200
Message-ID: <1461770074-13428-4-git-send-email-xose.vazquez@gmail.com>
References: <1461770074-13428-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461770074-13428-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

It's old and incomplete information, website already
has a more complete FAQ

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 FAQ | 97 ---------------------------------------------------------------------
 1 file changed, 97 deletions(-)
 delete mode 100644 FAQ

diff --git a/FAQ b/FAQ
deleted file mode 100644
index 040f807..0000000
--- a/FAQ
+++ /dev/null
@@ -1,97 +0,0 @@
-More at http://christophe.varoqui.free.fr/faq.html
-See also http://christophe.varoqui.free.fr/usage.html
-
-1. How to set up System-on-multipath ?
-======================================
-
-prerequisite : udev and multipath-tools installed
-
-here are the steps on a Debian SID system :
-
-* add dm-mpath and dm-multipath to /etc/mkinitrd/modules
-* copy $tools_dir/multipath/0[12]_* to /etc/mkinitrd/scripts
-* define a friendly alias for your multipathed root disk
-  (in /etc/multipath.conf). Example : "system"
-* enable busybox in /etc/mkinitrd/mkinitrd.conf and set ROOT
-  to any valid block-device (but not a /dev/dm-* one, due to
-  an mkintrd misbelief that all dm-* are managed by LVM2)
-* run mkinitrd
-* in /boot/grub/menu.lst, define the root= kernel parameter
-  Example : root=/dev/system1
-* modify /etc/fstab to reference /dev/system* partitions
-
-At reboot, you should see some info like :
-
-path /dev/sda : multipath system
-...
-gpt: 0 slices
-dos: 5 slices
-reduced size of partition #2 to 63
-Added system1 : 0 70685937 linear /dev/system 63
-Added system2 : 0 63 linear /dev/system 7068600
-Added system5 : 0 995967 linear /dev/system 70686063
-...
-
-2. How does it compare to commercial product XXX ?
-==================================================
-
-Here are a few distinctive features :
-
-* you can mix HBA models, even different vendors, different speed ...
-* you can mix storage controllers on your SAN, and access them all, applying
-  different path grouping policy
-* completely event-driven model : no administration burden if you accept the
-  default behaviours
-* extensible : you can plug your own policies if the available ones don't fill
-  your needs
-* supports root FS on multipathed SAN
-* free, open-source software
-
-3. LVM2 doesn't see my multipathed devices as PV, what's up ?
-=============================================================
-
-By default, lvm2 does not consider device-mapper block devices (such as a
-dm-crypt device) for use as physical volumes.
-
-In order to use a dm-crypt device as an lvm2 pv, add this line to the
-devices block in /etc/lvm/lvm.conf:
-
-types = [ "device-mapper", 16 ]
-
-If /etc/lvm/lvm.conf does not exist, you can create one based on your 
-current/default config like so:
-
-lvm dumpconfig > /etc/lvm/lvm.conf
-
-(tip from Christophe Saout)
-
-4. I see a lot of "io_setup failed" message using the directio checker
-======================================================================
-
-The directio path checker makes use of the asynchronous I/O API (aio) provided
-by modern Linux systems. Asynchronous I/O allows an application to submit I/O
-requests asynchronously and be notified later of their completion status. To
-allow this, we must allocate an asynchronous I/O context (an object of type
-aio_context_t) and this task is handled by the io_setup system call.
-
-A system wide limit on the number of AIO contexts that may be active
-simultaneously is imposed via the aio-max-nr sysctl parameter.
-
-Once this limit has been reached further calls to io_setup will fail with the
-error number EAGAIN leading to the "io_setup failed" messages seen for e.g. when
-running "multipath -ll".
-
-To avoid this problem the number of available aio contexts should be increased
-by setting the aio-max-nr parameter. This can be set on a one-time basis via the
-/proc file system, for e.g.:
-
-        # echo 131072 > /proc/sys/fs/aio-max-nr
-
-Doubles the number of available contexts from the default value of 65536.
-
-To make this setting persistent a line may be added to /etc/sysctl.conf:
-
-        fs.aio-max-nr = 131072
-
-Consult appropriate application and operating system tuning recommendations for
-guidance on appropriate values for this parameter.
-- 
2.5.5
