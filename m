Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBD0C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:15:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA42264EA1
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA42264EA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612235728;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x12i2WjmhD2KQsdZ428oB+PCW6B1txRlIGhGbdh0iws=;
	b=NNyA0O1dIjHkWrH9qxtZUcp/6MQ2xU5v2Zh+7B5WNYX0btqCvS0NEh3VluivDskTnaOyGS
	HNdIT4IOFgGaRztHbG1qKFDuerXWifLAN+1H8YXHijXvpcq3039elbPyv4m2k3oul01Sa+
	3BF2VpRlbBRwBedYmUo78i/GtabsWNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-6wAE8NeTOz26upAPjmMi5A-1; Mon, 01 Feb 2021 22:15:26 -0500
X-MC-Unique: 6wAE8NeTOz26upAPjmMi5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB213100C66B;
	Tue,  2 Feb 2021 03:15:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C50735D9CA;
	Tue,  2 Feb 2021 03:15:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 04AF34EBC6;
	Tue,  2 Feb 2021 03:15:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1123FH3q022627 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 22:15:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37D4E5D749; Tue,  2 Feb 2021 03:15:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E3D462461;
	Tue,  2 Feb 2021 03:15:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1123FAeR025331; 
	Mon, 1 Feb 2021 21:15:10 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1123F9RC025330;
	Mon, 1 Feb 2021 21:15:09 -0600
Date: Mon, 1 Feb 2021 21:15:09 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210202031509.GM15006@octiron.msp.redhat.com>
References: <20210128204544.18563-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210128204544.18563-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/3] multipath: fixes for SAS expanders and
	root FS access
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

On Thu, Jan 28, 2021 at 09:45:41PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> here are 3 patches I'd like to get reviewed before we create a pull
> request. The first two are related to complex SAS setups, the second
> one is to avoid accessing the root file system in a possible dangerous
> situation.
> 
> Wrt 2/3: while testing it, I discovered that "I_T_nexus_loss_timeout"
> is a read-only sysfs attribute, therefore this code does nothing.
> I considered removing it altogether, observing that the attribute has
> been read-only as long as it existed (v2.6.17, 2006). I'd like some
> feedback beforehand, though, perhaps some distros use patched kernels
> that make this attribute r/w?

I_T_nexus_loss_timeout appears to have always been read-only on RHEL and
Fedora.

-Ben

> 
> Regards
> Martin
> 
> Martin Wilck (3):
>   libmultipath: use 3rd digit as transport_id for expanders
>   libmultipath: sysfs_set_nexus_loss_tmo(): support SAS expanders
>   multipathd: add code to initalize unwinder
> 
>  libmultipath/discovery.c   | 35 ++++++++++++++++++++++++++++-------
>  multipathd/Makefile        |  2 +-
>  multipathd/init_unwinder.c | 34 ++++++++++++++++++++++++++++++++++
>  multipathd/init_unwinder.h | 21 +++++++++++++++++++++
>  multipathd/main.c          |  2 ++
>  5 files changed, 86 insertions(+), 8 deletions(-)
>  create mode 100644 multipathd/init_unwinder.c
>  create mode 100644 multipathd/init_unwinder.h
> 
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

