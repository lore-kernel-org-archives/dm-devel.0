From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dmeventd: fix typo in configure.in causing
	monitoring failure
Date: Tue, 09 Oct 2007 18:46:06 -0400
Message-ID: <470C04AE.3060701@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030903010309020004030105"
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
--------------030903010309020004030105
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

Attached patch fixes a typo in configure.in of device-mapper.

As a result of the typo, DMEVENTD_PATH in libdevmapper-event
could be set ignoring "exec_prefix" and the monitoring may not
work.

For example, LVM2 may complain it can't communicate with dmeventd:

# lvm.static lvcreate -m1 -l1 testvg
  Unable to read from event server.
  Unable to read from event server.
  testvg-lvol0: event registration failed: Input/output error
  testvg/lvol0: mirror segment monitoring function failed.
  Logical volume "lvol0" created

while in the background, dmeventd caused segfault soon after startup:

From syslog:
  dmeventd[688]: dmeventd ready for processing.
  kernel: dmeventd[688]: segfault at 08000000 eip 4ff615a7 esp bfafe2f8 error 4

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------030903010309020004030105
Content-Type: text/x-patch;
 name="dm-fix-configure-dmeventd-prefix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dm-fix-configure-dmeventd-prefix.patch"

Fix a typo in configure.in ("dmeventd_pref" should be "dmeventd_prefix")

As a result of this typo, LVM2 commands might try to invoke dmeventd
which doesn't match to the library version and monitoring fails to work.

Index: device-mapper.work/configure.in
===================================================================
--- device-mapper.work.orig/configure.in
+++ device-mapper.work/configure.in
@@ -394,7 +394,7 @@ if test "$DMEVENTD" = yes; then
 	AC_ARG_WITH(dmeventd-path,
   		    [  --with-dmeventd-path=PATH       dmeventd path [[${exec_prefix}/sbin/dmeventd]] ],
   		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_pref/sbin/dmeventd") ])
+  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_prefix/sbin/dmeventd") ])
 fi
 ################################################################################
 AC_SUBST(usrlibdir)
Index: device-mapper.work/configure
===================================================================
--- device-mapper.work.orig/configure
+++ device-mapper.work/configure
@@ -6646,7 +6646,7 @@ _ACEOF
 
 else
    cat >>confdefs.h <<_ACEOF
-#define DMEVENTD_PATH "$dmeventd_pref/sbin/dmeventd"
+#define DMEVENTD_PATH "$dmeventd_prefix/sbin/dmeventd"
 _ACEOF
 
 fi

--------------030903010309020004030105
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030903010309020004030105--
