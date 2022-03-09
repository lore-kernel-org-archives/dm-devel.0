Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88745C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  9 Mar 2022 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646815912;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=gI5a5FBTCDfKZuB/tSB35LYWQS87TdvTnHamexFp6OE=;
	b=a1QQv6bvX56qpZJwPU0waK+GLHWL+aAdA1GOZSEPHyuq8gEBVOggtY6ddjme1dxrqTFlrC
	cYeZlvzyuMvwVmaoLSWXAX0sjLRbd+SKwB23jHQpPzuyI49mXfhPi9stlqRlY3oYAPxxGu
	cSpeh7hngwFc5kCJlgnjji4eE39iN/A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-_lysXLobMLmqoI5IINrl5Q-1; Wed, 09 Mar 2022 03:51:50 -0500
X-MC-Unique: _lysXLobMLmqoI5IINrl5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E35B6296A60D;
	Wed,  9 Mar 2022 08:51:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A068F141DC29;
	Wed,  9 Mar 2022 08:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 44C021966371;
	Wed,  9 Mar 2022 08:51:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9661C194F4AE
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Mar 2022 08:51:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F3E483160; Wed,  9 Mar 2022 08:51:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D016083168;
 Wed,  9 Mar 2022 08:51:43 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2298pgJ3020462; Wed, 9 Mar 2022 03:51:42 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2298pfEp020453; Wed, 9 Mar 2022 03:51:41 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 9 Mar 2022 03:51:41 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <23895da7-bcec-d092-373a-c3d961ab5c48@arrikto.com>
Message-ID: <alpine.LRH.2.02.2203090347500.17712@file01.intranet.prod.int.rdu2.redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
 <012723a9-2e9c-c638-4944-fa560e1b0df0@arrikto.com>
 <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
 <23895da7-bcec-d092-373a-c3d961ab5c48@arrikto.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
 Offload
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
Cc: "djwong@kernel.org" <djwong@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "osandov@fb.com" <osandov@fb.com>,
 "msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "roland@purestorage.com" <roland@purestorage.com>,
 "zach.brown@ni.com" <zach.brown@ni.com>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>,
 "kbus @imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
 "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
 Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
 "martin.petersen@oracle.com >> Martin K. Petersen"
 <martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: MULTIPART/MIXED;
 BOUNDARY="185206533-1881345822-1646815902=:17712"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-1881345822-1646815902=:17712
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Tue, 8 Mar 2022, Nikos Tsironis wrote:

> My work focuses mainly on improving the IOPs and latency of the
> dm-snapshot target, in order to bring the performance of short-lived
> snapshots as close as possible to bare-metal performance.
> 
> My initial performance evaluation of dm-snapshot had revealed a big
> performance drop, while the snapshot is active; a drop which is not
> justified by COW alone.
> 
> Using fio with blktrace I had noticed that the per-CPU I/O distribution
> was uneven. Although many threads were doing I/O, only a couple of the
> CPUs ended up submitting I/O requests to the underlying device.
> 
> The same issue also affects dm-clone, when doing I/O with sizes smaller
> than the target's region size, where kcopyd is used for COW.
> 
> The bottleneck here is kcopyd serializing all I/O. Users of kcopyd, such
> as dm-snapshot and dm-clone, cannot take advantage of the increased I/O
> parallelism that comes with using blk-mq in modern multi-core systems,
> because I/Os are issued only by a single CPU at a time, the one on which
> kcopyd’s thread happens to be running.
> 
> So, I experimented redesigning kcopyd to prevent I/O serialization by
> respecting thread locality for I/Os and their completions. This made the
> distribution of I/O processing uniform across CPUs.
> 
> My measurements had shown that scaling kcopyd, in combination with
> scaling dm-snapshot itself [1] [2], can lead to an eventual performance
> improvement of ~300% increase in sustained throughput and ~80% decrease
> in I/O latency for transient snapshots, over the null_blk device.
> 
> The work for scaling dm-snapshot has been merged [1], but,
> unfortunately, I haven't been able to send upstream my work on kcopyd
> yet, because I have been really busy with other things the last couple
> of years.
> 
> I haven't looked into the details of copy offload yet, but it would be
> really interesting to see how it affects the performance of random and
> sequential workloads, and to check how, and if, scaling kcopyd affects
> the performance, in combination with copy offload.
> 
> Nikos

Hi

Note that you must submit kcopyd callbacks from a single thread, otherwise 
there's a race condition in snapshot.

The snapshot code doesn't take locks in the copy_callback and it expects 
that the callbacks are serialized.

Maybe, adding the locks to copy_callback would solve it.

Mikulas
--185206533-1881345822-1646815902=:17712
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--185206533-1881345822-1646815902=:17712--

