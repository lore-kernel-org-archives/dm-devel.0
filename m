Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF4CC83F16
	for <dm-devel@archiver.kernel.org>; Tue, 29 Aug 2023 06:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693292040;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rbURTZ7zn30u+tne/TDxuoILXPJRCdtD0TmjCwK7t/A=;
	b=f7abRtBnA9rL9EGtVElQMDWpg7W9+i9aS6AnQUeDiL/kxZmyCE2wJnC45w/n5qPm+a5rmo
	goJxMmdokHwwzw2gAlzHBytrMTERNWbAlyNSH5Ga2amrfpOFq7ZiKlRZ51YKGEw2S8t6bF
	mWIRABe+rw8GgBAF6HIEJK4CC4JaRjc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-VRzjY4TEPjGRjWfNsu9Crg-1; Tue, 29 Aug 2023 02:53:57 -0400
X-MC-Unique: VRzjY4TEPjGRjWfNsu9Crg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 842181C04326;
	Tue, 29 Aug 2023 06:53:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7DA5C40C6F4C;
	Tue, 29 Aug 2023 06:53:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C74319465B3;
	Tue, 29 Aug 2023 06:53:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0EF81946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 13:21:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 89EE3402D90; Mon, 28 Aug 2023 13:21:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80F34401051
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 13:21:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5541A185A7A3
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 13:21:08 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-rFdlpyCANXSg-IzBVuBOOA-1; Mon, 28 Aug 2023 09:21:06 -0400
X-MC-Unique: rFdlpyCANXSg-IzBVuBOOA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1E9A96187E;
 Mon, 28 Aug 2023 13:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6569C433C8;
 Mon, 28 Aug 2023 13:20:54 +0000 (UTC)
Date: Mon, 28 Aug 2023 15:20:47 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Message-ID: <20230828-durften-hauswand-67319ee0c17c@brauner>
References: <20230810171429.31759-1-jack@suse.cz>
 <20230825015843.GB95084@ZenIV>
 <20230825134756.o3wpq6bogndukn53@quack3>
MIME-Version: 1.0
In-Reply-To: <20230825134756.o3wpq6bogndukn53@quack3>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 29 Aug 2023 06:53:51 +0000
Subject: Re: [dm-devel] [PATCH v2 0/29] block: Make blkdev_get_by_*() return
 handle
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 "Darrick J. Wong" <djwong@kernel.org>, linux-nvme@lists.infradead.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, dm-devel@redhat.com,
 target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
 Jack Wang <jinpu.wang@ionos.com>, Alasdair Kergon <agk@redhat.com>,
 drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Christoph Hellwig <hch@infradead.org>, xen-devel@lists.xenproject.org,
 Gao Xiang <xiang@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Chao Yu <chao@kernel.org>,
 Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
 linux-mm@kvack.org, Song Liu <song@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, linux-fsdevel@vger.kernel.org,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> So besides my last fput() worry about I think this could work and would be
> probably a bit nicer than what I have. But before going and redoing the whole
> series let me gather some more feedback so that we don't go back and forth.
> Christoph, Christian, Jens, any opinion?

I'll be a bit under water for the next few days, I expect but I'll get
back to this. I think not making you redo this whole thing from scratch
is what I'd prefer unless there's really clear advantages. But I don't
want to offer a haphazard opinion in the middle of the merge window.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

