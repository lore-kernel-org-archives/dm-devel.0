Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D348623AB95
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 12:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764677529; cv=pass; b=Kf7cNaN0CliyJUQ5LXffQi2CayOKgYv6l1M2LZxpaGnKPFYIN4++zGPrRxuIpVSFl5+9KhdT+iMNXQa5FhqzNkogB326NcISHr0bPLfz3TmfrvK0aH7cgGjCqwZHEN/tGPDBMr9+67bZDx2qGPIj6uG3ga4FqbH3ct/+q4/B3IE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764677529; c=relaxed/simple;
	bh=uDBhQW/8n5CtKMELSsZI3Ge1KzTLlmmQPBlgZRypu6U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=R5ve56qIr7tBPEsU9qqn/HxcVZzbmf7eZ+Zv8/etO4H6LrU1Ji0XNgONwZ6mE29dAPcUVQ0kFSuz9bAw8XJthRzP8Y17t7GlS6rBc356tiLoEtrxII+T65JZ+L/3jrINTD+lQAtWPxj9QQZel4d3l0En8DQYBiCWXW5NSMyVbeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=O/9Bnxlj; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="O/9Bnxlj"
ARC-Seal: i=1; a=rsa-sha256; t=1764677523; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Rg+vjuLsljljLUsuUhQ3005P0L0L39lBt9M/6Bz4wa8NKZjcd2kvU9Wh24/sweXu7Mwcd7imOjX1rhXb8147Fum9NUPKYhxUCCd+ctQqX0wG9d7c2BTE3dnnOskDAevmb00wVHBW3foGeHjx0q5a35+AnLJoeu7f9bIrmyd4VfU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764677523; h=Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=JXiZNj8t20+eyvtQyKqneNbunN0RjZ+jePjtswDTiiw=; 
	b=SpCf4Zx4C5n9cR07/jU/9R8EVTQaNL7uYbHwYJ47Ni23dSABeFTA+MwK6gS+KXr+ODDFQiCAMOZlorkA6zi8lBRO2rQFE6dUUxHI0/iXB1SlA8NMS9tnqG/zPxsVqWooTRocqaT+cLDTzZkBFmLqn4ncQNeentMe5wgGuKvz/Mo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764677523;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=JXiZNj8t20+eyvtQyKqneNbunN0RjZ+jePjtswDTiiw=;
	b=O/9BnxljGkpMOAnbElFuY8LETMrNm3IuosNrajJqZhQZQK2ywDhVTnGC2MADKFTs
	iZniMj1V7+WjtsLxUllrJIHyxq4Gitw17T9MR3thOi+Ch0ntpnDkzx6BqsISPjNAbNl
	9+xX3U97dMwnhYjbzgZlSGZwAc9qOfSo2BigHQOE=
Received: by mx.zohomail.com with SMTPS id 17646775229821022.9523785710982;
	Tue, 2 Dec 2025 04:12:02 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH 0/2] dm-pcache: fix metadata indexing and persistence issues 
Date: Tue,  2 Dec 2025 20:11:56 +0800
Message-ID: <20251202121158.111092-1-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

dm-pcache stores metadata (cache_info and segment_info) in 4K-aligned
slots on the cache device, using sequence numbers and CRC to identify
the latest valid copy.

However, the cache_info and segment_info paths were computing their
on-media index using sizeof(struct) instead of the 4K metadata stride.
As a result:

  * cache_info updates (including gc_percent set via a dmsetup message)
    were written to invalid offsets between metadata slots and failed
    to persist across table reloads or reboots.

  * segment_info indexing became desynchronized, so rotation to the
    "next" slot no longer matched the location returned by
    pcache_meta_find_latest().

The issue can be reproduced with:

  dmsetup create pcache_vdb --table \
    "0 $(blockdev --getsz /dev/vdb) pcache /dev/pmem0 /dev/vdb 4 \
     cache_mode writeback data_crc false"

  # Check default gc_percent (70)
  dmsetup status pcache_vdb

  # Change gc_percent to 10
  dmsetup message pcache_vdb 0 "gc_percent 10"

  # Verify change is active in memory
  dmsetup status pcache_vdb

  # Reboot the system...

  # Without patch (gc_percent reverts to 70):
  dmsetup status pcache_vdb

  # With patch (gc_percent persists as 10):
  dmsetup status pcache_vdb

This series fixes the issue by deriving the metadata slot index from
the pointer returned by pcache_meta_find_latest(), using the 4K stride
(CACHE_INFO_SIZE / SEG_INFO_SIZE). This ensures that updates to
cache_info and segment_info are written to valid slots and remain
consistent with the on-media layout.

Li Chen (2):
  dm pcache: fix cache info indexing
  dm pcache: fix segment info indexing

 drivers/md/dm-pcache/cache.c         | 13 ++++++++++---
 drivers/md/dm-pcache/cache_segment.c |  6 +++++-
 2 files changed, 15 insertions(+), 4 deletions(-)

-- 
2.51.0

