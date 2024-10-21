Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842F41E767C;
	Mon, 21 Oct 2024 12:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512156; cv=none; b=M+adl5Sct/5FHD1/RGwvaUEU6FOXSLCzF14ZVaDGGo9wmCOSP5J2SgMGfwygi46vKwAqw2CqIOPtKO57GZMLlIUKqFJIMOCNzFf5x87Lgj/YLMwnzBK2/ltEl3SwtOd42LLOTfGSMj58TTL4fI3eM290GpA2C1g8W8enlVlj4DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512156; c=relaxed/simple;
	bh=P6/SI4WhncsIlLVKEMGDeZOfwQM3d9L/ThOdT0DK/Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fqf4LI5WoUzkUbp2IGrU9o0kK/vROfOfIsjx4VtLfmvEUyWIYyLUaEtNGTOdHzlDsiPgIYgezijKHHYiqfnEKeV0VV41dagotiP3zEQq6hRB5ozMbxVnYzjv5WQ6lQYeg+T7pZsjjPmutz9ALDp+BN343DTumrG1xoDqE0Mzl8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=n4EmeSgn; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="n4EmeSgn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=/5D+1HDJu4jRHj0J3oLDhRztiMPaWKm98jgYBpyHshY=; b=n4EmeSgnfg27SXQe
	hhO7CWEO8XLm3FasgX26dKm8cr+ZkUizAiKTnNW2zTaOMR7c3wXb5ZSS1pWlx0SgMtX4drPMZvQYo
	+FFa9YL43TIFPioV2IM9GcUiQ6XSq7fdP2W4fBz370zzR+RnAT6F+pL7yP60jK1o3RMvSk9c+wiRv
	E75atLZgXF4lF8bc8E1chbaOCQ4acjY3avje6YjP9gOobx9yHVcM68eg9OtELUufz2HtG1jDfaZLg
	XAW0Wg5Nk4iuMDXNwzsb5QRPVMugtQuzwsx/lywyuaM0PM5xviEKL+INZ+tmHAxbuUo7m1IK0LzJX
	Rw+X1SDPtBSWTZzf4w==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t2r7B-00CUrl-05;
	Mon, 21 Oct 2024 12:02:25 +0000
Date: Mon, 21 Oct 2024 12:02:24 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, msakai@redhat.com,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] dm deadcoding
Message-ID: <ZxZC0A-GvSg6THtd@gallifrey>
References: <20241003011554.266654-1-linux@treblig.org>
 <f251e49c-d846-2c87-3914-2d4f8bf37e3e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <f251e49c-d846-2c87-3914-2d4f8bf37e3e@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 12:01:56 up 165 days, 23:15,  1 user,  load average: 0.00, 0.03,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Mikulas Patocka (mpatocka@redhat.com) wrote:
> Hi
> 
> I've accepted these patches.

Thanks, yep I noticed them in -next :-)

Dave

> Mikulas
> 
> 
> 
> On Thu, 3 Oct 2024, linux@treblig.org wrote:
> 
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > 
> > Hi,
> >   This is a collection of deadcoding in various parts
> > of dm.  It's all strictly function deletion with no
> > (expected) change of behaviour.
> > 
> > Build and booted on x86-64, but no dm tests done.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> > 
> > 
> > Dr. David Alan Gilbert (9):
> >   dm cache: Remove unused btracker_nr_writebacks_queued
> >   dm cache: Remove unused dm_cache_dump
> >   dm cache: Remove unused dm_cache_size
> >   dm cache: Remove unused functions in bio-prison-v1
> >   dm: Remove unused dm_set_md_type
> >   dm: Remove unused dm_table_bio_based
> >   dm: zoned: Remove unused functions
> >   dm vdo: Remove unused functions
> >   dm vdo: Remove unused uds_compute_index_size
> > 
> >  drivers/md/dm-bio-prison-v1.c            | 35 -----------------
> >  drivers/md/dm-bio-prison-v1.h            | 24 ------------
> >  drivers/md/dm-cache-background-tracker.c |  6 ---
> >  drivers/md/dm-cache-background-tracker.h |  1 -
> >  drivers/md/dm-cache-metadata.c           | 33 ----------------
> >  drivers/md/dm-cache-metadata.h           |  3 --
> >  drivers/md/dm-table.c                    |  5 ---
> >  drivers/md/dm-vdo/data-vio.c             | 29 --------------
> >  drivers/md/dm-vdo/data-vio.h             |  5 ---
> >  drivers/md/dm-vdo/indexer/index-layout.c | 26 ------------
> >  drivers/md/dm-vdo/indexer/indexer.h      |  4 --
> >  drivers/md/dm-zoned-metadata.c           | 50 ------------------------
> >  drivers/md/dm-zoned.h                    |  2 -
> >  drivers/md/dm.c                          |  6 ---
> >  drivers/md/dm.h                          |  2 -
> >  15 files changed, 231 deletions(-)
> > 
> > -- 
> > 2.46.2
> > 
> 
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
