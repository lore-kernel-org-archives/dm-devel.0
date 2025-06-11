Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0820E22615
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 01:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749604606; cv=none; b=gG0pwu6sXdVz0yqVXc7pO2pgVtMzFV8Zlw7dNjLcdx7M8Tg6nJhcF+F3x9/5CDgFyUT3Mdqio7uig/9B3nURA60WFMHmOTXDSI8c1K8HJHSCKTULiRYjBLe8XXFUr6I9tl2RddQb4sCxrh7bOIPKWKiVmSpn3ANXvxRFiZ4QdzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749604606; c=relaxed/simple;
	bh=XxeGX0ABHr6t0blt4Ueufya/GWHM0ZwsH8afxP1y0CU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JaA5xJksaF3W5lZ9jYL55OQNUkJulSPiOHFu/8EB58HyBQK0ddScKBFYi9rVXW3Inevym9qVa06MevKwN/8UO1TnWU8DXN3JehDkI2/htK/NUWwVVN0850foeqS2vxQy1QpXWr68XHdxOYdB1FJljKpuXrPMO6+VuCnvZhqVeHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HpvHXvJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HpvHXvJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1409C4CEED;
	Wed, 11 Jun 2025 01:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749604604;
	bh=XxeGX0ABHr6t0blt4Ueufya/GWHM0ZwsH8afxP1y0CU=;
	h=From:To:Subject:Date:From;
	b=HpvHXvJBrevp2Td7xzHwjsDSOYmqXrCjQ+Y9FbzF9/p4WOiSb3U3bAIPKLsPWCXZp
	 tFHqTzEiPM0QiYloAyTbjEKXkPKrZzkBMk2qT3I4SRFXIjvcWyrTfinJ8Oyqv+txKD
	 1d06EDX/lt/0QtfX5rHEu0gRJWdKsUmp/nheDXszMCYrsb1aMAlVofNk6+RoTImng+
	 cGaDZBZ5+ystiLWF4cQ0bNsnOx4+qCudH4y6v82EpR3ISA4yBEMgF6nJygfQCTMgf1
	 g5TFKUmlASEba39Ju6WbSKf2ZFpArI0kBzRTMW/0Mj17IndqxEXl1KWs6C18mEAZUn
	 SUAAo0U6KAWAQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/2] Code cleanup and simplification
Date: Wed, 11 Jun 2025 10:14:55 +0900
Message-ID: <20250611011457.92309-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mike, Mikulas,

A couple of patches to cleanup/simplify code. No functional change.

Damien Le Moal (2):
  dm: Remove unnecessary return in dm_zone_endio()
  dm: Simplify dm_io_complete()

 drivers/md/dm-zone.c |  2 --
 drivers/md/dm.c      | 11 ++---------
 2 files changed, 2 insertions(+), 11 deletions(-)

-- 
2.49.0

