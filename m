Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE01F433B3
	for <dm-devel@lists.linux.dev>; Fri, 10 Jan 2025 06:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736491111; cv=none; b=ffup/jsQ9o4W56jDflKU9TZxeCQD3YlJ3TR3bmnDD+XBy7sDrGny3PnAxM12LQOKGKEBZ1P3zWyMzWl1GvcQn7F/lyYhO8sxM9Hx0f1A0erDBRLO4nBUAXuCUvXu16CBKLpAVCwCjEYVBZ4dzmFXDRjTODbe+TS/iZu7udpq13w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736491111; c=relaxed/simple;
	bh=xiCaJUEusVGjslN8HXBIgbTM4nRIxTttX/bli0hHZt0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lsLpl3d80mIBfLBbHBsMBbiBEPKHMZo4gPm9DwslfkbklAGqAPlSSuInS4MWhkDrVusvo6iRdF+DylmDQ1kTSQmJLVi6mu9HQJ3buzq0NzxsTTV75LE9JmSuw6+j25NeKOEmif+yXfJPGYCSdfRj1inho+a6UUVOoFvR7AzlE8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YTsPc5sZbzrS7M;
	Fri, 10 Jan 2025 14:36:36 +0800 (CST)
Received: from dggpemf200016.china.huawei.com (unknown [7.185.36.174])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E58F180217;
	Fri, 10 Jan 2025 14:38:18 +0800 (CST)
Received: from huawei.com (10.174.176.212) by dggpemf200016.china.huawei.com
 (7.185.36.174) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jan
 2025 14:38:17 +0800
From: chenrenhui <chenrenhui1@huawei.com>
To: <dm-devel@lists.linux.dev>
CC: <lixiaokeng@huawei.com>, <bmarzins@redhat.com>, <mwilck@suse.com>
Subject: [PATCH] libmultipath: add condition for enqueueing path to io error check
Date: Fri, 10 Jan 2025 14:38:16 +0800
Message-ID: <20250110063816.759-1-chenrenhui1@huawei.com>
X-Mailer: git-send-email 2.45.1.windows.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf200016.china.huawei.com (7.185.36.174)

In function io_err_stat_handle_pathfail(), path->io_err_dis_reinstate_time
is set to 0 to enqueue path to io error check as soon as possible. But
multipathd can not do it within marginal_path_err_recheck_gap_time seconds
after power-on, because curr_time is less than
marginal_path_err_recheck_gap_time.

To handle the early marginal path, we can enqueue path when
io_err_dis_reinstate_time is 0.

Signed-off-by: chenrenhui <chenrenhui1@huawei.com>
---
 libmultipath/io_err_stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 4996c0b0..879c310a 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -367,7 +367,8 @@ int need_io_err_check(struct path *pp)
 		return 1;
 	get_monotonic_time(&curr_time);
 	if ((curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
-	    pp->mpp->marginal_path_err_recheck_gap_time) {
+	    pp->mpp->marginal_path_err_recheck_gap_time ||
+            pp->io_err_dis_reinstate_time == 0) {
 		io_err_stat_log(4, "%s: reschedule checking after %d seconds",
 				pp->dev,
 				pp->mpp->marginal_path_err_recheck_gap_time);
-- 
2.45.1.windows.1

