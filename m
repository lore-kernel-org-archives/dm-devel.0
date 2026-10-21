Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792607292;
	b=POGWE2GiOVmOdh1wsFGHr+QhcKe7ZQQ+athdg7RR8ZFDjhPwKx0T4qYpPCz8U+D65fCP
	 Gi+HYwaNGpPbhbQBISSiOAuI7nuJMoVBEU7lcwxaV1JDAw4Noy+uiNB0wux+kP30WqMtR
	 oPX9qtJWnTeVvTCXZAy8IkyLvGN34haVLCgFcVBJJUwhyjx0nBflGE+SU2y+8SUTv5V0y
	 r/j5QXcTm2Os1nd26DuFE0o/UUrVhWgDwPzmT1rIkKb3p2eo39d/hqm3fU2UhVjNWNRmz
	 R/qFGkpmKi/6aHMl5bR0eA8O/ZnL8qeZfhnW1MwYjMZ6WmMGg1y3BaZ3fREldr0BkOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792607292;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=tmkeaXAPyOSqcZdeouZOZXT0U0i2SEvacyZUDdI7lgQ=;
	b=NOGFpvkVWCdHNA0jrbiByNq2/YKQS6REbMB5B0xdhF6N5gMH19QXIaNIdW5U8esVQe+7
	 biVZOGuApjhOif9ta2DCtS3i/2Xm3KGm0XXSuujJhfucZlxuh/9b4t3Wz1n7TGSo6J+i+
	 VNPsqELPl1UHYDaKtT5a84a262WPlshOhCXTMKm7eYZrw8EpSyHHF5x/Pb7pwjaYPcTIv
	 L/chmkn5D9BAmO/1aano8y64PeOHyQHlaHyGFBssJO6Hf1CMdBEuvalogewQ/sUvRe6Eq
	 dBXaigJQ9LevxX9fskqNM7licYxR/GuDcXwm1JdTj+HDCq/goaEdvDwJSs6+khXnHjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=MQG4p5LW;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F43606A319
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 18:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77F43606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=MQG4p5LW
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso887079eec.0
        for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 11:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792607290; x=1793212090; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tmkeaXAPyOSqcZdeouZOZXT0U0i2SEvacyZUDdI7lgQ=;
        b=MQG4p5LWrIyXmDukvsCnlnuE6/8fLEsgjHHCK6A+UWTSZMSCZlnES294/+Aqv+bn32
         MJxwenIZMexqFFfefagGEEErkGwjKKdtK81ys6ylicWBhJLcdnkw375yrWCIyfjXNuHj
         VrQzuIkfk6TGigzjfJjrCk9RqXGjZezZ2ZliPNOf0mhlnyg5cCmHyl1UfoTWthGD8n9s
         LDsEvPwGrBt1A9JnBktgAl0gLmYM0VFUylKMeAMxHcFu2QVBVgJrQVxtgpKTpK3DEUfe
         Prt9Q8iB+3oMStPbK6VFe9wTChK1HixsJZQNV1O0jntn5NpKJiWO7lIN7Q6n+fvRFmdc
         XHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792607290; x=1793212090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tmkeaXAPyOSqcZdeouZOZXT0U0i2SEvacyZUDdI7lgQ=;
        b=G68p8R0JdNcCEeez4/9BdZYiXomOEfMQfPHNsOOw1Par6C0FpTyiWxO8AHrXYV5YaI
         Qrlq0Dovk1cA0hvj9kpjiikgGqgCICwaCt848FNZ3caFqKv7dFsyv7Xj78PUdanbDJux
         gVtcU+jBjvAvTodBXDt97jZpCYalluZ6Rd2beKxxSQw/R1GNzMQrmPIqt4B6sDXG1eTy
         j0vyf2lZrQfNqY8Q6Vm/Nvb/5NN1acdSA/R6bhu8Ynpl4hddQ/XnF/fs/8wcIS8WBXQA
         S+icJTz4FWyA92T0Uz8DRYm9mHWQQ+bVTMzYdmyP9Hubp8G/lK3fFcXrXb6uQ3B5ovhs
         gJtw==
X-Gm-Message-State: AFq9FYJjNBImTAQjaPYUvL8CGT3cvs9p1GdApkzvq5U204fQPBKqbhix
	WsS9jUU7Zii6u86zoa7MqlH0H2/LrYZv1gbPycBOy4geNeyEe0lYrF1OHqun5x71EpeDAtnpm3K
	MTIvoCcODAAmKegp/J83rb4Q9F9+1TpsdAoqb7kInu51wvReNU/KT0WFcfSh46vAmzn6aiY0ICs
	IE7CdbOnSZjwqJ0czokDBhGGCgZGJ+VOh7cw41JQSlBGMpWkg=
X-Gm-Gg: AYBFou36++qPgqrH4ccS3LjtB5zgpCfdY16H8ZEw47UFI10lSvEAcCW/ES5x6nznqwU
	rVcdWGcDRpX7qi/4PpB2VR2vYYttbXzTWuR6kB9T/v5pfytqnjoY3eGlnlvwlWw8ErsQhBb1sWZ
	cRtkE1qdP+jcA7tMoOU9V06s9eYALjPrMFr6KDmTMrZkG3ic1+UhGH3or+fZsU4vCU94xzisu5F
	ki2WCgA1WZ3jYrOWE3ef1ZMSNMa/VEg4fFJYCmkg3rjCkiQHiEPXkKPO7I3I8p7GL/a7XvvEv4E
	33Tbd4wO6c/pjn9/pGvyx0nAQr27EmeVyLDkz2qzJnSqNNnbqTq7ni3az+uu1ZI//v6/q7jF+bu
	Y+iHerPZ+A0lMVkv5scy3TtpZhWjUkbX5056EZqcn9kzgeoN0u9AXQMJmm6sxbtmCueX3VQ2z3m
	3gwQpHMC4HbjWLX0DhPkKS3lboV1I8nVesjKT4QahkIaqYhyZg7m3AuZtYLHHr/jK4XBKl8Vz7+
	Sx9LO9gSLrOCjQ0emsow9Wwz/eRBt54R8XrNEGhv69GA+danC4u+pLuurXcwqZSzV4a2QFwPvP/
	XKemCv5ZROSo8id8l7wdzpIIg+bZ1kI8f5oITHbS/w0jzecrM3zLFWe3EF04szKypJ3wYO+X9+i
	zmPfhR6N5zF76N9C37rguoUONAdzJTTFPWD1DVRjwj4mPxucWDFK7
