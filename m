Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F08C636D7
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 20:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675284401;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Wq3JoZ/3nbNMwiITl9EsQya1FtppeCaa+AHRGrWwJkk=;
	b=Ggh6ejfttWhMJD0crmT96v7YI81qyMsRbzBd1sWANljtQuKi7dtfdxqb7hvrYXx3IDYttc
	JbSh3S0l+oQ29ixIEVRJ7iLl9jK9yV64BTaohF8qK0M5CINystwwKk7xH0POWqU5zr61wD
	JmQVTX+3NYPmNmeGCcR9YJbOXcsBzYs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-1BDHYhBIMweIiOBHOog8Nw-1; Wed, 01 Feb 2023 15:46:39 -0500
X-MC-Unique: 1BDHYhBIMweIiOBHOog8Nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F37C2857D07;
	Wed,  1 Feb 2023 20:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E01A32026D4B;
	Wed,  1 Feb 2023 20:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9D5919465A4;
	Wed,  1 Feb 2023 20:46:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 79750194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 11:11:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1913B2166B34; Wed,  1 Feb 2023 11:11:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 117142166B33
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 11:11:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7E581C07588
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 11:11:05 +0000 (UTC)
Received: from smtp.tiscali.it (michael-notr.mail.tiscali.it
 [213.205.33.216]) by relay.mimecast.com with ESMTP id
 us-mta-248-0Q1ymDBoPOqWpMNte7p9XA-1; Wed, 01 Feb 2023 06:11:03 -0500
X-MC-Unique: 0Q1ymDBoPOqWpMNte7p9XA-1
Received: from [192.168.178.50] ([79.16.97.72])
 by michael.mail.tiscali.it with 
 id Fn9j2903F1ZhrJf01n9lci; Wed, 01 Feb 2023 11:09:53 +0000
x-auth-user: fantonifabio@tiscali.it
Message-ID: <d16bba68-f470-62a0-baa9-03be2882047d@tiscali.it>
Date: Wed, 1 Feb 2023 12:09:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To: Mike Snitzer <snitzer@kernel.org>, Sergei Shtepa <sergei.shtepa@veeam.com>
References: <20221209142331.26395-1-sergei.shtepa@veeam.com>
 <20221209142331.26395-3-sergei.shtepa@veeam.com>
 <Y9mrJJDFnMNWR7Vn@redhat.com>
