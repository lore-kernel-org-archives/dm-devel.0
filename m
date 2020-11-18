Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819B3C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 09:13:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFC1F20715
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 09:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFC1F20715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-9iWMG5JTPteHqwmII1xjHA-1; Wed, 18 Nov 2020 04:13:51 -0500
X-MC-Unique: 9iWMG5JTPteHqwmII1xjHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DD821009440;
	Wed, 18 Nov 2020 09:13:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58F3C60C05;
	Wed, 18 Nov 2020 09:13:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E527E181A71F;
	Wed, 18 Nov 2020 09:13:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AI9DjQm022956 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 04:13:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3E80A2166BB3; Wed, 18 Nov 2020 09:13:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 396F12166BA3
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 09:13:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7B6D90E42F
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 09:13:42 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-411-0pltcT9OMX2rPaZ-S9ijkg-1;
	Wed, 18 Nov 2020 04:13:38 -0500
X-MC-Unique: 0pltcT9OMX2rPaZ-S9ijkg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 65CA0AD45;
	Wed, 18 Nov 2020 08:54:57 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-20-hch@lst.de>
From: Coly Li <colyli@suse.de>
Message-ID: <e7f826fd-cb9c-b4ab-fae8-dad398c14eed@suse.de>
Date: Wed, 18 Nov 2020 16:54:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-20-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AI9DjQm022956
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org, Jan Kara <jack@suse.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 19/20] bcache: remove a superflous
	lookup_bdev all
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/18/20 4:47 PM, Christoph Hellwig wrote:
> Don't bother to call lookup_bdev for just a slightly different error
> message without any functional change.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>ist

Hi Christoph,

NACK. This removing error message is frequently triggered and observed,
and distinct a busy device and an already registered device is important
(the first one is critical error and second one is not).

Remove such error message will be a functional regression.

Coly Li

> ---
>  drivers/md/bcache/super.c | 44 +--------------------------------------
>  1 file changed, 1 insertion(+), 43 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e5db2cdd114112..5c531ed7785280 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2380,40 +2380,6 @@ kobj_attribute_write(register,		register_bcache);
>  kobj_attribute_write(register_quiet,	register_bcache);
>  kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
>  
> -static bool bch_is_open_backing(struct block_device *bdev)
> -{
> -	struct cache_set *c, *tc;
> -	struct cached_dev *dc, *t;
> -
> -	list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
> -		list_for_each_entry_safe(dc, t, &c->cached_devs, list)
> -			if (dc->bdev == bdev)
> -				return true;
> -	list_for_each_entry_safe(dc, t, &uncached_devices, list)
> -		if (dc->bdev == bdev)
> -			return true;
> -	return false;
> -}
> -
> -static bool bch_is_open_cache(struct block_device *bdev)
> -{
> -	struct cache_set *c, *tc;
> -
> -	list_for_each_entry_safe(c, tc, &bch_cache_sets, list) {
> -		struct cache *ca = c->cache;
> -
> -		if (ca->bdev == bdev)
> -			return true;
> -	}
> -
> -	return false;
> -}
> -
> -static bool bch_is_open(struct block_device *bdev)
> -{
> -	return bch_is_open_cache(bdev) || bch_is_open_backing(bdev);
> -}
> -
>  struct async_reg_args {
>  	struct delayed_work reg_work;
>  	char *path;
> @@ -2535,15 +2501,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  				  sb);
>  	if (IS_ERR(bdev)) {
>  		if (bdev == ERR_PTR(-EBUSY)) {
> -			bdev = lookup_bdev(strim(path));
> -			mutex_lock(&bch_register_lock);
> -			if (!IS_ERR(bdev) && bch_is_open(bdev))
> -				err = "device already registered";
> -			else
> -				err = "device busy";
> -			mutex_unlock(&bch_register_lock);
> -			if (!IS_ERR(bdev))
> -				bdput(bdev);
> +			err = "device busy";
>  			if (attr == &ksysfs_register_quiet)
>  				goto done;
>  		}
> 




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

