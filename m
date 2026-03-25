Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2243DB644
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451986; cv=none; b=jARg4+BWNNbGWOFTYfHlkfCYvoanYy67oo0TYs/qkaXi2+Qw/9DskMs3gPtTBfF8xiK0gZvY2wxFvvZUu8ojc8FkDHu5tstJ51OqFAS3gPcd6HbR8IrGutWM7/BADm45LGqQs/X2Jn3xPN/Wffux8bQM7clFhaU5rMfhbwQFM7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451986; c=relaxed/simple;
	bh=i/J+diTjxoBPXRCcrOqVJ8bIkzX7u2UwqrOt6LLdS64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vf2tYZX6NQK2ObIXvTmLtpDbfW8imMRHzYIcbRJcYJ1QH/9SEpOyesY8F5JyIO4hmZGH+NfVpZgup2xTMckYScgflpRQ7qQquBFXv+Ae5I/H44v6pNnfuggjFgSm018Wf7nY/ARIuG2P1whytbph/qN7H7Z+GIsiafB1u+K9a/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RfjN5be1; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RfjN5be1"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1271195d2a7so5470802c88.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1774451984; x=1775056784; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RWgNYoeUfaSdALpA5GKzS7v3dhZHUImsA08n9Lx3Mvw=;
        b=RfjN5be13DZLuHBmoeuvusZWU9PzJKzFHf/0nWSjHluZK9lGo6UWYOB+2s48u62x2K
         Dabb/XMzNpPJe4JjKc5x4/XYR9w3M0pqR7B1qTZg/aGdUDiSsRyXRW+c1aaJbb1a3cZ2
         7oaB2BJM8TIqdhnokYyf8tvoGYzem9P5CvlkxfVU3k87G8bscWW6lwlr8XMGdM0j623U
         8g07fLb0Dtl89hNKvV7utu4tD93bqQHgR60u0Xb5Rrx1nwAvMxyYS1ldmoYkFaXPSHRe
         yFywOwZAwFPq7btG+l67HLYMkVgakKEnjWVdPzUIfFaChfbxzsbFHSKVepp0J61kXjwM
         dbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774451984; x=1775056784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWgNYoeUfaSdALpA5GKzS7v3dhZHUImsA08n9Lx3Mvw=;
        b=jP3aAAEvs2JNJPxOP7gyVg299o2Kihe2WexTLuyYIgwl4K/A7GP7V50g3FJ0dUuOL5
         yP/Naf/hZJ88Iw62wcW4CSZa7wvWzRmWHx4xugQo/85mLYjZt0pWnY47bcTXr7lrhdfH
         u81ENqY2ZxtNFifWTMAaq4cTHp13PSmWSffE4EiMQKphooOlo4aeZO8xjKrB0YI+56al
         7zfkd7t8lZuoDOpvPpHEpUdTj40zdo4k5UONrJKdcfNgDmZ/G2OwbN8+QnyIwvnp2+Sv
         UpHMe1d59AIQFAjoMkVlMBdMivgBe9qRDCjAhBlAko4Gq6RfEGia2Gib3FkWoBUUAE5R
         1ygg==
X-Gm-Message-State: AOJu0Yxh4LDZuqvHAYdq9WXyMMbAYViv5WhmMKXiQd4QIN5BgYxbPcyW
	TufO1O91uqpax8ehQqf9Oh6kBrPLl7zwmu4oHp722YqySG5p7LDlSFEDFC9X7pXJ8OgR72Mj7cc
	nsaBS8LbmKX0U1wSGOqxeO5re3naQ7ZK1bZZWcnRnXzcssinXbvbftDeAyLNdJy5mTHGl8VnUst
	7CfVfeb8dyHxTk19cYEJkBKdT7smCYCsgH9R/EYl1euWiX
X-Gm-Gg: ATEYQzwYe5M+HXkT+0DGPLraqy156NaS563hYYd4hONFA2/hLvYqZ2tB0zvVyyFTzyV
	wcYRXH/RfM+37UwB0yXd7gSYILlHZ4yuPeX97DHdvM1ar9hf8VqdciOnCi+Ntm92bREHF/nxqwx
	Diel1dupX9LGPQH9VMPOYc5aCaxHF27nQuOln59nPhSydgCGVWswyYIOxD/kAbkdYN50ilpkCaV
	zppTMzYFggopqVuP7TpM5mo+D8l2s8Y4BqXZfK+6mTshEt3e0dYgJyHGjAq+lD8VB6Bk41+rzGX
	b8HOW8wtYKle6DY9/Iaddg6KvIm1VtqPz9WLihfoFa5irxOJapaoBZdhg5MYnHs9qMrOkOIBG8D
	8qmN9tfT16S4llXQwP7nKf8rRmi3VTQuOFZSslxcYtPGQnxmWbuwh2StlAbBYPJ/WornBVgRxcL
	ncYYGBkNcKEIbNBSUFbBEhf+E8jW21gbVV8hK+l6ilhv0TfOvkQroV5okH6A3VdP41IX0YqjG7X
	67yB2T520m6k39XwVyYaNinRWXznGtuy/6RQWz1IINCGxzqriGRbuc=
