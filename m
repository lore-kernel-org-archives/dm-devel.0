Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5106EC82549
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CFCD824631
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFCD824631
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-UP-XF_NSNP6iCrfVKXJkjw-1; Mon, 16 Nov 2020 10:00:28 -0500
X-MC-Unique: UP-XF_NSNP6iCrfVKXJkjw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0592B1075642;
	Mon, 16 Nov 2020 14:59:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDC1F176BB;
	Mon, 16 Nov 2020 14:59:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AFF0F183D021;
	Mon, 16 Nov 2020 14:59:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGExY99015559 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 09:59:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 03CCA2156A36; Mon, 16 Nov 2020 14:59:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F29D32156A34
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4400185A7A2
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:33 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-192-fZ_LJCz4NoiHftbqTHxqig-1; Mon, 16 Nov 2020 09:59:31 -0500
X-MC-Unique: fZ_LJCz4NoiHftbqTHxqig-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyS-00042Q-Vn; Mon, 16 Nov 2020 14:59:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:41 +0100
Message-Id: <20201116145809.410558-51-hch@lst.de>
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 50/78] z2ram: reindent
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

reindent the driver using Lident as the code style was far away from
normal Linux code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/z2ram.c | 493 ++++++++++++++++++++----------------------
 1 file changed, 236 insertions(+), 257 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 0e734802ee7cc6..eafecc9a72b38d 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -42,7 +42,6 @@
 
 #include <linux/zorro.h>
 
-
 #define Z2MINOR_COMBINED      (0)
 #define Z2MINOR_Z2ONLY        (1)
 #define Z2MINOR_CHIPONLY      (2)
@@ -50,17 +49,17 @@
 #define Z2MINOR_MEMLIST2      (5)
 #define Z2MINOR_MEMLIST3      (6)
 #define Z2MINOR_MEMLIST4      (7)
-#define Z2MINOR_COUNT         (8) /* Move this down when adding a new minor */
+#define Z2MINOR_COUNT         (8)	/* Move this down when adding a new minor */
 
 #define Z2RAM_CHUNK1024       ( Z2RAM_CHUNKSIZE >> 10 )
 
 static DEFINE_MUTEX(z2ram_mutex);
-static u_long *z2ram_map    = NULL;
-static u_long z2ram_size    = 0;
-static int z2_count         = 0;
-static int chip_count       = 0;
-static int list_count       = 0;
-static int current_device   = -1;
+static u_long *z2ram_map = NULL;
+static u_long z2ram_size = 0;
+static int z2_count = 0;
+static int chip_count = 0;
+static int list_count = 0;
+static int current_device = -1;
 
 static DEFINE_SPINLOCK(z2ram_lock);
 
