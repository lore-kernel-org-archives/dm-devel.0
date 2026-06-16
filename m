Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27F53ADBAC;
	Tue, 16 Jun 2026 23:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781653664; cv=none; b=HyNofBNU6rhgmyb5UCqa8Tw6XxBzOPeDmmL4KuSStt0BPDLsUsGXdJV5l7ZWes3y0FRuub97b74YVkdUlx+BI2b0Cp19Ys7fxTOm0CxavEP/iYtiukZ9KP7p0xxSf1vgYmnvNTPjqR3/T0k1/yshtE2FS7VqGVTJ1tywxAKi9WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781653664; c=relaxed/simple;
	bh=Ia37bVYtODG0iMuzwXEAyjJ7hpWmw5zvE84hvyjJdTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brb+wfG9EO0LHDG3j+DzEpjzbWeoNf+83gSeWyJHN2LSnV3kRqWEPginIiejVaOPcTskzDXn7rhrm+0d2i1bMC/ZxMz9D5lmTKOq25FQwAPH/4+f1nffwuIGFTeCpTTnlBZNS/cnLO378Wir4w/51bGpFMiJvUXEAGFFsksXCjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Mh4amz8s; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Mh4amz8s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=uUqXq74JcCRG12Ys8DcDIO0suKKnJqu3XS3PIM0oyTk=; b=Mh4amz8svqS0VEgg
	CoAV8P+tLZ/u09B0tqCDA5dylIDaMnotn2SAQ3Y9tTryhK04g7xinfPSa4NylQmRyDsaIiQcImPdk
	UUlN5oXYIZkuDV3e7JtWAQvQ+tpDhE1eMjMAkq8NSr+2KJlWUBIOrBOW+UOMGC8YoX70L+fJPbGBL
	0NhF3LfsfUDRXkfpSKLHoC8GUegsyc75xqFAt7lLrzpYSRHfFSw4kB70RZt0J0hC83hQUUrITMxqi
	LNL4PjwdRkM6/P+DSFAVaSeMTGXLjv/MuJyShGndyhLqrHBjanNvEAJ6C+mZk88Qe4BOI7cxQf+hS
	Kjddq5EPrOIGJjMWTg==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZdVM-00000008A3o-0iao;
	Tue, 16 Jun 2026 23:47:40 +0000
Date: Tue, 16 Jun 2026 23:47:40 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajHgnCh7mv-TYilH@gallifrey>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
 <ajHgIWdT0QmeF_t4@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajHgIWdT0QmeF_t4@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 23:46:18 up 32 days,  2:59,  2 users,  load average: 0.01, 0.05,
 0.01
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Tue, Jun 16, 2026 at 08:09:18PM +0000, Dr. David Alan Gilbert wrote:
> > Interesting; I've got your:
> >   dm-raid1: don't fail the mirror for invalid I/O errors
> >   For DM_IO_BIO requests, do_region() built each destination bio by walking..
> > ontop of e21ee273e6fa3879aec9a27251cfce98156e07c4 which is just before 7.1
> >   I've not your https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta.com/
> > 
> > root@dalek:/home/dg# lvcreate  --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > root@dalek:/home/dg# mkfs.ext4 /dev/mapper/main-lvol0
> > root@dalek:/home/dg# mount /dev/mapper/main-lvol0 /mnt/tmp/
> > root@dalek:/home/dg# chmod a+rwx /mnt/tmp
> > 
> > dg@dalek:~$ dd if=/dev/zero of=/mnt/tmp/testfile bs=1024k count=1
> > 
> > my two tests are separate tests:
> 
> Goodness, I'm struggling here. Unpatched, I have no problem recreating
> the issues you've described, but everything I've tried with the
> proposals included gets the expected results. I'm running out of ideas
> on replicating your results with hardware I have, but it's getting late,
> so I'll try to have new ideas tomorrow.

OK, no problem - let me know if there's any useful diags I can gather;
would blktrace or function tracing or something help?

Sleep tight!

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
