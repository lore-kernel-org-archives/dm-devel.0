Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B7313BADF
	for <dm-devel@lists.linux.dev>; Wed,  3 Jul 2024 22:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720044819; cv=none; b=JlKqQuD1YP235tFK/6ab1hX9Wq7O5jFUiJTfD5WBESjzj/xcOn7j+kF8h0aelvRoTeoKuUXi4B4QAzBH5awd+jNKBtUjMT4i82zu61hKDwiF8fErOmiV9UZ83VzKn+Sbmg4TDLSAgw+OV+7WYNUI9lnVQlaHJ+2NIaUx6V7wAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720044819; c=relaxed/simple;
	bh=WPpeMXjWKV8X9j8T6d9CagW7yAl8IqN0xBj23zi0zrI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OvnNcNWABP3yUpNb0k/w5xWCwapRtfII5KR8vCFWzJAfF5WykGALnXx3WiF+IDSiAw1si+pEPCxvBcaDWVVIKb8x0z5FkY1QanlBblVxsSo1/Vsq2SK4yTMAfkzh5nCq3oJWbRmU9ZqeX3s2PBsH9ZOZD8al58VmCBPsKEWWZIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWP8B1Jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWP8B1Jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17610C2BD10;
	Wed,  3 Jul 2024 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720044818;
	bh=WPpeMXjWKV8X9j8T6d9CagW7yAl8IqN0xBj23zi0zrI=;
	h=From:To:Subject:Date:From;
	b=JWP8B1JtbEdle/RLSNoXgVQ4FHuXiZ9fGbHU74krdVtVGNh4YA4UVZwtylaDezRXZ
	 eBs0wI9prJipe3ovXq0U2/ah4A/vkC8d9s5F31pBkWykQSc503bIBM0GRUhghh45/+
	 7X4cTjyratS0OFRbORK8QR3pNF1sUFd1XSvwwebhATupELoAQHfBOwrLAIyJsn4KBO
	 MHlvZjglXTdJAcEjPx1sScQrYqewRuFF1qbbE9aSqmfPH2JI5uInYQRZaugqh4ph5E
	 t0m10q8CQl4eftK89KQ4Ve15K58k+A7istmPGIqGy4cttt1Cz8Vp3rriCjI2Sk50Gs
	 qMTzYKAxEg6XA==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/2] Remove unused dm_target fields
Date: Thu,  4 Jul 2024 07:13:34 +0900
Message-ID: <20240703221336.503507-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple of patches to remove unused fields in struct dm_target.

Damien Le Moal (2):
  dm: Remove max_write_zeroes_granularity
  dm: Remove max_secure_erase_granularity

 drivers/md/dm.c               |  4 ----
 include/linux/device-mapper.h | 12 ------------
 2 files changed, 16 deletions(-)

-- 
2.45.2

