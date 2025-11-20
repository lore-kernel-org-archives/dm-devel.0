Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90E628D8DF
	for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 06:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619720; cv=none; b=agPhmOm2Q8tNEN3qvxIt68ICkF0qI8uW3tyYm23sM/nayyshe4jqvZ34iWMC37auZDcZriywUn3lzIXv0IRAByaM/rUUFRPeGE6LvbAtUSTgg1WQRQPNHnKpYItzwHEJq43pUV3KNsiidmqpdxL1GEISspg2i/x5/SV4LU+JniI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619720; c=relaxed/simple;
	bh=RD780VYoO4el34s1XyrMCycr4hUGJdnVlx95GOUK8vM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ee2MN+8F+DWgjyhYdMkE+PWaw8k+y/6TbAsRk9PZr/38fTJLmlv7kMbikOupklZuAOoH0SMhIe6x0K6id9k5+n3Jf4RKa01pd5SxR1u3RVaUtmHp1+4uSMsw4dtXzDdN6W564CAONu95CmfNuuNL5hQWHL+Jps/0PgSkguf1nK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2FB9E68B05; Thu, 20 Nov 2025 07:21:47 +0100 (CET)
Date: Thu, 20 Nov 2025 07:21:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <20251120062146.GA29990@lst.de>
References: <20251117105945.10179-1-urezki@gmail.com> <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 19, 2025 at 06:26:13PM +0100, Mikulas Patocka wrote:
> 
> 
> On Wed, 19 Nov 2025, Christoph Hellwig wrote:
> 
> > On Tue, Nov 18, 2025 at 06:21:56PM +0100, Mikulas Patocka wrote:
> > > OK - I accepted Uladzislau's patch. As logical block size and physical 
> > > block size seem to be unreliable, it's better to set the size in dm-ebs.
> > 
> > logical and physical block size are reliable.  Uladzislau just seems
> > to have a completely broken device that needs fixing, because it will
> 
> He created a qemu-emulated NVMe device with physical and logical block 
> size 8192 in a virtual machine. And logical block size was reported as 512 
> in the guest kernel - so it is either a qemu bug or a kernel bug.

No, that's not the case.  If you use his command line you'll see a qemu
device with 8192 logical blocks assuming you have support for large
folios, or a completely unusuable device that claims to have 512
byte blocks for compatibility, but also a capacity of zero so that no
one can use it for anything but passthrough.

> in nvme_update_disk_info there is this piece of code:
>         if (blk_validate_block_size(bs)) {
>                 bs = (1 << 9);
>                 valid = false;
>         }

Yes, that's what I mentioned above.  The valid=false sets the capacity
to zero, so you're not actually going to be able to use this device.

> So, the valid block size depends on whether CONFIG_TRANSPARENT_HUGEPAGE is 
> defined, which is quite weird.

And also the page size, and none of that is too weird.  You need support
efficiently allocating large order folios to support a
block size > PAGE_SIZE and currently CONFIG_TRANSPARENT_HUGEPAGE is
the guard for that.  There was some talk of lifting that, but that
requires a bit of work.

