Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D77F1552E0
	for <dm-devel@lists.linux.dev>; Tue,  4 Mar 2025 02:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741054443; cv=none; b=tA4dE8rRkZiCDD83YLFq2966rwl/IAxyEbGAlXR8YJJBNwCuBOQfpIlKen5Tbiyvpgx2IZuxPoaDNi34LhkaBsFEJjXJoDz8+9c9+5orbffb36Brs83lKQ85ug/zJ8bJQG0I414HMwoFGbUbW7YvNgbV/B0q378Ng/tJ/j19bbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741054443; c=relaxed/simple;
	bh=65qteFEhlJkfEJHajsEeIUVaNND/sMGS27EzH//MlBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWY5tNkYH9CpApNFNkMOrDeaqOmL+HkTEBb92yh3GAa4eS54q4r2Dtr9KTTwbj5r3IaNvfIggwxg11Qj1BEEnGihyvr5PRAXPjtYPX15KVzMFrNL1h7PjyRC3/QsPvf9YIyF3EJKOmtBKICeGSZg4LBE1Kw5o+fSjY5BAo1lJ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=NmjinMaE; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="NmjinMaE"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22113560c57so97252385ad.2
        for <dm-devel@lists.linux.dev>; Mon, 03 Mar 2025 18:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741054441; x=1741659241; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sK0gfp+tfIRPtJrzvnT/QgeAtUCdjlbqmvBwODDMg9Q=;
        b=NmjinMaEueH1vR5U19gDtckE51nTd2kelrwH1SrAZ/3h+qTvd5kl5B+Kq9IPWsNwUu
         j3zc+q0qkAkXpmzJRQ+lSJp98ktb1pnWyvVh4Ozs4/wM0kek1yY8FDELIBocETdCz3iP
         WJY+4i1v3+/FGcdSgFwIu0FqHfN8FUaZin5oob7iXGc2j6wTo6mXl+pMgiCZ4aOfRRhM
         d4xv6vRomluRHtxjpLcBjW85PK+neHxU8Sz5if7PetDefZik3elMPgbQ4hx2pbAMMxdl
         21rFFEi0ciNe3V9tcdP26xi5N/Jd5WSejRZZfDk4kpkpXdWpiLeFCKKhVhgG2VC5Oi8h
         7Yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741054441; x=1741659241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sK0gfp+tfIRPtJrzvnT/QgeAtUCdjlbqmvBwODDMg9Q=;
        b=ssoikk598LQuA08qLEufor94cAOYWXIoL63ivmUz2QwNNClZNJKdqkDeQlQngqHl5t
         +ZLM9MB1TYjsG0ReFZhVTw3+qk+MSfXYWi/EMfdNJodisq4jy9o2TWZ0HIZSMRKTNPPQ
         BL8Jn7JYq0aoTfLfHuU1OHJHvg7lTrPUCnhjxF79Vlpn07QTFGb4GEtWjMo79V+AwOy/
         8zjm9ZPYklzXpg+jvR3uXXVVVWND0q6TToL0RRZTMY8fnZAsTf9oAA2Ukpm7x5un6qwi
         K35H9rn2r/e34Z8cdzbjiJDSi4rlcD1N/HSz3Jzv/EKUYapPnQ0thINzK6QKXZfyxPwU
         sQUw==
X-Forwarded-Encrypted: i=1; AJvYcCUuaZc7oHfIAWT7lMraT2d68Y4bc9kkevGBbfGJD0a42KpeFX7/0V4bWu3otKhvTb/kYCKW++/cZQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+FOCM9sq8Ap9kBmNQTSPLUVO675DjiCGbx65ekDy+dZ7U4LDj
	BA3llxpbHtdP7AmcPSbujuzP2ll7cRcYtp0nYa4pMIFHvcq0yvp+dOqUSF6Rcb0=
