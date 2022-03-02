Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A61D7C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Mar 2022 09:21:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-Z5EkXMElMJKV2I4Qn-fiAA-1; Thu, 03 Mar 2022 04:21:51 -0500
X-MC-Unique: Z5EkXMElMJKV2I4Qn-fiAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A25081006AA5;
	Thu,  3 Mar 2022 09:21:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E6757FA32;
	Thu,  3 Mar 2022 09:21:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A9FA1809C83;
	Thu,  3 Mar 2022 09:21:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 222BnRiu030463 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Mar 2022 06:49:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A305D407E242; Wed,  2 Mar 2022 11:49:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EE6A407E240
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 11:49:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85CD6185A7BA
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 11:49:27 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-327-RmU0Ae07OVWSZ8hUJ5fETw-1; Wed, 02 Mar 2022 06:49:25 -0500
X-MC-Unique: RmU0Ae07OVWSZ8hUJ5fETw-1
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="316595434"
X-IronPort-AV: E=Sophos;i="5.90,148,1643702400"; d="scan'208";a="316595434"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
	by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	02 Mar 2022 03:49:24 -0800
X-IronPort-AV: E=Sophos;i="5.90,148,1643702400"; d="scan'208";a="535358916"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314)
	([10.237.222.76]) by orsmga007-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 03:49:22 -0800
Date: Wed, 2 Mar 2022 11:49:16 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <Yh9ZvLHuztwQCu0d@silpixa00400314>
References: <20220219210354.GF59715@dread.disaster.area>
	<CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
	<CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
	<CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
	<Yh0y75aegqS4jIP7@silpixa00400314>
	<Yh1aLfy/oBawCJIg@gondor.apana.org.au>
	<CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
	<Yh2c4Vwu61s51d6N@gondor.apana.org.au> <Yh9G7FyCLtsm2mFA@kroah.com>
MIME-Version: 1.0
In-Reply-To: <Yh9G7FyCLtsm2mFA@kroah.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Mar 2022 04:21:39 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Dave Chinner <david@fromorbit.com>,
	Linux-Kernal <linux-kernel@vger.kernel.org>, qat-linux@intel.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Greg,

On Wed, Mar 02, 2022 at 11:29:00AM +0100, Greg KH wrote:
> On Tue, Mar 01, 2022 at 04:11:13PM +1200, Herbert Xu wrote:
> > On Mon, Feb 28, 2022 at 05:12:20PM -0800, Linus Torvalds wrote:
> > > 
> > > It sounds like it was incidental and almost accidental that it fixed
> > > that thing, and nobody realized it should perhaps be also moved to
> > > stable.
> > 
> > Yes this was incidental.  The patch in question fixes an issue in
> > OOM situations where drivers that must allocate memory on each
> > request may lead to dead-lock so it's not really targeted at qat.
> 
> Ok, so what commits should I backport to kernels older than 5.10 to
> resolve this?
Is it possible to wait for a set that resolves the problem rather than
backporting the patches that disables the use-case?
I have a patchset that fixes the actual issue and we are doing an
internal review before submission to the mailing list.
I should be able to send a V1 out between today and tomorrow.

If not, then these are the patches that should be backported:
    7bcb2c99f8ed crypto: algapi - use common mechanism for inheriting flags
    2eb27c11937e crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
    fbb6cda44190 crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
    b8aa7dc5c753 crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
    cd74693870fb dm crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
Herbert, correct me if I'm wrong here.

Thanks,

-- 
Giovanni

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

