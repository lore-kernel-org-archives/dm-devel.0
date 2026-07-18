Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277CC238C2A
	for <dm-devel@lists.linux.dev>; Sat, 18 Jul 2026 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784382226; cv=none; b=NhRV5BjCPUTnJFCGQePDNRZ//x10wr3nZ2nu0Qh6aZGFzR5Tl5kXntvfENKcnmjURSXD7+aiTCxQe5bAvWMrhIT0tjqLFfQNkB53dM1aA1aaWt/Hvb9qA3LZin5LguN/JOFGjY83ygzzQTpTU03fqfo8j6zMG9guTss/K3Qrnx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784382226; c=relaxed/simple;
	bh=EDTOpUY5E+v2EtkzFsvwJ96cDbvlurM2h+bzt++FeG4=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:From:Subject; b=rvLwa/05EUwnZ14BfeXIb9RLoNflU4q0e314MZ5nUWNNsRUf3c6tUF6fAWDVuBDQz1l3fO9IXZhVMJPw54BgejQZLctRsXNplWkdWmY4scbAl0HdvpRNF+S79CuzJqz4fjBir53KK5gR+P3/MaI/Q2ulf7kH/oWSvSVeVyZQNpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BzY2T1Ii; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BzY2T1Ii"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca53979f8e8so731293a12.2
        for <dm-devel@lists.linux.dev>; Sat, 18 Jul 2026 06:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784382224; x=1784987024; darn=lists.linux.dev;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EDTOpUY5E+v2EtkzFsvwJ96cDbvlurM2h+bzt++FeG4=;
        b=BzY2T1IiFJikv88D7bOe3KLHm/BDVvT6Oy5Mw08M/9J/DFD5siiObB518nuL2RX0yk
         aMMHtcwW+uQWdgEKXcFWvGD02evyqJp42PmOs9+pY4t6VLpJqx07bRrdGcHs1AlHu5V5
         +uR94CXAPL2HaO+6LpfEY/rq1E9SyX9iR5gB5JXrWWYQj+MMWmamxcnyiwdvggNo110z
         sy4rlpHd+NwPcXeLJQIybs2/97PXHl0vgAggIDIkkqLOIymxmXjXwuTGtXBmfooecqYk
         Se8Cjao9QapCRYh3jkjVuE0c0WG+FAwxbWplzO32bWWQgDSZ+CuIfXuDJtfeCNjnrQ2x
         TXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784382224; x=1784987024;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:content-type:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EDTOpUY5E+v2EtkzFsvwJ96cDbvlurM2h+bzt++FeG4=;
        b=EhLb3wBVB+hA1BEFCxM1SWM6PFq3KD/ofSGF1Vzk4AsqNxvLhibT8+SoaDwLms0kN4
         SjcDTOJZzcPUjCtwOkXuQM73El3dvPE/tN0nFsX6Zc9lRewjtnslqxdNJTej1JTQfTR0
         BwrCQzJN/4TolU2xnWCZME03AazWUeENUBDXagvYtkqAgB2x/ss6GWiOGv9v2IKQk6ix
         iSJ/O1gGpRDF36AJSTogPc/C4Sc6nt107EPGDLe6zkB/g7n6yDoX4PxviIQUIOdIES2T
         hOXOz4fakxBFZ1/8u+C/Ko0huvOTDvvytpjNZj+7wa9KgsvvCbO7kKPepXbdfCRP6I+N
         yrAg==
X-Gm-Message-State: AOJu0YxyTMk+GrxcStQHJb7xKiy2GMpcYoq19Ax1moXLJuQ4pqQ5JC4x
	3Lnf5RsCvNFeTgJZc+IPAEmm+VhSOM5z+Wu3nC3uF2iE6LLo5gwf0X8M
X-Gm-Gg: AfdE7cmKb07ke7fdDCYdngSCd5sqH5CTj7DnY2iMbsHP+4r9+zkXjPtWrjOyQh9RjUN
	v6BTHr//HK8t2C9bE0is/p+gYbxnJgQCEwqo944nDZxP2OV9Ll/CHrd9DU1eF1ml0Mn170oHyib
	lT6m5zqq1LrxfhbXbRsyVx3Wyb00LfVGWl6gdY9rgP+EufiQjDGiez3EIdqBdBueoY7lr9r6FqW
	fmbc2aeZT8yRDCyHguppONDwgRm9NtDDTHTyQZsapeYPAlAZTM4IKiJCRF43M3nqIKvLZa7iK8T
	h4P05HOC3At5M3jEbQf5QiZQfmQMvenKxQr3Uph5mvfEWpnr7h616pUwRDQythr6mklDQ3oF+3T
	jXDKoscPjLdBuzKVQ1Ppg8ZWq0ZeIUS+2KfO83LgEDpBcaMUJZhIVoWM+hQ8o3a/8x4IiRo69+5
	5kdxjIns+MRykB/i9f
