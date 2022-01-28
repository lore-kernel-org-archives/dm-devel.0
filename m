Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F68C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 17:19:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-Tpr0xisPOr25WGsXB1EMzA-1; Fri, 28 Jan 2022 12:19:28 -0500
X-MC-Unique: Tpr0xisPOr25WGsXB1EMzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 011CA101F000;
	Fri, 28 Jan 2022 17:19:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B042A70D51;
	Fri, 28 Jan 2022 17:19:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5E3E81809CB8;
	Fri, 28 Jan 2022 17:19:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SHJFPS001366 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 12:19:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E611141DEEA; Fri, 28 Jan 2022 17:19:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A49B141DEE5
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 17:19:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D88C73C14652
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 17:19:14 +0000 (UTC)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
	[209.85.166.52]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-638-KM24XR69OVONqeX_XOlPLg-1; Fri, 28 Jan 2022 12:19:12 -0500
X-MC-Unique: KM24XR69OVONqeX_XOlPLg-1
Received: by mail-io1-f52.google.com with SMTP id p63so7714434iod.11
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 09:19:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
	:message-id:date:mime-version:content-transfer-encoding;
	bh=8RmVGniZmHcvwcWEDKH/kYZlMbnd/uwqHE2Oo5hNPa0=;
	b=KpIrfkAfc+iQn3J9lIQLrcm6SKZnPLgMMTBKjdgE1jPL1gQYlOmnOPGgfRwfTITKY4
	yTQe6B6/LypDVNI239Evy7Q9Q+21z6YIoS23opUpB1LluSPJKxvzNElLAHyb1lfbskO5
	5/piawAw+GukwqGowtkj2sYPIrYYdQn2KgtLe93V7b8u9dDjnYBkcDgP6pgkGSkcmFIV
	74vV/ILCAfX9EIOuOegdu1ZhHz8gHSsN5Ua5ou86L3HT0ohKnWVpHSNhdihsuHEfG6Ki
	IxctlCmS6pbn1jS6J2bEr9lS6gYUVHEqdOUePW2RI4GSEhbmTINX9eYl7GWOFbZkL8he
	utNA==
X-Gm-Message-State: AOAM532JKXoD4nRqDcgBDwZMv9TtlvRzyQykMr7T5qNY9vxFhLYQywRL
	ZN/y3cnp4rsyLyIKNtZ4QXlWBioTok+pug==
X-Google-Smtp-Source: ABdhPJwC61Mrr7nsRCUtfuUGH56jvUq/5GrMBamk5MOUSAy5rrDSO8kxyOI21Pnnj+XHPGYKtsVV7A==
X-Received: by 2002:a05:6638:12c3:: with SMTP id
	v3mr1175752jas.254.1643390351642; 
	Fri, 28 Jan 2022 09:19:11 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
	by smtp.gmail.com with ESMTPSA id
	u17sm3181407ilk.49.2022.01.28.09.19.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 28 Jan 2022 09:19:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20220128155841.39644-1-snitzer@redhat.com>
References: <20220128155841.39644-1-snitzer@redhat.com>
Message-Id: <164339035062.308241.9563111056017072139.b4-ty@kernel.dk>
Date: Fri, 28 Jan 2022 10:19:10 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v4 0/3] block/dm: fix bio-based DM IO
	accounting
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 28 Jan 2022 10:58:38 -0500, Mike Snitzer wrote:
> [this v4 is final iteration, should be "ready"...]
> 
> Hi Jens,
> 
> Just over 3 years ago, with commit a1e1cb72d9649 ("dm: fix redundant
> IO accounting for bios that need splitting") I focused too narrowly on
> fixing the reported potential for redundant accounting for IO totals.
> Which, at least mentally for me, papered over how inaccurate all other
> bio-based DM's IO accounting is for bios that get split.
> 
> [...]

Applied, thanks!

[1/3] block: add bio_start_io_acct_time() to control start_time
      commit: 5a6cd1d29f2104bd0306a0f839c8b328395b784f
[2/3] dm: revert partial fix for redundant bio-based IO accounting
      commit: b6e31a39c63e0214937c8c586faa10122913e935
[3/3] dm: properly fix redundant bio-based IO accounting
      commit: 3c4ae3478082388ae9680a932d6bfd54c10fca0d

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

