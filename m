Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A29C3DA7A
	for <dm-devel@archiver.kernel.org>; Thu,  5 Jan 2023 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672934004;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ed5IU/KocL8MybcYsiFzAoNj9V+3/YLgAi5Ef+vI56o=;
	b=Ui3LN+jKQiSPlivoKzDgvZVSKxYWoiVlMNubk6phZ/pjfnC04lsttCIQB4cABeIlpZF2Bf
	MpjgnJyBNXBYIWKeq6CUnWlEEGRcHF4hckzOmRoS2Wgy/s6QdgC/j8upP01/o3oBhIkGVd
	13P/ZityE1HiuwUIYop6bsdR1IFplzU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-o79eiIqIOveNn8a69H6RCw-1; Thu, 05 Jan 2023 10:53:21 -0500
X-MC-Unique: o79eiIqIOveNn8a69H6RCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B69271C05EC0;
	Thu,  5 Jan 2023 15:53:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 226B453A0;
	Thu,  5 Jan 2023 15:53:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECDEB1946589;
	Thu,  5 Jan 2023 15:53:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8A751946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Jan 2023 15:53:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9CF59492B07; Thu,  5 Jan 2023 15:53:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94C23492B06
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 15:53:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D47E1C05EBF
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 15:53:14 +0000 (UTC)
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-kub5dpmKNXKPnJLF8mEoxA-7; Thu, 05 Jan 2023 10:53:12 -0500
X-MC-Unique: kub5dpmKNXKPnJLF8mEoxA-7
Received: from letrec.thunk.org (host-67-21-23-146.mtnsat.com [67.21.23.146]
 (may be forged)) (authenticated bits=0)
 (User authenticated as tytso@ATHENA.MIT.EDU)
 by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 305FnZPB011422
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 5 Jan 2023 10:49:44 -0500
Received: by letrec.thunk.org (Postfix, from userid 15806)
 id 02E768C0850; Thu,  5 Jan 2023 10:49:32 -0500 (EST)
Date: Thu, 5 Jan 2023 10:49:32 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <Y7bxjKusa2L/TNRE@mit.edu>
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
 <20221229081252.452240-4-sarthakkukreti@chromium.org>
 <Y7Wr2uadI+82BB6a@magnolia>
 <CAG9=OMNbeU=Xg5bWvHUSfzRf8vsk6csvcw5BGZeMD5Lo7dfKFQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMNbeU=Xg5bWvHUSfzRf8vsk6csvcw5BGZeMD5Lo7dfKFQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 3/7] fs: Introduce FALLOC_FL_PROVISION
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, sarthakkukreti@google.com,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 04, 2023 at 01:22:06PM -0800, Sarthak Kukreti wrote:
> > How expensive is this expected to be?  Is this why you wanted a separate
> > mode flag?
>
> Yes, the exact latency will depend on the stacked block devices and
> the fragmentation at the allocation layers.
> 
> I did a quick test for benchmarking fallocate() with an:
> A) ext4 filesystem mounted with 'noprovision'
> B) ext4 filesystem mounted with 'provision' on a dm-thin device.
> C) ext4 filesystem mounted with 'provision' on a loop device with a
> sparse backing file on the filesystem in (B).
> 
> I tested file sizes from 512M to 8G, time taken for fallocate() in (A)
> remains expectedly flat at ~0.01-0.02s, but for (B), it scales from
> 0.03-0.4s and for (C) it scales from 0.04s-0.52s (I captured the exact
> time distribution in the cover letter
> https://marc.info/?l=linux-ext4&m=167230113520636&w=2)
> 
> +0.5s for a 8G fallocate doesn't sound a lot but I think fragmentation
> and how the block device is layered can make this worse...

If userspace uses fallocate(2) there are generally two reasons.
Either they **really** don't want to get the NOSPC, in which case
noprovision will not give them what they want unless we modify their
source code to add this new FALLOC_FL_PROVISION flag --- which may not
be possible if it is provided in a binary-only format (for example,
proprietary databases shipped by companies beginning with the letters
'I' or 'O').

Or, they really care about avoiding fragmentation by giving a hint to
the file system that layout is important, and so **please** allocate
the space right away so that it is more likely that the space will be
laid out in a contiguous fashion.  Of course, the moment you use
thin-provisioning this goes out the window, since even if the space is
contiguous on the dm-thin layer, on the underlying storage layer it is
likely that things will be fragmented to a fare-thee-well, and either
(a) you have a vast amount of flash to try to mitigate the performance
hit of using thin-provisioning (example, hardware thin-provisioning
such as EMC storage arrays), or (b) you really don't care about
performance since space savings is what you're going for.

So.... because of the issue of changing the semantics of what
fallocate(2) will guarantee, unless programs are forced to change
their code to use this new FALLOC flag, I really am not very fond of
it.

I suspect that using a mount option (which should default to
"provision"; if you want to break user API expectations, it should
require a mount option for the system administrator to explicitly OK
such a change), is OK.

As far as the per-file mode --- I'm not convinced it's really
necessary.  In general if you are using thin-provisioning file systems
tend to be used explicitly for one purpose, so adding the complexity
of doing it on a per-file basis is probably not really needed.  That
being said, your existing prototype requires searching for the
extended attribute on every single file allocation, which is not a
great idea.  On a system with SELinux enabled, every file will have an
xattr block, and requiring that it be searched on every file
allocation would be unfortunate.  It would be better to check for the
xattr when the file is opened, and then setting a flag in the struct
file.  However, it might be better to see if it there is a real demand
for such a feature before adding it.

						- Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

