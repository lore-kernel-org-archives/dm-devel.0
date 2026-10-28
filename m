Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793147092;
	b=GSXg5fqhQakrPdd/SxgBFOk9w/FrHycXk8at+zJTVWjBv3XcBDmU1o5YV56BB7b8zm7G
	 Sw0wOFrF01h99vhGR7XSCR/SGUN++UDMyrRzBUuFYIEfiQPPJiCMdAFOnJqHS7zTUV8So
	 dTukNmR7EIbqOo3CpSJ59Sv4CZSZyrrfQo2kkAf7kCPvMt+xWwZlwllZS107YqntIjVcY
	 EZssrASPyyoD59O0p84wzyKmiajMxenKfacZHj43iELAD3ApHnQ/NfuK4YMeAEgiXpILf
	 Nl9x8FfWYnML4cfllyG4w1QH1ugZdxlv3oiKeNfRHJEkCzXSBgSBjgAQt6lfzyXOb+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793147092;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=XdX6JcKrQH3xw1+6AOsyr0uskjWA4qF6gINeE1xFnf0=;
	b=NI64QEEDDDJvqqJP/sfXmezGJ7wwoX/N8QFBZ0wg03mq2opfGaFWAhv0mbGCs2UM1XNt
	 Bz9/vFE+9AkasQst3/n2stBbIJ/hHa4E2FHpbZfspjxZiQ0pvJdMFSG5x9s+EdSGLLT9d
	 QH63h6shShebc96UrO2EdRlAb0SozKIl2/cq05ApOQriETqz6aNFSyy0vpX2UY5eN8g0Q
	 HHlMFi1kgnXLVlQnh+DG3bVOPrayTyDHbMi0RQDk3/WzLCV4//HxSZqK1MQdHECDSXH50
	 T7AvEKJC1aVqVaHSxu+IesnoY7VpjXfIium5HxlmEfFGgo8rmZC2P8B3mocibg2fEog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=L4l4tg8P;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF2606A31A
	for <dm-devel@lists.linux.dev>; Wed, 28 Oct 2026 00:24:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85EF2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=L4l4tg8P
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-369f33df08eso806003eec.0
        for <dm-devel@lists.linux.dev>; Tue, 27 Oct 2026 17:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793147090; x=1793751890; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XdX6JcKrQH3xw1+6AOsyr0uskjWA4qF6gINeE1xFnf0=;
        b=L4l4tg8PKkOBVqFde9Y4racGC7DVRuL7mYAzEewPMkogPoB1WpbLvbs06iuWUqpdxi
         fHMcXB12XU6SFoghuKE78Yt15jL8BqlIAUBIEIaaHzceFHD5Jgo49/wPNukvlHS+XBv6
         2KKKzPDOW4l8fNF7HdOiPTGD5ZY/i02TLzRbazpPv5iRD7jkCd8l3qTlU6CVMaWl7Eqs
         e75qfSwbFBVQLxE98ovIbyltTK7YBtlh6RMzgo90WvBBef/rj3W3dzawHZug+2S5YD+b
         yRIo4WUZfnugmbAqpS0RgdcMO6SC+MgLLHFKe/xO10ntra4NQ7B2lSdT6V+2F6LfgEsn
         e1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793147090; x=1793751890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XdX6JcKrQH3xw1+6AOsyr0uskjWA4qF6gINeE1xFnf0=;
        b=0Jl1W1h632joVCn6N9zl1jeH8ZgU1hEn3/40IHc8D6G/onIlaBuPlbMd/+OyhLZibD
         YU/IV4wJ139/pGePgiAZ3t2XJ6hbKOHEtSwV9eYqkGYoLK3enHvJxTOw/glDCXeFq/El
         3pOywLhQ1qjB0DEJ7cNschxAzIKKCHcVbNmgZzEUhIwck3V5ysJ0CkRwZSjRO2hdeqXk
         HRbbS3Aj54HbInBqv68ATq4jWNxJPj59fRSwwmwmVTQP2FYhW+fhPwqbHdsj8IG45RcM
         JTTUapDjhUUQPaHhHbvfTDg2C1d7SsoM5R3mgE85Ya3yIr5+RZnGC86RNZxjeZghsDEG
         PVxg==
X-Gm-Message-State: AFq9FYKI1F0agqrqzb6Y9EFFXqBoR0srIMwq7GKYecM25fOd2qS4B8CT
	Aopw3h/q190/Pv6aeugbP7c8/h4vm9oWSF9sQ8+lBT18sCelizgtiecr/wOosBlSxd/KRN9SyUg
	wP5EzdMzI5XNWouRa4X+mIuVW+o+9nu09YpzrRAClN3LzgECv+xGwHCNfFYUxhRSCaTi2JB4qZY
	MkQsotai05wjI2w9R9bVk3qenF06Ja+L7gAPv5L7/Plu7hIJ0=
