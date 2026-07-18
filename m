Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12E31C862D
	for <dm-devel@lists.linux.dev>; Sat, 18 Jul 2026 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784381548; cv=none; b=sTcNH8FgmH8sy+CHPiYvc4KEXO9vLmr7hodB7mc9w+4r2xp/xViQjXmTkSy89SIV/Wvm5B3p5oseO2Csdrw5oodguTyhSPks9gPOpQxa/KwoWZ0pbn1hAJO502yAIzv977DAsAP9srOncUcz01ZHaJ9cKAaRoEBi2zfccSnjXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784381548; c=relaxed/simple;
	bh=FMQfaB7ouOksmHSCC21OYO486FumS8uL07Iv4aHA4ck=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:From:Subject; b=motI8/JBENCsIGtv3LxpdKEWePWE3qndWbx0hewCb2tsNZpPnVZ3bKb0yRRSo0HFdOQhg2yNwBlf2QdM9/6y7c0N7/xYigPIy4lNIxzmkKtHjN7mACiS6Wyxgf2ucBedUgG/cHZhuUTYkzO0Jn/rCWa+yTz4/PealFN11Hd+RSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMHC7PXr; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMHC7PXr"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3860f32307bso1369269a91.0
        for <dm-devel@lists.linux.dev>; Sat, 18 Jul 2026 06:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784381546; x=1784986346; darn=lists.linux.dev;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5JrTEjagPFA6CsbLgaehZEN8naUDrDz69XI72VU9ubA=;
        b=kMHC7PXrACK8Rglzlm4mqjO15DvVLiBVvAo/BsLcvt1VhRAtDufdDTcjMwBfpkj5VA
         nLxGLB0bCNK6+HggUsiXBnAvIKiLoV5ij3tv76shvpxsQM642mRGb93VBcgHFOZSR4Ka
         FFkOULjv5L2DzIqQU73Jc5fh5+/M6lvjbHuwxVkB3j+hn9+4gbI3N+9Sn9xW6xC5agE1
         +iyPvDBcm64p4/AmEgeIPjYVojwFh5upviw1yy1SuoewhvSXjuEWmw6jvDGlI7brd6HC
         KfcN4x4ZX4XZYOAy1KEonKDjChu9YPKW4+UBzqWSyY6IJdpRvCbVcui0FXKe9gUxL8Uf
         eBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784381546; x=1784986346;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5JrTEjagPFA6CsbLgaehZEN8naUDrDz69XI72VU9ubA=;
        b=a8xpJ2B40Va5xO7cnq7+9Na01q4NRt5iZQQ2u65Ntwe+3XvpdJUiC7IahBR9020P2N
         3mLYvx8p1ujucLBQTZpuJbMgN7/SHZ4KQ970GLS7DSr68z9rNkWf8JkOb2u9reuRLzZx
         Nc6UlQsPcYVYUt61zd3IfKzDDzhAL7TrRTkkyH6El/jfXbLakPxmEisplsrM+8Sd/CBg
         sLCtXFzUhEViNIDb+VISdzwWiZk9m1/Wrx3+Vddfkfi8+P588a3cO+zXvL9/KnT1E4q+
         e/PCWSToKinjiD25smI9/5sISI0qC8CMutct2dFUFLNo66sX+2BnIcejNODD8h3+awax
         ThYA==
X-Gm-Message-State: AOJu0YzPqjYR85zzOkEkecXcLyZb8CP9sVEfgfkC7ETKWXogLYeKRjUW
	8VeoZlq/YqQxSZ3huvZm3axeiCfkmOFS7zUFPBeKb91MHmqtITZQ0yOg
X-Gm-Gg: AfdE7ckUNPvDlnLeRTMfCNbjahiaxYmUYbi1A9hCCIomPjPMgeU2c4lLjLJKIJgxLrG
	2M5cPVFBFLW0J4RbccmSTX7mNlNSkEXHcp2xelE4urpOQAwC+1a3wvUgk7vSt4j2OeQYB40+6Ql
	wMF6wGTtu6vO13cLViW7jQWy1MFEqn5SEhBvA8mw2bCLruk3apUYZt68oLHf15S5NiESruaIi9h
	NyD++TTkyqORe1B5/PCuFRDU6P+9L5DqfxG+G7l/hrfuDGfsdTkve5xhlv3DJTsF5CALPrXlHZ9
	UufU4ysOFa6YY313JKASJkmaJCi3wFbL5fxBfn2iqwx4/w5N4R+6qSwCOZO4d6xrHjOMI+0WT5D
	6rEyfmLXno7BZGy0IgsGyLdwJ+I/vW3Zrr9+w/r6XfdEsvQbVFjL9/EkmJ2kqRJADVBp2oCjHAf
	YS7aYsbKB0h/q6vjXW
X-Received: by 2002:a05:6a00:4c13:b0:843:468d:780d with SMTP id d2e1a72fcca58-84c294d9d18mr5567923b3a.3.1784381545510;
        Sat, 18 Jul 2026 06:32:25 -0700 (PDT)
