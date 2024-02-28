Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98CD3FBA5;
	Wed, 28 Feb 2024 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141171; cv=none; b=J0sXbPoX0HKr/9CML8qgTRrdRlbhekx0DVnhl4QATCNE/khd2XuqebY3hYMfcuqipo7PEYSNrmztvf+jHz58eGpKFGC4vP363bUoJJne+gTcNGKOBreyG5VLCorxfvr/79UGRr9gu6dyrXY5bLxow5gAoocmnJT/Ead+YkdyWZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141171; c=relaxed/simple;
	bh=UNTgcEBBg73DjZmytlJ3R7l8+M00JW1cu/+Tjop0kzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YgI27yG1PjraJwcPyQt4ISTXqPi0cpp5qtL25Gdt/ZfS5vvlVZN4WEbl8ZRRL1Ti/zuwGsgy3Vm7jTsmktawc8xLwicJ9ITJiocieAq3mW3tVJQzfIjjEBpS+jr7Wdk7LoZWkVS4mfJR7sc8vjTFOAKq4X1trLEC1ZvGKTmASlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kX8C3+pO; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kX8C3+pO"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d27184197cso72934881fa.1;
        Wed, 28 Feb 2024 09:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709141168; x=1709745968; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UNTgcEBBg73DjZmytlJ3R7l8+M00JW1cu/+Tjop0kzs=;
        b=kX8C3+pOQzyWz96AAWfM6RuIZ2nasV/BYC1Hk6CCDxagj9HpYSqEEY+tI3LsIZgvuM
         6zOUMy33pbCQbKglHpTIxfMwDBPOqabzeqhlbo5IPIQLkO7/UapJ6jc1FyIsc+mNJ39L
         KWEEMkr8g2sQWDHy2LDfaXPquv/UjKX578bcqbtkbEFpkuw2cvjOkeJHkvZoxmwqEcI3
         ojzoz9NQPFXTc1qdIBP4fS2OZM9W4gYEQ+GWsWPerl8dPzqTNGUj8orhOxVhnxbHlfBC
         4DFauHccDzcZHRolIvSynkGocIU2YZIIrCwAjfCt+/jyplvjdwE9W5Zh7NgM66ECXOmJ
         TpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709141168; x=1709745968;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UNTgcEBBg73DjZmytlJ3R7l8+M00JW1cu/+Tjop0kzs=;
        b=mAVC3w+b0Vm+Pyv9pgM+xkFiqOrHksYrd6ImmGNxPbt128M4uDdBIjJW6MoobqAj+a
         7eedgAuw27s5iUd9QBwVWHRSrjcasszRTiWgqf9YVDpNX9wUtNQ29y8yCqUHONbHGHGV
         7RO/tMYwo2ko/w581c+uC25j/lRNqKX1ZNbG/e+rupgAJe3tHaW3z2TY6fSE5GHLZZWf
         oTmf7u7U/nm4xpHkSXnO4/6SHerZll/6j10vAUbXAtXACekYOWDEspEYRSFdniWawu7X
         YS8AXIHLncukuXCs9MUtVH7H6AGtX3AqrAElALfrqzEmGJZDbi7VP5mWxmcqc3HITQUn
         FdAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIZSQvpvUgcNzeWLTualMAwpIocre3mOHiLiFz8Rv7IBEVfKN1nzOvdQYKY6OuZRuoHMaMj3ldIOIzG9fI/zqBUmaxX3hTQWT3E7LyaVyozw3FHb9+Poa/3w70pWtqjAdhbZSjDA==
X-Gm-Message-State: AOJu0YyxeCRkSVUE2nGvL22XqPNLL4Q27F3k4syVDXSgKPgJDAU1iIoB
	3xB/ZxXmijF7lOIGKup/SCZPG8a0KC2Vi8CvJcZClbffXS4e6kSz9m+/6aLIS33VCwNzz2CO050
	qn5MbvyFaChPQ1R0yCM2L/UCzr+qb3aXz/pjc8g==
X-Google-Smtp-Source: AGHT+IH1rWoewQvMELMlYHG8fdSakqFW164fjWcxkcHfJKS1Eql5fp55rbAcnXR8nYl+LnUARZaIVQMv/On3PTITdrk=
X-Received: by 2002:a05:651c:4d3:b0:2d2:c8ee:c99b with SMTP id
 e19-20020a05651c04d300b002d2c8eec99bmr2003504lji.29.1709141167712; Wed, 28
 Feb 2024 09:26:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAOCpoWc_HQy4UJzTi9pqtJdO740Wx5Yd702O-mwXBE6RVBX1Eg@mail.gmail.com>
 <CAOCpoWf3TSQkUUo-qsj0LVEOm-kY0hXdmttLE82Ytc0hjpTSPw@mail.gmail.com>
