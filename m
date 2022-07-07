Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146D2C43334
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 03:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657166310;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/gEA5mpldHmwcY7dMp81eaHRLkW3APwM76tSRFn9mpo=;
	b=TsTXkxR740g/r7LmTCI7LYD6j2Viv4m4/Iyk9NWbNviCkES+MiKXhPL9wF75mVckuG3EiU
	LyJLhYLZeG6rvyU7UJ/GwUWNoTwBaN4MITicPgWA64LEaJNLs3lukWaCWfjLfDYSxmroqv
	IgapHNG/ycUiM07QtQ1eYevaTWq86QM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-tBiT3gK9MpiC_k4uaCZ3VQ-1; Wed, 06 Jul 2022 23:58:27 -0400
X-MC-Unique: tBiT3gK9MpiC_k4uaCZ3VQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 034BD1C0518A;
	Thu,  7 Jul 2022 03:58:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E64B40D2853;
	Thu,  7 Jul 2022 03:58:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 524CF1947058;
	Thu,  7 Jul 2022 03:58:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5095F194704E
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 03:58:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 321BD1121320; Thu,  7 Jul 2022 03:58:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D4771121315
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 03:58:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11A20101A54E
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 03:58:24 +0000 (UTC)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-OXcBk8XvO-6gP5Mf7cVBbQ-1; Wed, 06 Jul 2022 23:58:22 -0400
X-MC-Unique: OXcBk8XvO-6gP5Mf7cVBbQ-1
Received: by mail-pg1-f177.google.com with SMTP id o18so15020206pgu.9
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 20:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JxCvx3Wm6aJVrrCk9KxbfLNMLkjb2WQRHJLc9xDV7wo=;
 b=EjfDGHHMK6ucLEdIpkirUJkjPBfafW3Cw+V6H2huZ6AxVpysBTda4pQnozTnbRFT7b
 1CI1l4AIOnx7aRrueNzr3mAjnfL8gkbNHJGPDTVJJEkMHmS2FFeRWLTKgsk74pBIpujK
 EQhkueJim0fPmJTPWeVOOrmSDm7qyyteW/t6cBLsKgjulSVcFMm3qu8h+g7orTpikwoa
 IeZh1h9yyxzs1DrHhWaPz8DBW78yg56VLXRAfsPLalrRk6/K3zwEuzKw08E9BM6I9YxH
 /pxInIpEkSy/iMRR68E2eeN5E3bxWVAbYySnCoNVHmEL72UmxYQjftwMv7z+ZTGwk0XY
 4UPw==
X-Gm-Message-State: AJIora/bOFPrOkm1CkjfQSNgGsVMvv305keq+CM+MiJQkZY5Mzh2Svrn
 kIQEDKmXy1WA5wmw6CjQb3nGEA==
X-Google-Smtp-Source: AGRyM1t4S2EttzYuHEUjp0/XnuFNsoOvI4ExjjU9puQ2Rr17H7beMyUoSMv6NJayHK6t/EwYutkiyw==
X-Received: by 2002:a17:903:1c7:b0:16a:2844:8c1f with SMTP id
 e7-20020a17090301c700b0016a28448c1fmr51071550plh.30.1657166300753; 
 Wed, 06 Jul 2022 20:58:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 c10-20020a170903234a00b0016b9b6d67a2sm17284819plh.155.2022.07.06.20.58.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 20:58:20 -0700 (PDT)
Date: Wed, 6 Jul 2022 20:58:19 -0700
From: Kees Cook <keescook@chromium.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <202207062058.49046961A4@keescook>
References: <20220627153526.3750341-1-mka@chromium.org>
 <YsWmPt7xwTlvTfAf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YsWmPt7xwTlvTfAf@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v7 0/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>, Milan Broz <gmazyland@gmail.com>,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
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

On Wed, Jul 06, 2022 at 11:11:58AM -0400, Mike Snitzer wrote:
> On Mon, Jun 27 2022 at 11:35P -0400,
> Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > As of now LoadPin restricts loading of kernel files to a single pinned
> > filesystem, typically the rootfs. This works for many systems, however it
> > can result in a bloated rootfs (and OTA updates) on platforms where
> > multiple boards with different hardware configurations use the same rootfs
> > image. Especially when 'optional' files are large it may be preferable to
> > download/install them only when they are actually needed by a given board.
> > Chrome OS uses Downloadable Content (DLC) [1] to deploy certain 'packages'
> > at runtime. As an example a DLC package could contain firmware for a
> > peripheral that is not present on all boards. DLCs use dm-verity [2] to
> > verify the integrity of the DLC content.
> > 
> > This series extends LoadPin to allow loading of kernel files from trusted
> > dm-verity devices. LoadPin maintains a list of root digests of verity
> > devices it considers trusted. Userspace can populate this list through an
> > ioctl on the new LoadPin securityfs entry 'dm-verity'. The ioctl receives
> > a file descriptor of a file with verity digests as parameter. Verity reads
> > the digests from this file after confirming that the file is located on the
> > pinned root. The digest file must contain one digest per line. The list of
> > trusted digests can only be set up once, which is typically done at boot
> > time.
> > 
> > When a kernel file is read LoadPin first checks (as usual) whether the file
> > is located on the pinned root, if so the file can be loaded. Otherwise, if
> > the verity extension is enabled, LoadPin determines whether the file is
> > located on a verity backed device and whether the root digest of that
> > device is in the list of trusted digests. The file can be loaded if the
> > verity device has a trusted root digest.
> > 
> > [1] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
> > [2] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
> 
> Hi Kees,
> 
> Please pick this series up, thanks.

Thanks for the Acks! I'll get this into -next shortly.

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

