Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A4FCC7EE24
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685720504;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hoIqVltPZK7A7rl21xz5cNSGMPu8INX0af5FYECUt0Q=;
	b=crru/2MSvGldu4rnkCM/5g1NNbx5mdaW8HmZfb7cFIo51fdmthxnE3NMI1Aam4PrvGfN8n
	d8OEK0qlxOBdLvqT+E6b8wdghs+GNvx9KgHpKBLqCyyz8SwF0Kh9MtbsglEYBhAGwptV45
	6ybJSGZ6ripQ7q2rJs3gIrusobEX1ZY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-smXbpOk3MVu0MLzZPCL-tA-1; Fri, 02 Jun 2023 11:41:43 -0400
X-MC-Unique: smXbpOk3MVu0MLzZPCL-tA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF111185A78B;
	Fri,  2 Jun 2023 15:41:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81A5B492B0A;
	Fri,  2 Jun 2023 15:41:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 607E01946595;
	Fri,  2 Jun 2023 15:41:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 73B95194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 15:41:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F4279E63; Fri,  2 Jun 2023 15:41:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5860F9E60
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 15:41:36 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BD5B3850548
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 15:41:36 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-uh8AeqVlM9CcvNw5ueNbOQ-1; Fri, 02 Jun 2023 11:41:34 -0400
X-MC-Unique: uh8AeqVlM9CcvNw5ueNbOQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 7E35F68AA6; Fri,  2 Jun 2023 17:41:30 +0200 (CEST)
Date: Fri, 2 Jun 2023 17:41:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20230602154130.GA26710@lst.de>
References: <20230601072829.1258286-1-hch@lst.de>
 <20230601072829.1258286-4-hch@lst.de>
 <CAHk-=wj3TrM-NWUcFUivefNwzbfGdfcgDGfGP12m6WBfH9JpWg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj3TrM-NWUcFUivefNwzbfGdfcgDGfGP12m6WBfH9JpWg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 3/3] block: fail writes to read-only devices
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
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[quoting your reply out of order, because I think it makes sense that
 way]

On Thu, Jun 01, 2023 at 09:02:25PM -0400, Linus Torvalds wrote:
> So honestly, that whole test for
> 
> +       if (op_is_write(bio_op(bio)) && bio_sectors(bio) &&
> +           bdev_read_only(bdev)) {
> 
> may look "obviously correct", but it's also equally valid to view it
> as "obviously garbage", simply because the test is being done at the
> wrong point.
> 
> The same way you can write to a file that was opened for writing, but
> has then become read-only afterwards, writing to a device with a bdev
> that was writable when you *started* writing is not at all necessarily
> wrong.

files, or more specifically file descriptors really are the wrong
analogy here.  A file descriptor allows you to keep writing to
a file that you were allowed to write to at open time.  And that's
fine (at least most of the time, people keep wanting a revoke and
keep implementing broken special cases of it, but I disgress).

The struct block_device is not such a handle, it's the underlying
object.  And the equivalent here is that we allow writes to inodes
that don't even implement a write method, or have the immutable
bit set.

> The logic wrt "bdev_read_only()" is not necessarily a "right now it's
> read-only", but more of a thing that should be checked purely when the
> device is opened. Which is pretty much exactly what we do.

Except the whole make a thing readonly just for fun is the corner case.
DM does it, and we have a sysfs file to allow it.  But the usual
case is that a block device has been read-only all the time, or has
been force to be read-only by the actual storage device, which
doesn't know anything about the file descriptor model, and will
not be happy.

So maybe a lazy read-only after the last writer goes away would be
nice (not that we actully track writers right now, but that whole
area is comletely fucked up and I'm looking into fixing it at the
moment).

And for extra fun blkdev_get_by_dev doesn't check for read-only
because we've historically allowed to open writable file descriptors
on read-only block devices for ioctls (in addition to the magic
(flags & O_ACCMODE) == 3 mode just ioctl). 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

