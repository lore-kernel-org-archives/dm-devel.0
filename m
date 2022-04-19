Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C788FC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 02:34:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-_zlNzgb5MFqUi_RTMJlulw-1; Mon, 18 Apr 2022 22:34:20 -0400
X-MC-Unique: _zlNzgb5MFqUi_RTMJlulw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A074838025F0;
	Tue, 19 Apr 2022 02:34:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34CB9465196;
	Tue, 19 Apr 2022 02:34:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E22CF1947BBD;
	Tue, 19 Apr 2022 02:34:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E798F1947BBB
 for <dm-devel@listman.corp.redhat.com>; Tue, 19 Apr 2022 02:34:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BB2520239EF; Tue, 19 Apr 2022 02:34:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 872AE20239EE
 for <dm-devel@redhat.com>; Tue, 19 Apr 2022 02:34:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2466F18A6586
 for <dm-devel@redhat.com>; Tue, 19 Apr 2022 02:34:00 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-5xG1Z1zMN3qCVxqAAt8faA-1; Mon, 18 Apr 2022 22:33:58 -0400
X-MC-Unique: 5xG1Z1zMN3qCVxqAAt8faA-1
Received: by mail-pg1-f171.google.com with SMTP id k29so22288300pgm.12
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 19:33:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=j9cziDR8TTkRRjQK85vGUcJr91F0j+7nYT1sRtOWrYo=;
 b=alp996xcunIx2IgYjo57NTYQSugqLgI3CWsJrFGEvN/BPmZcx9NNZihFWNPWRB1WH5
 MpK8MZ402ZkCtekxRRO0Cz0fzygATn7PJnmkrRpoF78VRFyVITA2QpaPm1q0eSuJ8Wxo
 pvbyo69IOmacLEWrmtUxUXQSLf1uOiGpoW3DsLDUF2ScI+cVcufxn92mCkTzkHQtuh51
 /Fzqzlp2/wo5HeD0n4QbZcJlXsKoSzsxS1AQP4V4PEL4ySWH4KwlUdnihuSo0g/Vp6R7
 lxmQEN/pAnctwOfzXwVnebJO/mw963f/75zac7fcYTqGRX6DbzvliTo6F9CWATEAXUso
 jYog==
X-Gm-Message-State: AOAM533eLNXLT61DnheFxrhnv5SUdx1DgwYvUFHuHhXucm4Wx7/X73a6
 Kh7+kX2avMc/79GWAorcqXGPHw==
X-Google-Smtp-Source: ABdhPJxbQz3Vu6hsTbGBYxojsApKIqv4MmFTFy5f9XEVo+IQP8mxZsJhUUcVYLGxcRcQXCRGbyuF/A==
X-Received: by 2002:a63:f341:0:b0:39d:3ce2:fc8d with SMTP id
 t1-20020a63f341000000b0039d3ce2fc8dmr12314343pgj.441.1650335637120; 
 Mon, 18 Apr 2022 19:33:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 y131-20020a626489000000b00505a8f36965sm13955880pfb.184.2022.04.18.19.33.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Apr 2022 19:33:56 -0700 (PDT)
Date: Mon, 18 Apr 2022 19:33:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <202204181931.A618DFF2C@keescook>
References: <20220418211559.3832724-1-mka@chromium.org>
 <202204181512.DA0C0C6EBD@keescook> <Yl3pj72hM/Bo+Kf5@google.com>
MIME-Version: 1.0
In-Reply-To: <Yl3pj72hM/Bo+Kf5@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 0/3] LoadPin: Enable loading from trusted
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
Cc: Douglas Anderson <dianders@chromium.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 18, 2022 at 03:43:27PM -0700, Matthias Kaehlcke wrote:
> Hi Kees,
> 
> On Mon, Apr 18, 2022 at 03:14:14PM -0700, Kees Cook wrote:
> > [oops, resending to actual CC list]
> > 
> > On Mon, Apr 18, 2022 at 02:15:56PM -0700, Matthias Kaehlcke wrote:
> > > This series extends LoadPin to allow loading of kernel files
> > > from trusted dm-verity devices. It adds the concept of
> > > trusted verity devices to LoadPin. Userspace can use the
> > > new systl file 'loadpin/trusted_verity_root_digests' to
> > > provide LoadPin with a list of root digests from dm-verity
> > > devices that LoadPin should consider as trusted. When a
> > > kernel file is read LoadPin first checks (as usual) whether
> > > the file is located on the pinned root, if so the file can
> > > be loaded. Otherwise, if the verity extension is enabled,
> > > LoadPin determines whether the file is located on a verity
> > > backed device and whether the root digest of that device
> > > is in the list of trusted digests. The file can be loaded
> > > if the verity device has a trusted root digest.
> > > 
> > > The list of trusted root digests can only be written once
> > > (typically at boot time), to limit the possiblity of
> > > attackers setting up rogue verity devices and marking them
> > > as trusted.
> 
> 
> > Thanks for working all this out! Where does the list of trusted
> > roothashes come from? I assume some chain of trust exists. Is the list
> > maybe already stored on the rootfs?
> 
> Yes, at least the content of the list comes from the rootfs. The
> userspace part is still TBD (also pending on the evolution of this
> patchset), having the list pre-formatted in a single file on the
> rootfs should be fine.

Ah-ha, that's perfect.

> > It'd be nice if there was some way to pass the trust chain to LoadPin
> > more directly.
> 
> I imagine you envision LoadPin reading the file itself, instead of
> just processing the content. That should be doable. One option would
> be to pass the path of the file with the hashes through the sysctl
> file and use kernel_read_file_from_path() to read it if the path is
> in the pinned root (or maybe even in any trusted file system ;-)

It could be a boot param or a Kconfig too. But yeah, having LoadPin able
to use itself to validate the file path would be much nicer.

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

