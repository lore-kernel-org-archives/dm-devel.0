Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792624813;
	b=4dSupnQBqkNGtVsVrI6wojOWQaWK1V+/jg7qibRqE0JF6j4Fym0WCG1jNx8cWb+HiXyR
	 H6lBlnJ53U1VkmFm9ukjUj0NS+AKLCtQpqc03E/4TOpTEj6QIXsGE2wUd12FdUAFz/94N
	 Zp02lf/6NDXd7WtDo7nxLw/We5l8fFjn/isKGw9CkeYkNRruV5AB7Od71N6dCwCCFm27V
	 kLRHu1VGe7Tnqay97qA52oZerGnRAKia8SsxwCnDP2qw9x+aNzWoi9T2ouyYMKIvOziRu
	 E9W8Hh+UB9tNjPf+EevS/f6KuiKf0nfwV6x/YawvSkArnIct0LcnxhVxcrmR8xR8i9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792624813;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lRbLi5IkY5aJTBgXXArfj+04fZgL4ZhXH50gK7njr/k=;
	b=3XMTdSewJOucK7ABVyIDwCIm2QwPDSqZ0XyHhtWMH5qCIkH+YtdYpfdslEhvRj5wyDbl
	 GDaohK7ehIE5ZfYT1LI64i/n66pj+PHO6uOTJmiVBoC8E+pU0lwGbpmpggESH4dyTGKKy
	 hL9rH4CzBkJcWRujHqKIKehu7IYkHY2dotfiZpK2Zq/FRPqV1kMcz+LZ6V4Dplu4XcQsX
	 Lar1g+4mlUp0IZLE5ryus84O8vycu6wxKcwEoBMTiAzjEcvI0BfGHQciSfgjGIvfrbOFQ
	 nmhUIpqj/TJstKDrkWBwDPrXiLpIBPERHZ+aryTKNGGSW9bxdbnhmOHIEkJ3rVucBzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AqZ1FJgm;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38877606A31B
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 23:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38877606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AqZ1FJgm
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-15ea896ddc8so1774851c88.0
        for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 16:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792624811; x=1793229611; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lRbLi5IkY5aJTBgXXArfj+04fZgL4ZhXH50gK7njr/k=;
        b=AqZ1FJgml+34ql6yUK/13SGyL060J8AXr1RKa6OGGNHAsJ5bQThwLSBBSKpxtHPJGA
         pPp2u3rCH75hyodYSj6fSlJJxB7/40pcFjqPZNrxK/BeBrJr2JwDmV2OQ9lJXaDU9WOj
         EN+ucFnFkukf3ihTRQJTgAXpwDVMZhyZSwvsZaasfs4WNw8fZUveRUugOWsrkc3gpOHB
         DFoAxTlmi34cTsPeegqO5tC62tJqXDHJV/Bip2Qh4nno5F3lzWW+t+CWn6ZWS2ttF0Tl
         leJ2TxsfNVatNXo7pHBdgNt12id31Ud74NpTCfzxXTQxHUHREWW8Gm/fdmqNE9lpmLWO
         kfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792624811; x=1793229611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lRbLi5IkY5aJTBgXXArfj+04fZgL4ZhXH50gK7njr/k=;
        b=ZEVK+Wg6Bbwxt9abltolR/N8SFSD1NqjWM0Txv1r5qM3yAtRHyNqJ9hraCyYSxlbuY
         0JOd8vzhU0cF38Fo/xO5fsk1Bx8kv76/hC0eA3x87FLxGUDa8XXbjiA8qehok0f5Z30j
         3YJSP43OC695uvixcTQVkqOj1OkZhnDKbHmsgZLSFog40IE0TQmO9AI98pH7zHrBWf64
         JoDMIInpOmlofL0ghsaXlwjO3lu3TqgDenEB6yKUv9xjaiSazMyW/ZgXa3WB3MyCGuYl
         NeBOy/6jiltfTg0rDQadG19SxVKyG7yt3/IsJsuiIqDCoCuno7XseLjNbxwhhqbSU8v3
         JTTw==
