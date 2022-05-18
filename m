Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A08C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 19:43:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-_RAujznSON-QapeikxZxgA-1; Wed, 18 May 2022 15:43:38 -0400
X-MC-Unique: _RAujznSON-QapeikxZxgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C415880B90C;
	Wed, 18 May 2022 19:43:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71EC82166B25;
	Wed, 18 May 2022 19:43:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 160F91947B8F;
	Wed, 18 May 2022 19:43:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AFBE91947068
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 19:43:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 935D17774; Wed, 18 May 2022 19:43:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E40F7B64
 for <dm-devel@redhat.com>; Wed, 18 May 2022 19:43:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39121185A7A4
 for <dm-devel@redhat.com>; Wed, 18 May 2022 19:43:31 +0000 (UTC)
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com
 [209.85.222.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-NIaThYC2MDyqdO2Zfp-ubw-1; Wed, 18 May 2022 15:43:29 -0400
X-MC-Unique: NIaThYC2MDyqdO2Zfp-ubw-1
Received: by mail-qk1-f174.google.com with SMTP id z126so2298937qkb.2
 for <dm-devel@redhat.com>; Wed, 18 May 2022 12:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eWE/Csrg3TFZq52PFagCnd5ycCPpe2W/G6e1YggcD68=;
 b=10P4pJc512uAoOXFaPFakomuCga72qGy+pgWr3yOmNILDPP2WlGl3cmxLmUnG+gFM9
 xiAEscKLhT2pc8vp8zKEW0s1rP2d88yATUYfPoVRaqTjBddkPzZ93ifX7gCW0ZncMbRo
 8XSPMvXwIUe1tRCL56EDGtmQ2EneJ/TD5dZbZZNN6u+TbI8mHa2xGMu2mIKwBHIxVRzp
 H20ilKnuNTkrFazxPzNN64uYWbBcsPyEJskdk0MFau8aMlF/75QZhqgV+2ty4rhNXWdc
 MM4DXAkC3fzd7DYOYUXeC748NlNGC2LICxijPkaCESaRnZHC3gtc3IktpbkcpW1MIbzZ
 CZ/Q==
X-Gm-Message-State: AOAM530Tc4KZeVM4bym9RQg36Znb0csQoMRsT/T6oL+yQ+FUNHqZRKTy
 aVZPkRNmDdhC9TLlbb1HrsYcTGg=
X-Google-Smtp-Source: ABdhPJxwDfvRn/dtBw/nu2UWuqr/QIeIsuEtWlURFwHEFgLeTC0TWbkdZvRu40tYPgyyOvUl6VbGrQ==
X-Received: by 2002:ae9:e90d:0:b0:6a3:28eb:1a4f with SMTP id
 x13-20020ae9e90d000000b006a328eb1a4fmr815862qkf.21.1652903009028; 
 Wed, 18 May 2022 12:43:29 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 h8-20020ac85148000000b002f39b99f679sm83146qtn.19.2022.05.18.12.43.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 12:43:28 -0700 (PDT)
Date: Wed, 18 May 2022 15:43:27 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YoVMX4pDDIN1vmH8@redhat.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <202205181221.F02CF5A9D2@keescook>
MIME-Version: 1.0
In-Reply-To: <202205181221.F02CF5A9D2@keescook>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v4 0/3] LoadPin: Enable loading from trusted
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
Cc: Douglas Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>,
 "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 18 2022 at  3:23P -0400,
Kees Cook <keescook@chromium.org> wrote:

> On Tue, May 17, 2022 at 04:34:54PM -0700, Matthias Kaehlcke wrote:
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
> 
> For the coming v5 (which will fix the 0-day reports), if I can get some
> Acks from the dm folks, I can carry this with other loadpin changes in
> my tree. Though I'm fine with this going via the dm tree, too:
> 
> Acked-by: Kees Cook <keescook@chromium.org>

I'll review it once it's posted.

But I'm going to reply to v4's 1/3 now.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

