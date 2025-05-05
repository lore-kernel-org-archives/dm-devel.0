Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0A42DF57D;
	Mon,  5 May 2025 22:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485930; cv=none; b=arNrTyYiNZt2N+Z5S9sy39T15N5GyjD95nzgw0KoXUsUshs0W/cPc17T1kImg25jFLra9n3bAqGAno1SHrecP64rm00sdbM75JppNxapEEP5EoJ623CwI4VZtGi5PDHVUNmwaAfXdVRq6vZpDG5RMvBUXO3DW2Q6cH0dRjnMDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485930; c=relaxed/simple;
	bh=xAQ9TRBt9kOvMcTBbHvhw54Knw6blmAnNV9ZJZIyMwc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j3G/iarVsl1SBBnQ87UgmWQABwDCAYa15YY4KYIoBGyWVhRx79JRC6oJgYQ1InDxgihtnjzptToDzT+hj+0qbTQZDXpfPNVrZE85ygy7OhcUxcJO077SkeU9Kc0wRe4WU6eThUtfLBZD2IyhG+RISBH9TcaNHiS4be/KtzIAC74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quE8o4bK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quE8o4bK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACFCC4CEE4;
	Mon,  5 May 2025 22:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485929;
	bh=xAQ9TRBt9kOvMcTBbHvhw54Knw6blmAnNV9ZJZIyMwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quE8o4bKKQMDYzx67BgZpO/pMAS2IbhC03OeKbXu7cme1IJJrjmg93dyveTbhyhlf
	 +06ocTJY4/d6eAE2092KC8bOFJwicHRbILmE3aBW3x6rWZnSHn25s3pUeBEtX+BNp2
	 9kRsYfDxBHDpXDDvkiB4KcEEIPMffCD+/M+adyYHJr+RFCDXQkniqSzq96iofjiJCv
	 APTDkDM7RiQgdTznimzWGW9KWmrOL3aAp2VLLvPqSVU4LjZji0UTnQ0pqsNsGV+qWO
	 FHclPLzEneQlZF1xLQdLGtKbXB1Rf/RH3Sm5ofquAi7ld+XGHC7fKt1jdTc8JsY59w
	 DU+khjFcrFv3g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.6 071/294] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  5 May 2025 18:52:51 -0400
Message-Id: <20250505225634.2688578-71-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index fd84e06670e8d..50de96e4e6c33 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -668,6 +668,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {
-- 
2.39.5

