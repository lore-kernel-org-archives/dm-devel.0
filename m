Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC8AC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 18:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641925336;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UCn6D6eQ8SklrzcucPpT7DgovKIPiWCe5VlPkTck+j4=;
	b=dHWR9LPiGFWqJ8ujOV3HIO/W1e+e0M3BB/lu6K2hVW5//m4/cIgeng3vqnbpr9TICYUoTJ
	UmNw3mPo7fDalBqBkdPdiz18GqMs6IxFqNLRqO6uPpXTJAxRdN7vbwEtWGOuXbE9b7pE9R
	+Niw3KAQ09igFPyVAtqH2BYpTHEEinU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-MLn9E5qgPzaRoi3ONrWmyA-1; Tue, 11 Jan 2022 13:22:13 -0500
X-MC-Unique: MLn9E5qgPzaRoi3ONrWmyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF0DA2F25;
	Tue, 11 Jan 2022 18:22:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 967FB7A405;
	Tue, 11 Jan 2022 18:22:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5268C4BB7C;
	Tue, 11 Jan 2022 18:22:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20BILmi5011585 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 13:21:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 09EC38C089; Tue, 11 Jan 2022 18:21:48 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com
	(segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 053C67A3F6;
	Tue, 11 Jan 2022 18:21:22 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<YcH/E4JNag0QYYAa@infradead.org> <YcP4FMG9an5ReIiV@T590>
	<YcuB4K8P2d9WFb83@redhat.com> <Yd1BFpYTBlQSPReW@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 11 Jan 2022 13:23:53 -0500
In-Reply-To: <Yd1BFpYTBlQSPReW@infradead.org> (Christoph Hellwig's message of
	"Tue, 11 Jan 2022 00:34:30 -0800")
Message-ID: <x49ee5ejfly.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] blk-mq/dm-rq: support BLK_MQ_F_BLOCKING
	for dm-rq
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Dec 28, 2021 at 04:30:08PM -0500, Mike Snitzer wrote:
>> Yeah, people use request-based for IO scheduling and more capable path
>> selectors. Imposing bio-based would be a pretty jarring workaround for 
>> BLK_MQ_F_BLOCKING. request-based DM should properly support it.
>
> Given that nvme-tcp is the only blocking driver that has multipath
> driver that driver explicitly does not intend to support dm-multipath
> I'm absolutely against adding block layer cruft for this particular
> use case.

Maybe I have bad taste, but the patches didn't look like cruft to me.
:)

I'm not sure why we'd prevent users from using dm-mpath on nvmeof.  I
think there's agreement that the nvme native multipath implementation is
the preferred way (that's the default in rhel9, even), but I don't think
that's a reason to nack this patch set.

Or have I missed your point entirely?

Thanks!
Jeff

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

