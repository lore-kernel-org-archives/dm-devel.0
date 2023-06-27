Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557ACEB64DC
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jun 2023 15:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687881009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2KxA6CvGk7i3yJlfDSqf7ZNtCGPU3fbEBNNFN0Jg7WA=;
	b=MwiUPaXqKlFnnC2U+/hQ4sm7KdQX5XUmO9cmyIE1v9XT8S1/0We3r0Uu94cla/damEPSui
	d9OlRnQP8/kWONv5efOiVEjXxAMfZ4YhTRpbYqO1kgnR3/63ywdphUY8xu4ZjrltrH9iUQ
	OEgO90updjP+TQz/VX5z0sjtZTD4t5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-lXPVcyymN761HKb-piPXlA-1; Tue, 27 Jun 2023 11:50:07 -0400
X-MC-Unique: lXPVcyymN761HKb-piPXlA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF914854C29;
	Tue, 27 Jun 2023 15:50:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18BFC40C6CD1;
	Tue, 27 Jun 2023 15:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AABD71946588;
	Tue, 27 Jun 2023 15:50:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 525291946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Jun 2023 15:50:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3ACF040BB4D; Tue, 27 Jun 2023 15:50:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 322BA40D1A4
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 15:50:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14B193813F45
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 15:50:01 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-juR5mG5iNjKPy6LOvkl54g-1; Tue, 27 Jun 2023 11:49:55 -0400
X-MC-Unique: juR5mG5iNjKPy6LOvkl54g-1
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1qEAx0-00DZ76-0y; Tue, 27 Jun 2023 15:49:54 +0000
Date: Tue, 27 Jun 2023 08:49:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZJsFIkpj/+CdrQ1W@infradead.org>
References: <1a33ace-57f9-9ef9-b967-d6617ca33089@redhat.com>
 <f9e830ef-adf7-4196-a46f-ba4e65cbb54d@redhat.com>
MIME-Version: 1.0
In-Reply-To: <f9e830ef-adf7-4196-a46f-ba4e65cbb54d@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] block: flush the disk cache on BLKFLSBUF
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Marc Smith <msmith626@gmail.com>,
 Jens Axboe <axboe@kernel.dk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 27, 2023 at 05:31:12PM +0200, Mikulas Patocka wrote:
> Marc Smith reported a bug where he wrote to the dm-writecache target using 
> O_DIRECT, then reset the machine without proper shutdown and the freshly 
> written data were lost. It turned out that he didn't use the fsync or 
> fdatasync syscall (and dm-writecache makes its metadata persistent on a 
> FLUSH bio).

Which so far is expected.  Even with O_DIRECT you need O_(D)SYNC or
fsync/fdatasync to persist data.

> When I was analyzing this issue, it turned out that there is no easy way 
> how to send the FLUSH bio to a block device from a command line.

xfs_io -c fsync /dev/foo

> The "blockdev --flushbufs" command also doesn't send the FLUSH bio, but I 
> would expect it to send it. Without sending the FLUSH bio, "blockdev 
> --flushbufs" doesn't really guarantee anything.

I wouldn't expect it.  It's a really weird legacy thing that calls
back up into the file system, but only if it sets s_bdev to this
device.  I don't think we should add new users of it that overload the
semantics.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

