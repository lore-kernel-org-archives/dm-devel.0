Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB0C242D9E
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763573187; cv=none; b=H20tKXbd1iXpsxfFf1Exe981Ohn7AtgA4r+yh7E10PhAIodMb2bY5mpaBpQxVzV4A/HSU4Xvt4JiMINQdXHn626HPdSazuTX27EtkxPT79ZPf9j8yHgr1GGVGEdacWrNjob0GQdNj2F7xI81VvTfrJU5DpD/AzI9moDYJCqLbJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763573187; c=relaxed/simple;
	bh=+3v0BSRLrpz9V3CXQQTfhQu0LyN67UtJ8+xHlpkcqto=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=P5WKYHeVuNFvdXjosPv40VcRPdFkPD2yzBtVeKvoIvyPRbwZ6tuniZwvg2LXFJNmTTJ+MjbSZ5alvXoJh0VdlyERT3C96eWJmL/QJhC5tgrYEqEhj7idl5JaVgP5f7ZpEH47umSuuNGcoGCjDj5h8TyIibtg96eXBeAtLWuyPTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NEp2xazp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NEp2xazp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763573184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G/IJTsBKSTFZbHc5wVkqyaMwEn78SLvEeJSiVuPlafA=;
	b=NEp2xazpDGM3rdFdfy4pF0SxVynByGBr4VqYZbx4B5pBwBEYPqOcnUh97bIcwFC718x8/Q
	FyR8wazg/XngrfPTfN17x9WLxy63PoMvWqzwaKdUftDECqSvNll5SRbZr/plqzxsVXTfMd
	64Isutu02wCJ7ShA4Bxyygbh2UxxvFM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-J3o31TcEOM6_crtZfoh5rg-1; Wed,
 19 Nov 2025 12:26:22 -0500
X-MC-Unique: J3o31TcEOM6_crtZfoh5rg-1
X-Mimecast-MFC-AGG-ID: J3o31TcEOM6_crtZfoh5rg_1763573179
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6275818AB307;
	Wed, 19 Nov 2025 17:26:19 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E34BC18004A3;
	Wed, 19 Nov 2025 17:26:16 +0000 (UTC)
Date: Wed, 19 Nov 2025 18:26:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christoph Hellwig <hch@lst.de>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Uladzislau Rezki <urezki@gmail.com>, Alasdair Kergon <agk@redhat.com>, 
    DMML <dm-devel@lists.linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
    Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
In-Reply-To: <20251119054635.GB19993@lst.de>
Message-ID: <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
References: <20251117105945.10179-1-urezki@gmail.com> <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Wed, 19 Nov 2025, Christoph Hellwig wrote:

> On Tue, Nov 18, 2025 at 06:21:56PM +0100, Mikulas Patocka wrote:
> > OK - I accepted Uladzislau's patch. As logical block size and physical 
> > block size seem to be unreliable, it's better to set the size in dm-ebs.
> 
> logical and physical block size are reliable.  Uladzislau just seems
> to have a completely broken device that needs fixing, because it will

He created a qemu-emulated NVMe device with physical and logical block 
size 8192 in a virtual machine. And logical block size was reported as 512 
in the guest kernel - so it is either a qemu bug or a kernel bug.

> run into all kinds of other problems otherwise.

Hmm, Linux may get it wrong too. See this piece of code in 
include/linux/blkdev.h:

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
/*
 * We should strive for 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER)
 * however we constrain this to what we can validate and test.
 */
#define BLK_MAX_BLOCK_SIZE      SZ_64K
#else
#define BLK_MAX_BLOCK_SIZE      PAGE_SIZE
#endif


/* blk_validate_limits() validates bsize, so drivers don't usually need to */
static inline int blk_validate_block_size(unsigned long bsize)
{
        if (bsize < 512 || bsize > BLK_MAX_BLOCK_SIZE || !is_power_of_2(bsize))
                return -EINVAL;

        return 0;
}

in nvme_update_disk_info there is this piece of code:
        if (blk_validate_block_size(bs)) {
                bs = (1 << 9);
                valid = false;
        }

So, the valid block size depends on whether CONFIG_TRANSPARENT_HUGEPAGE is 
defined, which is quite weird.

Mikulas