X-Gm-Gg: ASbGncuDj2iYWzq0G1ldaC+8qy768pAoT5WlXgBZGlH/3q2Nxvd5BLqgnagiRCcg6PV
	VzG53XtrUxJizEABkE1KhzBLkVAx4NHSI7XnOO8MrIPqBTG2VKO5sKEqRnblz4Rn30P/SBjiR4g
	7AItLqSOJEUwgMj/3rEnPl0wUwWWAA5ucjomCOT2K/nEU42uUMxNLeGwcDL4cQBBK5ly0TgVDaP
	bTQiCkuq6/x3MS+vKqDeTfks/BHekJTs5gIdBd42tawzLTuAVtDKQdQSaZb9JvrkFr5Evhc3zeT
	Jm+FvAVJFK6HGulBaGRJGPMlolmzyzQBTPUnBIyHSJA00j1NxukiACyLLkN2cvp6zZUL0bPXqj8
	oscXdWS3j7Q==
X-Google-Smtp-Source: AGHT+IHyS8XI7dQracLy9dzzwN9VnTebYLZcAjwtproeAmBp0VUFPFDoIsd/L7rBrZtQKzPw1kpc7Q==
X-Received: by 2002:a17:903:3b85:b0:220:caf9:d027 with SMTP id d9443c01a7336-22368fbeb7cmr225661495ad.23.1741054440675;
        Mon, 03 Mar 2025 18:14:00 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c5bd2sm84882545ad.111.2025.03.03.18.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 18:14:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpHnB-00000008Ys6-2dlU;
	Tue, 04 Mar 2025 13:13:57 +1100
Date: Tue, 4 Mar 2025 13:13:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z8Zh5T9ZtPOQlDzX@dread.disaster.area>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
 <Z8W1q6OYKIgnfauA@infradead.org>
 <b3caee06-c798-420e-f39f-f500b3ea68ca@redhat.com>
 <Z8XlvU0o3C5hAAaM@infradead.org>
 <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>

On Mon, Mar 03, 2025 at 10:03:42PM +0100, Mikulas Patocka wrote:
> 
> 
> On Mon, 3 Mar 2025, Christoph Hellwig wrote:
> 
> > On Mon, Mar 03, 2025 at 05:16:48PM +0100, Mikulas Patocka wrote:
> > > What should I use instead of bmap? Is fiemap exported for use in the 
> > > kernel?
> > 
> > You can't do an ahead of time mapping.  It's a broken concept.
> 
> Swapfile does ahead of time mapping. And I just looked at what swapfile 
> does and copied the logic into dm-loop. If swapfile is not broken, how 
> could dm-loop be broken?

Swap files cannot be accessed/modified by user code once the
swapfile is activated.  See all the IS_SWAPFILE() checked throughout
the VFS and filesystem code.

Swap files must be fully allocated (i.e. not sparse), nor contan
shared extents. This is required so that writes to the swapfile do
not require block allocation which would change the mapping...

Hence we explicitly prevent modification of the underlying file
mapping once a swapfile is owned and mapped by the kernel as a
swapfile.

That's not how loop devices/image files work - we actually rely on
them being:

a) sparse; and
b) the mapping being mutable via direct access to the loop file
whilst there is an active mounted filesystem on that loop file.

and so every IO needs to be mapped through the filesystem at
submission time.

The reason for a) is obvious: we don't need to allocate space for
the filesystem so it's effectively thin provisioned. Also, fstrim on
the mounted loop device can punch out unused space in the mounted
filesytsem.

The reason for b) is less obvious: snapshots via file cloning,
deduplication via extent sharing.

The clone operaiton is an atomic modification of the underlying file
mapping, which then triggers COW on future writes to those mappings,
which causes the mapping to the change at write IO time.

IOWs, the whole concept that there is a "static mapping" for a loop
device image file for the life of the image file is fundamentally
flawed.

> > > Dm-loop is significantly faster than the regular loop:
> > > 
> > > # modprobe brd rd_size=1048576
> > > # dd if=/dev/zero of=/dev/ram0 bs=1048576
> > > # mkfs.ext4 /dev/ram0
> > > # mount -t ext4 /dev/ram0 /mnt/test
> > > # dd if=/dev/zero of=/mnt/test/test bs=1048576 count=512

Urk. ram disks are terrible for IO benchmarking. The IO is
synchronous (i.e. always completes in the submitter context) and
performance is -always CPU bound- due to the requirement for all
data copying to be marshalled through the CPU.

Please benchmark performance on NVMe SSDs - it will give a much more
accurate deomonstration of the performance differences we'll see in
real world usage of loop device functionality...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
