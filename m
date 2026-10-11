Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C8C339386
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791741296; cv=none; b=gS1yINDg/Fw5hNA7M44lG0V260u0aT8qXqgy2okgfkQJhHm6rQTp3B29TG9doPXlnYMZ5c4Mp5IHWr9qCDbRQbsFb2H6lgadpwDQDmKze8qFffV0WPp4nyk5ykAu0DEDLBbVN48+fPPqBaAZW2MeMqAr9sw825KZytv+Vfis0+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791741296; c=relaxed/simple;
	bh=1u+SvA0K/piaqCP2bammpQ+xKV6gQwneMX4d2DzhNvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EETO1W+xWgjJ85Wc3gQqu1tcqUdGursVjJNCbbq/VuOW4/ZGy1zDo2SbzMQw/hdQGYjMnw1CIAiAuRXo+c3qiB8XBvRIFKFctLdMLkeEVWFf1Sh40W3L2SbOZxkpQLAeE+8S1DM+AmXj9QIBoE3oFlLA/KsDGIRevMBbaHkrEHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PM/jjwOu; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PM/jjwOu"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6acb9c018ffso1989526a12.1
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791741293; x=1792346093; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pMz8tbwpxQBDLx8AlhOWU85jm60XxNjWVs22q2b3BTA=;
        b=PM/jjwOumxooEL60PGYwyxf5hKxTbXpIvsfhIhfQRj9pgT6xgheDtoUGPX4BKNwS9J
         8e+s4pasP+B0qNpX6B5GQCKwg3wb9EpEDbRXVk9CNVEsOuOh/hjLdLJn0vxHnvSJksJ3
         dKSn6OhUmURA8R+Wvkjo741EHtsWFdPIx/ErDL6wE6XCzmMiQ35UnO93CaIwwbA63bXk
         f1x/LLhgK1B83ES+c45kBv50juMxFdDevGimp2XxrCLjcoWYc6VurY5FRE+H7j4VbtLw
         PElMCSwQWJmd/hDwr1KmWzmtDLS8V3Pc2vOQa54vAA/NxwOazJ5GqNDmJ+gUyF/XomFs
         vDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791741293; x=1792346093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pMz8tbwpxQBDLx8AlhOWU85jm60XxNjWVs22q2b3BTA=;
        b=tjcRc4GlgEUNECi6qFfZs/b9X1WlpNaA6wUcX1kCH2CRP4F8q0ozd76w3+V3S0rS9l
         IDXvY2FqcbSz/nyEobyBG3PFDwKgOIFgN2DHwLbglZyr048mYvQt9s4FAqgge98Pim7U
         kqqUCWOUikMbgubbHNWDFAQTnpBtkIDweoOOc6R2YBjDPJQxAab0QJoPFV74WLuwzjS+
         D4h+RfQeNX40Gs/Ka2AnQpQjKfZvSzT0OpHxNiLVv8QIGMeIT2PmzohwPUz+tSg9lAX7
         JAausckcOPKgJ8wNRwFVuUJHYDvoHavIUoocQeQeTUY7Cxe0m/tDHEEJPoFZ9G8AwDVu
         YzQA==
X-Gm-Message-State: AFq9FYJB0kizOtiKjV0T8T+zjz0+nNM8MzyqPLp2yNW/RukH2vhV/jnj
	jei+j+nMQBzW7wCowbW7eZ0uo8TTZJr6hrB+iTnXTvBQvz3vYWiq1AedzMHe+YVKi3E=