X-Received: by 2002:a05:6a00:21d2:b0:848:5451:cfa8 with SMTP id d2e1a72fcca58-84c29082b41mr4798670b3a.0.1784382224204;
        Sat, 18 Jul 2026 06:43:44 -0700 (PDT)
Received: from [10.70.111.138] ([202.189.104.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2adc5307sm2843000b3a.16.2026.07.18.06.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2026 06:43:42 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------drWKf0FUsj9DFH1Q5UFlfqZe"
Message-ID: <5947c25a-0a1e-4bb2-ad3e-8e4d9ecbd8c2@gmail.com>
Date: Sat, 18 Jul 2026 21:43:37 +0800
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
Subject: [BUG] dm: dm_setup_md_queue UAF walking table_devices without lock

This is a multi-part message in MIME format.
--------------drWKf0FUsj9DFH1Q5UFlfqZe
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I am reporting a KASAN slab use-after-free in the device-mapper core in
dm_setup_md_queue().

Summary
=======

dm_setup_md_queue() walks md->table_devices without holding
md->table_devices_lock while a concurrent failed DM_TABLE_LOAD frees a
table_device via dm_table_destroy() -> close_table_device(). The crash
shows as a KASAN UAF on the list walk, and often a follow-on page fault
in bd_link_disk_holder().

Affected
========

- Confirmed on Linux 6.6.144 (da47cbc254661aa66d61ef061485a7080305c4be)
- Originally found on Linux 6.6.0 (ffc253263a1375a65fa6c9f62a893e9767fbebfa)
- Files: drivers/md/dm.c, drivers/md/dm-ioctl.c
- Config: CONFIG_DM=y, CONFIG_BLK_DEV_LOOP=y, CONFIG_KASAN=y

Root cause (brief)
==================

- Top frame: dm_setup_md_queue() at drivers/md/dm.c:2380
   (list_for_each_entry over md->table_devices), called from table_load()
   while md->type == DM_TYPE_NONE.
- table_devices_lock is held only around add_disk() and then released. The
   subsequent list walk that calls bd_link_disk_holder() has no lock.
- A concurrent failed table_load unlocks at err_unlock_md_type and then
   dm_table_destroy() -> close_table_device() (list_del + kfree) races with
   that walk.

The PoC uses only documented DM ioctls (DM_DEV_CREATE, DM_TABLE_LOAD,
DM_DEV_REMOVE) as root. Concurrent table loads are not forbidden by the
userspace API; the kernel must serialize mapped-device state.

Crash excerpt (KASAN)
=====================

BUG: KASAN: slab-use-after-free in dm_setup_md_queue+0x4f4/0x590
Call Trace:
  dm_setup_md_queue+0x4f4/0x590
  table_load+0x56b/0x8b0
  ctl_ioctl+0x72a/0xcb0

Allocated by: linear_ctr -> dm_get_table_device -> table_load
Freed by:     linear_dtr -> dm_table_destroy -> table_load error path

Full stack is in the attached tarball as stacktrace.txt.

Impact
======

Privileged local DoS (CAP_SYS_ADMIN required). Practical exploitation
beyond DoS has not been evaluated; reporting as a privileged memory-safety
bug / DoS in DM core.

Reproducer
==========

Attached: dm-setup-md-queue-uaf-repro.tar.gz

VM-only. Six workers race: create a fresh DM device, concurrent failing
linear table load vs successful error-target load (dm_setup_md_queue runs
while type is DM_TYPE_NONE), then remove.

Quick path (Docker + KVM):

   tar xzf dm-setup-md-queue-uaf-repro.tar.gz
   cd <extracted-dir>
   docker build -t dm-setup-md-queue-uaf -f Dockerfile .
   mkdir -p artifacts
   docker run --rm --privileged --device=/dev/kvm --network=host \
     -v "$PWD/artifacts:/artifacts" \
     -e OUTPUT_DIR=/artifacts \
     -e RUN_TIMEOUT_SEC=240 \
     dm-setup-md-queue-uaf

Expected within ~40s after the PoC starts (first run also builds the
kernel):

   BUG: KASAN: slab-use-after-free in dm_setup_md_queue
   ...
   Kernel panic - not syncing: Fatal exception

Note: a WARNING in bd_unlink_disk_holder / bd_link_disk_holder may appear
first. The attached run.sh omits panic_on_warn=1 so the guest can continue
into the KASAN UAF.

I am happy to test patches. Please let me know if you need more detail.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>

--------------drWKf0FUsj9DFH1Q5UFlfqZe
Content-Type: application/x-gzip; name="dm-setup-md-queue-uaf-repro.tar.gz"
Content-Disposition: attachment; filename="dm-setup-md-queue-uaf-repro.tar.gz"
Content-Transfer-Encoding: base64

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
U57ylKcnpf8CsEIsmQCgAAA=

--------------drWKf0FUsj9DFH1Q5UFlfqZe--
