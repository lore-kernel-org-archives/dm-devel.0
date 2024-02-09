Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECAF16439
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 23:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707521273; cv=none; b=qZjrEqN+9ow7ds8JA3anYWSrpjzolLV5ryzDwRP2AnqkKmvbilWhtgTYrFUbrIuDgdF05NMp8ZMXXdni7dksCrPtdH1EC676i3NhZRbeA93Qkbzp+T7Pr7F46W91Az7pd3jXq4GNQgcJzCydvOohr5IxuOxqufe878W6gff70vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707521273; c=relaxed/simple;
	bh=PmfTuqgut+W4Nb0fccGynFZ7Zy4taE8I4Q0hIriGw8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cxKOaueSp9ocCHeDzSClXitVlAlGRGoCkZMaGh/v0g3yA+T9er4dtsammEHdXefXpzRwZen4ma/r8fZNfUACOASmCpOrsU3CSryr1gWPN22tg8bPc1jysZA16BzKNG7pdWlrky0RArA9Muvj74GephZH6wpwwcSzvgeOmLWpuEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KGfdsH0G; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KGfdsH0G"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40ef3f351d2so14857065e9.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 15:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707521269; x=1708126069; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=npOGXi0XfiQDecpf6zBBKppJFanrLKrU8uW1FsyOTt8=;
        b=KGfdsH0Gwjix9hy2/5BZXpLnEM5Lq8q3GtXi/yBwDAzslOjTYE+p+Q+kOeNQHKlaA0
         EfdgWaEVid/dJJ7dnTaVbLNKMEIEcPoEEdeMEydr6M64l8RhFAWO8IVcIIb37Wx7/pil
         KU59XhwN+rSxsiqieEDu80nUckenLpQAzVuinu680xaHLLKJqFipWz1ofNt+lCmmSGR0
         kQuZNCw/7+eHFMHPG7Q/r4SHeXQOIRMoflEDwKQgAprsPPUfFtIWi8IQmULs7tSpwwAt
         zPlVW6aHCmViLXUlW0WZM7GLlA/xWPuv20npff4bDtJ3fd/MACyKVC0pHxioz/3ADEiC
         /u1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707521269; x=1708126069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npOGXi0XfiQDecpf6zBBKppJFanrLKrU8uW1FsyOTt8=;
        b=t+lE30xDiyTKfVBrtmANNC2ig+hihVjgd2n/1juZnp81gtuWkjkCJ0Ku9PSwivElX/
         zRhR0ZmfskqLxA4i9V+XjKqYqku+VYna2z61QnfoIERwNve8/NWT4pkjQFlorfRHU08F
         kkt73IyVrAXKrCWuruezvdhiVVAcqsRt8ylzj3yQIiuEgZASsZS7zeog4XkBAXiLqmmZ
         rRQQoLiRCq11PgBu0Lt6hXb5WMaUHepByby4osWrvBaJ327xAhNaymMtyIz7ZONSrzNe
         a/oY9PS01dzeu48cquegLDxRDfUWn/m927kwtBjf6GclaDSiS/cw9KRKD9Zai3fN9NZ+
         o5QQ==
X-Gm-Message-State: AOJu0YymlD2LR6sG5s9T4Ow/gSCa6ltgbnW1bFmq5nwOyks+kBCUF9cB
	5ZAlR2RtlNzdKyjv1JWEPwYemoRwottEyAF78mGpucg5B7fUV7hWeh3h9ce30Us=
