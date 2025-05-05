Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1282F3A6C;
	Mon,  5 May 2025 23:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486884; cv=none; b=uXlM/rfmzt5tesRRWOJKrCC2bnI532T9cAcPAP0zX7nhE68DevFrhN6rMVE5KuM83T0rDbagI9NLeGMWBuA3ZNct4ORTPVzpdmdkdf9xYIiFwlhJY6Gr6X2UN7D2wcwi5wij2NiH0aOAI7swQV+GWFceiYOhwLM+37F4WYiIQuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486884; c=relaxed/simple;
	bh=uzRngQ09N+cYqFREnf8hrA6RbO131KtnUMMDuxB7Wfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RZwOq7/9ho0O5aHPeYaGzKqu+YGOmA3mUFoSaiZxpJDcl5HKUIj7B30BoOdUOXydHUgNSAIa2U7uUUZ5InqoKbu4P6QbZacvhTaboGq47+TdaM7brFprlFQHBMa2WybgKlZ37DRd3g7JCufMwMnLF2iIlfe1o39DnHDlgPYy0bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bg4/GM9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bg4/GM9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA1C4CEEE;
	Mon,  5 May 2025 23:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486884;
	bh=uzRngQ09N+cYqFREnf8hrA6RbO131KtnUMMDuxB7Wfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bg4/GM9rSNV/t82Ngw2uhDY3hw2R7VnItQ1dz5atD4ogC2t+3R/Z1I2P2vBN+c155
	 FbeHtDg634IltX8OOhusVx/QzneGpl0PPdPbcCOmFIbQMpKbWGfozECrUQ2pbaT0Iy
	 WRYFo5FpIx/B8fVD4JrVlLWBik6IvtRgC/Pnof4aQXBgtnLyif3fIJaia84uLiq71U
	 MtZpL3YiWKjDWga3aQm+CUxIbooYbfLqN7ZKDxAftDLKHr9nI5IZoIEmr7L1YzWTTI
	 prUXTxxtP3I7z8mFuLVCMT4FRnNTtRJPXBuOhexren2y8ru+CMJPU5YTn9+BdDwcAA
	 qHnu0JgnkxZTw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 042/153] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  5 May 2025 19:11:29 -0400
Message-Id: <20250505231320.2695319-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505231320.2695319-1-sashal@kernel.org>
References: <20250505231320.2695319-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.181
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 45fc728515c14f53f6205789de5bfd72a95af3b8 ]

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 52083d397fc4b..f14177c7657c0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -660,6 +660,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	tgt->type = dm_get_target_type(type);
 	if (!tgt->type) {
-- 
2.39.5

