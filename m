Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793665924;
	b=L+18jNpIis1k9PIKzgnj5TENdvWGUK/aQWFouzDvV1yPdXIB6x1oCFjjcPcL+O7d79Uy
	 HsvWuGyebJFU2cbgjx00IKNb7NhcbSo3J5RFsL+7b1/HLi3X/m30W8VGgk3azCEJZwF09
	 fjH3rHILXULAxBAbILO9lTYnf5oiajO2bTaYZBS95Zbq29o2ErPUNYVgF1rxELUSWx/60
	 nVroOM/XgSwIMgXeO3TGwyQl7GqnJsV+f2iFd5LHKqVAopDPojzahPI7J+TISqHNyxqEQ
	 hc0hbWrGQwSujMye31Q7ZQBO4U+Rvg9rIrpWNZnDCTMHAqR1FOG7wA8yTgyOOYTaNjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793665924;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=FlcEDfBvZScpGyVCWsE8gul/GUUmf6aoDe6iDpv+PLM=;
	b=4eVR8sz6oVDOgcJxVhr9Lyh1O4/kTXxkeLPARv4ML43nFOIJYxLOLCdspiStIJGPhtwd
	 kdnaojiXBbuBqNtAqg+fvlSuQQkfkbpIiMg3Y6jkiJz90WxbvIw3CPE5qa223yWdGdbhl
	 86y9NVzcBBpSznJBhvTIRt8oO3uvlqVghfTpiYY6kl8iKQgXJYAYJX1zNa9HciZcUKqwX
	 Uu0dhMZPT+CqCQbYk7aVS9yOMjmmBVPrCLMgNMIUHNRJ71bX4umBY2YsL6IV8R0fASmeQ
	 DWK6tRKWkZmyswqxTjHaPpg+l2CA8ZQtMW5Hj/SlONxzTKoxpVpIvl2lsJ47XghncXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=ZWw1ZepL;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A956606A324
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 00:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A956606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=ZWw1ZepL
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-14394530ec6so4677035c88.1
        for <dm-devel@lists.linux.dev>; Mon, 02 Nov 2026 16:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793665922; x=1794270722; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FlcEDfBvZScpGyVCWsE8gul/GUUmf6aoDe6iDpv+PLM=;
        b=ZWw1ZepLIxd++HI++n7QEwP37CfGF1n4AaXocM5eGCu77Yj53XxlVV0+eckg2IkDg8
         MkfXTpBFRNmkYs8kowKaamWcRT35NJi3OD6x7HI1oUMfKrnAnk+UA7oaB/chlp25Vv8h
         Bj+GP4YEOS/1MOVbq007KbzTgBLBEYKJrcXpo7WR9izCqET5F8Xp/wIb4Wmo4/okKHmf
         pDAbOerzWZtCR+flYztkKatmTwyN1GI1150G5RnWZxkWZxymBaOxf9ektOIpcCgoag9T
         hi+kKaWco4Chko4YBSS1hhtCXxaoK527DsCl8822SNtDoZ5E3ihcB2LdqyQ6Zu1yNUSu
         ZK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793665922; x=1794270722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FlcEDfBvZScpGyVCWsE8gul/GUUmf6aoDe6iDpv+PLM=;
        b=X2GdGiAhmP1DdJdDgPZuW3d+xZ4ARDRaQIiIsn6fEEUPSuFGSEiMwSM1qPo6B2hGd1
         l1yj3l2QdLU4GZyTAGse4wZaOjffXyWMyYW4ZTspSUBYOLlfumU/xAl0ky90j2ZpCmUT
         1hsMiAwBeir793shBUVu55fAGQmN3eMUdwOLbJy7RoV8jTZVkYjUmaWdtWehGz/EQjP6
         DN0LWtnHLAlgOpbyd5lHd+f30Y0vWqjAzD2Y2R04M1zqqll0qPhI2Noq4k+gmOusjGbD
         LUeYBAyX0pH4RyOuEZvQ88OLZ9VFGcAQVtVbQxXBIkiKJDPvqyLLNZz80vuVqKgoo+0u
         a3rQ==
X-Gm-Message-State: AFq9FYLFu0RnVrUiBJg9nSnazLwIqwsRmgtXfKAbAzOn6PIoO7FCSQB1
	p9NQgCm3wO3VivR2oAVSeLVZHspBfyZYlR7MFh7Jq3/pXvEgS7c0cI5Kx+VELeTLxh5ZBgYSm1j
	zWDmmrNEJDnaxLzSLmsdlMmqVwPKKsaQo3s6xuKQGOQ3AANLQjaHul7C7tv4CcsyjPrjMYz8YzF
	oPOp6mKgGgcryoDXA2Lr6AlLkfwEcKHLfOEF6FUVsUul86rr0=
