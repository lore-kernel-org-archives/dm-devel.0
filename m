Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711744;
	b=RrjkbZagHTZqX1fRi2gSFAQL/Jkp0MNWUBjuymGC5OwbwWIgvCbtGhsDIsVUA+eVXhXR
	 sUV3KLscFJPFGfehJPI34gb/8LVLSNlsBgm/8WkxeWA8sr1IQkj2gJxrYKruZk4SYZRu2
	 H+wzNaifARsr8E7hYn+nrur59AavVRdLpsae9aEEaKO43uNyR9n6tBqJNj3T08JQfOFli
	 NJy8mMrBLRPV+iCj3NjsIt+nmsSnOmZMugyYEize0HD9hhIwUW4orna9sMYpx30E28Ykr
	 tNo+Pd6tb+QRniQgLrmJ+DM3zlAY9YoSAVfRMC3iRk46Fz3JiuF2AefekSpXLpwalMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711744;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GH6ICF2aSqksQ7d29gPerX4odXCWIgYHgs6cp06vt5c=;
	b=WLFYIyRfw2N965T8XLoP3vZUGiXBTbagUMy5O4soXRDeuWk9xckci3ii7UJoJjXCUK0e
	 KmJXqy1RYytiJv1hfeyegHxEOrYoNYMXyyJ/6UblrBQwnWKwjUdycSvNMsB1NFDXAmXEb
	 YrZga91MPU6ccvcy0CI9KeoTXmXDsk4W4AGfbTO9N+CxFfWNFWOeJMUhJvLOOnjALcqlb
	 4wRVFy0aBK0KSyhhZjeHZmOkWwPmcXRT8dEcKOre3/HAAxFz1nbkbebnzIsJCpHI97fHx
	 wWe0vDeyFOs+6LcpDzkFjNAINMtdBcvhNfSJLMtWEre1CBhDZjCJ2OL8zrRZsMZmd3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pnq+RnjX;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C8C606A31C
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 16:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4C8C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pnq+RnjX
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2f05b465cd1so39536505ad.3
        for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 08:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795711743; x=1796316543; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GH6ICF2aSqksQ7d29gPerX4odXCWIgYHgs6cp06vt5c=;
        b=pnq+RnjXryZJf7ITD8P/l+il6FF9XpkXE+vpHax9ZrJUMmUIrwN7BvBPe+S7zZQFe6
         cly6B8xu3AHhT2/7gLELYfH+X+yT60lQh0lt9gDjZUOjbE3Qn6BAoD0rxXRG3ZsC1fab
         e9fDG9LvoXtJxMrAVso3JZUeRwCoaVg8Gmr1HvN/RPY4lLwUmI+EQYyr3p+nE2ekINbF
         /aPNqaikn+gIKg7rPT+0bXgs9AldN8FxQARWrA6DCC9BUPLyOkZ1X0gV4+tIJrPgeOqX
         4v6D+UgtWk2getufABMLxmqiDMx3o0oZajLwgdIXYL/jkMq3/q202uFqDZMPM5dWtmz9
         jYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795711743; x=1796316543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GH6ICF2aSqksQ7d29gPerX4odXCWIgYHgs6cp06vt5c=;
        b=bbBIikamvTUrZ28/2jAnCTDVcNcFdTVkdlXZaj/m57FW3dWd8DFgJWmc1H/whflvFY
         JAjmzyNF0go8GzHz3SV4Lz87fZ4i3XWo7ojnLCVweMaRwvSaWm1PUO1maRDyPFUX2AOs
         PcgKJ4NlQl7sT+5yIDxPyoxqL1Bu0iRpUpXYw3VTcsp+abRt0D6neSlzwb3g0i/bQs06
         XXh6zhJp7shqpaDl21UY6gxn9PLTmqstA0uFscu3RHiIMN206NpTonCL29vNKz3o2awS
         lkTSsqNDqJMw8dhtKSQIYnfbhU+FJvBNNTGrDhZBeRuhDHTZ3lZV7cQ2PoH9ztG9BRqr
         Qolg==
