Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC4DC74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 09:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680080708;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PHJes53Bj9aE2W/8WhbSdAEAPXLyjAZmRi3kjr4ElVI=;
	b=jOxPxw+2Y7EURaiN1pBrKLLjlXj2OjhP+ViIzxHBcml4asPn9ghMzWkNYt9fQPqTXji5c7
	TwsnJS3Es4q45fQWQYKm8PEk7AjhxJlmniC+GXARFE3xOsyOAismjwkWO4YKa+vJiE5Cve
	i1lJxZ5ygMe6u1EQPQysncDNtABUSYw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-KTRNlMi0NMy_1EoCb87UyQ-1; Wed, 29 Mar 2023 05:05:05 -0400
X-MC-Unique: KTRNlMi0NMy_1EoCb87UyQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47745384D037;
	Wed, 29 Mar 2023 09:05:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26FCF492C3E;
	Wed, 29 Mar 2023 09:05:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB157194658D;
	Wed, 29 Mar 2023 09:05:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D3D86194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 09:05:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6A114042AC5; Wed, 29 Mar 2023 09:05:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF4734042AC0
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 09:05:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AAC83C025BD
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 09:05:00 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-9t1z9iBWPciTvmeLEY1IDw-2; Wed, 29 Mar 2023 05:04:58 -0400
X-MC-Unique: 9t1z9iBWPciTvmeLEY1IDw-2
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; d="scan'208";a="231751498"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 17:04:56 +0800
IronPort-SDR: hXeEZgo7XD/cMOXrw0/2k/WKYFQGtnLfkhJt5T67vWF6GzPL5c6N/XiJqPPx7HF9rxmEs0HYBu
 +Xo3C1znVV29Caqpn0ITPz9HhUWhFdO1pQLL8Y9AnF+WNhYKP3ihRzuAoR4vg6DW0n0/aXoU+j
 HnOUvMU0ycHqZgUqZDEYG+NH+/n0ZkVhjfqakdkwmc0J3WznmmOp/OR1HoY+TrKGnv9TDgoock
 ORrPbHx355Lt3xK1T/ymq58uY0sWD4peccsih1hRFq51BPK0uS06DWX/URVOBvfnu8OEBDKUv6
 T4I=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 01:21:06 -0700
IronPort-SDR: PYwqpSpYtVYN9y8ZxJHYOZCZi2M3gNQh52Aro759mNAV41fRbJ6uQ1vwVO/jbDF1XwjoRI/buQ
 fpjTSJvawjmp7zaXlVpv4jTgalEUYkEu220I/tV9YB2xWQ/+AATVly7ba39hMpFNMLznbTnKOq
 UdMUZyiW4sAXogfmC8lOfAULZZt6nxu6QKmnu3Qr3GpDflIcEiIVQ2dL4mf0OgFnzfyr7O4p7J
 ewwI5FO3S0x3TBWZXOibo2/cREbUoXKgpAC7nX1ohjN4MKNwq0ZWZsTdp2cwdBfQwR3dA9FlJe
 DFE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 02:04:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pmgc75Z34z1RtVx
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 02:04:55 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 5GW0gHsXlGmT for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 02:04:54 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pmgc24vbRz1RtVm;
 Wed, 29 Mar 2023 02:04:50 -0700 (PDT)
Message-ID: <71d9f461-a708-341f-d012-d142086c026e@opensource.wdc.com>
Date: Wed, 29 Mar 2023 18:04:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084331epcas5p2510ed79d04fe3432c2ec84ce528745c6@epcas5p2.samsung.com>
 <20230327084103.21601-10-anuj20.g@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230327084103.21601-10-anuj20.g@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v8 9/9] null_blk: add support for copy offload
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
Cc: Vincent Fu <vincent.fu@samsung.com>, bvanassche@acm.org,
 joshi.k@samsung.com, gost.dev@samsung.com, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/27/23 17:40, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Implementaion is based on existing read and write infrastructure.
