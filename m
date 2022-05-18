Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03488C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 19:23:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-ZTJd9UZ3Pp2iUce9BcqmeA-1; Wed, 18 May 2022 15:23:53 -0400
X-MC-Unique: ZTJd9UZ3Pp2iUce9BcqmeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E37661C00131;
	Wed, 18 May 2022 19:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7ECE87AD5;
	Wed, 18 May 2022 19:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C1641947B8F;
	Wed, 18 May 2022 19:23:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E00551947068
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 19:23:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B79E92024CD5; Wed, 18 May 2022 19:23:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2FA02024CAE
 for <dm-devel@redhat.com>; Wed, 18 May 2022 19:23:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B8DA3C14CC0
 for <dm-devel@redhat.com>; Wed, 18 May 2022 19:23:16 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-Ezq6wG5EOkuJtnXZdavvzw-1; Wed, 18 May 2022 15:23:12 -0400
X-MC-Unique: Ezq6wG5EOkuJtnXZdavvzw-1
Received: by mail-pl1-f171.google.com with SMTP id i1so2700371plg.7
 for <dm-devel@redhat.com>; Wed, 18 May 2022 12:23:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=azN0WpbB56teBoeHRiX8ZF8theRa9wuUdenPzDm2W0A=;
 b=Opj+mYcMF6e4urLLYWkIdQp8vJ/BEK8Y1og8rGNz2FGDTd6r0d0Wqi2jv8KlnPNYy1
 9HETYKYykjSMzhGc9eaCeS50j7KJDRXRjhrF+difVsbJGW+3OsXSPUa+WDucP2++iW5M
 ux2r5PlIURMTKl0ImZBCk0Qx/5ahIhBXk0ot27V8/OTOT/Gj5V4vOeVoKwLdiRYoJYFV
 h/6i+izq8krmsZHot7poy8iPQkvGoQ67QPJbQ8Aj6+1Spp//8oPS1mXfYvT+YrthepSK
 dpxaNh7b58TuIncYEeuLJWwO+o7a7KCcQods7HK46Npx5GX6poEl+c3857ze3z/sd1in
 hcAQ==
X-Gm-Message-State: AOAM530pY5V/B9k9r9Wl8G6+0oP4Blz6Ecvbb1vmisOhFwR8t+NPc6pS
 T0APKGoFv36NBMQinsxNeNmF/A==
X-Google-Smtp-Source: ABdhPJxxZN/NR10p8Wr/541BkyIcKrJcnoJoUiHqQDum/hfEMTs1nrTf898+1jlCrtMSQOkhw1YXoA==
X-Received: by 2002:a17:90b:4f86:b0:1df:28c5:e89a with SMTP id
 qe6-20020a17090b4f8600b001df28c5e89amr1016434pjb.66.1652901791534; 
 Wed, 18 May 2022 12:23:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 l17-20020a170902d05100b0016168e90f2dsm2055410pll.219.2022.05.18.12.23.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 12:23:11 -0700 (PDT)
Date: Wed, 18 May 2022 12:23:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <202205181221.F02CF5A9D2@keescook>
References: <20220517233457.1123309-1-mka@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20220517233457.1123309-1-mka@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 17, 2022 at 04:34:54PM -0700, Matthias Kaehlcke wrote:
> As of now LoadPin restricts loading of kernel files to a single pinned
> filesystem, typically the rootfs. This works for many systems, however it
> can result in a bloated rootfs (and OTA updates) on platforms where
> multiple boards with different hardware configurations use the same rootfs
> image. Especially when 'optional' files are large it may be preferable to
> download/install them only when they are actually needed by a given board.
> Chrome OS uses Downloadable Content (DLC) [1] to deploy certain 'packages'
> at runtime. As an example a DLC package could contain firmware for a
> peripheral that is not present on all boards. DLCs use dm-verity [2] to
> verify the integrity of the DLC content.

For the coming v5 (which will fix the 0-day reports), if I can get some
Acks from the dm folks, I can carry this with other loadpin changes in
my tree. Though I'm fine with this going via the dm tree, too:

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