@@ -71,7 +70,7 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 {
 	struct request *req = bd->rq;
 	unsigned long start = blk_rq_pos(req) << 9;
-	unsigned long len  = blk_rq_cur_bytes(req);
+	unsigned long len = blk_rq_cur_bytes(req);
 
 	blk_mq_start_request(req);
 
@@ -92,7 +91,7 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 		if (len < size)
 			size = len;
-		addr += z2ram_map[ start >> Z2RAM_CHUNKSHIFT ];
+		addr += z2ram_map[start >> Z2RAM_CHUNKSHIFT];
 		if (rq_data_dir(req) == READ)
 			memcpy(buffer, (char *)addr, size);
 		else
@@ -106,228 +105,214 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
-static void
-get_z2ram( void )
+static void get_z2ram(void)
 {
-    int i;
-
-    for ( i = 0; i < Z2RAM_SIZE / Z2RAM_CHUNKSIZE; i++ )
-    {
-	if ( test_bit( i, zorro_unused_z2ram ) )
-	{
-	    z2_count++;
-	    z2ram_map[z2ram_size++] = (unsigned long)ZTWO_VADDR(Z2RAM_START) +
-				      (i << Z2RAM_CHUNKSHIFT);
-	    clear_bit( i, zorro_unused_z2ram );
+	int i;
+
+	for (i = 0; i < Z2RAM_SIZE / Z2RAM_CHUNKSIZE; i++) {
+		if (test_bit(i, zorro_unused_z2ram)) {
+			z2_count++;
+			z2ram_map[z2ram_size++] =
+			    (unsigned long)ZTWO_VADDR(Z2RAM_START) +
+			    (i << Z2RAM_CHUNKSHIFT);
+			clear_bit(i, zorro_unused_z2ram);
+		}
 	}
-    }
 
-    return;
+	return;
 }
 
-static void
-get_chipram( void )
+static void get_chipram(void)
 {
 
-    while ( amiga_chip_avail() > ( Z2RAM_CHUNKSIZE * 4 ) )
-    {
-	chip_count++;
-	z2ram_map[ z2ram_size ] =
-	    (u_long)amiga_chip_alloc( Z2RAM_CHUNKSIZE, "z2ram" );
+	while (amiga_chip_avail() > (Z2RAM_CHUNKSIZE * 4)) {
+		chip_count++;
+		z2ram_map[z2ram_size] =
+		    (u_long) amiga_chip_alloc(Z2RAM_CHUNKSIZE, "z2ram");
 
-	if ( z2ram_map[ z2ram_size ] == 0 )
-	{
-	    break;
+		if (z2ram_map[z2ram_size] == 0) {
+			break;
+		}
+
+		z2ram_size++;
 	}
 
-	z2ram_size++;
-    }
-	
-    return;
+	return;
 }
 
 static int z2_open(struct block_device *bdev, fmode_t mode)
 {
-    int device;
-    int max_z2_map = ( Z2RAM_SIZE / Z2RAM_CHUNKSIZE ) *
-	sizeof( z2ram_map[0] );
-    int max_chip_map = ( amiga_chip_size / Z2RAM_CHUNKSIZE ) *
-	sizeof( z2ram_map[0] );
-    int rc = -ENOMEM;
-
-    device = MINOR(bdev->bd_dev);
-
-    mutex_lock(&z2ram_mutex);
-    if ( current_device != -1 && current_device != device )
-    {
-	rc = -EBUSY;
-	goto err_out;
-    }
-
-    if ( current_device == -1 )
-    {
-	z2_count   = 0;
-	chip_count = 0;
-	list_count = 0;
-	z2ram_size = 0;
-
-	/* Use a specific list entry. */
-	if (device >= Z2MINOR_MEMLIST1 && device <= Z2MINOR_MEMLIST4) {
-		int index = device - Z2MINOR_MEMLIST1 + 1;
-		unsigned long size, paddr, vaddr;
-
-		if (index >= m68k_realnum_memory) {
-			printk( KERN_ERR DEVICE_NAME
-				": no such entry in z2ram_map\n" );
-		        goto err_out;
-		}
-
-		paddr = m68k_memory[index].addr;
-		size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE-1);
-
-#ifdef __powerpc__
-		/* FIXME: ioremap doesn't build correct memory tables. */
-		{
-			vfree(vmalloc (size));
-		}
+	int device;
+	int max_z2_map = (Z2RAM_SIZE / Z2RAM_CHUNKSIZE) * sizeof(z2ram_map[0]);
+	int max_chip_map = (amiga_chip_size / Z2RAM_CHUNKSIZE) *
+	    sizeof(z2ram_map[0]);
+	int rc = -ENOMEM;
 
-		vaddr = (unsigned long)ioremap_wt(paddr, size);
+	device = MINOR(bdev->bd_dev);
 
-#else
-		vaddr = (unsigned long)z_remap_nocache_nonser(paddr, size);
-#endif
-		z2ram_map = 
-			kmalloc_array(size / Z2RAM_CHUNKSIZE,
-                                      sizeof(z2ram_map[0]),
-                                      GFP_KERNEL);
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
-		}
+	mutex_lock(&z2ram_mutex);
+	if (current_device != -1 && current_device != device) {
+		rc = -EBUSY;
+		goto err_out;
+	}
 
-		while (size) {
-			z2ram_map[ z2ram_size++ ] = vaddr;
-			size -= Z2RAM_CHUNKSIZE;
-			vaddr += Z2RAM_CHUNKSIZE;
-			list_count++;
-		}
+	if (current_device == -1) {
+		z2_count = 0;
+		chip_count = 0;
+		list_count = 0;
+		z2ram_size = 0;
 
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME
-			": using %iK List Entry %d Memory\n",
-			list_count * Z2RAM_CHUNK1024, index );
-	} else
-
-	switch ( device )
-	{
-	    case Z2MINOR_COMBINED:
-
-		z2ram_map = kmalloc( max_z2_map + max_chip_map, GFP_KERNEL );
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
-		}
+		/* Use a specific list entry. */
+		if (device >= Z2MINOR_MEMLIST1 && device <= Z2MINOR_MEMLIST4) {
+			int index = device - Z2MINOR_MEMLIST1 + 1;
+			unsigned long size, paddr, vaddr;
 
-		get_z2ram();
-		get_chipram();
-
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME 
-			": using %iK Zorro II RAM and %iK Chip RAM (Total %dK)\n",
-			z2_count * Z2RAM_CHUNK1024,
-			chip_count * Z2RAM_CHUNK1024,
-			( z2_count + chip_count ) * Z2RAM_CHUNK1024 );
-
-	    break;
-
-    	    case Z2MINOR_Z2ONLY:
-		z2ram_map = kmalloc( max_z2_map, GFP_KERNEL );
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
-		}
+			if (index >= m68k_realnum_memory) {
+				printk(KERN_ERR DEVICE_NAME
+				       ": no such entry in z2ram_map\n");
+				goto err_out;
+			}
 
-		get_z2ram();
+			paddr = m68k_memory[index].addr;
+			size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE - 1);
 
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME 
-			": using %iK of Zorro II RAM\n",
-			z2_count * Z2RAM_CHUNK1024 );
+#ifdef __powerpc__
+			/* FIXME: ioremap doesn't build correct memory tables. */
+			{
+				vfree(vmalloc(size));
+			}
 
