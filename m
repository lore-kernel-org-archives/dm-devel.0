Return-Path: <SRS0=qgMK=F2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2F9C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 14:38:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7DF33221FC
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 14:38:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DF33221FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608647884;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9/2G2eho/8ULM4YbwgwWY9I488d4s1++bRkXUPv2JRc=;
	b=CXqinC2RnDfpJCu37+riAutL9yGr4Uxk1MHOzxqWUUiq8ZP555NGdOW80r2VY7pmI9K/mw
	4en4HJmeaSNTp99wr3c8Zu+kZER0kmHypLJj34rhLDu9UvWRTGb1jfyUXYxhKDd6xjfG0S
	bbgimXRGDlxK6nE+CBn5YjboNdJlF8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-Ry8HqHInPUefjHnjO8ISIQ-1; Tue, 22 Dec 2020 09:38:00 -0500
X-MC-Unique: Ry8HqHInPUefjHnjO8ISIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53C7A8735CC;
	Tue, 22 Dec 2020 14:37:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE9B35D72E;
	Tue, 22 Dec 2020 14:37:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8AF4E180954D;
	Tue, 22 Dec 2020 14:37:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BMEaKok021553 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Dec 2020 09:36:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B7BD36F130; Tue, 22 Dec 2020 14:36:20 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24A0D6F977;
	Tue, 22 Dec 2020 14:36:17 +0000 (UTC)
Date: Tue, 22 Dec 2020 09:36:16 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20201222143616.GB12885@redhat.com>
References: <30d39293-80a4-9ef5-92bb-6b6dec464be3@toxicpanda.com>
	<mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
	<20201222133246.GA5099@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20201222133246.GA5099@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: bvanassche@acm.org, corbet@lwn.net, shuah@kernel.org,
	linux-doc@vger.kernel.org, josef@toxicpanda.com,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com,
	Palmer Dabbelt <palmer@dabbelt.com>, michael.christie@oracle.com,
	linux-kselftest@vger.kernel.org, kernel-team@android.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
 BIOs to userspace
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 22 2020 at  8:32am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Dec 14, 2020 at 07:00:57PM -0800, Palmer Dabbelt wrote:
> > I haven't gotten a whole lot of feedback, so I'm inclined to at least have some
> > reasonable performance numbers before bothering with a v2.
> 
> FYI, my other main worry beside duplicating nbd is that device mapper
> really is a stacked interface that sits on top of other block device.
> Turning this into something else that just pipes data to userspace
> seems very strange.

I agree.  Only way I'd be interested is if it somehow tackled enabling
much more efficient IO.  Earlier discussion in this thread mentioned
that zero-copy and low overhead wasn't a priority (because it is hard,
etc).  But the hard work has already been done with io_uring.  If
dm-user had a prereq of leaning heavily on io_uring and also enabled IO
polling for bio-based then there may be a win to supporting it.

But unless lower latency (or some other more significant win) is made
possible I just don't care to prop up an unnatural DM bolt-on.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

