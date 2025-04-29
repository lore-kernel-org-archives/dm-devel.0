Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F18E175A5;
	Tue, 29 Apr 2025 12:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745929700; cv=none; b=dmY7ODDY4LA8VL3JqsFN60gQPNr0dhqSZx9P0J+zDgJW29ONEUXsPjfSOalQj3yCDqHamOgIhbl5svG57cci8l+JYs/i4E83+OgyMEmzrj9dBhKqhmme3/evjyVu1yHDPgxZVLUwWrVUOTOXHHfiH4FjzvcK+Togt9aszBbgEXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745929700; c=relaxed/simple;
	bh=1CAfX43axeyXhHAA2pWyW1DzJI+aoNNB9mI8PIkd6lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMktck/xPIj+G/+XAlXzk0K9d/pJ02NM0cY/IXKALQki2dpMMSslFgytf1l8/827V8bE0cgiAP72uRWV0sHqkJZvmWPg4dF/EAw0GV9HoRTZNF+dmJ7EL+ZOZkEe5BBNG5z+7zkc02802zcXFuYpm2PXX6z7tVzk3Urmr+XUX0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D4A3E68AA6; Tue, 29 Apr 2025 14:28:13 +0200 (CEST)
Date: Tue, 29 Apr 2025 14:28:13 +0200
From: hch <hch@lst.de>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <Naohiro.Aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 04/17] block: remove the q argument from blk_rq_map_kern
Message-ID: <20250429122813.GA12807@lst.de>
References: <20250422142628.1553523-1-hch@lst.de> <20250422142628.1553523-5-hch@lst.de> <76ba8f63-b5d3-4e43-beb4-97dae085c5f2@suse.de> <df1fa243-a824-4607-8393-90dedecbe772@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df1fa243-a824-4607-8393-90dedecbe772@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 29, 2025 at 11:24:55AM +0000, Johannes Thumshirn wrote:
> > Good cleanup. I always wondered why we need to have it.
> 
> Because we used to call 'bio_add_pc_page()' in e.g. bio_map_kern()' 
> which took a request_queue. But that got changed in 6aeb4f8364806 
> ("block: remove bio_add_pc_page") to a simple 'bio_add_page()'.

Even back then you could have easily derived it from the struct
request, through.
