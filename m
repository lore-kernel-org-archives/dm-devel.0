Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B53C77B7C
	for <dm-devel@archiver.kernel.org>; Thu,  4 May 2023 06:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683182833;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VYHPQO1WGuVF1HFuVFB7zF2XyDxoS8Gg6YY9F29LUhs=;
	b=f8Qmwo5/oyQ4/zvpJG/0k3HsawM6B0K74FL/vL6U+U0IH5v7jV3bviVCQWY76c3SpQt/aq
	4BDt4BOtAadA+UOkcf2mllTsy72oT0+mFTTiPfpRMlP5HkaEJazIs7snesUhnt4gz13lZk
	clQ3CIeZcEIGJSdvyh6l3PHEGJWK+WM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-gVmgWMEkNxCqb4rihJ7IEw-1; Thu, 04 May 2023 02:47:09 -0400
X-MC-Unique: gVmgWMEkNxCqb4rihJ7IEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C722F185A78B;
	Thu,  4 May 2023 06:47:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BC5A63F3E;
	Thu,  4 May 2023 06:47:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 537B619465BC;
	Thu,  4 May 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1F601946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  2 May 2023 11:51:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5271C15BB8; Tue,  2 May 2023 11:51:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD6DAC15BAE
 for <dm-devel@redhat.com>; Tue,  2 May 2023 11:51:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91F99280AA24
 for <dm-devel@redhat.com>; Tue,  2 May 2023 11:51:05 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-pEUyYW8qMAWrixmzSnICiw-1; Tue, 02 May 2023 07:51:04 -0400
X-MC-Unique: pEUyYW8qMAWrixmzSnICiw-1
Received: by mail-qt1-f199.google.com with SMTP id
 d75a77b69052e-3ef3ca5b5afso49413391cf.0
 for <dm-devel@redhat.com>; Tue, 02 May 2023 04:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683028264; x=1685620264;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=kdZho8b0P96S/DuDI1xyFnU41Cvk0heUauLxuFmvVg0=;
 b=dK9ivzrOgvEtkRWDDmttTRyvymgunUzM/UTVaruUP9S9+DX/UoLNAjdqJzMH6ECA5t
 JS55zC0cSjPlH1YSVoNxvyAoBZ3j0VSaxCcn03t2zxpSDJTiednNRiA+1eJEqJT7tpkL
 wFX+j8123c3MSwPERuoJwVLfxSVSI7RnZ5jfAxpiyesWCs39buWXRluPZfLouOKbJXPH
 1dlAkki/ibhVSvK+PtmvnjUQ7sirTrFhx2hEf7aONWWZs7kQBc3DYf8BE4g66p7y/pbK
 A8Yph06lJZJqzb80Kpmg53X7HZBuFYE8Wi7RtS31WYdnTX8jHVzDUicO1rxxrLrccry9
 aNdA==
X-Gm-Message-State: AC+VfDx+an+3rKmVr5Rdoo0J3T9XbOrMvdgsq9+uoUVN8/GnnDu8O7Bn
 DNad89umPVCohpQwx6AGzCP8NpMjjGbhD7Wf16eNjMRORoSB8Q/77uciTHKR1tVdGn/l0NBXmDr
 gDURJQv0F2AjyjvE=
X-Received: by 2002:a05:622a:30f:b0:3ef:337b:4fcb with SMTP id
 q15-20020a05622a030f00b003ef337b4fcbmr28295412qtw.64.1683028264042; 
 Tue, 02 May 2023 04:51:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Vrqw+pKj/0O/fsSqYR2NNR+qseAedVJ76NoenSc8LVgBigL4KUU+oPaikQc4zPyJmE8NtjQ==
X-Received: by 2002:a05:622a:30f:b0:3ef:337b:4fcb with SMTP id
 q15-20020a05622a030f00b003ef337b4fcbmr28295396qtw.64.1683028263837; 
 Tue, 02 May 2023 04:51:03 -0700 (PDT)
Received: from ?IPV6:2601:883:c200:210:6ae9:ce2:24c9:b87b?
 ([2601:883:c200:210:6ae9:ce2:24c9:b87b])
 by smtp.gmail.com with ESMTPSA id
 fd9-20020a05622a4d0900b003d65e257f10sm6632958qtb.79.2023.05.02.04.51.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 02 May 2023 04:51:02 -0700 (PDT)
Message-ID: <5f3ddda1-2c7d-811c-ffd5-5fc237def2eb@redhat.com>
Date: Tue, 2 May 2023 07:51:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "axboe @ kernel . dk" <axboe@kernel.dk>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
 <20230502101934.24901-10-johannes.thumshirn@wdc.com>
From: Bob Peterson <rpeterso@redhat.com>
In-Reply-To: <20230502101934.24901-10-johannes.thumshirn@wdc.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 04 May 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH v5 09/20] gfs2: use __bio_add_page for adding
 single page to bio
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
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, kch@nvidia.com,
 agruenba@redhat.com, shaggy@kernel.org, song@kernel.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, snitzer@kernel.org,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 cluster-devel@redhat.com, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/2/23 6:19 AM, Johannes Thumshirn wrote:
> The GFS2 superblock reading code uses bio_add_page() to add a page to a
> newly created bio. bio_add_page() can fail, but the return value is never
> checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/gfs2/ops_fstype.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 9af9ddb61ca0..cd962985b058 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -254,7 +254,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
>   
>   	bio = bio_alloc(sb->s_bdev, 1, REQ_OP_READ | REQ_META, GFP_NOFS);
>   	bio->bi_iter.bi_sector = sector * (sb->s_blocksize >> 9);
> -	bio_add_page(bio, page, PAGE_SIZE, 0);
> +	__bio_add_page(bio, page, PAGE_SIZE, 0);
>   
>   	bio->bi_end_io = end_bio_io_page;
>   	bio->bi_private = page;
Hi Johannes,

So...I see 6 different calls to bio_add_page() in gfs2.
Why change this particular bio_add_page() to __bio_add_page() and not 
the other five?

Regards,

Bob Peterson

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

