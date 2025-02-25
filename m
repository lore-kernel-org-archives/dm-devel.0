Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4739515E5A6
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740499075; cv=none; b=PzWfVBISdEqKJhHldDShy2dvc37EsxqKtDb7KQHriRzYlWQu/njDQIgmqW/NWVOCdCELvg6ZQTcOO57DV5rZTnI7ueKMoui7xOdQG01KcMR0ifyQgGkIVkgnjHW+S4bkfwJ/QI+6LSKB755bc9nDo35D7fK2Kam8oTXWDeb0/uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740499075; c=relaxed/simple;
	bh=6qiZe+xP+p3+fE/fVGSawwzS5zMvoBvDTM5VmBaz5gU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oU9eUA0ZlEXCMrM5tdrbOMMRW7OwOXjl4CnLMRloJ09twCiClhxikA05eUkxsa6TPGxj+DwgjpX89FelIjnaPOK0QvmofdZ854dn/Y2QoZ6oRUma4KCNMyQki1Q6+dUmlXn73RweWemfr4dN9b6pck/0XqI1wbiY3zlnSf/HPbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=AhQmgg0J; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="AhQmgg0J"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4397e5d5d99so36524045e9.1
        for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 07:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1740499070; x=1741103870; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yAuHojxKJ1KIzCnQrRKlDonzN9Ic83Tuk28woRWNuZ8=;
        b=AhQmgg0JlRhUOvZyES24P3NUWwU+9kz/gNLPajqpG39/giWjGzPVe4BQ5nitvjI4xN
         6vmE+t+uxLFM0qqd5H0WX9mIe8SI9xDnjvwjRtwMYExAOrozWVZqEjyp3MZbDuaCBDJb
         8wK1ApiXMBuoKDVgtTSGANdtGbtlWtAHC1hBfkgoKPQ1YWBARNCMuUxjsf9BYjo0WoqE
         BEuDAYRLeeePLdMiLUHR75tfYZpsArXRnlB+MRTpMvM9LK8ij/v67uJjqAlkxgtWe9j1
         rO/e7Kl3YARfqvkr4jgOcAC4P9z2SmIcJNhjczpd6J36qs6vess1/60ajEr2X2Oq6lHC
         S4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740499070; x=1741103870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yAuHojxKJ1KIzCnQrRKlDonzN9Ic83Tuk28woRWNuZ8=;
        b=josnrsIx/X0t8DW/sDhm2qHARxQXb+csMPMvPDM1LiowXd8ePfYYz9hHGk9rbCSImB
         VYTGFGE0HGsuPxXA1Kd90x19aPbJG1CJHkS2e4b49e7t9JPBqjkKh1WTcKmiKH9+/w8B
         GV12V7kORq5EMux8OHdzaT4Tq6AqMZNcv7sS9zhYesc1mUofGh7ZjIXw4ESZTvhGITX7
         z9uyB8U1rYClepCENFOutsnmezIOcouCkpG9F9NWAd+GWkCB+jZ01jbf3Yzuuay/Q4+u
         TBrrjJAjAUBd+HdJFpO2K1hgkSACP66OklcCCU0RujDx8ZW3oJ5kwySctlI8wYTDcdDt
         CzrQ==
X-Gm-Message-State: AOJu0Yx0AkTWkuOrrjbm2Us0d0yXfm9oijTn2sWmhmmfXXof5QdNnpfO
	nXEq6f4sewHl2x9r8xPvR0IrRRCRikYf91tR1WVwtbPboc+jglZfZ+cd8BegUcjUIwGEP/8ot55
	K
X-Gm-Gg: ASbGnctQGh87s5L/jreFtLb5mz2IBqwkit9NRbeRNCPhmcE8gAxXdMCg0mmJRbhM65J
	aqeGnoTUpFhmiyVmv8d7GSnnBp361rUyZFq7l77+WF5mpjowEvQ+TfxJcAnCGQx4bXU54jIXLEY
	awKUnaTX0VsDO+YBAKTZIedrk+oe09LAS7p+hQwWIWyS46usumVxTfhO+w3cq5/TeF+HkQJiAHh
	cX+Uj6QcEEkZ+Bdvxa5CXvQv9x3utLZijv23iTxjQFchiOMUcXY2Vkayv11d0IpPvv3TDYMxnZG
	olDKkt7RqScfas/3XOAnMbXmNVmzWtsJSjAnXIf+/BJkhyf8n/g=
X-Google-Smtp-Source: AGHT+IFfq38GJOxvXmm1Hu8e8CW9j66XXbEStEBBGvDm/lwVGfxrd6uY1d2YcyJ2yCpU7CWMd89oHw==
X-Received: by 2002:a05:600c:190c:b0:439:a0d6:a54a with SMTP id 5b1f17b1804b1-43ab0f8e095mr31182305e9.28.1740499070371;
        Tue, 25 Feb 2025 07:57:50 -0800 (PST)
Received: from somecomputer (ip128204144132.rev.hostingnetwork.at. [128.204.144.132])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390cd8e7228sm2767865f8f.72.2025.02.25.07.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 07:57:50 -0800 (PST)
From: Richard Weinberger <richard@sigma-star.at>
To: dm-devel@lists.linux.dev
Cc: upstream+dm@sigma-star.at, mwilck@suse.com
Subject: Issues with cold-plugged devices and systemd/udev
Date: Tue, 25 Feb 2025 16:57:48 +0100
Message-ID: <2927047.aYr0rKQ5TD@anvil>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello!

