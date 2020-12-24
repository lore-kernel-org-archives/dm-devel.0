Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1F9C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C180C21D1B
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C180C21D1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-cHwf23FFMeS8DBFv1ljoqA-1; Mon, 04 Jan 2021 14:03:46 -0500
X-MC-Unique: cHwf23FFMeS8DBFv1ljoqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D3CC8144E2;
	Mon,  4 Jan 2021 19:03:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DB225C8AA;
	Mon,  4 Jan 2021 19:03:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3355A5002E;
	Mon,  4 Jan 2021 19:03:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BO9utW3012982 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Dec 2020 04:56:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D2E5B10FFE6D; Thu, 24 Dec 2020 09:56:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF01310FFE6A
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 09:56:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7044D185A7BC
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 09:56:53 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-101-bE8aa_F6ObSakVhZ8Ls0YQ-1;
	Thu, 24 Dec 2020 04:56:51 -0500
X-MC-Unique: bE8aa_F6ObSakVhZ8Ls0YQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id C80412253A;
	Thu, 24 Dec 2020 09:56:49 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id p5so1918687oif.7;
	Thu, 24 Dec 2020 01:56:49 -0800 (PST)
X-Gm-Message-State: AOAM5305ibzxFewZqcNwee89H1iiVD1QMIlGUEBm2h2gidAsXSmfIG9Y
	dftbKYrEkrYvzhz3mCecL7owp5lKPDRn+zdjxmM=
X-Google-Smtp-Source: ABdhPJyJVKnUfd3D1h+72t/QQy4A04Gab7AwQXcwdGD1QMVLr97Qh1xVnE4NhLIimRh41kNmduD2cCZK8KAA2XDa3GQ=
X-Received: by 2002:aca:dd03:: with SMTP id u3mr2420893oig.47.1608803809071;
	Thu, 24 Dec 2020 01:56:49 -0800 (PST)
MIME-Version: 1.0
References: <20201223223841.11311-1-ardb@kernel.org>
	<dff974aa-4dcf-9f4a-83db-eb4883aa3376@gmail.com>
In-Reply-To: <dff974aa-4dcf-9f4a-83db-eb4883aa3376@gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 24 Dec 2020 10:56:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE2Y=7OKsHccv59uzc_Jg7vixkrnYQRgX6RRYJQiHnKOw@mail.gmail.com>
Message-ID: <CAMj1kXE2Y=7OKsHccv59uzc_Jg7vixkrnYQRgX6RRYJQiHnKOw@mail.gmail.com>
To: Milan Broz <gmazyland@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:11 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Megha Dey <megha.dey@intel.com>
Subject: Re: [dm-devel] [RFC PATCH 00/10] crypto: x86 - remove XTS and CTR
	glue helper code
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 24 Dec 2020 at 10:33, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 23/12/2020 23:38, Ard Biesheuvel wrote:
> > After applying my performance fixes for AES-NI in XTS mode, the only
> > remaining users of the x86 glue helper module are the niche algorithms
> > camellia, cast6, serpent and twofish.
> >
> > It is not clear from the history why all these different versions of these
> > algorithms in XTS and CTR modes were added in the first place: the only
> > in-kernel references that seem to exist are to cbc(serpent), cbc(camellia)
> > and cbc(twofish) in the IPsec stack. The XTS spec only mentions AES, and
> > CTR modes don't seem to be widely used either.
>
> FYI: Serpent, Camellia and Twofish are used in TrueCrypt/VeraCrypt implementation;
> cryptsetup and I perhaps even VeraCrypt itself tries to use native dm-crypt mapping.
> (They also added Russian GOST Kuznyechik with XTS, but this is not in mainline,
> but Debian packages it as gost-crypto-dkms).
>
> Serpent and Twofish can be also used with LRW and CBC modes (for old containers only).
>
> Cryptsetup uses crypto userspace API to decrypt the key from header, then it configures
> dm-crypt mapping for data. We need both use and in-kernel API here.
>
> For reference, see this table (my independent implementation of TrueCrypt/VeraCrypt modes,
> it should be complete history though):
> https://gitlab.com/cryptsetup/cryptsetup/-/blob/master/lib/tcrypt/tcrypt.c#L77
>
> If the above still works (I would really like to have way to open old containers)
> it is ok to do whatever you want to change here :-)
>

Thanks Milan.

With the XTS code removed from these drivers, the XTS template will be
used, which relies on the ECB mode helpers instead. So once we fix
those to get rid of the indirect calls, I'd expect XTS to actually
improve in performance for these algorithms.

> I have no info that CTR is used anywhere related to dm-crypt
> (IIRC it can be tricked to be used there but it does not make any sense).
>

Yes, that was my assumption. Thanks for confirming.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

