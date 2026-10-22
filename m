Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792712946;
	b=0De+1E2/2aWf1HYddoV7yWF8P5TJoXzVC19IkJt+YdfDSSkCxmSlcSDhfT4QsOtpDCAO
	 T7SqbHtnHJlw1SsPUf3QTpFaSziByCvBvhvzWR3S0mCbtnLWZFGVSNLdYMK71nfWRlsJo
	 7iWdQb1gOMh2uucHcmIum5Fqk1jvy62/IPDVap1yRoDEk4fPTBzIZMbCFd7UHrQxfvmkG
	 RI1xPfgUrpMrWcx1aYAYcdSp8NMFK8mOTsT6GFvvHWCCviSsLKw10/Uaebe1hmu4WT4KP
	 wegA5C/8/zbM7hQ9antfYJy13g+HGgY3Iz3gu+Lf7k7Hm4V+i23czEv+fN37/x4BgTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792712946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=golt6MBb4CKBDxqCfaMC4QkCui2d3YXf98bP29jjeQ4=;
	b=xJzs9tr1k9W8sMUGMRqe91S8FYAxcfjcXggMLtL3rceq+2FeVnzrZxazM3dWNrHplLIf
	 2XiXZ18H9wmoJyO3rnOu6pf9Xw94GmpCJ5lhGh1r4sLCkxCOgrdWtrpowyNwiCNnhFde5
	 Tjx84347A3Y/nxxjnC14d2gWS3sPnaFnZwGsYYQzfXcOsndh3UGLd2+X/ygMqvooUqFWe
	 5biOd2lm2nMm/uMYQ4i0Y6rQqd+58hoCo+4uwJ2HeLkFzu/wuMApTiau8EjlRmSB34S6e
	 1ubVGNcBCK51TqI6/wID5pYQ5a+gQwCriyJ8/eDPWbjB5gUYGrBeAzH6qNwLDYlRxfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=X0I5B7gy;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AD5606A319
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 23:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88AD5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=X0I5B7gy
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3282db206d3so865595eec.0
        for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 16:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792712945; x=1793317745; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=golt6MBb4CKBDxqCfaMC4QkCui2d3YXf98bP29jjeQ4=;
        b=X0I5B7gypY0tRM0NQFxIqnS0RCepu+k1kS/qRr5a/5WV2EiK3Ag0reYtx7TuXaQJmb
         s5nKR8VRem/pj9Xg48q42z39UDoqfIvjGV2cnP5swfXTh6rme4696hWY7YKZ89GX1qr0
         p7OfeQdwEYWEApkneWjMFp9WA+w9Odi5xEYpCVZ33+fIMlBqFHe9SHOIvlnp1ugT/AiH
         1OhnvMWSLAPHdH/I9a/t4qc6wlkruXrjhl4YSSEDBkp5UVX20z9UX7aIsMBD1L8hULAT
         4VGVVjA/qvVQlhO/wCo/PLLMDqDnZVwg1zSzQ2nFxBAqR7UtiqgghlDeeXlJmEBKugjk
         KV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792712945; x=1793317745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=golt6MBb4CKBDxqCfaMC4QkCui2d3YXf98bP29jjeQ4=;
        b=br/ZVb456VIVmHYBnMvCjK5FGg4SUZ60AUthDhUmmAfFuUksCCClJTgWuLVyuQS8MW
         AlGPYueLdZXztzntoHAznujCvlRsth+wh2hEdYy9ym1CSpTEkQOc6scGx2OXqis/eRcW
         v2Q0+ieKIGxHuC0VS0XckSGxg2qnC9FklXsUyvSNnx7z3y91OZbfCNLSrQxjWaJZRGEY
         BaPcX7IMZ6XajJjV4dEa0HJ4Ca4cljTfDX7KmHyphOSo+N7+E+pxQHiuZcAfrL1dg9ZA
         c7bk2Vob0hDXGE6hEUl3EA5V875JeKIjrz6KKGmYH619dkNCX1HzujfGbGVd3iGL1o4P
         YC+A==
