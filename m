Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620EE1EC4FF
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957980; cv=none; b=f3VONyZMe0vj8YEcxtynqBgUwaFBRHQ5qAYwsc4/MKVCsAm3gouxyAPsxpiq/agOmdWA0YYLoRH/A1o+JIXbW1C/OAqQlne3kySL6KMBsbtLnXsg88VMjeWnul3djkDhAQUbhxsjETr2n6o5bn6ONYJtlroxgKl9m3gvt5sbPvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957980; c=relaxed/simple;
	bh=1nvSYr00E0nj1Dwpt6QIN/ExF/PNaJ0iXjynVHD/iq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DAmu7SrlR9ZJDMh96ZfAVhfoH/JEGZEqOuQuuJkR9NowJwV9Y5n/2cGkfmIaHArwpCkNW705q9O1HJS1+CEZR8lhZSeQCvE6yjDC6KsCrk5g3fyVBEDyQpdN+h8OrzeysUEwiok3mmjth6G1kX7Kiuv52fxNCGvNadcvLqYbfFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eSdUWMHQ; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eSdUWMHQ"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d414b8af7bso5928158a12.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957977; x=1734562777; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qQoepkUak9HbcSAPbteW7afifPmBsaKWxviVcP4Qg3Y=;
        b=eSdUWMHQee05Vx1ZxSL8jyzFZlYPgmHC5vaNAOcGcrP8SlXLqonl5gF/2ecnet2v8E
         YxD4Ommv/hTnvvGyShOGT/t7BYDRINu1UkuBcpjoQheS9nJ0hth/9AFK1FQTZFxf55Y1
         swlFIDFkFtiqPGOtZHn2kyNpH3mQPxXseLi1XT+0Z1UZWRRpK2GXaiRMyqBYPy+7x/wX
         ZaQtFU6sIRhE3KT2Z5fGe/T05Xe0+sWRweYBXLfZQrL6Rc3tWDwe153ltp9nq5Svregx
         eGH4bWramGPx+H4xpCcGpfYEvXETdubRAf4kSwIBtrTIOWop1MlTlRh+y20tKLgIG/4c
         676Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957977; x=1734562777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qQoepkUak9HbcSAPbteW7afifPmBsaKWxviVcP4Qg3Y=;
        b=WOWfWKNC7cLUHUbvz011/eAICW4vSgbAJn1mCLdNmpmGtO6jet64+Vjt7pSZsHDnm4
         ufdDZQtrsE7cD3BJ+rEaIGgieiv9IawWd1X4HiCIlzVozjMS2Le/40jeCGAKzzknD69D
         Pxu8r4P2qkRS3oyMcJ4Fisgcno21FcQZjiU+N3L8ekigETSGCN9QhHMccb5EQyIsbU1n
         n2H7y0tpa9WCtO8TX7ztlXe544Yv2UYPTRclH1Sk1CzMXc11J56SWtOeBV/kQgdj3D6F
         fjNypE75ihdBxFn3LHu0cNUrL0u9obWLzKja/+1shhCye1ZnpQjEoKIsz57er3lA8pQ9
         t4MA==
X-Gm-Message-State: AOJu0YyHyB0CfnMkkFa6xKC0g8hq2umpNzSgN8p3Hf03kTA8hyhzACkb
	NWbyUl6hDqqt/ZAbYgmsxuh0qF6VolVtGaYfeK8E8sASNWJdl0ZTxnOTF9zSRpU=
X-Gm-Gg: ASbGncv+SF1Cig3KJhDuZ9/b5Fl0HWxCjVFUyh4hDi1TWz+1HD1D5nns2yGnuCuQIRe
	aO28upASFSdVUZ7rZ1tAIBqFMuwmsIP1DNYELu14MpM3X5L4wOcI+lNXoDMoD8T0Y+GB8/f2BqD
	+sht1gtCn73kCrzp+b3EuBbpf6WfsKLoCcua18AxanqpRglOcyUphb8GDfOSTg5X8SYGO6kWFrB
	DsORJ61LCSGAQEgk0OOrdBzkQh+9Tz+jvh9k4sskyCfqpO/RCh6jhgx5eVKuzvDBe5rdwNOHZPf
	eIm7Ohgy3ls9Ng2FVz3v/TSZtXF55JueeO5yrllS
X-Google-Smtp-Source: AGHT+IFUp3E7K/4RKm3SOGG6S4p2II2WG/Wa+WF7xBg/7N6iE6AAiYb1hL4Tk8CljhJSmPd4EMtobA==
X-Received: by 2002:a17:906:1db2:b0:aa6:6ca2:b76c with SMTP id a640c23a62f3a-aa6c1b2a9c0mr174706066b.35.1733957976347;
        Wed, 11 Dec 2024 14:59:36 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa6964b7c64sm434499866b.95.2024.12.11.14.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/14] multipathd: More map reload handling, and checkerloop work
Date: Wed, 11 Dec 2024 23:58:55 +0100
Message-ID: <20241211225909.298770-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set goes on top of Ben's set [1] for github issue 105 [2].

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

Reviews & comments welcome.

Regards
Martin

[1] https://lore.kernel.org/dm-devel/20241205035638.1218953-1-bmarzins@redhat.com/
[2] https://github.com/opensvc/multipath-tools/issues/105
[3] https://lore.kernel.org/dm-devel/Z1iUekRg8sai8HLT@redhat.com/


Martin Wilck (14):
  multipathd: don't reload map in update_mpp_prio()
  multipathd: remove dm_get_info() call from refresh_multipath()
  multipathd: sync maps at end of checkerloop
  multipathd: quickly re-sync if a map is inconsistent
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

 libmultipath/structs.h     |   2 +-
 libmultipath/structs_vec.c |   1 -
 multipathd/main.c          | 287 +++++++++++++++----------------------
 3 files changed, 118 insertions(+), 172 deletions(-)

-- 
2.47.0

