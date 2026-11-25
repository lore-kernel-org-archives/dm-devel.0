Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795581229;
	b=e7T6O2NDVm+GdqdPTuJiNnXbRI0I3t3eqaIHakPvW2Sjb7Dld/1nOk2+xr8IYmciT4SA
	 WI6ay7cUnxfKI/xmtBJWOkTIzYb/zuctTRrWwvyIFsEJoSCbl2MIfMTIAfer306IvRk0l
	 WgnL7H+Sl27U0+8TDoSCzE/oy1bY4A9FmWMmCdwHSmag6bCNZlPC9pSa4i/+ICGre0Q2o
	 V7P0mWq/G1QkYRz354txpVzeZQ+B9oA4c0vu5R3anEsPl/gk/02ZkSrDWEYOOIlv2k+0o
	 Yb4wHC9F306SGd6UTR+cAX06gTTRaSLd0TMG/p6upkXd+C5NurFWlp9vIc4/H/QiJRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795581229;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZT+4sCsr3xr8FnfN5LLRrbbwBT9PMqCRbtWGTXSuCNQ=;
	b=T+ZIFBRK3JYoqVgWrA2hPLYDYN9c+AZbpjVVv52wDTflSBCgw/dvz9oN3sip+nEB3NP8
	 mnIY5B8mZh0PG4QN40zIkNz1Al7XAp3fYp3y1jrkGhfGSJXbB5Kbq8ksNq0Qp1xH+Ef2d
	 fxJet2Pn3Zq1LSJNndLduWGCftN6CKMyXzrFGR2kZOOMJ25F3DHJJELnkkggcCmX4OxKf
	 K8TeDRe5BmBoIpqxXqyhh8lJUudreufKsYtGHly4ORcCIQRxiCKDV5FqX/fmIhAjjY4vy
	 WbFn7SWw6MZUI908bYjq8iLIeRIZpEiFQ35Jy2c8SIODk9aXOYL/wuVG3xQGsPtLCyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fOg9IQb2;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22314606A323
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 04:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22314606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fOg9IQb2
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b67f25e6e1so2580733b3a.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 20:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795581227; x=1796186027; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZT+4sCsr3xr8FnfN5LLRrbbwBT9PMqCRbtWGTXSuCNQ=;
        b=fOg9IQb2JVA/+9THVjV4sXkA8/oi5lKoE+xPQJtpKGLoBmIehQCNnEB79/4KX/bYQg
         f94AZoJDnYWk0JV9t0Y9alPYDJEXe3fo0G4Ii8X1qSoweyVvN3NWQ+f7RqgmaPctQobH
         3nfJXCeCTCOnkbHUB0kSa2lykgfcQeC7DDFNQfZmdjxKws1xQFnMDkob25wchCEQ3BhO
         t0lTQq2CYYCdiPxgjsDJ03qJ1o+NMjg4qpLaRUmF1c50pFI5oPFBii+1WCl5uUod9efg
         Rv7P7NhM7GrPT9ZGo6wPG+jHp1gAQ3GOwn9hu+zmJK96R50Nw3DMIExzm0nUeYRxC+8p
         P6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795581227; x=1796186027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZT+4sCsr3xr8FnfN5LLRrbbwBT9PMqCRbtWGTXSuCNQ=;
        b=S+WPfj59RwBhkK7ZzvdDEp8RcjSDC/Q+8sojU92ArGDxFtAX474qc3zyRm/4OcoTRS
         2xe8G9D1PRvBMaSyX68PNXMsnYsULnPc5GdXH9+/E0idaWFaAK5FiQO1yE3LeEjykEaw
         KVUo8UkPo1dvNzS9P3ca75+yklfs6sP1zCIjUSREa8Zqk2N79aJB2dUYni0SgP40rzn1
         cN3NTy8I2fvNaDxK4+wGxs3c8ZmlgWz7MLg9kronyPMzKSe4/DvaOFmKPIs4rAJLOrDJ
         0UKUoZjzTbbjEOYdPBqFGjyXXZem+axqN3SFDAy9ihwbpJYVWA6O6K6XGnY9mNXOPbdu
         3ocg==
X-Forwarded-Encrypted: i=1; AL+hErH1pzxOOHCO2PO8BM+NwthOU9+oX/DMu1u/Qi+GX5zKKbFECpP1NCWn6k7ZzTe4Czfcdu2oQz8/XA==@lists.linux.dev
X-Gm-Message-State: APuU4Z8xwFyD8vBq7Ny3PDrw5X3NgKDdMo4bFz8FhYVNClOJ2FLVRdkF
	P2Q2683rf0tKXKNC7+sFQBjlwTF9AzBeCx9h+0GFSMtqJJnx+skd1WX3
