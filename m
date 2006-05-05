From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: [PATCH] dm.c
Date: Fri, 5 May 2006 08:45:29 -0500
Message-ID: <200605050845.30546.kevcorry@us.ibm.com>
References: <20060504160048.CA34173C68@hormel.redhat.com>
	<20060505072857.M41283@cn.ee.ccu.edu.tw>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060505072857.M41283@cn.ee.ccu.edu.tw>
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

On Fri May 5 2006 2:35 am, m9230 wrote:
> I am sorry that I did not list the original source.
> Thanks to Eric, this is the original source:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=646
>
> > Hello, I found a problem in dm_blk_ioctl() in dm.c:
> >
> > In dm.c, dm_blk_ioctl() is assigning a full unsigned 32 bits of
> > device size to a signed 32 bit size. This may cause BLKGETSIZE64
> > ioctl and BLKGETSIZE ioctl failed to get the device size when device
> > size is larger than 1TB.
> >
> > I am using device-mapper.1.01.05.
> >
> > Changing "long size;" to "sector_t size;" might fix this up, it
> > works for me. For example: error = ioctl(fd, BLKGETSIZE64, &size);
> > returns "size" in bytes.

I haven't seen an actual patch yet for this bug, so here's one with the 
suggested fix (against 2.4.31 + device-mapper-1.02.05).

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

Index: 2.4.31/drivers/md/dm.c
===================================================================
--- 2.4.31.orig/drivers/md/dm.c
+++ 2.4.31/drivers/md/dm.c
@@ -456,7 +456,7 @@ static int dm_blk_ioctl(struct inode *in
 			unsigned int command, unsigned long a)
 {
 	kdev_t dev = inode->i_rdev;
-	long size;
+	sector_t size;
 
 	switch (command) {
 	case BLKROSET:
@@ -476,7 +476,7 @@ static int dm_blk_ioctl(struct inode *in
 
 	case BLKGETSIZE:
 		size = volume_size(dev);
-		if (copy_to_user((void *) a, &size, sizeof(long)))
+		if (put_user((unsigned long) size, (unsigned long *) a))
 			return -EFAULT;
 		break;
 
