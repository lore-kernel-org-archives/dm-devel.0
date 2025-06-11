Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1B92D5432
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 01:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749604527; cv=none; b=BcVAYvnIksCzbMlNGJ7VQ6V88kiQZTwtE06fRq5jEnoh9RX+L/u1er1nrf5zwMap3pu2ZrZB4J8XCJjI2mPqrDQWaGYCxGpksFGW06iNTih373jgUCSPbM2tqKNRIBR13hDsCWNF/Lyt7U/xJSM8VvFIFM1oR3y6hV2FhHM9zA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749604527; c=relaxed/simple;
	bh=k6G9JCi3uA+7uH3gxoS8EoreO1AOiX+iDs804GY8RS4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qrP+aWomEHZyRmldhl6NTYF4cZzoMk/w4hXfc1c5gRL3m2ez51rfJbjiqyrlRdo/JhvLDdN7bAl2XQmodamr3MpQY/OTGc+5QJGMDlkRAmcXnTUlDvxD64EGT2kNnv9hYm36ogri2JByFUHniGtrLCnYlwCl0DKiXW4p3PAYt6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTuZpykQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTuZpykQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D73C4CEED;
	Wed, 11 Jun 2025 01:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749604526;
	bh=k6G9JCi3uA+7uH3gxoS8EoreO1AOiX+iDs804GY8RS4=;
	h=From:To:Subject:Date:From;
	b=GTuZpykQgnESfhY4iVyy4jy1wDH5v47S7kyATEiq4UkP3fNO5OPX+kXhq98Fby/k/
	 hC/M677Mq600RWs363qoF27dHGeOAPoRkuUEGGsQXvqVLUeBB4yMMWbqBL3VLabv9d
	 0XVEQ25TyJ18/MdMQeAUpQG9+DCWlD32mlI/Lps2ykQPKc+JrKbUVhkJx/o3uMRlpB
	 V5d45U8uAWa/9GRdAPqdvrm9cReCmCOWgA5E01D8fgXWmzfzpQFIwUDYIcRNEgcXAb
	 KMv+ythFeQiCht4aTYVT7a1osMlOCBGM0nvh/18r6y805QbD7+b/CrraQ579gZzDk2
	 HzkoXNclKM4kg==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/2] Fix dm-crypt handling of emulated zone append
Date: Wed, 11 Jun 2025 10:13:38 +0900
Message-ID: <20250611011340.92226-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mike, Mikulas,

dm-crypt splitting a regular write used for emulating a zone append
operation breaks the writeen sector return for zone append, causing all
sorts of issues (e.g. corruptions) with file systems using the zone
append operation (btrfs, xfs). The first patch addresses this issue.
The second patch adds a check to detect if a DM target attempts to split
such BIO.

Damien Le Moal (2):
  dm: dm-crypt: Prevent splitting of emulated zone append operations
  dm: Check for forbidden splitting of emulated zone append operations

 drivers/md/dm-crypt.c | 12 ++++++++++++
 drivers/md/dm.c       |  6 ++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.49.0

