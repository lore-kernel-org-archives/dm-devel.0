Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BEC15098A
	for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 11:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737459968; cv=none; b=WpVI4llQm7YJgc3wblEGzapXSpYmPy1FCHRfxA82MXvgOqigJWsEqAwCzf3pUEPSht8XNkZV7axreIN+upRIEtFv1fO/T0yv91XQIhTe/cZiSrOqR2n1UMCPe97GBCHe62ZAgYlKtLTu5ahDy8h29A5FPtK4X8/7m6wn7KEJXHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737459968; c=relaxed/simple;
	bh=DFXZDvvWsDdFC6LIGI5w6Olbz0lLT52nkZKxzLoKtwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qHzQW5kQFjGj0yuD7ItUYdWNxbf+7eZnfxhlFGy/Q4t/jcJ4tFYU2H/PE0fh7pCYDL36dRKgTNSSYKIDfAw/ERtqhGd36Bpmug968J057uhbrqUgJC8+05xqfgbMvxhBr5PpO4MZuTNwr+znttsmvq8TpBuAKLi4R+xd9j7gKqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S9xUOfbd; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S9xUOfbd"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa689a37dd4so1027399666b.3
        for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 03:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737459964; x=1738064764; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A7w1rlInYhoKwDXxGfunIIP+nNYlYZkxMYau13FCDK8=;
        b=S9xUOfbd55+N8X2+FjXpVu9juR+47C2f3eLYmMe12hTywht8hZ975H1JowFB0t9AD+
         lBn6xqcraYz1CuzMCNEOUS/oEF3jWVao3jbWfyJu0MDCQy5akJu0Mop3yrvRKS1+zLAO
         Xq/pgCb/EEA+02ZwpEO1B5WI0diLRTkG0Y3Gyby7NacxZyuBFUmTmJQPEDlXZLtobc6L
         RSjcSClzT/SNGnWfBlrQAu5QtpL8ppB/EoPVz0PFfgFFpqq0YVCSZ7EbCweXOSHTdoBv
         d7nqw1eRGVHaOxATCm+PXuDQFhVwzH5XLj5G1wBeKJqjq015WWDmcTF4PjSSOVKaWo9Z
         u2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737459964; x=1738064764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7w1rlInYhoKwDXxGfunIIP+nNYlYZkxMYau13FCDK8=;
        b=uvrmGMnwE/ygswWm0cpw8E6cZZ2ffoHFckaEfhwoBcFFEUPqKeoFm7cyV/pZa9EkVR
         2HgDxucKRXPalXvR2gZEGhXo9a3Hf9vC2p2a+HWYLNABYxwp4PoXeZkVMgYG14vaG+Az
         CJiY8Da/Zj7JhK7cKCab9FIR1E3uDtqztxL1DnBZpDjiCbVzBH40jsyVZeDFeud2mnp+
         0TBonA8bktejbFZFfYDFY3lNuZj1xpSYhMCS7miQB/tfN/xcrJuvBoAkVDU4CPAFYvTU
         HOo7WZGauE2VXQ20olPCF3ROcYYU9D1pVLhWUqAJG0cFIa6Aw4YgGzEyE5pxZ/pzuKkh
         X3Zg==
X-Gm-Message-State: AOJu0YyAcyHrGgUvIyGmtbvohGCZiFC8YaCH+3aFMqgdXx3rQT1k2y0o
	xUkt7U0WM+doSDVhkIOA3WIr3owY6EODGZi0v99WztWWm9WW2rCXzmdhPRqlDpw6mOPxI4gZ70r
	Z
X-Gm-Gg: ASbGncvu6yk9bTiSn9W+XpBSy2BLMniT6oXqL0Q2Wu2mNaCESVvZr7JBKRICpsucLdk
	iSdEJti7nfBPtFrCZtqn24h3/03nnw1D8ji3UWhHuxG9GRwY5D327ugRXv5lBXTprVrzVXtHnht
	UQ+eddUVwLUJCHECquwFu4CZ3pPBI+lgm/y9ucPplOEjSwSFAgFG6zlAyE24nlmnSryrkzXZxYF
	fKtdmGd4EMI7N9I5aMU89FdsKFp8v7xTCQLTZGQCb6EF6IUaTZjWdwelsmWcHyRoZ3qlJJVJAHX
	3GszO7iszviqUkO6TzEOuEc/FEnHpD2d8oQ1PLsTcZbm2EYsbVg+DfAX
X-Google-Smtp-Source: AGHT+IEkElsj/37KG2bkgJYr9Z3cvE/VbztADTseL8ddNppvAwPNpAA1U8Nz+BprlzS63fYeoK8pxw==
X-Received: by 2002:a17:907:9452:b0:aa6:c169:4e21 with SMTP id a640c23a62f3a-ab38b1b454dmr1574940766b.6.1737459963278;
        Tue, 21 Jan 2025 03:46:03 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ab384ce21d7sm747004966b.69.2025.01.21.03.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 03:46:03 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v4 00/15] multipathd: More map reload handling, and checkerloop work
Date: Tue, 21 Jan 2025 12:45:37 +0100
Message-ID: <20250121114538.31963-1-mwilck@suse.com>
X-Mailer: git-send-email 2.48.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set goes on top of Ben's set [1] for github issue 105 [2].

Re-posting only 15/15 for v4.

Changes v3 -> v4 (all based on the review by Ben Marzinski):

15/15: add checks for pp->is_checked to avoid re-enabling path groups prematurely.

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
 multipathd/main.c          | 319 +++++++++++++++++--------------------
 3 files changed, 151 insertions(+), 171 deletions(-)

-- 
2.48.0

