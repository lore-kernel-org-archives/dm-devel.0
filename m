Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C07C64EC4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 16:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678120469;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LEUAqpAMVQLfBbXC/tSx3OwL/3xzxYscYw+WwwSPA+M=;
	b=X8hGzNjxot4a0lmGEGQgM3rM772HSZw49YU8buFGv3mtuQXmG9r3HXlNxgrSXSsgBjYs5a
	CbwZYAepX1c+l9VKFdd0beqvIbdjGzfIDrP3v9mZMpp3SEjEB6du785GPYSPpEjm5w05Ws
	fCm72iwhlN3l4+jE+db1SUVEONVZgFE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-wf1iSlA6PIqJtMBY3vHPTg-1; Mon, 06 Mar 2023 11:34:20 -0500
X-MC-Unique: wf1iSlA6PIqJtMBY3vHPTg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72C6D811E6E;
	Mon,  6 Mar 2023 16:34:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5ED42492C3E;
	Mon,  6 Mar 2023 16:34:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1645D194658D;
	Mon,  6 Mar 2023 16:34:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DCA12194658D
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 16:33:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5B07112132D; Mon,  6 Mar 2023 16:33:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE9F81121314
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 16:33:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90E36101A521
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 16:33:49 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-XPvd5GfUN8uEkYTh6R-HdA-1; Mon, 06 Mar 2023 11:33:47 -0500
X-MC-Unique: XPvd5GfUN8uEkYTh6R-HdA-1
Received: by mail-qt1-f171.google.com with SMTP id c18so11176595qte.5
 for <dm-devel@redhat.com>; Mon, 06 Mar 2023 08:33:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678120426;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=xamEf0g8UD74VgDCraQyO/0BNndSuMBoEsR2uDhIwkU=;
 b=cs7nZAIIv9pP4rOFx28HwECK/XEX5YoZkrse5abm6S5kXgcgmNwWR+CPPYuAFQaRZK
 XHjIBq3XXARWyJSZ+5k/7k6FdQj6x8KCng35KVPPLY6aD9pO9dFh5Z27xFC8Rb05gvYQ
 woMMBdiWkOxdOZQYDcIPRpxbSFaARPK667LYGz1t7ofbquCYMSAoo7BqohAX2RzTl82T
 xJpL5/egJcYibSNshpRVSfGZ2M5TpnojhVdcCj+S7pAg8YWdTavmSZ3luaOv09jbtlQE
 0aoIQaC8dneqczwHoi0s/Krjd3qyHCApkClcy4pSaQod6rlNemEwdqyA7Dn9txt90OJP
 nl4Q==
X-Gm-Message-State: AO0yUKUFzBcYS3AQuEGtGN6yX3m3jmYUea6/QVttwbdKBF4CLaoNNdkN
 WHUopx+MvhbUMvMaWmuaquPO73k=
X-Google-Smtp-Source: AK7set8Rk4NTmWA3Qft9ZSo6h+1C/ajcKootudbE5YwgUCvInVAJafOD0yPPqYG9pai1keHcJsePaA==
X-Received: by 2002:a05:622a:184:b0:3bf:d6cf:6cac with SMTP id
 s4-20020a05622a018400b003bfd6cf6cacmr18551469qtw.63.1678120426319; 
 Mon, 06 Mar 2023 08:33:46 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 l6-20020ac84a86000000b003ba11bfe4fcsm7737786qtq.28.2023.03.06.08.33.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 06 Mar 2023 08:33:45 -0800 (PST)
Date: Mon, 6 Mar 2023 11:33:44 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZAYV6OekGBVFgjAM@redhat.com>
References: <alpine.LRH.2.21.2303061115140.24847@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2303061115140.24847@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] dm-crypt: add cond_resched() to dmcrypt_write()
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
Cc: yangerkun@huawei.com, agk@redhat.com, dm-devel@redhat.com,
 yangerkun <yangerkun@huaweicloud.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 06 2023 at 11:17P -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> The loop in dmcrypt_write may be running for unbounded amount of time, 
