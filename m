Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53EE1A9B2C
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145673; cv=none; b=JA+W6ZE3hjFXOAKSNqQnL1Iop4OD/4EzS8uWwDpNZlLratl4tE0l895lWg4NSSP4PahJbnjr1iwV40pRPPRPBCYFOYckwcZW1FFJH6YaOh7J5FgqWfAFahu2AJM24BJ87ftDz2Mq5YYhTgq9bRIIamqRtHt05fKqsCibxSPuTdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145673; c=relaxed/simple;
	bh=umzYE8qH4pNPmuASzBTe7y3/4o7Bf1bLTZj593Sb890=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AZ5LspY/Xvn1BeqOtdKEp7QIWNCH4WJnNwpJZ+1AyxWEh+A/u7jZwea67BfIBcTiwPRVKOm2p28wJPdb8+CjfO6qVM7UkPRCgv88pUHJiC3dwzMHxBnh9uX1c4FvjiD2//XoJYOPWYjEPMDORv/aBXzOLq+FuMbs/Ryw2VDt++c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=INwbw/50; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="INwbw/50"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4363dc916ceso22515515e9.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145669; x=1737750469; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eGHmztP7eqnqpuRjwd2fgReJAWoGNIkaWTuoAy99+IQ=;
        b=INwbw/50Fb824oT9II9grcMZQRRmsEZByYQ9ni3RPo0Fk3mXuVJ0C0ivrjHDFOlHD9
         ZRyAPCTct/j62DEwbS1txjm/Jyy8OL9G0Mfa74YPcl6JysywyRXg2K8CRzd9klR6iufh
         TpbyfsdXueYyZrkZLAoKmaZmzQhdpDDIljcEN5OJd/zNiAWh33q4mGzvctJ2hzbTLsla
         4jWIVTZuPuww/s0Ctb3wQbn3NF0ciBmDYyf4WrpLpXOfLDQb0ZovlMudOMDZ3geFMaeT
         YSsQTCsPBKKmoq9J5gc+XHEpDLBulR7DT9/HyOEmoqj2vYsMwsZGgT3Jk8KUmE7JEt4Z
         xNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145669; x=1737750469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGHmztP7eqnqpuRjwd2fgReJAWoGNIkaWTuoAy99+IQ=;
        b=jDxcHLWNnmt169U+NZSngQFJchrYKoaJ9AvyhwEqm5qnt3YbbwQlZqnFteFu7A6yeY
         1yR0i3X410f4fGbBWmXn5OzW6/sTWQlRUOmQ+Sr7AYh4jYsBvdqc8uND98OeKiswdyqe
         jgSFDbZ1Se9IgpSk1NnugS8pUN69HwLF9BLVyJFgTrFviMVHzHZog0M+3ok7p74cc1q4
         CJegc0CwSpW535CL65FLQ3d6nzyVpGwSJhWFoeIw4O86irdYB7OK46sbzh5KFUAyqBmj
         mXqj/BGamYVKrSoFm1uHUEE0HOb0HFOmRrKnQU2tn3kBDKrmefaR7KAH4qOMC9bs98Sa
         gkTw==
X-Gm-Message-State: AOJu0YxlVaYY2J6L6ZF40qXlHCBP4Mhsw+ReVt70Y4wWA8Rk0qZ9hddh
	5siNlzpAAC8B9Yuy0KN5mOensV4sX+oP+11kRiZoJncyQ/wwTf0jKYDk+LMKH0IfX3kK93kjs2i
	t
X-Gm-Gg: ASbGncvNz2mb2h8gkWf2WoOVSiP65+dErjhYkaY9b5uzyb5PgPnu77BRYnHTT55pipv
	Lk4wxolm4kLp/2cXaHhWykIpddOBdmB7LLN6dp1719yhtg3tmV0/J8MGVdwsXY2Z2z2oW9lSQ20
	oJN3K2p4SambMxXfFrXQNIirLYQR8PGu4xTzDA6OvrhBLS6Czd3R3iqNyo2O2M6CrStjdP0Ny7k
	bvCnFPLD8tIHl3hgb+sS7R5zAL2RY9mr0MfOf91yXF82s2Jx/0UiMvGs86PmKwYyP6LGP+lnQeU
	Jimd5FfBEGA9RFdxhMVaLz8UsjqkdyXgA6/octgrSZQ=
