Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6B549BD77
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 11:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163592; cv=none; b=L6FVQLQbWYHGNtZXsK868flRMaRj8Q81Ria8kX8i2dHN3slyQhBm2YEh87sgfTCQE4ovwH62bt/mqz8/X7lqCZIHV2K9iWZUTiJ0jtvIB9Ka05N82rzkwswHwfCOUeNVaSMBXjE/CtyM0apvgj9kwiXMSQz0R5FrcZTA1O/pMjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163592; c=relaxed/simple;
	bh=NcuGwx6nAU4jknO4kfaOEdRYLrOWx/RlJvZRS0+ffmc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UH/bbWmoZK+S65R58UBmQ2zsPG4MURZ/9/bWd+cWPskvD8uAxp30hFlgWuMD6s6Gy/XoTQKggZAbOxeFJWDqEIv27SgQX8FeXOPhtASd6Fnk1uUlmJu8fkKn7cYEErjKRRWQjHhdpLD9PInWsJbYHXPwYdBTZ2PwJch35L8mpoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F4U6jrMV; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F4U6jrMV"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49c5a927a1fso264625e9.2
        for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 04:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790163583; x=1790768383; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ptqEbP9k/k599RgBfEHuSUGuglS6CduFjL/USF1vB6g=;
        b=F4U6jrMVmcXJVDKSLcHvyaPGOutJnxRXMWy7OHIit8KyN4pg1f9JXkJX4vIsarLMVB
         bgFwgjwH0MGHUUvnde/JcRBil+WHECMo/oQsiv5x33/0eLF8teHkeCXZ35Uo6eVYBsxu
         DPEbzmpe+AnMjax2SeNZoDmK4dpHpuY8bORAqJsYUZUzn04J/JYF+COmO5JQ2gXcmDKv
         XTMkhRhOt+zDOttCEVs7Rb033cpjrOv9la/F0T5EG9PQr/DAvX7xzBQELTAzgqOUNW8k
         TBo4AJHOO9RvwSi6km38HPlyjdFfQYuSzxWzq0iS465/Bh8OotDzU2Dnl/SATv8t4SZt
         GvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790163583; x=1790768383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ptqEbP9k/k599RgBfEHuSUGuglS6CduFjL/USF1vB6g=;
        b=dkt2sEiYcRsqcPDhNMPccZlmXHEqSFaFwYdTdTSVbQyheNE+h6f3Yhqt6SPD7KePlp
         lnx9/a/FfHaaUS5xWgyn8knSNfaAgBPTZVh5NMbVsK2A/d5xZgVKoEXwZHH4ug73I+OR
         8jB6RgSzGswIqkOUCRJkYlu+di3Ax6QUQjsadGYFfaaeRzLPlKS7yIfd/JahcdXfQpbZ
         nl+2G5jyvDtRyAG47RZIYrJbuq5hYsbrqEl39agyzRJrqQK0vW9vF5kQJyXKhtZE52It
         GRaSW5lKD9Oz2e8j5NmLLzJD48ljmWUxFkW4cTNNYWpYh3va3k31WN6lrTifhn0Y7gcJ
         0A+g==
X-Forwarded-Encrypted: i=1; AKwUvBxkHJpz5jv+gGgcfPLBQYfONw1MIBGZ2OcX9/h393xeGbLUkUky4G6MPSmME5SlQ4zfFju0EH/v/w==@lists.linux.dev
X-Gm-Message-State: AFuF++nf111B/AQ7ygSvWm0nUOnGcZKW03TV9tjj8FHN6Sfj+fiHCGw4
	ZFxjWdSFq8gkSnGXG7vrHauD8aU40IZBcCCrEyH8MpYyvZ6OeEroO2rG
X-Gm-Gg: AYBFou14qvysUMVap/uwrz30gfCMRDFfI47NUo4MZJzmBjASGEqDGAZnGjMFlzTFKDN
	Zl34RYAM8pv08WMKEyy1aDRJbwfmSVi7nKBekb80QRXjr4qBM+FscRQLaIvgd9HZeCi3dekMwX6
	jeDapzCTheKRrky2pN0rmeUwLp9/UFgA7Rvv0nKp4JwmBPTk7hPw2VXZo45iWM5IGntaPPiDXPB
	8/Y/6gke5f7AMjHYql19Wc9cTsQXzq6YaX8pKpdbGatLlNJAzg9lJhj75ATSO+e1vpiu3eea/sR
	lI0IZoov6E9BdV29wGxQuYGtZTbtGhUEMzUo5mLfWPOQeR4vX8oOsgWH+o5QQW8LH0Lp8Jme0WB
	PGRfblVYIaycwD4DrUOcjfSGm+07c7xY3vsFFpo6r0s811F4yAWrYn7RvUz5ejwBJNfmAZz+kwP
	0ZolKzpMSp7mYfzXl7qfN9BHKlwnASOfNAvf21C7pftX7AM8k8ZUPaD/7d77QVSpzAp8cQHfmBd
	zgLd/VspuOeJSm57XA=
X-Received: by 2002:a05:600c:4fcc:b0:49c:f9b8:bae0 with SMTP id 5b1f17b1804b1-49fdf13cf49mr30698975e9.2.1790163583288;
        Wed, 23 Sep 2026 04:39:43 -0700 (PDT)
