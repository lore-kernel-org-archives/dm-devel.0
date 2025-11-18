Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B845C320A30
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 12:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763467258; cv=none; b=bxAhfMVVSujqiIFw7p6r5abyaY0cBh7yOR6KX6GnK9J/dFBFFsecozJOYZqFHU7LV/8kNTQze8BC745RGaNyuH1J9z2yed2VNZrRvcPf4AaIU/4lJdLa0NtOxyhiW5GwZhV9G+Edev+iVIZVftbGCvO67q041CuQdpM1cpPDGbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763467258; c=relaxed/simple;
	bh=cxKUeXQRKBIKwY1/SaeU6VCcgmACFN7yWkDzm8ojQnk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=B2GCqAMAyRNL6S57UaK9LWem3YYVlFSyAanXPaH/c0PAmi5TpNtUtgdzaqUOlLeWWNso/Tk5vY+an/RuTSxBnkkHv7oOhO9QyxP1X0ykuCTK2KeCQERxh1BoxieN+5DvxdhiFZjHn1oR4rAV5YsaP2Q254OjsaKOxrc/nci1N2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eYu9ZZEB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eYu9ZZEB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763467255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iw3favTJJDwDGGBoaMZchD8v5qXA33X8whQK6fGBamE=;
	b=eYu9ZZEBGwm6KpzS8KQ7mIBnPNAmhq4lWu1MYKENFyk2vxTuI4n0dALA8e1cQ3q0pAIsyF
	KwYg0nntikugIcmvmreeYRVZafMYpzYGTlQ/3gNBV/IG03sJvpBEWjy6XPQkHVij8IaPa/
	GARGyZ3yP3atS8PKbHC68i1+UpJn4pc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-zEyOw7VzMaSZNGFuRSA6-w-1; Tue,
 18 Nov 2025 07:00:50 -0500
X-MC-Unique: zEyOw7VzMaSZNGFuRSA6-w-1
X-Mimecast-MFC-AGG-ID: zEyOw7VzMaSZNGFuRSA6-w_1763467249
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1684219560A5;
	Tue, 18 Nov 2025 12:00:49 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64DB819560B0;
	Tue, 18 Nov 2025 12:00:46 +0000 (UTC)
Date: Tue, 18 Nov 2025 13:00:36 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, 
    LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
In-Reply-To: <aRxa1wPMsJwBubjx@pc636>
Message-ID: <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
References: <20251117105945.10179-1-urezki@gmail.com> <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Tue, 18 Nov 2025, Uladzislau Rezki wrote:

> Hello, Mikulas!
> 
> > Hi
> > 
> > What is the logical_block_size of the underlying nvme device? - i.e. 
> > what's the content of this file 
> > /sys/block/nvme0n1/queue/logical_block_size in the virtual machine?
> > 
> It is 512. Whereas a physical is bigger, i.e. my device can not perform
> I/O by 512 granularity.

And what is physical block size? Is it 8192?

> As for virtual machine, i just simulated the problem so people can set
> it up and check. The commit message describes how it can be reproduced.
> 
> The dm-ebs target which i setup does ebs to ubs conversion, so the NVME
> driver gets BIOs are in size and aligned to ubs size. The ubs size
> corresponds to the underlying physical device I/O size.
> 
> So your patch does not work if logical < physical. Therefore it does
> not help my project.

Logical block size is the granularity at which the device can accept I/O. 
Physical block size is the block size on the medium.

If logical < physical, then the device performs read-modify-write cycle 
when writing blocks that are not aligned at physical block size.

So, your setup is broken, because it advertises logical block size 512, 
but it is not able to perform I/O at this granularity.

There is this piece of code in include/linux/blkdev.h:
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

What happens when you define CONFIG_TRANSPARENT_HUGEPAGE in your .config? 
Does it fix the problem with small logical block size for you?

Mikulas

> --
> Uladzislau Rezki
> 

