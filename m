Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793743487;
	b=wD1mh6e0fJFDbJM8CBjGR8X5lyoDDtXNqxoo/6lMtBkJmRF5t+XMzp4J0tXTJkWd5Wj+
	 ea+PyK0ncn719O1cJy4nkxmBhX/6cDhklxCY4xzONbOZnmhb3okZ24tZ8LGjYPn4OXcUy
	 sc7+eJhTKikzOEXepRgMkC1o/TO3UVKlPnyAizi6XzKNDA9+X0QeQ5lUWLjqAGwYrkpf/
	 pNMHLo10IW5MqSK/LBXhe3HgwPNsHpvpss78Aa/31xCf0vc6jtm8v8/GSXcbQo1B9OaYQ
	 kFUGjiourrMcvjb+gqtAIbHfq0RTFMQFzRCfo6FiH1kBDBEfUNBlLWAfgRBhUqf/kXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793743487;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=SmTMwpv1OD2XFRpOKXXdUL7roE1j9Y1IT5kBf1gh+/U=;
	b=0cQqdwYiXtkqn1sB6okq/oZl5VEBlTWsZhYPOrT73aCWzPhRXWvKG4cZ3FwqfnCQtK7D
	 3M3c4PSm35THNK5pjVauDi/4rsGZwCAmWBwVpVuYz/HIwZhl5s56xJ5I6+cJ9aayfoqzc
	 YPB+p/f5QC7UcMThCqGimBEForyUcYGvoV3iDEI4ys31ED1kQYaMDhUXXjbl1JE2qTDF+
	 RhYHSnZHwvcmQJdiIVy+dqnJ3kyicPQ4hSzbX6YbV7O3imjXCzr+kC0SNzqvZEyp0jnyt
	 DsIvqiqz0MkilSTjEG7fUgceJfbKPVLyjnSNw31arJWYD7/iiILknJX+Cr8JGWdrLBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NxMobliF;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DB6606A329
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 22:04:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80DB6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NxMobliF
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c45551fa84eso12671766b.3
        for <dm-devel@lists.linux.dev>; Tue, 03 Nov 2026 14:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793743481; x=1794348281; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SmTMwpv1OD2XFRpOKXXdUL7roE1j9Y1IT5kBf1gh+/U=;
        b=NxMobliFZD92CGLuXYqNCS0+qJDZqFzLbimenrgzB0n13YkkiH3YFej4nh4f9xP5fD
         G3TtkzaHiL1ScPw6ju484SrcYctcX/BFOnffit8mP5oclzsHlDPNJ5C93952XvafthIn
         oTtF2NzBZ1reOa7IRa8LvJUWwWkBl9XZ9P2WW+nqjo7CRYT+01MRC7xZlTG5WdGn0IkS
         JxRWM2TiM0ZUXtj0p6C6Fp8+PIGwuqjv9m7/ZkBhwXryTeo7Xc7DUMvE3t9Zy0QAjAKg
         uYGz4ja3vRiIsBNb+CLr3B2qju9RwWCqG8LNLpwZ2s3IpaZqS00gPO5fIj/z/knXT1Vn
         0u5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793743481; x=1794348281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SmTMwpv1OD2XFRpOKXXdUL7roE1j9Y1IT5kBf1gh+/U=;
        b=RKCtBqP33kOoiX67pIEi9oKbLLc2IGubDa1u+i5EUyGSzMkx7X2/g8ObYJb/tCnwqJ
         WIcRwGmLA5TBLz4XZPpOLnMK2xBgYDgjvfZEhgFJ9zqBfA/RVZjj2j843KXmg6AaC7FI
         dSkc0efylpI133lFARNAZ7PvMwkHtEkK8zvV4plCjtebW+x+ufQ3ncFP2/7kuHXMk1Ty
         lu4FJ3p70hUftwywVgA2BeNJ8+NaWoDZK6TinBNfyVnqh3CjJfOMJHNj+vbXGaCb2WL/
         yQdS+moeTiL+nXCBCBxbkmaFT8hnGJKrxAXdQHd68fQwB5Lselm2qx14bEjYPPWev+Aq
         I/UA==
X-Gm-Message-State: APuU4Z+rhE5IQfyt7Sxf4mk8qezdg9uOBmahtNZ2PY3WpWUG1o8UDoOJ
	KdVSv6yuNMEH8cLvQayf/xq94YT8xG8Se1mUJLmRY972mn84tSqdstD02wd1oEJtKLM=
