Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36198C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 16:06:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-yKR5M-d-NsaqoqI0UijWpA-1; Wed, 15 Jun 2022 12:06:02 -0400
X-MC-Unique: yKR5M-d-NsaqoqI0UijWpA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A5923801F4D;
	Wed, 15 Jun 2022 16:05:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35C51404E4C7;
	Wed, 15 Jun 2022 16:05:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF2A31947054;
	Wed, 15 Jun 2022 16:05:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02A7119466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 15:57:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DBB2640334F; Wed, 15 Jun 2022 15:57:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7C2E40334D
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 15:57:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0BC783397A
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 15:57:06 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-0Wgv5ieaOOugFRCkfCsdjA-1; Wed, 15 Jun 2022 11:57:05 -0400
X-MC-Unique: 0Wgv5ieaOOugFRCkfCsdjA-1
Received: by mail-qv1-f41.google.com with SMTP id a9so9110762qvt.6
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 08:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qBdDjuNRoiyiK83BBB/2Pz0UDfBWTPayUI2ot+rneIk=;
 b=JC85u4jiMEXbd2irMSSG8fFfkfqgblH2dMt98LCZXgqHAFix4CG56NcOYFSJm7l42t
 d9iwVjJkpEhVINF32dM+OK+9GJodONcTIn4gMZh6EB1NMRur+he8DXyZUD3ittCjvgZS
 srkECGb2sWaxATrL+4HMG4YhMTya0/nun0ncGcp4OfYw+GYIZmKVqCNiTyPGZ6tNNvri
 ua6XmzmCNBUImA9XsvlhGIuIdeg5tEVu5H1pwUzxveS8J31u/gcAP6l3kYVda/mZCkD9
 I2/hoRSFGVZJg6JeaFq4opSgcJgLRRkI1VlWNTRjadgsgxeGt0g+oauti7kzqoRaMZFW
 6kwQ==
X-Gm-Message-State: AJIora9BSAdIzJTpml0aCH0Tq+HdUP36KFuZ0Fzr6eqXik8Rr7mIdiSI
 tIVrEIU0I7veGPFaoi4CtkW91t/nQZwJ7+o=
X-Google-Smtp-Source: AGRyM1sb/lGOXEW8FkiRyhb/s/sdoFnpptDGt7EcbcW5JYNdGuVjFrbV0cxrE/+qYwRIB+1Ayif1CA==
X-Received: by 2002:ad4:5c87:0:b0:464:5127:6b5b with SMTP id
 o7-20020ad45c87000000b0046451276b5bmr215420qvh.32.1655308624647; 
 Wed, 15 Jun 2022 08:57:04 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 m13-20020ac866cd000000b00304ed2c0f25sm9351684qtp.50.2022.06.15.08.57.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Jun 2022 08:57:04 -0700 (PDT)
Date: Wed, 15 Jun 2022 11:57:03 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Message-ID: <YqoBTymvHkpEEj4T@redhat.com>
References: <1655223028-3199-1-git-send-email-bmarzins@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1655223028-3199-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] dm: fix possible race in dm_start_io_acct
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 14 2022 at 12:10P -0400,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> After commit 82f6cdcc3676c ("dm: switch dm_io booleans over to proper
> flags") dm_start_io_acct stopped atomically checking and setting
> was_accounted, which turned into the DM_IO_ACCOUNTED flag. This opened
> the possibility for a race where IO accounting is started twice for
> duplicate bios. To remove the race, check the flag while holding the
> io->lock.
> 
> Fixes: 82f6cdcc3676c ("dm: switch dm_io booleans over to proper flags")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index d8f16183bf27..c7d2dbf03ccb 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -544,17 +544,20 @@ static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
>  {
>  	/*
>  	 * Ensure IO accounting is only ever started once.
> +	 * Expect no possibility for race unless DM_TIO_IS_DUPLICATE_BIO.
>  	 */
> -	if (dm_io_flagged(io, DM_IO_ACCOUNTED))
> -		return;
> -

This check ^ is best left at the top since it avoids needless locking
in the DM_TIO_IS_DUPLICATE_BIO case.

> -	/* Expect no possibility for race unless DM_TIO_IS_DUPLICATE_BIO. */
>  	if (!clone || likely(dm_tio_is_normal(clone_to_tio(clone)))) {
> +		if (WARN_ON_ONCE(dm_io_flagged(io, DM_IO_ACCOUNTED)))
> +			return;

So this can be dropped ^

>  		dm_io_set_flag(io, DM_IO_ACCOUNTED);
>  	} else {
>  		unsigned long flags;
>  		/* Can afford locking given DM_TIO_IS_DUPLICATE_BIO */
>  		spin_lock_irqsave(&io->lock, flags);
> +		if (dm_io_flagged(io, DM_IO_ACCOUNTED)) {
> +			spin_unlock_irqrestore(&io->lock, flags);
> +			return;
> +		}

Leaving only this part ^ as the necessary change to fix the race.

>  		dm_io_set_flag(io, DM_IO_ACCOUNTED);
>  		spin_unlock_irqrestore(&io->lock, flags);
>  	}

Now applied and staged in linux-next for v5.19-rc3 (or later).  I
won't rebase so this commit will remain valid:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=10eb3a0d517fcc83eeea4242c149461205675eb4

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

