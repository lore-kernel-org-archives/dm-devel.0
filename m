Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1437C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  2 Apr 2022 03:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648871404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FZO1g8gA4RxsoE0fd+zQPXFr3UD3b+KMWuwRxZ8+7G0=;
	b=JswLRBjLsLaVCv+K92Q9pmSBYkKHXeEdTI51xhd4hwKYx2QQRfOsT2R9Ne7LCG/bN0W6F3
	QJyia/JYjCIqycZp5Js7EP7qXUi+/UHPjejlz0AOQEDpAEdsB6v0GdBBc9DR1b+pH9vJ1V
	/dxJfAwaC/GzFlMXxfGF5HMg8WXZLU4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-XWe0Oq4OMGK9PSgm7rVUxQ-1; Fri, 01 Apr 2022 23:49:59 -0400
X-MC-Unique: XWe0Oq4OMGK9PSgm7rVUxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65B1F8002BF;
	Sat,  2 Apr 2022 03:49:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 15DCB9E75;
	Sat,  2 Apr 2022 03:49:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB00D1949761;
	Sat,  2 Apr 2022 03:49:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D2D511949761
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Apr 2022 03:49:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B46CD200BC58; Sat,  2 Apr 2022 03:49:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CD17200A4F0;
 Sat,  2 Apr 2022 03:49:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2323nnj5015947;
 Fri, 1 Apr 2022 22:49:49 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2323nml7015946;
 Fri, 1 Apr 2022 22:49:48 -0500
Date: Fri, 1 Apr 2022 22:49:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220402034948.GW24684@octiron.msp.redhat.com>
References: <20220330221510.22578-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220330221510.22578-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 00/14] Rework uevent filtering and merging
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
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 On Thu, Mar 31, 2022 at 12:14:56AM +0200, mwilck@suse.com wrote:
> Hi Ben, hi Christophe, hi Tang Junhui,
> 
> the bulk of this patch set (3-8) is a rework of the uevent filtering and
> merging logic introduced in commit ee8888f ("multipath-tools: improve 
> processing efficiency for addition and deletion of multipath devices"),
> by Tang Junhui.
> 
> The rationale is explained in detail in the commit message in patch 08/14.
> TL;DR: The previous approach delayed uevent handling, possibly a lot, which
> is often undesirable. The new logic passes events to the dispatcher
> immediately, but if they queue up (because the dispatcher can't keep
> up with the rate at which events arrive, or is blocked e.g. by the
> path checker), the dispatcher will apply filtering and merging
> between servicing individual events. This worked well in my own testing,
> but I'd appreciate if ZTE could give it a shot in their special test
> environment.
> 
> Patch 9-14 add some more improvements to the uevent handling code, and
> improve logging. The first 2 patches are unrelated fixes.
> 
> Comments welcome,
> 
> Martin

For everything except 04, 05, and 06

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

BTW, for some reason, these emails didn't come through a plain test for
me.

> 
> Martin Wilck (14):
>   multipathd: allow adding git rev as version suffix
>   multipathd: don't switch to DAEMON_IDLE during startup
>   uevent_dispatch(): use while in wait loop
>   libmultipath: uevent_dispatch(): process uevents one by one
>   libmultipath: uevent_dispatch(): only filter/merge new uevents
>   multipathd: reconfigure: disallow changing uid_attrs
>   libmultipath: microoptimize uevent filtering and merging
>   libmultipath: uevent_listen(): don't delay uevents
>   libmultipath: uevent: use struct to pass parameters around
>   libmultipath: uevent: log statistics about filtering and merging
>   libmultipath: merge_uevq(): filter first, then merge
>   libmultipath: uevent_filter(): filter previously merged events
>   libmultipath: uevent: improve log messages
>   libmultipath: uevent: add debug messages for event queue
> 
>  Makefile.inc               |   3 +-
>  libmultipath/config.c      |   6 +-
>  libmultipath/config.h      |   4 +-
>  libmultipath/discovery.c   |   2 +-
>  libmultipath/list.h        |  53 +++++
>  libmultipath/structs.h     |   2 +-
>  libmultipath/uevent.c      | 407 ++++++++++++++++++++++---------------
>  libmultipath/uevent.h      |   3 +-
>  multipath/multipath.conf.5 |   2 +
>  multipathd/main.c          |  59 ++++--
>  tests/uevent.c             |   2 +-
>  11 files changed, 354 insertions(+), 189 deletions(-)
> 
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

