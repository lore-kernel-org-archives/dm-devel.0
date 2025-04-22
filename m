Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45AA7DA66
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333247; cv=none; b=qd9OEXYcVLnseIK1OPQIxiPKFmPt4rLRVs3QZPwxAfqc+XM1xMSkrmAmqMv1xcSl/9TiHdfSI+XJb0s72VV3rWa90HUXeW6ywUE+IvrDfNVxOecvq5tiMYH7cl45LqlY6nWrVs6vL0pbvjRPRu5Qnd4AMEsEmcovXfqtchIIB3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333247; c=relaxed/simple;
	bh=mxaN1YfKr9XM6IYQpeEYNHp2o5nhaspR23hE7ooUlyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bL1GeLC3Gz4Xhdm5iGxiGOg7hndkVYsGG14jMYV6wu2oh99MNZaTXgjCVJ8Z117TPc9w98WXojzkcbn28yNPTHYsQt+Rp139Cnx2tIVWEf2zjxwhzRtMepuXJv0E8+O5hvweVhJdbI6HN3GWdCgUDKDLTl0g04DZ+f4ccBtTLJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=agbxR8dE; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="agbxR8dE"
Date: Tue, 22 Apr 2025 10:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745333232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yAI/tHGZKw9Oh2M0OTaf9GagIHs6QLbsLOS+/MzIsjk=;
	b=agbxR8dEA6ICHJ+ueYl8V1cTMDl6ZU5E2kQjTxarAZC6XhPfPNJl/VXCcHmVByjdN+RJet
	LOXRFqZXuXgtSq715y5xgMBKy4cCHw94dDFaV6llqSpbf2Y3wltQxtoBBsSfUVONJeXcjH
	DqhbekbGuY+m/mBcO2dIZKEzOP+pCjs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: add more bio helper
Message-ID: <jetduw7zshrmp4gl7zfpwqjweycwesxiod7xvtnxqwqekgtvdf@idwnvfzvhgik>
References: <20250422142628.1553523-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422142628.1553523-1-hch@lst.de>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 22, 2025 at 04:26:01PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds more block layer helpers to remove boilerplate code when
> adding memory to a bio or to even do the entire synchronous I/O.
> 
> The main aim is to avoid having to convert to a struct page in the caller
> when adding kernel direct mapping or vmalloc memory.

have you seen (bch,bch2)_bio_map?

it's a nicer interface than your bio_add_vmalloc(), and also handles the
if (is_vmalloc_addr())

bio_vmalloc_max_vecs() is good, though

> 
> Diffstat:
>  block/bio.c                   |   57 ++++++++++++++++++++++
>  block/blk-map.c               |  108 ++++++++++++++++--------------------------
>  drivers/block/pktcdvd.c       |    2 
>  drivers/block/rnbd/rnbd-srv.c |    7 --
>  drivers/block/ublk_drv.c      |    3 -
>  drivers/block/virtio_blk.c    |    4 -
>  drivers/md/bcache/super.c     |    3 -
>  drivers/md/dm-bufio.c         |    2 
>  drivers/md/dm-integrity.c     |   16 ++----
>  drivers/nvme/host/core.c      |    2 
>  drivers/scsi/scsi_ioctl.c     |    2 
>  drivers/scsi/scsi_lib.c       |    3 -
>  fs/btrfs/scrub.c              |   10 ---
>  fs/gfs2/ops_fstype.c          |   24 +++------
>  fs/hfsplus/wrapper.c          |   46 +++--------------
>  fs/xfs/xfs_bio_io.c           |   30 ++++-------
>  fs/xfs/xfs_buf.c              |   27 +++-------
>  fs/zonefs/super.c             |   34 ++++---------
>  include/linux/bio.h           |   39 ++++++++++++++-
>  include/linux/blk-mq.h        |    4 -
>  kernel/power/swap.c           |  103 +++++++++++++++++-----------------------
>  21 files changed, 253 insertions(+), 273 deletions(-)