X-Forwarded-Encrypted: i=1; AL+hErEEihOCI3/cCXYWpqSIGxxyl0/p1OjU/ppmLexXzLLg3F3HVokHg6F69p8V0Spb4pJbC/guT03xHA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9cHxKfOflLO28pDMplyEGnoqbDgyRsFlU75Ppet0cAAsxCo3se
	C0ysue5Gw31rfEN6flfJLE7mRUqbH+4eFEI3Jbkj9zGc+2eYq75Opn7D
X-Gm-Gg: AZFdTZckXWueOc149U7HuWj6uNadpgvYZ9vMzhJBPtsHV5Fxn7Vh9/uDrcEB5tcTP4g
	vXCX7SIroEGbGPPsOColp0okfXYYdHg0Lm4PYCEHTAM7bw580Var1SiFoLxJ1zLamQfiNoZuPvX
	1ZTXyUVnhT6480N2Y/J4PXYPr7uy7izVs1wwPCoMbYw44AcG/qoXv3Tu/1uEaN7HgDyXcmHNwrT
	m8J8/rmcQ7kdJrUEqqeoFrEu1LEotDzMSwhe2PsPkkJLydpUx895SiA1fV2vRS0LV6zLN6RAyyU
	a5KQUgwa8Yxh0rPsLP/ZXewJ9KoqxkLwPEneNwi2vmKg9QJWjf0r7+aexv2WDoxyOtrwBPHc1Jv
	xn3xUd4SA+QK6pdQHGkXqTigUYHqi/pz/5qBv/Kgwh0ANZpSJV1CF3a8E4ZPGXXpQXOgG966+SE
	Qp9mvQ92izVqTfTVeV1BqypAWo9wwIx6Ve/r1WE9ncX+u6QErN7mzSzVuZMV28WoB9xAsDSOCun
	5Cjf9h915qD1yxT/niMlF0yLQTPZHyezLGaxokhd84HLPLU3TVFGvWNlQiYdr6TXbUwPuASJ0z1
	kDtqAUddcRsZIEckq/b7FcdQ1N9uxld0in7lQBWLK1+8Ae9SSQP2aAZhgY/KUXORMf+FLY3nGo1
	QnKRl9RA3
X-Received: by 2002:a17:903:2c50:b0:2e9:6972:54d7 with SMTP id d9443c01a7336-2f03f17e712mr186944285ad.52.1795711742920;
        Thu, 26 Nov 2026 08:49:02 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0dcbe3sm106734335ad.28.2026.11.26.08.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:49:02 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: mpatocka@redhat.com
Cc: agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	zkabelac@redhat.com,
	okozina@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject
Date: Fri, 27 Nov 2026 00:48:58 +0800
Message-ID: <20261126164858.531979-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5e21caf9-5aaf-8007-0e71-598d7828697e@redhat.com>
References: <5e21caf9-5aaf-8007-0e71-598d7828697e@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 23 Nov 2026, Mikulas Patocka wrote:
> Please, show some numbers - how much does this patchset improve Android
> boot time (if you are prefetching blocks that will be needed at boot) or
> application load time?

Here are numbers from three stock phones (UFS flagship, GKI 6.18;
UFS 6.12; eMMC 6.6), 3 cold boots each.  Method: the sysfs block
stats are cumulative since kernel start, and verity hash reads
bypass the dm-verity queue and land on the underlying device, so
"hash reads = underlying.sectors - verity.sectors" read at
boot_completed gives the whole boot.  A 4K hash block covers 128
4K data blocks, so the minimum hash traffic for the data actually
read is data/128 (less with ignore_zero_blocks, which skips zero
blocks -- the real minimum is lower, so the amplification ratios
below are conservative).

The hash blocks are re-read under boot memory pressure, because the
256 KiB module-wide floor cannot hold any large partition's tree:

  device            kernel   hash read   minimum   amplification
  UFS flagship       12.1s     48.4 MB   10.8 MB        4.5x
  UFS 6.12           14.8s     31.1 MB    7.6 MB        4.1x
  eMMC mid-range     42.4s     17.7 MB    6.6 MB        2.7x

On the eMMC phone every hash read is a synchronous dependency of a
data read; system_ext alone re-reads its tree 5.5x.

With the patchset (v5[1]) and a small fs_mgr change -- size each
verity client's retain target to its hash tree, and send
"prefetch_hash" once the device is up, off the critical path --
the same phone, 3 cold boots each:

                           baseline      patched
  kernel boot time           42.36s       41.97s
  hash read at boot         17.7 MB      14.8 MB

