Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22A9351FAC
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 12:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762863234; cv=pass; b=jNm0niN0E5G/OZk57MKDmsRTzAp9RsR9s344yQMYGEcJ5s/egF20zgpssYKbU7S8cfkazaJOjwucqxopQrvOVT9WSr08biiAM2g72UcfGO8/TlqkiN51nWJ8OQ7ZggfoqwNKN7auWdW+w/yD/w6VdfXNt0nsNQLVyUsax/zGjTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762863234; c=relaxed/simple;
	bh=bRS9V4HtbYmM8BwFtJpce720ZwyDchDBNTwT0Chs4IQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bLsFf/jEJWY0I9q8H50g9MSQylqjRsOMdQxAq+h273kEIt6vqtj7ZLkAr/HfheEWZH/29tWrXW3wkv/UDBuPfIfgc0H2TvKPBJ1ODiWIYfiecoo8ueGW/AA1fEu+xQmiJKPxvzTRC+zxq4mP90CsFVaClCbkNAIGfMy8b32d1e8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=o+CmB8py; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="o+CmB8py"
ARC-Seal: i=1; a=rsa-sha256; t=1762863226; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gN/Lx4L0GQW6eZ2bhQ2hqBttrkhwCcg2rs2cQfpVyamggmo/4k4gw1OYNBBRo7qqMo71Rjf+Ki7/6MGDCXb1AoRAGRFfrSsCHKEKppkVpDZ09eHTkjbCPEWd/shR0krTGfWyRHWMZd4q8/kAM/4Uo4IUR9w+KsBuSA9JrWrjtxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762863226; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=3rf1D/4fwTGRB2QLWhJTsTTHiMYMJjvBFzasPMzswiI=; 
	b=HtPkaslzW7pkCKH6YGtLMUwiDaY/WI17Q64pJnBg0kt1PRohxw9GM2P7ZMG4M3ccEBN19B+m0YbDJJUSRV+JmWWLWW2Zgvh/pNugol1FFqJ1CER8M0yM83MduPvKstzOf5AUYJK0QLC/Cnu8jUp9iYkcLPj4tD260iq5CMeML7s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762863226;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=3rf1D/4fwTGRB2QLWhJTsTTHiMYMJjvBFzasPMzswiI=;
	b=o+CmB8pyZhnL/LhJFqpOTm2LU6fjraIFJBDhTPygmgGSSTFjbfEHs/LB+/i+Nj0F
	8BxtcgF/sNGwxPh2QdjNCPEudQVh/tNOXvsAYhNmGcJJWNlcBV5CYI5heNNd0bJkC8c
	Iha68X5GT3sT8DFJcCPuEfkJ41WnLleiNXdQ5abI=
Received: by mx.zohomail.com with SMTPS id 1762863222724300.3267506287883;
	Tue, 11 Nov 2025 04:13:42 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH v2 0/3] dm-pcache: built-in support and metadata hardening
Date: Tue, 11 Nov 2025 20:13:33 +0800
Message-ID: <20251111121337.1063443-1-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

This three-patch series tidies dm-pcache’s build glue and tightens the metadata scan.

Patch 1 allow dm-pcache to be linked into vmlinux and avoids clashing with the sunrpc
cache_flush() by using obj-$(CONFIG_DM_PCACHE) and renaming the helper across the tree.

Patch 2 drops a redundant recomputation of the metadata slot pointer while walking headers.

Patch 3 Ensure dm-pcache initializes cache_info from a zeroed state so metadata CRC
failures can’t leak stale flags into the new-cache path.

Thanks for your review.

Li Chen (3):
  dm-pcache: allow built-in build and rename flush helper
  dm-pcache: reuse meta_addr in pcache_meta_find_latest
  dm-pcache: zero cache_info before default init

 drivers/md/dm-pcache/Makefile          | 2 +-
 drivers/md/dm-pcache/cache.c           | 4 ++--
 drivers/md/dm-pcache/cache.h           | 2 +-
 drivers/md/dm-pcache/cache_req.c       | 6 +++---
 drivers/md/dm-pcache/pcache_internal.h | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.51.0