-	    break;
+			vaddr = (unsigned long)ioremap_wt(paddr, size);
 
-	    case Z2MINOR_CHIPONLY:
-		z2ram_map = kmalloc( max_chip_map, GFP_KERNEL );
-		if ( z2ram_map == NULL )
-		{
-		    printk( KERN_ERR DEVICE_NAME
-			": cannot get mem for z2ram_map\n" );
-		    goto err_out;
+#else
+			vaddr =
+			    (unsigned long)z_remap_nocache_nonser(paddr, size);
+#endif
+			z2ram_map =
+			    kmalloc_array(size / Z2RAM_CHUNKSIZE,
+					  sizeof(z2ram_map[0]), GFP_KERNEL);
+			if (z2ram_map == NULL) {
+				printk(KERN_ERR DEVICE_NAME
+				       ": cannot get mem for z2ram_map\n");
+				goto err_out;
+			}
+
+			while (size) {
+				z2ram_map[z2ram_size++] = vaddr;
+				size -= Z2RAM_CHUNKSIZE;
+				vaddr += Z2RAM_CHUNKSIZE;
+				list_count++;
+			}
+
+			if (z2ram_size != 0)
+				printk(KERN_INFO DEVICE_NAME
+				       ": using %iK List Entry %d Memory\n",
+				       list_count * Z2RAM_CHUNK1024, index);
+		} else
+			switch (device) {
+			case Z2MINOR_COMBINED:
+
+				z2ram_map =
+				    kmalloc(max_z2_map + max_chip_map,
+					    GFP_KERNEL);
+				if (z2ram_map == NULL) {
+					printk(KERN_ERR DEVICE_NAME
+					       ": cannot get mem for z2ram_map\n");
+					goto err_out;
+				}
+
+				get_z2ram();
+				get_chipram();
+
+				if (z2ram_size != 0)
+					printk(KERN_INFO DEVICE_NAME
+					       ": using %iK Zorro II RAM and %iK Chip RAM (Total %dK)\n",
+					       z2_count * Z2RAM_CHUNK1024,
+					       chip_count * Z2RAM_CHUNK1024,
+					       (z2_count +
+						chip_count) * Z2RAM_CHUNK1024);
+
+				break;
+
+			case Z2MINOR_Z2ONLY:
+				z2ram_map = kmalloc(max_z2_map, GFP_KERNEL);
+				if (z2ram_map == NULL) {
+					printk(KERN_ERR DEVICE_NAME
+					       ": cannot get mem for z2ram_map\n");
+					goto err_out;
+				}
+
+				get_z2ram();
+
+				if (z2ram_size != 0)
+					printk(KERN_INFO DEVICE_NAME
+					       ": using %iK of Zorro II RAM\n",
+					       z2_count * Z2RAM_CHUNK1024);
+
+				break;
+
+			case Z2MINOR_CHIPONLY:
+				z2ram_map = kmalloc(max_chip_map, GFP_KERNEL);
+				if (z2ram_map == NULL) {
+					printk(KERN_ERR DEVICE_NAME
+					       ": cannot get mem for z2ram_map\n");
+					goto err_out;
+				}
+
+				get_chipram();
+
+				if (z2ram_size != 0)
+					printk(KERN_INFO DEVICE_NAME
+					       ": using %iK Chip RAM\n",
+					       chip_count * Z2RAM_CHUNK1024);
+
+				break;
+
+			default:
+				rc = -ENODEV;
+				goto err_out;
+
+				break;
+			}
+
+		if (z2ram_size == 0) {
+			printk(KERN_NOTICE DEVICE_NAME
+			       ": no unused ZII/Chip RAM found\n");
+			goto err_out_kfree;
 		}
 
