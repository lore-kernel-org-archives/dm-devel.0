Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C23DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 17 Mar 2022 08:03:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-MuGmSsFVPyCTOYQHjpI6Vw-1; Thu, 17 Mar 2022 04:03:54 -0400
X-MC-Unique: MuGmSsFVPyCTOYQHjpI6Vw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E0B11C05EC7;
	Thu, 17 Mar 2022 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3AE50404D8FB;
	Thu, 17 Mar 2022 08:03:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 186081940365;
	Thu, 17 Mar 2022 08:03:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 580B61949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 21:38:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35B76401E7A; Wed, 16 Mar 2022 21:38:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31AEE401E79
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 21:38:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1734E899EC2
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 21:38:23 +0000 (UTC)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-RueIdQAmN36XIkoyUgimoA-1; Wed, 16 Mar 2022 17:38:21 -0400
X-MC-Unique: RueIdQAmN36XIkoyUgimoA-1
Received: by mail-il1-f180.google.com with SMTP id b9so2498996ila.8
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 14:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=5j/Sq8viQeL/hoyzW74KMLICeOJJ3w8lbHfpe3/YTVU=;
 b=AFBxmGdULqwTCZAQpCz76tlfRK4bxLjyFO/BAqfHV8jUVerm7ypY9l4EE2E+CUk+Pi
 zhhhjqITxY5JqG4s9A+LH1pouGAb5QQKgK1LdPQc9vlfYcFWFqWHIkOgmfIyNbjCISAY
 BTjPXr3DoqVTaPDxho25VyaPRJUJa/QTT1P0t4LG55tcjAcga0lm5/B8XbDwDuTTS4YS
 prTmxBXoayvI7LkV3XBF73V4Bil/rWa5zxNu7RvFFiOY7eCxLa76msFUiuacFlPmbv0y
 t9NAXsHwcSbUpK5rFnBjsQid0ZB5XUBvC9L3e+1z/UMb9bjRLASB36g2N1oMWejCtbKp
 ojww==
X-Gm-Message-State: AOAM531y9x5rmrQrshVXeSb5W04DyFpkyVrSPSu0kTSPGJG1cO7VwF6P
 UHBZ1IEkFGgyfADz9aIyptovIVvwHiF04ezieE+bNAp6WXg=
X-Google-Smtp-Source: ABdhPJzyY7nVOwSZFU6XgRHIUFHXdyAf8u1zf1zxe/TFlHeKO0VEOG5DoWkiwO5oi6A6Zcq1sk6IKlUs0qteIMjGX5k=
X-Received: by 2002:a92:c5aa:0:b0:2c5:f753:9069 with SMTP id
 r10-20020a92c5aa000000b002c5f7539069mr608362ilt.71.1647466700640; Wed, 16 Mar
 2022 14:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <Yh9G7FyCLtsm2mFA@kroah.com> <Yh9ZvLHuztwQCu0d@silpixa00400314>
 <Yh+FpKuoyj3G16lK@kroah.com> <Yh/vY4t3xnuoCW3Q@gondor.apana.org.au>
 <Yh/yr6oB5yeOUErL@silpixa00400314> <Yh/znCnZzWaL49+o@gondor.apana.org.au>
 <YiDHT31ujlGdQEe/@silpixa00400314> <YiEVPc2cd38AnLZB@gmail.com>
 <YiEyGoHacN80FcOL@silpixa00400314> <YiE21aPGG5DHwJvb@gmail.com>
 <YiJRQQmSxA/fbm6P@silpixa00400314>
In-Reply-To: <YiJRQQmSxA/fbm6P@silpixa00400314>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Wed, 16 Mar 2022 14:38:10 -0700
Message-ID: <CACsaVZJ2JH1M9-fB9uO=XKDuO74ZPKBHX81TQ4+bBvr_iSNiWQ@mail.gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Thu, 17 Mar 2022 08:03:49 +0000
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
Cc: linux-xfs <linux-xfs@vger.kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Greg KH <gregkh@linuxfoundation.org>,
 Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
 Linux-Kernal <linux-kernel@vger.kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Makes sense. I'm going to send it upstream and Cc stable as documented
> in https://www.kernel.org/doc/html/v4.10/process/stable-kernel-rules.html#option-1
> I will then revert this change in the set that fixes the problem.

Did this go anywhere? I'm still not seeing it in any of the stable trees.

Kyle.

On Fri, Mar 4, 2022 at 9:50 AM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> On Thu, Mar 03, 2022 at 09:44:53PM +0000, Eric Biggers wrote:
> > On Thu, Mar 03, 2022 at 09:24:42PM +0000, Giovanni Cabiddu wrote:
> > > On Thu, Mar 03, 2022 at 07:21:33PM +0000, Eric Biggers wrote:
> > > > If these algorithms have critical bugs, which it appears they do, then IMO it
> > > > would be better to disable them (either stop registering them, or disable the
> > > > whole driver) than to leave them available with low cra_priority.  Low
> > > > cra_priority doesn't guarantee that they aren't used.
> > > Thanks for your feedback Eric.
> > >
> > > Here is a patch that disables the registration of the algorithms in the
> > > QAT driver by setting, a config time, the number of HW queues (aka
> > > instances) to zero.
> > >
> > > ---8<---
> > > From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > > Subject: [PATCH] crypto: qat - disable registration of algorithms
> > > Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
> > >
> > > The implementations of aead and skcipher in the QAT driver do not
> > > support properly requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
> > > If the HW queue is full, the driver returns -EBUSY but does not enqueue
> > > the request.
> > > This can result in applications like dm-crypt waiting indefinitely for a
> > > completion of a request that was never submitted to the hardware.
> > >
> > > To avoid this problem, disable the registration of all skcipher and aead
> > > implementations in the QAT driver by setting the number of crypto
> > > instances to 0 at configuration time.
> > >
> > > This patch deviates from the original upstream solution, that prevents
> > > dm-crypt to use drivers registered with the flag
> > > CRYPTO_ALG_ALLOCATES_MEMORY, since a backport of that set to stable
> > > kernels may have a too wide effect.
> > >
> > > commit 7bcb2c99f8ed032cfb3f5596b4dccac6b1f501df upstream
> > > commit 2eb27c11937ee9984c04b75d213a737291c5f58c upstream
> > > commit fbb6cda44190d72aa5199d728797aabc6d2ed816 upstream
> > > commit b8aa7dc5c7535f9abfca4bceb0ade9ee10cf5f54 upstream
> > > commit cd74693870fb748d812867ba49af733d689a3604 upstream
> > >
> > > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > > ---
> > >  drivers/crypto/qat/qat_common/qat_crypto.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > Sounds good; is there any reason not to apply this upstream too, though?
> > You could revert it later as part of the patch series that fixes the driver.
> Makes sense. I'm going to send it upstream and Cc stable as documented
> in https://www.kernel.org/doc/html/v4.10/process/stable-kernel-rules.html#option-1
> I will then revert this change in the set that fixes the problem.
>
> Thanks,
>
> --
> Giovanni

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

