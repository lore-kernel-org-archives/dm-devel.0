Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB8EC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 07:17:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-7dHlUOOrPxma82MIkF2XJg-1; Tue, 01 Mar 2022 02:17:46 -0500
X-MC-Unique: 7dHlUOOrPxma82MIkF2XJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24034824FA6;
	Tue,  1 Mar 2022 07:17:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AD60519D2;
	Tue,  1 Mar 2022 07:17:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DAB3B4EE76;
	Tue,  1 Mar 2022 07:17:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SKdQep007949 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 15:39:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D5FBC2026D6A; Mon, 28 Feb 2022 20:39:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D10402026D69
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 20:39:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 551993802ADA
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 20:39:23 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-403-f8nHC5pnNcSfRGid36256Q-1; Mon, 28 Feb 2022 15:39:21 -0500
X-MC-Unique: f8nHC5pnNcSfRGid36256Q-1
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="316198800"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; d="scan'208";a="316198800"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
	by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	28 Feb 2022 12:39:20 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; d="scan'208";a="510236616"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314)
	([10.237.222.76]) by orsmga006-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 12:39:17 -0800
Date: Mon, 28 Feb 2022 20:39:11 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Yh0y75aegqS4jIP7@silpixa00400314>
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
	<20220219210354.GF59715@dread.disaster.area>
	<CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
	<CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
	<CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 01 Mar 2022 02:17:20 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>,
	Linux-Kernal <linux-kernel@vger.kernel.org>, qat-linux@intel.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 28, 2022 at 11:25:49AM -0800, Linus Torvalds wrote:
> On Mon, Feb 28, 2022 at 12:18 AM Kyle Sanderson <kyle.leet@gmail.com> wrote:
> >
> > Makes sense - this kernel driver has been destroying users for many
> > years. I'm disappointed that this critical bricking failure isn't
> > searchable for others.
> 
> It does sound like we should just disable that driver entirely until
> it is fixed.
> 
> Or at least the configuration that can cause problems, if there is
> some particular sub-case.
The dm-crypt + QAT use-case is already disabled since kernel 5.10 due to
a different issue.
Is it an option to port those patches to stable till I provide a fix for
the driver? I drafted already few alternatives for the fix and I am aiming
for a final set by end of week.

Thanks,

-- 
Giovanni

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

