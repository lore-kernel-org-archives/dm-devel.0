Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529334;
	b=mAxGZ+IchB2QyHJrZ/AzWT/lyN23X2BEwnSqGPVf5ALFm4MOFucIFoKWlOymHZzRPZWZ
	 yCDpFBY+DWKyom2aS8hqaa4zoDHOotstOe9xuXkNhdv+M74grcK7c6HXmi0lQo9rZ+35+
	 ZOVY7PAlm9S9NgFmqMcuGzZ7+4taNFx9XpYGtYSZZEe/GgBolB1HBX7/YbjcrFRF+pgyg
	 jfhnrxMkvCNP4jAMyVZqIH4pOaGaI9DcMUVCff0Tiu5i3QseABuwYgFGpYL45yH3Li/DF
	 KamZfTv2dFDGEPBJK84WYxM5PCA3Vc+8FfVg+g8MENK3B+mZbFD6TNvfBWWnQ+h9jsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529334;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=JNpEQNvJAyr0z1Lh3P8fnjlkfZGPhM3zoV87eED5GMw=;
	b=NSearDUqmN6AUSnf1NLcAc4FrBpcdbmzcsGfDAQGJ+b7Uuc5CBvK2BMqyuqus9SEpjEh
	 ktwaUQSpVBwZ0c+/27XFz8m+5iENcB9H9Xpl4ghUaylA6Y3li+T4PTw3YeXMs6xSVkF1D
	 beIs55ctEl3CEmK4X83deurCsSnchCOvJSAI23h9KtAwpWJTqCaS2fmjJVJ5A43UZT0O1
	 hXuP5mhMWRDKRaJLF+YmhDysIVdCCJqHsol/0jO7tjSc6jdfxTgW31wMNjtILChHYeF5N
	 J8oAA6bmuO5wSh9l2auk+9bc+PM/XEH3zISKeT1yZkip+kH91arJg5MQp1tHYOJldfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=W3xzTq1V;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981F2606A31B
	for <dm-devel@lists.linux.dev>; Tue, 20 Oct 2026 20:48:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 981F2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=W3xzTq1V
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36661f953e4so1775697eec.1
        for <dm-devel@lists.linux.dev>; Tue, 20 Oct 2026 13:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792529333; x=1793134133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JNpEQNvJAyr0z1Lh3P8fnjlkfZGPhM3zoV87eED5GMw=;
        b=W3xzTq1VSS/SgX4TigUljYFrOTDK65IwV3cla/Aeq4bs1GD0wBJOXKdqqOUJ5q/DKd
         XX6f/jgBTtUD7dwlNTG5EmNna+qFTTRua12SEcKnMByPyF/hzrWBkOVMjSF+q8UhvaoG
         MjFRe1fbiesAn4xsv2E8LpjIo3SZ0E46lshE6dZ8SG2n5kJmTYQZ8a9y2iiOUeeUoTOK
         edYaiRMhlRIXgEiMzA/pwXZY4+gFmoL9ThJbEhHYsokV3f5UJI6P9Ip0pHucXV+tHvN4
         nJcd7eUDdFW/j2IUqJkiYoqXHT8MuAtFmcAJ4UJC8MfPIN87NxeQWeBFCZ2Z+T7JpFM3
         mVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529333; x=1793134133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JNpEQNvJAyr0z1Lh3P8fnjlkfZGPhM3zoV87eED5GMw=;
        b=USA84FlFabJJIoasbPAMUXxOuw1xiz66EJV/r7C7nd9QgDehiG5trekcEmVc+aOzbX
         2d+N+OnVTFgD2mb3J2fy420XPg92JIW/H4khJTZqQCVPHiYICwasaYTM0STgN45Ll1iS
         OJ19UmVnumJb9RMxruJOhMoSprn/QTGJ761taclZHfxTmgRG/uy23h+eHC1LJ8LBXk64
         EW+ntVx3d62eI+WDgSbXd4udWX3SMagErnQ//PTDb6sTX3EdbT9kSRdNzh5Xt3qff+nS
         dJNzufG65oHOfMJys6OnZjz+FDFVugIJ8NJ6WOSUxDWn4oE5C0QTn2Ub1guMleM6xhSk
         +5cA==
