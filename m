Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE05C678D5
	for <dm-devel@archiver.kernel.org>; Wed,  8 Mar 2023 20:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678307257;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f/xaVGX4Bd352EceeUYKJqDaqXALSR1dKr3kSUm7TE8=;
	b=D2AGDg2HrxCNW3dq1U38jK6qJmft9y8QsLl2ebcL3TR1JeGpuRfX36hGRCHEm/RyFKKURc
	2NgGWIm4WxN8qBbhjNskW+q4W/rza8OWC3SjDUGyEyNeePcfI3/cP/lzaBKT+nlgoS42l7
	3LGzbQxWOcc43NndADTGvtTX+4R7apA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-u24TOrbmMjyXE5S79V9LvA-1; Wed, 08 Mar 2023 15:27:34 -0500
X-MC-Unique: u24TOrbmMjyXE5S79V9LvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D4FE811E6E;
	Wed,  8 Mar 2023 20:27:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C52C2026D4B;
	Wed,  8 Mar 2023 20:27:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1DBA419465BD;
	Wed,  8 Mar 2023 20:27:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE36319465B5
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Mar 2023 20:27:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A24A82026D68; Wed,  8 Mar 2023 20:27:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AFA22026D4B
 for <dm-devel@redhat.com>; Wed,  8 Mar 2023 20:27:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A3D2811E9C
 for <dm-devel@redhat.com>; Wed,  8 Mar 2023 20:27:29 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-vC81anm-NxiMgyqEW26OiQ-1; Wed, 08 Mar 2023 15:27:25 -0500
X-MC-Unique: vC81anm-NxiMgyqEW26OiQ-1
Received: by mail-qt1-f175.google.com with SMTP id s12so19473437qtq.11
 for <dm-devel@redhat.com>; Wed, 08 Mar 2023 12:27:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678307245;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=/20KFgVaCbhWkWSenGGB1/+L4QwyO4onHWnKBRgUBYg=;
 b=S7havGZWmGtLdvb+Myc2vMWx6LGPrHzGDnyVxF+SMj5cBv2OSKpDTb5zhoD7FjzVzB
 bUluAO4t15Y3zA2wqiNT9CvRYsrHhiS6aJnVRyJLH4aBdkzkQAPXbB2MDZCbSLEklHAX
 L2ieoUiPDE/1RA0NiwUDsfeNGg5DD9lalNc8n+V2yf8aPwn4DZF183aUufaZY4avuoCR
 U4Aj6wDHuHF8yVnCn2qiY8JtkXVtvQLX0l7z4BHaC7mJm95y66QQpM9kIy+dhePsLzte
 aLtRjMGUxYEJQ1bom1mYbZ5LEfEHtOV1n6EmnqJn6hLcn2xb+QcuTwbDWi5xW0PAuFsg
 cJZA==
X-Gm-Message-State: AO0yUKUs/qkJq2BbDaVbkOYqsHY0S6n6wVASAqZZE5GfkeC0Bs6U5GyQ
 Sg+ZUgDkUtbjPftWK7bYrISeCAY=
X-Google-Smtp-Source: AK7set8dvB/4qMr6vHsWzlPUWYLio3NToqIGBeL1emVliBR6VVv4EP/mehECjD/DgA1nrifWFI+ZZA==
X-Received: by 2002:ac8:57cd:0:b0:3bf:be20:544c with SMTP id
 w13-20020ac857cd000000b003bfbe20544cmr32142596qta.39.1678307245376; 
 Wed, 08 Mar 2023 12:27:25 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b6-20020ac801c6000000b003bd1a798f76sm12123795qtg.37.2023.03.08.12.27.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Mar 2023 12:27:24 -0800 (PST)
Date: Wed, 8 Mar 2023 15:27:23 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Ignat Korchagin <ignat@cloudflare.com>,
	Hou Tao <houtao@huaweicloud.com>
Message-ID: <ZAjvqz5pWf8aSkJ7@redhat.com>
References: <20230306134930.2878660-1-houtao@huaweicloud.com>
 <ZAY/o9ew9AtrCLE5@redhat.com>
 <e9b61952-98a8-6e3b-2d85-6aaf07208a7b@huaweicloud.com>
 <ZAdOgUdqwLpUyPlc@redhat.com>
 <6c2d07bf-828e-3aeb-3c02-6cdfd6e36ff3@huaweicloud.com>
 <CALrw=nFrbWF2ZhQtK9gx5ZFHK4Cd9outwEQqByJgmb7ryOoCgA@mail.gmail.com>
 <ZAjfu0R7rv45J3Dr@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZAjfu0R7rv45J3Dr@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] dm crypt: initialize tasklet in crypt_io_init()
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, houtao1@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 08 2023 at  2:19P -0500,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Wed, Mar 08 2023 at  8:55P -0500,
> Ignat Korchagin <ignat@cloudflare.com> wrote:
> 
> > Perhaps instead we can just pass an additional flag from
> > tasklet_schedule to indicate to the function that we're running in a
> > tasklet. I originally have chosen the tasklet_trylock/unlock hack to
> > avoid passing an extra flag. But unitialized memory makes sense as
> > well as the desire to avoid calling tasklet_init unconditionally. So
> > an extra member in dm_crypt_io might be the most straightforward here.
> 
> ... I think we should certainly evaluate the use of an extra flag.
> 
> Ignat: I'll have a look at implementing it but if you have a patch
> already developed please do share.

I've staged the following in linux-next for 6.3 via the linux-dm.git,
but if you see anything wrong with it I can obviously fix:

From: Mike Snitzer <snitzer@kernel.org>
Date: Wed, 8 Mar 2023 14:39:54 -0500
Subject: [PATCH] dm crypt: avoid accessing uninitialized tasklet

When neither "no_read_workqueue" nor "no_write_workqueue" are enabled,
tasklet_trylock() in crypt_dec_pending() may still return false due to
an uninitialized state, and dm-crypt will unnecessarily do io completion
in io_queue workqueue instead of current context.

Fix this by adding an 'in_tasklet' flag to dm_crypt_io struct and
initialize it to false in crypt_io_init(). Set this flag to true in
kcryptd_queue_crypt() before calling tasklet_schedule(). If set
crypt_dec_pending() will punt io completion to a workqueue.

This also nicely avoids the tasklet_trylock/unlock hack when tasklets
aren't in use.

Fixes: 8e14f610159d ("dm crypt: do not call bio_endio() from the dm-crypt tasklet")
Cc: stable@vger.kernel.org
Reported-by: Hou Tao <houtao1@huawei.com>
Suggested-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index faba1be572f9..de08ff4f7c98 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -72,7 +72,9 @@ struct dm_crypt_io {
 	struct crypt_config *cc;
 	struct bio *base_bio;
 	u8 *integrity_metadata;
-	bool integrity_metadata_from_pool;
+	bool integrity_metadata_from_pool:1;
+	bool in_tasklet:1;
+
 	struct work_struct work;
 	struct tasklet_struct tasklet;
 
@@ -1731,6 +1733,7 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
+	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1777,8 +1780,7 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	 * our tasklet. In this case we need to delay bio_endio()
 	 * execution to after the tasklet is done and dequeued.
 	 */
-	if (tasklet_trylock(&io->tasklet)) {
-		tasklet_unlock(&io->tasklet);
+	if (!io->in_tasklet) {
 		bio_endio(base_bio);
 		return;
 	}
@@ -2233,6 +2235,7 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_hardirq() || irqs_disabled()) {
+			io->in_tasklet = true;
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;
-- 
2.37.1 (Apple Git-137.1)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

