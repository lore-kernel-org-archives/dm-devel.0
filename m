From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: [PATCH] dm.c
Date: Fri, 5 May 2006 08:56:43 -0500
Message-ID: <200605050856.44400.kevcorry@us.ibm.com>
References: <20060504160048.CA34173C68@hormel.redhat.com>
	<20060505072857.M41283@cn.ee.ccu.edu.tw>
	<200605050845.30546.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200605050845.30546.kevcorry@us.ibm.com>
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
Cc: Eric Sandeen <sandeen@sgi.com>, m9230 <m9230@cn.ee.ccu.edu.tw>
List-Id: dm-devel.ids

On Fri May 5 2006 8:45 am, Kevin Corry wrote:
> I haven't seen an actual patch yet for this bug, so here's one with the
> suggested fix (against 2.4.31 + device-mapper-1.02.05).

And just in case it's easier for the DM guys, here's the same fix as a patch 
against linux-2.4.28-pre4-devmapper-ioctl.patch from device-mapper-1.02.05.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/



In dm_blk_ioctl(), change 'size' to a sector_t so we can correctly return
the size of devices between 1 and 2 TB.

Fix suggested by Eric Sandeen <sandeen@sgi.com>
http://oss.sgi.com/bugzilla/show_bug.cgi?id=646

Signed-Off-By: Kevin Corry <kevcorry@us.ibm.com>

Index: device-mapper.1.02.05/patches/linux-2.4.28-pre4-devmapper-ioctl.patch
===================================================================
--- device-mapper.1.02.05.orig/patches/linux-2.4.28-pre4-devmapper-ioctl.patch
+++ device-mapper.1.02.05/patches/linux-2.4.28-pre4-devmapper-ioctl.patch
@@ -7823,7 +7823,7 @@
 +			unsigned int command, unsigned long a)
 +{
 +	kdev_t dev = inode->i_rdev;
-+	long size;
++	sector_t size;
 +
 +	switch (command) {
 +	case BLKROSET:
@@ -7843,7 +7843,7 @@
 +
 +	case BLKGETSIZE:
 +		size = volume_size(dev);
-+		if (copy_to_user((void *) a, &size, sizeof(long)))
++		if (put_user((unsigned long) size, (unsigned long *) a))
 +			return -EFAULT;
 +		break;
 +