X-Gm-Message-State: AFq9FYIGp4In1EIy0O7T0wlSzWHohS+pRkXJDuiWPXejQQsremWE8VpQ
	YLRgySaS2XMSIUVMIZsp/+SxyGqwhkVqPcG9qYnJ4m875/ITY1bMALPO3q4eNmBAqIxOiDIQ4m7
	VvDzHZk8u4tkggEONqsz21MdcKdJbngU9qisT3WIzduNsnc2xfUe7vqpb0E8hCmbMHFFXKmD/Dl
	h8SfK3I/12cb29IW8hq9dbx15N6j/dVW+hsAMMdzm1eo2lslw=
X-Gm-Gg: AYBFou3gaGgkkwnamxdvxDwi/VfQCjUDZB4Euq0FiHnrIkaPPujc0+3pInmt3VT3S0F
	jUV6bxQxogjyxOCSBwXlkwmzu83argk3tL2sisJCEsOu/C272X25CtGTOh2UUjFLkBX9kQ19IFL
	RqqFoW7u1VxYq6Dldc/VGeiu3ROMp3/32gga6Kq4ev/hbnzBFlmc1KfsdZzaRyUu0GmmI+Zzgs7
	wchHEKryO9Ghu3jymG5DFXfQLVwcYbs5GGCTo74+RvLrCpjNXYzzEnPMyfS8VgNQHQp9sezurzo
	1Tt9sUJ17a9g88+M2Fh1zN4prb+pjJIaYQTcPds8OVOd98nsDIuXqLpyOZ+9M8PbTiLRrHe3b/u
	DhIQOMTFVESTdhRFdiG4fsSL54YHBd/99ehT7RvNQxFK3I6Gjm9ebRxAqRX0IRLdmi7EppaWKoO
	1+MF8PXpNPCwxqNZxD629wOwVcyN1gjYHNC94+3wEZZuMFvm2eZCi/9oR5jLuCsU+UTpE3gq6yn
	ijCw8t6ZHft2dwbOlBH3s3uJKX0G6pA5+UzlWt2LNAsokkyHcSB0mK4wf6A69ezq8SkvqQEq9+P
	vVKJtiMtjBe7uvCyF6Fx1m3v00a88u3MhgN0vRHnh32x1OXLqYTOgwAWH91GZpeerosJB1wRos0
	b5/LbrPN398H5cgEdJCiXundg9Q7cGNJ3CeoA2vMpCeBqxrWgGA0qVQ==
X-Received: by 2002:a05:701b:420c:20b0:17d:7b45:f91f with SMTP id a92af1059eb24-19140a1dcdbmr3496354c88.32.1792624810880;
        Wed, 21 Oct 2026 16:20:10 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.111])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903bb7f098sm14372742c88.12.2026.10.21.16.20.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 16:20:10 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v3 0/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Wed, 21 Oct 2026 16:19:58 -0700
Message-ID: <20261021231959.69270-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <179261848556.617150.17378002460197797656.b4-review@b4>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
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

This is v3. It follows Martin's review of v2: needs_ro_update() now
fetches missing dm info instead of assuming a reload is needed, and
force_readonly is cleared when a load reads it rather than only when
the load succeeds. The changes are listed at the end.

Ben, I dropped your Reviewed-by because the needs_ro_update() logic
changed. The no-dm-info case reverses the "assume it needs to be
reloaded" behavior from 6e40bf92, so please check that you're OK
with it.

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
the map's paths, and dm_addmap_create() and dm_addmap_reload() clear it
as soon as they have read it. needs_ro_update() sets it for the reload
done for a DISK_RO uevent, and ev_add_path() and update_map() compute
it from all of the map's paths. With the patch, the 06:09:10 reload
would have found no read-only path and loaded the map read-write.

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

 libmultipath/devmapper.c |  17 +++++--
 multipathd/main.c        | 104 +++++++++++++++++++++++----------------
 2 files changed, 75 insertions(+), 46 deletions(-)

-- 
2.56.0