X-Gm-Gg: AZFdTZfg6mhIyTR39dakmz3sMtVRp9Kqh6CVtifHlqUKrxPSML5/6rGDR92FspS7MJH
	B1XQRCYTv2rT05xrIJTn2XEfHAFO1iqGwKqbD5FtckegUP7CAzCbj2kT41wkW/4pzRdKv0lP3u+
	WNbCtPO1iL3pkD4O1+SKZoTBjqTJyR54dnszHNh9eOcC9mV72YACTCNt1jQnPqL6Odnv2g5BWWI
	CoEzLjTyjQ0m771cd7+te8d1yxJTStQN0FJhIKjtXBMY11trqAsILs2YVrsaQGNTCzcPR+OBUEm
	3oBS0IGon9WoFjz/miTLhSdgcDKEe0rzitZDikE1qdoBIrHoo6NVyIfdgiLQAOEK18nDUS9RbIc
	2Y9kbC5dbkius0MF+VrdR/y09i/Evv2HollUilZ9U+c7QcXcs+q9qAtvlfi1vZ25CACgyuJtXRx
	plmIebLWJLs0zU9gxQw6aeTVkfIxNXaJDnwG+gOCqwMv/NfjUV9Q2+SmpwZPDHCaSwUrTe+JHyz
	cqbBID2AePkxKFCNannvgRa9P6BNW8V4A2Vq5P7XwbJt5Lel8RC7oYQ+iZ2pds+5Clcb9UnTRJj
	sFeBvhxUFlb3+BnoGE8YKfePTmYTZoPJVjVXuWzxT3BHtVGClwcH1WCKfVpeWN5SPmJAeKLKjF0
	tKgZ4h7eUsNRXTTBDckqgiN6z5VcmKC5m2RFqIMa5gcOMgbao1l9+rxWrvW397FQOLEYjEg==
X-Received: by 2002:a05:6a00:b80c:b0:899:74d0:8a72 with SMTP id d2e1a72fcca58-8c87d90393dmr15459092b3a.59.1795581227294;
        Tue, 24 Nov 2026 20:33:47 -0800 (PST)
Received: from yupeng-XPS-15-9520.. (c-73-169-192-12.hsd1.wa.comcast.net. [73.169.192.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f726sm8528812b3a.36.2026.11.24.20.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 20:33:46 -0800 (PST)
From: Peng Yu <yupeng0921@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Peng Yu <yupeng0921@gmail.com>
Subject: [PATCH 0/2] dm thin: complete writes only after the metadata commit
Date: Tue, 24 Nov 2026 20:33:23 -0800
Message-ID: <20261125043325.138351-1-yupeng0921@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a new option to the dm thin pool: wait_for_commit. When
wait_for_commit is enabled, a write or a discard will return after the
metadata is committed. By default, wait_for_commit is disabled, and the
thin pool behaves exactly as before.

Why we need wait_for_commit:

Assume there is a server A, and the underlying device of its thin pool
is an NVMe-oF device. Server A creates a thin device and exports the
thin device to a remote host via NVMe-oF too. When server A fails, a
control plane will rebuild the pool and thin device on a standby
server B, and server B will export the thin device to the same remote
host. When the remote host issues a FLUSH, server A fails, so the
metadata are not committed to the pool. The thin pool fails over to
server B, and then the NVMe-oF multipath resends the FLUSH to B.
B receives the command and finds nothing to flush. In this case, some
uncommitted data are lost, but the remote host can't get any error.

As the dm thin pool doc says: "the thin-provisioning target behaves like
a physical disk that has a volatile write cache". If the underlying disk
of a thin pool is a remote disk and we want to fail over the thin pool
from server A to server B, the "volatile write cache" is only on
server A, and server B doesn't know about it, so we will get a
consistency issue. The wait_for_commit option could fix this issue with
a performance penalty.

Below is a performance test on my laptop. We got the results in a VM on
loop devices.

1 MiB sequential first writes (no zero fill)
|                      | 1 job, depth 1           | 8 jobs, depth 8          |
|                      | MiB/s | mean ms | p99 ms | MiB/s | mean ms | p99 ms |
| no wait_for_commit   | 1307  | 0.65    | 1.59   | 1596  | 39.7    | 276    |
| with wait_for_commit | 131   | 7.57    | 17.7   | 776   | 78.2    | 148    |

4 KiB random writes, mostly to new blocks (allocation and zero fill)
|                      | 1 job, depth 1, 2000 writes | 8 jobs, depth 2, 10000 writes |
|                      | s       | IOPS   | p99 ms   | s       | IOPS    | p99 ms    |
| no wait_for_commit   | 1.16    | 1723   | 0.97     | 4.96    | 2066    | 15.3      |
| with wait_for_commit | 10.5    | 195    | 11.6     | 15.1    | 673     | 49.5      |

4 KiB random overwrites of mapped blocks, 4 jobs, depth 16
|                      | IOPS   | mean ms | p99 ms |
| no wait_for_commit   | 202095 | 0.31    | 1.12   |
| with wait_for_commit | 203293 | 0.31    | 1.13   |

Peng Yu (2):
  dm thin metadata: report uncommitted state and refuse commits after a
    failure
  dm thin: add wait_for_commit pool feature

 .../device-mapper/thin-provisioning.rst       |  25 +++-
 drivers/md/dm-thin-metadata.c                 |  61 +++++++--
 drivers/md/dm-thin-metadata.h                 |  14 +++
 drivers/md/dm-thin.c                          | 116 +++++++++++++++---
 4 files changed, 190 insertions(+), 26 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

