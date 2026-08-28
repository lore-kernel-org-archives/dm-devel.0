Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE33E450F2
	for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 05:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787896300; cv=pass; b=SSQFYu6akP+hhe7sZUtUichsJgakflbLvFh/h9NsORI8N5HOruCOOn0VeNp5v/3motquoiZFZ8BcUr9jpTVAxAQzsVcauydKxM78QQxC+MUH5xw/il42hu6dJhUFg0DefM/Olf+jo5/Dx7IbI6OtDTVZL+rwRUUGkBMJ9VJa3lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787896300; c=relaxed/simple;
	bh=Y2TG9nDzfuPTicq7OJCpPe2Xp11ubXsgTq3We46VI20=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=duOGNsGgd+CJaXKsC7Hpdly/3F1K1U2Lk1GWHoUrvURAiEtjIRdvY1mFRK6jSezN6VwOeLfCrzzoHEapwdTTKbTRdb2Z+/oyK0iFH2jDHUIQ1I5eEzOCqe9KgjR0YUA5cSrq1lz89mktF/Wx+BkoIzX6lk+l1oblApWm2gFQ7nQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=ODwLKeqY; arc=pass smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="ODwLKeqY"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso735145a91.3
        for <dm-devel@lists.linux.dev>; Thu, 27 Aug 2026 22:51:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787896298; cv=none;
        d=google.com; s=arc-20260327;
        b=O8NNRAKulfRjBvTh5jVaZvUPgyVBkhMBK/7ffCjaM2vqYw3NlxPFoxOgY1dmgE543q
         7V+xAwSpKKoa1UQAFtuHd7xPNAad31WD79HxuXV1cSSjPSPw3gEEzOyCtPg7jZGrDhoJ
         vLZiH38gafAV2i3n00vFIncsnMroy/oLVlnf13VgwRy8z4m1BMtofr/ts3lxmlQbiChN
         TwIMvCTEwrNipPZFUAK4+QnGnxVaY74iFpZpinc4UZV+L3UeGpWQEa8oCOHgb3q25Hdn
         EHvzapFmLsA/zQ+gVUIIqGEy7exhcyJwMPKwOGHcYRGZuasVUeJLb331+3iY9Rp5frVN
         KoHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=hm4xgC3E24zQaBzzk1libVX+Z8H8hDTIZxZvDCzl7YI=;
        fh=5CCyx68SYlqkEfRT/Q6YHX1MR70SfAHooif9KUILH54=;
        b=rkBDwKmR26Bv1uTd2gOJJ9LKCN1ryd6q7UgVnxcD5qOl+qWwidfeiGKn2JYf9GKv6Y
         6cA0w5D/G1le/IcloI0rR1fWRjUZAdpLAD92w7WjIu6KpGczsmOsxWnnpu07qblzIoRO
         Rgjzu5WFBN4b+J+9ffgEFxuZVBsTlvhcbU+lm/xegYD9Bof/4C59EJzPrGqdOmENRhv8
         Y7K7zK3N4AZE+bLLQzZrdkZWkuaR2pE1qlP+JUPi8Qfsfrw7wggfkf5yb2Z/X/tMb4KY
         iI8yt/SkrNGdyyAEvqC5+q8d9OoPbvRRvnkZXVcTLbAmIXKYSUprFrhawB3LOV2V7xjP
         pdOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787896298; x=1788501098; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hm4xgC3E24zQaBzzk1libVX+Z8H8hDTIZxZvDCzl7YI=;
        b=ODwLKeqYu0affdx6yxyzX/MwTSNWJzHS8xF6YNL3ky7MkwOjPXwc8Td/5ZchzH+HQP
         xlZ/vOnBqoG1JmnOQg0ZLheI1Tm9x7jdaYm18N8t0N3YwuXzFuJzC7CiGaoDPRBr/HP5
         nWtZ96Au1XgIMbLRh1AS6WQw6DjM9kAuo+Q0rK5od1jYcLAG+e09gVvxUFjvLM7yY/5e
         AJ1yhLKZQbbrqDxxkEI9sN1MHYKJ83/IxEbltRVFZSupU20TAZo81z3x6E6557WRPA2t
         1z2jxHlD+W1Y3MuhI9CmetCTGGKXOVwHPAPy4QoWkYqCsO775BSrsfBAQ9zTqV4aSFAO
         XYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787896298; x=1788501098;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hm4xgC3E24zQaBzzk1libVX+Z8H8hDTIZxZvDCzl7YI=;
        b=rznamEClFuirj8ZC69ZgjARWyNR2Bho1+P6lW4eKctxxaD8f+nJADvvyiUlgrh+vjk
         XXxilY4ODP40TyxkRGluOF5akYtXYJH9An9CT1L2b6IQviYP7H1TTxz1+njvfrEBAOX3
         oqSL3A7+V8U3LBzUcNSU8tBBGR//kA4d2GiEgFoMdhjndDS8IHOCcTBL8j+1XYQKaRg/
         Z4fdQjGYPFmI5QcnRhqpvmTGsgeIqt+ZYI3/hv+DKsuJHX+vAExEPYN4rxDrcsjH+4PF
         ejjxLaWeXgM7Z2ru5i4kcLE4mUHN9XzCfxUjjyQl2wHVLVulHMUH+NT0AE2mWWZBf5Xy
         YDmw==