X-Received: by 2002:a05:693c:65db:b0:366:8efb:bab9 with SMTP id 5a478bee46e88-3674e450f24mr4481593eec.11.1792607289917;
        Wed, 21 Oct 2026 11:28:09 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc8439sm9841561eec.11.2026.10.21.11.28.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 11:28:09 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v2 0/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Wed, 21 Oct 2026 11:27:58 -0700
Message-ID: <20261021182759.30106-1-brian@purestorage.com>
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

This is v2. It reworks how force_readonly is set and cleared,
following Ben's review of v1. The changes are listed at the end.

A multipath map can stay read-only after write protect is cleared on
the storage, even though all of its paths are read-write. It happens
when the map's paths are removed and re-added while write protect is
set:

1. Write protect is set. The map is reloaded read-only.
   uev_update_path() sets force_readonly for that reload and clears it
   afterwards.

2. All of the map's paths are removed, and new paths are added while
   write protect is still set. ev_add_path() sees a read-only path and
   sets force_readonly = 1. Nothing ever clears it.

3. Write protect is cleared on the new paths, one after another. Each
   path's DISK_RO=0 uevent is ignored while any path of the map is
   still read-only.

4. The last path's uevent reloads the map. The reload sees the stale
   force_readonly = 1 and loads the map read-only, logging "reloaded
   (retval 0)".

force_readonly only works in one direction: ev_add_path() can set it
but never clears it. If the new paths had been added already writable,
ev_add_path() wouldn't have set the flag and the map wouldn't have
stuck. The paths have to be added while write protected and then
cleared in place.

After step 4 nothing reloads the map again. A rescan doesn't change the
paths' ro state, so it generates no DISK_RO uevent. And since
multipathd now sees the map as read-only, needs_ro_update() also
ignores the next DISK_RO=1 uevent for it.

If two paths' uevents happen to be handled after all paths are
writable, the map does recover: uev_update_path() clears
force_readonly after its reload, so the second reload is read-write.
That makes the problem look intermittent.

Example
-------

We hit this on RHEL 9 device-mapper-multipath 0.8.7, whose
ev_add_path() and uev_update_path() handle force_readonly the same way
as current master. The host's iSCSI sessions were torn down and
re-established while the array was write protecting the volume. From
the messages log, trimmed:

  05:48:27  ...114d8: reload [0 51200 multipath 0 1 alua 1 1
            service-time 0 6 1 135:272 1 66:624 1 69:720 1 129:560 1
            132:656 1 135:752 1]
  05:48:27  sdsd: map ...114d8 reloaded (retval 0)
  05:51:04  kernel: sd 24:0:0:48: [sdaer] Write Protect is on
  05:51:05  ...114d8: remaining active paths: 0
  05:51:07  kernel: sd 29:0:0:48: [sdaoi] Write Protect is on
            (and four more new paths)
  06:09:01  kernel: sd 24:0:0:48: [sdaer] Write Protect is off
  06:09:07  kernel: sd 29:0:0:48: [sdaoi] Write Protect is off
  06:09:10  sdaoi: update path write_protect to '0' (uevent)
  06:09:10  ...114d8: reload [0 51200 multipath 0 1 alua 1 1
            service-time 0 6 1 67:880 1 70:992 1 130:848 1 133:960 1
            65:1072 1 67:1056 1]
  06:09:10  sdaoi: map ...114d8 reloaded (retval 0)

The state afterwards, as recorded by the test:

  dm-106: ro
  sdaer: rw  sdagu: rw  sdaix: rw  sdala: rw  sdand: rw  sdaoi: rw

The patch
---------

The patch sets force_readonly right before each load from the state of
the map's paths, and dm_addmap() clears it when a load succeeds.
needs_ro_update() sets it for the reload done for a DISK_RO uevent,
and ev_add_path() and update_map() compute it from all of the map's
paths. With the patch, the 06:09:10 reload would have found no
read-only path and loaded the map read-write.

Changes since v1:

- Set force_readonly in needs_ro_update() when it returns true,
  instead of in uev_update_path(). The DISK_RO=1 case uses the uevent
  again, rather than rereading sysfs.

- Clear force_readonly in dm_addmap() on success, as for need_reload,
  instead of after the loads in ev_add_path() and uev_update_path().

- In ev_add_path(), only compute force_readonly when need_do_map is
  set.

- Walk mpp->pg rather than mpp->paths in needs_ro_update(), since
  mpp->paths may be stale there. ev_add_path() and update_map() still
  use mpp->paths: both call adopt_paths() first, and mpp->pg doesn't
  contain the new paths until setup_map().

- Move sysfs_get_ro() above has_ro_path() instead of adding a forward
  declaration. The function is unchanged.

Brian Bunker (1):
  multipathd: don't leave maps read-only after write protect is cleared

 libmultipath/devmapper.c |   4 +-
 multipathd/main.c        | 113 +++++++++++++++++++++++++--------------
 2 files changed, 75 insertions(+), 42 deletions(-)

-- 
2.56.0

