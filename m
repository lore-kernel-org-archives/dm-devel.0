Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F348BC7EE2F
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480081;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1qNn0DfyJ23tDihledjnRa8cETYPcl01aGfpjtA5ZNs=;
	b=FrkXhZ0+PLL8dLkEZZ9rzOowAeQfApEtJAayUDd0rc7VziudhU8++/nFHgnt7kC0RBvV8s
	iWXitPY91qxlkDaiy7iHw5wJ0sLdRIP3jJZJl4ClLYpQRB4DP29OaGKBRzcR2CPDnjXoJh
	tCmzuR723IBi4Rcg+ivVAlmYuc3+1oY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-jtD_h_VxNMin3oGd89KV_w-1; Tue, 30 May 2023 16:54:38 -0400
X-MC-Unique: jtD_h_VxNMin3oGd89KV_w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E49785A5BF;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B6E9400DFF;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC1331946A46;
	Tue, 30 May 2023 20:54:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A581194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 06:14:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 49505421C3; Tue, 30 May 2023 06:14:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 408A4420A8
 for <dm-devel@redhat.com>; Tue, 30 May 2023 06:14:01 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B10D3803524
 for <dm-devel@redhat.com>; Tue, 30 May 2023 06:14:01 +0000 (UTC)
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-e5qLxzAzNhOovj045_HJBw-1; Tue, 30 May 2023 02:13:57 -0400
X-MC-Unique: e5qLxzAzNhOovj045_HJBw-1
X-QQ-mid: bizesmtp65t1685426547tmy4xja6
Received: from localhost.localdomain ( [113.200.76.118])
 by bizesmtp.qq.com (ESMTP) with 
 id ; Tue, 30 May 2023 14:02:24 +0800 (CST)
X-QQ-SSF: 01400000000000C0G000000A0000000
X-QQ-FEAT: znfcQSa1hKaNoAA+Wu37XwpK1cksC/6aTghWFSS0JvJasQfz+eIO2zJLQRT6i
 rEM1DjNn+cMKUMmMkYKxNVhiJ/YaqYwyOdwJn8trVVHL4FwWqRIC1gXasm0tl2QcgbOhP2j
 LvZhKTr8+O0f7WbJ7aEKXPBecA76aTyilAsJsTVqnedMXbBhFAnGHPVXjv6vLMsjW6YvPyi
 i1gtBueSiPnfPmNzUzOGPtA6xO9BEI1yiGrXZ0be9XSQujkY1RIoTVJFJr5g/q5q1gPvFUS
 ZEKOIIEP+REIXrHWhBXhZbB8seLB4k9ZUsPfQMlMU4/yyaVrRkuBNBwcOqvR1A5Vgs91htm
 UZo1RdQcwSh9F4y0PRV2IDwcHtWLTFF1d191XBv6COHtM1tov3TE4c2SwkUPUQ1WWsDxlmz
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6104239791662094715
From: gouhao@uniontech.com
To: johannes.thumshirn@wdc.com
Date: Tue, 30 May 2023 14:02:22 +0800
Message-Id: <20230530060222.14892-1-gouhao@uniontech.com>
In-Reply-To: <20230502101934.24901-5-johannes.thumshirn@wdc.com>
References: <20230502101934.24901-5-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz7a-0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: Re: [dm-devel] [PATCH v5 04/20] fs: buffer: use __bio_add_page to
 add single page to bio
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, damien.lemoal@wdc.com,
 kch@nvidia.com, agruenba@redhat.com, shaggy@kernel.org, song@kernel.org,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 cluster-devel@redhat.com, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
 rpeterso@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: uniontech.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> 
> The buffer_head submission code uses bio_add_page() to add a page to a
> newly created bio. bio_add_page() can fail, but the return value is never
> checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/buffer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a7fc561758b1..5abc26d8399d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2760,7 +2760,7 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
>  
>  	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>  
> -	bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
> +	__bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
>  	BUG_ON(bio->bi_iter.bi_size != bh->b_size);
Can `BUG_ON` be deleted now ?
>  
>  	bio->bi_end_io = end_bio_bh_io_sync;
> -- 
> 2.40.0
--
thanks,
Gou Hao

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

