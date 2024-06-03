Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7AD12C484
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419493; cv=none; b=XyWy94pNzxa/tumz23tJpy1itdkZcBryTi8nIzn8d3E9s4QMG0acpreceJfUcuc1TPrCIZ7IFfcUJubAZl2x/tSOBhUmoYBSJ+3StFllMeSC+6DGlWX4PY7ZnbosxTTQtjvHlpCwiiiuVnRcEytUyK4IjyyHV6teQlKV4nBA1No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419493; c=relaxed/simple;
	bh=OU4mVbRF8T7fGhSRohDJTOAtuVkdmbk3kcb/uJg5Lg0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jDa2VKU3lKRe8af7P66MxAiznGB0u35a1bNIZ8WzQM7+jivCSmjeylWrGB4hsn30p4QJbJBH3f4UyQYSXsnOTxWQHGBrxiYV614UEehH/j0XcOC88J6ds8oxLVccmc1Cp37dKlyV6V1Sy8wNzMkGDmukWA6JLPi34HCpn/KaODk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VtDFN31XCz1S91T;
	Mon,  3 Jun 2024 20:54:16 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D7D2180060;
	Mon,  3 Jun 2024 20:58:10 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:09 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 00/12] md: refacotor and some fixes related to sync_thread
Date: Mon, 3 Jun 2024 20:58:03 +0800
Message-ID: <20240603125815.2199072-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Changes from RFC:
 - fix some typos;
 - add patch 7 to prevent some mdadm tests failure;
 - add patch 12 to fix BUG_ON() panic by mdadm test 07revert-grow;

Yu Kuai (12):
  md: rearrange recovery_flags
  md: add a new enum type sync_action
  md: add new helpers for sync_action
  md: factor out helper to start reshape from action_store()
  md: replace sysfs api sync_action with new helpers
  md: remove parameter check_seq for stop_sync_thread()
  md: don't fail action_store() if sync_thread is not registered
  md: use new helers in md_do_sync()
  md: replace last_sync_action with new enum type
  md: factor out helpers for different sync_action in md_do_sync()
  md: pass in max_sectors for pers->sync_request()
  md/raid5: avoid BUG_ON() while continue reshape after reassembling

 drivers/md/dm-raid.c |   2 +-
 drivers/md/md.c      | 437 ++++++++++++++++++++++++++-----------------
 drivers/md/md.h      | 124 +++++++++---
 drivers/md/raid1.c   |   5 +-
 drivers/md/raid10.c  |   8 +-
 drivers/md/raid5.c   |  23 ++-
 6 files changed, 388 insertions(+), 211 deletions(-)

-- 
2.39.2

