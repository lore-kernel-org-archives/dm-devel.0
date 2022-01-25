Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F653C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jan 2022 00:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643070253;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/Ls1A/xLpRz9NdNINKkWh7/eheO3VsjmYDD8OI4lJ/A=;
	b=bnnNkh6c8h6w4ZT7xUyyUGR67BAH5ejy8u/hCBB0KmR+a16kstTmSOWNBj1qxUHN/p92NF
	a2kqAQAbtM5FuJlc7L6WzHRdQG2h65kd+vlH3jqOHCsUGIn6VWEzYduAJGbUNCff32YYk9
	bNs3aWlJ9fx7+fJ8ZnKvLlt7A50rEFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-cPerTauWPUunFjWp64oGNw-1; Mon, 24 Jan 2022 19:24:09 -0500
X-MC-Unique: cPerTauWPUunFjWp64oGNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D34672F4B;
	Tue, 25 Jan 2022 00:24:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 202751042551;
	Tue, 25 Jan 2022 00:24:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 086AD1809CB9;
	Tue, 25 Jan 2022 00:24:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20P0KxZJ032697 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 Jan 2022 19:20:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AA6105F91C; Tue, 25 Jan 2022 00:20:59 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
	(agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B3E05F90F;
	Tue, 25 Jan 2022 00:20:25 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
	from userid 3883)
	id CDF2F424F088; Tue, 25 Jan 2022 00:20:25 +0000 (GMT)
Date: Tue, 25 Jan 2022 00:20:25 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Brian Geffon <bgeffon@google.com>
Message-ID: <20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: Brian Geffon <bgeffon@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
References: <20220124150209.22202-1-bgeffon@google.com>
	<20220124151434.GB20331@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CADyq12ykDCswWZw05OdyYfP-zT6afuhXbckii1m1egQ2fSwB4w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADyq12ykDCswWZw05OdyYfP-zT6afuhXbckii1m1egQ2fSwB4w@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod Street,
	Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH] dm: introduce a no open flag for deferred
	remove
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24, 2022 at 10:25:47AM -0500, Brian Geffon wrote:
> Thank you for looking at this. There are a few reasons this might be
> useful, the first is if you're trying to speed up a graceful teardown
> of the device by informing userspace that this device is going to be
> removed in the near future. Another might be on systems where it might
> be worthwhile to not have users with CAP_DAC_OVERRIDE be able to open
> the device. The logic on this second case is that, suppose you have a
> dm-crypt block device which is backing swap, the data on this device
> is ephemeral so a flow might be to setup swap followed by dmsetup
> remove --deferred /dev/mapper/encrypted-swap. This will guarantee that
> as soon as swap is torn down the encrypted block device is dropped,
> additionally with this new flag you'll be guaranteed that there can be
> no further opens on it.
 
And is that the reason you propose this?
- You want a special exclusive 'one time open' device that 
  self-destructs when closed?

> No, this is fully backwards compatible with the current deferred
> remove behavior, it's not required. Additionally, since on the actual
> remove userspace would receive an -ENXIO already once the remove
> process has started it seems reasonable to return -ENXIO in the
> deferred remove case when this flag is enabled.
 
Well I feel it does break existing semantics which is why we wrote
the code the way we did.  The state can be long-lived, the code
that has it open might legitimately want to open it again in
parallel etc. - in general this seems a bad idea.

But if the reason for this is basically "make it harder for 
anything else to access my encrypted swap" and to deliberately
prevent access, then let's approach the requirement from that angle.
Are there alternative implementations with interventions at different
points?  Are there similar requirements for devices that don't need
deferred remove?  If this is indeed the best place to insert this type
of restriction, then we should label it and document it accordingly so
people don't mistakenly use it for the 'normal' case.  (We always keep
libdevmapper and dmsetup in sync with kernel interface extensions, so
we'd seek a tiny patch to do that too.)

Alasdair

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

