Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D5BC6FA82
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 08:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663923104;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C1Po8CZYxZyqIezHtZZXGtQhZ95RAszJwq4hojpUT6A=;
	b=JSt3+49caqocfNkbt8GGcBlHG0L9brvVHqI+96VEN1It9P2hP/d/qE6Pk48DTW504MUo1U
	uyohJT5oXkLTiMusEJm3HNkb5zaI/D4c982UHZFTjq5yj5c9hXYUDPu0jh1ycaXgKGazXl
	i9ZkLCAYXbGXv4pVmOrGQ3wnrWQGpz0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-ZtJBQojON16b1sa7bYtNWw-1; Fri, 23 Sep 2022 04:51:41 -0400
X-MC-Unique: ZtJBQojON16b1sa7bYtNWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87E3B101E159;
	Fri, 23 Sep 2022 08:51:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0E05D2166B2F;
	Fri, 23 Sep 2022 08:51:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF90E19465B6;
	Fri, 23 Sep 2022 08:51:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0179719465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 08:51:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E900C40C6E14; Fri, 23 Sep 2022 08:51:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1D6140C6E13
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 08:51:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C78D80C8C1
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 08:51:35 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-73-bwhZaDK5PzafSMzK55hZBA-1; Fri, 23 Sep 2022 04:51:31 -0400
X-MC-Unique: bwhZaDK5PzafSMzK55hZBA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1obePA-0033p5-F8; Fri, 23 Sep 2022 08:51:28 +0000
Date: Fri, 23 Sep 2022 01:51:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Daniil Lunev <dlunev@google.com>
Message-ID: <Yy1zkMH0f9ski4Sg@infradead.org>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <YyQTM5PRT2o/GDwy@fedora>
 <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
 <Yylvvm3zVgqpqDrm@infradead.org>
 <CAAKderPF5Z5QLxyEb80Y+90+eR0sfRmL-WfgXLp=eL=HxWSZ9g@mail.gmail.com>
 <YymkSDsFVVg1nbDP@infradead.org>
 <CAAKderNcHpbBqWqqd5-WuKLRCQQUt7a_4D4ti4gy15+fKGK0vQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAAKderNcHpbBqWqqd5-WuKLRCQQUt7a_4D4ti4gy15+fKGK0vQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@google.com>,
 virtualization@lists.linux-foundation.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 21, 2022 at 07:48:50AM +1000, Daniil Lunev wrote:
> > There is no such thing as WRITE UNAVAILABLE in NVMe.
> Apologize, that is WRITE UNCORRECTABLE. Chapter 3.2.7 of
> NVM Express NVM Command Set Specification 1.0b

Write uncorrectable is a very different thing, and the equivalent of the
horribly misnamed SCSI WRITE LONG COMMAND.  It injects an unrecoverable
error, and does not provision anything.

> * Each application is potentially allowed to consume the entirety
>   of the disk space - there is no strict size limit for application
> * Applications need to pre-allocate space sometime, for which
>   they use fallocate. Once the operation succeeded, the application
>   assumed the space is guaranteed to be there for it.
> * Since filesystems on the volumes are independent, filesystem
>   level enforcement of size constraints is impossible and the only
>   common level is the thin pool, thus, each fallocate has to find its
>   representation in thin pool one way or another - otherwise you
>   may end up in the situation, where FS thinks it has allocated space
>   but when it tries to actually write it, the thin pool is already
>   exhausted.
> * Hole-Punching fallocate will not reach the thin pool, so the only
>   solution presently is zero-writing pre-allocate.

To me it sounds like you want a non-thin pool in dm-thin and/or
guaranted space reservations for it.

> * Thus, a provisioning block operation allows an interface specific
>   operation that guarantees the presence of the block in the
>   mapped space. LVM Thin-pool itself is the primary target for our
>   use case but the argument is that this operation maps well to
>   other interfaces which allow thinly provisioned units.

I think where you are trying to go here is badly mistaken.  With flash
(or hard drive SMR) there is no such thing as provisioning LBAs.  Every
write is out of place, and a one time space allocation does not help
you at all.  So fundamentally what you try to here just goes against
the actual physics of modern storage media.  While there are some
layers that keep up a pretence, trying to that an an exposed API
level is a really bad idea.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

