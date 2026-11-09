Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794250571;
	b=Mm6Coi1l2lcqj8ywThNR65Hd6YDpA8ve9Vh73ekbcFNPumebHCghmDQl97NCkaw8dwZT
	 EL5ppph20Z6Z/779BlCASaBxmDhY71ivpgx5UfuNAwTAc/UJJ9G2QLjtgBhY7TDXndhe8
	 OxH/dWMpzOyrHIfUus+/iOWnq7lc3nK/zsJZc5DlSqx9erMIZp2Ltaq4bkXsmxtP13+jk
	 weRd12zoxjJPdarhz4ZxVETEdkgkEFntAfBQ1mX8fVw7NOkUaDRQmowq1DFq4kfBwIRoj
	 5AtIhNyYpKlIVowOfr0wjHHW8KoqvkLKRanoOhPFq64p1UFCeo9JLI6SSm+8J9UE3kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250571;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IiJcWINAfJBzrOKWMfrm1O3L4qXGO6yhQLaecnb4TsA=;
	b=2X2Y6Y4vAWO+HdySGpuBuzG6D2rNxdxkqzqBkpXdArIrHR/oXXf3u4+swtDl9U9ruQEY
	 wGunJEAeoBYKfHMr5skWu54jMhKIRHH/KUeytfa1qs4qRba7mw4MlHvygi74ras4cbXag
	 GQkhwHqCbqawf5woKsop8FxMIS5qD3+ydmXurXn047OyHAUf/Fwjv8AYj89MR6rMDyPwT
	 ZgPJMSYwxkHla/RLfBb3Je56+6oxKbcz0hPTRe8yvgDQTJ7boWxPfwmukcmc7Eae9GUXI
	 ozk6SH8GEZJrObXxrlkoZTorrrvvg6hFgtZ8urfPev/JFgFxB8JqWlkwTZqFxVIPZKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IqO1rLNU;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AE5606A326
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 18:56:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17AE5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IqO1rLNU
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1a3c08d6928so2166610c88.0
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 10:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794250569; x=1794855369; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IiJcWINAfJBzrOKWMfrm1O3L4qXGO6yhQLaecnb4TsA=;
        b=IqO1rLNUsPqplrDNKXpfnvEfIF65G72l/AkcSBj/5EbHvdBgxTUF23dq/KkSnBXDP/
         0MRndtIW5chJ/NLvCIxWDQOTGwSrwGCKAUGSHRlASeWyTVhN3sy+bcUAA1e/vbVbBHgS
         UeDMZoPU2mZlYggCxjQTBv10psM9aq5K7larPZ88xeylNVbkRYzCKhAEXhtUWrJdH085
         yc0Nk/8nkhY4hf5lV7fo2ODYKOarYVZ4r4iRVvQZvebLSsYjv6eIa15rgmhrpjQc/oxz
         tIduic/d3FQqK8nsah7CuadrPw3wPnjt3sUcZBnTJpU9LPqQB+OxLAEf1ZK5rl3FfB/y
         wrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794250569; x=1794855369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IiJcWINAfJBzrOKWMfrm1O3L4qXGO6yhQLaecnb4TsA=;
        b=h56RVirgmxOD7G91GjegHAlcKRgUpzkfcmQQB3tt2/i/CgA8eeuklylOYisQq4IEBo
         F74eIoXzq8ZKSXA7ntpJssC1xCaRQIJXBxabgVbZHjruU1vXYxe3He1kziwNDIGM/HYP
         fKEcRLCCBtS5bF7NFRG3vwV2Bn45CZfoF6yuWc+jWs+ET8g/kXxF/swKLFtdxAprPguv
         Bpmd6upddgDsjYYKVpju/LVWXl2CXE86ZoX3XuG081cqpowLJPH0Lrdv2V+iKZ7D1vmK
         gN5MOB9rbqFl9BkfG/oSEJ6YHgBXh0oVz7U7Wr5EI3Hw2wa6zMQaETpXC2yTSrXkLosJ
         AVVQ==
X-Gm-Message-State: APuU4Z/EW1gopgF764Jy9HNlafWDo8LOK/QUA4VCI9r0GnRm/mE7/Puy
	HVWLAAtzImCqZHsUlFRp0CQ0rJRPNdMKGmm8HOe/FNN/rSwrUBMxZCBpjTbExfO+hnsz7UN8KXC
	PjIKoNkxpa7lt/fJzRyKfeVBlf0Pn1s8YCFeSHCAuH2Zx+YrohO/GQtMyekieqrexNQEiMkOaF9
	+byqrBz3Yhu3uXNwRhDRE0LD50bzN3o4vFpGT/a/04n9SWt/w=
