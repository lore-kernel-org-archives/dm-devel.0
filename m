Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A48E24E4A1
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 06:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781676083; cv=none; b=Pz9eN+feUd297vS8b4SDPKmY63YDEqDXF86rFT+mLx4pq1MDudFb5n8qjQJIslOVIt0q41LRDchGV1K7rixiMN6S8GPC71q5lwXnMPvl6SREJ8AvDNxAR2DBJpDUAIuWL6CZO7tZ+2gx/cd8FVAuejyJFVfLlSAvydq5kGsv9Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781676083; c=relaxed/simple;
	bh=9cTw/JnmOq+Lg/bik/bZdAun5MmzsMPz0mVbPrlMgos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fo3L+tYsme9CjtPjC2gS4YmbChJhmB1d8WufY8BDYhUi/rOjacHa11ZdmWkST4YfDBTcfqjDWIQWGlQ9HMqASg8C41BUC5QQmH81Q7LOYdYB9K/UwMPvxSywHHLqF3Y2SKD3FqxpDOIq1jBk5aXun5JRfqG53CjTsJGRyR5nMsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Br3QLQZ2; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Br3QLQZ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1w
	TYS6wlD6Y08GlyAG8ZJc1JnzrqWILMaDV6q0XLuqA=; b=Br3QLQZ2zk3EU7K5cC
	HRrsGF/oPYT3pFIEE8Zc9M30K19vpkZhibzD5CQNAgwYHY6M8tFCZmJFGezHYm0q
	rJqsPJe7jts+Clq6I4Lop9ZfCstluBS4qLKLGXQSAnx8FYqAJP+fYX/uH0wnTUHK
	iQ7M9yZUJKIrHNuh9+JbAfUJk=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDH8pUWODJqtz+rDw--.4521S3;
	Wed, 17 Jun 2026 14:00:56 +0800 (CST)
From: ghuicao@163.com
To: Mike Snitzer <snitzer@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH 1/2] dm era: fix NULL pointer dereference in metadata_open()
Date: Wed, 17 Jun 2026 14:00:52 +0800
Message-Id: <20260617060053.71051-2-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260617060053.71051-1-ghuicao@163.com>
References: <20260617060053.71051-1-ghuicao@163.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH8pUWODJqtz+rDw--.4521S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7XFyUuFy3JrykXw1DZF1fZwb_yoW8JF45pF
	Z7XFyfC395trWDZF47A3W8uFyY9a1jgrWUAr9F9w1qyw4Y9rWj9F4jq3sFvF1qvFWfKa13
	Xa1qya45ur4qkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUBMNUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC-Bg7zWoyOBi+PAAA3o

From: Cao Guanghui <caoguanghui@kylinos.cn>

metadata_open() returns NULL when kzalloc_obj() fails, but the
caller era_ctr() only checks IS_ERR(md).  Since IS_ERR(NULL)
returns false, the NULL pointer is treated as a valid result
and later assigned to era->md, leading to a NULL pointer
dereference when the metadata is accessed.

Fix this by returning ERR_PTR(-ENOMEM) on allocation failure,
consistent with dm-cache-metadata.c, dm-thin-metadata.c, and
dm-clone-metadata.c which all use ERR_PTR(-ENOMEM) for the
same pattern.

Fixes: eec40579d848 ("dm: add era target")
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/md/dm-era-target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 05285c04ff2c..08ce96e8cf4f 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -810,8 +810,10 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
 	int r;
 	struct era_metadata *md = kzalloc_obj(*md);
 
-	if (!md)
-		return NULL;
+	if (!md) {
+		DMERR("could not allocate metadata struct");
+		return ERR_PTR(-ENOMEM);
+	}
 
 	md->bdev = bdev;
 	md->block_size = block_size;
-- 
2.25.1