From: Fabio Fantoni <fantonifabio@tiscali.it>
In-Reply-To: <Y9mrJJDFnMNWR7Vn@redhat.com>
X-Antivirus: Avast (VPS 230131-14, 31/1/2023), Outbound message
X-Antivirus-Status: Clean
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 01 Feb 2023 20:46:35 +0000
Subject: Re: [dm-devel] [PATCH v2 02/21] block,
 blkfilter: Block Device Filtering Mechanism
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
Reply-To: fantonifabio@tiscali.it
Cc: axboe@kernel.dk, linux-doc@vger.kernel.org, corbet@lwn.net,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Il 01/02/2023 00:58, Mike Snitzer ha scritto:
> On Fri, Dec 09 2022 at  9:23P -0500,
> Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
>
>> Allows to attach block device filters to the block devices. Kernel
>> modules can use this functionality to extend the capabilities of the
>> block layer.
>>
>> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
>> ---
>>   block/bdev.c              | 70 ++++++++++++++++++++++++++++++++++++++
>>   block/blk-core.c          | 19 +++++++++--
>>   include/linux/blk_types.h |  2 ++
>>   include/linux/blkdev.h    | 71 +++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 160 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/bdev.c b/block/bdev.c
>> index d699ecdb3260..b820178824b2 100644
>> --- a/block/bdev.c
>> +++ b/block/bdev.c
>> @@ -427,6 +427,7 @@ static void init_once(void *data)
>>   
>>   static void bdev_evict_inode(struct inode *inode)
>>   {
>> +	bdev_filter_detach(I_BDEV(inode));
>>   	truncate_inode_pages_final(&inode->i_data);
>>   	invalidate_inode_buffers(inode); /* is it needed here? */
>>   	clear_inode(inode);
>> @@ -502,6 +503,7 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
>>   		return NULL;
>>   	}
>>   	bdev->bd_disk = disk;
>> +	bdev->bd_filter = NULL;
>>   	return bdev;
>>   }
>>   
>> @@ -1092,3 +1094,71 @@ void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
>>   
>>   	blkdev_put_no_open(bdev);
>>   }
>> +
>> +/**
>> + * bdev_filter_attach - Attach the filter to the original block device.
>> + * @bdev:
>> + *	Block device.
>> + * @flt:
>> + *	Filter that needs to be attached to the block device.
>> + *
>> + * Before adding a filter, it is necessary to initialize &struct bdev_filter
>> + * using a bdev_filter_init() function.
>> + *
>> + * The bdev_filter_detach() function allows to detach the filter from the block
>> + * device.
>> + *
>> + * Return: 0 if succeeded, or -EALREADY if the filter already exists.
>> + */
>> +int bdev_filter_attach(struct block_device *bdev,
>> +				     struct bdev_filter *flt)
>> +{
>> +	int ret = 0;
>> +
>> +	blk_mq_freeze_queue(bdev->bd_queue);
>> +	blk_mq_quiesce_queue(bdev->bd_queue);
>> +
>> +	if (bdev->bd_filter)
>> +		ret = -EALREADY;
>> +	else
>> +		bdev->bd_filter = flt;
>> +
>> +	blk_mq_unquiesce_queue(bdev->bd_queue);
>> +	blk_mq_unfreeze_queue(bdev->bd_queue);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(bdev_filter_attach);
>> +
>> +/**
>> + * bdev_filter_detach - Detach the filter from the block device.
>> + * @bdev:
>> + *	Block device.
>> + *
>> + * The filter should be added using the bdev_filter_attach() function.
>> + *
>> + * Return: 0 if succeeded, or -ENOENT if the filter was not found.
>> + */
>> +int bdev_filter_detach(struct block_device *bdev)
>> +{
>> +	int ret = 0;
>> +	struct bdev_filter *flt = NULL;
>> +
>> +	blk_mq_freeze_queue(bdev->bd_queue);
>> +	blk_mq_quiesce_queue(bdev->bd_queue);
>> +
>> +	flt = bdev->bd_filter;
>> +	if (flt)
>> +		bdev->bd_filter = NULL;
>> +	else
>> +		ret = -ENOENT;
>> +
>> +	blk_mq_unquiesce_queue(bdev->bd_queue);
>> +	blk_mq_unfreeze_queue(bdev->bd_queue);
>> +
>> +	if (flt)
>> +		bdev_filter_put(flt);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(bdev_filter_detach);
> What about bio-based devices? (DM, MD, etc)
>
> DM uses freeze_bdev() and thaw_bdev(), seems like you're missing some
> work here.
>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 5487912befe8..284b295a7b23 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -678,9 +678,24 @@ void submit_bio_noacct_nocheck(struct bio *bio)
>>   	 * to collect a list of requests submited by a ->submit_bio method while
>>   	 * it is active, and then process them after it returned.
>>   	 */
>> -	if (current->bio_list)
>> +	if (current->bio_list) {
>>   		bio_list_add(&current->bio_list[0], bio);
>> -	else if (!bio->bi_bdev->bd_disk->fops->submit_bio)
>> +		return;
>> +	}
>> +
>> +	if (bio->bi_bdev->bd_filter && !bio_flagged(bio, BIO_FILTERED)) {
> Shouldn't this be: if (unlikely(...))?
>
> But that obviously assumes a fair amount about the only consumer
> (temporary filter that lasts as long as it takes to do a backup).
>
>> +		bool pass;
>> +
>> +		pass = bio->bi_bdev->bd_filter->fops->submit_bio_cb(bio);
>> +		bio_set_flag(bio, BIO_FILTERED);
>> +		if (!pass) {
>> +			bio->bi_status = BLK_STS_OK;
>> +			bio_endio(bio);
>> +			return;
>> +		}
>> +	}
>> +
>> +	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
>>   		__submit_bio_noacct_mq(bio);
>>   	else
>>   		__submit_bio_noacct(bio);
> And you currently don't allow for blkfilter to be involved if a bio
> recurses (which is how bio splitting works now).  Not sure it
> matters, just mentioning it...
Hi, thanks for review this project that I think is very useful and I 
hope it will be able to reach a very good quality, that will be 
integrated into the kernel and that more backup solutions will use it 
improving backups on linux in several cases.
In the last month Sergei made big changes, applying Christoph Hellwig 
changes and working following the received replies, the new version of 
the patch is not ready yet but the many changes done for now are 
available here: https://github.com/SergeiShtepa/linux/commits/blksnap-master
I suppose that full review now of v2 when many things was already 
changed for next version can risk to waste time. I hope I've helped with 
this, if I haven't, sorry to have bother you.
>
> But taking a step back, in the hopes of stepping out of your way:
>
> Myself and others on the DM team (past and present) have always hoped
> all block devices could have the flexibility of DM. It was that hope
> that caused my frustration when I first saw your blkfilter approach.
>
> But I was too idealistic that a byproduct of your efforts
> (blk-interposer before and blkfilter now) would usher in _all_ block
> devices being able to comprehensively change their identity (and IO
> processing) like DM enjoys.
>
> DM showcases all the extra code needed to achieve its extreme IO
> remapping and stacking flexibilty -- I don't yet see a way to distill
> the essence of what DM achieves without imposing too much on all block
> core.
>
> So I do think blkfilter is a pragmatic way to achieve your goals.
>
> Mike
>
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