Received: from [10.70.111.138] ([202.189.104.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2f1601d6sm2570952b3a.50.2026.07.18.06.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2026 06:32:24 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------XZiXwCbxJ9BCh4rmgSQTpQNJ"
Message-ID: <2582d759-1e99-4a31-9a1b-5eccf0af3891@gmail.com>
Date: Sat, 18 Jul 2026 21:32:19 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 agk@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
From: Junzhe Yu <junzheyu1@gmail.com>
Subject: [BUG] dm-integrity: dangling reboot notifier after resume vs remove
 race

This is a multi-part message in MIME format.
--------------XZiXwCbxJ9BCh4rmgSQTpQNJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I am reporting a KASAN slab use-after-free in dm-integrity involving the
reboot notifier registration path.

Summary
=======

A late do_resume() can register ic->reboot_notifier on a dm_integrity_c
object that a concurrent DM_DEV_REMOVE path is destroying. The removal path
unregisters the old notifier via dm_integrity_postsuspend() and later frees
ic in dm_integrity_dtr(), but does not unregister the notifier that the
racing resume just installed. The global reboot notifier chain is then left
with a dangling node; a later notifier_chain_register() walk touches it and
panics under KASAN.

Affected
========

- Confirmed on Linux 6.6.144 (da47cbc254661aa66d61ef061485a7080305c4be)
- Originally found on Linux 6.6.0 (ffc253263a1375a65fa6c9f62a893e9767fbebfa)
- Files: drivers/md/dm-integrity.c, drivers/md/dm-ioctl.c, kernel/notifier.c
- Config: CONFIG_DM=y, CONFIG_DM_INTEGRITY=y, CONFIG_KASAN=y

Root cause (brief)
==================

1. do_resume() in drivers/md/dm-ioctl.c resumes mapped device md without
    rechecking whether md has already entered the DMF_FREEING removal path.
2. Under the bad interleaving, removal has already unregistered the old
    ic->reboot_notifier through dm_integrity_postsuspend().
3. The late do_resume() continues into dm_integrity_resume() and registers a
    new ic->reboot_notifier on the global reboot notifier chain.
4. Removal then frees this ic via dm_table_destroy() / dm_integrity_dtr(),
    but no second postsuspend() runs to unregister the newly registered
    notifier.
5. The chain retains a dangling notifier_block embedded in the freed ic.
    A later notifier_chain_register() walks the list to insert by priority,
    touches the freed node, and panics.

Crash excerpt (KASAN)
=====================

BUG: KASAN: slab-use-after-free in notifier_chain_register+0x2aa/0x310 
kernel/notifier.c:35
Call Trace:
  notifier_chain_register+0x2aa/0x310
  blocking_notifier_chain_register+0x6e/0xc0
  dm_integrity_resume+0x5a4/0x1a20 drivers/md/dm-integrity.c:3293
  dm_table_resume_targets+0x1d5/0x350
  dm_resume+0x19e/0x2b0
  dev_suspend+0x543/0x7e0

Allocated by: dm_integrity_ctr -> table_load
Freed by:     dm_integrity_dtr -> __dm_destroy -> DM_DEV_REMOVE

Full stack is in the attached tarball as stacktrace.txt.

Impact
======

Privileged local DoS (CAP_SYS_ADMIN required to use /dev/mapper/control).
dm-integrity is an optional target. The race can be hit reliably (especially
with CPU-pinned workers), but we do not have a stable reclaim path to RIP
control. We are reporting this as a low-risk privileged DoS / functional
memory-safety bug, not as a high-severity exploit.

Reproducer
==========

Attached: dm-integrity-notifier-uaf-repro.tar.gz

VM-only (do not run on a production host). Minimized PoC: concurrent
DM_DEV_CREATE / DM_TABLE_LOAD (two integrity tables) / DM_DEV_SUSPEND
(resume) / DM_DEV_REMOVE. Workers use sched_setaffinity to CPU 0; without
CPU binding the race may miss on some hosts.

Quick path (Docker + KVM):

   tar xzf dm-integrity-notifier-uaf-repro.tar.gz
   cd <extracted-dir>   # contains Dockerfile, poc.c, repro.sh, ...
   docker build -t dm-integrity-uaf -f Dockerfile .
   mkdir -p artifacts
   docker run --rm --privileged --device=/dev/kvm --network=host \
     -v "$PWD/artifacts:/artifacts" \
     -e OUTPUT_DIR=/artifacts \
     -e RUN_TIMEOUT_SEC=180 \
     dm-integrity-uaf

Expected within ~20-90s after the PoC starts (first run also builds the
kernel):

   BUG: KASAN: slab-use-after-free in notifier_chain_register
   ...
   dm_integrity_resume
   ...
   Kernel panic - not syncing: KASAN: panic_on_warn set ...

I am happy to test patches. Please let me know if you need more detail.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>

--------------XZiXwCbxJ9BCh4rmgSQTpQNJ
Content-Type: application/x-gzip;
 name="dm-integrity-notifier-uaf-repro.tar.gz"
Content-Disposition: attachment;
 filename="dm-integrity-notifier-uaf-repro.tar.gz"
Content-Transfer-Encoding: base64

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
kIc85CEPechDHvLwbcJ/ABx1w4kAoAAA

--------------XZiXwCbxJ9BCh4rmgSQTpQNJ--
