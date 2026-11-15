Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=174.142.148.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794738955;
	b=0BEkfAc0l3xnu+cV5EojV7VqSX1qDqVvMJ18c+PEMY6XASJA38Iy4p0rbrxPJ0Zq6HsF
	 F80qTIcVj4cUYO+6mO1d+zQVV8j8KMNQjuFR9iZsBK299tWl8THG5B5ZJwY+fZXujcIS4
	 s83cdnjVDQHQVaXGIDHPdfGs/ohRUEht5lZd5fbIJSYsf1TpMu0xvQuq85xTRYraTR8uG
	 CmuBJV4I/PP84mXfrvccCv1tg9Wnk2yBb+7U+8PzZBC3M1IDfZOWjzaTuV6VX2bdmB/0e
	 /m0Ron6u5EpguRi4F5yWstZWh7vaj0tCxlzqqL+0I4/jjHJ9aU+628CvluDcohWZeaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794738955;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Nhl2t4L6TkxzXfInRClWp4avrcdnLduLOcL5y1yZrzU=;
	b=VgW6LFfyY1gowyOXcFdoyUi8o5OCv56/jlv54QM2KTkUrN08I9haEmpTZc9lCjcsS6+T
	 v8cSI/8alTWfKRC4yPfPbcHX7Lw0otxloVjgy+phgR+k0N2gk21XDw6yAUBVI+X3mzUjx
	 X99iRqOpHJDEUFuOneu6GODjPT1wdhg7BWRJl04YQyTgHTAC98YZ4JZLJngijauS5Eg5D
	 nWHO4tDJo4rjWG4zkV/FBTcJh5af0Gzqcrzmp5/gOgasnMpm1Og6+PvJsW738CNIj4WuT
	 95239FebVlKf/KYgSrdQOuMAftY3CcIrjoclnJUgOdo3++Gmh4s3/M+ZHhZWEB8pGBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=umail.furryterror.org;
	spf=pass smtp.mailfrom=drax.hungrycats.org;
	arc=none smtp.remote-ip=174.142.148.226
Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C816D606A31A
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 10:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C816D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id CE9EE1CD7E13; Sun, 15 Nov 2026 05:35:47 -0500 (EST)
Date: Sun, 15 Nov 2026 05:35:47 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Alexey Kuznetsov <axet@me.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [RFC PATCH 1/1] btrfs: track physical bad extents, fast-fail,
 persist, and relocate
Message-ID: <avmLAy52vfyJ5qze@hungrycats.org>
References: <20261112134703.38510-1-nondet@yandex.ru>
 <20261112134703.38510-2-nondet@yandex.ru>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112134703.38510-2-nondet@yandex.ru>

On Thu, Nov 12, 2026 at 08:47:03AM -0500, Alexey Kuznetsov wrote:
> Feedback wanted on: on-disk representation (device-tree items vs a
> dedicated tree vs extending RST), per-sector vs per-bio failure, whether
> the I/O path should record errors or only scrub/userspace, how to
> coordinate with device replace and balance, and whether an incompat bit
> is the right compatibility mechanism for a feature that changes read
> semantics.

Thanks for putting this together.  I'm not sure why btrfs needs to be
involved at all, though.

The btrfs error-handling model already assumes a drive that remaps bad
sectors in firmware.  A read hits a bad sector and gets EIO (or a csum
mismatch), btrfs reads another copy, and writes the good data back to
the failed location.  That write is where the drive moves the sector to
a spare.  From then on the LBA is good again, and the filesystem never
needs to know where the bad media is.  The model breaks only when the
drive can't remap anymore, because its spares are used up or because
its firmware won't do it.

So the missing piece is exactly a device that behaves like that firmware
when the real firmware doesn't.  Put stock btrfs on top of it and nothing
in btrfs has to change.  It also works for every other filesystem, swap,
and raw users, which an in-btrfs list can't do.

The patch shows how hard it is to do this inside the filesystem.  I had
a LLM read it against v6.12 (I haven't run it, because it has problems
too severe to be worth testing), and the mirror redirect, read fast-fail
and persistence all have problems that come from btrfs trying to remap
underneath itself.  The LLM found:

  - The write redirect in btrfs_map_block() tests the bad list against
    *length, which at that point is the distance to the end of the
    chunk.  For RAID1/RAID1C3/RAID1C4/DUP, one confirmed sector diverts
    every write below it in the chunk.  The read check uses the real
    bio length, so the diverted copy keeps old data that reads can
    still reach.  On nodatasum files that's stale data returned
    without an error.  The filesystem still believes those blocks are
    mirrored.

  - btrfs_map_repair_block() goes through the same redirect, so repair
    writes land on the healthy copy, and the "skip repair write" checks
    never see the bad device.

  - Fast-fail returns true after a bio split, so the remainder of the
    bbio is never submitted and the reader hangs.  Every fast-fail also
    increments read_io_errs without doing any I/O.

  - Device replace reuses the devid, so the new disk inherits the old
    disk's bad ranges at the next mount.  The incompat bit is cleared
    when one device's list empties, even if other devices still have
    ranges.

  - The existing test doesn't detect the bugs.  It only writes at the
    bad offset, and it compares the file right after sync, so it reads
    the page cache rather than either disk copy.

  - There are inaccuracies on free space tracking for metadata (with
    remapped blocks removed) that can cause a filesystem abort.

  - The LLM found more issues, but I'll stop here.

