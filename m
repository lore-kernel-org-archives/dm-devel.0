Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3551140C5AE
	for <dm-devel@lists.linux.dev>; Tue, 19 May 2026 09:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779183706; cv=none; b=hsO1MXn6LG5ZNpKf6awBrlub7P5zVQyuur7ZoDF5Xb5Ns9qaE/bTLH3xaybEzATA5nBkBHipPVK8fS3MC8JSMAd2aVsEFnO/Iqdl65yoqJlLmRB0+UP5Tt5dTbIPlsTpodbZ3InlmP6KUbHE/xgW4N/n6RAQf4DX9f5MofRGeSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779183706; c=relaxed/simple;
	bh=HWfUxPfYscSIW9k1qDbIOfe/mSljB1Gv/XVXTVAhy6o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HHjSRZGC471vvSy9R7yDqiTm7iYyWFTlUKJwkJ7F1tlHQYoz9GHGYQ1n5mo6fJC3jb9LgPzIIM1c5f5L9m3wooVCxeZ1sxPU/5nEMV4dg8bQ/4IbXAVaKKaWKFta2B/6K2WwdlwxhDI7g/3Fz1FPN8KBBpqTKR2mqUogGmS7OWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kIh2iA1P; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIh2iA1P"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36643b96b99so3112662a91.0
        for <dm-devel@lists.linux.dev>; Tue, 19 May 2026 02:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779183696; x=1779788496; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RkcnvoW7fcNh19SzTtFYiuusZgm3lpkLEpTJ1iXQXd0=;
        b=kIh2iA1P0NhtmcdGrfse0ZComJnzA1Uw3TzyAtuLe2Frcp2hWwDwGT7D3E5OWt5e60
         yZepTcpo9uuAzG/8V0xAYfvVgT631NPfh4YX2JAZAWJwZXfbW4hZqCgcZk1w9SCKoykl
         Mu3H3J50up31Do3o3O0NvQqd+LUwcPGlZCdP0WaoE5IeLBnFgI316k6VFfgepnUp72Qq
         qNCWzLwTt2pahoEPr4RzYODdvY1euzEe49v/34Szwzkn0IONtsNT8vHFmc4ruvn8N1aQ
         BWPDCF7hDmHwAKBG8n4cJc/KMZ3uTZKjCaQASVC9UMyJuIJPDUx3lRo8yzQ7Rl6TbsHT
         I71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779183696; x=1779788496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkcnvoW7fcNh19SzTtFYiuusZgm3lpkLEpTJ1iXQXd0=;
        b=Hq4PbqejMPCSaAaIU/8gUGqjhaY9csGw7Od5xdDYwD/Fm2RKIc6VSNR5cW8VaPX43E
         ct27IHIj4e0g3B08PNrS4Gb9r+X8ByRF4bRwCNUVmOzxTt4ogsvWDtXbKsFs37Tnatv0
         gpk0xr45VMjk4Ee1e0c+CXSEun8Je42CzuBymSOsDw0LATNzzuu2R//ZB0P5eNsyW+r1
         2+x4udkrDHmOUEniIx0r4PuYk6umz+kkcV+CRwmXqTn423zIIbIswthKHLEWMxG4ux4T
         XNPPltEUas+g2ZMQZjsz9tBXi8jjoKveZGLxHWbqo+WAk1Jiu/u/4Sw4POlHHke3P7Ny
         DZIw==
X-Gm-Message-State: AOJu0YzTJjcS04kwHrHZklLmuuSicc1rCQPZ9NbxS1xBatlJI/fPo80R
	sfwDXBpk3cQ0EUWuS5A4IR7d70lqYxUQmqMTu7uIflDgaewqSmZD+LAW
X-Gm-Gg: Acq92OFbzM7pVdPpom8FkMHbLZxIrAm/8S61fqnRg4wR4d3zrQoQvrO/TPxFbpj1WVj
	+mYyP/oSkZF/AVo++ifRLjY0a2jxUNlwmFpr3NQ+mNMXTdr/u9wpg4POCyeHT9sSQVyJYq5I77l
	/5rqI9C1lyKVyEMmkKxh2rzBm1ncPksDTb/tU6Zzy2vWg8brafJElJUBem117GhayL6wIKJFiH9
	qdY/dUceDiuiMVw8lUJcDS9dC56dqBMcw9HLkdVdpTdiuHgSjdA4H31ONCVfhUGYoaWuXnkypu9
	GBoWyqOfvKvVSVzd2BFXLFa79Q1qdfUqqn7MlN9OJoHZbUVfqV6VXgbb4kXkQKBBWmkWQ6JMR/W
	z9JYNsMmWzJQ2fPbz871N5ZvYUdrEjud7OI0KtKS5fgbN6+ghBb4FT2nM9rTQfPxbYyyA5ErfH1
	sKemlWQYK683YHWJNqrxD8g5RmnL36+6H0rCSiDD6B8f6GHAtO
X-Received: by 2002:a17:90b:260b:b0:368:ed92:6f3 with SMTP id 98e67ed59e1d1-36951b89773mr20374375a91.18.1779183696382;
        Tue, 19 May 2026 02:41:36 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36951059f4dsm13101437a91.0.2026.05.19.02.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 02:41:35 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: dm-vdo: iterator after loop end in mark_slab_journal_dirty?
Date: Tue, 19 May 2026 17:41:32 +0800
Message-Id: <20260519094132.1964544-1-maoyixie.tju@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

While reading drivers/md/dm-vdo/slab-depot.c I noticed
something that looks like a past the end iterator pattern.
I would appreciate it if you could take a look and let me
know whether this is a real issue, and whether it is worth
fixing.

The site is mark_slab_journal_dirty() (linux-7.1-rc1, around
line 156):

    list_for_each_entry_reverse(dirty_journal, dirty_list,
                                dirty_entry) {
            if (dirty_journal->recovery_lock <=
                journal->recovery_lock)
                    break;
    }

    list_move_tail(&journal->dirty_entry,
                   dirty_journal->dirty_entry.next);

When the loop walks all entries without break (the new
journal's recovery_lock is smaller than every existing
entry), dirty_journal is past the end.
dirty_journal->dirty_entry then aliases dirty_list (the
list head) via container_of offset cancellation. So
dirty_journal->dirty_entry.next is head->next, the first
real entry. list_move_tail then inserts journal just
before the first entry, i.e. at the front of the list.
That is the intended behaviour for a sorted insertion
where the new entry has the smallest recovery_lock. The
dereference of the past the end iterator is undefined per
C11.

Jakob Koschel cleaned up many such sites in 2022, for
example commits 99d8ae4ec8a (tracing: Remove usage of list
iterator variable after the loop), 2966a9918df (clockevents:
Use dedicated list iterator variable) and dc1acd5c946 (dlm:
replace usage of found with dedicated list iterator
variable). This site was not covered.

A candidate fix would track an explicit insertion target.
Declare `struct list_head *insert_after = dirty_list` before
the loop. Overwrite it to `&dirty_journal->dirty_entry` only
when the loop breaks early. The final list_move_tail then
reads `insert_after->next`. On break that points to the
entry right after the insertion position. On fall-through
it points to `head->next`, the first real entry. The
behaviour is unchanged in all cases, including an empty
list and a list with one entry.

If this is intentional or already known, please disregard.
Otherwise, I am happy to send a [PATCH] or to leave the fix
to you. Thank you for your time, and sorry for the noise if
this is not actually worth fixing or has already been
spotted.

Thanks,
Maoyi Xie
https://maoyixie.com/