-		get_chipram();
-
-		if ( z2ram_size != 0 )
-		    printk( KERN_INFO DEVICE_NAME 
-			": using %iK Chip RAM\n",
-			chip_count * Z2RAM_CHUNK1024 );
-		    
-	    break;
-
-	    default:
-		rc = -ENODEV;
-		goto err_out;
-	
-	    break;
+		current_device = device;
+		z2ram_size <<= Z2RAM_CHUNKSHIFT;
+		set_capacity(z2ram_gendisk, z2ram_size >> 9);
 	}
 
-	if ( z2ram_size == 0 )
-	{
-	    printk( KERN_NOTICE DEVICE_NAME
-		": no unused ZII/Chip RAM found\n" );
-	    goto err_out_kfree;
-	}
-
-	current_device = device;
-	z2ram_size <<= Z2RAM_CHUNKSHIFT;
-	set_capacity(z2ram_gendisk, z2ram_size >> 9);
-    }
-
-    mutex_unlock(&z2ram_mutex);
-    return 0;
+	mutex_unlock(&z2ram_mutex);
+	return 0;
 
 err_out_kfree:
-    kfree(z2ram_map);
+	kfree(z2ram_map);
 err_out:
-    mutex_unlock(&z2ram_mutex);
-    return rc;
+	mutex_unlock(&z2ram_mutex);
+	return rc;
 }
 
-static void
-z2_release(struct gendisk *disk, fmode_t mode)
+static void z2_release(struct gendisk *disk, fmode_t mode)
 {
-    mutex_lock(&z2ram_mutex);
-    if ( current_device == -1 ) {
-    	mutex_unlock(&z2ram_mutex);
-    	return;
-    }
-    mutex_unlock(&z2ram_mutex);
-    /*
-     * FIXME: unmap memory
-     */
+	mutex_lock(&z2ram_mutex);
+	if (current_device == -1) {
+		mutex_unlock(&z2ram_mutex);
+		return;
+	}
+	mutex_unlock(&z2ram_mutex);
+	/*
+	 * FIXME: unmap memory
+	 */
 }
 
