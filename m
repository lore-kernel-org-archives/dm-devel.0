Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F20F37CD5A
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 02:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787193025; cv=none; b=KqyH10r1Yac0zfSWuhWrcCM9ZBus5FzzQ83c0SQ3HNjxahsENVGiV429T2wQs+5ngrLtbGxZdcECJULwJDhnLGK4Nyd3xAErUwI2u40kAdmuyvahzryvoPsvSooHmr+buMyr7qyNoiv7SJOmvz1mHpnVoEqJK74reWB8wSd8zzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787193025; c=relaxed/simple;
	bh=E7u00EylPTyQZ0hegJggfQH2JdLIhj/3q8bc5lFQHyA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZdAZTPK4C0ldoKxJ4DSqk9o4vxGDxBfMZkFUCyci7VqXVfVAYXlVynhgqjwztW1RvcJRDbGRTsaUtQu6qgKrOKIUdacdkQL+oJ5YQspITKhE4rJubBlFh4s/ybgMQsO7wMIkPRVMA21McGkili0gafIhTOb1BLmxwxePbetSNME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hQS8734BDzYQtyK
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 10:29:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 6DFBE40539
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 10:30:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgB34om4ZoZqkD7rCw--.39952S4;
	Thu, 20 Aug 2026 10:30:17 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Cc: yebin@huaweicloud.com,
	yebin10@huawei.com
Subject: [PATCH RFC 0/2] dm persistent-data: detect btree cycles and record space-map errors
Date: Thu, 20 Aug 2026 10:24:15 +0800
Message-Id: <20260820022417.3841604-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB34om4ZoZqkD7rCw--.39952S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1DXr1DCFyrAw4kCw43trb_yoW8uw43pr
	WrG3s8Kw4DtrnrZwsavr40yFyYyF4fZ3yUG34DK3sayay5Wrn2qF1Uta4j9rnIkFyxX3WY
	vF4jg34Duw4DArUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU18sqt
	UUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This series hardens dm-persistent-data against metadata corruption that
can leave the kernel hung in an uninterruptible state.  The two patches
attack the same class of problem from both sides: symptom detection and
root-cause prevention.

Patch 1 adds a depth limit (DM_BTREE_MAX_DEPTH = 16) to every unbounded
btree traversal loop (lookup, insert, overwrite, remove, find_key).
When metadata is corrupted such that a node's value points back to an
ancestor or to itself, these loops currently never terminate, hanging
the kernel.  With the limit in place the traversal returns -ELOOP
instead, and dm-thin handles this error by aborting the transaction and
downgrading the pool to read-only mode so no further writes hit the
corrupted metadata.

Patch 2 addresses a root cause of such corruption.  The transaction
manager's dm_tm_inc/dm_tm_dec/dm_tm_inc_range/dm_tm_dec_range wrappers
have void return types, so when the underlying space-map operations
fail the error is silently swallowed and the transaction is committed
with inconsistent reference counts.  This can produce permanent space
leaks, premature refcount drops, and -- critically -- self-referencing
btree nodes that trigger the very infinite loops that patch 1 catches.
The fix records the first space-map failure in a sticky error flag
(sm_error in the transaction manager, data_sm_error in dm_pool_metadata)
and refuses to commit while the flag is set, all without changing any
function signatures.

Ye Bin (2):
  dm persistent-data: add btree traversal depth limit to detect metadata
    corruption
  dm persistent-data: record space-map errors in transaction manager

 drivers/md/dm-thin-metadata.c                 | 65 +++++++++++++---
 drivers/md/dm-thin.c                          |  9 +++
 drivers/md/persistent-data/dm-btree-remove.c  | 14 ++++
 drivers/md/persistent-data/dm-btree.c         | 28 +++++++
 drivers/md/persistent-data/dm-btree.h         |  8 ++
 .../persistent-data/dm-transaction-manager.c  | 74 ++++++++++++++++++-
 .../persistent-data/dm-transaction-manager.h  |  6 ++
 7 files changed, 191 insertions(+), 13 deletions(-)

-- 
2.34.1