X-Gm-Gg: AYBFou0ekNJhAvD9nbVfEr702J9HwGqjNSb7H7vXRU6VUf1JzJ62qh+agfM9KmWbjrj
	IjuDC6fjicebX7/U1cpVXhmiqa4K69Uj3io7E4LxvxiDEQrlu0DqRIreUinr9Njxf8JDN9jQijN
	QXOU+bu0pweJQXXHbxD7wtr/FDZL9exL+0usJGhwvcMFn4CWDIORPhb9E2raDcFGcx9vb5xi00P
	N7vTsHBLq5ig2+BFSZXYgZit/QSVTGhbVom38uORd07Zu/VKuBPMdtJxRJ6wnhDhzPRkW6YdEwP
	MXJ2jMinMp0u0R746bicC2npX0EZ0vwFF1NlJLfGII51QOblFIaMTf+EnbxtA6vP9aomufRn71k
	TrSATVu4jJxAAqGUYyJelPs32hjuF61HYDvbMWl5cZ6FbtYFSBSD+Y4mlX4XtOs6iAKu6sZxxps
	M/xKMvvGcU+73gWMAN33Rt52tSZvYddUh5UYAvIuOBoU47elJzuLXHYiO9EcdffhCI9eGh4IRK9
	04HH2jthiY2s1FPMb48YEHxfJXqIZtGULfOpPDCPOKGOkVJyXxjGbpLFGQuvGfwCPw7mOJdxVhC
	c7rD7EV4EpMa046vNbRCRkK3iouGX47gpCn1gb8iIB6/etUEOAE+EFr0NKJMqF43EeXoBK13kxv
	lPBCw908QW2WwVq7nWWeZ0mCkpBpqFSKrrNY95Ispw7CiXNqDbRipNLRMYZyz55NmBz4tTjdo5z
	Wt/MEyj6oX53xdDEb2EIRHpJ263GE+M44eiOnNHQsNseSk2Q==
X-Received: by 2002:a05:701b:2806:b0:19a:ace1:793b with SMTP id a92af1059eb24-1ac5d888f2cmr18947979c88.18.1793665921450;
        Mon, 02 Nov 2026 16:32:01 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b38ac58sm36417225c88.23.2026.11.02.16.32.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 16:32:00 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	christophe.varoqui@opensvc.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v6 0/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Mon,  2 Nov 2026 16:31:49 -0800
Message-ID: <20261103003150.78513-1-brian@purestorage.com>
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

This is v6. It follows Ben's review of v5: needs_ro_update() no longer
takes an ro value and no longer tries to avoid reading the paths' ro
state from sysfs. It recomputes force_readonly from all of the map's
paths on every call, which removes the special cases v5 needed. The
changes are listed at the end.

As agreed, tracking the ro state per path and dropping force_readonly
altogether, as Martin and Uday Shankar suggested, will be a separate
series on top of this fix.

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
the map's paths. dm_addmap_create() clears it as soon as it has read
it, and dm_addmap_reload() clears it once the reload has succeeded.
needs_ro_update() sets it for the reload done for a change uevent,
from the ro state of all of the map's paths in sysfs, and
ev_add_path() and update_map() compute it from all of the map's paths.
With the patch, the 06:09:10 reload would have found no read-only path
and loaded the map read-write.

Changes since v5:

- needs_ro_update() no longer takes an ro value. As Ben suggested, it
  sets force_readonly from map_has_ro_path() on every call. If the map
  is already read-only and has to stay so, it clears the flag and
  returns false, since dm has to reopen the paths for any read-write
  reload anyway. Otherwise it returns true if the flag differs from
  the map's current read-only state. This fixes the v5 case where the
  map was read-write, a path was still read-only, and nothing was
  reloaded, and it drops the "keep the flag after a failed read-only
  reload" special case: the flag is recomputed on every change uevent,
  so a failed reload is retried on the next one.

- uev_update_path() no longer reads the path's ro state itself, from
  sysfs or from the uevent's DISK_RO. It just calls needs_ro_update().
  The uevent still only tells us that something changed, and sysfs,
  which the kernel updates before it sends the uevent, is the source
  of the ro state. The "update path write_protect" message now prints
  the new state from force_readonly.

- A path whose ro attribute can't be read in sysfs counts as not
  read-only, instead of making uev_update_path() do nothing.

- The rest of the patch (dm_addmap_create(), dm_addmap_reload(),
  update_map(), ev_add_path()) is unchanged from v5.

Changes since v4:

- dm_addmap_reload() no longer clears force_readonly up front and sets
  it back on failure. It clears the flag only once the reload and
  resume have succeeded, as Ben suggested. A failed reload leaves it
  set, so the next reload tries read-only again.

- uev_update_path() takes the path's ro state from sysfs instead of
  from the uevent's DISK_RO. The uevent only says that something
  changed. The kernel updates the ro attribute before it sends the
  uevent, so sysfs is current when the uevent is handled, while the
  uevent itself may have been queued behind later changes.

  Note that this changes behavior: any change uevent for a path in a
  map, not only one with DISK_RO, can now trigger a read-only reload
  if sysfs disagrees with the map. It also avoids the pointless
  reload that 6e40bf92 describes when a rescan's DISK_RO=0 and
  DISK_RO=1 uevents are handled after the rescan has finished, since
  sysfs then shows read-only for both. The cost is a sysfs read of
  each path of the map per change uevent, next to the pathinfo() call
  uev_update_path() already makes.

- dm_addmap_create() is unchanged and keeps the read-only shortcut.

Changes since v3:

- If a reload fails, dm_addmap_reload() sets force_readonly back to
  the value it had on entry. The map still has its old table, so a map
  that was supposed to become read-only is tried again on the next
  reload.

- Move the walk over the map's path groups into map_has_ro_path().

Changes since v2:

- In needs_ro_update(), fetch the dm info with dm_get_info() if the
  map has none, and return false if that fails, instead of assuming a
  reload is needed.

- Clear force_readonly in dm_addmap_create() and dm_addmap_reload() as
  soon as they have read it, instead of in dm_addmap() on success.

- I didn't add per-path tracking of the ro state. force_readonly is
  only computed from sysfs right before a load, which is rare, so the
  cost of reading sysfs there is small.

Changes since v1:

- Set force_readonly in needs_ro_update() when it returns true,
  instead of in uev_update_path().

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

 libmultipath/devmapper.c |  18 ++++-
 multipathd/main.c        | 144 ++++++++++++++++++++++++---------------
 2 files changed, 105 insertions(+), 57 deletions(-)

-- 
2.56.0