While these problems could be fixed, none of these problems exist if
the remapping happens below the filesystem and supports existing btrfs
write error handling.

Currently only CMR spinning drives support badblocks-style LBA-based
remap lists.  Other storage types don't have stable LBA-to-physical
mappings, and a badblock-style remap list doesn't work on these devices.
Users with healthy CMR drives that have not exhausted their remap sectors
also gain nothing from this patch.  By doing the sector remapping in
the dm layer, the runtime cost is paid only by those who use the layer.

What I'd want from a dm-quarantine kernel target:

The target detects failures on the lower device itself, and keeps the
remap table on the device.  There are two kinds of failure to handle,
because a drive with no spares left often accepts the write and fails
on the read:

  - A write fails on the lower device: allocate a reserve block, write
    the data there, add the mapping, and complete the bio successfully.

  - A read fails on the lower device: mark the block pending and return
    EIO.  The next write to a pending block goes straight to a new
    reserve block.  A later successful read of a pending block removes
    it from the pending list, since the error was never confirmed.

That's the same thing drives do with their pending sector list, and with
btrfs on top, the next write is the repair write from the good copy.

Because a block is only remapped when it is written, the reserve copy
always holds data the filesystem wrote.  That avoids the problem of
remapping an in-use sector to a reserve block full of garbage, and
nothing needs to be salvaged first.

The remap unit should be the lower device's logical block size, so
there's never a read-modify-write through a bad sector.

The table has to be crash-consistent with the data.  A remapped write must
not be reported durable before its mapping is.  Committing table changes
on FLUSH/FUA, the way dm-thin and dm-cache do with dm-persistent-data,
gives the right semantics.  Keep two copies of the table so that a bad
sector under it isn't fatal.

Reserve allocations never move.  New defects should take the next
free reserve block, and existing mappings stay put.  The current dmq
build_table() doesn't do this.  It assigns reserve offsets in sorted
order every time the table is rebuilt, and the map file doesn't record
them, so adding a bad range below an existing one silently points every
later remap at different reserve sectors.  That needs fixing even in
the userspace-only dm-linear version.

The target's header goes at the start of the lower device, with the
reserved sectors at the end, making the upper device shorter than
the lower device by the size of the reserved area.  The filesystem's
superblock locations are remapped like bad sectors, with the superblocks
copied to the upper device, and zeroed out on the lower device.  Then udev
and btrfs device scan find the filesystem only on the dm device and never
through the raw device, so they won't bypass the remap.  The current dmq
doesn't hide the lower device's superblocks.  The same trick converts
an existing filesystem in place, as discussed in the GitHub issue.

Modern drives ship with tens of thousands of spare sectors.  Anyone who
wants to keep using a drive whose own remap table is full has already
grown more defects than that, so a reasonable default reserve size is
about 256 MiB.

When the remap table is full, failing the write with EIO is the only
option.  That's what drive firmware does too.  It's not harmless on
btrfs: when a write error hits an ordered extent and no write to a
mirror or parity stripe succeeded, the ordered extent is silently
deleted, and data that write(2) already reported as written is lost.
The difference from firmware is that a kernel module can add more
reserve.  Shrink the upper device and take more space from the top end
of the lower device, so the reserve area grows downward.  The target
should raise an event when free reserve drops below a threshold, like
dm-thin's low_water_mark, so userspace can shrink the filesystem and
extend the reserve before the table fills.

The table should be a log that userspace can read and act on, not just
a private mapping.  Every remap, pending entry and failure is recorded,
and the admin can intervene: inspect the entries, clear a pending
block, force a remap ahead of time from a badblocks scan, or retire a
remap.  Counters for remapped, pending and failed blocks cover the
summary.

btrfs scrub does need a different approach to error reporting, but
not the one in the patch.  Scrub can't write errors to the device
tree on a read-only filesystem, especially on a filesystem that goes
read-only because of its write errors.  dmesg isn't a substitute either:
it's rate-limited, so a scratch on the disk yields only a fraction
of the affected files per scrub run.  I outlined another method in
btrfs-progs#836 [1]: btrfs collects error events (physical address, error
type, repair result, block type) in ring buffers that userspace fetches
through a sysfs file, with blocking reads so a daemon can listen all
the time.  Userspace resolves the addresses to files, and can feed the
same events into the dm target's bad block remapping table.  Nothing is
written to the filesystem, so it works on a read-only mount, and it
catches errors outside of scrub too.  If the buffer overruns, the reader
should be told how many events were lost, so it knows to scrub again.

dm-quarantine as posted is mostly dm-linear plus dm-error with runtime
messages, and the messages are a problem.  dmq reloads it as suspend,
load an empty table, resume, then send the ranges, so for a moment a
mounted filesystem sees no remaps.  Messages are fine as the
intervention interface, as long as they change the on-device log
rather than a table that only exists until the next reload.

So my suggestion is to drop the btrfs patch, fix at least the two
dmq issues above for the dm-linear version, and put the effort into a
remapping target with an on-device table.

[1] https://github.com/kdave/btrfs-progs/issues/836
