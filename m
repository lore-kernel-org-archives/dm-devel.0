Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6060EC7EE2E
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998752;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=r0XWpB3tDeXcwSam12mWDP21nspmmw6AvzZB5BM4K4o=;
	b=ViCyyg7y/eHU5DJ+GieHCdU/ZwuYDyadbjaiuyjq1z7VngQujoiUhU+Cd/dO4uccfrQwgP
	lb9f9TLO3d757QJj4Dm/DGDhw8tB0g5NXjRUlqfkVF0fEo6A6A6L56Q2MIiFHtRFBSNBVQ
	5uiemT0B5LQJ14ndcAyo06Mjx6IheeA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-8x_A-i59NGSWosF-oJOsMg-1; Thu, 25 May 2023 03:12:30 -0400
X-MC-Unique: 8x_A-i59NGSWosF-oJOsMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1744C811E86;
	Thu, 25 May 2023 07:12:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03F0F40D1B67;
	Thu, 25 May 2023 07:12:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1777A19465BB;
	Thu, 25 May 2023 07:12:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D33D319465A0
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 May 2023 02:34:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 87CB7492B0B; Thu, 25 May 2023 02:34:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 803CD492B0A
 for <dm-devel@redhat.com>; Thu, 25 May 2023 02:34:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6591B85A5B5
 for <dm-devel@redhat.com>; Thu, 25 May 2023 02:34:39 +0000 (UTC)
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net
 [207.46.229.174]) by relay.mimecast.com with ESMTP id
 us-mta-606-EnITh_W2NXmA_UFzeNgpew-1; Wed, 24 May 2023 22:34:37 -0400
X-MC-Unique: EnITh_W2NXmA_UFzeNgpew-1
Received: from duoming$zju.edu.cn ( [218.12.18.236] ) by
 ajax-webmail-mail-app4 (Coremail) ; Thu, 25 May 2023 10:34:13 +0800
 (GMT+08:00)
X-Originating-IP: [218.12.18.236]
Date: Thu, 25 May 2023 10:34:13 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: duoming@zju.edu.cn
To: "Mike Snitzer" <snitzer@kernel.org>
X-Priority: 3
In-Reply-To: <ZGz9k3jnVqiO20a2@redhat.com>
References: <20230523075857.76520-1-duoming@zju.edu.cn>
 <ZGz9k3jnVqiO20a2@redhat.com>
MIME-Version: 1.0
Message-ID: <89fc5b.4de4d.18850c1b97f.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBHjAkmyW5kO_KyAw--.52218W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwIGAWRuJ94HcwAAsB
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
 CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
 daVFxhVjvjDU=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 25 May 2023 07:12:27 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: zju.edu.cn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

On Tue, 23 May 2023 13:53:23 -0400 Mike Snitzer wrote:

> > In order to improve the IO performance of the dm-crypt
> > implementation, the commit 39d42fa96ba1 ("dm crypt:
> > add flags to optionally bypass kcryptd workqueues")
> > adds tasklet to do the crypto operations.
> > 
> > The tasklet callback function kcryptd_crypt_tasklet()
> > calls kcryptd_crypt() which is an original workqueue
> > callback function that may sleep. As a result, the
> > sleep-in-atomic-context bug may happen. The process
> > is shown below.
> > 
> >    (atomic context)
> > kcryptd_crypt_tasklet()
> >   kcryptd_crypt()
> >     kcryptd_crypt_write_convert()
> >       wait_for_completion() //may sleep
> > 
> > The wait_for_completion() is a function that may sleep.
> > In order to mitigate the bug, this patch changes
> > wait_for_completion() to try_wait_for_completion().
> > 
> > Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
> > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > ---
> >  drivers/md/dm-crypt.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 8b47b913ee8..5e2b2463d87 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -2085,7 +2085,8 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
> >  	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
> >  	if (!crypt_finished && kcryptd_crypt_write_inline(cc, ctx)) {
> >  		/* Wait for completion signaled by kcryptd_async_done() */
> > -		wait_for_completion(&ctx->restart);
> > +		while (!try_wait_for_completion(&ctx->restart))
> > +			;
> >  		crypt_finished = 1;
> >  	}
> >  
> > -- 
> > 2.17.1
> > 
> 
> Cc'ing Ignat for closer review.
> 
> But wasn't this already addressed with this commit?:
> 8abec36d1274 dm crypt: do not wait for backlogged crypto request completion in softirq
> 
> Mike

Thank you for your review, I think the commit 8abec36d1274 ("dm crypt: 
do not wait for backlogged crypto request completion in softirq") could
not solve this problem.

When crypt_convert() returns BLK_STS_PROTECTION or BLK_STS_IOERR, meanwhile,
there is request that is queued and wait kcryptd_async_done() to process.
The workqueue callback function kcryptd_crypt_read_continue() will not be called.
The variable crypt_finished equals to zero, it will call wait_for_completion()
that may sleep. The relevant codes are shown below:

static blk_status_t crypt_convert(...)
{
...
		/*
		 * The request is queued and processed asynchronously,
		 * completion function kcryptd_async_done() will be called.
		 */
		case -EINPROGRESS:
			ctx->r.req = NULL;
			ctx->cc_sector += sector_step;
			tag_offset++;
			continue;
...
		/*
		 * There was a data integrity error.
		 */
		case -EBADMSG:
			atomic_dec(&ctx->cc_pending);
			return BLK_STS_PROTECTION;
		/*
		 * There was an error while processing the request.
		 */
		default:
			atomic_dec(&ctx->cc_pending);
			return BLK_STS_IOERR;
		}
...
}

static void kcryptd_crypt_write_convert(...)
{
...
	r = crypt_convert(); //return BLK_STS_PROTECTION or BLK_STS_IOERR
...
	if (r == BLK_STS_DEV_RESOURCE) { //this condition is not satisfied, the workqueue will not be called.
		INIT_WORK(&io->work, kcryptd_crypt_write_continue);
		queue_work(cc->crypt_queue, &io->work);
		return;
	}
...
        // crypt_finished is zero, because there is request that is queued and wait kcryptd_async_done() to process.
	crypt_finished = atomic_dec_and_test(&ctx->cc_pending); 
	if (!crypt_finished && kcryptd_crypt_write_inline(cc, ctx)) {
		/* Wait for completion signaled by kcryptd_async_done() */
		wait_for_completion(&ctx->restart);  //may sleep!
                ...
	}
...
}

Best regards,
Duoming Zhou




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

