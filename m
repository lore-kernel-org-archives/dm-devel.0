From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: [PATCH] multipath assumes pathnames are block devices
Date: Mon, 15 Jan 2007 20:36:15 +0000
Message-ID: <45ABE5BF.3090708@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010502010001080409060304"
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
--------------010502010001080409060304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

When a name is passed on the multipath command line, multipath assumes
it is a block device if it appears in the filesystem:

multipath/main.c:386:
if (filepresent(conf->dev))
        conf->dev_type = DEV_DEVNODE;
else if (sscanf(conf->dev, "%d:%d", &i, &i) == 2)
                conf->dev_type = DEV_DEVT;
        else
                conf->dev_type = DEV_DEVMAP;

This conflicts with the use of "-f" (flush map by name), in the case
that a file of the same name as the map exists in the current directory:

$ multipath -f mpath0
$ touch mpath0
$ multipath -f mpath0
must provide a map name to remove

The attached patch avoids this by adding a new function isblockdev() to
libmultipath/util.c and adding this to the DEV_DEVNODE condition. This
also means that we check for the case that what the user passed was a
character device, fifo etc.

It's probably also worth changing "-f" option to take an explicit
mapname argument, rather than just using argv[optind] after option
processing - I'll send another patch for that.

Kind regards,

Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFq+W/6YSQoMYUY94RAojDAKDD+0xeACwY8S/ommZw6SX0pw8Z1gCcDzhV
ZkYc0ZtRHPxRQzk+JO5zDkU=
=azH8
-----END PGP SIGNATURE-----

--------------010502010001080409060304
Content-Type: text/x-patch;
	name="multipath-tools-0.4.7-check_path_is_blockdev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="multipath-tools-0.4.7-check_path_is_blockdev.patch"

diff -Nurp multipath-tools-0.4.7.orig/libmultipath/util.c multipath-tools-0.4.7/libmultipath/util.c
--- multipath-tools-0.4.7.orig/libmultipath/util.c	2007-01-15 20:21:05.000000000 +0000
+++ multipath-tools-0.4.7/libmultipath/util.c	2007-01-15 20:22:07.000000000 +0000
@@ -53,6 +53,16 @@ filepresent (char * run) {
 }
 
 int
+isblockdev (char * run) {
+	struct stat buf;
+	
+	if(stat(run, &buf))
+		return 0;
+
+	return S_ISBLK(buf.st_mode);
+}
+
+int
 get_word (char * sentence, char ** word)
 {
 	char * p;
diff -Nurp multipath-tools-0.4.7.orig/multipath/main.c multipath-tools-0.4.7/multipath/main.c
--- multipath-tools-0.4.7.orig/multipath/main.c	2007-01-15 20:21:05.000000000 +0000
+++ multipath-tools-0.4.7/multipath/main.c	2007-01-15 20:22:07.000000000 +0000
@@ -383,7 +383,7 @@ main (int argc, char *argv[])
 
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
 
-		if (filepresent(conf->dev))
+		if (filepresent(conf->dev) && isblockdev(conf->dev))
 			conf->dev_type = DEV_DEVNODE;
 		else if (sscanf(conf->dev, "%d:%d", &i, &i) == 2)
 			conf->dev_type = DEV_DEVT;

--------------010502010001080409060304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010502010001080409060304--
