Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018B926ED46
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781356206; cv=none; b=JADlw33hFozHxjjw6eSlsfhJFdg/Grw6sTs192erGdNnAt28bI541jk/ycJl7RIAiVhFF4/DPH+nbGRgyW0YFzb9DDzzWLczsRmCK/lLYjJ0v1A3cE2U8KB8R9g/bajnavgqifhxuxOTBelag5+7+2ZqcoW1TLCq4m6MVNKB3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781356206; c=relaxed/simple;
	bh=qeT90Jm68DHyvnMWRr819DYsG1ubNEah3n5p7ZNYCRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GKaa0fWoMbekbt4oatIoCdTXgDhoQVsdFozna9yZJkY+jg9Z37C4yY8rFVk/Ja1yDzQHOQ14V7IQQ5yYiDuJ8N6nY4k0Ji7fk8jnsD6P0uR8mZwKdLbsQkhJlyKwaJs8D/cIdGA811YJotdUtE04XQb6gGNI3lTIeUD45TATAkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnInVMwD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnInVMwD"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490a7629453so2268035e9.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781356203; x=1781961003; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E9CZ0nPZOyjKQdtPKI8vR9XTO6lw3CPQXknRiL6KtJA=;
        b=EnInVMwDBj7sEN5/cE7y7l+XOARKo/D0ifILobVElMCdCtZfHjid5iEzzr4SMDMEph
         pKqsrSqI7sImNs+CawFPCk+bqwktVcX3ggBf909DWHsv0qT9FTmn+zpL60tR8rcf5Yje
         m4kurT83QHJZG+ey9xH/r4MY7Vk3zoYwc1O41vrOlKKwjYk5d29edGLJL50JarGvUH+B
         Qdip49zt9pS0W4W3+wMsv0AY4Rj+nAn6BoTfePu3sS4/mLLQ3rBvuoGxBkQiQVdvKPTZ
         KWTK+c/crjoiEF11CqmJOl2FEe2Ja2YBNSaKMu2Xy6Rgoq83Q2W0lkTPlXn9ZYySkZ57
         Ze0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781356203; x=1781961003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9CZ0nPZOyjKQdtPKI8vR9XTO6lw3CPQXknRiL6KtJA=;
        b=DUz1WX8dbVUHKrR4Wj0Khg0HIMFpRw96pNBorEo82+3zMcYQzJC3zlmSIK1Fsze+AL
         /KSGzVfQ7PeAt90joE7hKsgMfpikr75HcH9M/g7uEtyz6UO3Sn+Q+ybElP+meJOrdcyv
         aZJ3J2yJTF0IwzWRx/HRaQSW7ALoPLE9u5GmESazdVeTqmvzvHsg+2Bqz10R0hnFykzD
         5AifSt3x6gVUYWmVIHiOs4KzLijc7WdD26XWOX2CcuvEMP7mFlf9N7P9mTx38JnmiXhZ
         YQEPSzyVRnKwvONb4KrDYUEQn2KyBrXxxNn2FANg5r2NGmrbv6oWH6fzR0VfTpY4ws/i
         h8bg==
X-Forwarded-Encrypted: i=1; AFNElJ8zDQXBunjFSrL39oGXKrtXHf6QOP4R9rJYsahoOirOZ9goqNoeEHArOwhG66Ecv8Lh43OUkprkIA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIwPfXaDP+KFqMRhCccHJPY6hpGThAbHRZQBBAEn/cYCxWJg3n
	9fag1wiNiarHS/xJ0Wr53h5Gz2sZ3AKaTvH1kFyviDXGPlo7fwmsg3I=
X-Gm-Gg: Acq92OHylyG8NnzlUQRKtvlfLNVSASbdUC9DI3f9GfXoUXoJ2VkCNQxhWx/vjnytIG1
	K9XNvkKcI0dc/UnvUablg7hB1Ahc2JY0JQo/75j76Pzgd4btaZJ0JItn9NTDQc6f1Ua7P9l4lxT
	mcBmjcxnMpIp1f/CNxG7oggitoFOLL7oNtd2xf80iZ6fHn8XzrzZkB8Xj6Jx8NNbRUCF8fzarOr
	orufrSiM6nfXH3tayBs8q5l7VhfYNc3oauJWOCrVhFAsH6V5/gYde+xgGbqw2dxSpfEOWfQ5f8T
	Qct0gYAXs7erbOr24+243ksUO9JSsXl1zgRH17F58OMy3YkiYJxRcvMVjgepoEZBPD5Lap9tnvt
	Vt7g7N720x+rsRGIgsL2+iteNz2kdFRn/softg1xoc1Rz2LZDFBJDTkMUlECD5hEdN6Mi73fmEJ
	DZ6XWIcpdANsmREsqU68zkyJ91/D6JanjS2vWjOmQ6rTF5e3DGe0dp+SzBQ9TQzZ0i
X-Received: by 2002:a05:6000:714:b0:460:1bf8:c959 with SMTP id ffacd0b85a97d-4606da0582dmr4178688f8f.0.1781356203294;
        Sat, 13 Jun 2026 06:10:03 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c5266sm16702126f8f.29.2026.06.13.06.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 06:10:02 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 0/5] multipath-tools: clean up man pages II
Date: Sat, 13 Jun 2026 15:09:55 +0200
Message-ID: <20260613131002.144263-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

It performs general cleanups, updates, and formatting fixes
across the man pages, incorporating feedback from Martin and Ben.

Xose Vazquez Perez (5):
  multipath-tools: remove legacy syntax check comments from man pages
  multipath-tools: clarify path selector descriptions in multipath.conf.5
  multipath-tools: specify file paths using variables and add FILES
                   section in multipath.conf.5
  multipath-tools: clarify user_friendly_names prefix behavior in
                   multipath.conf.5
  multipath-tools: fix mandoc errors/warnings in man pages

 kpartx/kpartx.8                               |  4 -
 libmpathpersist/mpath_persistent_reserve_in.3 |  5 --
 .../mpath_persistent_reserve_out.3            |  5 --
 mpathpersist/mpathpersist.8.in                |  6 --
 multipath/multipath.8.in                      |  4 -
 multipath/multipath.conf.5.in                 | 87 +++++++++++--------
 multipathd/multipathc.8                       |  6 +-
 multipathd/multipathd.8.in                    |  5 --
 8 files changed, 54 insertions(+), 68 deletions(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.54.0

