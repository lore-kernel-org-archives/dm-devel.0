Return-Path: <SRS0=lnUw=KA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C19AC433B4
	for <dm-devel@archiver.kernel.org>; Wed,  5 May 2021 20:45:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9746E613E9
	for <dm-devel@archiver.kernel.org>; Wed,  5 May 2021 20:45:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9746E613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620247534;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5jzLUJeitWItC+THNE/cmz7KiVGiWH3TkXrH94vFYQ8=;
	b=Kf3QPfwg7OxzldXKEtrvNl0OQZCnz2GGGJuOtBcCjxmKxG59fTgFuXaQMMCmZoGAQv11s/
	/SRCqX+JK0BOgGWmHmMMNVrZxINnMrzYmoAAre+I4W64xqOsDpz5rf+Ry6Rjwa5XhwlSul
	X7bnokslh5yfKENET+D4o+shRWfjD38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-0NBntNWnNVaqqBspTdmF1w-1; Wed, 05 May 2021 16:45:31 -0400
X-MC-Unique: 0NBntNWnNVaqqBspTdmF1w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6205B6D5CA;
	Wed,  5 May 2021 20:45:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCAF51002D71;
	Wed,  5 May 2021 20:45:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 59C1555351;
	Wed,  5 May 2021 20:45:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 145KjNJG028000 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 May 2021 16:45:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 54C1118965; Wed,  5 May 2021 20:45:23 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0489150555;
	Wed,  5 May 2021 20:45:09 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 145Kj9iG010988; Wed, 5 May 2021 16:45:09 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 145Kj9OK010985; Wed, 5 May 2021 16:45:09 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 5 May 2021 16:45:09 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Melvin Vermeeren <vermeeren@vermwa.re>
In-Reply-To: <10258776.4TuPVb8Keo@verm-r4e>
Message-ID: <alpine.LRH.2.02.2105051642300.32187@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<2912930.OmXdaqUpTP@verm-r4e>
	<alpine.LRH.2.02.2105051604580.32187@file01.intranet.prod.int.rdu2.redhat.com>
	<10258776.4TuPVb8Keo@verm-r4e>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
	Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm-integrity: if we have discard support,
 use it when recalculating
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



On Wed, 5 May 2021, Melvin Vermeeren wrote:

> On Wednesday, 5 May 2021 22:05:35 CEST Mikulas Patocka wrote:
> > Yes.
> 
> I fail to understand why that would be desired behaviour, as I see it it is 
> conflicting with current documentation in integritysetup(8):

So, we can ask Milan to update the manpage.

> > --integrity-recalculate
> > Automatically recalculate integrity tags in kernel on activation. The device
> > can be used during automatic integrity recalculation but becomes fully
> > integrity protected only after the background operation is finished. This
> > option is available since the Linux kernel version 4.19.
> 
> The device in SSD with discard case never receives integrity protection 
> because the metadata is filled with discard filler. Could you explain the 
> reasoning behind the patch?

It will receive integrity protection for the newly written data.

If you create an integrity device and make a filesystem on it, the newly 
written data matters. The old data that were on the filesystem before 
formatting it don't care and don't need to be protected.

> Thanks,

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