X-Google-Smtp-Source: AGHT+IE1ilcc5/BQn+xEmuI5zsZ2SoLtQXWthwipjIaMx6m/g0WyztHQkisEXK0F96yirVJHCjeQ1A==
X-Received: by 2002:a5d:4951:0:b0:33b:1b37:ea32 with SMTP id r17-20020a5d4951000000b0033b1b37ea32mr2549945wrs.30.1707521268728;
        Fri, 09 Feb 2024 15:27:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWUK1qedF1S0KBeqj/ic+OacEVtekv7V+75uZVE1OpcxdJMonOl+mQFGCWsZeRK9A5qN7m4TS/9dbtJ8wJbkQkm/PPod2xaSF2dodobQNaOygXMa9XLAAVhdmfZ1F8pDId09h4Kc3/B+0mqUQkp+bTAFnCANfCZQCK3rWFInqzJAgFrp9fitNod
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id h17-20020a05600c315100b0041087022567sm896222wmo.34.2024.02.09.15.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 15:27:48 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH v2 0/7] udev rule and CI improvements
Date: Sat, 10 Feb 2024 00:27:28 +0100
Message-ID: <20240209232735.9791-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes wrt v1:
 2/7: This patch becomes trivial, DM_UDEV_DISABLE_OTHER_RULES_FLAG
    is not imported any more, and my previous statement that DM_NOPATH
    might be set in an earlier rule was wrong; the test whether
    it's already set is dropped.
 3/7: looks different now because of the change in 2/6
 4/7: there was a flaw in the previous version, .MPATH_SAVE_DISABLE_OTHER_RULES_FLAG
    must always be set. z0-dm-mpath-late.rules was broken as well.
 5/7: looks different now because of the change in 2/6
 6/7: new, another glitch that I found while working on this code
 7/7: was 6/6.

Except for 1/7, I dropped Ben's "Reviewed-by:" trailer.

Changes wrt "v0" ("multipath-tools: udev rules and service improvements"
posted on Feb 5th)
 1/6: fix logic as pointed out by Ben Marzinski
 2/6: Keep importing MPATH_DEVICE_READY as suggested by Ben Marzinski.
      Don't import DM_UDEV_DISABLE_OTHER_RULES_FLAG any more.

# v1 Cover letter:

Patch 1-3 of this series are actually a v3 of my previous series
"multipath-tools: udev rules and service improvements" posted on Feb 5th.

Patch 4-6 are new. 4/6 implements new logic for setting
DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD, as discussed in the thread about 1/6
of the v1 series. 5/6 fixes a variant of the race condition that 3/6
addresses. Meanwhile I got positive test feedback about these patches; the
partner isn't observing any more errors with these patches applied. Thus
while certain types of race conditions (reload happening between
DM_SUSPENDED test in 10-dm.rules and blkid or pvscan calls in later rules)
are still possible, they seem to be rare enough to be handled in a separate
patch set.

6/6 is an unrelated new patch which is necessary to make CI for arm/v7
environments work.


Martin Wilck (7):
  11-dm-mpath.rules: use import logic like 13-dm-disk.rules
  11-dm-mpath.rules: don't import DM_UDEV_DISABLE_OTHER_RULES_FLAG
  11-dm-mpath.rules: handle reloads during coldplug events
  11-dm-mpath.rules: don't save DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD
  11-dm-mpath.rules: clear DM_DISABLE_OTHER_RULES_FLAG for coldplug
    events
  11-dm-mpath.rules: Don't force activation while device is suspended
  multipath-tools: Makefile.inc: set _FILE_OFFSET_BITS=64

 Makefile.inc                     |  1 +
 multipath/11-dm-mpath.rules.in   | 67 +++++++++++++++++++++++++-------
 multipath/Makefile               |  2 +
 multipath/z0-dm-mpath-late.rules |  4 ++
 tests/Makefile                   |  5 ++-
 tests/alias.c                    |  4 +-
 tests/directio.c                 |  7 ++--
 tests/dmevents.c                 |  8 ++--
 tests/sysfs.c                    | 57 ++++++++++++++-------------
 tests/test-lib.c                 |  9 +++--
 tests/wrap64.h                   | 48 +++++++++++++++++++++++
 11 files changed, 157 insertions(+), 55 deletions(-)
 create mode 100644 multipath/z0-dm-mpath-late.rules
 create mode 100644 tests/wrap64.h

-- 
2.43.0

