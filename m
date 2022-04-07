Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 795E7C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 08:16:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-cv_xQap-N36-uZVKan-jWQ-1; Thu, 07 Apr 2022 04:16:43 -0400
X-MC-Unique: cv_xQap-N36-uZVKan-jWQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DE77833942;
	Thu,  7 Apr 2022 08:16:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCED941636D;
	Thu,  7 Apr 2022 08:16:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F3B4194034F;
	Thu,  7 Apr 2022 08:16:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 98AEA194034E
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 08:16:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 658B514C474B; Thu,  7 Apr 2022 08:16:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 61AC614C4747
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 08:16:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48D37811E75
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 08:16:39 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-iZHsZ4iSNyWvdjTU4rbX5Q-1; Thu, 07 Apr 2022 04:16:37 -0400
X-MC-Unique: iZHsZ4iSNyWvdjTU4rbX5Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C45241F85B;
 Thu,  7 Apr 2022 08:16:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08D6613485;
 Thu,  7 Apr 2022 08:16:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wRyrM+CdTmLMCAAAMHmgww
 (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 08:16:32 +0000
Message-ID: <24bb310e-6ce2-88c9-ebdc-59d49c609d77@suse.de>
Date: Thu, 7 Apr 2022 16:16:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
To: Christoph Hellwig <hch@lst.de>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-5-hch@lst.de>
From: Coly Li <colyli@suse.de>
In-Reply-To: <20220406061228.410163-5-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Phillip Lougher <phillip@squashfs.org.uk>, linux-bcache@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/6/22 2:12 PM, Christoph Hellwig wrote:
> Remove the magic autofree semantics and require the callers to explicitly
> call bio_init to initialize the bio.
>
> This allows bio_free to catch accidental bio_put calls on bio_init()ed
> bios as well.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bio.c                        | 47 ++++++++++++------------------
>   block/blk-crypto-fallback.c        | 14 +++++----
>   block/blk-map.c                    | 42 ++++++++++++++++----------
>   drivers/block/pktcdvd.c            | 25 ++++++++--------
>   drivers/md/bcache/debug.c          | 10 ++++---
>   drivers/md/dm-bufio.c              |  9 +++---
>   drivers/md/raid1.c                 | 12 +++++---
>   drivers/md/raid10.c                | 21 ++++++++-----
>   drivers/target/target_core_pscsi.c | 10 +++----
>   fs/squashfs/block.c                | 15 +++++-----
>   include/linux/bio.h                |  2 +-
>   11 files changed, 112 insertions(+), 95 deletions(-)
[snipped]
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index 6230dfdd9286e..7510d1c983a5e 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -107,15 +107,16 @@ void bch_btree_verify(struct btree *b)
>   
>   void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>   {
> +	unsigned int nr_segs = bio_segments(bio);
>   	struct bio *check;
>   	struct bio_vec bv, cbv;
>   	struct bvec_iter iter, citer = { 0 };
>   
> -	check = bio_kmalloc(GFP_NOIO, bio_segments(bio));
> +	check = bio_kmalloc(nr_segs, GFP_NOIO);
>   	if (!check)
>   		return;
> -	bio_set_dev(check, bio->bi_bdev);
> -	check->bi_opf = REQ_OP_READ;
> +	bio_init(check, bio->bi_bdev, check->bi_inline_vecs, nr_segs,
> +		 REQ_OP_READ);
>   	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
>   	check->bi_iter.bi_size = bio->bi_iter.bi_size;
>   
> @@ -146,7 +147,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>   
>   	bio_free_pages(check);
>   out_put:
> -	bio_put(check);
> +	bio_uninit(check);
> +	kfree(check);
>   }
>   
>   #endif

[snipped]

For bcache part,

Acked-by: Coly Li <colyli@suse.de>


Coly Li



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

