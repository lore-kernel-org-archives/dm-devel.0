Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF61C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 25 Feb 2022 09:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645780656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2d1xXLPk3bSyOlP2Mabuk/h4Y+MFEckNAN+7PVYUQnc=;
	b=bvIG9y+sqRLp2QPXvM1do9Lel7yFuoYRozlGgMcRXg2tXKq9GdGwfswEiXdMDFsMnNPHIy
	uYPFQbTJAfzQDNbyOFikhAos18T8Lw23HM0mVArnBX+MwYcTBW4nipDWE445WJvLWftJIx
	DQOh56KFk+itOSedILBo7H3tITzXZHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-odWw-kYxNMCehJTLuZxFdQ-1; Fri, 25 Feb 2022 04:17:33 -0500
X-MC-Unique: odWw-kYxNMCehJTLuZxFdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C502B1854E26;
	Fri, 25 Feb 2022 09:17:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42B2B10246F4;
	Fri, 25 Feb 2022 09:17:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97C634A701;
	Fri, 25 Feb 2022 09:17:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21P9Cqdt026771 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 25 Feb 2022 04:12:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E0F521038AC4; Fri, 25 Feb 2022 09:12:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D26B1006870;
	Fri, 25 Feb 2022 09:12:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 21P9CW8f021225; Fri, 25 Feb 2022 04:12:32 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 21P9CVVN021221; Fri, 25 Feb 2022 04:12:31 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 25 Feb 2022 04:12:31 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Nitesh Shetty <nj.shetty@samsung.com>
In-Reply-To: <20220224124213.GD9117@test-zns>
Message-ID: <alpine.LRH.2.02.2202250410210.20694@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141948epcas5p4534f6bdc5a1e2e676d7d09c04f8b4a5b@epcas5p4.samsung.com>
	<20220207141348.4235-9-nj.shetty@samsung.com>
	<alpine.LRH.2.02.2202160845210.22021@file01.intranet.prod.int.rdu2.redhat.com>
	<20220224124213.GD9117@test-zns>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, zach.brown@ni.com, chaitanyak@nvidia.com,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH v2 08/10] dm: Add support for copy offload.
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 24 Feb 2022, Nitesh Shetty wrote:

> On Wed, Feb 16, 2022 at 08:51:08AM -0500, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 7 Feb 2022, Nitesh Shetty wrote:
> > 
> > > Before enabling copy for dm target, check if underlaying devices and
> > > dm target support copy. Avoid split happening inside dm target.
> > > Fail early if the request needs split, currently spliting copy
> > > request is not supported
> > > 
> > > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > 
> > If a dm device is reconfigured, you must invalidate all the copy tokens 
> > that are in flight, otherwise they would copy stale data.
> > 
> > I suggest that you create a global variable "atomic64_t dm_changed".
> > In nvme_setup_copy_read you copy this variable to the token.
> > In nvme_setup_copy_write you compare the variable with the value in the 
> > token and fail if there is mismatch.
> > In dm.c:__bind you increase the variable, so that all the tokens will be 
> > invalidated if a dm table is changed.
> > 
> > Mikulas
> > 
> >
> Yes, you are right about the reconfiguration of dm device. But wouldn't having a
> single global counter(dm_changed), will invalidate for all in-flight copy IO's
> across all dm devices. Is my understanding correct?
> 
> --
> Nitesh Shetty

Yes, changing it will invalidate all the copy IO's.

But invalidating only IO's affected by the table reload would be hard to 
achieve.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

