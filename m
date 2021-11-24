Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE57C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637770241;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oOJ/gLJSDJRIBDR/wEuC0XAYoj17EaQU4LYJdfcKhb8=;
	b=aDf5lXOW06Y4aXMc47zAhEkpH4YQqCz8hYoWEPzPqRb6YbGtQhRlhJulND4Ma8atii3Ce7
	rYWeSc4gFmh7Sk0X8ptaLz2oDJWS6/x+oxpnEQFlHRUIucNRjOCCPAUg50gHNZIXvPlSTM
	PnaZrdhAfx8TIAknGiRZ2BpIjrPjRag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-zYDrbrUOPsCgdyfrUWbNDg-1; Wed, 24 Nov 2021 11:10:37 -0500
X-MC-Unique: zYDrbrUOPsCgdyfrUWbNDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8F1710144E0;
	Wed, 24 Nov 2021 16:10:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87A5D60C05;
	Wed, 24 Nov 2021 16:10:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0363B1809C89;
	Wed, 24 Nov 2021 16:10:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AOGAPNd030645 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 11:10:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6A3DB5DF2B; Wed, 24 Nov 2021 16:10:25 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 156AF5D9C0;
	Wed, 24 Nov 2021 16:10:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 1AOGA6o0014896; Wed, 24 Nov 2021 11:10:06 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 1AOGA6Ra014892; Wed, 24 Nov 2021 11:10:06 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 24 Nov 2021 11:10:06 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: David Anderson <dvander@google.com>
In-Reply-To: <CA+FmFJBs9ocSbXHxdEncdGRRByamziXc+h9DMNH=r6qWPk3nzQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2111240819520.1631@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDJX8tVtGbuxo_Xqo=7GNd66W_FoVk=i6Kssp-6zP5cmmA@mail.gmail.com>
	<20211123231518.GA63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CA+FmFJBs9ocSbXHxdEncdGRRByamziXc+h9DMNH=r6qWPk3nzQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
	dm-devel@redhat.com, Akilesh Kailash <akailash@google.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 23 Nov 2021, David Anderson wrote:

> In our ecosystem, the OTA generation and on-device application process
> has evolved continually, in every release, for over 10 years now. So
> we think it's unlikely that we'll stop making improvements to it. Our
> current roadmap has other changes in the pipeline too. It's not just
> us trying to eek out diminishing returns. Other parts of the system
> change around us, and the OTA system needs to adapt.
> 
> The performance penalty is something we've been working on, and have
> improved a lot since our first iteration. We're currently
> experimenting with io_uring as well.
> 
> Best,
> 
> -David

Hi

I understand that an update format developed over 10 years will have 
better compression ratio than my format developed in 2 months.

I'd be interested in extending dm-update to handle your your update format 
and possibly add some abstraction, so that it can work with multiple 
formats.

You say that you have "COPY" and "XOR" operations.

How do you search for blocks that are similar, so that the "XOR" method is 
benefical for them? How do you make sure that you don't perform the "XOR" 
operation twice, if there's system crash when performing it?

Could it be possible for you to give us two Android images and a program 
that calculates difference between them? So that we could see how well we 
are performing compared to the existing solution.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

