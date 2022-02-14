Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1495CC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142--0rcVfhCPXiSIIZ3iqMlBw-1; Mon, 14 Feb 2022 03:48:02 -0500
X-MC-Unique: -0rcVfhCPXiSIIZ3iqMlBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 806DB814246;
	Mon, 14 Feb 2022 08:47:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 400E0106F775;
	Mon, 14 Feb 2022 08:47:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 278E54BB7C;
	Mon, 14 Feb 2022 08:47:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8U6Ue008947 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:30:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4031753C8; Mon, 14 Feb 2022 08:30:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A39F53CE
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:30:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 989D68047D6
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:30:02 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
	[45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-197-BJGxrzQ8OMyVoVjXyQbseg-1; Mon, 14 Feb 2022 03:29:58 -0500
X-MC-Unique: BJGxrzQ8OMyVoVjXyQbseg-1
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Jxy4D5pH9z8wd3;
	Mon, 14 Feb 2022 16:26:36 +0800 (CST)
Received: from [10.174.178.134] (10.174.178.134) by
	canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.21; Mon, 14 Feb 2022 16:29:53 +0800
To: <dm-devel@redhat.com>
References: <20220209093751.2986716-1-yi.zhang@huawei.com>
From: Zhang Yi <yi.zhang@huawei.com>
Message-ID: <0410123a-5da5-073a-fa08-f0038870b464@huawei.com>
Date: Mon, 14 Feb 2022 16:29:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20220209093751.2986716-1-yi.zhang@huawei.com>
X-Originating-IP: [10.174.178.134]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
	canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
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
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Cc: linux-block@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com,
	agk@redhat.com, yukuai3@huawei.com
Subject: Re: [dm-devel] [PATCH] dm: make sure dm_table is binded before
	queue request
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Friendly ping.

On 2022/2/9 17:37, Zhang Yi wrote:
> We found a NULL pointer dereference problem when using dm-mpath target.
> The problem is if we submit IO between loading and binding the table,
> we could neither get a valid dm_target nor a valid dm table when
> submitting request in dm_mq_queue_rq(). BIO based dm target could
> handle this case in dm_submit_bio(). This patch fix this by checking
> the mapping table before submitting request.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  drivers/md/dm-rq.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 579ab6183d4d..af2cf71519e9 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -499,8 +499,15 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  
>  	if (unlikely(!ti)) {
>  		int srcu_idx;
> -		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
> -
> +		struct dm_table *map;
> +
> +		map = dm_get_live_table(md, &srcu_idx);
> +		if (!map) {
> +			DMERR_LIMIT("%s: mapping table unavailable, erroring io",
> +				    dm_device_name(md));
> +			dm_put_live_table(md, srcu_idx);
> +			return BLK_STS_IOERR;
> +		}
>  		ti = dm_table_find_target(map, 0);
>  		dm_put_live_table(md, srcu_idx);
>  	}
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

