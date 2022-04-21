Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4E9C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Apr 2022 14:47:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-d4QU1hhXM96PFfVWY7xluQ-1; Thu, 21 Apr 2022 10:47:49 -0400
X-MC-Unique: d4QU1hhXM96PFfVWY7xluQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AFC1383A5D0;
	Thu, 21 Apr 2022 14:47:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5BA654E889;
	Thu, 21 Apr 2022 14:47:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F83D19451F0;
	Thu, 21 Apr 2022 14:47:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFD5119451EF
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Apr 2022 14:47:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D98564021D9; Thu, 21 Apr 2022 14:47:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D5814572326
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 14:47:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B974C811E90
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 14:47:46 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-NxHgWTrrPTq5Twyp6_mujw-1; Thu, 21 Apr 2022 10:47:45 -0400
X-MC-Unique: NxHgWTrrPTq5Twyp6_mujw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 47F0E60F2E;
 Thu, 21 Apr 2022 14:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B346C385A8;
 Thu, 21 Apr 2022 14:40:18 +0000 (UTC)
Date: Thu, 21 Apr 2022 16:40:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <YmFsz3lZt7jPUCGV@kroah.com>
References: <20220420064745.1119823-1-hch@lst.de>
 <20220420064745.1119823-3-hch@lst.de>
 <YmBiAQ/IZbFhRc6o@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <YmBiAQ/IZbFhRc6o@sol.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 2/2] blk-crypto: fix the blk_crypto_profile
 liftime
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
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
 linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Ritesh Harjani <riteshh@codeaurora.org>,
 Adrian Hunter <adrian.hunter@intel.com>, linux-block@vger.kernel.org,
 Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
 Alim Akhtar <alim.akhtar@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Asutosh Das <asutoshd@codeaurora.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 20, 2022 at 12:41:53PM -0700, Eric Biggers wrote:
> On Wed, Apr 20, 2022 at 08:47:45AM +0200, Christoph Hellwig wrote:
> > Once the blk_crypto_profile is exposed in sysfs it needs to stay alive
> > as long as sysfs accesses are possibly pending.  Ensure that by removing
> > the blk_crypto_kobj wrapper and just embedding the kobject into the
> > actual blk_crypto_profile.  This requires the blk_crypto_profile
> > structure to be dynamically allocated, which in turn requires a private
> > data pointer for driver use.
> > 
> > Fixes: 20f01f163203 ("blk-crypto: show crypto capabilities in sysfs")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Can you elaborate on what you think the actual problem is here?  The lifetime of
> the blk_crypto_profile matches that of the host controller kobject, and I
> thought that it is not destroyed until after higher-level objects such as
> gendisks and request_queues are destroyed.  Similar assumptions are made by the
> queue kobject, which assumes it is safe to access the gendisk, and by the
> independent_access_ranges kobject which assumes it is safe to access the queue.
> 
> I suppose this wouldn't have worked with the original sysfs design where opening
> a file in sysfs actually got a refcount to the kobject.  But that's long gone,
> having been changed in Linux v2.6.23 (https://lwn.net/Articles/229774).
> 
> Note that commit 20f01f163203 which added this code got an "all looks good" from
> Greg KH (https://lore.kernel.org/r/YaH1CmHClx5WvDWD@kroah.com).  I'd have hoped
> that he would've noticed if there was a major problem with how kobjects are used
> here!  Greg, would you mind taking a look at this part again?

I do not know the model for the block devices and queues and all of that
well at all.  My first glance this seemed sane, but if the lifetime
rules are not normal in any way, I do not know.  I defer to Christoph
for all of this, he knows it way better than I do.

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

