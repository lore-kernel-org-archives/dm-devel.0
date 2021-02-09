Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DE5C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:30:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E85664EB1
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E85664EB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612848616;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oUEqQRNzvcyI/tzEEawflleRMXqcUkTGVC4auYJYQ4w=;
	b=GHZ//h+o7cE9nq3JtzbPz3yD/3GDQV9bpnKo7fgf5vmdhV2dj+w7XkG864cKP+3ARSBmCw
	+2ljlP/5PHfvgzsghyeD0EtsS17vOpFkZX2aLX4eShTHIWTCIMMxj/7AWj+3NyDov4DQ2/
	CNb6d8vtT0Ifj5WGBU3hdZog/hd1aEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-rAlLrG7zPdOXAWL25sbdlQ-1; Tue, 09 Feb 2021 00:30:14 -0500
X-MC-Unique: rAlLrG7zPdOXAWL25sbdlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8228E8030C2;
	Tue,  9 Feb 2021 05:30:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 313346E71A;
	Tue,  9 Feb 2021 05:30:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A7F018095CB;
	Tue,  9 Feb 2021 05:30:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1195U5PE030752 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 00:30:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 79BB860C05; Tue,  9 Feb 2021 05:30:05 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CF1560C04;
	Tue,  9 Feb 2021 05:30:00 +0000 (UTC)
Date: Tue, 9 Feb 2021 00:29:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20210209052959.GA25714@redhat.com>
References: <20210202033528.76166-1-jefflexu@linux.alibaba.com>
	<20210205183909.GA4722@redhat.com>
	<59ca57e0-5a5f-33b6-24ed-90d615c40949@linux.alibaba.com>
	<20210208151700.GA22064@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210208151700.GA22064@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: joseph.qi@linux.alibaba.com, msb@chromium.org, dm-devel@redhat.com,
	toshi.kani@hpe.com, mbroz@redhat.com
Subject: Re: [dm-devel] dm: fix iterate_device sanity check
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 08 2021 at 10:17am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Feb 05 2021 at  9:03pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
> 
> > 
> > 
> > On 2/6/21 2:39 AM, Mike Snitzer wrote:
> > > On Mon, Feb 01 2021 at 10:35pm -0500,
> > > Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> > > 
> > >> According to the definition of dm_iterate_devices_fn:
> > >>  * This function must iterate through each section of device used by the
> > >>  * target until it encounters a non-zero return code, which it then returns.
> > >>  * Returns zero if no callout returned non-zero.
> > >>
> > >> For some target type (e.g., dm-stripe), one call of iterate_devices() may
> > >> iterate multiple underlying devices internally, in which case a non-zero
> > >> return code returned by iterate_devices_callout_fn will stop the iteration
> > >> in advance.
> > >>
> > >> Thus if we want to ensure that _all_ underlying devices support some kind of
> > >> attribute, the iteration structure like dm_table_supports_nowait() should be
> > >> used, while the input iterate_devices_callout_fn should handle the 'not
> > >> support' semantics. On the opposite, the iteration structure like
> > >> dm_table_any_device_attribute() should be used if _any_ underlying device
> > >> supporting this attibute is sufficient. In this case, the input
> > >> iterate_devices_callout_fn should handle the 'support' semantics.
> > >>
> > >> Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
> > >> Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
> > >> Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
> > >> Cc: stable@vger.kernel.org
> > >> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> > > 
> > > Thanks for auditing and fixing this up.  It has been on my todo so
> > > you've really helped me out -- your changes look correct to me.
> > > 
> > > I've staged it for 5.12, the stable fix will likely need manual fixups
> > > depending on the stable tree... we'll just need to assist with
> > > backport(s) as needed.
> > 
> > I'm glad to help offer the stable backport. But I don't know which
> > kernel version the stable kernel is still being maintained. Also which
> > mailing list I should send to when I finished backporting?
> 
> All your v2 changes speak to needing more discipline in crafting
> individual stable@ fixes that are applicable to various kernels.. when
> all applied to mainline then it'd be the equivalent of your single
> monolithic patch.
> 
> But without splitting the changes into separate patches, for stable@'s
> benefit, we'll have a much more difficult time of shepherding the
> applicable changes into the disparate stable@ kernels.
> 
> I'll have a look at splitting your v2 up accordingly.

Hi, please see these commits that I've staged in linux-next via:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

1141b9133777 dm table: fix iterate_devices based device capability checks
0224c5e6fd07 dm table: fix DAX iterate_devices based device capability checks
76b0e14be03f dm table: fix zoned iterate_devices based device capability checks
55cdd7435e97 dm table: remove needless request_queue NULL pointer checks

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

