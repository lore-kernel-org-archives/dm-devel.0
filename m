From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Bug#403426: kernel corrupts LUKS partition header on
	arm
Date: Fri, 29 Dec 2006 21:24:34 +0100
Message-ID: <20061229202434.GD23246@deprecation.cyrius.com>
References: <20061217022906.2434.60658.reportbug@LKG8A754B.example.org>
	<20061220161529.GA10820@deprecation.cyrius.com>
	<87lkkrgej4.wl%clemens@endorphin.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87lkkrgej4.wl%clemens@endorphin.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Clemens Fruhwirth <clemens@endorphin.org>
Cc: 403426@bugs.debian.org, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>
List-Id: dm-devel.ids


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Clemens Fruhwirth <clemens@endorphin.org> [2006-12-29 11:52]:
> Please try the version from subversion
> http://luks.endorphin.org/svn/cryptsetup

With 1.0.4 plus the attached 2 patches from SVN I no longer get any
corruption but I also cannot access my encrypted data.  Is there
anything else I should try?


foobar:~# cryptsetup luksOpen /dev/sda5 x
Enter LUKS passphrase:
device-mapper: table: 254:0: crypt: Device lookup failed
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table.
Failed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and verify that /dev/sda5 contains at least 133 sectors.
Failed to read from key storage
Enter LUKS passphrase:
device-mapper: table: 254:0: crypt: Device lookup failed
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table.
Failed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and verify that /dev/sda5 contains at least 133 sectors.
Failed to read from key storage
Enter LUKS passphrase:
device-mapper: table: 254:0: crypt: Device lookup failed
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table.
Failed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and verify that /dev/sda5 contains at least 133 sectors.
Failed to read from key storage
Command failed: No key available with this passphrase.

foobar:~# cryptsetup luksOpen /dev/sda5 x
Enter LUKS passphrase:
device-mapper: table: 254:0: crypt: Device lookup failed
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table.
Failed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and verify that /dev/sda5 contains at least 133 sectors.
Failed to read from key storage
Enter LUKS passphrase:
device-mapper: table: 254:0: crypt: Device lookup failed
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table.
Failed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and verify that /dev/sda5 contains at least 133 sectors.
Failed to read from key storage
Enter LUKS passphrase:
device-mapper: table: 254:0: crypt: Device lookup failed
device-mapper: ioctl: error adding target to table
device-mapper: ioctl: device doesn't appear to be in the dev hash table.
Failed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and verify that /dev/sda5 contains at least 133 sectors.
Failed to read from key storage
Command failed: No key available with this passphrase.

foobar:~#

-- 
Martin Michlmayr
http://www.cyrius.com/

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="02_fix_arm.dpatch"

#! /bin/sh /usr/share/dpatch/dpatch-run
## 02_fix_arm.dpatch by Clemens Fruhwirth <clemens@endorphin.org>
##
## DP: Add error checking to read_blockwise for short reads.
## DP: Commit a patch that fixes http://bugs.debian.org/403075

@DPATCH@
Index: lib/utils.c
===================================================================
--- cryptsetup-1.0.4~/lib/utils.c	(revision 1)
+++ cryptsetup-1.0.4/lib/utils.c	(working copy)
@@ -151,8 +151,10 @@
 static int sector_size(int fd) 
 {
 	int bsize;
-	ioctl(fd,BLKSSZGET, &bsize);
-	return bsize;
+	if (ioctl(fd,BLKSSZGET, &bsize) < 0)
+		return -EINVAL;
+	else
+		return bsize;
 }
 
 int sector_size_for_device(const char *device)
@@ -171,8 +173,11 @@
 	char *padbuf; char *padbuf_base;
 	char *buf = (char *)orig_buf;
 	int r;
-	int hangover; int solid; int bsize = sector_size(fd);
+	int hangover; int solid; int bsize;
 
+	if ((bsize = sector_size(fd)) < 0)
+		return bsize;
+
 	hangover = count % bsize;
 	solid = count - hangover;
 
@@ -209,15 +214,20 @@
 	char *buf = (char *)orig_buf;
 	int r;
 	int step;
-	int bsize = sector_size(fd);
+	int bsize;
 
+	if ((bsize = sector_size(fd)) < 0)
+		return bsize;
+
 	padbuf = aligned_malloc(&padbuf_base, bsize, bsize);
 	if(padbuf == NULL) return -ENOMEM;
 
 	while(count) {
 		r = read(fd,padbuf,bsize);
-		if(r < 0) goto out;
-		
+		if(r < 0 || r != bsize) {
+			fprintf(stderr, "read failed in read_blockwise.\n");
+			goto out;
+		}
 		step = count<bsize?count:bsize;
 		memcpy(buf,padbuf,step);
 		buf += step;
@@ -242,6 +252,9 @@
 	int frontHang = offset % bsize;
 	int r;
 
+	if (bsize < 0)
+		return bsize;
+
 	lseek(fd, offset - frontHang, SEEK_SET);
 	if(offset % bsize) {
 		int innerCount = count<bsize?count:bsize;

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="03_no_header_conv.dpatch"

#! /bin/sh /usr/share/dpatch/dpatch-run
## 03_no_header_conv.patch by Clemens Fruhwirth <clemens@endorphin.org>
##
## DP: Kick ancient version header conversion.

@DPATCH@
Index: luks/keymanage.c
===================================================================
--- a/luks/keymanage.c	(revision 19)
+++ b/luks/keymanage.c	(working copy)
@@ -67,14 +67,6 @@
 	return mk;
 }
 
-static inline void convert_V99toV991(char const *device, struct luks_phdr *hdr) {
-	struct luks_phdr tmp_phdr;
-	fputs(_("automatic header conversion from 0.99 to 0.991 triggered"), stderr);
-	hdr->mkDigestIterations = ntohs(htonl(hdr->mkDigestIterations));
-	memcpy(&tmp_phdr, hdr, sizeof(struct luks_phdr));
-	LUKS_write_phdr(device, &tmp_phdr); 
-}
-
 int LUKS_read_phdr(const char *device, struct luks_phdr *hdr)
 {
 	int devfd = 0; 
@@ -109,14 +101,6 @@
 			hdr->keyblock[i].passwordIterations = ntohl(hdr->keyblock[i].passwordIterations);
 			hdr->keyblock[i].keyMaterialOffset  = ntohl(hdr->keyblock[i].keyMaterialOffset);
 			hdr->keyblock[i].stripes            = ntohl(hdr->keyblock[i].stripes);
-
-			if(hdr->keyblock[i].active == LUKS_KEY_DISABLED_OLD) {
-				hdr->keyblock[i].active = LUKS_KEY_DISABLED;
-				convert_V99toV991(device, hdr);
-			} else if(hdr->keyblock[i].active == LUKS_KEY_ENABLED_OLD) {
-				hdr->keyblock[i].active = LUKS_KEY_ENABLED;
-				convert_V99toV991(device, hdr);
-			}
 		}
 	}
 

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--fUYQa+Pmc3FrFX/N--
