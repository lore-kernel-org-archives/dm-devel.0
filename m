Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BF3539A
	for <dm-devel@lists.linux.dev>; Wed,  5 Mar 2025 00:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132874; cv=none; b=MJ+A1CnmRWfjVFSlnB94KCIQyoXLbhhkgBD3/wOuhlLxe9XM/cj1608rsgWvWLKqNwpqoKqXeIG2ivnPvXk6HeAND4qbXVCF8hvZkYaSH0fZmya/b30NRRF3n0LoB/rYOpyopkJEOkjdC6yZNIBIoYq5oQtx3+PlbQhShoHluJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132874; c=relaxed/simple;
	bh=rRf1I8v2mb7cp/ZXvd0fvfOTQ6ljFLMAqB8offpuq4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIrnMUPI5MKv3Mf0o7JBd4hCh3W9WrExI3yJnpW0ckJ2hK8qfN/9o/iaaAHkzMuf/m6Etmxb7ROMtU/qp5dNERpwxv6xHqatIgi6RaxHs0l9HAXMesJNuYgwgnHIoIhborG4Ke0NZT7rKeCEEQWk3MU77iEg6cCjlq5QS6SkxPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ifROLQ/e; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ifROLQ/e"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-219f8263ae0so116428325ad.0
        for <dm-devel@lists.linux.dev>; Tue, 04 Mar 2025 16:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741132871; x=1741737671; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r789Q1jlfKz3IK8/NvqMNawojmvOfE2LdKKMhm7xExQ=;
        b=ifROLQ/e9I9y0Pilb1yceQEd+n5jifz2ve3aeMwTlU0clF2C5sXKc78qWBzLZABk+h
         lpADztqFwfzhP5A+iIFOlkBBL/Q6aMiuDaipGikpaHlnDlxFj4ptjFC41wAPIAJRQsJT
         TGkcePD44UQEg1chLil/74ImuRnVE3FA9jQc5gl/iQ2mf55xG7Il+wmtAcfkn9G9OtsA
         Bn84kdlVkPZLMe6Fkhowa0YLuMp3sxN8eASpD+xmiktvl2Dnes5iINXJ9xuCfI4p4OkB
         VpbKcUMo0i9tVxLWhno+myz6/b9SR4p0mHy94mP2BFUwVu70TVoRRSrmAaQEfKMb4Tzn
         7xRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741132871; x=1741737671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r789Q1jlfKz3IK8/NvqMNawojmvOfE2LdKKMhm7xExQ=;
        b=T6pnA+bzJXaU7oG7csp2RYRXnLuwQ3FGJk/4s8kUkQ2xeAUL+O0gzkoMW/4wrIiS2Q
         hzRA4itwwF8w7Qww8+6Vk2iU/72CEPAoagrNvwy0ZD5Ru/s7kGQFi3fUlh2ZS5LlCvrz
         O/ZzLDshCiHXF5dTVkkIQBiR4N0aayAjQk5pZ5g7Ji+znVDbXDgOOBSroPIvBLvXxUi1
         IPirb0Kw71UjxTDTb5RBEhkYuvA1/jlCSD4z7lzlwM+R+xmEK2hjPFZ/D958OfUuPyMJ
         AhoZqzU7aP6SU6/90IxypXrh1YafjxMBf49vRuxRHyMA2e7U/Siibd2KxYt47cm+l4YF
         uK5A==
X-Forwarded-Encrypted: i=1; AJvYcCVuI7OL5+TKYEE0rWQtvYUqBMyVvHrQQuU/53L/CinVNzu009fh7YcHmmXtmo4H1mjF/8gn4E0y+g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwbkocBMbHGPSvuCjWWnVTV17Fl3jC736lO6ouqIjt7+mceRPJu
	NbLA0wOb+PVb7SI00T3JLN+OagHt2mfyMDJ/mNpvyvpTMzinEBECUfIFqpVv7kA=
X-Gm-Gg: ASbGncsFeImEw+Lo0wOh8JxmL13qURe0oM7Ks+nYtEjsZEGC4wCbdr5v2MaydoSYUkb
	rFixiTqCMa63NdcRkvm2Z3i+/49gqYW8hlQX7aYXtbwDsEH57JtsQE7kdUzPF8GIdBXWw2sdUyI
	vfz6oqw+kMpAVXzjsGM7lmSJhyofXOKniTQMXTDLyHk3OmMgeDYn1pyNGQMKYbPyZ/vdb2jlx2X
	NakM54nrkcEVs3g9U2iprctkt45fatb0wpMagMaYAlMWKtoyjakQCNpWpSCD/0b6E5Hfi6fSRSF
	8J4LqCwYxf47Q2GUFRr/nNDrIkH/8ug0mDF5cZAO15m72H+IsL4c5rqKtdwQLyUNAyxTBojB23A
	xzvq+0gbeZA==
X-Google-Smtp-Source: AGHT+IHWgVZhwTqjUW79RBkAyQLg9bvckDYTsLtUpYchpTAMxRfLmyPz7j2sZ2jjWwFHd2M8cA6aqg==
X-Received: by 2002:a17:902:d486:b0:21f:522b:690f with SMTP id d9443c01a7336-223f1d15117mr17904215ad.46.1741132871461;
        Tue, 04 Mar 2025 16:01:11 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d5247sm101040415ad.26.2025.03.04.16.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 16:01:10 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpcCC-00000008xBG-1vBY;
	Wed, 05 Mar 2025 11:01:08 +1100