X-Received: by 2002:a05:7022:618f:b0:12a:6a64:81fe with SMTP id a92af1059eb24-12a96e42285mr2393458c88.8.1774451983860;
        Wed, 25 Mar 2026 08:19:43 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.81])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12aa6513e9bsm167355c88.0.2026.03.25.08.19.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Mar 2026 08:19:43 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: mwilck@suse.com,
	bmarzins@redhat.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH 0/2] alua path checker and prioritizer
Date: Wed, 25 Mar 2026 08:19:33 -0700
Message-ID: <20260325151940.18928-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For ALUA-capable storage arrays, multipath-tools currently uses TUR
(Test Unit Ready) as the default path checker while a separate
prioritizer determines ALUA state. When sysfs provides ALUA state
(the common case), no RTPG command is needed for priority. However,
if sysfs is unavailable or detect_prio is off, the prioritizer issues
RTPG, resulting in two SCSI commands per path check cycle: TUR + RTPG.

This patch series introduces:

1. An 'alua' path checker that uses RTPG as the path check command,
   providing richer path state information than TUR:
   * TRANSITIONING state detected and mapped to PATH_PENDING,
     preventing false all paths down during controller failover
   * STANDBY state detected and mapped to PATH_GHOST
   * UNAVAILABLE/OFFLINE states properly distinguished

2. An 'alua_cached' prioritizer that uses cached state from the alua
   checker, eliminating duplicate RTPG commands.

This design intentionally couples the checker and prioritizer: the
alua_cached prioritizer consumes state cached by the alua checker.
While this blurs the traditional separation between these components,
for ALUA the path state and priority fundamentally derive from the
same underlying data, making the coupling a natural fit.

The patches set the alua checker as the auto-detected default for ALUA
devices. Explicitly configured checkers in the hardware table take
precedence over auto-detection.

As part of this change, the common async threading infrastructure is
extracted from the TUR checker into a new async_checker base class.
Both TUR and ALUA checkers now extend this base, eliminating code
duplication and establishing a pattern for future async checkers.

Brian Bunker (2):
  checkers: add alua path checker and async checker framework
  prioritizers: add alua_cached prioritizer

 libmultipath/Makefile                   |   2 +-
 libmultipath/async_checker.c            | 245 +++++++++++++++++++
 libmultipath/async_checker.h            | 122 ++++++++++
 libmultipath/checkers.c                 |   1 +
 libmultipath/checkers.h                 |   1 +
 libmultipath/checkers/Makefile          |   3 +-
 libmultipath/checkers/alua.c            | 256 ++++++++++++++++++++
 libmultipath/checkers/tur.c             | 302 +++---------------------
 libmultipath/libmultipath.version       |   8 +
 libmultipath/prio.c                     |   1 +
 libmultipath/prio.h                     |   1 +
 libmultipath/prioritizers/Makefile      |   1 +
 libmultipath/prioritizers/alua.c        |  30 ---
 libmultipath/prioritizers/alua.h        |   8 +
 libmultipath/prioritizers/alua_cached.c | 193 +++++++++++++++
 libmultipath/prioritizers/alua_rtpg.c   |  57 ++++-
 libmultipath/prioritizers/alua_rtpg.h   |   4 +
 libmultipath/prioritizers/sysfs.c       |   7 +-
 libmultipath/propsel.c                  |  29 ++-
 libmultipath/structs.c                  |   2 +
 libmultipath/structs.h                  |   3 +
 multipath/multipath.conf.5.in           |  23 +-
 22 files changed, 988 insertions(+), 311 deletions(-)
 create mode 100644 libmultipath/async_checker.c
 create mode 100644 libmultipath/async_checker.h
 create mode 100644 libmultipath/checkers/alua.c
 create mode 100644 libmultipath/prioritizers/alua_cached.c

-- 
2.50.1 (Apple Git-155)

