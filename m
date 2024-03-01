Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC62959153
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 22:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332848; cv=none; b=KSpR8ZzFX9a/oYJvqK8ysigANeYumYUaIWYzoeSBtiu0xNvS7/BBxpZoTRK635EXmaJoQVqvBAmcpZ8sAPPcipX0tuLZNAhfd21YN+5FRL6YGUFV2xPKOHfqkeqgb5TqhGcm8MOOlgErGOHUB92vWoS9wFxDMq94Wk4wYbg0V54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332848; c=relaxed/simple;
	bh=h8Z64roH6CKO+65k2VXozXpGWok617hR6tKLqfEr9zU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pdO6msfvHR5da9DEhvjO3ECl6qAQyRTjZZG+KXKNZhC5Ywvkln2s2iid6foSUfrVgbDDqTTyDxGIFAaAL7qFFfao6afhWu03IC+sqC11ffG/WT9rA1jYQhk4pYsxiZW8RhLnIqQHj5jPS3ZWI/7CjpwmCrlGlgCa99G34ahuQss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q840oU2d; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q840oU2d"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a44888b123dso224391366b.0
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 14:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709332843; x=1709937643; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bgpbT3PF/ZPufkkOtFhdBKPBk7rUITFcmXO4uOkRyZE=;
        b=Q840oU2dWFmkMgnK75o6K9JQZDMNzLUpEQojBxZHjrc8q3luxpbMw9oHsqm75XvRx0
         2n8LOng9vpziLruX9jN0WrPBqunJfO/JFQ1S8tPceTN4YM6nOkq0GDYA+/ntK/VKD3y0
         VpA9rVxw/XHQwdEbZWn6k+eIaNS9lZ7X3yaf2yeI9VKpLwwLR4zHcRvixMzl1vNLsIy/
         yOUKDmCRtzvTvzoaJQumlpLJDZ9DOxPSK1fCA6ewpPOne2C1MMNZ1+4lc/mZOFeZAfis
         ky76y7ULFCJycWg2aasjmrqr3skdztChosOoeWXNUDvFnNb1rj5GNK4M/blQkBBt8dkF
         hhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709332843; x=1709937643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bgpbT3PF/ZPufkkOtFhdBKPBk7rUITFcmXO4uOkRyZE=;
        b=Axm4jGbg6t/Ht9AdkmyXv8U3yneCNLdjUZeb6yS9O0/Y4A6QXf1/GXtfIhQBPxJLWJ
         cXDThPaOLx348dIPpfYQbKezJs9zn4q+4pBPxGrrs5o3vxruYflS7nCHme0Xt6/g+f12
         nojxkNDULrmoy5otov25+DxbUNr1slzhvjHCWBtB3vUpp3jYqeDd0sRvToj5Y+HRJDNw
         LooYyqH98/vygcV1dfJHJ9NTjbQq6bWVOYRA2PgSHFaAIbYRa1C+7C/w0yxAgfoZzHRh
         ugMfp7zrHJnPq9txfsrBtRwq+CeNlhvB75F9HcuV7gFfo/Kat9hbW1W8RRwyPk1ow/4K
         6YmA==
X-Forwarded-Encrypted: i=1; AJvYcCUgP+LlcG6QaHdvnusdO78jM8ZttvhzM2oFJoUG0Nre6noc9Gj+fkpmD0wWd23uLDeziKr3qMOzZaBHuhaqLCcmkMIX/C2JRcY=
X-Gm-Message-State: AOJu0YzmUTtbL8mHJmEZWfBsD5VxDfCFwDWkTXij3vFUsfKQs2ZbytHG
	kajVlOs1SSDrl+Ivxm4L5wG1JmpYgs2K9BjavpYF76OXXei7zk5InNKRAyFcLbw=
X-Google-Smtp-Source: AGHT+IG4KVtQNjL+aPONLyovBkgVLOJNoXyo6BaA6dBftxeuQjZ9K/K6hMMVCQLHxAi4TnPryDKlsA==
X-Received: by 2002:a17:906:4955:b0:a3e:69ff:141f with SMTP id f21-20020a170906495500b00a3e69ff141fmr2937481ejt.33.1709332843176;
        Fri, 01 Mar 2024 14:40:43 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id k14-20020a170906128e00b00a44b91ae6d4sm472269ejb.33.2024.03.01.14.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 14:40:43 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/7] device mapper udev rules rework
Date: Fri,  1 Mar 2024 23:40:04 +0100
Message-ID: <20240301224011.11117-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All,

here is a draft for a rewrite of the device mapper udev rules, as follow up
to the previous thread "About DM_UDEV_DISABLE_OTHER_RULES_FLAG and
DM_NOSCAN" [1]. While I have taken care to minimize the impact on
other udev rule sets, some changes to both the multipath-tools and
systemd rules will be necessary. Patches for these are in preparation,
but I'd like to reach consensus on the dm part first.

As discussed in [1], the idea is to use just one udev property as "API" for
later rules to determine whether the device at hand can be probed or
otherwise accessed. This API remains DM_UDEV_DISABLE_OTHER_RULES_FLAG,
because it is widely used by other rule sets. This means that the flag of
the same name that is set in the DM_COOKIE needs to be saved and restored
via a different property. For this property, I've chosen the name
DM_COOKIE_DISABLE_OTHER_RULES_FLAG, which is hopefully awkward enough that
authors of non-dm rules won't consider using it.

DM_UDEV_DISABLE_OTHER_RULES_FLAG is a logical "OR" of various conditions
that should prevent other rules from accessing a device. This includes the
cookie flag, the "suspended" flag, and the "noscan" flag
(DM_SUBSYSTEM_UDEV_FLAG0=1). dm-multipath has more such conditions.

Because DM_SUSPENDED and DM_NOSCAN are now purely internal and don't need to
be restored from the udev db, they are renamed to .DM_SUSPENDED and
.DM_NOSCAN, respectively.

For follow-up rules, the semantics of DM_UDEV_DISABLE_OTHER_RULES_FLAG=1
is "don't probe, don't attempt IO, and keep existing device properties
(if any) until subsequent uevents are received". It doesn't mean the
device should be completely ignored, and it doesn't mean that the block
layer stack on top of the device should be destroyed. Contrary to what
we discussed in [1], I didn't try to come up with flags carrying these
other meanings. I the LVM layer doesn't have the necessary information
for doing this. The only flag with "destroy" semantics I am aware of
is SYSTEMD_READY="0", and it's up to systemd to deal with that.

The first two patches are minor fixes that I came up with while working
on the rules.

[1] https://lore.kernel.org/linux-lvm/9d50edb0-baa4-4a01-a2f0-136dfdb79937@redhat.com/T/#t

Martin Wilck (7):
  13-dm-disk.rules: import ID_FS_TYPE
  10-dm.rules: don't deactivate devices for DISK_RO=1
  10-dm-rules: don't restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from db
  11-dm-lvm.rules: don't restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from
    db
  dm udev rules: don't export and save DM_SUSPENDED
  dm udev rules: don't export and save DM_NOSCAN
  10-dm.rules: bump DM_UDEV_RULES_VSN to 3

 udev/10-dm.rules.in          | 32 +++++++++++++++++++++-----------
 udev/11-dm-lvm.rules.in      | 13 +++++--------
 udev/12-dm-permissions.rules |  2 +-
 udev/13-dm-disk.rules.in     |  9 +++++----
 4 files changed, 32 insertions(+), 24 deletions(-)

-- 
2.43.2