X-Google-Smtp-Source: AGHT+IH0HSuYgmBy2Py1mYcoUQhXxZx5MdfgV73IooLA4qcMaO8nvUYcX4sKUJO8e9AB0HFe8rvi2w==
X-Received: by 2002:a5d:5e03:0:b0:386:3c93:70ff with SMTP id ffacd0b85a97d-38bec4fb69emr8238695f8f.8.1737145668870;
        Fri, 17 Jan 2025 12:27:48 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-438904136easm43326545e9.13.2025.01.17.12.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:48 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 00/15] multipathd: More map reload handling, and checkerloop work
Date: Fri, 17 Jan 2025 21:27:23 +0100
Message-ID: <20250117202738.126196-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set goes on top of Ben's set [1] for github issue 105 [2].

Changes v2 -> v3 (all based on the review by Ben Marzinski):

03/15: See 15/15 below
04/15: replaced the previous patch, which decreased the checker interval to
       1 if the map was still inconsistent after reloading, by a warning.
       It's unlikely that this condition will ever occur, but if it does,
       we want to know.
08/15: Re-added the call to switch_pathgroups which had been mistakenly deleted.
15/15: New, compensate the fact that it is now more likely to miss the
       call to enable_group() in update_path_state().

Changes v1 -> v2:

Removed patch 3 and 4 of v1 and replaced them by an alternative approach.
Instead of allowing map and path removal in the checker loop, the kernel sync
is moved towards the end.

Patch 5 ff. in v1 contained a bug in the new checker_finished() function.
If one "tick" function returned true, the other might not be executed any
more. In v2, all tick functions are executed, and the action to be taken is
selected according to the combined results.  Also, we won't call
reload_and_sync_map() when we've already called update_map().

Patch 13 is new in v2. Patch 8 from v1 has been moved after patch 13.

(In the thread following the review of v1, I mistakenly wrote about an
upcoming "v4" of this patch set. That was wrong, I meant this v2 here).

Cover letter of v1:

The first patch implements the remark I had on patch 2 on Ben's set, the 2nd
is a minor cleanup.

Patch 3 moves the sync_mpp() call from the beginning to the end of the
checkerloop, as suggested by Ben in [3]. If an inconsitency is found
(mpp->need_reload), we reload the map and schedule another sync for the
next tick (patch 4).

Patch 5 ff. reshuffle the code in checkerloop(). There is now one function,
checker_finished(), that takes all actions that need to be done with the vecs
lock taken after the checkers have finished. checkerloop() enters this
function immediately when the checkers have finished, without dropping and
re-acquiring the vecs lock. The map reload logic is completely handled in this
function.

The various _tick() functions don't loop over mpvec any more; they are now
just called for a single mpp, and they simply return true if a map reload is
required.  The actual reload action differs: if missing_uev_wait_tick()
requests a reload, it needs to be a full update_map() (which calls
adopt_paths()), whereas in the other cases, reload_and_sync_map() is sufficient.
Patch 12 changes the reload action for the ghost delay tick.

Patch 13 removes maps if that are not found in the kernel any more. This
obsoletes the map garbage collector. Unlike the logic in v1, we won't remove
maps on arbitrary error conditions any more.

Reviews & comments welcome.

Regards
Martin

[1] https://lore.kernel.org/dm-devel/20241205035638.1218953-1-bmarzins@redhat.com/
[2] https://github.com/opensvc/multipath-tools/issues/105
[3] https://lore.kernel.org/dm-devel/Z1iUekRg8sai8HLT@redhat.com/

Martin Wilck (15):
  multipathd: don't reload map in update_mpp_prio()
  multipathd: remove dm_get_info() call from refresh_multipath()
  multipathd: sync maps at end of checkerloop
  multipathd: emit a warning if a map remains inconsistent after reload
  multipathd: move yielding for waiters to start of checkerloop
  multipathd: add checker_finished()
  multipathd: move "tick" calls into checker_finished()
  multipathd: don't call reload_and_sync_map() from
    deferred_failback_tick()
  multipathd: move retry_count_tick() into existing mpvec loop
  multipathd: don't call update_map() from missing_uev_wait_tick()
  multipathd: don't call udpate_map() from ghost_delay_tick()
  multipathd: only call reload_and_sync_map() when ghost delay expires
  multipathd: remove non-existent maps in checkerloop
  multipathd: remove mpvec_garbage_collector()
  multipathd: enable pathgroups in checker_finished()

 libmultipath/structs.h     |   2 +-
 libmultipath/structs_vec.c |   1 -
 multipathd/main.c          | 317 +++++++++++++++++--------------------
 3 files changed, 149 insertions(+), 171 deletions(-)

-- 
2.47.1

