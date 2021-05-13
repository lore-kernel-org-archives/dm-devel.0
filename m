Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BDFC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:22:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A019B613C4
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A019B613C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620933774;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CBpC/Shp4gQFHZ8a0lwlWQDonDSCFTbUWWPabLDvnJA=;
	b=KlFoPTRXbfU5fKGnHxfo+QP8wdCBAYFQGG/3OxdYeb5pPXspxXn43zsumxToCbUPqVOwY5
	hJwCHvwTSV0D2x5P5NejdBVOpY+DsrMPIwMI7GfiHSjpajh3HwLTo5VVLQ8aC/R+MO6kbf
	yWBcBS85jMIhe9UbFSV1XRubRcaDQoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-Td1ICKd8OSitn2PPk_eYGA-1; Thu, 13 May 2021 15:22:52 -0400
X-MC-Unique: Td1ICKd8OSitn2PPk_eYGA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 485AA8042C9;
	Thu, 13 May 2021 19:22:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D5B75D6AC;
	Thu, 13 May 2021 19:22:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5BFA218005B6;
	Thu, 13 May 2021 19:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DJMe12016624 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 15:22:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DD2C750C0A; Thu, 13 May 2021 19:22:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2EAF19172;
	Thu, 13 May 2021 19:22:29 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 14DJMTP4022674; Thu, 13 May 2021 15:22:29 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 14DJMPNw022669; Thu, 13 May 2021 15:22:25 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 13 May 2021 15:22:25 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Milan Broz <gmazyland@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Changheun Lee <nanich.lee@samsung.com>
In-Reply-To: <0e7b0b6e-e78c-f22d-af8d-d7bdcb597bea@gmail.com>
Message-ID: <alpine.LRH.2.02.2105131510330.21927@file01.intranet.prod.int.rdu2.redhat.com>
References: <a01ab479-69e8-9395-7d24-9de1eec28aff@acm.org>
	<0e7b0b6e-e78c-f22d-af8d-d7bdcb597bea@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, yi.zhang@redhat.com, bgoncalv@redhat.com,
	dm-crypt@saout.de, linux-kernel@vger.kernel.org,
	alex_y_xu@yahoo.ca, ming.lei@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org, hch@lst.de
Subject: Re: [dm-devel] regression: data corruption with ext4 on LUKS on
 nvme with torvalds master
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> On 5/13/21 7:15 AM, Theodore Ts'o wrote:
> > On Thu, May 13, 2021 at 06:42:22PM +0900, Changheun Lee wrote:
> >>
> >> Problem might be casued by exhausting of memory. And memory exhausting
> >> would be caused by setting of small bio_max_size. Actually it was not
> >> reproduced in my VM environment at first. But, I reproduced same problem
> >> when bio_max_size is set with 8KB forced. Too many bio allocation would
> >> be occurred by setting of 8KB bio_max_size.
> > 
> > Hmm... I'm not sure how to align your diagnosis with the symptoms in
> > the bug report.  If we were limited by memory, that should slow down
> > the I/O, but we should still be making forward progress, no?  And a
> > forced reboot should not result in data corruption, unless maybe there
> > was a missing check for a failed memory allocation, causing data to be
> > written to the wrong location, a missing error check leading to the
> > block or file system layer not noticing that a write had failed
> > (although again, memory exhaustion should not lead to failed writes;
> > it might slow us down, sure, but if writes are being failed, something
> > is Badly Going Wrong --- things like writes to the swap device or
> > writes by the page cleaner must succeed, or else Things Would Go Bad
> > In A Hurry).
> 
> After the LUKS data corruption issue was reported I decided to take a
> look at the dm-crypt code. In that code I found the following:
> 
> static void clone_init(struct dm_crypt_io *io, struct bio *clone)
> {
> 	struct crypt_config *cc = io->cc;
> 
> 	clone->bi_private = io;
> 	clone->bi_end_io  = crypt_endio;
> 	bio_set_dev(clone, cc->dev->bdev);
> 	clone->bi_opf	  = io->base_bio->bi_opf;
> }
> [ ... ]
> static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
> {
> 	[ ... ]
> 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, &cc->bs);
> 	[ ... ]
> 	clone_init(io, clone);
> 	[ ... ]
> 	for (i = 0; i < nr_iovecs; i++) {
> 		[ ... ]
> 		bio_add_page(clone, page, len, 0);
> 
> 		remaining_size -= len;
> 	}
> 	[ ... ]
> }
> 
> My interpretation is that crypt_alloc_buffer() allocates a bio,
> associates it with the underlying device and clones a bio. The input bio
> may have a size up to UINT_MAX while the new limit for the size of the
> cloned bio is max_sectors * 512. That causes bio_add_page() to fail if
> the input bio is larger than max_sectors * 512, hence the data
> corruption. Please note that this is a guess only and that I'm not
> familiar with the dm-crypt code.
> 
> Bart.

We already had problems with too large bios in dm-crypt and we fixed it by 
adding this piece of code:

        /*
         * Check if bio is too large, split as needed.
         */
        if (unlikely(bio->bi_iter.bi_size > (BIO_MAX_VECS << PAGE_SHIFT)) &&
            (bio_data_dir(bio) == WRITE || cc->on_disk_tag_size))
                dm_accept_partial_bio(bio, ((BIO_MAX_VECS << PAGE_SHIFT) >> SECTOR_SHIFT));

It will ask the device mapper to split the bio if it is too large. So, 
crypt_alloc_buffer can't receive a bio that is larger than BIO_MAX_VECS << 
PAGE_SHIFT.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

