Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11952010E1
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748681; cv=none; b=iJVQ73Xl7xbfQio5VzJmk/orNY9m8qTgJgkwPLxdvOIKeJ4P9EgJJOAkWZC33msyNV933bT9qOdBVdxjFFYDIJjRKiGkEjXIgcItNfRjzZQlT4qBU/4l75yAacocFKMqF1QB8wLW79gSsXDSqp1+XpWMENlHRyu7psfK3zSzuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748681; c=relaxed/simple;
	bh=pJO2Azn4qHtpo8WwFwrnecAE0hSrdF50hsM0GWT8hSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vjf981qkWOwXwKEjPkQUfAo7LAxuNzFHedIeels5Ggc5gvkfwsK9OzhtAGYqa5aM4zE6bmUSGQzPCmbXRAW91PEfcyjpF/TTJg7v02kTqduSs7uUwLLFkhNq7PhNY20Dt4kJQRZKqXbGQaFOf1Pkc+1VJb6rcnujqVnNttkol4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VpGtsF5N; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VpGtsF5N"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3824709ee03so177635f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748677; x=1733353477; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TRU83PLpj1VY5A9sZ+9bWMjgZ04Vw+MMhCtI4c5KCK0=;
        b=VpGtsF5NNSV1+izDr6l96qyaZ9EDYpYBuU6cluq/bMY50F0ayo2chQorERb75as+7V
         AhDGcWK3xpOQAMF3eWjou0Gbj1bJS3rnSd4C/rkycwS5p4tuFHHLQcHws4Qh7cLIUe3z
         snpVDHYP1XQBHvBzGnWcK/A3tBwt8m94JIK3hp8b7UIqiw2T7SjUTGLWGzgM9dCfovqZ
         UQNClK7xuxQ7Dvj3nJYRNaN7ZlQ6I41V76DJ65Ezil/6RwDMerjnXB3y541h3QSDU3HS
         +E0phTislexZ4sXFfG+RPbvson/Vx2g9PYk+HgyG9rVcMkgvtSsYVSgSdhflHGQag5jL
         1iMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748677; x=1733353477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRU83PLpj1VY5A9sZ+9bWMjgZ04Vw+MMhCtI4c5KCK0=;
        b=JhtIkoQodwMnmUbLOHxQjcz/sgEpHjT7/FnJHBfzOKWXZX5+iVIDPZF0Ofm0cOSXWn
         BosDU8DzCp5GVrEHsjownQyKw0w/AGmENZzZVzw0Mind+eOATlmmhcTOKJtFOILmL3RV
         YSaBYnstea9KrV3WXi4KJtC52iKhzZ/pWW9yHTYkGlJU6IiEstrinmCmH8tUv0Hzyj7S
         oKlxHdo3NdqdV3CReusw5zg6kEiP6j2cyFiyZTXOt7Wq+jM4b482mcVL15iJsizTH4VS
         tPmG2eAIsez4PPXKkIWq0uiToyb1E1hXqkmrwjW+nSIec8aaXV31Mh+74Niho1SOpce+
         QCIg==
X-Gm-Message-State: AOJu0YxYF63bGqdYsj2agWQ3M73UeBr8KMCAKnQ8kj8SydRnHL+b1DW7
	83c90X8Jojo5S0SnGMrmJJUGDSk8Z7Jihlb5TWJV2gR1sDktOIt86wZdH/ewH5g=
X-Gm-Gg: ASbGnctUDFmi5+jEmOun/8EJ4UNBCWl2vyrIn42FpJHeVGEI+Eul4FFZ/WJY63BBFRI
	u5y6PSnLWq8ykNDGSsaZdt4vtT/EeobGsXAdGcqAa2uFgnPVqPk57yxSr1fVZETyL1kMW/72FKw
	RglmzgtfqaxRa8nXP+ZMmWU1iWV5nHaGc0GLxukgE6C/5AO+M/2t/ykPQwuJEfZktPTh9Kg8fkL
	1Y4o2Hvc7aKxYZU6stKrD7aLfeAfQu9mPXkWuuoV2SbIWFB92VeHVQj4l6KcAu1cbWio0Sdrowe
	lOYcTooe/TBseRloi8+bh9ty/MffHiIrMn6H
X-Google-Smtp-Source: AGHT+IHgeFxPGU+rrNodpBWALKqMqHZVYLUgZBxctceRPPrC1UN7l1KE02EAuxe9XE+hIfCU6YL7wQ==
X-Received: by 2002:a5d:6d0b:0:b0:382:450c:25ee with SMTP id ffacd0b85a97d-385c6ed74c9mr3972025f8f.40.1732748676868;
        Wed, 27 Nov 2024 15:04:36 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ccd2e405sm79817f8f.22.2024.11.27.15.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/8] multipath-tools fixes
Date: Thu, 28 Nov 2024 00:04:22 +0100
Message-ID: <20241127230430.139639-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch is an attempt to fix
https://github.com/opensvc/multipath-tools/issues/105.

Patch 2-5 provide a re-implementation of pgcmp() without relying on
pgp->id, as discussed during the review of v1 of this series.

Patch 6 and 7 change the way multipathd triggers uevents when
it detects configuration changes, motivated by
https://github.com/opensvc/multipath-tools/issues/105.

Up to now, multipathd had done this basically only if the "failed" state of a
map had changed. This would miss cases where e.g. with find_multipaths strict,
a path had been added to the WWIDs file and "multipathd reconfigure" had been
run. In such cases, the paths would be added to the map, but udev would still
not see them.  The same holds for changes of the blacklist.

With this set, when a map is created, or when map creation fails, multipathd
checks whether udev already sees the correct properties for the device, and
triggers an uevent otherwise.

When maps are to be removed because of configuration changes in
coalesce_maps() (for example if a WWID has been removed from the WWIDs file),
multipathd now also triggers uevents for the respective path devices. This
is only done in coalesce_maps(), where current configuration changes are
reflected. We can't do it after a "remove map" CLI command, for example,
because that is by definition a temporary change. If we triggered an uevent
for that, multipathd would recreate the map it just removed as soone as it
receives the uevents.

Patch 8 is a minor log message change.

Martin Wilck (8):
  libmultipath: fix handling of pp->pgindex
  libmpathutil: change STATIC_BITFIELD to BITFIELD
  libmpathutil: add cleanup_bitfield()
  libmultipath: move pathcmp() to configure.c
  libmultipath: re-implement pgcmp without the pathgroup id
  libmultipath: trigger uevents upon map creation in domap()
  multipathd: trigger uevents upon map removal in coalesce_maps()
  multipathd: improve a log message in coalesce_maps()

 libmpathutil/libmpathutil.version |   1 +
 libmpathutil/util.c               |   5 ++
 libmpathutil/util.h               |  10 +--
 libmultipath/configure.c          | 124 ++++++++++++++++++++----------
 libmultipath/devmapper.c          |   9 +--
 libmultipath/discovery.c          |   2 +-
 libmultipath/dmparser.c           |   1 -
 libmultipath/pgpolicies.c         |   6 ++
 libmultipath/structs.c            |  31 +++-----
 libmultipath/structs.h            |   3 -
 libmultipath/structs_vec.c        |  15 ++++
 multipathd/main.c                 |   6 +-
 12 files changed, 135 insertions(+), 78 deletions(-)

-- 
2.47.0