-static const struct block_device_operations z2_fops =
-{
-	.owner		= THIS_MODULE,
-	.open		= z2_open,
-	.release	= z2_release,
+static const struct block_device_operations z2_fops = {
+	.owner = THIS_MODULE,
+	.open = z2_open,
+	.release = z2_release,
 };
 
 static struct kobject *z2_find(dev_t dev, int *part, void *data)
@@ -340,89 +325,83 @@ static struct request_queue *z2_queue;
 static struct blk_mq_tag_set tag_set;
 
 static const struct blk_mq_ops z2_mq_ops = {
-	.queue_rq	= z2_queue_rq,
+	.queue_rq = z2_queue_rq,
 };
 
-static int __init 
-z2_init(void)
+static int __init z2_init(void)
 {
-    int ret;
+	int ret;
 
-    if (!MACH_IS_AMIGA)
-	return -ENODEV;
+	if (!MACH_IS_AMIGA)
+		return -ENODEV;
 
-    ret = -EBUSY;
-    if (register_blkdev(Z2RAM_MAJOR, DEVICE_NAME))
-	goto err;
+	ret = -EBUSY;
+	if (register_blkdev(Z2RAM_MAJOR, DEVICE_NAME))
+		goto err;
 
-    ret = -ENOMEM;
-    z2ram_gendisk = alloc_disk(1);
-    if (!z2ram_gendisk)
-	goto out_disk;
+	ret = -ENOMEM;
+	z2ram_gendisk = alloc_disk(1);
+	if (!z2ram_gendisk)
+		goto out_disk;
 
-    z2_queue = blk_mq_init_sq_queue(&tag_set, &z2_mq_ops, 16,
+	z2_queue = blk_mq_init_sq_queue(&tag_set, &z2_mq_ops, 16,
 					BLK_MQ_F_SHOULD_MERGE);
-    if (IS_ERR(z2_queue)) {
-	ret = PTR_ERR(z2_queue);
-	z2_queue = NULL;
-	goto out_queue;
-    }
+	if (IS_ERR(z2_queue)) {
+		ret = PTR_ERR(z2_queue);
+		z2_queue = NULL;
+		goto out_queue;
+	}
 
-    z2ram_gendisk->major = Z2RAM_MAJOR;
-    z2ram_gendisk->first_minor = 0;
-    z2ram_gendisk->fops = &z2_fops;
-    sprintf(z2ram_gendisk->disk_name, "z2ram");
+	z2ram_gendisk->major = Z2RAM_MAJOR;
+	z2ram_gendisk->first_minor = 0;
+	z2ram_gendisk->fops = &z2_fops;
+	sprintf(z2ram_gendisk->disk_name, "z2ram");
 
-    z2ram_gendisk->queue = z2_queue;
-    add_disk(z2ram_gendisk);
-    blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
-				z2_find, NULL, NULL);
+	z2ram_gendisk->queue = z2_queue;
+	add_disk(z2ram_gendisk);
+	blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
+			    z2_find, NULL, NULL);
 
-    return 0;
+	return 0;
 
 out_queue:
-    put_disk(z2ram_gendisk);
+	put_disk(z2ram_gendisk);
 out_disk:
-    unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
+	unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
 err:
-    return ret;
+	return ret;
 }
 
 static void __exit z2_exit(void)
 {
-    int i, j;
-    blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
-    unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
-    del_gendisk(z2ram_gendisk);
-    put_disk(z2ram_gendisk);
-    blk_cleanup_queue(z2_queue);
-    blk_mq_free_tag_set(&tag_set);
-
-    if ( current_device != -1 )
-    {
-	i = 0;
-
-	for ( j = 0 ; j < z2_count; j++ )
-	{
-	    set_bit( i++, zorro_unused_z2ram ); 
-	}
+	int i, j;
+	blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
+	unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
+	del_gendisk(z2ram_gendisk);
+	put_disk(z2ram_gendisk);
+	blk_cleanup_queue(z2_queue);
+	blk_mq_free_tag_set(&tag_set);
+
+	if (current_device != -1) {
+		i = 0;
+
+		for (j = 0; j < z2_count; j++) {
+			set_bit(i++, zorro_unused_z2ram);
+		}
 
-	for ( j = 0 ; j < chip_count; j++ )
-	{
-	    if ( z2ram_map[ i ] )
-	    {
-		amiga_chip_free( (void *) z2ram_map[ i++ ] );
-	    }
-	}
+		for (j = 0; j < chip_count; j++) {
+			if (z2ram_map[i]) {
+				amiga_chip_free((void *)z2ram_map[i++]);
+			}
+		}
 
-	if ( z2ram_map != NULL )
-	{
-	    kfree( z2ram_map );
+		if (z2ram_map != NULL) {
+			kfree(z2ram_map);
+		}
 	}
-    }
 
-    return;
-} 
+	return;
+}
 
 module_init(z2_init);
 module_exit(z2_exit);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

