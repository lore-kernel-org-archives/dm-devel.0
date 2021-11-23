Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598EBC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 23:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637709565;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2Aw2P1LKjRIdkkS3uu3i5NrS+a4MR27D3fdV346RliU=;
	b=LPZrO1Q4Ur7c3Hx1Y82Pk2dPQszd6LkcezSzZyW67+u5qqJymXfgzgKRJswflRuFPT/8Jr
	/T6FgZyby1oRNegdWo3QiiMP4sfcDY57TOJzilkCSVAY8GIRBakz/t5Dx7YBxYIsdLH8pw
	O0Aia3bCq5zrzQw+30Hr+XAFLPPE6jk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-SJIZ6MFzM0iZ8O0QRckQOQ-1; Tue, 23 Nov 2021 18:19:21 -0500
X-MC-Unique: SJIZ6MFzM0iZ8O0QRckQOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAAB88026BB;
	Tue, 23 Nov 2021 23:19:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 973911972E;
	Tue, 23 Nov 2021 23:19:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 43BB21832E7F;
	Tue, 23 Nov 2021 23:19:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANNHWHc027517 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 18:17:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AFD44ABA1; Tue, 23 Nov 2021 23:17:32 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
	(agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1BA6660843;
	Tue, 23 Nov 2021 23:17:15 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
	from userid 3883)
	id 6CF2C424F08E; Tue, 23 Nov 2021 23:15:18 +0000 (GMT)
Date: Tue, 23 Nov 2021 23:15:18 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Akilesh Kailash <akailash@google.com>
Message-ID: <20211123231518.GA63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: Akilesh Kailash <akailash@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <msnitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	David Anderson <dvander@google.com>, dm-devel@redhat.com
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDJX8tVtGbuxo_Xqo=7GNd66W_FoVk=i6Kssp-6zP5cmmA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABSDvDJX8tVtGbuxo_Xqo=7GNd66W_FoVk=i6Kssp-6zP5cmmA@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod Street,
	Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	David Anderson <dvander@google.com>, Alasdair Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 02:27:18PM -0800, Akilesh Kailash wrote:
> On Tue, Nov 23, 2021 at 1:03 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
> Older devices do not get new kernel features, only LTS updates. On the
> other hand, by having
> it in user-space, we have more control by adding in new features. For
> ex: On Android S, we
> introduced the first version of Android COW format. Now in Android T,
> we plan to support
> new features by having XOR compression (which saves more space).

While you are developing this, sure, you're finding new ways that
make significant space savings and want to roll them out easily
and the userspace approach helps you to do that.

But the law of diminishing returns will eventually kick in, where you
have reached a format that provides "good enough" space savings and then
reducing the runtime performance penalty will become the overriding
concern and that'll point back to an in-kernel solution.

So that's the end point I think we are aiming for here.  Combining the
requirements to find a sweet spot between space saving and performance.
 
By then, the ability still to make a tweak that saves a tiny bit more
space isn't going to be worth paying an ongoing performance penalty
for.  (And there could still be some sort of ebpf-style option.)

Alasdair

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

