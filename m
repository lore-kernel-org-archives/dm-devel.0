Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794843159;
	b=ZtsHscEdGPmAeBRsFukDcvLJCD2T8J3epoxhFfFRyDUWesP1BB0VsgiHECJf1yOVFmQ5
	 djg4hAYPkmccX1dnAEqBW+2gKMDpFTzaWAaoEyAyCIixj11eWphrxPijNgWOc1DdBEsnl
	 ReJw4RazicWgj719Fi5xi4HtZJlV9XouFUEKHgdiju0xsFgfMs++/F37MRUV0OR5a8IjR
	 MU4SRXuvcV3EyHRsrLAvL9VlBFdYTyn3DkzE81i22QGwV9MtS3whh5Vh1iDD/xAz7eFoO
	 59Sg4MWs10uR5q6ocwmPPdLga/7QMBG+pQIELZCKYYgrK68w/mJIOVI85FQr9FG6aKw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794843159;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
	b=D9qoyCH9JKc+CzHCRLxUdBsmZYDPkZdC+H3Snkt5gXKmb5xDqXXtnZ7OJp4t90i6YmmO
	 ti0fBf0iaG54OGZpen9INoiIv3jvqNoH9hQPwDK/g+cPZW5U+s+qJjVhoN3CPsBr14ybh
	 7f2VqRq8mv4hEjZekpBy2ETj/ZBdGE0jUM3KVt0HKYlXbEnexrVPgf3JLFQ5sHbhXxBal
	 APMIP6ioCD4YKR8kukMqypMh21JUtr9921esvtNE5LP0K2f6jFuhLtXSZn2efujZ/gGjZ
	 7gzpTaqifvpYsrlkSWUKMaPQhCSyi6gZn8wJFkIJfaTHRi0B5sdiUSW7CkM/k2qOUgA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SbGILGhy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C9F606A329
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 15:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08C9F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SbGILGhy
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91f2b826fe9so36874866d6.1
        for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 07:32:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794843158; cv=none;
        d=google.com; s=arc-20260327;
        b=k4Jh682Nh1Mbwy06zRa+xiD3NQI4gXz6u8xTan4AITxRyGeiX5g8lBF/UmgOgDlJTY
         Xjph5CAzhagkSxZtttXdQ6kfFWdRTa4MBwCaJf/diOYxK1FmG9KKt7n4DHjliHYtXg5N
         sTkfOg/Tk13qxOwqec+0U6sfXS9I2d1URk2RDTZAhSr4pYeSxQNZ0Ptc5M+1w+orrb+0
         Ib03XeebsnF35P0YTcpCWX9fSWkPFzzndokb1Zl5kNqOuUGx3B5YEKY7c8qNka7tCuef
         aq5A3bm25aYrLBJFJ5GkU0RDgRyb51FwKF3ZNaTP31ShES6v1cHllxlKlsG5+AV5UtEH
         8Y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
        fh=lGiesCu+Ae4Q4vHEhtBhBBGQk20kdCSYzDzUTxYA+yY=;
        b=bNsmAXe2mm2/cY8BIMb7bpWMFD3ojVflMg7rl2rclGq/3I7olEu/f9wQt45DE/5j0V
         ecDKmryAK3+cW+VterArkVcgBy+Byke+llKpnXvCLk3u60GbbO3aSDBSnNCJ9Rley8pA
         i0cg6FaeM5qdA0mteua8zzkPn6G9sVA2awrWIHRU111v2xFKwFjwKoFUnSw7isnb3g1H
         umkPP76wU0PfLjPGzau+Yxxtswi09wErFwZzpzzOYBcxbQfv9vDyHo2zOU9W7AkqAfmF
         edHV06HPgfQmJ+74uvz/0icS/ImYY2E61EWFIQGqHUuV0ktqLvkhJwjGlQagtrdE7Dn5
         DOcg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794843158; x=1795447958; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
        b=SbGILGhyjFNMQ/01rK89NDExrsV/7P1lupnSVZ82QXaF+nzwCipc5U+YuZe4+IV1+R
         4rwgVOyG1AOxMsLMEWNcLf8HXVK5cERmvb9s2Ho/Gk/v6p+HLlyMTwAx08nEcZs4yfHW
         vVb6lOU3E/Eeu0vpk4UTumy0J92g4gtuwdts0CweybRHTaXY3n+OtOB1VS+MGCSWlA/2
         k2ws6l7Ebf7Xb+OqBZBpW7hTaLPbc5/SWGQQeDS4mGCvMtNJa4BSYLfVKv3JoCa8DQyH
         2J9WrfrhUrevyCdUQk8YRQjNA+Mt+DAe5u49hc7ZWUDlZOaVYFRXCcSbntmzWYSQQUQV
         ntPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794843158; x=1795447958;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UZfjUUdOGV4n+muBluIHHduUrTQ0oRHWELrphw0Vc24=;
        b=Y3NN0Br27qub8yW4W9fWjn3uuDCWI6GuhTmlhJbswi1jBYQThm7rBVCZBjgYHR/fvC
         wZ+Pq8BUNCItPIWrxJk+PRxzH9+QpJSDm750omU9ibvg3uawhzxnoYMGZK9j1IG1fB62
         WQ6VTcCGxgEfWYXRuuQMd44C/2XUd/vR7NPc1/Yvt5dOmWV2KScT5WBXs4yet+y+hRzJ
         1TacjUV9qF/Wd8+DlYh6c85eJVPh7RGwrYhBwBIDGUzoTJzBo87AsyXYmUQ3374DaWUy
         wWntz4f52R9SOX4P2lR1KiC0Zg5hUTU6zAC5d2k2Ofpw/fzZpE4KZ1Wp4GI5cgAPnpjV
         zXGw==