X-Gm-Message-State: AFq9FYLRKlXyj5gBqHwV2x1LOGefZUTGRmDBlEeQ79/kedKJfbirzpQ1
	4TYUSNoraBUOYEUNGgfmV4r0c6iD1knt551B27i4t963fSgndbe+hFRC3iipNnAI3UzSGPCToRa
	DWHesSGOonj5j4LvLi+SRdpifs9vAVY6UHOBNIFl3O2MlvIOl/CHbUF3lehFQi/XPkAzpagn69f
	A1cEz5Qknh4kePtmOwn0H14QUrtlmISV6cYJ0E6P/dekfh8wo=
X-Gm-Gg: AYBFou1DGODV7E+3Y0SSLJaO1GNThWQDp2gpM/saYXEBGP2mlmmKn5YqL/VMe94XQxe
	i/C8mlnFWjIW8aQH43Ek6tQhONu2ilrIrr/+8bBV3OJV3jL8hJi6RCde+mgeY1JgOYPCLnxJWuz
	YyyoZohYhqbhmwU31zuMy+ZqTCTjpGWCli60Q0hRYG8YxmkLDZf8PDifFIVYtzIVvH1c0JAumr/
	IZKfLnY7GaPRY6DXI8R40SSr0t6OswlAYJt+m7FnYFvl0OqvYW92ehVtQ8P0m/f0B/DWwusmCg+
	Yi+igUhhefHcG1/nMD2PYrP2RSDp5TCpnZ5ljSpsfMXoHO2aR8Z514vAJQ0dYVDN4S9lnmteYt9
	9UUFzncvv7Oeh5oqdT5DXkm0yQRCjX5U6hL8FhHtQRG1ctIHFTBngi0hYx96SQI9Uj5OIszPraf
	7bqEr+M3tQGLzAiNme8XKcbX8ye/sJO3YnEP7d5mr1YNshdlsYA+rUuLcYJxy70cBXv1w37xmLm
	xHCNQH44NMetiDYhxWepqzYsbAWLywhs/Pm04T1D1JILqLTBISFClVWFjCM9yryD0kTAAzf73Nq
	t5l4D8359vQziVcOj/LX++f7TnwBXrcB/PmkyYzKz2M/cFu/KeVdSE89eZBhW1RamqZpKY/A6xg
	uNXJP75aouxawgW/XMIV9CelJbvPzJYbcC4uZr0cc8nZhfOFboe+M
X-Received: by 2002:a05:7022:28f:b0:18d:5988:8d3 with SMTP id a92af1059eb24-190a109f74amr13396c88.3.1792529332305;
        Tue, 20 Oct 2026 13:48:52 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a180adasm954412c88.8.2026.10.20.13.48.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 13:48:51 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 0/1] multipathd: don't leave maps read-only after write protect is cleared
Date: Tue, 20 Oct 2026 13:48:38 -0700
Message-ID: <20261020204841.50459-1-brian@purestorage.com>
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

The patch adds map_has_ro_path(), which checks whether any of a map's
paths is read-only in sysfs, and uses it wherever force_readonly is
set. ev_add_path() now computes the flag from all of the map's paths
and clears it once the map is loaded, as uev_update_path() already
does after its reload. uev_update_path() and update_map() recompute it
before reloading. With the patch, the 06:09:10 reload would have found
no read-only path and loaded the map read-write.

Open points for review:

- uev_update_path() now takes the read-only state from sysfs rather
  than from the uevent's DISK_RO value. That relies on set_disk_ro()
  updating the disk's read-only state before sending the uevent, which
  current kernels do. Older kernels (e.g. v4.18) sent the uevent first.

- force_readonly is a one-shot hint that several callers have to set
  and clear correctly. A follow-up could remove it and have
  dm_addmap_create() and dm_addmap_reload() call map_has_ro_path()
  themselves. That would move sysfs_get_ro() into libmultipath and
  change the multipath command's behavior too, so it isn't part of
  this fix.

Brian Bunker (1):
  multipathd: don't leave maps read-only after write protect is cleared

 multipathd/main.c | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

-- 
2.56.0