X-Gm-Gg: AYBFou1wHzD2XBw76IZpT8yoJSdUToiELbwCnIh2M6o9Xrv/Os+gcKt5rJPjfgoXG+M
	BIA2zS6TaSxaDz1jrU0OetZC9a4QWQa6JTF/gqJJoqoq22SVTNwiIsNsKdl1WPcYDH5ueXBX2UO
	HPUlpcBt9nCX4kkaWaTwv20JxE1CkbuAtzKMQ5EINXZFE8EPQDpIL1QtvBmeKh0ZEbMkn155PVu
	Cssd79ZfqZuRuhEVr/73tI4cDgln4DMljbjw6vFVDkcMhlPLhBz+AsgpxM974uUWl1R7oSBuOkN
	IwHu/BOfwDLf0b1Z4TBNRFUUYliIdowU8YMvssvvKAfZFWx92lzzdfYtkLSlW+bJrMbCD4/3uBq
	aqMctq4gYPRgBS9wq/AWPudYsND1GxD76jo6gyIB3n7auNs7/d9y++V/p3bGoM1tan8PPqiNp8D
	H32NImE+YziA5Pt3qf9qNX/FEYWzpMYgUR0cssueJVMen3dMW5lQVPjvpVoWnNCmnbhSUgVCCbU
	hm+I4ZmpOVmT9y/XUXvuwZwCBFn3IpXbflb+F2wmOXwtx36SrexexVPLaTyXV/0GzMi0qJ1tZtc
	4JxzgdKnmrufwO/Ki/OKQMR2kUjVYteU/Z5GhWw9o+CqY6zR0LIQMDh+eIrSUteQAYK0IT4WGEM
	z5J8MTq6dCcqVP6rWBQ7NvTUxThUbmJBoLYq2lmESb7qu7yiQuB1H/w==
X-Received: by 2002:a05:7301:c009:b0:36a:713:a76b with SMTP id 5a478bee46e88-36a2007fcc2mr1046640eec.6.1793147090035;
        Tue, 27 Oct 2026 17:24:50 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.111])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a23641e78sm620510eec.0.2026.10.27.17.24.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 17:24:49 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v5 0/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Tue, 27 Oct 2026 17:24:36 -0700
Message-ID: <20261028002437.39990-1-brian@purestorage.com>
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

This is v5. It follows Ben's review of v4 and the discussion with
Martin on v3: dm_addmap_reload() now clears force_readonly only after a
successful reload, needs_ro_update() clears it on every false return
except when a read-only reload still has to be retried, and
uev_update_path() takes the path's ro state from sysfs instead of from
the uevent. The changes are listed at the end.

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
using the path's ro state in sysfs, and ev_add_path() and update_map()
compute it from all of the map's paths. With the patch, the 06:09:10
reload would have found no read-only path and loaded the map
read-write.

Changes since v4:

- dm_addmap_reload() no longer clears force_readonly up front and sets
  it back on failure. It clears the flag only once the reload and
  resume have succeeded, as Ben suggested. A failed reload leaves it
  set, so the next reload tries read-only again.

- needs_ro_update() clears force_readonly on every false return,
  except while the map is read-write and one of its paths is still
  read-only, which means a read-only reload failed and must be
  retried. This covers the two cases Martin listed (map and path both
  read-only, and path read-write on a read-only map that still has a
  read-only path). In the dmi.read_only == ro case, it only walks the
  paths if the flag is actually set. The early returns for ro < 0 and
  for a failed dm_get_info() leave the flag alone, since there is no
  valid state to decide from there.

- uev_update_path() takes the path's ro state from sysfs instead of
  from the uevent's DISK_RO. The uevent only says that something
  changed. The kernel updates the ro attribute before it sends the
  uevent, so sysfs is current when the uevent is handled, while the
  uevent itself may have been queued behind later changes. If sysfs
  can't be read, the uevent's DISK_RO isn't trusted either, and
  nothing is done. This also gives needs_ro_update() a valid ro value
  for every change uevent, as Ben asked.

  Note that this changes behavior: any change uevent for a path in a
  map, not only one with DISK_RO, can now trigger a read-only reload
  if sysfs disagrees with the map. It also avoids the pointless
  reload that 6e40bf92 describes when a rescan's DISK_RO=0 and
  DISK_RO=1 uevents are handled after the rescan has finished, since
  sysfs then shows read-only for both. The cost is one sysfs read per
  change uevent, next to the pathinfo() call uev_update_path() already
  makes.

- dm_addmap_create() is unchanged and keeps the read-only shortcut.
  Ben, I read your "There's much to be gained by pulling out the
  dm_addmap_create() code" as "not much", in agreement with Martin.
  Please correct me if I got that wrong.

Changes since v3:

- If a reload fails, dm_addmap_reload() sets force_readonly back to
  the value it had on entry. The map still has its old table, so a map
  that was supposed to become read-only is tried again on the next
  reload. This covers both a failed load and a failed resume.

- In needs_ro_update(), the early return for dmi.read_only == ro now
  clears force_readonly if the map and the uevent are both read-write
  and none of the map's paths is read-only, so the restored flag can't
  make a later, unrelated reload load the map read-only.

- Move the walk over the map's path groups into map_has_ro_path(),
  since needs_ro_update() now needs it in two places.

Changes since v2:

- In needs_ro_update(), fetch the dm info with dm_get_info() if the
  map has none, and return false if that fails, instead of assuming a
  reload is needed. This also removes the separate path walk for that
  case.

- Clear force_readonly in dm_addmap_create() and dm_addmap_reload() as
  soon as they have read it, instead of in dm_addmap() on success. A
  failed load can no longer leave the flag set for a later, unrelated
  reload, such as one for a path group change. needs_ro_update() no
  longer needs to clear the flag itself.

- I didn't add per-path tracking of the ro state. force_readonly is
  only computed from sysfs right before a load, which is rare, so the
  cost of reading sysfs there is small. Per-path tracking could be a
  follow-up if you want it.

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

 libmultipath/devmapper.c |  18 ++++-
 multipathd/main.c        | 144 ++++++++++++++++++++++++++-------------
 2 files changed, 111 insertions(+), 51 deletions(-)

-- 
2.56.0

