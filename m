Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0322EF0
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137211; cv=none; b=QKRdjD2ot4inN4XdUm1FAsCrtypaQswrj1eEyshjrko35NoQkXtely8aNSsKvJxMIaNfxpXmqL5MOY8bu/Ydd/UxG99H+lWYkQ9dPhQU+Ku2nYOyc1Ey794/F9psi/jEBXOjbtAX/1M1YxlF8hd+6233Kul2Wb0cFQbOEqvAgMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137211; c=relaxed/simple;
	bh=C6j1GOtK/b4SZynpfqmg+CPFzh/76smc05t7/E0NIX4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cYHX6pPwOg+vBsoMK4gQcsiv1mHqfLC6OgDrXz2Sqn/qzh/XFLpwgE2w+ghzcY9w/Xgfw5FgdUBIAedz47upn1F/2VbNvF6tnp+7QEHBFdx2dripwzZOhHxHPOiGRU/deOcnpuHwDOY3FsFcIvkZvoQns1UL5n3q3CNcAlfj7qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O/Yo/rT+; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O/Yo/rT+"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5101cd91017so5652775e87.2
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 04:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707137206; x=1707742006; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ioQdq1v4nm5awpqcrNZUpLmq1a65Z05XymoIOU6TeXw=;
        b=O/Yo/rT+ipfcTZue/AFOhoJttUJ1mu/rluPfG1XVoFkC9a7K4KTZxNXskFHwIaMRXZ
         IvdIp+9OINy0H09jCCQK7ZMQPNROpjk2tcEw0gxUNN3lGJ1GmQqRoqfKtt0QZ6vBbUTV
         miImQ3jVNuTqbELu42GhwYrhuCUqRlYmEG29XSmWCfc91RffOdoH3kZHc6UcVQoyfYOV
         Qxs6lCb6ydgRyfIT6Q5E92D7UKWzlv86y3quoT5pE6rHeFfTLBZ7nmQDmGYhL0Whl60+
         4BGgepXKdAvK6a8O963Asji/YyGcnN0p51uE9Bl7jqul7Ejernr7Yp6aZM1269WSVd91
         AqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707137206; x=1707742006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ioQdq1v4nm5awpqcrNZUpLmq1a65Z05XymoIOU6TeXw=;
        b=VbjF01EjVXT1tmrusO+bU0Zs37J8fIBF9IGHXd5FlYXBQiq0k98qKwQ/0IQ2DdC6nk
         YG8HJI6qaNS1ylhtvsU5Z/nYo7OCS+Q5FKy82Fr7n9EpV5MVe9p54OFi0rKueZ2tbwSz
         zY4q6A6oX450LGI+4DDuFU2ARdlQ3TrpEGkgMnjOBn8cEOODJBRE5I/pqrTOP/LUULjs
         bimTjq03rD49gXZfqbPyREeVO9zy2mlp94IFX30IgAbD/yZZQ79Q9TuWzkKqvozes1bU
         vHZi1ykdpEy+dK4xwX1UCsEP/+9sXkHKQU2Bem8fkMsfzf+rUrCZxLKJFWmfV9tGadgN
         J83A==
X-Gm-Message-State: AOJu0YzDG8LMdMmp5dsSwl5/c1Xk1AU0Zc+Fuxc05E+xVygSCs72ncDc
	VqxzMes0Gtn0FokjlqT0BjMUm0hoKT3kdGAqnSMWJH1Agm9IBu5yASEEEBftvcg=
X-Google-Smtp-Source: AGHT+IEmzSbuI4VsJhZwguwPXEJso4yzM/cR+a1FEjpiQazB1JLgAD/aYhGTRgRxeevENp0M4Q2nfg==
X-Received: by 2002:a05:6512:508:b0:511:3a96:e385 with SMTP id o8-20020a056512050800b005113a96e385mr4730965lfb.30.1707137206185;
        Mon, 05 Feb 2024 04:46:46 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVCTauppcN+fLqy0/e0TEySvGs9DNuWSHqvads6hHwTUXgYyEnVxSKGC7ox9I8PbE6Pp0JZxqwWVQSZ+By6a+ZMzHQMnNVXSvI8DLsqswX6xYNqO7DpHBZ+R+lfKiUNUHJH4gVUN5FXDC+iDC6u4o4seVe//lWHYwgBExkxsCI8eZKSLibUihf0
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id bh11-20020a05600c3d0b00b0040fd24653d4sm7018323wmb.36.2024.02.05.04.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 04:46:45 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 0/6] multipath-tools: udev rules and service improvements
Date: Mon,  5 Feb 2024 13:46:32 +0100
Message-ID: <20240205124638.17877-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first 3 patches and patch 5 are minor fixes for the udev rules.

Patch 4 fixes an issue that was observed in partner tests. Since we dropped
the dependency on systemd-udev-settle.service, it's more common that
multipath sees paths being added to existing maps during boot and reloads
the maps. If this happens while udev is executing rules for an uevent
related to the map in question (most importantly, a coldplug event),
the rules may see the map as suspended, and will refrain from scanning
the device content.

https://systemd.io/BLOCK_DEVICE_LOCKING/ doesn't help us here. We would need
to take an exclusive lock an lock_multipath() to achieve that, but since
5ec07b3 ("libmultipath: use a shared lock to co-operate with udev") we
don't. We _might_ consider re-introducing exclusive locking, because the main
reason we don't was that udev would discard events for which it couldn't
obtain the lock. Since systemd 250, udev has a retry logic for such events
which would avoid this problem. We would also need to implement similar retry
logic in multipathd, though. For now, and because we need to support systemd
< 250 anyway, I've come up with the workaround in patch 4 (first tests went
well, but more testing is still needed).

Patch 5 is a partial fix for the the problem that multipathd socket activation
starts multipathd also on systems that don't need it. See
https://github.com/opensvc/multipath-tools/issues/76. More far-reaching
approaches have been discussed to avoid that the user needs to enable
multipathd explicitly if multipath hardware is present
(https://github.com/opensvc/multipath-tools/pull/78) but no solid solution
for that has emerged yet.

Reviews and comments welcome.

Martin Wilck (6):
  11-dm-mpath.rules: don't import properties that are already set
  11-dm-mpath.rules: fix list of imported properties
  11-dm-mpath.rules: use import logic like 13-dm-disk.rules
  11-dm-mpath.rules: handle reloads during coldplug events
  multipath: udev rules: use configured $(bindir) in udev rules
  multipathd: don't activate socket activation by default

 .gitignore                                    |  1 +
 Makefile.inc                                  |  2 +-
 ...11-dm-mpath.rules => 11-dm-mpath.rules.in} | 49 ++++++++++++++-----
 multipath/Makefile                            |  2 +-
 multipath/multipath.rules.in                  |  5 +-
 multipathd/multipathd.socket                  |  4 +-
 6 files changed, 45 insertions(+), 18 deletions(-)
 rename multipath/{11-dm-mpath.rules => 11-dm-mpath.rules.in} (73%)

-- 
2.43.0

