Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DF9309F08;
	Wed, 29 Jul 2026 05:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785302503; cv=none; b=BvMLaNfi/AJg1EKxfljmf5xKwLJjh0yypDhqnauFdnDrhBiAWJiIjRisDCPe4JmU6c45f3D3wwGYMnS6KNb+8o+Lu+ZC/62tZZ2DDEUTts+u44h3o9qPKq+NoMDF1xhN1R5V0tYt5E5J6zizfSgfJm1Fml7DoX5EnwSQZA/jhhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785302503; c=relaxed/simple;
	bh=gNij4ra+uirk9D9uO4mg7QfqJa/MKBxxFr0utsqpsq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SZTnTnPXZ+1CuP9h8TirVrswgCmgvy5Pd7AvWo2+ecU9KaqBrrq0J/UBbqYhlo91sDTmn6buxU6wma9HUDjKeLCnMo8uJ0IIM0GWW8Wby6jQucQmpTiXRfGg+BINjbD0BDSYEn9mmLZ3pMvAJCRwAUFKny8EzPu/2MOM1E8Ku6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmIUxIrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmIUxIrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E977C1F000E9;
	Wed, 29 Jul 2026 05:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785302502;
	bh=bePras/bjq5DnyoIW/REImBKWcxyJk7rleCYBbhs5g4=;
	h=From:To:Cc:Subject:Date;
	b=PmIUxIrKFOdmVsp1J8sfovVEELikuTiH1hSTvSghIwORE3Rl36Vf89Igku4rZRg9J
	 BqbyulNkkcXASTu3+tdEcSAH1LdndIohWUKYfuXz8mxIc/zaERoZ/8oSMx7ttN65U6
	 Yiw90d1Dxcdks3n0WyOYh/jQNiPxk1dn33u6grsnUnCpEB8+Id7H+V1FzuD3kzV7ie
	 MB9IW8SrOA2ObOB3I93DZF40VT6k89ph2J6Uod1UMRZmyVaoaqzf5sFjO6P1QLOYzA
	 pW5DI6FaHugY/I/7WEFGu+PUJqF8rdB9Pu7y6RFQ566sFyB8E5Err2h7JyHwTl4UB7
	 jVeXvZyt65t+g==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 0/4] dm-verity fixes
Date: Tue, 28 Jul 2026 22:19:05 -0700
Message-ID: <20260729051909.62106-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series backports some dm-verity fixes to 6.18 that failed to apply
earlier.

The lines added/removed are the same as the upstream commits.  The
conflicts were just in the context.

Eric Biggers (3):
  dm-verity-fec: fix the size of dm_verity_fec_io::erasures
  dm-verity-fec: fix reading parity bytes split across blocks (take 3)
  dm-verity-fec: replace {MAX,MIN}_RSN with {MIN,MAX}_ROOTS

Mikulas Patocka (1):
  dm-verity: fix buffer overflow in FEC calculation

 drivers/md/dm-verity-fec.c | 110 +++++++++++++++++--------------------
 drivers/md/dm-verity-fec.h |   6 +-
 2 files changed, 52 insertions(+), 64 deletions(-)


base-commit: 221fc2f4d0eda59d02af2e751a9282fa013a8e97
-- 
2.55.0

