Received: from mail-ua1-f99.google.com (mail-ua1-f99.google.com [209.85.222.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A81DF98F
	for <dm-devel@lists.linux.dev>; Mon, 11 Aug 2025 05:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754890828; cv=none; b=mB34kxOXsGQ7i6GFA/yCfssroypLObgTwxIBseKBblujipJNhSXVOTPa0wM6GAQr68F7jRjSDVW39eHxO782QZXf0fMS3euSugoaJQ2RQw7W9vXpCYrTwRWz6F0RLP/tq8rKCxSqmh17KYslTnCskIvilKT6lP0evf1nTn0YGPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754890828; c=relaxed/simple;
	bh=zrVBUNxxZqstsRJDYJz90CxtD6sPPVd06a6UywvSNv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uy3osGCiy3Dj80nX6stg7ao9Gv+CRHBMRD8ZijUTCwT2JscMYNWwbvAVLKG7QYs1TlvIw+Nqa6F7JZDH5PKW1mZNZUIvbKS+PF6HjhiNGrNIWwsu2zR5wnR/j1gDix8hXXgArpryZAs3QZWgk7Uh9Y9xW63xNjOOzcDRTkgneUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ENAVRAm4; arc=none smtp.client-ip=209.85.222.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ENAVRAm4"
Received: by mail-ua1-f99.google.com with SMTP id a1e0cc1a2514c-88db6483e3fso2493079241.0
        for <dm-devel@lists.linux.dev>; Sun, 10 Aug 2025 22:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754890825; x=1755495625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s5Tm8MncGgTzffuubiEuxBs0xK5k7TEVaXhLTBjgDNo=;
        b=daEY1hEILbmAMlQwAaU+x9ZLfHakoSNy4pvKOCEFpgt9ewEYsKpBcYYfyXEZzV697e
         Kt33PQb42IW6qPH3bBKU02/tQw1USiOTV6RvhpRidUKAIluNWP1nODSR6rI79+ho1nyB
         FMPoQaiVWO/KF5Yb12+iozSPoAdGSGbjTZQ1E0SA7lXWw4JeZUFCVYE0wApvgmbI/6iR
         9Ettc8bvIgkPOlY1YPBwErUiw4U/t3zKSyWDGdHw0gzviEmdy5Hc5YUZKtRq9EUxBr9z
         8tcEY1ylAVCwxcQOje2CIUzTeoFL9MLlnNFYx4GLE8nGk4bUvWBJVTK3csZUGKA9ZrZT
         Qp9w==
X-Forwarded-Encrypted: i=1; AJvYcCXmrE0CBJe3JoreL8xV57/UuQC5OexVprVfupzmxVVnqIC07elannrFt+Og5uC/d54/PPClWchmvg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+lLj1M0dpR6Fby0Dhu8EUgdYewMAnsTHYax339dbgADNmPV47
	5gUl1wgnlhWdAskMVV4kzyOLGJT+E/TCINTU0GQF7gFltc4wDVvFfbFc58GQdhiVWj7NfzUsltD
	Ux9baimPR9SN/nsOn06VMTgtHkKvavJw4oECJwSvPkuxsqweWRAOwmi23qEgJgo9LUmvxwhN8jf
	Kg1lHHLXzryCLzkHsniJvEvz9H2FtEXAKAsNB4L89hDqph86HYnDlxNrK6TWstHnzhnlgzjxBW/
	Ds7Sp1IEH5SFh2D5ehh
X-Gm-Gg: ASbGnctit3DvbMDA0xlZvhdXNQaB3RuKWHcOcXAeVLoL/MITGh9/ypeRXiXC5ps3m6T
	ABu2JzJXwsvrhjAChhbh7miyEoTHjmDuf5nBmEBdI7yNMUB4RBCnI8azgw9/v3vFen8M8ay6sCy
	mA0xIrIXQnm9Ch7lTRbOMios1T43oCZ3tFY+MofsU/Tr8VE9Ijh1Uon0gA2y/X5xJmq/DcnYITT
	XKjSnzBgtKHkttRtw/ejrom1N3WgdqD7NpZ3jFf3mQZ8NoAypdwcwjrteDfz2oJgHl5glB+V308
	2Y1z8+7GpIV8PrDBxJD+kHYs/9LqNqZ99PACuG5an9YzuE04ZrYCfxLQ6mRSDO/AkzQmNIzbLqi
	IEo7q1rbz81vcG9TzTSuK31lfufdMYIArJUNnr9tpDdVBKq/dF+H2TsgijVA/aAKcMMAte6TMwD
	sC
X-Google-Smtp-Source: AGHT+IGeRPWKp85XERwtNgspg5cWLcmS+bVEdrIvb93kpfyiZEm47gSKRxu/XQdUPzX9VsfyM3MiuY2r8Jkx
X-Received: by 2002:a05:6102:2926:b0:4e6:f7e9:c4a5 with SMTP id ada2fe7eead31-5060f0cf0cemr4211943137.22.1754890825364;
        Sun, 10 Aug 2025 22:40:25 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-5062bb517b5sm551221137.3.2025.08.10.22.40.24
        for <dm-devel@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Aug 2025 22:40:25 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-70741fda996so75639466d6.0
        for <dm-devel@lists.linux.dev>; Sun, 10 Aug 2025 22:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1754890824; x=1755495624; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s5Tm8MncGgTzffuubiEuxBs0xK5k7TEVaXhLTBjgDNo=;
        b=ENAVRAm4lsdmMbjOKyb5QZA1YukZ5UR+aPZtvvKtZFzlAdFNbChZOmpkotqlLedOI1
         9uMVk3GmerpExCNtQU+F58dEGUd0KHXqAMNA0VlTe/NwBYHZLHzO6eeBt3IwKjcFTE4A
         A1lqpwX1EJ2v44NHY8LMrw8eHwO3I0VmcyE74=
X-Forwarded-Encrypted: i=1; AJvYcCX68jwXgDE9hYDLQH9sI0YHxkd6DOqz+H8ugYfqk2s7Rnsw8jbuIO1DQhlKGI+Dt4we39p43DidHg==@lists.linux.dev
X-Received: by 2002:a05:6214:528d:b0:706:ff82:a3c8 with SMTP id 6a1803df08f44-7099a1cf2b2mr155458566d6.5.1754890823859;
        Sun, 10 Aug 2025 22:40:23 -0700 (PDT)
X-Received: by 2002:a05:6214:528d:b0:706:ff82:a3c8 with SMTP id 6a1803df08f44-7099a1cf2b2mr155458396d6.5.1754890823367;
        Sun, 10 Aug 2025 22:40:23 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ce44849sm150544766d6.84.2025.08.10.22.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 22:40:22 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 0/2 v5.10] Fix CVE-2021-47498
Date: Sun, 10 Aug 2025 22:27:00 -0700
Message-Id: <20250811052702.145189-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Hi,

 To Fix CVE-2021-47498 b4459b11e840 is required, but it has a dependency
 on e2118b3c3d94 ("rearrange core declarations for extended use
 from dm-zone.c"). Therefore backported both patches for v5.10.

Thanks,
Shivani

Shivani Agarwal (2):
  dm: rearrange core declarations for extended use from dm-zone.c
  dm rq: don't queue request to blk-mq during DM suspend

 drivers/md/dm-core.h | 52 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-rq.c   |  8 ++++++
 drivers/md/dm.c      | 59 ++++++--------------------------------------
 3 files changed, 67 insertions(+), 52 deletions(-)

-- 
2.40.4