> 
> Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
> ---
>  drivers/block/null_blk/main.c     | 94 +++++++++++++++++++++++++++++++
>  drivers/block/null_blk/null_blk.h |  7 +++
>  2 files changed, 101 insertions(+)
> 
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index 9e6b032c8ecc..84c5fbcd67a5 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1257,6 +1257,81 @@ static int null_transfer(struct nullb *nullb, struct page *page,
>  	return err;
>  }
>  
> +static inline int nullb_setup_copy_read(struct nullb *nullb,
> +		struct bio *bio)
> +{
> +	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
> +
> +	memcpy(token->subsys, "nullb", 5);
> +	token->sector_in = bio->bi_iter.bi_sector;
> +	token->nullb = nullb;
> +	token->sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> +
> +	return 0;
> +}
> +
> +static inline int nullb_setup_copy_write(struct nullb *nullb,
> +		struct bio *bio, bool is_fua)
> +{
> +	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
> +	sector_t sector_in, sector_out;
> +	void *in, *out;
> +	size_t rem, temp;
> +	unsigned long offset_in, offset_out;
> +	struct nullb_page *t_page_in, *t_page_out;
> +	int ret = -EIO;
> +
> +	if (unlikely(memcmp(token->subsys, "nullb", 5)))
> +		return -EOPNOTSUPP;
> +	if (unlikely(token->nullb != nullb))
> +		return -EOPNOTSUPP;
> +	if (WARN_ON(token->sectors != bio->bi_iter.bi_size >> SECTOR_SHIFT))
> +		return -EOPNOTSUPP;

EOPNOTSUPP is strange. These are EINVAL, no ?.

> +
> +	sector_in = token->sector_in;
> +	sector_out = bio->bi_iter.bi_sector;
> +	rem = token->sectors << SECTOR_SHIFT;
> +
> +	spin_lock_irq(&nullb->lock);
> +	while (rem > 0) {
> +		temp = min_t(size_t, nullb->dev->blocksize, rem);
> +		offset_in = (sector_in & SECTOR_MASK) << SECTOR_SHIFT;
> +		offset_out = (sector_out & SECTOR_MASK) << SECTOR_SHIFT;
> +
> +		if (null_cache_active(nullb) && !is_fua)
> +			null_make_cache_space(nullb, PAGE_SIZE);
> +
> +		t_page_in = null_lookup_page(nullb, sector_in, false,
> +			!null_cache_active(nullb));
> +		if (!t_page_in)
> +			goto err;
> +		t_page_out = null_insert_page(nullb, sector_out,
> +			!null_cache_active(nullb) || is_fua);
> +		if (!t_page_out)
> +			goto err;
> +
> +		in = kmap_local_page(t_page_in->page);
> +		out = kmap_local_page(t_page_out->page);
> +
> +		memcpy(out + offset_out, in + offset_in, temp);
> +		kunmap_local(out);
> +		kunmap_local(in);
> +		__set_bit(sector_out & SECTOR_MASK, t_page_out->bitmap);
> +
> +		if (is_fua)
> +			null_free_sector(nullb, sector_out, true);
> +
> +		rem -= temp;
> +		sector_in += temp >> SECTOR_SHIFT;
> +		sector_out += temp >> SECTOR_SHIFT;
> +	}
> +
> +	ret = 0;
> +err:
> +	spin_unlock_irq(&nullb->lock);
> +	return ret;
> +}
> +
>  static int null_handle_rq(struct nullb_cmd *cmd)
>  {
>  	struct request *rq = cmd->rq;
> @@ -1267,6 +1342,14 @@ static int null_handle_rq(struct nullb_cmd *cmd)
>  	struct req_iterator iter;
>  	struct bio_vec bvec;
>  
> +	if (rq->cmd_flags & REQ_COPY) {
> +		if (op_is_write(req_op(rq)))
> +			return nullb_setup_copy_write(nullb, rq->bio,
> +						rq->cmd_flags & REQ_FUA);
> +		else

No need for this else.

> +			return nullb_setup_copy_read(nullb, rq->bio);
> +	}
> +
>  	spin_lock_irq(&nullb->lock);
>  	rq_for_each_segment(bvec, rq, iter) {
>  		len = bvec.bv_len;
> @@ -1294,6 +1377,14 @@ static int null_handle_bio(struct nullb_cmd *cmd)
>  	struct bio_vec bvec;
>  	struct bvec_iter iter;
>  
> +	if (bio->bi_opf & REQ_COPY) {
> +		if (op_is_write(bio_op(bio)))
> +			return nullb_setup_copy_write(nullb, bio,
> +							bio->bi_opf & REQ_FUA);
> +		else

No need for this else.

> +			return nullb_setup_copy_read(nullb, bio);
> +	}
> +
>  	spin_lock_irq(&nullb->lock);
>  	bio_for_each_segment(bvec, bio, iter) {
>  		len = bvec.bv_len;
> @@ -2146,6 +2237,9 @@ static int null_add_dev(struct nullb_device *dev)
>  	list_add_tail(&nullb->list, &nullb_list);
>  	mutex_unlock(&lock);
>  
> +	blk_queue_max_copy_sectors_hw(nullb->disk->queue, 1024);
> +	blk_queue_flag_set(QUEUE_FLAG_COPY, nullb->disk->queue);

This should NOT be unconditionally enabled with a magic value of 1K sectors. The
max copy sectors needs to be set with a configfs attribute so that we can
enable/disable the copy offload support, to be able to exercise both block layer
emulation and native device support.

> +
>  	pr_info("disk %s created\n", nullb->disk_name);
>  
>  	return 0;
> diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
> index eb5972c50be8..94e524e7306a 100644
> --- a/drivers/block/null_blk/null_blk.h
> +++ b/drivers/block/null_blk/null_blk.h
> @@ -67,6 +67,13 @@ enum {
>  	NULL_Q_MQ	= 2,
>  };
>  
> +struct nullb_copy_token {
> +	char subsys[5];
> +	struct nullb *nullb;
> +	u64 sector_in;
> +	u64 sectors;
> +};
> +
>  struct nullb_device {
>  	struct nullb *nullb;
>  	struct config_item item;

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

