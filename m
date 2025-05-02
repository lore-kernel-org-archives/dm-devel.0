Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A06D267387;
	Fri,  2 May 2025 07:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746169544; cv=none; b=X6vRMKWapxEwd/A8zY9S1OW8QHa8mtih2k8FeY9HnsvqCC6RFCwZw/JbtKTWhH7HcvaYU30HRgbbrFq2ae7peTjLxLeyIIu1HaA8dspFenoE5/WlkiNDVIUETqC+AH9XMc+Nlj93CwX4b1AAs8Dsju9UoUC+7jYeZand9v3TLM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746169544; c=relaxed/simple;
	bh=E7uWLqpiUSJQeuGNiKliTZyr4qv/ug0M4WqZ6POeUW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARCGlXRcT1MspCIgfJ612R/5SOFGsHmelSeMfqL5mZYO0bqlsV+LKxNV1WrHGv8S/Dnw43ZdFGvI8ZM3/uhpa0etxzMymRg9WnTQwT37+rhEt9pam37TI3+j8kHgD8ranP0winchphFfo4ngLIGCnqlnoGaM/M2hyid4bJDwOw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E60F467373; Fri,  2 May 2025 09:05:37 +0200 (CEST)
Date: Fri, 2 May 2025 09:05:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 07/19] block: simplify bio_map_kern
Message-ID: <20250502070537.GA8402@lst.de>
References: <20250430212159.2865803-1-hch@lst.de> <20250430212159.2865803-8-hch@lst.de> <282b0a35-cc60-4d61-a3b7-9b565c57b8bf@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282b0a35-cc60-4d61-a3b7-9b565c57b8bf@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 02, 2025 at 03:56:08AM +0900, Damien Le Moal wrote:
> > -	unsigned long kaddr = (unsigned long)data;
> > -	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > -	unsigned long start = kaddr >> PAGE_SHIFT;
> > -	const int nr_pages = end - start;
> > -	bool is_vmalloc = is_vmalloc_addr(data);
> > -	struct page *page;
> > -	int offset, i;
> > +	unsigned int nr_vecs = bio_add_max_vecs(data, len);
> >  	struct bio *bio;
> >  
> > -	bio = bio_kmalloc(nr_pages, gfp_mask);
> > +	bio = bio_kmalloc(nr_vecs, gfp_mask);
> 
> This may also fail if nr_vecs is larger than UIO_MAXIOV, in which case, the
> ENOMEM error may not really be appropriate. I guess we can sort this out
> separately though.

Yeah.  It's also existing behavior, so no real change here.

