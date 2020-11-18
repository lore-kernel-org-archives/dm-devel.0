Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EFDC64E7B
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 542B320715
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 542B320715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-dRdszY09NIWuVr2-13y8kw-1; Wed, 18 Nov 2020 16:34:50 -0500
X-MC-Unique: dRdszY09NIWuVr2-13y8kw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21C3C18B9F29;
	Wed, 18 Nov 2020 21:34:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F046A60875;
	Wed, 18 Nov 2020 21:34:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C702C86BE8;
	Wed, 18 Nov 2020 21:34:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AILYXqh000562 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 16:34:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2AEAAA9F36; Wed, 18 Nov 2020 21:34:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25CECA9F1E
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 21:34:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13713801E6B
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 21:34:33 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-7-BRcKs9GSNpKARfl4w9JpsQ-1;
	Wed, 18 Nov 2020 16:34:28 -0500
X-MC-Unique: BRcKs9GSNpKARfl4w9JpsQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 53C3FB019;
	Wed, 18 Nov 2020 21:34:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 716231E1328; Wed, 18 Nov 2020 15:41:05 +0100 (CET)
Date: Wed, 18 Nov 2020 15:41:05 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201118144105.GM1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-9-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-9-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 08/20] init: refactor devt_from_partuuid
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 18-11-20 09:47:48, Christoph Hellwig wrote:
> The code in devt_from_partuuid is very convoluted.  Refactor a bit by
> sanitizing the goto and variable name usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  init/do_mounts.c | 68 ++++++++++++++++++++++--------------------------
>  1 file changed, 31 insertions(+), 37 deletions(-)
> 
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index aef2f24461c7f1..afa26a4028d25e 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -105,13 +105,10 @@ static int match_dev_by_uuid(struct device *dev, const void *data)
>   */
>  static dev_t devt_from_partuuid(const char *uuid_str)
>  {
> -	dev_t res = 0;
>  	struct uuidcmp cmp;
>  	struct device *dev = NULL;
> -	struct gendisk *disk;
> -	struct hd_struct *part;
> +	dev_t devt = 0;
>  	int offset = 0;
> -	bool clear_root_wait = false;
>  	char *slash;
>  
>  	cmp.uuid = uuid_str;
> @@ -120,52 +117,49 @@ static dev_t devt_from_partuuid(const char *uuid_str)
>  	/* Check for optional partition number offset attributes. */
>  	if (slash) {
>  		char c = 0;
> +
>  		/* Explicitly fail on poor PARTUUID syntax. */
> -		if (sscanf(slash + 1,
> -			   "PARTNROFF=%d%c", &offset, &c) != 1) {
> -			clear_root_wait = true;
> -			goto done;
> -		}
> +		if (sscanf(slash + 1, "PARTNROFF=%d%c", &offset, &c) != 1)
> +			goto clear_root_wait;
>  		cmp.len = slash - uuid_str;
>  	} else {
>  		cmp.len = strlen(uuid_str);
>  	}
>  
> -	if (!cmp.len) {
> -		clear_root_wait = true;
> -		goto done;
> -	}
> +	if (!cmp.len)
> +		goto clear_root_wait;
>  
> -	dev = class_find_device(&block_class, NULL, &cmp,
> -				&match_dev_by_uuid);
> +	dev = class_find_device(&block_class, NULL, &cmp, &match_dev_by_uuid);
>  	if (!dev)
> -		goto done;
> -
> -	res = dev->devt;
> +		return 0;
>  
> -	/* Attempt to find the partition by offset. */
> -	if (!offset)
> -		goto no_offset;
> +	if (offset) {
> +		/*
> +		 * Attempt to find the requested partition by adding an offset
> +		 * to the partition number found by UUID.
> +		 */
> +		struct hd_struct *part;
>  
> -	res = 0;
> -	disk = part_to_disk(dev_to_part(dev));
> -	part = disk_get_part(disk, dev_to_part(dev)->partno + offset);
> -	if (part) {
> -		res = part_devt(part);
> -		put_device(part_to_dev(part));
> +		part = disk_get_part(dev_to_disk(dev),
> +				     dev_to_part(dev)->partno + offset);
> +		if (part) {
> +			devt = part_devt(part);
> +			put_device(part_to_dev(part));
> +		}
> +	} else {
> +		devt = dev->devt;
>  	}
>  
> -no_offset:
>  	put_device(dev);
> -done:
> -	if (clear_root_wait) {
> -		pr_err("VFS: PARTUUID= is invalid.\n"
> -		       "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
> -		if (root_wait)
> -			pr_err("Disabling rootwait; root= is invalid.\n");
> -		root_wait = 0;
> -	}
> -	return res;
> +	return devt;
> +
> +clear_root_wait:
> +	pr_err("VFS: PARTUUID= is invalid.\n"
> +	       "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
> +	if (root_wait)
> +		pr_err("Disabling rootwait; root= is invalid.\n");
> +	root_wait = 0;
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

