Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 331B0C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 19 Feb 2022 21:04:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-UlTHB75BNMmu4jOrgclawA-1; Sat, 19 Feb 2022 16:04:17 -0500
X-MC-Unique: UlTHB75BNMmu4jOrgclawA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C3C4108087A;
	Sat, 19 Feb 2022 21:04:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9675E5DF37;
	Sat, 19 Feb 2022 21:04:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 85FCF4BB7C;
	Sat, 19 Feb 2022 21:04:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21JL40tX008396 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 19 Feb 2022 16:04:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CE3EBC27FAB; Sat, 19 Feb 2022 21:04:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA8C9C27FA6
	for <dm-devel@redhat.com>; Sat, 19 Feb 2022 21:04:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD7C23C021B6
	for <dm-devel@redhat.com>; Sat, 19 Feb 2022 21:04:00 +0000 (UTC)
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au
	[211.29.132.246]) by relay.mimecast.com with ESMTP id
	us-mta-64-yehYxJSINgO9SUZEaSfCLg-1; Sat, 19 Feb 2022 16:03:58 -0500
X-MC-Unique: yehYxJSINgO9SUZEaSfCLg-1
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au
	[49.186.17.0])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C654052F78C;
	Sun, 20 Feb 2022 08:03:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nLWtW-00E1z1-7i; Sun, 20 Feb 2022 08:03:54 +1100
Date: Sun, 20 Feb 2022 08:03:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kyle Sanderson <kyle.leet@gmail.com>
Message-ID: <20220219210354.GF59715@dread.disaster.area>
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62115b3d
	a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
	a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=nt1UNTH2AAAA:8 a=7-415B0cAAAA:8
	a=tiecrrFWBOFT3706sEAA:9 a=CjuIK1q_8ugA:10 a=1jnEqRSf4vEA:10
	a=7AW3Uk2BEroXwU7YnAE8:22 a=biEYGPWJfzWAr4FL6Ov7:22
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
Cc: giovanni.cabiddu@intel.com, qat-linux@intel.com,
	Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 18, 2022 at 09:02:28PM -0800, Kyle Sanderson wrote:
> A2SDi-8C-HLN4F has IQAT enabled by default, when this device is
> attempted to be used by xfs (through dm-crypt) the entire kernel
> thread stalls forever. Multiple users have hit this over the years
> (through sporadic reporting) - I ended up trying ZFS and encryption
> wasn't an issue there at all because I guess they don't use this
> device. Returning to sanity (xfs), I was able to provision a dm-crypt
> volume no problem on the disk, however when running mkfs.xfs on the
> volume is what triggers the cascading failure (each request kills a
> kthread).

Can you provide the full stack traces for these errors so we can see
exactly what this cascading failure looks like, please? In reality,
the stall messages some time after this are not interesting - it's
the first errors that cause the stall that need to be investigated.

A good idea would be to provide the full storage stack decription
and hardware in use, as per:

https://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> Disabling IQAT on the south bridge results in a working
> system, however this is not the default configuration for the
> distribution of choice (Ubuntu 20.04.3 LTS), nor the motherboard. I'm
> convinced this never worked properly based on the lack of popularity
> for kernel encryption (crypto), and the embedded nature that
> SuperMicro has integrated this device in collaboration with intel as
> it looks like the primary usage is through external accelerator cards.

This really sounds like broken hardware, not a kernel problem.

> Kernels tried were from RHEL8 over a year ago, and this impacts the
> entirety of the 5.4 series on Ubuntu.
> Please CC me on replies as I'm not subscribed to all lists. CPU is C3758.

[snip stalled kcryptd worker threads]

This implies a dmcrypt level problem - XFS can't make progress is
dmcrypt is not completing IOs.

Where are the XFS corruption reports that the subject implies is
occurring?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

