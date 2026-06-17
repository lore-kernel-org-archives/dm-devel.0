Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC6A47F2C0;
	Wed, 17 Jun 2026 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781710451; cv=none; b=Vlehk7Gw2Mbjcs1dlfQbIuB9f1Ugw5/h5avrgs1ap9Q6zJR07PJwKmPUfGdPjZFiAb5N8zAXeceJ3NpdapTyQ302uk+at+SYvAECrxwFu8j7ZWNBqhtwDPWUtvPkItaYaczkZmu+C0/i/8kgLExgIPiM2baLvsW6ehDPXggntdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781710451; c=relaxed/simple;
	bh=ldQlyF3iwZDHzqDz6i5JqXa6qEru3kHdRQKwkQUyNRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJO6IlbK7tzl4FCN9OoG2q3KVQ17AJBjoSl07G1jx8FEfj66PzCEg94ZFFog+xvhkV09jK+K3JTVEzNVoKcwqIWQnTZnj3hhql18+Dtp1XS0018oK13jrYPIpNE9stijWZrTH04Lk6Jhal4JZy9ha0trUH21413RbIU5+z2tXlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=pGG6rX+X; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="pGG6rX+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=XZyXprz0zJow+g3vO4Ir15KoK2E7phHH/ANUzJJ3MqM=; b=pGG6rX+Xa92C8IaL
	GGumvVURVUkhWeK15+gogjsJsf+5/GdWyMrCR9ITgof1kbwzBBI07kAiLp8OquA6DNDQxbmFTvIeR
	ar2wjNmb4w3BzqO1Z36k+tIXwG7tFHfpMjcsqccVmOWdPEa/wG8lksS3MjduROzq3523DXfwivUI6
	VhJtrjAH9fwjT3KKci/W5a1YIMYtPFOPC5vsb4fSKRzlYmr5MqyJht6hy0RCUpGSqxDCtbDcMedtH
	NxRqxq9XmU/5VVQn0wUw8pg5e4ffrmiN+PFNYTViq7fhZOCGFTZsPgFTK9LffqSp/khiZoiBojOMI
	yNdrvly2v6uMq8CUfA==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZsH5-00000008LR7-1StE;
	Wed, 17 Jun 2026 15:33:55 +0000
Date: Wed, 17 Jun 2026 15:33:55 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajK-Y7uoK0QT5PVl@gallifrey>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
 <ajK4YacvP7eQ-S2o@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajK4YacvP7eQ-S2o@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 15:33:08 up 32 days, 18:45,  3 users,  load average: 0.00, 0.03,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Tue, Jun 16, 2026 at 08:09:18PM +0000, Dr. David Alan Gilbert wrote:
> > root@dalek:/home/dg# lvcreate  --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> 
> So this is a subtle difference from your original report which ran
> lvcreate a little differently:
> 
>   # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> 
> This patch series address problems with the original report with the
> "--type mirror" parameter, which uses dm-raid1.c instead of md/raid1.c.

Ah OK.
(I think I think I did say that somewhere, hmm ajFK5NXkxd6jU5zu@gallifrey ? )

> Knowing that detail makes this a trivial matter to fix now, so I'll send
> a separate patch for that. But this series should be good to go for the
> original issue on the legacy dm mirror.

Great!  Thanks again,

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