The composition changes: the baseline's excess over the needed
minimum is pure re-reads; with the per-client retain targets every
device's total stays within its tree size, and the re-read
amplification is gone.  The prefetch itself does not move boot
time -- the win it provides is elsewhere.

The boot case is one user; the other is application launch.
Android reads verified data mostly through erofs on dm-verity, and
preloading the files an app will need means readahead on those
volumes.  That readahead must stay modest -- aggressive preloading
competes with the application's own I/O -- which is what makes
prefetching the hash blocks the right granularity: the hash
stream is a small fraction of the data volume, yet without it
every block read pays an extra hash read, the hash reads occupy
the verify kworkers, and on low-end devices the verity kworker
CPU becomes visible (a patch has been proposed to expose the
verify workqueue for tuning[2] for exactly this reason).
Prefetching the hash blocks in advance, in batches, removes the
per-block read and the kworker storm.  The trees on our devices
run 80+ MB, so caching them entirely is real pressure on
low-memory phones -- which is the per-device tuning problem the
retain target and the retain_bytes message expose.

> Would prefetching with the readahead() syscall be better? (it would
> prefetch data down to the page cache, so I presume it would be more
> efficient)

The hash reads are submitted as bios and do not consult the block
device's page cache, so readahead() on the hash device warms a
cache that verity never reads through.  The test build ships
AOSP's libprefetch (posix_fadvise-based, page-cache level) and it
cannot reach dm-bufio whether enabled or not.

The other direction -- reading the data files so that their hash
blocks come up as a side effect -- is not precise either: the
verified volumes are erofs filesystems, one 4K hash block covers
512 KB of data across file boundaries, and userspace cannot know
which files map to the hash blocks it will need.  Making sure the
needed hash blocks are resident that way means reading a large
amount of data, and for application launch that volume is not
acceptable.  The message reads exactly the hash blocks and
nothing else.

> Back in the era of mechanical disks, there used to be a daemon that
> prefetched blocks to improve boot time. With SSDs, the idea was
> abandoned because it didn't provide any advantage. Are you
> implementing something like this?

No: this is not sequential-throughput streaming.  Each 4K data read
must first fetch and verify its hash block, and pressure eviction
makes it fetch it again; the numbers above are that dependency and
those re-reads, which a faster disk reduces but does not remove.

> Maybe we could add an upcall that returns the last used time of the
> oldest object in a given shrinker, select the shrinker with the oldest
> object and shrink from it? Would this be feasible?

For our scenario, picking the client with the oldest buffer would
be an improvement over the current count-only order.  But the
oldest-buffer timestamp alone can misjudge: a client that is mostly
hot with a few long-idle buffers would be selected first, and I
have not found a single metric that weighs a client's overall
temperature correctly.

The precise version would be one LRU holding every dm-buffer
regardless of client.  That has two problems: the lock contention
of a single list shared by all clients, and the loss of any
per-client priority -- there would be no way to protect the clients
whose buffers matter most while reclaiming the rest.  That
protection is exactly what the per-client retain floor provides,
which is why I see the two as complementary rather than
alternatives: the LRU would order eviction, the floor would bound
it.

> Maybe you need to tune /proc/sys/vm/min_free_kbytes if the kernel is
> not shrinking memory fast enough.

min_free_kbytes is a global reserve; the need here is per-device
targeting, not reclaim latency.

To summarize where this leaves the series: prefetch_hash does not
move boot time on its own, but the retain_bytes changes measurably
remove the re-read amplification (2.7x on this device, 4.5x on the
flagship).  If you have reservations about prefetch_hash and
drop_hash, would you consider taking the retain_bytes-related
patches first (per-client target, sizing from the hash area, the
retain_bytes message -- patches 2-4 of v5) and leaving the
prefetch/drop lifecycle messages for a follow-up discussion?

[1] https://lore.kernel.org/all/20261121171934.3847617-2-yangyongpeng.storage@gmail.com/
[2] https://lore.kernel.org/all/20261116223301.1706170-1-sarthakkukreti@google.com/

Thanks for the review,
Yongpeng
