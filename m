Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794421014;
	b=X72TxZN+tGV8yUyY2gYDbhipAwYsLOQc1VDP5xWJHQQ2NGCdIbyzpI9NQK7+OVZIqVI2
	 JCOsX7XIW13wD1BXDb0taE5JPm6/FFn+0MpGhxiSaq69pkOUScBo2l8ZjI10obcMNTuwr
	 isF+IILPpHGR5HeJNXOtiOb898/B1exexROe7WBSvRW9NTVafFxPxbMwIrui89gr4SGlC
	 tifhBHk0qwV9Q7G2qhD4cAEfrcXVNdK3Y899jTSve+1xtYwRMHlvP4SUtXxsh1c00sYxX
	 5h8pvhfgHOXjc8rmK5d0gXgOdvnStx7myQ2D0ODKluXtHhh3NkH1SFPYyN4bq7SGflQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794421014;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tghWYw9WJxfX/qgydlAyo2SGvbzRB2GuCoj7vsIRDmU=;
	b=wp2PdzzZwDnVE7d94TqNxOY8kGvmI+w1ICj7A9w62XqexCbmv+6LaMmUGy47Jq6tNaJX
	 PG8lO7oMtWC0mBZEv3VppuIBWn7/AJpOmFgnD1VH86csGN2Hfkg5MP4589u6M1NSF8+Do
	 SN/oHJgHijvz4ya8cDxZqmC7oh8alEg1Gepa8wQKfBGguMpGREUhITflEicsQHuechCL7
	 dDs9B5rtthVkDpg+r58naygF/9z4QrfCxLD8EAQnFbA4jv6lwv3YcPoFXJHzgnRbHUb5V
	 LSSWFdTCOcA7JxmAMLT+P/eb1Wsl4BweatLXIOi0OTeaN40a7M92owBagJpYSnj9zZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=JOtbFmFm;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69EF606A886
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 18:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D69EF606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=JOtbFmFm
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-372bdb942dbso4420894eec.1
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 10:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794421013; x=1795025813; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tghWYw9WJxfX/qgydlAyo2SGvbzRB2GuCoj7vsIRDmU=;
        b=JOtbFmFm29hl9QhusI5nzdl4mDGPuvwEh4dbMIHvkTkTdkxyQMQJdIL0t3m4ajrkiB
         G9Sz6f3WlnmX2lW0HGcYejO/BvHpGOWfzMED6OK3lChKrrma9u086zNxvuH81dWrkdGx
         gUimRrr+tirhWNg5qKGL7P1bP7zsXY8xFIC1hB1IoJA6rCRakUZpJ/iZ3/1xX2Ok/YRi
         vte5WzxXQq9BpsWlEbFhNAw2UhTzQrjhLm7ppgN1w1IKjxYyzfeJkBPs3HQytXESZXAW
         eCWWPyxkoBfYZE/jonomVU6V+3eytJ0mzpgQdLRIKBGWVuY50gGJEtkC/80i6xz0jRAC
         QBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794421013; x=1795025813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tghWYw9WJxfX/qgydlAyo2SGvbzRB2GuCoj7vsIRDmU=;
        b=DuIDimSaZ3ECwmNPFEIYjRTWZC309WTyhqnJIzSJ2YDOWvly5fur0t6mhShGNiFg5p
         nP/q0rM1y2Z6f/u1R29BikWGRkpTUbxpKCwUp6jQtUnW/04eXgp2J9BWrVe3/8diErBV
         L9tpmDjwnRuQ8BVRvgHdVw6iYnhTy+PJyVX1IfJ8wDC0kOjgf9VlEjU1GE8oOR2auVHa
         5E2sbKhQgybLjo7Yxop7LOEoWuD3KhUkd/TCbrDGdEzDHcylxLoCjGEcTa9XG3ZlJVFz
         l0GtHGA7HjLE5faly7THql9HQbHF7X+x4rTp7nFccInr9lhicichJoWdoS0l3ZrFkXP1
         SGug==
X-Forwarded-Encrypted: i=1; AL+hErEh8W7mPOOQ8ZG9PVAwyn+ve68D0l3U0WDx5zXWEY+ESE09bIuhwBt6M+f4DpE4TeOQ4FCUsoZFBQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/ci7pVnBm3lND8HF2Ywn0vjANpgSeXidElN5tAWIZ3vo9FeKfD
	UD0t8ktsrUZbpq/wu8vAUgzxqaccL2qWsti17gCvGYE1IC+OAbSNQ0iNV3ep87e8d0k=
