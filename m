Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE85393DF2
	for <dm-devel@lists.linux.dev>; Sat, 25 Jul 2026 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784971111; cv=none; b=YF8NPDwg69/VaodKrKr+HBV7vb5J1/OmOkcqcYZ9A7h2Dg3iU3ySt96BBZghOdSEY55p0v/sl+GHpeGtixK6SNXdxnUehSBrn7Y8em1OdPD2WgJ9oKeySL6uOdWhY7PrY5afGxrroExlWDPJVuy7h+8Dl7u3L0MgMFxvcsJ3/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784971111; c=relaxed/simple;
	bh=yQd7j+9b93EriPFwyfi8UBbwunz1hpFXRM0DtaEWMAE=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:From:Subject; b=j+69ve+D/PzKQ362zXt05DrCHwkl6V1oF8P+QIIAxD+9648o8fPOQGEvaGcqbgGBZBbZMNMxB2YrC1VQftYeLZh0dfUkSD3LrXwfRL9P/NmM6jutLyTuuGJ/GrUnUk6B3CumUnfV47uJBHngME0XCsMQnDMasrOw8GfmnVNp5xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGBw86PH; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGBw86PH"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ccae46de39so1978345ad.3
        for <dm-devel@lists.linux.dev>; Sat, 25 Jul 2026 02:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784971108; x=1785575908; darn=lists.linux.dev;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yQd7j+9b93EriPFwyfi8UBbwunz1hpFXRM0DtaEWMAE=;
        b=iGBw86PHcx7Rx3KLgbsLYhYqRoz32/OHZjpEGowNaiOhetmxvF5owxhinwSgPuxfce
         Rn0QA1Y2BFEWjP8T3KDNSFOXfdEwAAi1PyK4gT3urVJ0yMpa2KNAmhZfodQSAji2PowA
         AtK9Trjr0vyuVoDUdmhq+9JHZzUmwq7swYPqWDC5c2Gy8BJq2VF2nouKiXyu3d80NOJf
         KN1WVuU0fDOvCn162zMPFXqJONTJlHy4wC2QwA+WjfxO7tqS3Q+rPZrcoG3N6uE48zUa
         qTcljDDAl1WHP7qWRoW2ao54Fs0E5TTxILdETRb454s2oba1yD8qfD8lpoGFrtP0Mid7
         iMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784971108; x=1785575908;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yQd7j+9b93EriPFwyfi8UBbwunz1hpFXRM0DtaEWMAE=;
        b=Xu0E3a/Mv//cPFa0CN5jWOclUEx1KBRSAIj87H5U5a4PwNa4rReFxPE/ug5WM9rN4I
         dkQoQtoZrySwk/1+UrSyw4+khfk3LLw8tpsfQ+ZHQjxLVnlZRrnvkqLJ+O/vB62VWml5
         yPuN4NRVLTk6CHM3lalkcT+utWm/bA4BFD0g1rQuYOOpSWo2Q8j3Ijd8/x13jBt8t0w1
         9qAiWWek8KjCs1KAWqIfxBrLIVSv34CumnPmypZhtDti+r5Z9lSD72qkPgITOIm3ouIN
         gbnAo5pd1hghzmmJqDMO4Yz8PLhXmcLQ458pGTsnRIbVhP4eCG+KLhtQ5DwPCNZ9ozxz
         VpAg==
X-Gm-Message-State: AOJu0YxxyJLdvuQOHtWwc2RBob6JQXOLzmu8EkI65d/GeEAMipGQWKQ9
	eveyv4Iq3X1SPGM3K9VxBJWj3A9FRT9nY4S+hHLLJAGMYuQed3R/Muru
X-Gm-Gg: AR+sD12oRWzv1Af/l2JcjRqHdsHV+RUmI45Nz8saQO8Xcdc/BE1GRGcfetGJ6Eu9hhp
	czey3sSa3Nd8qjh+m6f08dhRJDrbqyc/05wvmWyzIE4vx8ep9DcD835UZzue3tYKLdFapVwFAWR
	zVOF+Hehx1vPjn/TKg3Pdo5yOG1q3MrKMSCLzjf35lAn5RXfoGarBY3vis6xAo5E59orX5s73ni
	J1uGP6IyPA3jy1Aa58j6nJOkyERLkBpnZe7U/2Ffh+IXEyWEeHcIA4JEhN7FpCgEdLxt9HLmUCI
	JNDOrwpr04t9Bmpnc2Fo5fxsV+x0TPug9mMgEuY+G0k96gkDIWdIvUcBs++qN+ZK9O7vhNwSbz4
	N/Q33ZEA2cWMAoik7W1Xq1zXJdHpQg4CeejckrGgO0QFLf8BTOco/KegSVyftWDrDvXnxcBhqCC
	fbtDFNCMRq9ibMGk36VFWDCYPp18Y=