X-Gm-Gg: AYBFou1Qv+RH1q94OMv4E4jFCfHeoVPMQQacUF+3+Uuaw1u3/ytucBUTIwyxKYB1czD
	qOWgk5vhgpgtcZDG7HYUNus8fjjOvm/0pZzwUPasXOgBbk8vaNxh/5J8Kge1WrZ15vQ7M4Dd+WO
	1+jkVGNM8cixSP2yl/GLeNcgPCrvHDcmzQ5z/y3bNKozetD8QpqViAlgpp6BXn2aj0VekyzuvF9
	hFLieZIaKGRfVy3fG7e7ozvTKeylUAvLjxFTSf0J+WHRoLMkAv1woof0wgyQrO3gL7FlooaJxFs
	jl1N6jA8IAECAXdJaj60ZKlGePYL8OK6dezkuhIC/DmehbJzA251iuckdV6MG5yvMNtoIQcw6QR
	Tkiclb86nRb0/fx6LYzlYM2YA4wl4Beg1iZO4mi/VDdtyIGvtZZXgMV2OhiIA2jHC8cIq1r4o8N
	Pck0755sDN+iywJtg0GU2/sjB4yNVIVLbP4HLHthhoeXcuT/rhEwH/OVMcwieVI62Rm9fiYuWjO
	nBd+BuV1Yhbb+D6oExeGXAqKqjAQd852bI9idr7mQAz7O+DX72yKHsyMZzXsdkrvXaRq805oOOC
	MEfbsChOJPKvIdIVXEy+9vpiUJ2RMq1a8tPnujY9lpb2pROy6cXLZHtI8rXQDSmlvAJv/0qe7bC
	TIHy2YQ==
X-Received: by 2002:a17:907:5c6:b0:c41:55b4:d88b with SMTP id a640c23a62f3a-c4ca7a9f7d5mr1183044366b.43.1793743480728;
        Tue, 03 Nov 2026 14:04:40 -0800 (PST)
