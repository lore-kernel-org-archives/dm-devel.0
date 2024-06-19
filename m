Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5B077F0B
	for <dm-devel@lists.linux.dev>; Wed, 19 Jun 2024 08:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784153; cv=none; b=DCgJVNRtuyd0VX5lz9ws8P8Cq2vgwVxO32v7Gz4+YwvamlVgwztwID74kclpZ03TD0/j1uiRRcPyI18+4mGJZdtgId4lSHCHzGkbUpLVECso7nzOLXLzZVpyoZrejGeDHryMzGsTF02J0aU7ZznMC6VjtmlpWlZLe30R9IEyAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784153; c=relaxed/simple;
	bh=z0SlEVjuMjft4IMkiONjhZcAyB+pz/y+jPbljyxtcyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BBh4LvsbJIOfI//QqWytItf0HibI4HoOtDEKQr4qNe9lE0372WI6CsewEaAvXehv7aDBWMQt8aHCfBnMg25NfP8h7WpyGcRobh8ir9mJqmq0Z/X6oZcNc0YHeCC+nkEOdqJtxSQKypfEN0pCxFkIYXHPS4wizJ8kn/b1y0G7gxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B204868AFE; Wed, 19 Jun 2024 10:02:18 +0200 (CEST)
Date: Wed, 19 Jun 2024 10:02:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	axboe@kernel.dk, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
Message-ID: <20240619080218.GA4437@lst.de>
References: <20240610104329.3555488-1-john.g.garry@oracle.com> <20240610104329.3555488-6-john.g.garry@oracle.com> <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com> <20240618065112.GB29009@lst.de> <91e9bbe3-75cf-4874-9d64-0785f7ea21d9@oracle.com> <ZnHDCYiRA9EvuLTc@kbusch-mbp.dhcp.thefacebook.com> <24b58c63-95c9-43d4-a5cb-78754c94cbfb@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b58c63-95c9-43d4-a5cb-78754c94cbfb@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 19, 2024 at 08:59:33AM +0100, John Garry wrote:
> In this case, I would expect NOIOB >= atomic write boundary.
>
> Would it be sane to have a NOIOB < atomic write boundary in some other 
> config?
>
> I can support these possibilities, but the code will just get more complex.

I'd be tempted to simply not support the case where NOIOB is not a
multiple of the atomic write boundary for now and disable atomic writes
with a big fat warning (and a good comment in the soure code).  If users
show up with a device that hits this and want to use atomic writes we
can resolved it.