In-Reply-To: <CAOCpoWf3TSQkUUo-qsj0LVEOm-kY0hXdmttLE82Ytc0hjpTSPw@mail.gmail.com>
From: Patrick Plenefisch <simonpatp@gmail.com>
Date: Wed, 28 Feb 2024 12:25:57 -0500
Message-ID: <CAOCpoWeNYsMfzh8TSnFqwAG1BhAYnNt_J+AcUNqRLF7zmJGEFA@mail.gmail.com>
Subject: Re: [REGRESSION] LVM-on-LVM: error while submitting device barriers
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>, regressions@lists.linux.dev, dm-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I'm unsure if this is just an LVM bug, or a BTRFS+LVM interaction bug,
but LVM is definitely involved somehow.
Upgrading from 5.10 to 6.1, I noticed one of my filesystems was
read-only. In dmesg, I found:

BTRFS error (device dm-75): bdev /dev/mapper/lvm-brokenDisk errs: wr
0, rd 0, flush 1, corrupt 0, gen 0
BTRFS warning (device dm-75): chunk 13631488 missing 1 devices, max
tolerance is 0 for writable mount
BTRFS: error (device dm-75) in write_all_supers:4379: errno=-5 IO
failure (errors while submitting device barriers.)
BTRFS info (device dm-75: state E): forced readonly
BTRFS warning (device dm-75: state E): Skipping commit of aborted transaction.
BTRFS: error (device dm-75: state EA) in cleanup_transaction:1992:
errno=-5 IO failure

At first I suspected a btrfs error, but a scrub found no errors, and
it continued to be read-write on 5.10 kernels.

Here is my setup:

/dev/lvm/brokenDisk is a lvm-on-lvm volume. I have /dev/sd{a,b,c,d}
(of varying sizes) in a lower VG, which has three LVs, all raid1
volumes. Two of the volumes are further used as PV's for an upper VGs.
One of the upper VGs has no issues. The non-PV LV has no issue. The
remaining one, /dev/lowerVG/lvmPool, hosting nested LVM, is used as a
PV for VG "lvm", and has 3 volumes inside. Two of those volumes have
no issues (and are btrfs), but the last one is /dev/lvm/brokenDisk.
This volume is the only one that exhibits this behavior, so something
is special.

Or described as layers:
/dev/sd{a,b,c,d} => PV => VG "lowerVG"
/dev/lowerVG/single (RAID1 LV) => BTRFS, works fine
/dev/lowerVG/works (RAID1 LV) => PV => VG "workingUpper"
/dev/workingUpper/{a,b,c} => BTRFS, works fine
/dev/lowerVG/lvmPool (RAID1 LV) => PV => VG "lvm"
/dev/lvm/{a,b} => BTRFS, works fine
/dev/lvm/brokenDisk => BTRFS, Exhibits errors

After some investigation, here is what I've found:

1. This regression was introduced in 5.19. 5.18 and earlier kernels I
can keep this filesystem rw and everything works as expected, while
5.19.0 and later the filesystem is immediately ro on any write
attempt. I couldn't build rc1, but I did confirm rc2 already has this
regression.
2. Passing /dev/lvm/brokenDisk to a KVM VM as /dev/vdb with an
unaffected kernel inside the vm exhibits the ro barrier problem on
unaffected kernels.
3. Passing /dev/lowerVG/lvmPool to a KVM VM as /dev/vdb with an
affected kernel inside the VM and using LVM inside the VM exhibits
correct behavior (I can keep the filesystem rw, no barrier errors on
host or guest)
4. A discussion in IRC with BTRFS folks, and they think the BTRFS
filesystem is fine (btrfs check and btrfs scrub also agree)
5. The dmesg error can be delayed indefinitely by not writing to the
disk, or reading with noatime
6. This affects Debian, Ubuntu, NixOS, and Solus, so I'm fairly
certain it's distro-agnostic, and purely a kernel issue.
7. I can't reproduce this with other LVM-on-LVM setups, so I think the
asymmetric nature of the raid1 volume is potentially contributing
8. There are no new smart errors/failures on any of the disks, disks are healthy
9. I previously had raidintegrity=y and caching enabled. They didn't
affect the issue


#regzbot introduced v5.18..v5.19-rc2

Patrick
