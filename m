Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F78933065D;
	Mon, 15 Jun 2026 13:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529657; cv=none; b=VOm9y7hiX04c4i6LX6mpjNkUCzwOF5W/UmwN9EKUj9Pc7hYgPcUn73hl5FDJh46GA0zmWwUQEgaWgCCchI/gfrPhj/r14Uuy0TsQVCNn1K3jgfxhvZ+4JYzjZ2YW9ZvKVBunwr6iyDFZvm825bEaB5B4LtU0xTT+ibwvoRe3ClM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529657; c=relaxed/simple;
	bh=WBy4ftRsF+77j9Y8vrKrrhxO61L1Uzcgj5u5ThGaNFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOyaxyhcYOHEVUnbJhDDY9skkRVHwmuaRECrIVS2GFnJ/uLHDQavg+nPWH18hwGCR6NhXBz2gIBhAOnjj4sorsnWygyEM6LmqsvMwckum8Hh+CQeUmEyZmB4olWUEeMpNyoC3swWjuhfpR/tjXo5gLIgJzfnOcyzKVmNvqmqMYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=QC+kSnhJ; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="QC+kSnhJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=q4Ln9xrT69rl6foCabuTmIp5JgkEPmV60vTvASDJviU=; b=QC+kSnhJUmg24DxA
	bzRL/D0WYwY4/SGGwXBNEEP4JnibPKsKFse9EhL7nEEYKDWs68Tiq44DwdwUOFwh7+ERgoIsvoyl7
	okLtysXykbuzG9fDrx+MaaQOSjLDwJj0VfgpFpfy/I7Xn0xNHfY97xpy0lRwPMhAAwpN5ilT1UdbQ
	C4CXjVcBxWq4ok6uFWLBTaixbIhMGIcGI2Q1gR0cX+TD0iwHpcAkKQN/PLz0wedlug/QpOo365UOq
	rN/Hc088mDlOO5+/kVZABMCFxy5VL5Mq/mvIg98T80Q5IaWY1qU4HSVVQoRKDHXvMLUTU0hvKTCVZ
	KQEzsaq1qtC+Zt9UkQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZ7FF-00000007jlc-1qZO;
	Mon, 15 Jun 2026 13:20:53 +0000
Date: Mon, 15 Jun 2026 13:20:53 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ai_8NbPAG6YgwpnQ@gallifrey>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <31e178fc-ed41-45d9-9e85-2d114f4222a4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <31e178fc-ed41-45d9-9e85-2d114f4222a4@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 13:18:13 up 30 days, 16:30,  2 users,  load average: 0.06, 0.05,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Zdenek Kabelac (zkabelac@redhat.com) wrote:
> Dne 14. 06. 26 v 19:57 Dr. David Alan Gilbert napsal(a):
> > Hi,
> >    I've got a repeatable raid hang/warn and would appreciate some pointers
> > as where to debug.
> >    (I've been logging stuff on  https://bugzilla.kernel.org/show_bug.cgi?id=221535 )
> > 
> >    This started off as debugging a case where I'd get my RAID1 (on the host)
> > getting a reliable 'rescheduling sector'/disk failure while running the qemu block test suite
> > during a qemu build, but then I tried to build a smaller discrete
> > test, and now I've got a simply triggerable warn and test hang.
> > There's no errors from the underlying SATA layer on the storage,
> > everything resyncs just fine.
> > 
> > I've got an existing LVM vg ('main') with two mirrors on sda2, and sdb2
> > which are SATA disks.
> > 
> > # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > 
> 
> Hi
> 
> It's probably worth to say here - the '--type mirror' is the OLD
> (historical) DM mirror target implementation - this target is now in the not
> so active development as users are supposed to be using newer (and faster)
> md wrapped '--type raid1'

Ah, that might have been when I split off to using a separate test
LV rather than risking my LV containing actual useful data and had to
try and find the lvcreate command.

> So if you use   'lvcreate -m1 ....'   you get 'auto-magically' this
> mirroring target.

Thanks,

Dave

> But this obviously doesn't fix the problem if old mirror target...
> 
> Regards
> 
> Zdenek
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
