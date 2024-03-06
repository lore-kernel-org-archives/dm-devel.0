Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D82135A5F
	for <dm-devel@lists.linux.dev>; Wed,  6 Mar 2024 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740815; cv=none; b=aDrWinCwrvqW+MXtbvT42V7nJBGoyq/WLgY/J6YEGtSGb7QYwUvGMXJ+KrJxexCrDH2cENNzFleKbBr/FMQezA3AjNvCmBH9eUugL1JsMGwJsUbIDz4MceX9hVNT7jRUEG6kyI/XVS00hw0h6wKX0ELfIwKEakUSngXv5brRF4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740815; c=relaxed/simple;
	bh=yErQmxsqshrBcM8l6AwNJI7JsDiBKwPq6xd5fRjHqwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tz++eTxHwgnosbvPRCO4FiignpoRgLCNEB1lxoiAkNdP5AN4cDfol+tXm5CCozCFIQC2d8Mrzb4VPPcCrNLnV8fcyZ+UN1NjXUhhK2c/2x5aGssSvN7vqlCPluN80Fl5h/hLHA5BQcA2PmEifQqzIxzTn+0/gOko11ztAW666A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KFuvvBpI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFuvvBpI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709740812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wIIdw8ckHvVn5igXTzUjHRLg6rvzXoUvv9uYoYgw/8Q=;
	b=KFuvvBpItsmhlG2GTAcjhb1Mno05fHv1PWnvcXvp0Ef/A+2qi3NoUsOUB6Nypfkn/M086K
	RKK3jvQWTvGV1saLTWJ3z/yhyqAQONPzkaAC2E8U6tbvSgS+KDi3lA1zz8KGdseXLev7nZ
	+eGOYk5HSAi65PuYngOGzjUjTtHATc4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-VkHvEyVUPY-rUx7UgScF8w-1; Wed,
 06 Mar 2024 11:00:08 -0500
X-MC-Unique: VkHvEyVUPY-rUx7UgScF8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 184761C54062;
	Wed,  6 Mar 2024 16:00:08 +0000 (UTC)
Received: from fedora (unknown [10.72.116.47])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6165D200AD5B;
	Wed,  6 Mar 2024 16:00:01 +0000 (UTC)
Date: Wed, 6 Mar 2024 23:59:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>,
	Patrick Plenefisch <simonpatp@gmail.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>, linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	regressions@lists.linux.dev, dm-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: LVM-on-LVM: error while submitting device barriers
Message-ID: <ZeiS/bjJaRcrerWW@fedora>
References: <CAOCpoWc_HQy4UJzTi9pqtJdO740Wx5Yd702O-mwXBE6RVBX1Eg@mail.gmail.com>
 <CAOCpoWf3TSQkUUo-qsj0LVEOm-kY0hXdmttLE82Ytc0hjpTSPw@mail.gmail.com>
 <CAOCpoWeNYsMfzh8TSnFqwAG1BhAYnNt_J+AcUNqRLF7zmJGEFA@mail.gmail.com>
 <672e88f2-8ac3-45fe-a2e9-730800017f53@libero.it>
 <CAOCpoWexiuYLu0fpPr71+Uzxw_tw3q4HGF9tKgx5FM4xMx9fWA@mail.gmail.com>
 <a1e30dab-dfde-418e-a0dd-3e294838e839@inwind.it>
 <CAOCpoWeB=2j+n+5K5ytj2maZxdrV80cxJcM5CL=z1bZKgpXPWQ@mail.gmail.com>
 <a783e5ed-db56-4100-956a-353170b1b7ed@inwind.it>
 <ZedaKUge-EBo4CuT@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZedaKUge-EBo4CuT@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Mar 05, 2024 at 12:45:13PM -0500, Mike Snitzer wrote:
> On Thu, Feb 29 2024 at  5:05P -0500,
> Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
> > On 29/02/2024 21.22, Patrick Plenefisch wrote:
> > > On Thu, Feb 29, 2024 at 2:56 PM Goffredo Baroncelli <kreijack@inwind.it> wrote:
> > > > 
> > > > > Your understanding is correct. The only thing that comes to my mind to
> > > > > cause the problem is asymmetry of the SATA devices. I have one 8TB
> > > > > device, plus a 1.5TB, 3TB, and 3TB drives. Doing math on the actual
> > > > > extents, lowerVG/single spans (3TB+3TB), and
> > > > > lowerVG/lvmPool/lvm/brokenDisk spans (3TB+1.5TB). Both obviously have
> > > > > the other leg of raid1 on the 8TB drive, but my thought was that the
> > > > > jump across the 1.5+3TB drive gap was at least "interesting"
> > > > 
> > > > 
> > > > what about lowerVG/works ?
> > > > 
> > > 
> > > That one is only on two disks, it doesn't span any gaps
> > 
> > Sorry, but re-reading the original email I found something that I missed before:
> > 
> > > BTRFS error (device dm-75): bdev /dev/mapper/lvm-brokenDisk errs: wr
> > > 0, rd 0, flush 1, corrupt 0, gen 0
> > > BTRFS warning (device dm-75): chunk 13631488 missing 1 devices, max
> >                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > tolerance is 0 for writable mount
> > > BTRFS: error (device dm-75) in write_all_supers:4379: errno=-5 IO
> > > failure (errors while submitting device barriers.)
> > 
> > Looking at the code, it seems that if a FLUSH commands fails, btrfs
> > considers that the disk is missing. The it cannot mount RW the device.
> > 
> > I would investigate with the LVM developers, if it properly passes
> > the flush/barrier command through all the layers, when we have an
> > lvm over lvm (raid1). The fact that the lvm is a raid1, is important because
> > a flush command to be honored has to be honored by all the
> > devices involved.

Hello Patrick & Goffredo,

I can trigger this kind of btrfs complaint by simulating one FLUSH failure.

If you can reproduce this issue easily, please collect log by the
following bpftrace script, which may show where the flush failure is,
and maybe it can help to narrow down the issue in the whole stack.


#!/usr/bin/bpftrace

#ifndef BPFTRACE_HAVE_BTF
#include <linux/blkdev.h>
#endif

kprobe:submit_bio_noacct,
kprobe:submit_bio
/ (((struct bio *)arg0)->bi_opf & (1 << __REQ_PREFLUSH)) != 0 /
{
	$bio = (struct bio *)arg0;
	@submit_stack[arg0] = kstack;
	@tracked[arg0] = 1;
}

kprobe:bio_endio
/@tracked[arg0] != 0/
{
	$bio = (struct bio *)arg0;

	if (($bio->bi_flags & (1 << BIO_CHAIN)) && $bio->__bi_remaining.counter > 1) {
		return;
	}

	if ($bio->bi_status != 0) {
		printf("dev %s bio failed %d, submitter %s completion %s\n",
			$bio->bi_bdev->bd_disk->disk_name,
			$bio->bi_status, @submit_stack[arg0], kstack);
	} 
	delete(@submit_stack[arg0]);
	delete(@tracked[arg0]);
}

END {
	clear(@submit_stack);
	clear(@tracked);
}



Thanks, 
Ming

