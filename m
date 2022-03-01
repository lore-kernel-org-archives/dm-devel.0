Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D7DC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 01:12:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-5rCCQFPuPluh10ky6OHv_A-1; Mon, 28 Feb 2022 20:12:54 -0500
X-MC-Unique: 5rCCQFPuPluh10ky6OHv_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98787180FD71;
	Tue,  1 Mar 2022 01:12:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D1F360C05;
	Tue,  1 Mar 2022 01:12:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6FD771809C98;
	Tue,  1 Mar 2022 01:12:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2211Cjek028893 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 20:12:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A5C737AC9; Tue,  1 Mar 2022 01:12:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A05307ACB
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 01:12:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BEAA101AA48
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 01:12:42 +0000 (UTC)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
	[209.85.208.180]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-673-r6QOpZU1PRqCb2AVN53btA-1; Mon, 28 Feb 2022 20:12:40 -0500
X-MC-Unique: r6QOpZU1PRqCb2AVN53btA-1
Received: by mail-lj1-f180.google.com with SMTP id u11so19819968lju.4
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 17:12:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=7sPR5FUt6BL5vY4zH7orS+P13v54d72vP0e3RrfoSc8=;
	b=hAThO/M65bYMEsKNi7kr4R/ia26ToCSLcYrmYOB7FyoyPwy6VFs9KE8NfWEbnAerUK
	yVdJMLwBZkPpxsJrdR5bdlVFiAO0Eh8ogIkkxARgbZf8IH2QU1gc3byBSLFMc5mVi8BJ
	S3Xs41j/gjypbmBmyYljjnIyCjdTnHnO+SL22KVq9nquwxPM1H0w7QILZmuNnK5pkItW
	XLCsDmZjq7J5vAUigB/d8Mc/9VyUQixLE3+GmX0b8cSovZgYqc2k+XoXYqDH8n6+/TTf
	fyStMxkSO3V8DlA90gRMgTcz951yRkfWnLguSwdhhayG+PO564m9K+iRyUh+wNftnwMH
	jVWA==
X-Gm-Message-State: AOAM531Te8tXy4b5elB3bXzHRpM7E9qqorxAlWM1tOU7NvVoR53MQb3E
	trmnO1m3vYJsA3L6DnjZGKvwVCgcbQt/7yM3VJs=
X-Google-Smtp-Source: ABdhPJy2hgMc6nftbXGjuCqn44QXJihcHDDj53/E4d/15VX20to3eBQiIjXGnrBHYQSHiLcFbnBzxw==
X-Received: by 2002:a2e:9f56:0:b0:246:4d12:1652 with SMTP id
	v22-20020a2e9f56000000b002464d121652mr16178040ljk.258.1646097158581;
	Mon, 28 Feb 2022 17:12:38 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com.
	[209.85.167.47]) by smtp.gmail.com with ESMTPSA id
	by35-20020a05651c1a2300b0024671a354e7sm1584877ljb.17.2022.02.28.17.12.37
	for <dm-devel@redhat.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 28 Feb 2022 17:12:37 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id b9so24371212lfv.7
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 17:12:37 -0800 (PST)
X-Received: by 2002:ac2:4d91:0:b0:443:127b:558a with SMTP id
	g17-20020ac24d91000000b00443127b558amr14616139lfe.542.1646097157337;
	Mon, 28 Feb 2022 17:12:37 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
	<20220219210354.GF59715@dread.disaster.area>
	<CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
	<CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
	<CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
	<Yh0y75aegqS4jIP7@silpixa00400314>
	<Yh1aLfy/oBawCJIg@gondor.apana.org.au>
In-Reply-To: <Yh1aLfy/oBawCJIg@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Feb 2022 17:12:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
Message-ID: <CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
	Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Kyle Sanderson <kyle.leet@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 28, 2022 at 3:26 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Indeed, qat has been disabled for dm-crypt since
>
> commit b8aa7dc5c7535f9abfca4bceb0ade9ee10cf5f54
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Thu Jul 9 23:20:41 2020 -0700
>
>     crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
>
> So this should no longer be an issue with an up-to-date kernel.

Ok, that commit message doesn't exactly make it clear that it also
fixes a major disk corruption issue.

It sounds like it was incidental and almost accidental that it fixed
that thing, and nobody realized it should perhaps be also moved to
stable.

Oh, except I think you *also* need commit cd74693870fb ("dm crypt:
don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY") that
actually reacts to that flag.

Which also wasn't marked for stable, and which is why 5.10 is ok, but
5.9 (which has that first commit, but not the second) is not ok.

Of course, maybe they got marked for stable separately and actually
have been back-ported, but it doesn't sound like that happened.. I
didn't actually check.

                  Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