X-Forwarded-Encrypted: i=1; AHgh+Rr/c+mPJx9nvPHXf1Kz4gcKedrpu7+ocvgohtPaLilX9TANrGerXrKiRq9SSY7vPt4QKSxz3Od4zQ==@lists.linux.dev
X-Gm-Message-State: AFuF++kPrpZl+nVqZ+/DdyM3RwNzklJ2gcEe0BlCru/yTXQopMnK0h+6
	Wh7+GCLXzU1ATRG1/qBr0KFNF3RXBGfSM2KG4xHkBN7lGI8eEkl26ZKYqaN19OgeORKyg3ArW+e
	rRrh+DiW/W5aqyVxsuIndKlxf3IEqHbD+5XZUYpnarNv1AfvBnRktHQ==
X-Gm-Gg: AR+sD13/Gp3iu69cOTS/rh/xrISAAex4/cZftJHXqjiSEzEBmg81+tlnZh3b2Renr7q
	Uhdu1ee5dDHZktqJUxRS+t9qObBWOskItEPki6JH18cDxGrqJsefWa8dOrM2aiFRGnVo9ocWXQY
	7To7a44QZ2ygPqsOqlG8FRBxxH/XEI/db+C6BDffP2+ewgzoXlXXTBe4btIPun8PlOJSS54zauY
	7qhWH7rJuv87HpFFboN2b+MebOf/B3YtcXp67mTDbcfiIvnInLAs7KEa9PrINtNgLhBcYchPFVX
	YOBFILIemN4yxGJeuxP1VMfPyXIm+pRBu51AWX2dVdBcUxQwmf2ZgRH3xIZVDZ8nUI28O4tmxmI
	hevzAFgqpgBWdA/QMmpshfqxHNdPl9hKa
X-Received: by 2002:a17:90b:1dce:b0:38e:5b59:c2ff with SMTP id
 98e67ed59e1d1-396d0ea8b47mr9762281a91.3.1787896297232; Thu, 27 Aug 2026
 22:51:37 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:51:35 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:51:35 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:51:35 -0700
X-Gm-Features: AcwNN1VWv8aVvRqurvOTERaQEJoSi8mJ1UC5bMOE-DaGb8jyYaB-qud6ia5EklQ
Message-ID: <CA+0ovCjSR_YcGORgj8Ydab6HtzJDxjOHZx9OU1L8j0PC-KSXmw@mail.gmail.com>
Subject: [BUG] UBSAN: shift-out-of-bounds in dm_integrity_map
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: falemi@asu.edu, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/193-ubsan-shift-out-of-bounds-in-dm-integrity-map/

  UBSAN: shift-out-of-bounds in drivers/md/dm-integrity.c:2106:52
  shift exponent 138 is too large for 32-bit type 'unsigned int'
  Call Trace:
   dm_integrity_map+0xe14/0xfe0 drivers/md/dm-integrity.c:2106
   __map_bio+0x5e8/0xa60 drivers/md/dm.c:1426
   __split_and_process_bio drivers/md/dm.c:1760 [inline]
   dm_split_and_process_bio drivers/md/dm.c:2034 [inline]
   dm_submit_bio+0x73f/0x2900 drivers/md/dm.c:2090
   __submit_bio+0x475/0x880 block/blk-core.c:644
   submit_bio_noacct_nocheck+0x467/0x990 block/blk-core.c:755
   __block_write_full_folio+0x7ee/0xdc0 fs/buffer.c:1830
   blkdev_writepages+0xef/0x1b0 block/fops.c:486
  Kernel panic - not syncing: UBSAN: panic_on_warn set ...

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
