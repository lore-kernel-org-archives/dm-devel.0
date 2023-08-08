Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FAD5C001B0
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 22:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691534722;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j5+vuPGk3+8UKhy7SQcPHm0JAka8xPtMHNDH5Kd2XR4=;
	b=hY4U3ZdLBc4x6kTmK48L+XBYi2YUSUetoEnwYe30y4r/ig43x1kHA5+KiOYJ7HRqQxGocI
	p+xeRvetMw5t3S2shZJZr+dm8CUxrQLpOlZN4vbtO5lpwffMJatAaGlhks42EbegGuRFXy
	n6EdfGGrxEGxOT5bkCN3jZLYR5NDvVg=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-5iDVRmHZOa-0OVO-H-oChA-1; Tue, 08 Aug 2023 18:45:21 -0400
X-MC-Unique: 5iDVRmHZOa-0OVO-H-oChA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D81E629AA3B5;
	Tue,  8 Aug 2023 22:45:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE02940C2076;
	Tue,  8 Aug 2023 22:45:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BEC451946588;
	Tue,  8 Aug 2023 22:45:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC2F61946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Aug 2023 22:45:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A43231121315; Tue,  8 Aug 2023 22:45:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CD4C1121314
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 22:45:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81C0880C909
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 22:45:08 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-100-XNDSleEhMCGevplCjKzDpg-1; Tue,
 08 Aug 2023 18:45:04 -0400
X-MC-Unique: XNDSleEhMCGevplCjKzDpg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id ACC3A20FC0D2; Tue,  8 Aug 2023 15:45:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ACC3A20FC0D2
Date: Tue, 8 Aug 2023 15:45:03 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230808224503.GA20095@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
 <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH v10 11/17] dm-verity: consume root hash
 digest and signature data via LSM hook
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 25, 2023 at 04:43:48PM -0400, Paul Moore wrote:
> On Tue, Jul 11, 2023 at 11:43???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > On Fri, Jul 07, 2023 at 10:53:45AM -0400, Mike Snitzer wrote:
> 
> ...
> 
> > > Both of your calls to security_bdev_setsecurity() to set your blobs in
> > > the bdev are suspect because you're doing so from the verity_ctr().
> > > The mapped_device has 2 dm_table slots (active and inactive).  The
> > > verity_ctr() becomes part of the inactive slot, there is an extra step
> > > to bind the inactive table to the active table.
> > >
> > > This leads to you changing the blobs in the global bdev _before_ the
> > > table is actually active.  It is possible that the inactive table will
> > > simply be removed and the DM verity device put back in service;
> > > leaving your blob(s) in the bdev inconsistent.
> > >
> > > This issue has parallels to how we need to defer changing the global
> > > queue_limits associated with a request_queue until _after_ all table
> > > loading is settled and then the update is done just before resuming
> > > the DM device (mapped_device) -- see dm_table_set_restrictions().
> > >
> > > Unfortunately, this feels like it may require a new hook in the
> > > target_type struct (e.g. ->finalize())
> >
> > Thanks for pointing out this issue. We were calling security_bdev_setsecurity()
> > because the roothash signature data is only available in verity_ctr()
> > and it is discarded after verity_ctr() finishes.
> > After digging deeper into the table_load, I realized that we were indeed
> > wrong here.
> >
> > Based on my understanding of your suggestion, it seems that the correct
> > approach would be to save the roothash signature into the struct dm_target
> 
Sorry for the delay in responding. It took me a while to test out the design idea
suggested by Mike.

The current implementation is indeed incorrect. However, I've been able to develop
a working prototype that addresses the problem identified in the existing implementation.
I still need some additional time to fine-tune and clean up the prototype.

My goal is to have everything ready and send it out next month.

> Would you be doing this with a LSM hook, or would this live in the
> device mapper layer?
> 
In my implemention, it is a new hook in the device mapper layer. 
The hook is triggered just before activating an inactive table of a mapped device.
So in our case, we use the hook to attached the dm-verity's roothash metadata
to the block_device struct of mapped device.

> > and then invoke security_bdev_setsecurity() before activating
> > the inactive table in the __bind function (where dm_table_set_restrictions is called).
> >
> > To facilitate this process, it seems appropriate to introduce a new hook
> > called finalize() within the struct target_type. This hook would enable
> > targets to define tasks that need to be completed before activating
> > a new table.
> >
> > In our specific case, we would add a finalize hook to the dm-verity module,
> > allowing us to call security_bdev_setsecurity() and associate the roothash
> > information in the struct dm_target with the struct block_device of
> > the struct mapped_device. Is this correct?
> 
> Where would the finalize() hook be called?

It is in the __bind function in drivers/md/dm.c, calling just before 
rcu_assign_pointer(md->map, (void *)t) which activates the inactive table.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

