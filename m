Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B23AC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 05:13:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-zHxddeUZOkKcPRTjERIcAQ-1; Thu, 06 Jan 2022 00:13:29 -0500
X-MC-Unique: zHxddeUZOkKcPRTjERIcAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E47CE81EE60;
	Thu,  6 Jan 2022 05:13:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8FBD12E39;
	Thu,  6 Jan 2022 05:13:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4031C4BB7C;
	Thu,  6 Jan 2022 05:13:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2065DEm9020847 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 00:13:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 45F39C01784; Thu,  6 Jan 2022 05:13:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 41463C15E71
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 05:13:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27FD2185A79C
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 05:13:14 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
	[139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-608-XFKZVPjjO9eyFbQgArBySg-1; Thu, 06 Jan 2022 00:13:13 -0500
X-MC-Unique: XFKZVPjjO9eyFbQgArBySg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 64F296197C;
	Thu,  6 Jan 2022 05:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E16EC36AE5;
	Thu,  6 Jan 2022 05:07:44 +0000 (UTC)
Date: Wed, 5 Jan 2022 21:07:42 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Bae, Chang Seok" <chang.seok.bae@intel.com>
Message-ID: <YdZ5HrOKEffBrQIm@sol.localdomain>
References: <20211214005212.20588-1-chang.seok.bae@intel.com>
	<YbqRseO+TtuGQk5x@sol.localdomain>
	<4101B942-6327-49A9-BE8B-9E51F0427F50@intel.com>
MIME-Version: 1.0
In-Reply-To: <4101B942-6327-49A9-BE8B-9E51F0427F50@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dave Hansen <dave.hansen@linux.intel.com>, "Williams,
	Dan J" <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Krishnakumar,
	Lalithambika" <lalithambika.krishnakumar@intel.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Lutomirski, Andy" <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
	"Gairuboyina, Charishma1" <charishma1.gairuboyina@intel.com>,
	"Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>
Subject: Re: [dm-devel] [PATCH v4 00/13] x86: Support Key Locker
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 05, 2022 at 09:55:17PM +0000, Bae, Chang Seok wrote:
> >> +-----------+---------------+---------------+
> >> | Cipher    |   Encryption  | Decryption    |
> >> | (AES-KL)  |    (MiB/s)    | (MiB/s)       |
> >> +-----------+---------------+---------------+
> >> | AES-CBC   |     505.3     |   2097.8      |
> >> | AES-XTS   |     1130      |   696.4       |
> >> +-----------+-------------------------------+
> > 
> > Why is AES-XTS decryption so much slower than AES-XTS encryption?  They should
> > be about the same.
> 
> Analyzing and understanding this with specific hardware implementation takes
> time for us. Will come back and update you when we have anything to share here.

Note that for disk encryption, decryption performance is usually more important
than encryption performance.  So your performance results are strange.

> > Also, is the AES-CBC support really useful, given that for disk encryption,
> > AES-XTS is recommended over AES-CBC these days?
> 
> Yes, we understand that AES-XTS is the primary option for disk encryption.
> 
> But it seems that AES-CBC had been used for disk encryption, [1]:
> 
>     Comparing XTS to CBC for hard disk encryption
>         If a storage device vendor is seeking FIPS 140-2 certification today,
>         they will typically use CBC encryption, or even ECB. CBC is a good
>         mode, ...

That document is very old.  XTS has been NIST-approved for over a decade now.

> 
> As long as it is factual that the mode was once popular, it can help somebody
> who wants to use Key Locker for an old disk image I think.

AES-CBC is/was usually used with ESSIV, in which case the key cannot be fully
protected by Key Locker.

I'm not sure you should bother to support legacy use cases, especially since it
might mislead users into choosing a worse algorithm.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