Date: Wed, 5 Mar 2025 11:01:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z8eURG4AMbhornMf@dread.disaster.area>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
 <Z8W1q6OYKIgnfauA@infradead.org>
 <b3caee06-c798-420e-f39f-f500b3ea68ca@redhat.com>
 <Z8XlvU0o3C5hAAaM@infradead.org>
 <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
 <Z8Zh5T9ZtPOQlDzX@dread.disaster.area>
 <1fde6ab6-bfba-3dc4-d7fb-67074036deb0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fde6ab6-bfba-3dc4-d7fb-67074036deb0@redhat.com>

On Tue, Mar 04, 2025 at 12:18:04PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 4 Mar 2025, Dave Chinner wrote:
> 
> > On Mon, Mar 03, 2025 at 10:03:42PM +0100, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Mon, 3 Mar 2025, Christoph Hellwig wrote:
> > > 
> > > > On Mon, Mar 03, 2025 at 05:16:48PM +0100, Mikulas Patocka wrote:
> > > > > What should I use instead of bmap? Is fiemap exported for use in the 
> > > > > kernel?
> > > > 
> > > > You can't do an ahead of time mapping.  It's a broken concept.
> > > 
> > > Swapfile does ahead of time mapping. And I just looked at what swapfile 
> > > does and copied the logic into dm-loop. If swapfile is not broken, how 
> > > could dm-loop be broken?
> > 
> > Swap files cannot be accessed/modified by user code once the
> > swapfile is activated.  See all the IS_SWAPFILE() checked throughout
> > the VFS and filesystem code.
> > 
> > Swap files must be fully allocated (i.e. not sparse), nor contan
> > shared extents. This is required so that writes to the swapfile do
> > not require block allocation which would change the mapping...
> > 
> > Hence we explicitly prevent modification of the underlying file
> > mapping once a swapfile is owned and mapped by the kernel as a
> > swapfile.
> > 
> > That's not how loop devices/image files work - we actually rely on
> > them being:
> > 
> > a) sparse; and
> > b) the mapping being mutable via direct access to the loop file
> > whilst there is an active mounted filesystem on that loop file.
> > 
> > and so every IO needs to be mapped through the filesystem at
> > submission time.
> > 
> > The reason for a) is obvious: we don't need to allocate space for
> > the filesystem so it's effectively thin provisioned. Also, fstrim on
> > the mounted loop device can punch out unused space in the mounted
> > filesytsem.
> > 
> > The reason for b) is less obvious: snapshots via file cloning,
> > deduplication via extent sharing.
> > 
> > The clone operaiton is an atomic modification of the underlying file
> > mapping, which then triggers COW on future writes to those mappings,
> > which causes the mapping to the change at write IO time.
> > 
> > IOWs, the whole concept that there is a "static mapping" for a loop
> > device image file for the life of the image file is fundamentally
> > flawed.
> 
> I'm not trying to break existing loop.

I didn't say you were. I said the concept that dm-loop is based on
is fundamentally flawed and that your benchmark setup does not
reflect real world usage of loop devices.

> But some users don't use COW filesystems, some users use fully provisioned 
> files, some users don't need to write to a file when it is being mapped - 
> and for them dm-loop would be viable alternative because of better 
> performance.

Nothing has changed since 2008 when this "fast file mapping" thing
was first proposed and dm-loop made it's first appearance in this
thread:

https://lore.kernel.org/linux-fsdevel/20080109085231.GE6650@kernel.dk/

Let me quote Christoph's response to Jen's proposed static mapping
for the loop device patch back in 2008:

| And the way this is done is simply broken.  It means you have to get
| rid of things like delayed or unwritten hands beforehand, it'll be
| a complete pain for COW or non-block backed filesystems.
| 
| The right way to do this is to allow direct I/O from kernel sources
| where the filesystem is in-charge of submitting the actual I/O after
| the pages are handed to it.  I think Peter Zijlstra has been looking
| into something like that for swap over nfs.

Jens also said this about dm-loop in that thread:

} Why oh why does dm always insist to reinvent everything? That's bad
} enough in itself, but on top of that most of the extra stuff ends up
} being essentially unmaintained.
} 
} If we instead improve loop, everyone wins.
} 
} Sorry to sound a bit harsh, but sometimes it doesn't hurt to think a bit
} outside your own sandbox.

You - personally - were also told directly by Jens back then that
dm-loop's approach simply does not work for filesystems that move
blocks around. i.e. it isn't a viable appraoch.

Nothing has changed - it still isn't a viable approach for loopback
devices for the same reasons it wasnt' viable in 2008.

> The Android people concluded that loop is too slow and rather than using 
> loop they want to map a file using a table with dm-linear targets over the 
> image of the host filesystem. So, they are already doing what dm-loop is 
> doing.

I don't care if a downstream kernel is doing something stupid with
their kernels.

Where are the bug reports about the loop device being slow and the
analysis that indicates that it is unfixable?

The fact is that AIO+DIO through filesystems like XFS performs
generally within 1-2% of the underlying block device capabilities.
Hence if there's a problem with loop device performance, it isn't in
the backing file IO submission path.

Find out why loop device AIO+DIO is slow for the workload you are
testing and fix that. This way everyone who already uses loop
devices benefits (as Jens said in 2008), and the Android folk can
get rid of their hacky mapping setup....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
