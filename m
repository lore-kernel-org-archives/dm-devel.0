Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A6813D518
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731947169; cv=none; b=t/1EnQmq1Fpdo/gmLxXNfMLroLhBxzv+0TRub8X7xkwFbY3pWs1+/Xucx9y6h+tHMhWctljDeSU0G18I7Yoc+JH1yuTd0LuWUmVBCirhVBBL6HXKBWhW3XIzapUD7pqhJ9tbjej6B8wqXTYdT1Crkw6TbOeXTv8iyctNH/Fd5uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731947169; c=relaxed/simple;
	bh=r77FkxW219GPVdejKrUuVx2qyde7AqFdDrWagl85MOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQmnwdoAEizbm00fG0Py3G8uvvlhTSGvn6w0PHsINwxL+E/Fd/TfkAdWEEOpdVGFlhkBuhmgp/CbaAJ7S7LBhOhmMenaDGXyVvWBvv0jgoZrJT/LZfZKB5UAsc2CKUUTuOlKh+DER8OrH0ibKyljfzvX+WzK0xbHYLysolroP2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A7AC368D12; Mon, 18 Nov 2024 17:26:02 +0100 (CET)
Date: Mon, 18 Nov 2024 17:26:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dap581 <dap581@protonmail.com>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Milan Broz <gmazyland@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-settings: round down io_opt to physical_block_size
Message-ID: <20241118162601.GA12160@lst.de>
References: <sL6OHvHA2vueSjCGptT5XUvM5jjGMf3xGWrAW6npODvitd85paTESdsxpbircJbDh9VVyBNDNiqOcU39-LM7WwuldK5Tk4UkRSZjsycWdpo=@protonmail.com> <1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com> <3dc0014b-9690-dc38-81c9-4a316a2d4fb2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dc0014b-9690-dc38-81c9-4a316a2d4fb2@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 18, 2024 at 03:52:50PM +0100, Mikulas Patocka wrote:
> 
> 
> On Mon, 18 Nov 2024, Mikulas Patocka wrote:
> 
> > On Sat, 16 Nov 2024, dap581 wrote:
> > 
> > > Hello,
> > > Starting with kernel 6.11.x series up to current 6.12-rc7
> > > when I unlock my encrypted hdd (storage, not root) with cryptsetup:
> > > 
> > > cryptsetup luksOpen /dev/sda1 hdd5 -d keyfile_hdd5
> > > 
> > > it triggers an alignment inconsistency:
> > > In dmesg log, I read:
> > > ----
> > > [  105.841278] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > [  105.841292] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > [  105.841601] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > [  105.841607] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > ----
> 
> Hi
> 
> Does this patch fix it?

FYI, this rounding down looks reasonable to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

