From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [lvm-devel] new device-mapper required to build
 latest lvm from cvs
Date: Wed, 25 Jul 2007 16:01:13 -0400
Message-ID: <46A7AC09.2070502@ce.jp.nec.com>
References: <87wswplmgl.fsf@rho.meyering.net> <46A7AB23.7050306@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090803050009080801080205"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46A7AB23.7050306@ce.jp.nec.com>
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
--------------090803050009080801080205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

> lvm_fclose() calls dm_fclose(), which cause the linker to
> bring libdm-file.o in liblvm.a. Then there happens a conflict
> of create_dir().
> 
> Attached is a patch for device-mapper to rename the function
> and export it. It alone fixes the build error.
> 
> A patch for LVM2 to use the exported function will follow.

This is the patch for LVM2.
LVM2's create_dir() is left there for the case LVM2 specific
something could be put in future.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------090803050009080801080205
Content-Type: text/x-patch;
 name="lvm2-use-dm_create_dir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lvm2-use-dm_create_dir.patch"

Use dm_create_dir() instead of its own.

Index: LVM2.work/lib/misc/lvm-file.c
===================================================================
--- LVM2.work.orig/lib/misc/lvm-file.c
+++ LVM2.work/lib/misc/lvm-file.c
@@ -140,54 +140,9 @@ int dir_exists(const char *path)
 	return 1;
 }
 
-static int _create_dir_recursive(const char *dir)
-{
-	char *orig, *s;
-	int rc;
-
-	log_verbose("Creating directory \"%s\"", dir);
-	/* Create parent directories */
-	orig = s = dm_strdup(dir);
-	while ((s = strchr(s, '/')) != NULL) {
-		*s = '\0';
-		if (*orig) {
-			rc = mkdir(orig, 0777);
-			if (rc < 0 && errno != EEXIST) {
-				if (errno != EROFS)
-					log_sys_error("mkdir", orig);
-				dm_free(orig);
-				return 0;
-			}
-		}
-		*s++ = '/';
-	}
-	dm_free(orig);
-
-	/* Create final directory */
-	rc = mkdir(dir, 0777);
-	if (rc < 0 && errno != EEXIST) {
-		if (errno != EROFS)
-			log_sys_error("mkdir", dir);
-		return 0;
-	}
-	return 1;
-}
-
 int create_dir(const char *dir)
 {
-	struct stat info;
-
-	if (!*dir)
-		return 1;
-
-	if (stat(dir, &info) < 0)
-		return _create_dir_recursive(dir);
-
-	if (S_ISDIR(info.st_mode))
-		return 1;
-
-	log_error("Directory \"%s\" not found", dir);
-	return 0;
+	return dm_create_dir(dir);
 }
 
 int is_empty_dir(const char *dir)

--------------090803050009080801080205
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090803050009080801080205--
