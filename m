Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02A9B653
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 05:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707109932; cv=none; b=NEVhvOEiw3BWA56RCjqDhuI5b7eP6Hg+L1ebKe0feDzKdHjzkOf8ncrfy7ukpul+Nj4sZ0AOjWEwZfn2f5NPkSTd/OwlTAWAOWAeYKIeedmvud4OED4PU+ha7ukfvQZmhx2vovnyARieYhfxlXL8F8FXJOoOq+WmnP2izApymrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707109932; c=relaxed/simple;
	bh=uLratuBBiUELGGDELEjOgLcI+7TP/lMITd3VOcI/bow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dR3Gtapc87VT5ZihtGkuhW/zzYu3eVasG2O6B1aQTZGtjyJaxTjlE4sM8qSrvCbAUkoJ4Eanvh6SbuiSnw9YI/3HIh+oSV6nD81yTG/AjNpCjhiZwVIuBF4klqHM42Td0Nd7Sw/wQLM7lOFDfDPEm9uJfElfXxC5r9SX+tBJDWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0DAB2227AA8; Mon,  5 Feb 2024 06:12:00 +0100 (CET)
Date: Mon, 5 Feb 2024 06:11:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Message-ID: <20240205051159.GA17817@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org> <20240202073104.2418230-7-dlemoal@kernel.org> <Zb8K4uSN3SNeqrPI@fedora> <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org> <ZcBFoqweG+okoTN6@fedora> <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 05, 2024 at 11:41:04AM +0900, Damien Le Moal wrote:
> > I think only queue re-configuration(blk_revalidate_zone) requires the
> > queue usage counter. Otherwise, bdev open()/close() should work just
> > fine.
> 
> I want to check FS case though. No clear if mounting FS that supports zone
> (btrfs) also uses bdev open ?

Every file system opens the block device.  But we don't just need the
block device to be open, but we also need the block limits to not
change, and the only way to do that is to hold a q_usage_counter
reference.
