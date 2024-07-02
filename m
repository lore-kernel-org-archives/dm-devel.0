Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E41D6EB7C;
	Tue,  2 Jul 2024 06:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902983; cv=none; b=FN7xMav2mo2Fap0BDvtcaJosil48MQ2LF29P7OPUPy5pFD6fhfF1FzXJ5LDs7Lj4j7gZgfKMhW5jWylw7mdhVQ4kG5rbOs9LV5+c6AiyXNZh08WE1VcK4hYDKsB00EuEhY6T73hg27lr01EgcFw2QAk3ZALkKC5K9ImjHeQBDzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902983; c=relaxed/simple;
	bh=vHYOJnY3JHWtW1rilur1a+Vhm0DEqsEGZWmUxdUYc3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mPpNDLTttC1ibETaF2pKQTSQy8zm1LvprydC/vfiDsevy8i0f/NiFSA7JGcdbgIVYvzlPJCOm+cfmQBFwIHSq/O6mpqcXT3/n63EDzSeUR75YT4OnAJSZR9rkN/J5svkiElUchx31LM2GWmQgYOL1/Yl4kXT+0ZD016aDa1zzxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFPBRNOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFPBRNOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E98C32781;
	Tue,  2 Jul 2024 06:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719902982;
	bh=vHYOJnY3JHWtW1rilur1a+Vhm0DEqsEGZWmUxdUYc3o=;
	h=From:To:Cc:Subject:Date:From;
	b=nFPBRNOiwKt39OjjDWl/mXz+IWqybLH3hIlaIT3EOxWD7FgRuP19dZ8wuLmL+mflF
	 vmV/GHYjLiJafsLbUjGBW9N6HT4TiEVBbU0cVLhyFKG1iGHmyrSJXzbGdO2AYAtCUo
	 LvQ4G9iQJ/VKNhCJwr/09DmtY+FsWvg64AtHuCoct+6vBA17rSSuBtYh57uKxUI9xj
	 AlDO8XVIBIyR2WFr00ltgxpGo0pvk/QVIyJcmeOY8AyTNWu0oqTdxHR5JP8+vFQz3w
	 bbe/M+eIM1Ju3Dez0/ivh2Ax71ENlZIWgiWZUNjNgjPChSOsDyzW0GaA2PnBPClu9o
	 7ebgUU17FwuJA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/7] dm-verity cleanups and optimizations
Date: Mon,  1 Jul 2024 23:48:28 -0700
Message-ID: <20240702064835.120541-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains some cleanups and optimizations for dm-verity that
I've split out from my multibuffer hashing series
https://lore.kernel.org/linux-crypto/20240621165922.77672-1-ebiggers@kernel.org/.

This series does not depend on any crypto API changes, so it can be
applied right away.

Eric Biggers (7):
  dm-verity: move hash algorithm setup into its own function
  dm-verity: move data hash mismatch handling into its own function
  dm-verity: make real_digest and want_digest fixed-length
  dm-verity: provide dma_alignment limit in io_hints
  dm-verity: always "map" the data blocks
  dm-verity: make verity_hash() take dm_verity_io instead of
    ahash_request
  dm-verity: hash blocks with shash import+finup when possible

 drivers/md/dm-verity-fec.c    |  32 +--
 drivers/md/dm-verity-fec.h    |   6 +-
 drivers/md/dm-verity-target.c | 461 ++++++++++++++++------------------
 drivers/md/dm-verity.h        |  39 ++-
 4 files changed, 242 insertions(+), 296 deletions(-)


base-commit: 22a40d14b572deb80c0648557f4bd502d7e83826
-- 
2.45.2

