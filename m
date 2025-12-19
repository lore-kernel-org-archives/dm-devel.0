Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A034D2EC56D;
	Fri, 19 Dec 2025 19:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766172740; cv=none; b=LcIrszC09Xn9DoPw7+oiEfpzR3/4I23BTzEUcrWWzL7uxkCidZVa3x3juPvCIcN8T3LtVxHV9fYSpLU4LhIPUVQg2ot2rpptDWr5Q8smKp7mhYGg4wQ9NxpPZDcjcc6MdEvRKGMpjXTUYjo+IZdmlaC2fvBO81U5ipVwmtf339E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766172740; c=relaxed/simple;
	bh=zJ40im4Qzb2zGQ9EF4CcxcPago7I5cYx1L9t40i2lDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h3/RGVNhy+h6cG4aIseUq0sBlpLTVRZEkrzInpO+8YdM23LfU5/HKBfxi/Enerqt5yw8ObaEi2yBkR7SnyerUBP8HGwnbmmxsGy/J7KSSbZhO3BZcuqhy0YDmkQtdDPKvsEosgtyLGcJoi5MUau2kg746wQasxDI7wseWOxj/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCOXNX6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCOXNX6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7D3C4CEF1;
	Fri, 19 Dec 2025 19:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766172740;
	bh=zJ40im4Qzb2zGQ9EF4CcxcPago7I5cYx1L9t40i2lDA=;
	h=From:To:Cc:Subject:Date:From;
	b=UCOXNX6gh/VWf7s9acpoWNRICxqALvP24hEKXBXDXYHKPey9frJfCPmmZhQrPpZP3
	 j4qNuCvNmtjihofI+HOSVZ4yMcT86600vHIslQtwIi6xyYqHQiI/0ZnwoCwaCXMOVr
	 Qbex3VDqGp71K4D7hfxdERRlFyzRA9ME7IVhsljeauoMcA8Bl/3se6ulIjNvnPYdbY
	 h72BPsbKi99l0G2oDR2iTEbPJtwMrFqILPA7lbVlwHllXUf5stUa+PW3rYsjVeG6xo
	 d489LtCmaf/D7pWji0u20dlr1Oc0LYCQ5EpkWVgV7yITntx1kzzK5dNwiM5oiHB8VV
	 bv4Tj5XTeucFg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Eran Messeri <eranm@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/7] dm-verity: FEC optimizations and fixes
Date: Fri, 19 Dec 2025 11:29:02 -0800
Message-ID: <20251219192909.385494-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various optimizations and fixes for dm-verity's forward error
correction.  Targeting linux-dm/for-next and based on v6.19-rc1.

Changed in v2:
- Removed DM_VERITY_FEC_BUF_PREALLOC
- Made __verity_fec_finish_io() set ->fec_io to NULL.  (Might as well.)
- Added Sami's Reviewed-by

Eric Biggers (7):
  dm-verity: move dm_verity_fec_io to mempool
  dm-verity: make dm_verity_fec_io::bufs variable-length
  dm-verity: remove unnecessary condition for verity_fec_finish_io()
  dm-verity: remove unnecessary ifdef around verity_fec_decode()
  dm-verity: make verity_fec_is_enabled() an inline function
  dm-verity: correctly handle dm_bufio_client_create() failure
  dm-verity: allow REED_SOLOMON to be 'm' if DM_VERITY is 'm'

 drivers/md/Kconfig            |   4 +-
 drivers/md/dm-verity-fec.c    | 134 ++++++++++++++--------------------
 drivers/md/dm-verity-fec.h    |  35 ++++++---
 drivers/md/dm-verity-target.c |   5 +-
 drivers/md/dm-verity.h        |   4 +
 5 files changed, 86 insertions(+), 96 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0