X-Forwarded-Encrypted: i=1; AL+hErGFjEWk1KxPtj+3DXru2E0ndO94pATBjYFMRM+l43t6m3ssoZko3xR+dFWxyjUG6rWUnv2vE8hJeg==@lists.linux.dev
X-Gm-Message-State: APuU4Z81v4xISEbi5ZtNwF4KF3UgnbRg1rQ/Tbb6vClqvPwsuaw6S0WL
	saHrs0PWgeKuaKLjZHraypEGWApwz+dtXlGgonz8O6//g50Mm/ykm9C5DaCn4d/1yOuxeU6/uL2
	xAHg6cHgZCW16/E/qd6q1iEQqbex/Ixg=
X-Gm-Gg: AZFdTZdr+4MwSqVhsovC7eCIOl5g1RkJCeiQCAuBhJ71jA22PLNcLHC6PrIrRUzUtFg
	dXpJlah+4w5YyoOFzJkxHx8Sy+9kQluS2CI/XynH7wBuniWwOGoswJR9kzw7g2ZoBI1kDA0h5+9
	mzgZ5UO+MZ26rICIqx0UqeS92UZUHO21XIO5mZ1svctm6xc3aI3nw1EhwKK4X/7V9D+pcArYAUB
	etJ3iA4uGgW/3YQDQUbcZ61p8+rbjn7etVqqCZ4FOF5lpw1WuhCDoLG/qmNt5qs0zuWu+OjBlq8
	jvCjpXe8h0UmKKqxcm01oG2Q0wWHjHl0iRoByr1PfSZRppqCC9XQ/Rlx9RcZWV7MekcUtVLQb0k
	bfORFIVnjvrhctT+d4tOmbdViSEjLk14lPyryowXCtlxl/jIx4FSK2RBWJOONvcQAm1DFpkYqTU
	cw7XA=
X-Received: by 2002:a05:6214:c6f:b0:91c:133d:4916 with SMTP id
 6a1803df08f44-91f24258d3bmr175963246d6.57.1794843157790; Mon, 16 Nov 2026
 07:32:37 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261112134703.38510-1-nondet@yandex.ru> <20261112134703.38510-2-nondet@yandex.ru>
 <avmLAy52vfyJ5qze@hungrycats.org>
