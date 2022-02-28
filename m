Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FE9C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 19:26:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-tKMXELdtP7GSmLK4NKUPyg-1; Mon, 28 Feb 2022 14:26:25 -0500
X-MC-Unique: tKMXELdtP7GSmLK4NKUPyg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1FE3180FD71;
	Mon, 28 Feb 2022 19:26:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3576919E74;
	Mon, 28 Feb 2022 19:26:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 844991809C98;
	Mon, 28 Feb 2022 19:26:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SJQBVp003311 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 14:26:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C780A1410DD8; Mon, 28 Feb 2022 19:26:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C379C1400E74
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 19:26:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9CA1C03378
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 19:26:11 +0000 (UTC)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
	[209.85.167.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-610-DZu2M2ZdNASeNjIVJjVSOQ-1; Mon, 28 Feb 2022 14:26:08 -0500
X-MC-Unique: DZu2M2ZdNASeNjIVJjVSOQ-1
Received: by mail-lf1-f45.google.com with SMTP id f37so23080044lfv.8
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 11:26:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=k5Nq2+gFOwIAZZv1z8A5AiR5tZQQa62jzNlsasSMp48=;
	b=2V7/AFHnVNeqlm0LVVxcD30hsL9o9EAwVMSwSn9ggCA3izubqHXCQsLKR4w39/pzcM
	JWahQF/EbgvVBVnouIEY9i10cvJtBIYP51il8YLCNIyR835osoki9JSKXJr4V6P+Idu4
	ICxWZzzvQ3Ki+aS6Yt7MGFExhjbegF6RQXLzccY44lWXzhA/B40p0Y5rNT/IIOhBTvCQ
	n3RheJkuCK/ylZGo0iCKxWJQedkFxigHAPq2snkKTLuMNNaL4nWG3tW2u+zetRiHs7Hq
	ZnGWSWE70WEsakvWqQVjjrqF4M8rA0BxiN0gzmyPVWEpxC6eKEr5G2Mbu+9dQr7CI56U
	A2Kg==
X-Gm-Message-State: AOAM5307cJFP80kRVb63d12wSOGJ01ylqyUf7StPyixc4eqrtnLp7rBn
	3jhA4sKxG3Tf7Awi5VsKPEYjG0nxxhZcBD1v0Yk=
X-Google-Smtp-Source: ABdhPJwrE1KEm5U1ALRTzM5mXwhVbLzekJ7+NizZ3sTu0pgLgMgTLDGWR327zE7HHwcyOCXa9pvRLQ==
X-Received: by 2002:a05:6512:3d8b:b0:442:628c:73f3 with SMTP id
	k11-20020a0565123d8b00b00442628c73f3mr13713173lfv.419.1646076366775;
	Mon, 28 Feb 2022 11:26:06 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com.
	[209.85.167.44]) by smtp.gmail.com with ESMTPSA id
	x11-20020a2ea7cb000000b002460c9b20b4sm1469960ljp.139.2022.02.28.11.26.05
	for <dm-devel@redhat.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 28 Feb 2022 11:26:05 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id i11so23162408lfu.3
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 11:26:05 -0800 (PST)
X-Received: by 2002:a05:6512:3042:b0:437:96f5:e68a with SMTP id
	b2-20020a056512304200b0043796f5e68amr14128474lfb.449.1646076365434;
	Mon, 28 Feb 2022 11:26:05 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
	<20220219210354.GF59715@dread.disaster.area>
	<CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
	<CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
In-Reply-To: <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Feb 2022 11:25:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
Message-ID: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
To: Kyle Sanderson <kyle.leet@gmail.com>
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
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>,
	Linux-Kernal <linux-kernel@vger.kernel.org>, qat-linux@intel.com,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 28, 2022 at 12:18 AM Kyle Sanderson <kyle.leet@gmail.com> wrote:
>
> Makes sense - this kernel driver has been destroying users for many
> years. I'm disappointed that this critical bricking failure isn't
> searchable for others.

It does sound like we should just disable that driver entirely until
it is fixed.

Or at least the configuration that can cause problems, if there is
some particular sub-case. Although from a cursory glance and the
noises made in this thread, it looks like it's all of the 'qat_aeads'
cases (since that uses qat_alg_aead_enc() which can return -EAGAIN),
which effectively means that all of the QAT stuff.

So presumably CRYPTO_DEV_QAT should just be marked as

        depends on BROKEN || COMPILE_TEST

or similar?

              Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

