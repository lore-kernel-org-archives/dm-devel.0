Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549F037FF54;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781869496; cv=none; b=phuLySDZ5pFvGrBBKXH6ZGXjEqCA/sjc2VOzzBaSjEaXCzcFozEpAGsKU6D7VkpVgiNP9VRcKTodZ7MBrwnRRczdThlF8Bfwg6/9AqDtWrtwvPFgE63YAd9h+mU/SLZFyoqzZ5yeP3A5k8mcl0SXpEtc3HC+zBcwk4UbrCf75Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781869496; c=relaxed/simple;
	bh=AuAvjSYW6ETSoS2LpoKglEo3RierbpsTzWflE2fvQ5s=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=m22iZ7Q2OBAA6dWEgk6JtA9cEcpLJhZ+PKjTxI2Rov1Tv/348cPVwOoM0RAisFON4rfVLPC3Qso89Szvrr7UiF1Wxi7pPrEm9Gxo5ryuV+MDysc6j05cBWxlOw+N+NdQlLHe7EElo+jnoWg2O0msnRRz5wbYWGQ0Xm7kX/siR54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFW7jqvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFW7jqvz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0CEE3C2BCB4;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781869496;
	bh=AuAvjSYW6ETSoS2LpoKglEo3RierbpsTzWflE2fvQ5s=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=WFW7jqvzpsiJYi0NZ1y2XEiQVZFf+9MPRW20WLZs6hdiWjvknmQ6Bp9W/Di+8cOkF
	 Z09dqTR0hmcFawV6uqWVpP27pSYk8/WFHjlkz/39TTWBdDN6OpfVX2Xknc7WGwLMjh
	 Da0d4gMhfEpxlPp3lEX/ZHp0RxeYGF3bepN91WmIUeGlJv0zRly0fXtjQUeCqIBkCl
	 ZN750n7OHbIAWxC+DqrEA+emcFG0Cd54Jhv676USk/0WJZraVper+vV2KfRIZcPdh/
	 Ux1atBW/5W+9CFaUmv3ouE1SUuV3T/TrPLFQohjetD3sXwJmDTp6Q71Lnsm4Y8/QCt
	 8gF4YS6AN21pg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC492CD98F2;
	Fri, 19 Jun 2026 11:44:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH 0/3] dm-pcache: validate on-disk fields before use
Date: Fri, 19 Jun 2026 06:44:54 -0500
Message-Id: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALYrNWoC/x3MQQqAIBBA0avErBvQDMWuEi2mnGo2FgoRiHdPW
 r7F/wUyJ+EMU1cg8SNZrtig+w62k+LBKKEZBjVYZbXHdcQg+UbvnXOGNFpPgbQKhgxDy+7Eu7z
 /cl5q/QAFVmH0YgAAAA==
To: Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, 
 dm-devel@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781869494; l=2680;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=AuAvjSYW6ETSoS2LpoKglEo3RierbpsTzWflE2fvQ5s=;
 b=Wy+rmqffze5Fioo3hwyx8CmXsMYrS9U0prLQqoerFad1jcUVDtbWRpD4a2g35fntG5KYYjxbH
 T8kmColW9+VBcLGJeYqp5GgtEgfzzvGur0UcjqTzp1i+TgX23E5+BFt
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

dm-pcache reads its layout from the cache device and mostly trusts it. The
table load needs CAP_SYS_ADMIN, but the on-media metadata is only self-checked
with a CRC32C over a fixed, public seed, so anyone who can format or swap the
cache device forges the fields and recomputes the CRC. Several of them become
segment ids, array indices, loop counts and intra-segment extents with no bound
against the device geometry, which turns crafted metadata into kernel
out-of-bounds accesses, both at table load and during normal cache I/O.

Each patch adds the bound where the field is decoded:

  1/3  segment ids that index cache->segments[] -- bound against cache->n_segs
       (cache_pos_decode, cache_key_decode, and the last-kset paths in replay,
       writeback and gc).
  2/3  cache_info->n_segs and the segment-chain ids -- bound against the cache
       device segment count.
  3/3  the kset key_num, read by cache_kset_crc() and the replay loop before the
       CRC is even compared, and a key whose offset+length runs past its segment
       -- the latter is an OOB read that otherwise reaches user space on a cache
       read hit.

I found these by walking the cache-device decode paths. Each class reproduces in a
faithful in-kernel model under KASAN: the bug arm faults (slab out-of-bounds -- a
read for the seg_id, geometry and key_num/extent cases, a write for the n_segs
loop), the arm with the added bound is clean, and valid metadata is clean. The key
offset/length case also reproduces under KMSAN, where the over-read returns
uninitialized kernel memory. Reproducer available on request. Each check rejects
bad metadata with -EIO and leaves valid metadata alone.

checkpatch --strict is clean apart from "Alignment should match open
parenthesis" on the multi-line pcache_dev_err() calls, which match the style
already in the driver.

---
Bryam Vargas (3):
      dm-pcache: validate seg_id fields from persistent memory
      dm-pcache: validate geometry fields from on-disk cache_info
      dm-pcache: validate kset key_num and intra-segment bounds

 drivers/md/dm-pcache/cache.c           | 17 +++++++++++++++++
 drivers/md/dm-pcache/cache.h           | 35 ++++++++++++++++++++++++++++++++++
 drivers/md/dm-pcache/cache_gc.c        | 24 +++++++++++++++++------
 drivers/md/dm-pcache/cache_key.c       | 21 +++++++++++++++++++-
 drivers/md/dm-pcache/cache_writeback.c | 22 ++++++++++++++-------
 5 files changed, 105 insertions(+), 14 deletions(-)
---
base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
change-id: 20260619-b4-disp-997773a1-69ada10d3a3e

Best regards,
-- 
bryamzxz <hexlabsecurity@proton.me>