Received: from L-P-ITAIH2-L-RF.rf.local ([193.169.70.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18093csm81679515e9.3.2026.09.23.04.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 04:39:42 -0700 (PDT)
From: Itai Handler <itai.handler@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Milan Broz <gmazyland@gmail.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to PAGE_SIZE
Date: Wed, 23 Sep 2026 14:39:03 +0300
Message-Id: <20260923113903.901245-1-itai.handler@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <9a6c20da-4da9-4a8d-a6d4-f18900228bf6@redhat.com>
References: <20260922120330.127262-1-itai.handler@gmail.com> <20260922213457.GA3536981@google.com> <CAFpOueSjekxhjEosQGiZ9BiDh5tFOqBPX5w_2PVsrcN6pO+dHw@mail.gmail.com> <9a6c20da-4da9-4a8d-a6d4-f18900228bf6@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 23 Sep 2026, Mikulas Patocka wrote:
> There is one important problem - the SSDs and HDDs today have 4k hardware
> sector size.
>
> If you use 64k encryption sectors, the disk may write only a part of the
> 64k sector during power failure. When you attempt to read and decrypt such
> a sector, you get garbage.
>
> This is not a problem for XTS or ECB, but it is problem for CBC and most
> other encryption modes. So, the patch should reject using larger sectors
> with cipher modes other than XTS and ECB.

The mechanism is real and I am not disputing it. What I would like to
put to you is that it is not new, that this patch does not change it,
and that documenting it fits what dm-crypt already does better than a
new restriction would.

A torn sector is possible today
-------------------------------

Consumer NVMe are generally shipped with 512-byte logical blocks and
stay that way in use. Installing Linux does not change it: partitioning
and mkfs work inside the logical blocks the drive already exposes.
Changing the block size is a separate low-level operation - nvme format
with a different LBA format - which is destructive, which no installer
performs, and which a drive may not offer at all.

The machine I am writing from is one: a Samsung PM981a carrying a
complete Ubuntu install - GPT, EFI partition, /boot, and the rest of the
drive as LUKS over dm-crypt with LVM and ext4 on top - and it still
reports logical_block_size = physical_block_size = 512, with no
atomic_write_* attributes at all. The dm-crypt device on it reports a
512-byte logical block too.

The atomic write unit follows that format.
nvme_configure_atomic_write() takes it from NAWUPF, and where the
namespace does not advertise one the unit is a single logical block;
controller-level AWUPF is explicitly ignored. So on that drive the
guaranteed atomic unit is 512 bytes, not 4096.

Which means dm-crypt already permits, and has permitted for as long as
sector_size has existed, exactly the situation the restriction is meant
to prevent: a 4096-byte encryption sector spans eight device writes
there, with seven places to tear, in any cipher mode including CBC.

What this patch changes is the maximum size. It does not change what
any mode does when a sector is torn, and it does not make a torn sector
possible where it was not before.

What a tear costs
-----------------

  XTS, ECB     each cipher block is independent, so the sector decrypts
               to a mixture of old and new plaintext - what a torn write
               gives on an unencrypted device
  CBC          P_i = D(C_i) ^ C_(i-1), so exactly one block, the one
               whose predecessor is on the other side of the tear,
               decrypts to garbage; the rest is old or new data
  AEAD         authentication fails and the read returns an error rather
               than data, which is the loudest and arguably the best of
               these outcomes
  diffusers    the whole sector decrypts to garbage; in practice only
               reachable by writing a table by hand, since BITLK uses
               512 or 4096

My view is that all of these are acceptable, because a sector whose
write was not atomic is lost data in every one of them. The filesystem
above cannot rely on a partially written block whatever comes back from
it; the cipher mode decides whether the loss looks like stale data,
like one corrupt block, or like an I/O error. It does not decide whether
the data survived, because it did not.

Documenting it
--------------

So I would rather say this plainly in
Documentation/admin-guide/device-mapper/dm-crypt.rst than refuse
configurations:

    An encryption sector larger than the unit the underlying device
    writes atomically can be torn by a power failure, leaving part of
    the sector written and part not. This is already possible with a
    4096 byte sector on a device whose atomic write unit is 512 bytes,
    which is the common case; a larger sector widens the window. With
    XTS and ECB the torn sector decrypts to a mixture of old and new
    data, as a torn write does on an unencrypted device. With chaining
    modes the block at the tear also decrypts to garbage, and with the
    wide-block diffusers the whole sector does. Use a large sector only
    where losing a sector to a power failure is acceptable.

Reworded however you prefer, and I will send it as part of v3.

Rejecting modes above 4096 would be a new restriction on a hazard that
already exists below 4096, and it would have to be revisited for every
mode added later. It would also read oddly to a user who meets it as
"use ECB instead", ECB being tear-tolerant but not something anyone
should choose for disk encryption.

For what it is worth I do not think many people would meet it either
way: cryptsetup has defaulted to xts-plain64 for plain mode, LUKS1 and
LUKS2 for years - plain-mode, luks1-mode and luks2-keyslot-cipher in its
configure.ac - so almost anyone asking for a large sector is on XTS
already.

If it turns out to matter
-------------------------

If experience shows this does need enforcing, the version worth having
is not a mode allow-list against a constant but a comparison against
what the device actually advertises: refuse a sector larger than
queue_atomic_write_unit_max_bytes() for modes that cannot absorb a tear.
That plumbing exists, and you enabled DM_TARGET_ATOMIC_WRITES for
dm-crypt yourself last year.

It cannot go in now, because on drives like the one above it would also
refuse 4096 and break existing tables, so it needs a deprecation path
rather than a one-line check. That seems to me a better use of the
effort than freezing 4096 into the code as though it were a safe size,
and I am happy to work on it as a follow-up.

v3 will carry the documentation above, and the two changes I already owe
this thread: dropping the dm-verity comparison, which does not apply to
a writable target as Milan pointed out, and dropping QCE as the stated
motivation, which Eric was right about.

Thanks,
Itai
