Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F632C3747;
	Mon,  5 May 2025 22:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483614; cv=none; b=cYNynmNSQ7C9hT4W9KT3ATnxMJm6BVzuCkRHaAQw6I2PVpGMKCnZ3PC8kwSG/NMYaGxKPgJ63L+CcSG62PkSD2XYEuXd/ngJ5ZrAq2bc07ZEGihmx5CLCmSvslh5mJFcgckShi9qrWN39oMrsU3pO2QVjQWDrA7Umk/Cd8sZzdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483614; c=relaxed/simple;
	bh=6VySRvUn0/SE5ZxArdHZ7nv3IRQQBbPv6uTQLCyONLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GsHWfo3/tfjXO2dOreltW7d17nCqGD7hdFlr+DVV+EfnKAVuYBGQdaPrAedNL+r8F5xnaeYGrf3qH7zL01q+U8lEv1DaYzz3xnX4V/SiumT/S5QgAPSg1nk9G+qzOKZFYNqegVheJ4SPM6vsNuR0bViGOOvkz00wuPfdCkWqrs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjbsEg3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjbsEg3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5F7C4CEE4;
	Mon,  5 May 2025 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483614;
	bh=6VySRvUn0/SE5ZxArdHZ7nv3IRQQBbPv6uTQLCyONLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjbsEg3kbt5kjsGL8aOap5EmnxcgfF3nFUci9uhOqdKYOnIEQb6FLdm3TzElNe9yo
	 cOLWAvSWf7wRQNBFG+o8RxiLTacM6gRddHjFdrL3zN7/Gn9nZec8ffBvJaK7Xdm534
	 l70o5JmYbReX8nQ9xb4W7Sjrj/ok0Vz6M7AvFhYqhsUOdI0tdNaHIIy9FGHFu2sfKU
	 u0RgZLIup4ESRAVWYS9iJOL/TCkxARHGZoxWWkfg9z43hSJLpjPASJ01f2zgKhNk/X
	 hcM32A8KMvQ/PET0ZOGjGhECiDn2qMyU8kESTBYJlga4w+xHfC5CAiDya5e2dbwm+L
	 2lEAg/mjIKO4w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 144/642] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  5 May 2025 18:06:00 -0400
Message-Id: <20250505221419.2672473-144-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 0ef5203387b26..04b3e9758e531 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -697,6 +697,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
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