X-Gm-Gg: AYBFou0bBF3BfXL7f5gegl4bPLugHFZpTUh6h8K+gQDk5nIpUb9TYW3bWiAsRDKNeip
	crgoY5Wh3IjOF3OXyYCwAMhXvpJmSy1K26OBjg4n8Dm54A4J4QgShE/QPq6PO4CNXZ/MW+Hm/pW
	/2Jxn/PWLMUQgn42g4kodgwSTjxzi8TQcjVYTtIRx/gSORfunn7oDUFniVlxgkLWjFDxBxOZZwV
	wDh8xNQsJGUasKXM5eCPsTLxI8Fvb9M/XHsw8htYv1EjxLqMDG9a8wqYOy1yQ1dCihd69WZfrz5
	DBciEB3M5p9hk4eGGKyvYDD+szolo5WFhZIa0bMHqAt9GMh3H9M/eszH3xrPZ7pYILTOcenLAEJ
	30Q3OfDlRQcwO1eBiPBx1KPPdAwRAr7F+JFKvFdZva84JDWzD306z8GaS12aCKCZBMjgopJ6N+Y
	XsLm5fpEHlH+ihtUOICzGXQk0mQ8iGOSNX62oP42F0zPbOGTD45uf9sj6gNz9jVzh3/RRUod+jr
	gQO2O1utNoBPrO3RcK9VfRtpnikGw9qlAg3xpHysUF37AvvOIPJLSSY/BU1CGT/niyNcCFxfBKR
	PGnjDZPR+r3t01wRkEMHCqALA2sE5JRG6L3QMuLAs0VeweunwkBj+9buMwaY0S8fleZzp9a9gUg
	JjBhVEzfSGycE0IxNGGuiXHP8vA8vkvS3BCFxwW58MMxo96naquCCKZXzfMTOCY0hk1kM7Wfi7Q
	fBtvsqNtf27ozV6euZBlvp8MkSkAdHm80BGUbyjsRs
X-Received: by 2002:a05:7301:a01:b0:36e:2b8b:a098 with SMTP id 5a478bee46e88-37686d31f7cmr3346145eec.31.1794421012623;
        Wed, 11 Nov 2026 10:16:52 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212ec002sm20565706eec.26.2026.11.11.10.16.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 10:16:52 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v4 0/1] multipathd: recheck WWIDs of re-added paths with the device
Date: Wed, 11 Nov 2026 10:16:41 -0800
Message-ID: <20261111181642.51912-1-brian@purestorage.com>
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

During an array controller failover on an iSCSI host, multipathd
briefly put a path to one LUN into the map of another LUN, and I/O
meant for the first LUN landed on the second. See the v1 cover letter
for the full sequence, and my reply to Martin on v3 for the open
questions about it.

In short: a change uevent reported the wrong WWID for one path. The
removal of the path from its map then blocked for 4.4 seconds while
the map was suspended, and the re-add used that same, by then 4.4
second old, uevent to put the path into the wrong map. The next
INQUIRY on the path, 140 ms after the re-add, returned the correct
WWID.

Changes in v4, after Martin's and Ben's review of v3:

- Back to SG_IO, as in v2. The re-add check reads VPD page 0x83 from
  the device with check_path_wwid_change(), the same function
  recheck_wwid already uses, instead of comparing with the cached
  sysfs page. The cached page can be stale, so it isn't a better
  reference than udev's own INQUIRY.

- The check only runs if recheck_wwid is set. It is off by default,
  so nothing changes for users who don't enable it.

- Still only on PATH_ADD_REINIT, i.e. only for the re-add at the end
  of uev_update_path(). Ordinary adds never run it.

- No changes to libmultipath. get_sysfs_wwid() and the ABI version
  bump from v3 are gone.

- The uev_update_path() check from v2 that ignored a changed udev WWID
  stays dropped.

- multipath.conf(5) documents the new case under recheck_wwid.

We've seen the problem once and haven't reproduced it. We have been
running a v1-style patch on our test initiators since then without a
recurrence, which at this rate doesn't prove much either way.


Brian Bunker (1):
  multipathd: recheck WWIDs of re-added paths with the device

 multipath/multipath.conf.5.in |  8 +++++---
 multipathd/cli_handlers.c     |  2 +-
 multipathd/main.c             | 37 ++++++++++++++++++++++++-----------
 multipathd/main.h             | 13 +++++++++++-
 4 files changed, 44 insertions(+), 16 deletions(-)

-- 
2.56.0

