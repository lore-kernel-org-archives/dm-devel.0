Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4B3C7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684864413;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kdDlQ8Cs7Bx3PoKogUG055pfl9OG3YOfD1nkGU3A69Y=;
	b=RXwyTheM6aW/9kgV2gN29S7NoYuEFSZfXuvxmjcrCPmEryO1CHoho+NZrAPWMJq7l1YA5R
	x35m4msQHcP/naddNLJENgMh1Olvr7BTwKVkHmIDgq6hwtLAn7R2m+tjDXCpdgxiNPm/Oo
	Tfdix5M9weihySCb39VNAg4fVABfjfk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-pdk69mIcPluX4pGmj2u8Iw-1; Tue, 23 May 2023 13:53:32 -0400
X-MC-Unique: pdk69mIcPluX4pGmj2u8Iw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6FF6800B2A;
	Tue, 23 May 2023 17:53:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0486F492B00;
	Tue, 23 May 2023 17:53:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CAF0C19465A8;
	Tue, 23 May 2023 17:53:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76F5419465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 17:53:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C5092166B26; Tue, 23 May 2023 17:53:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4396C2166B25
 for <dm-devel@redhat.com>; Tue, 23 May 2023 17:53:27 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 269E2380670C
 for <dm-devel@redhat.com>; Tue, 23 May 2023 17:53:27 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-NBz3VDEIPgemkMTaxD02hA-1; Tue, 23 May 2023 13:53:25 -0400
X-MC-Unique: NBz3VDEIPgemkMTaxD02hA-1
Received: by mail-qk1-f170.google.com with SMTP id
 af79cd13be357-75b0b2d0341so13463285a.3
 for <dm-devel@redhat.com>; Tue, 23 May 2023 10:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684864405; x=1687456405;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=BXyP48UZlJHqtZCaroxC4ZeuGBPVBmHVxi5WAh4UKYc=;
 b=dVNZsTreq6dUE/dSMT3MND0TJD5K+fjMyN2FBJZWH3QcR/h4U7ZUWhki+0ldQTma/R
 Qu+xX69fI74D/XQHnPOwyuf+9d/JLs7YvR0M9KgPlFagM4R9fLVKBV5fxQZeY1XvcZYL
 UKyXRNhlxagXHcRkp7v6e0oc44o0b4HkwbM+LR03b3MOgxlYq07mEQkU9M/fl1M1oOXk
 7tFZzMq7vGbjtO55/PRPsT7fEGH9pO46TInVPhgxvXrrG5n0Faj0ClHm5keaFjm2mhdv
 4p5NRfX9SAB1p7wdrdOZDH8Wd0IF9QcYW+lrTFqLf8+IB1WwnwSVlUMkoIBoUcnLoIMe
 kndQ==
X-Gm-Message-State: AC+VfDz6NZjXxu8EyWMIYHPlqV02WwxKGtdPYXvfu9b3aFo4Fl6Cwgo/
 IJZ9TcIzBycq02+6pbaddlgO4vM=
X-Google-Smtp-Source: ACHHUZ4rOayS5f+CymY4fSs5G6oZU0RuGq8SeSpkrGKuo6iEZ9yLC1EypwkS+345axZrgh+XPK8abw==
X-Received: by 2002:a05:620a:3f48:b0:75b:23a1:480 with SMTP id
 ty8-20020a05620a3f4800b0075b23a10480mr4595232qkn.70.1684864405044; 
 Tue, 23 May 2023 10:53:25 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 r29-20020a05620a03dd00b007592f2016f4sm2673771qkm.110.2023.05.23.10.53.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 10:53:24 -0700 (PDT)
Date: Tue, 23 May 2023 13:53:23 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Duoming Zhou <duoming@zju.edu.cn>
Message-ID: <ZGz9k3jnVqiO20a2@redhat.com>
References: <20230523075857.76520-1-duoming@zju.edu.cn>
MIME-Version: 1.0
In-Reply-To: <20230523075857.76520-1-duoming@zju.edu.cn>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] dm crypt: fix sleep-in-atomic-context bug in
 kcryptd_crypt_tasklet
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com,
 Ignat Korchagin <ignat@cloudflare.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 23 2023 at  3:58P -0400,
Duoming Zhou <duoming@zju.edu.cn> wrote:

> In order to improve the IO performance of the dm-crypt
> implementation, the commit 39d42fa96ba1 ("dm crypt:
> add flags to optionally bypass kcryptd workqueues")
> adds tasklet to do the crypto operations.
> 
> The tasklet callback function kcryptd_crypt_tasklet()
> calls kcryptd_crypt() which is an original workqueue
> callback function that may sleep. As a result, the
> sleep-in-atomic-context bug may happen. The process
> is shown below.
> 
>    (atomic context)
> kcryptd_crypt_tasklet()
>   kcryptd_crypt()
>     kcryptd_crypt_write_convert()
>       wait_for_completion() //may sleep
> 
> The wait_for_completion() is a function that may sleep.
> In order to mitigate the bug, this patch changes
> wait_for_completion() to try_wait_for_completion().
> 
> Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  drivers/md/dm-crypt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 8b47b913ee8..5e2b2463d87 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2085,7 +2085,8 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
>  	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
>  	if (!crypt_finished && kcryptd_crypt_write_inline(cc, ctx)) {
>  		/* Wait for completion signaled by kcryptd_async_done() */
> -		wait_for_completion(&ctx->restart);
> +		while (!try_wait_for_completion(&ctx->restart))
> +			;
>  		crypt_finished = 1;
>  	}
>  
> -- 
> 2.17.1
> 

Cc'ing Ignat for closer review.

But wasn't this already addressed with this commit?:
8abec36d1274 dm crypt: do not wait for backlogged crypto request completion in softirq

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