In-Reply-To: <avmLAy52vfyJ5qze@hungrycats.org>
From: Alexey Kuznetsov <kuznetsov.alexey@gmail.com>
Date: Mon, 16 Nov 2026 15:31:59 +0000
X-Gm-Features: Aa3M54oeRpvY83d0nLazjOVqW7eXFFClTJV0uMrGDZK8xguOz0qojD8xIBRH0QU
Message-ID: <CAO1Zr+q5hhK5oPJtQu8v3oh=-AfB9FuPF2VQA=zpSGA0afB-FQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] btrfs: track physical bad extents, fast-fail,
 persist, and relocate
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Zygo,

Thanks for the detailed review. It changed the design, not just the patch.

I agree with the core point: physical bad-sector handling belongs below the
filesystem. A drive with spare sectors already does the useful part in
firmware: the filesystem sees EIO or a checksum mismatch, retries another
copy, and rewrites the good data to the failed LBA. That rewrite is what makes
the drive move the sector to a spare. We only need a block-layer replacement
when the drive can no longer remap, because the spares are exhausted or the
firmware refuses.

I also accept the consequences you spelled out: the remap unit has to be the
lower device's logical block size; reserve allocations must never move; and
the table has to be crash-consistent with the data, with FLUSH/FUA committing
table changes and two copies protecting the metadata. btrfs should not
intercept physical I/O for this.

Verified defects
----------------

I checked each point against 6.12 and I am not disputing any of them:

- the write redirect used the chunk/map length, not the bio length;
- repair writes went through the redirect as well;
- fast-fail after a split dropped the remainder;
- fast-fail inflated read_io_errs without doing I/O;
- device replace reused the old devid, so persisted ranges followed it;
- the incompat bit was cleared when one device's list emptied, not when the
  filesystem had no ranges left;
- the mirror-collapse test could pass from the page cache;
- dmq renumbered reserve offsets on every rebuild;
- dmq reloaded the table and only then installed the ranges, leaving a window
  with no remaps.

The last two are already fixed in the userspace side. The map schema now
stores a per-range reserve_start and the allocator cursor; reconciliation
keeps existing offsets and only allocates new gaps. Live updates diff the
target's range list and send incremental add_bad/remove_bad messages, so a
range-only change does not reload the table at all. Geometry changes are
refused while the mapped device is mounted. The userspace suite covers
add-below, remove-middle, idempotent re-apply, split boundaries,
poison-to-redirect, and reserve exhaustion.

Status of the btrfs patch
-------------------------

The btrfs patch is withdrawn from upstream consideration and kept as an
experiment in the branch. I will not resend it and I am not preparing a
btrfs v2. Scrub reporting and targeted relocation may still be useful, but as
filesystem features that feed the block layer, not as I/O interception.

Proposed dm-first staging
-------------------------

I am not claiming crash-safe redirect yet. For a first submission I would
like the target to do detection, keep a pending list, and poison confirmed
ranges (return EIO, never stale or zero data). The volatile table would be
restored by userspace before mount, but nothing would move data to a reserve,
so no acknowledged write can outlive a lost mapping. Redirect would arrive
with the persistent log: a small self-checksummed area at the end of the
device, two copies, a generation number, and the mapping committed before the
remapped write is reported durable.

Does that split make sense as a first submission, or would you rather see
redirect and the persistent table in one series?

Two smaller decisions:

- Geometry. I plan to require the lower device to be a partition by default.
  Whole-disk ownership, including LBA 0, becomes an explicit mode with a
  documented recovery path (initramfs or rescue media), because the target
  has to own the partition table and the boot loader's sectors too. Is the
  partition requirement reasonable, or is whole-disk the more useful default?
- Reserve. User-specified size with a documented default, not a hardcoded
  constant; new defects take the next free block and existing mappings never
  move. Any preference on the default or on whether the pool may grow?

I am rejecting zoned-device support for v1.

I will post the dm design and the on-disk format as a separate RFC once the
format and crash-ordering rules are written down. If you are willing to look
at the format before there is code, that is the review that would save the
most time.

Thanks again,
Alexey
