Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B2BC43219
	for <dm-devel@archiver.kernel.org>; Thu,  3 Mar 2022 09:21:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-meRimsoGM0GC7Ksi2YmI3A-1; Thu, 03 Mar 2022 04:21:49 -0500
X-MC-Unique: meRimsoGM0GC7Ksi2YmI3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AE0F1091DA4;
	Thu,  3 Mar 2022 09:21:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E6857369A;
	Thu,  3 Mar 2022 09:21:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2F9AD1809C88;
	Thu,  3 Mar 2022 09:21:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 222MhidX022456 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Mar 2022 17:43:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0847B40D2822; Wed,  2 Mar 2022 22:43:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03C2740D2820
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 22:43:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E06BF1C05B10
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 22:43:43 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-122-F6EyCOJNPZa587rJww_QGA-1; Wed, 02 Mar 2022 17:43:42 -0500
X-MC-Unique: F6EyCOJNPZa587rJww_QGA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="252351143"
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; d="scan'208";a="252351143"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
	by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	02 Mar 2022 14:42:38 -0800
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; d="scan'208";a="508365588"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314)
	([10.237.222.76]) by orsmga002-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 14:42:35 -0800
Date: Wed, 2 Mar 2022 22:42:20 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <Yh/yr6oB5yeOUErL@silpixa00400314>
References: <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
	<CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
	<Yh0y75aegqS4jIP7@silpixa00400314>
	<Yh1aLfy/oBawCJIg@gondor.apana.org.au>
	<CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
	<Yh2c4Vwu61s51d6N@gondor.apana.org.au> <Yh9G7FyCLtsm2mFA@kroah.com>
	<Yh9ZvLHuztwQCu0d@silpixa00400314> <Yh+FpKuoyj3G16lK@kroah.com>
	<Yh/vY4t3xnuoCW3Q@gondor.apana.org.au>
MIME-Version: 1.0
In-Reply-To: <Yh/vY4t3xnuoCW3Q@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
	Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Mar 2022 04:21:39 -0500
Cc: Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>,
	qat-linux@intel.com, Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Kyle Sanderson <kyle.leet@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 03, 2022 at 10:27:47AM +1200, Herbert Xu wrote:
> On Wed, Mar 02, 2022 at 03:56:36PM +0100, Greg KH wrote:
> >
> > > If not, then these are the patches that should be backported:
> > >     7bcb2c99f8ed crypto: algapi - use common mechanism for inheriting flags
> > >     2eb27c11937e crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
> > >     fbb6cda44190 crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
> > >     b8aa7dc5c753 crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
> > >     cd74693870fb dm crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
> > > Herbert, correct me if I'm wrong here.
> > 
> > These need to be manually backported as they do not apply cleanly.  Can
> > you provide such a set?  Or should I just disable a specific driver here
> > instead which would be easier overall?
> 
> I think the safest thing is to disable qat in stable (possibly only
> when DM_CRYPT is enabled/modular).  The patches in question while
> good may have too wide an effect for the stable kernel series.
> 
> Giovanni, could you send Greg a Kconfig patch to do that?
I was thinking, as an alternative, to lower the cra_priority in the QAT
driver for the algorithms used by dm-crypt so they are not used by
default.
Is that a viable option?

Sure, I can provide a patch for either the cra_priority or the Kconfig
option for the stable kernels that don't have the patches above.

-- 
Giovanni

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

