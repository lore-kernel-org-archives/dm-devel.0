Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E30C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  1 Apr 2022 04:57:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-9B6hTgo-MsupbXhHSd1cEw-1; Fri, 01 Apr 2022 00:57:42 -0400
X-MC-Unique: 9B6hTgo-MsupbXhHSd1cEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E809583395E;
	Fri,  1 Apr 2022 04:57:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D23840885A1;
	Fri,  1 Apr 2022 04:57:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 455091947BBE;
	Fri,  1 Apr 2022 04:57:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D68021947BBC
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Apr 2022 04:57:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A558D778A; Fri,  1 Apr 2022 04:57:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A18E07774
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 04:57:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E5803820543
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 04:57:30 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-oXkM1QB1MDuabSUzqNbFRg-1; Fri, 01 Apr 2022 00:57:17 -0400
X-MC-Unique: oXkM1QB1MDuabSUzqNbFRg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id D5FF268AFE; Fri,  1 Apr 2022 06:57:13 +0200 (CEST)
Date: Fri, 1 Apr 2022 06:57:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20220401045713.GA9057@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-5-hch@lst.de>
 <CGME20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42@eucas1p2.samsung.com>
 <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
MIME-Version: 1.0
In-Reply-To: <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/5] block: turn bio_kmalloc into a simple
 kmalloc wrapper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 31, 2022 at 11:18:03PM +0200, Marek Szyprowski wrote:
> Hi Christoph,
> 
> On 08.03.2022 07:15, Christoph Hellwig wrote:
> > Remove the magic autofree semantics and require the callers to explicitly
> > call bio_init to initialize the bio.
> >
> > This allows bio_free to catch accidental bio_put calls on bio_init()ed
> > bios as well.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch, which landed in today's next-20220331 as commit 57c47b42f454 
> ("block: turn bio_kmalloc into a simple kmalloc wrapper"), breaks badly 
> all my test systems, which use squashfs initrd:

In addition to the revert, this is the patch I had already queued up:

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 930eb530fa622..fed99bb3df3be 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -72,6 +72,13 @@ static int copy_bio_to_actor(struct bio *bio,
 	return copied_bytes;
 }
 
+static void squashfs_bio_free(struct bio *bio)
+{
+	bio_free_pages(bio);
+	bio_uninit(bio);
+	kfree(bio);
+}
+
 static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 			     struct bio **biop, int *block_offset)
 {
@@ -118,9 +125,7 @@ static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 	return 0;
 
 out_free_bio:
-	bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	squashfs_bio_free(bio);
 	return error;
 }
 
@@ -183,8 +188,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 			data = bvec_virt(bvec);
 			length |= data[0] << 8;
 		}
-		bio_free_pages(bio);
-		bio_put(bio);
+		squashfs_bio_free(bio);
 
 		compressed = SQUASHFS_COMPRESSED(length);
 		length = SQUASHFS_COMPRESSED_SIZE(length);
@@ -217,8 +221,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 	}
 
 out_free_bio:
-	bio_free_pages(bio);
-	bio_put(bio);
+	squashfs_bio_free(bio);
 out:
 	if (res < 0) {
 		ERROR("Failed to read block 0x%llx: %d\n", index, res);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