X-Gm-Gg: AYBFou2JBJgdTqv8ThH8sOzZfSUTsOGBShs/76VW3DAIspE49n0xqNQbDBX06La4qeO
	oEqhIxsopgJkYwe7vgSjVZ2bmyh7CpH2+t15LOO8uVe5f/cvJE+7o/irQdyR6L50CRvJ9SxOS8r
	8jRhp2+B/6FXUdY5Ijtkzvw3wjLnnKU9wiwspga2l51lZp6E9AuhvfDuOJQnpIKBSJldg44pkrM
	Jdh480mCutTRMHEvAy9edNpULAoqgf4RP3jjAkWmzHeKXyh6T+mmAFbMhI4VLiatHpSdGitipc4
	TUOf2mHs/orQHtpN+wlrCIEZniU0pEFoas/DcomB9L8i7OtOOLgiDBHkbG2JGQ2m5cp5vodFh95
	/vD9oi3tqO1gFUl6m1qt0sJlYa5KloI6LkAbWPppcnyl08Pt/7X/NgKJfRqNk8HgTU6FacAYV7n
	/EnRuQGFF50SaG8eVUaYoZN9Q0MtwFihawQmmFCsIwkzFbpzx9gfVvQfND+i6XcRJa7YQ62tnfM
	Vw7KQNyoBl+IMFHIf5ziO+EwGO3H2T38S8vxAfjWGCUPlA=
X-Received: by 2002:a17:907:c317:b0:c2d:c5ca:9862 with SMTP id a640c23a62f3a-c31a6eb4997mr763159766b.2.1791741292575;
        Sun, 11 Oct 2026 10:54:52 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a9f776sm376806366b.48.2026.10.11.10.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 10:54:52 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] dm zoned: fix two idle reclaim problems
Date: Sun, 11 Oct 2026 19:54:47 +0200
Message-ID: <20261011175450.952-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v3:
- Patch 2: reworded the comment and dropped the redundant
  dmz_nr_cache_zones() test, so the condition fits on one line
  (Damien Le Moal). Patches 1 and 3 are unchanged.
- From and Signed-off-by now carry my full name instead of the GitHub
  handle, as you preferred on v2. Thanks for checking.

Changes in v2:
- No code changes; only my author address changed.

These patches fix two problems in dm-zoned's reclaim worker, found while
running md RAID5 on three dm-zoned targets on 27 TB host-managed SMR drives
(WD Ultrastar DC HC680), each target with a regular cache device.

1. On a target with cache zones and no free sequential zone, an idle
   target keeps copying random zones into other random zones, forever
   (patch 2; patch 1 makes the resulting -ENOSPC back off instead of
   spinning). After a full md rebuild every chunk is mapped, so this
   happens right after a rebuild: the idle member read and wrote about
   72 MB/s nonstop for hours.

2. After a reclaim pass that ends while the target is busy, the idle poll
   is never re-armed, so zones filled under load are not reclaimed when the
   target goes idle (patch 3). Users notice it as "the buffer never drains";
   the workaround has been a timer sending "dmsetup message <dev> 0 reclaim".

Testing: the three patches were built as an out-of-tree dm-zoned module for
7.2.6 (the changed code is identical in current master) and tested
- on emulated host-managed drives (tcmu-runner ZBC handler) in a VM: the
  idle copy loop reproduced with the stock module (340 MB/s on an idle
  target, zone counters unchanged), 0 MB/s with the patches;
- on the three real drives since 2026-10-05: crash test, three 1.5 TiB
  write benchmarks, and eight conversions between single-device and
  cache-device layouts; emptied zones were reclaimed within minutes of the
  targets going idle without the reclaim timer.
- with a reproducer that needs no special hardware (scsi_debug zbc=managed,
  64 MiB zones, plus a 1 GiB loop cache device): stock module ~600 MB/s of
  read+write on the idle target with unchanged zone counters, patched
  module 0 MB/s:
  https://github.com/illofspeed/synology-host-managed-smr/tree/main/repro
Not done: a test on current master itself (only 7.2.6), and a rebuild onto a
cached member with the patches (the first problem was seen after a rebuild
with the stock module).

Related, not addressed here: the double-free in dmz_load_sb() reported on
dm-devel on 2026-05-30.

The problems were found and the patches written with the help of an AI
coding assistant (hence Assisted-by); the analysis, the tests on real
hardware and this description were reviewed by me.

Kyrylo Biryuk (3):
  dm zoned: back off when reclaim finds no destination zone
  dm zoned: do not reclaim a random zone into another random zone
  dm zoned: keep polling for idle reclaim after a reclaim pass

 drivers/md/dm-zoned-reclaim.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

-- 
2.47.3