X-Gm-Gg: AYBFou2x6al3nGa8atrPyaSxAllM5q9f8FJ0d98iDs5FFgBsJy1PDj3QtX0JiHOcorP
	YVjdfJ3MYxHGLiUPWHZ8IAxuw43UqdKhig5xeN+pdkMYwWkQMv42xbAqRks9s6J+isIY5tDvGXD
	J4pqf5OPajNwDpz79tWy2/YIj3z3kkmIfAwHOlIWm7HJvlF3Kf0T1+Hi6NMGg52jYK2fRDW8qK2
	i6egtOq3nwwmsx/VWkWClGUhVNj1wyZVB53/si3gaxhar9YKTZH1D4aQ1IE3WdqxTZbd5nlXISL
	1aOj30wf4RWICmLn16zii1is2U2H/tM925jb/VovF78/IJH52rYnZay2oOBv/F/WlxDxWZghs4c
	ybQGI8d/wJrWXf/bgM8cGC9SUWoHnk3eObNJ1UeWU8JEYO28aH0kTUlsG9GyVZ1O3rXnYCZeMWc
	Kmss3YSt1YRofr81UzRPE7fb023nljW5JJwRVQo6s+gobmYLxOPC4kWK8y4nyN18QZXipM4EUbj
	Mcuq350b/2iBd0hyybyCGwPeMdFBLOepVMBtaWzQZ1tLHF4ksXFE+UdxdeU5y/sxLrDOgY3iDNn
	NXn8vgex4uaslty457U1YPCFfpXrQPpp1JwpjvlTmS+eP6UOBLdgg2SNAxGpZcc98fUbqXmNRep
	R4qisB17SiQrfqP4q9krgDZ4zawm6Ks0prjep758UGY4Zt5TZUKVmxMuFxNR654AoJ13AgxojHU
	Dfbl6o5h1vlj5wph0ZjT+lfhjt
X-Received: by 2002:a05:701b:270c:b0:14a:5284:1bf5 with SMTP id a92af1059eb24-1b3b5fda3bfmr386308c88.13.1794250568772;
        Mon, 09 Nov 2026 10:56:08 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b11346sm952266c88.7.2026.11.09.10.56.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 10:56:08 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	christophe.varoqui@opensvc.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v3 0/1] multipathd: check re-added paths' WWIDs against sysfs
Date: Mon,  9 Nov 2026 10:55:54 -0800
Message-ID: <20261109185556.27139-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
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

During an array controller failover on an iSCSI host, multipathd
briefly put a path to one LUN into the map of another LUN, and I/O
meant for the first LUN landed on the second. See the v1 cover letter
for the full sequence.

Changes in v3, after Martin's review:

- No SG_IO. The re-add check now compares the udev WWID with one built
  from the VPD page 0x83 data the kernel caches in sysfs, so it does no
  I/O on the device and can't hang. The new get_sysfs_wwid() in
  libmultipath shares get_vpd_uid() and get_uid()'s WWID clean-up with
  the existing sysfs fallback, so both produce the same string.

- The uev_update_path() check that ignored a changed udev WWID is gone.
  With cached data it would be dangerous: if a LUN is really remapped
  and the kernel hasn't rescanned yet, sysfs still shows the old WWID,
  and ignoring the change would keep a path to one LUN in another LUN's
  map. Removing a path from its map is always safe; the add is the step
  that needs checking.

- check_path_wwid_change() is back to its upstream form.

Unchanged from v2: the check runs only on PATH_ADD_REINIT, i.e. only
for the re-add at the end of uev_update_path(), and only for paths
where can_recheck_wwid() is true. Ordinary adds never run it.

On mixing WWID sources: Martin is right that multipath-tools should
not use different methods in different places. But on RHEL 9 the udev
WWID for sd devices doesn't come from sysfs. The RHEL (and Fedora)
sg3_utils package installs upstream's 55-scsi-sg3_id.rules as
61-scsi-sg3_id.rules, with the comment "need to run after
60-persistent-storage.rules". So 60-persistent-storage.rules runs
first, and its "scsi_id --export --whitelisted -d $devnode" sets
ID_SERIAL; the sysfs-based sg3 rules then leave ID_SERIAL alone.
scsi_id sends INQUIRY over SG_IO (strace on the host shows
ioctl(SG_IO) for the standard INQUIRY and EVPD pages 0x00, 0x80 and
0x83 on every run). On the host where we hit this, the bad WWID came
from that SG_IO INQUIRY inside udev, not from cached kernel data.

Where sg3_utils' rules run first, as on openSUSE, which installs them
as 55-scsi-sg3_id.rules, ID_SERIAL is built from the same sysfs page
this check reads. With everything at defaults, which
can_recheck_wwid() requires, the designator selection is the same. On
that RHEL 9 host, ID_SERIAL equals "3" + the NAA designator decoded
from sysfs vpd_pg83 on all 18 Pure paths. So the check doesn't
introduce another way of computing the WWID. It compares udev's value
with the data udev is meant to derive it from.

What happens on a mismatch: the path is left out of its map and udev
is retriggered, up to retrigger_tries times. If udev and sysfs still
disagree after that, the path goes to INIT_FAILED, and the checker
later re-adds it through the normal path, which doesn't run the check.
So a persistent disagreement, for example a device where udev rules
pick a different designator, only delays the add (by roughly
retrigger_tries * retrigger_delay) and doesn't lose the path. A
transient bad value like ours is caught, because the retriggered udev
event returns the right WWID.

In our case, the kernel's cached page 0x83 for the path came from the
original scan, so unless the kernel rescanned the device during the
failover (we have no sign that it did, but didn't capture sysfs at the
time), it still held the correct WWID when the path was re-added, and
v3 would have refused the add.


Brian Bunker (1):
  multipathd: check re-added paths' WWIDs against sysfs

 libmultipath/discovery.c          | 42 ++++++++++++++++++++++---------
 libmultipath/discovery.h          |  1 +
 libmultipath/libmultipath.version |  5 ++++
 multipathd/cli_handlers.c         |  2 +-
 multipathd/main.c                 | 39 ++++++++++++++++++++--------
 multipathd/main.h                 | 12 ++++++++-
 6 files changed, 76 insertions(+), 25 deletions(-)

-- 
2.56.0

