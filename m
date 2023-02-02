Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBF9C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675356123;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P6QDQEI5GDrl40/HRD8N87VXRk5LCULTkpMeorTO870=;
	b=HIL4Vlo+qYrj/ifoliIxz2ZEekc/ueggmCW/U/DbHVI1zYqwO3laQU/sdQCpwj/Y6b3vQD
	4V6u0QArWXjvLCUa/TdGdwew7jSQ9C88D+UVAajZ0P8dbizkR2o8mrvAbdZazKjE+X6HYG
	OyB9ypQrkfQiudsQ90FeuDQHnziq3xg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-5nvYhXyxOoa1gmbGLadW4w-1; Thu, 02 Feb 2023 11:41:59 -0500
X-MC-Unique: 5nvYhXyxOoa1gmbGLadW4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00753385F36D;
	Thu,  2 Feb 2023 16:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1783F410B1ED;
	Thu,  2 Feb 2023 16:41:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA519194658C;
	Thu,  2 Feb 2023 16:41:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0DFD61946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 16:41:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 99866404BEC0; Thu,  2 Feb 2023 16:41:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 923D1404BEC1
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 16:41:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7839E87A383
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 16:41:29 +0000 (UTC)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com
 [209.85.219.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-rOSUsYiVMc6-RbRMGSgK1g-1; Thu, 02 Feb 2023 11:41:28 -0500
X-MC-Unique: rOSUsYiVMc6-RbRMGSgK1g-1
Received: by mail-qv1-f51.google.com with SMTP id u18so1301389qvv.9
 for <dm-devel@redhat.com>; Thu, 02 Feb 2023 08:41:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=1Sd/mC2dq5a1izGM43aJJbZ/EByEUvztVR2f3j4qBNU=;
 b=5acE8yBgjjYjDq+TiGtr4T9AI5p065adlpMZWTPCbpHwwn0pnxfCM+z6/15HTPMGcg
 sLt+1ebJ5/gwMKWFHDkMpy3jZxXUK4AB3rJudoQfT+vLHbuorqN5Z2lop0PjGi1UukRS
 6rOE76hT80fAAHyY51pNqBlTxV6Dphq3PuvRqo+r4HsilOk0ILD/x43z3O/exxsKSCK2
 adUDHiy76zJmZNBlxVQBS5Fu2DKSL4vHtxr44EcNPKvzsJMfMTsERHKybCywq4yvxP1i
 uatm6ieGAP54uDfIggJEju54Qs3iKUgLZrDiBlG6Esn04ddQrWg7wByd/rqY/PYgDg70
 sUKA==
X-Gm-Message-State: AO0yUKW0KlS1XM9kZFqKquDl2ZpmhR/pbpcb2XJ2SvcNXsneOh48l7s7
 9EULGdMXCKWshOfRe3rtANhjuGA=
X-Google-Smtp-Source: AK7set+4DZaHe9Eh4KBBEqljbJ8phXN/nzYGBd/kzzrMTPfJ1JNPnHtM97cxGOGqSLCdul79AmXaZg==
X-Received: by 2002:a05:6214:507:b0:53d:a0d9:979d with SMTP id
 px7-20020a056214050700b0053da0d9979dmr9978905qvb.23.1675356087336; 
 Thu, 02 Feb 2023 08:41:27 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b5-20020a05620a126500b00706b09b16fasm60292qkl.11.2023.02.02.08.41.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Feb 2023 08:41:26 -0800 (PST)
Date: Thu, 2 Feb 2023 11:41:25 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, mpatocka@redhat.com
Message-ID: <Y9vnte1xP5T+nZ6j@redhat.com>
References: <20230202012348.885402-1-nhuck@google.com>
MIME-Version: 1.0
In-Reply-To: <20230202012348.885402-1-nhuck@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] dm-verity: Remove WQ_UNBOUND.
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
 Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 01 2023 at  8:23P -0500,
Nathan Huckleberry <nhuck@google.com> wrote:

> Setting WQ_UNBOUND increases scheduler latency on ARM64.  This is likely
> due to the asymmetric architecture of ARM64 processors.
> 
> I've been unable to reproduce the results that claim WQ_UNBOUND gives a
> performance boost on x86-64.
> 
> This flag is causing performance issues for multiple subsystems within
> Android.  Notably, the same slowdown exists for decompression with
> EROFS.
> 
> | open-prebuilt-camera  | WQ_UNBOUND | ~WQ_UNBOUND   |
> |-----------------------|------------|---------------|
> | verity wait time (us) | 11746      | 119 (-98%)    |
> | erofs wait time (us)  | 357805     | 174205 (-51%) |
> 
> | sha256 ramdisk random read | WQ_UNBOUND    | ~WQ_UNBOUND |
> |----------------------------|-----------=---|-------------|
> | arm64 (accelerated)        | bw=42.4MiB/s  | bw=212MiB/s |
> | arm64 (generic)            | bw=16.5MiB/s  | bw=48MiB/s  |
> | x86_64 (generic)           | bw=233MiB/s   | bw=230MiB/s |
> 
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  drivers/md/dm-verity-target.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index ccf5b852fbf7..020fd2341025 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1399,8 +1399,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  		goto bad;
>  	}
>  
> -	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
> -	wq_flags = WQ_MEM_RECLAIM | WQ_UNBOUND;
> +	wq_flags = WQ_MEM_RECLAIM;
> +
>  	/*
>  	 * Using WQ_HIGHPRI improves throughput and completion latency by
>  	 * reducing wait times when reading from a dm-verity device.
> -- 
> 2.39.1.456.gfc5497dd1b-goog

Hi,

I've discussed with Mikulas, tweaked your patch slightly but accepted
your change, please see:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=6f30cc248507ee96c22ff4c3cbc86099ff12b7a9

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