> thus we need cond_resched() in it.
> 
> This commit fixes the following warning:
> 
> [ 3391.153255][   C12] watchdog: BUG: soft lockup - CPU#12 stuck for 23s! [dmcrypt_write/2:2897]
> ...
> [ 3391.258372][   C12] CPU: 12 PID: 2897 Comm: dmcrypt_write/2 Tainted: G             L    5.10.0+ #8
> [ 3391.267288][   C12] Hardware name: Huawei TaiShan 2280 V2/BC82AMDDA, BIOS 1.75 04/26/2021
> [ 3391.275428][   C12] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
> [ 3391.282102][   C12] pc : blk_attempt_bio_merge.part.6+0x38/0x158
> [ 3391.288080][   C12] lr : blk_attempt_plug_merge+0xc0/0x1b0
> [ 3391.293540][   C12] sp : ffff8000718abc30
> [ 3391.297530][   C12] x29: ffff8000718abc30 x28: 0000000000000000
> [ 3391.303509][   C12] x27: ffff2020361d9ac0 x26: 0000000000000001
> [ 3391.309488][   C12] x25: 0000000000000001 x24: ffff8000718abd08
> [ 3391.315467][   C12] x23: ffff0020a10dbb00 x22: 0000000000000001
> [ 3391.321445][   C12] x21: ffff8000718abe20 x20: ffff0020a10dbb00
> [ 3391.327424][   C12] x19: ffff0020aed7b040 x18: 0000000000000000
> [ 3391.333402][   C12] x17: 0000000000000000 x16: fffffdffffe00000
> [ 3391.339381][   C12] x15: 0000000000001000 x14: 0000000000000000
> [ 3391.345359][   C12] x13: 0000000000002000 x12: ffff2060011f9070
> [ 3391.351338][   C12] x11: 0000000000000001 x10: 0000000000000002
> [ 3391.357316][   C12] x9 : ffff800010586c38 x8 : ffff202009a7f200
> [ 3391.363294][   C12] x7 : ffff8000718abd00 x6 : ffff20200df33750
> [ 3391.369274][   C12] x5 : 0000000000000001 x4 : 0000000000000000
> [ 3391.375252][   C12] x3 : 0000000000000001 x2 : ffff0020a10dbb00
> [ 3391.381230][   C12] x1 : ffff0020aed7b040 x0 : 0000000000001000
> [ 3391.387210][   C12] Call trace:
> [ 3391.390338][   C12]  blk_attempt_bio_merge.part.6+0x38/0x158
> [ 3391.395970][   C12]  blk_attempt_plug_merge+0xc0/0x1b0
> [ 3391.401085][   C12]  blk_mq_submit_bio+0x398/0x550
> [ 3391.405856][   C12]  submit_bio_noacct+0x308/0x380
> [ 3391.410630][   C12]  dmcrypt_write+0x1e4/0x208 [dm_crypt]
> [ 3391.416005][   C12]  kthread+0x130/0x138
> [ 3391.419911][   C12]  ret_from_fork+0x10/0x18
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: yangerkun <yangerkun@huawei.com>
> Fixes: dc2676210c42 ("dm crypt: offload writes to thread")
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/md/dm-crypt.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-crypt.c
> +++ linux-2.6/drivers/md/dm-crypt.c
> @@ -1954,6 +1954,7 @@ pop_from_list:
>  			io = crypt_io_from_node(rb_first(&write_tree));
>  			rb_erase(&io->rb_node, &write_tree);
>  			kcryptd_io_write(io);
> +			cond_resched();
>  		} while (!RB_EMPTY_ROOT(&write_tree));
>  		blk_finish_plug(&plug);
>  	}
> 

I suggested the same here:
https://listman.redhat.com/archives/dm-devel/2023-February/053402.html

Yet yangerkun resisted it:
https://listman.redhat.com/archives/dm-devel/2023-February/053410.html

And stuck with their more throttled approach (which looks wrong to me,
shouldn't it be using time_is_after_jiffies!?)
https://listman.redhat.com/archives/dm-devel/2023-March/053473.html

Anyway, I'm inclined to take your patch, I share your views:
https://listman.redhat.com/archives/dm-devel/2023-March/053470.html

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

