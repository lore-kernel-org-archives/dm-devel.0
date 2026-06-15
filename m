Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D68409128;
	Mon, 15 Jun 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781545366; cv=none; b=P3MK7SyFjVzjym8MVuaAqGPZVPMjG/3HBaPHPQiuTRQdB6DoDvYwXqONifp3t1LLaDFqiU7xvCRKPdFBNcwUBOYExaO1H7Jh35HbqAw9xPsSHCjG4yorSL4v2Ybc3iwtFClfHuvjuXqC49wTKpj76O2c8DgGakL9y9N7Y3+Zq/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781545366; c=relaxed/simple;
	bh=cSW22OFjUrtZkrSJBtMq3YpxXpw2AbjC2BV6ILrnW1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i71PVtIUfgazR2uLjhBa6G20JR1V7LF1oukgMSOuFUSAXzKurHKRu0W7LfS2f49ZyHMW8G29OVaVFZsxXzIWEtq53f+6//8EmcJOoHO5INfXqd/4K1fG1nvf3fh//UDvhTA71aUcTCzddmvIhXnv1oWm+tbtlLge1PH5OgCvnxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=V+ilREmf; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="V+ilREmf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=zrq2IOvrLzT7YTwjZtNxwzvUw3chS6yvepMZ1EjEA4Q=; b=V+ilREmfJm0vtGwM
	VmehlFvWaqL5+MEvpkjCQdcMJfiigqZiojYnyf4pEI9ShIg2vYNGMr8xQ0kh0kcjdHxV+Sfc44tdm
	SmJ8Xi/0lM0a28XDMyACvTr8Ebz0LaRd4RRyMIKbvju4AGleId9xYNfKniulkBO7UqsIkcm9Ciwpg
	ifJqcZOK3Y8UvI3/W63KfJnpZipneEF3RUQMkzrrQuNNgFn7+AATSEeERZPNuD5HLe9KKmV9y0+F+
	kj5YVnzo/U9gkXpLyAjXt3xSwHGscJ3dRTTSh8sUCLKLnPHcyWRwzLweVf8VjFVJ7vfBBzY/H1+jB
	ZFmm+cp0ifGGRlHNDw==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZBKc-00000007oRz-2lhD;
	Mon, 15 Jun 2026 17:42:42 +0000
Date: Mon, 15 Jun 2026 17:42:42 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajA5kpUraXqh9ag9@gallifrey>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <ajAYN_mmjzYBAimV@kbusch-mbp>
 <ajAb0m9cNraQn2Pw@kbusch-mbp>
 <ajAqUwo3eTm1c2_J@gallifrey>
 <ajA0L-u-r4nhbpfl@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajA0L-u-r4nhbpfl@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 17:39:19 up 30 days, 20:52,  2 users,  load average: 0.00, 0.01,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Mon, Jun 15, 2026 at 04:37:39PM +0000, Dr. David Alan Gilbert wrote:
> > Hi Keith,
> >   Thanks for the patch, alas it doesn't seem to be helping here;
> >  the first warn is still the same
> > and it still hangs the test process hard and eventually BUGs at
> > 
> > void blk_mq_end_request(struct request *rq, blk_status_t error)
> > {
> >         if (blk_update_request(rq, error, blk_rq_bytes(rq)))
> >                 BUG();
> 
> Oh, that was not expected.
> 
> What is the dma alignment requirement of your backing devices? You can
> find the attribute for sda at /sys/block/sda/queue/dma_alignment. I'm
> expecting 511, but just want to double check.

Yeh looks like it:
/sys/block/sda/queue/dma_alignment:511
/sys/block/sdb/queue/dma_alignment:511

all of the lvm also looks like it is.

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