As I understand it, the current Device Mapper concept requires that udev
be up and running while a new DM device is being configured, as mandated by
all udev rules.

I'd like to highlight a case where this requirement is not met and explore
possible workarounds or solutions.

Configuring DM devices, such as dm-crypt, before systemd (and udev) starts
is common in embedded systems. This typically occurs within a minimalist
initramfs or via the dm-mod.create=3D kernel parameter.

In most cases, this issue goes unnoticed because users are only configuring
the root filesystem. However, our scenario is different: all dm-crypt
devices are configured before real userspace starts, and userspace later
mounts them in various ways. These devices are also listed in /etc/fstab,=20
which is processed by systemd.

Since the DM device is created before udev is up, the cold-plugged DM has t=
he following
properties:

$ udevadm info /dev/mapper/cr_sdb
P: /devices/virtual/block/dm-0
M: dm-0
R: 0
U: block
T: disk
D: b 252:0
N: dm-0
L: 0
Q: 12
E: DEVPATH=3D/devices/virtual/block/dm-0
E: DEVNAME=3D/dev/dm-0
E: DEVTYPE=3Ddisk
E: DISKSEQ=3D12
E: MAJOR=3D252
E: MINOR=3D0
E: SUBSYSTEM=3Dblock
E: USEC_INITIALIZED=3D56919818
E: DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG=3D1
E: DM_UDEV_DISABLE_DISK_RULES_FLAG=3D1
E: DM_UDEV_DISABLE_OTHER_RULES_FLAG=3D1
E: SYSTEMD_READY=3D0
E: TAGS=3D:systemd:
E: CURRENT_TAGS=3D:systemd:

As a result, only the raw DM device is present, but systemd does not recogn=
ize
it as ready. Consequently, the mount unit dependency is missing, causing the
boot process to fail.

In a discussion with Martin Wilck, he suggested that suspending and resuming
the DM device might trigger the appropriate udev rule processing. Thanks a =
lot
for that!

Indeed, after running:

dmsetup suspend /dev/mapper/cr_sdb && dmsetup resume /dev/mapper/cr_sdb

udev properly processes the DM device, and systemd recognizes it as ready:

$ udevadm info /dev/mapper/cr_sdb
P: /devices/virtual/block/dm-0
M: dm-0
R: 0
U: block
T: disk
D: b 252:0
N: dm-0
L: 0
S: mapper/cr_sdb
S: disk/by-id/dm-name-cr_sdb
S: disk/by-uuid/f1b7c2ce-55cd-4f85-a192-cb43f55a781d
S: disk/by-id/dm-uuid-CRYPT-PLAIN-cr_sdb                                   =
                                                                           =
                                                           =20
Q: 12                                                                      =
                                                                           =
                                                           =20
E: DEVPATH=3D/devices/virtual/block/dm-0                                   =
                                                                           =
                                                             =20
E: DEVNAME=3D/dev/dm-0                                                     =
                                                                           =
                                                             =20
E: DEVTYPE=3Ddisk                                                          =
                                                                           =
                                                             =20
E: DISKSEQ=3D12                                                            =
                                                                           =
                                                             =20
E: MAJOR=3D252                                                             =
                                                                           =
                                                             =20
E: MINOR=3D0
E: SUBSYSTEM=3Dblock
E: USEC_INITIALIZED=3D56919818
E: DM_UDEV_DISABLE_LIBRARY_FALLBACK_FLAG=3D1
E: DM_UDEV_PRIMARY_SOURCE_FLAG=3D1
E: DM_ACTIVATION=3D1
E: DM_NAME=3Dcr_sdb
E: DM_UUID=3DCRYPT-PLAIN-cr_sdb
E: DM_SUSPENDED=3D0
E: DM_UDEV_RULES_VSN=3D2
E: ID_FS_UUID=3Df1b7c2ce-55cd-4f85-a192-cb43f55a781d
E: ID_FS_UUID_ENC=3Df1b7c2ce-55cd-4f85-a192-cb43f55a781d
E: ID_FS_VERSION=3D1.0
E: ID_FS_BLOCKSIZE=3D4096
E: ID_FS_LASTBLOCK=3D131072
E: ID_FS_SIZE=3D536870912
E: ID_FS_TYPE=3Dext4
E: ID_FS_USAGE=3Dfilesystem
E: DEVLINKS=3D/dev/mapper/cr_sdb /dev/disk/by-id/dm-name-cr_sdb /dev/disk/b=
y-uuid/f1b7c2ce-55cd-4f85-a192-cb43f55a781d /dev/disk/by-id/dm-uuid-CRYPT-P=
LAIN-cr_sdb
E: TAGS=3D:systemd:
E: CURRENT_TAGS=3D:systemd:

While I can live with this workaround, I'd like to ask for further input.
Is there a simpler solution available?

I'm also open to implementing changes in either the kernel or udev rules
to better handle this corner case.

If no alternative exists, I'd kindly ask that this workaround be recognized
and preserved to ensure that unconventional DM setups, such as those in
embedded systems, continue to function properly.

Thanks,
//richard

=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT UID/VAT Nr:
ATU 66964118 | FN: 374287y