X-Gm-Message-State: AFq9FYJkBP7MD61951Q5cYkfwFug6EVR2c0tr1MZur86qGVRY3jizkDo
	4lZuVbTJjJoiXvMshlDmIMqXrw7DfvMGpJ9DqrvhL41lKThHslSuSXNJfxdJSREg5Iec48W4yhy
	2iS6D7HyFOQXOp7vErSuXcNITB9WPcEo/blvzaFfKNnJhTGVqLmVZMOzhnU2hobpR8waAlCI/sA
	SXBqhyJyTFx7NfJEMmoT+0PusgGxxUx2U/JEKMhJjKjC2H4xE=
X-Gm-Gg: AYBFou3fgRHZVQqnwwh6d94+Ix1Xkqvt1MDF9huFYVG+EjdJFlQQBQOShtqI+mwNAMO
	hdg2PqXasqEnXZgz02HDwWRzz6vWXXzNBg7YfCTYf4nEMlpiJJM2EzKPo9CCPFJsfaNHo9M2HoX
	c0OH8VUliPe/d0NHvEOA9iPYNsMBMLlHhIyXwn/tUhwiwjPwSYfyjzMKxmblMAi3oT0VZyZQR6n
	iAabD0UmA81aJuSw/tQXXiaiNlz0VS0Mj6oZJUrEBFM686kW4B/MRKXePisNyktz47xc982N6Gq
	0FNLDElWnlWz2aReB5g+yuJkSfuFNHn6fbF7VVvX338voMW1ctk+jYC3qG18F5PBxfop2qbQcxM
	iDgbC5eEt2t3BwhTf64l12aq1PXWjyAN1aai/KYcbWZzUrOJejHUBET6Q/bdoIh9PF2er6FAJ+H
	Qm6HA6tyrUzpz7phnwUf55Tag870EICQwC2aOD0/Ae8B7pRc5KQOoYiUZ7oZqZjbKHet0XtC6RU
	CAH14fwagAf4/5NqERk/dOQ97WlmWMmWav+8ZQu0PmNc21gJ2JHfhFqJb65sXZF7PNCQwgdqtfi
	wt4ymzcbhmtstmnFCXqlvL7t5Egy9Kbcjmg67DCk8elnTg3eINNYpj52O3GmGaEXnz7blHXVeTe
	PlDZuj6MGJaUyJiRWznBPDUc4zmj9+vzd6FuPXyqIv7YZN2I025gu87XuMZ8cfpQxoqvvhT+Xrw
	==
X-Received: by 2002:a05:7301:7007:b0:35d:119b:edb with SMTP id 5a478bee46e88-369d97d95a1mr689084eec.23.1792712944339;
        Thu, 22 Oct 2026 16:49:04 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9c15883sm1488766eec.3.2026.10.22.16.49.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 16:49:03 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v4 0/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Thu, 22 Oct 2026 16:48:52 -0700
Message-ID: <20261022234853.79725-1-brian@purestorage.com>
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

This is v4. It follows Martin's review of v3: if a reload fails,
dm_addmap_reload() now sets force_readonly back, so that a map that was
supposed to become read-only is retried on the next reload, and
needs_ro_update() clears the flag again once none of the map's paths is
read-only. The changes are listed at the end.

Ben, your Reviewed-by from v2 is still dropped, since needs_ro_update()
has changed since then. The no-dm-info case reverses the "assume it
needs to be reloaded" behavior from 6e40bf92, so please check that
you're OK with it.

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
as soon as they have read it. If a reload fails, dm_addmap_reload()
sets it back. needs_ro_update() sets it for the reload done for a
DISK_RO uevent, and ev_add_path() and update_map() compute it from all
of the map's paths. With the patch, the 06:09:10 reload would have
found no read-only path and loaded the map read-write.

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

 libmultipath/devmapper.c |  26 ++++++--
 multipathd/main.c        | 128 +++++++++++++++++++++++++--------------
 2 files changed, 103 insertions(+), 51 deletions(-)

-- 
2.56.0

