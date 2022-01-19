Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 472E7C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jan 2022 06:11:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-szfJ6VbvOPmhqPxe-voOLA-1; Wed, 19 Jan 2022 01:11:50 -0500
X-MC-Unique: szfJ6VbvOPmhqPxe-voOLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F9D91DDED;
	Wed, 19 Jan 2022 06:11:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F9DC78D85;
	Wed, 19 Jan 2022 06:11:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 20F661809CB8;
	Wed, 19 Jan 2022 06:11:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20J6BYTi003257 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 Jan 2022 01:11:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 344E753D6; Wed, 19 Jan 2022 06:11:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FC2653C9
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 06:11:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C052E3C11A1B
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 06:11:29 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-400-Jq5odkF9NHywQ5Uce2TWSg-1; Wed, 19 Jan 2022 01:11:26 -0500
X-MC-Unique: Jq5odkF9NHywQ5Uce2TWSg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nA3JR-003qOV-IA; Wed, 19 Jan 2022 05:15:13 +0000
Date: Tue, 18 Jan 2022 21:15:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <YeeeYYm54aqsR6U6@infradead.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeUgNpFeg9LmW4Um@infradead.org>
	<0461b15e-8ace-5a84-cf9d-504e555b8cab@gmail.com>
	<2d937f09-e18c-6a95-bc6c-45bf5d1b1a11@nvidia.com>
	<YebupSYksz2gV8vn@infradead.org> <Yecitbf4lJtQA69O@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <Yecitbf4lJtQA69O@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Israel Rukshin <israelr@nvidia.com>,
	Christoph Hellwig <hch@infradead.org>, dm-devel <dm-devel@redhat.com>,
	Nitzan Carmi <nitzanc@nvidia.com>, Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 18, 2022 at 12:27:33PM -0800, Eric Biggers wrote:
> * The block device for a partition doesn't have its own request_queue or
>   queue_limits; those are properties of the disk, not the partition.  But,
>   setting an encryption key may require changes to the queue_limits.  For
>   example, discard_zeroes_data will no longer work, and the logical_block_size
>   will need to become the crypto data unit size which may be larger than the
>   original logical_block_size.

If we need changes to the queue limits we're doing something wrong I
think, as all these limitation only actually apply to bios that use
inline encryption and thus should be dynamic decisions.

Note that discard_zeroes_data is gone already, all zeroing must use
REQ_OP_WRITE_ZEROES.

> 
> * The block_device for a given partition didn't stay around while no one has it
>   opened or mounted.  This may have been addressed by Christoph's changes last
>   year that merged block_device and hd_struct, but this used to be an issue.

Yes, this is fixed now.

> * There was some issue caused by the way the block layer maps partitions to
>   disks; the knowledge of the original block device (and thus the key) was lost
>   at this point.  I'm not sure whether this is still an issue or not.

Also fixed by the block_device/hd_struct merged as the lookup is gone
entirely now.

> * A block device ioctl to set a key would need to handle cases where the block
>   device is already open (fail with EBUSY?), or already has pages cached in the
>   pagecache (invalidate them?).  A dm target avoids these concerns since a key
>   would only be set up when the disk and block device are originally created.

An ioctl is by definition perfomed on an open file handle, so it will by
definition be open.  But I don't think that check really is needed to be
so strict.  We can require the ioctl to be on an FMODE_EXCL file handle
which is a good sanity check and otherwise you get what you ask for.

> 
> Finally, there's also the fact that this would really be more than "setting a
> default key".  To precisely specify the encryption format, you also have to
> specify the algorithm, the key type, and the data unit size.  (Also potentially
> more details about IV generation, if blk-crypto ever starts to support more IV
> generation methods, which I'd like to avoid but it might eventually happen.)
> 
> These could all be passed in an ioctl, but dm-crypt already has a syntax defined
> for specifying encryption formats.  So it could make sense to reuse it.

We could of course find a way to mostly reuse the dm-crypt text based setup
syntax even on a block device if that helps.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

