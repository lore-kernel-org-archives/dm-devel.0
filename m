Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55612C55178
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 14:35:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF7B522202
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 14:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V9cqiFKQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF7B522202
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603809337;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=m7PHwsWnJyB8NAehz3J3fvRWnDYO4IDZwZ2cOYfx5sI=;
	b=V9cqiFKQRlmxBHCYYXFMFRZ7yoIFga6KgVFWXAHn4r4YKNUY9GnPzYzUlmzZ9bZF3L+1qL
	YGrLRGl0xAzRXHwtO15Ff8W5Iwus16+P0D/Q3wLUOZQkI9qYVkSywS9AnsKWyLPBXmPbNV
	RZoRba4axddtsW4uAMecOhWWOrypNmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-RaxoAk3AM1iqpotleqcq3Q-1; Tue, 27 Oct 2020 10:35:33 -0400
X-MC-Unique: RaxoAk3AM1iqpotleqcq3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68871800C60;
	Tue, 27 Oct 2020 14:35:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3601A5D9F1;
	Tue, 27 Oct 2020 14:35:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 336145810D;
	Tue, 27 Oct 2020 14:35:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09REZI4e002211 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 10:35:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9AC4F10013D0; Tue, 27 Oct 2020 14:35:18 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F6DE1002388;
	Tue, 27 Oct 2020 14:35:15 +0000 (UTC)
Date: Tue, 27 Oct 2020 09:34:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20201027133449.GC13012@redhat.com>
References: <1603412870-3627-1-git-send-email-michael.christie@oracle.com>
	<20201027125506.GB13012@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201027125506.GB13012@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/1] dm mpath: add IO affinity path selector
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 27 2020 at  8:55am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Oct 22 2020 at  8:27pm -0400,
> Mike Christie <michael.christie@oracle.com> wrote:
> 
> > This patch adds a path selector that selects paths based on a CPU to
> > path mapping the user passes in and what CPU we are executing on. The
> > primary user for this PS is where the app is optimized to use specific
> > CPUs so other PSs undo the apps handy work, and the storage and it's
> > transport are not a bottlneck.
> > 
> > For these io-affinity PS setups a path's transport/interconnect
> > perf is not going to flucuate a lot and there is no major differences
> > between paths, so QL/HST smarts do not help and RR always messes up
> > what the app is trying to do.
> > 
> > On a system with 16 cores, where you have a job per CPU:
> > 
> > fio --filename=/dev/dm-0 --direct=1 --rw=randrw --bs=4k \
> > --ioengine=libaio --iodepth=128 --numjobs=16
> > 
> > and a dm-multipath device setup where each CPU is mapped to one path:
> > 
> > // When in mq mode I had to set dm_mq_nr_hw_queues=$NUM_PATHS.
> 
> OK, the modparam was/is a means to an end but the default of 1 is very
> limiting (especially in that it becomes one-size-fits-all, which isn't
> true, for all dm-multipath devices in the system).
> 
> If you have any ideas for what a sane heuristic would be for
> dm_mq_nr_hw_queues I'm open to suggestions.  But DM target <-> DM core
> <-> early block core interface coordination is "fun". ;)
> 
> > // Bio mode also showed similar results.
> > 0 16777216 multipath 0 0 1 1 io-affinity 0 16 1 8:16 1 8:32 2 8:64 4
> > 8:48 8 8:80 10 8:96 20 8:112 40 8:128 80 8:144 100 8:160 200 8:176
> > 400 8:192 800 8:208 1000 8:224 2000 8:240 4000 65:0 8000
> > 
> > we can see a IOPs increase of 25%.
> 
> Great. What utility/code are you using to extract the path:cpu affinity?
> Is it array specific?  Which hardware pins IO like this?
> 
> Will you, or others, be enhancing multipath-tools to allow passing such
> io-affinity DM multipath tables?
> 
> > The percent increase depends on the device and interconnect. For a
> > slower/medium speed path/device that can do around 180K IOPs a path
> > if you ran that fio command to it directly we saw a 25% increase like
> > above. Slower path'd devices that could do around 90K per path showed
> > maybe around a 2 - 5% increase. If you use something like null_blk or
> > scsi_debug which can multi-million IOPs and hack it up so each device
> > they export shows up as a path then you see 50%+ increases.
> > 
> > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > ---
> >  drivers/md/Kconfig          |   9 ++
> >  drivers/md/Makefile         |   1 +
> >  drivers/md/dm-io-affinity.c | 272 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 282 insertions(+)
> >  create mode 100644 drivers/md/dm-io-affinity.c
> > 
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index 30ba357..c82d8b6 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -463,6 +463,15 @@ config DM_MULTIPATH_HST
> >  
> >  	  If unsure, say N.
> >  
> > +config DM_MULTIPATH_IOA
> > +	tristate "I/O Path Selector based on CPU submission"
> > +	depends on DM_MULTIPATH
> > +	help
> > +	  This path selector selects the path based on the CPU the IO is
> > +	  executed on and the CPU to path mapping setup at path addition time.
> > +
> > +	  If unsure, say N.
> > +
> >  config DM_DELAY
> >  	tristate "I/O delaying target"
> >  	depends on BLK_DEV_DM
> > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > index 6d3e234..4f95f33 100644
> > --- a/drivers/md/Makefile
> > +++ b/drivers/md/Makefile
> > @@ -59,6 +59,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
> >  obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
> >  obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
> >  obj-$(CONFIG_DM_MULTIPATH_HST)	+= dm-historical-service-time.o
> > +obj-$(CONFIG_DM_MULTIPATH_IOA)	+= dm-io-affinity.o
> >  obj-$(CONFIG_DM_SWITCH)		+= dm-switch.o
> >  obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
> >  obj-$(CONFIG_DM_PERSISTENT_DATA)	+= persistent-data/
> 
> Thinking about renaming all PS files to have a dm-ps prefix...
> 
> Fact that we have dm-io.c makes dm-io-affinity.c all the more confusing.
> 
> Can you rename to dm-ps-io-affinity.c and post v2?

You know what, I'll take care of it when I deal with the other path
selectors.

We'll need entries like this in Makefile:

dm-io-affinity-y += dm-ps-io-affinity.o

Otherwise the module won't be name dm-io-affinity and "io-affinity" on
DM table wouldn't autoload the kernel module.

Alternatively, MODALIAS can be used... might prefer that as it'd reduce
Makefile complexity for each path-selector.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

