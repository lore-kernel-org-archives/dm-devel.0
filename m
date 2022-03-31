Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4BDC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 16:40:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-zlPdEmsfO3SanvqpxJ-u1Q-1; Thu, 31 Mar 2022 12:40:35 -0400
X-MC-Unique: zlPdEmsfO3SanvqpxJ-u1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43CEE1C0515D;
	Thu, 31 Mar 2022 16:40:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E12FB2166B26;
	Thu, 31 Mar 2022 16:40:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C17E61947BBB;
	Thu, 31 Mar 2022 16:40:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E257B19451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 16:40:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1C2B40CFD05; Thu, 31 Mar 2022 16:40:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD73C40CFD02
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 16:40:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B816E803D7A
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 16:40:31 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-TSmqmBA8M7eeF9BFC0ckFQ-1; Thu, 31 Mar 2022 12:40:29 -0400
X-MC-Unique: TSmqmBA8M7eeF9BFC0ckFQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 055E168AFE; Thu, 31 Mar 2022 18:40:25 +0200 (CEST)
Date: Thu, 31 Mar 2022 18:40:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Qian Cai <quic_qiancai@quicinc.com>
Message-ID: <20220331164024.GA30404@lst.de>
References: <20220308061551.737853-1-hch@lst.de> <YkXYMGGbk/ZTbGaA@qian>
MIME-Version: 1.0
In-Reply-To: <YkXYMGGbk/ZTbGaA@qian>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] cleanup bio_kmalloc v2
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This should fix it:

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

