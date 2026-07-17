Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C60B3E5587
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 08:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277563; cv=none; b=aXdJIhhPaHpZ00Qk2qf6XBQiXw4XSVXpKwmJwSKbEPqQ2vT0dGAsaTYyReitvFCorf9o+Jw6nySSJWL70S9dZelyUZ/dKhZ1x1BH7zIQgHgfPky21/dDxRPBlU694eyCY8Zy6geix49AMxbzQPFNSoLFIi76lmIyXtCN5rSTg/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277563; c=relaxed/simple;
	bh=uyG2NstBGu9uvxcDQUpBx40TmRuBSCWvscMz9CspMCs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m3TB7nw50G6OY+oOWARuxXmmWVEqd5Z2GkiroA327po5k1w+s/aVBswxjRBw3FihQhwPiBQ3ekuxhCcIIFkXa1JG8AVV95AY/fvbRbXvfI/dfu/BeJXyzvI45Wkp6IWlLLTLCxc4fG20dWiaCfLFaft7sue1YpWazFsbqom/Nec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kqmBP9lr; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kqmBP9lr"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ccbff2e6a7so46870795ad.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 01:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784277561; x=1784882361; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ny8tEWn0LfJ+PXWsu9N+AvnciAXm3Eb06gckGWJf/ao=;
        b=kqmBP9lr0OaS+YS+C0QJWrb71oY4IYtbIOKBhIfnxnYRvgm4z8Bp4KRQVfrU61OBPd
         kYV205QK8aIs4S0PMZ4D9RegtdvHQcQ9SnszYJze2HwvVzuQqRR8uzpBT/sBjFLVYLeq
         vfnSv7jUq03aKFlwr6Gg+eKriBcRAHyQciPM3JT5K8M1LkXSkTuAKr/0vXtb42Wu65S0
         0X9BpVQap8CLzmgLK9W+nFomBJoOqE7O0M68qHI0aq4HN5YSrvXcXpbWJ2rwnDKp2D5h
         aOgaeFkku9G44he26VA+2eWIBrC52DZfzOc0rXnxzk+rqvhDB55ijHgvgdkf/FbiS9MN
         HV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277561; x=1784882361;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ny8tEWn0LfJ+PXWsu9N+AvnciAXm3Eb06gckGWJf/ao=;
        b=b9BNIwxHUht1CxpLmefmF7I9P1oKfy8p1NEy5gUI5BxCn+L4RHXti1IAMFzbFH86oc
         OtgBbcNHSR3s8OrQL9D0xaH45jrO4Am8cp25rbJaRHip9Cx5+o8bIyIEamSpt3YcZifR
         DuffAmP1ywPmiNPPqrs/Yw4ZotNKNtGrPyuH+QxYJRWgXs+ZoyXHu+M3RpUXB21mt9cu
         L8vTPQFXZrWwpRV9XtJTclH0pAbw64OX5jKJ3CIZJqfiNdx/3fBv5p0FZjir6Uso2oip
         ZzBZlNqsQNW1nk0uoL7LNspkq5vsbPlZlubei1VAvCLsrIQv20sdHX35fwDCK40WvSWS
         JQlg==
X-Forwarded-Encrypted: i=1; AHgh+RrZ7kveRv/bwWONNhCtHfPHQJb12oWc0Svq5D/lvTg5V0iDHV6Vfq3wf3rBDzG7TZvbUT37aFmEuw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyEek6mNa/Bw8B94R5kIwI5O4xYGW3rZ26NxpHJAyN02lLQhZrG
	nk4v3SApg8fjITA3mgqafUZxO9mQeYMuR78yyJneHYtTLTIdL0Y0uD+l
X-Gm-Gg: AfdE7ckc27DHaWV0PkZTfwfTSKekU4eOc9PBuXkEudv6+uLGJKwbHrFIqh2GC4BmPXI
	PZAobuBWzw2keIj/3PRjmGpZLLXuB5j/rOOOJVpissYpoJBMTU93HFmu+QioB4ECPNB70UIIrZ+
	m3QvaVJRV/OecaUnUdqW1jWWgDAidO1o6R7l7fcBnv/vDPJeatqFTDlehnM/xLGhPv1yUZ7iZ2G
	QT0z5lj2vam6PV6U7xOigXKADm21ofDxbt6AJppMce0iBORlORymcQLSlFTo+EQ8krtXQFTPXOT
	/ZDQ2txXwl4VM5Ma0KJwkEReFpLu5y19gEcgQFKE1Q2+BsCXzdj0h/l/7lj0fjYME0sa1a2/i6W
	f+8YE/88Q5WFZx0SAANookiYxsngFSxGftSbrSMdYujYeyJvc7B4YwSMaz8mi/rXL2P878yMNXU
	BJtgnIKZ3BteNNtPNh+YFfD4L3Y5k=
X-Received: by 2002:a17:902:da81:b0:2cc:7e4a:bcc5 with SMTP id d9443c01a7336-2cf34a48064mr16710945ad.32.1784277561368;
        Fri, 17 Jul 2026 01:39:21 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([118.112.177.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344be458sm6842445ad.25.2026.07.17.01.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:39:20 -0700 (PDT)
From: jianyungao89@gmail.com
To: dongsheng.yang@linux.dev,
	cengku@gmail.com
Cc: mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jianyun Gao <jianyungao89@gmail.com>
Subject: [PATCH 0/3] dm-pcache: minor cleanups
Date: Fri, 17 Jul 2026 16:38:53 +0800
Message-Id: <20260717083856.12820-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

A few small optimizations for dm-pcache:
- Fix ASCII diagram alignment in comments by replacing tabs with spaces
- Simplify cache_seg_remain() by removing redundant local variables
- Remove unused 'allocated' variable in cache_data_alloc()

Jianyun Gao (3):
  dm-pcache: replace tabs with spaces in comments to fix ASCII diagram
    alignment
  dm-pcache: simplify cache_seg_remain()
  dm-pcache: remove unused 'allocated' variable in cache_data_alloc()

 drivers/md/dm-pcache/cache.h     | 14 +++-----------
 drivers/md/dm-pcache/cache_key.c |  2 +-
 drivers/md/dm-pcache/cache_req.c | 19 ++++++++-----------
 3 files changed, 12 insertions(+), 23 deletions(-)

-- 
2.34.1