X-Received: by 2002:a17:903:468e:b0:2cc:df15:91e2 with SMTP id d9443c01a7336-2cfde8c2f20mr12551385ad.7.1784971107596;
        Sat, 25 Jul 2026 02:18:27 -0700 (PDT)
Received: from [10.70.111.138] ([202.189.104.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc4f4sm7499825ad.39.2026.07.25.02.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 02:18:26 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------O8n0LEepuVAIrxYKH8eQmfpU"
Message-ID: <9c337692-ce94-4dfa-80db-47390f67f0b5@gmail.com>
Date: Sat, 25 Jul 2026 17:18:23 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
From: Junzhe Yu <junzheyu1@gmail.com>
Subject: [BUG] dm-stats: null-ptr-deref in dm_stat_free on stats alloc failure

This is a multi-part message in MIME format.
--------------O8n0LEepuVAIrxYKH8eQmfpU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I am reporting a null-pointer dereference in device-mapper dm-stats when
@stats_create fails part-way through per-CPU buffer allocation.

Summary
=======

dm_stats_create() allocates per-CPU stat buffers in a loop. On mid-loop
ENOMEM it jumps to out: and calls dm_stat_free(). dm_stat_free() then
dereferences s->stat_percpu[cpu] without a NULL check, including for CPUs
that never received a successful allocation (still NULL from zero-init).

The crash is a KASAN null-ptr-deref / general protection fault in
dm_stat_free() at drivers/md/dm-stats.c, reached via DM_TARGET_MSG
@stats_create.

Affected
========

- Confirmed on Linux 6.6.145 (KASAN + CONFIG_FAIL_PAGE_ALLOC); also
   reproduced earlier on 6.6.144
- Originally found on Linux 6.6.0 via syzkaller
- Files: drivers/md/dm-stats.c
- Config: CONFIG_DM=y; CONFIG_FAIL_PAGE_ALLOC=y makes the PoC deterministic

Root cause (brief)
==================

1. dm_stats_create() does for_each_possible_cpu(): dm_kvzalloc(...);
    on failure: r = -ENOMEM; goto out;
2. out: calls dm_stat_free(&s->rcu_head)
3. dm_stat_free() does for_each_possible_cpu():
      dm_kvfree(s->stat_percpu[cpu][0].histogram, ...);
    with no NULL guard — NPD when that CPU never allocated.

Needs enough CPUs that fail_page_alloc can fail after some CPUs succeed
(guest with >= 4 vCPUs). Partial init on the error path is not cleaned up
safely.

Crash excerpt (6.6.145 KASAN)
=============================

general protection fault ... KASAN: null-ptr-deref in range [0x60-0x67]
CPU: ... Comm: repro Not tainted 6.6.145 #1
RIP: 0010:dm_stat_free+0x12c/0x360
Call Trace:
   dm_stats_message
   target_message
   ctl_ioctl
   dm_ctl_ioctl
Kernel panic - not syncing: Fatal exception

Full excerpt is in crash_excerpt.txt in the attachment.

Impact
======

Privileged local DoS (CAP_SYS_ADMIN required for /dev/mapper/control).
NULL deref, not UAF — practical impact is denial of service under memory
pressure / fault injection on the @stats_create path.

Reproducer
==========

Attached: dm-stat-free-null-deref-repro.tar.gz

VM-only (do not run on a production host). Minimized C PoC: create a
zero-target DM device, resume, send @stats_create - 1024 while
fail_page_alloc is armed (fallback: memory hog). Guest needs >= 4 vCPUs.

Quick path (Docker + KVM):

   tar xzf dm-stat-free-null-deref-repro.tar.gz
   cd <extracted-dir>
   docker build -t dm-stat-free-null-deref -f Dockerfile .
   mkdir -p artifacts
   docker run --rm --privileged --device=/dev/kvm --network=host \
     -v "$PWD/artifacts:/artifacts" \
     -e OUTPUT_DIR=/artifacts \
     -e VM_MEMORY_MB=512 \
     -e VM_CPUS=4 \
     dm-stat-free-null-deref

Expected shortly after the PoC runs (first run also builds the kernel):

   KASAN: null-ptr-deref ... dm_stat_free
   Kernel panic - not syncing: Fatal exception

I am happy to test patches. Please let me know if you need more detail.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>


--------------O8n0LEepuVAIrxYKH8eQmfpU
Content-Type: application/x-gzip; name="dm-stat-free-null-deref-repro.tar.gz"
Content-Disposition: attachment;
 filename="dm-stat-free-null-deref-repro.tar.gz"
Content-Transfer-Encoding: base64

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
zLCjYBSMglEwCkbBKBgFFAIAMfvaMACgAAA=

--------------O8n0LEepuVAIrxYKH8eQmfpU--
