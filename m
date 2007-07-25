From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [lvm-devel] new device-mapper required to build
 latest lvm from cvs
Date: Wed, 25 Jul 2007 15:57:23 -0400
Message-ID: <46A7AB23.7050306@ce.jp.nec.com>
References: <87wswplmgl.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030605000205090107080007"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87wswplmgl.fsf@rho.meyering.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LVM2 development <lvm-devel@redhat.com>, jim@meyering.net
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030605000205090107080007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Jim Meyering wrote:
> FYI, with the change I've just committed,
> 
>   http://sources.redhat.com/ml/lvm2-cvs/2007-07/msg00035.html
> 
> you now need a device-mapper library and headers built from
> today's cvs sources.  Otherwise, you'll get compile warnings
> and eventually a link error complaining about missing dm_fclose.

This change introduces an error for static build.

/usr/local/lib/libdevmapper.a(libdm-file.o): In function `create_dir':
/work/device-mapper/lib/libdm-file.c:59: multiple definition of `create_dir'
../lib/liblvm.a(lvm-file.o):/work/LVM2/lib/misc/lvm-file.c:177: first defined here
/usr/bin/ld: Warning: size of symbol `create_dir' changed from 176 in ../lib/liblvm.a(lvm-file.o) to 187 in /usr/local/lib/libdevmapper.a(libdm-file.o)

lvm_fclose() calls dm_fclose(), which cause the linker to
bring libdm-file.o in liblvm.a. Then there happens a conflict
of create_dir().

Attached is a patch for device-mapper to rename the function
and export it. It alone fixes the build error.

A patch for LVM2 to use the exported function will follow.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------030605000205090107080007
Content-Type: text/x-patch;
 name="dm-dm_create_dir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-dm_create_dir.patch"

lvm_fclose() calls dm_fclose(), which cause the static linker to
bring libdm-file.o in liblvm.a. Then there happens a conflict
of create_dir().

Fix the following build error:

/usr/local/lib/libdevmapper.a(libdm-file.o): In function `create_dir':
/work/device-mapper/lib/libdm-file.c:59: multiple definition of `create_dir'
../lib/liblvm.a(lvm-file.o):/work/LVM2/lib/misc/lvm-file.c:177: first defined here
/usr/bin/ld: Warning: size of symbol `create_dir' changed from 176 in ../lib/liblvm.a(lvm-file.o) to 187 in /usr/local/lib/libdevmapper.a(libdm-file.o)

Index: device-mapper.work/lib/.exported_symbols
===================================================================
--- device-mapper.work.orig/lib/.exported_symbols
+++ device-mapper.work/lib/.exported_symbols
@@ -1,6 +1,7 @@
 dm_lib_release
 dm_lib_exit
 dm_driver_version
+dm_create_dir
 dm_fclose
 dm_get_library_version
 dm_log
Index: device-mapper.work/lib/libdevmapper.h
===================================================================
--- device-mapper.work.orig/lib/libdevmapper.h
+++ device-mapper.work/lib/libdevmapper.h
@@ -629,6 +629,12 @@ char *dm_basename(const char *path);
  **************************/
 
 /*
+ * Create a directory (with parent directories if necessary).
+ * Returns 1 on success, 0 on failure.
+ */
+int dm_create_dir(const char *dir);
+
+/*
  * Close a stream, with nicer error checking than fclose's.
  * Derived from gnulib's close-stream.c.
  *
Index: device-mapper.work/lib/libdm-file.c
===================================================================
--- device-mapper.work.orig/lib/libdm-file.c
+++ device-mapper.work/lib/libdm-file.c
@@ -55,7 +55,7 @@ out:
 	return r;
 }
 
-int create_dir(const char *dir)
+int dm_create_dir(const char *dir)
 {
 	struct stat info;
 
Index: device-mapper.work/lib/ioctl/libdm-iface.c
===================================================================
--- device-mapper.work.orig/lib/ioctl/libdm-iface.c
+++ device-mapper.work/lib/ioctl/libdm-iface.c
@@ -228,7 +228,7 @@ static int _create_control(const char *c
 		return 0;
 
 	old_umask = umask(0022);
-	ret = create_dir(dm_dir());
+	ret = dm_create_dir(dm_dir());
 	umask(old_umask);
 
 	if (!ret)

--------------030605000205090107080007
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030605000205090107080007--