Received: from localhost.localdomain (host-188-122-3-146.finemedia.com.pl. [188.122.3.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e424c34sm4574266b.13.2026.11.03.14.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:04:40 -0800 (PST)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/2] dm zoned: fix idle reclaim busy loops
Date: Tue,  3 Nov 2026 23:04:36 +0100
Message-ID: <20261103220438.510609-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Two dm-zoned reclaim fixes for the 7.4 cycle and stable, split from the
earlier series as Mikulas asked after reverting v4 from dm-7.4: these
two carry Fixes and Cc: stable; the third change, "dm zoned: keep
polling for idle reclaim after a reclaim pass", will follow separately
for 7.5 and depends on patch 1 of this series.

1/2 stops dmz_reclaim_work() from rescheduling itself at once when a
pass cannot make progress (-ENOSPC: no zone to copy into; -EBUSY: no
zone to reclaim). On an idle target that retry ran without pause and
called dmz_check_dev() on every pass. 2/2 stops idle reclaim from
copying a random zone into another random zone, which frees nothing;
its -ENOSPC result relies on the back-off from 1/2, so the order
matters for backports too.

v5: https://lore.kernel.org/r/20261013145522.17499-1-illofspeed@gmail.com
Mikulas's request:
https://lore.kernel.org/r/b7e35437-de42-d078-e75a-1f08541eb725@redhat.com
Damien on v5 4/4:
https://lore.kernel.org/r/bf59b38e-635d-48b8-861f-e50961472e92@kernel.org

Changes since v5 (posted on 2026-10-13; a v6 was prepared but never
sent):
- Rebased on 7.4-rc1 without conflicts; its dm-zoned sources are
  identical to those of 7.3-rc7, on which v5 was based.
- 1/2 (was "dm zoned: back off when reclaim finds no destination zone")
  also takes the -EBUSY back-off from v5 4/4, as Damien asked ("This is
  undoing what patch 1 does"), but not v5 4/4's dmz_should_reclaim()
  change (idle reclaim only when a zone holds data). Without the
  polling patch that change stopped the idle poll after a complete idle
  drain, so later data was not reclaimed until the next allocation;
  the back-off alone stops both loops. Hannes's and Damien's
  Reviewed-by from v5 1/4 are dropped because the patch changed, as is
  Hannes's later one on v3 1/3 (2026-10-21).
- 2/2: code unchanged since v3; Damien's Reviewed-by kept, Hannes's
  added from his reply to v3 2/3 (2026-10-21).
- The polling patch is no longer part of this series (see above).
  Hannes, your comment on v3 3/3 concerns code that v4 moved into
  dmz_schedule_reclaim(), as Damien asked. The polling patch keeps that
  form, which avoids one extra run of the work after a pass that leaves
  reclaim not needed; if you prefer the unconditional reschedule,
  please say so and I will change it.
- The Assisted-by tags are gone, following commit 1e035297ffda ("docs:
  remove Assisted-by references"); tool use is described below.
- Commit messages: test results for exactly these patches on 7.4-rc1;
  measured rates are SCSI request counts, not commands reaching the
  drives.

Tested on 7.4-rc1 with emulated host-managed drives (scsi_debug),
RAM-backed: idle request rate and reclaim passes against the stock
module (1/2), the random-to-random case on a two-device target (2/2),
and checksums of all written data; details are in the commit messages.
md/dm-zoned reassembly after target removal was also clean, and a target
suspend and a "reclaim" message each landed during a copy with no hang
or kernel warning.

Also tested on three 27 TB host-managed SATA drives, each a
single-device dm-zoned target (998 random zones of 256 MiB) used as an
md RAID5 member under dm-crypt and XFS, with the stock module and with
both patches built out of tree for 7.2.10 (whose dm-zoned sources differ
from 7.4-rc1 only in three places where 7.2.10 open-codes
clear_and_wake_up_bit()). One run per module, kprobes attached
throughout; the drives sit behind a SATA port multiplier on a Marvell
88SE9235, and two other drives on the same controller were being
zero-filled at about 218 MB/s each, which affects the absolute numbers:
- idle for 300 s with all random zones free: stock, about 32.5 million
  reclaim passes per worker, each with a TEST UNIT READY that libata
  completes in software (about 108,000 SCSI requests per second per
  member) and about 915 s of system CPU time across all CPUs; patched,
  29-30 passes per worker, no dmz_check_dev() call, 58 requests per
  member and about 46 s of system CPU time. Those passes issue no I/O:
  the requests come with the target's periodic metadata flush;
- 300 s of single-threaded random 4 KiB O_DIRECT overwrites spread over
  1,100 chunks (more chunks than random zones), with dm-zoned's free
  random zone percentage at or below 30 (at most 309 of 998 free) in
  72-79% of the samples: 2,457 (stock) and 2,395 (patched) writes,
  99th percentile latency 0.49 s and 0.48 s;
- a target suspend with the array running, and removal of one
  member's dm-zoned target after the array was stopped, each while
  reclaim was copying a full zone (patched): each waited about 11 s
  for the copy to end, with no hang or kernel warning (with stock,
  reclaim on the member to be suspended had stopped after a busy pass,
  so there was no copy to overlap; the stock removal also waited for
  its copy);
- sha256 of all written data, read back at the end of each run: no
  mismatch; md parity checks of every stripe of the suspend/removal
  test and of a random sample (about 4%) of the other written stripes:
  no mismatch.

2/2's case does not arise on these single-device targets. As with the
stock module, reclaim still stops after a pass that ends while the
target is busy and reclaim is not needed (here: after a busy pass at
31% free, no pass for 600 s); the polling patch addresses that.

Not tested:
- the back-off while the target is busy: in the overwrite test every
  reclaim pass copied a zone, so no pass ended with -ENOSPC or -EBUSY;
- the -ENOSPC back-off on a single-device target without cache zones
  (found by code inspection) and recovery after a sequential zone is
  freed (neither test setup could establish those states);
- the effect of the cache-to-random fallback that 2/2 keeps: 6 such
  copies completed while the two-device target was being filled, but
  the test of its effect could not establish its starting state;
- system reboot and shutdown; only stopping and reassembling the md
  array and the dm-zoned targets was exercised;
- stable kernels at run time, other than the 7.2.10 runs above. Both
  patches apply with at most a 2-line offset to 7.3.1, 7.2.15, 6.18.60,
  6.12.115, 6.6.161, 6.1.191, 5.15.224 and 5.10.273, and the dm-zoned
  objects build there without warnings (x86-64 defconfig plus dm-zoned,
  W=1).

I used LLM coding assistants for root-cause analysis, drafts of the
code and changelogs, the test harnesses and reviews. I reviewed the code
and changed it where needed, and I am responsible for these patches.

Kyrylo Biryuk (2):
  dm zoned: back off when reclaim cannot make progress
  dm zoned: do not reclaim a random zone into another random zone

 drivers/md/dm-zoned-reclaim.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

