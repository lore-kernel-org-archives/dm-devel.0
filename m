Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62BA480DEA;
	Wed, 17 Jun 2026 16:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781715567; cv=none; b=XNSOgCFgRQBWc5oI0GIORtk9PNN/jvvCae8OzZDq6oW/BCCJAp3RQclc6C2zNAuqukyzDQwg5D5h5ZaNfGsN0TC8mzyTXEU/JCBCfs5QzFnFX+aFuCVLHfMKlq4tjxTh6648QkhIVO/UHPMtaw169behyf4vx5Rw25OQNNk2joM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781715567; c=relaxed/simple;
	bh=NbuAaDDHw4JXB9cwte3PF66X5gRlvufDEPtX0HM0MU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Isv3h3EKu2x/GJ/h+zjtmBk9DsLK5ALajlmNiI2pRtb1+qBLhb5aUj8F3DXMOns7GgimAzPB0Ir+tREl24xas4NtbTDRewvfHJu4JVSVbq/kBE76BekQQ3zIpc1KYqVhyrP8WVKDlJIa3plLuau0LpZgUaHqPmdzbffR40nb5pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=f7pvSjEa; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="f7pvSjEa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=5QUO1R3XIQ42f1w+DFF1EqW19xtkhJt8M9PwyWeViF4=; b=f7pvSjEaEhtWcLCq
	Cn08peLaC1IgQOuL6N00Xm2HvH8TrPPELpqvMAUOeiwjNqT3IVhBBl/cojI4rm4rqMCqs70hw5vxF
	8dnhC6uaPjzY05+mdOyZADYWve+CrM1hA5U2MMTysqyK0Ruyb3X69kebCFJ4XojoDVbvF7a2vz/dK
	jTevWjt+Sk3kXCWyZ6mop300/TKe096LB7rROk+/NpF74iggibc3IqVjTdQqONjFU8lwjxeqi/aSD
	tjLF3TF/0fg/ue2h8GzAP6no5nrMqrCJQ7Vlj8pqNwJs0RdmRAEf1RbwDHW7WPr2qgk6OUHEixyjh
	MM5T5v02tIxvjCWmCQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZtbm-00000008MiJ-1kLp;
	Wed, 17 Jun 2026 16:59:22 +0000
Date: Wed, 17 Jun 2026 16:59:22 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@kernel.org>, regressions@leemhuis.info
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajLSaiKXWIekcA97@gallifrey>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
 <ajK4YacvP7eQ-S2o@kbusch-mbp>
 <ajK-Y7uoK0QT5PVl@gallifrey>
 <ajLJiOwim7qBp_0P@kbusch-mbp>
 <ajLO80kZmFnyR2mH@gallifrey>
 <ajLRTkSZJ0WCYNk4@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajLRTkSZJ0WCYNk4@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 16:58:38 up 32 days, 20:11,  2 users,  load average: 0.07, 0.02,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Wed, Jun 17, 2026 at 04:44:35PM +0000, Dr. David Alan Gilbert wrote:
> > (It's a bit scary you're having to go around quite
> > a few places and make similar fixes; I assume there
> > are others that do similar things).
> 
> Yes, I understand that. I'm looking into a common way to validate this.
> The md raid doesn't have this problem because they always call
> bio_split_to_limits() first, but that's not an optimal thing to do for
> dm raid in the normal read/write path, so perhaps a common checker needs
> to happen generically in the block layer. Yeah, I know I removed the
> previous higher level validation ... I'll try find something less costly
> than what we had before.

OK, thanks again
(and to Thomas for gluing my query to those other two which got this
moving!)

Dave.
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
