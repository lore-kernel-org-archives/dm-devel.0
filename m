Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DE914EC47;
	Wed, 16 Oct 2024 23:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729121310; cv=none; b=H81N3HfIu8H5xnDZAfyypz2FRLeAwXqT6TcMU/cMXaKRJnb0pAVoDP88aUq4HGPq0dbi8cuAdGmLE7zqDLxTvh7QMwJqf3upJyaF/Bk672isW61J0RF6VI+jcvry0OIxzPOYBjQH/Pkfvbk34rxPXN6hTVY6JiZJFtdMQ1lytPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729121310; c=relaxed/simple;
	bh=Cf2GH1PBloo5u/SL/FWRlv6cAAqFO5p0+n+kcE4KN6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mtXnkex0x4mZs6RuejM9oN0MYrhyhoCF1noXf5G7ElUZOcwH07C7sUKyHnVKc7RvNLPJ19Z3QUhZmFi49JqCQIdrTzjDn/yYLgOdrN/XF2w62GscGFaErHp1ia9oT8tWmPv4t1L7e6zsn/aTVF+bk8a01yWP+5NjhPzDP7RiUpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srDjm2OR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srDjm2OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1F6C4CEC5;
	Wed, 16 Oct 2024 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729121309;
	bh=Cf2GH1PBloo5u/SL/FWRlv6cAAqFO5p0+n+kcE4KN6Y=;
	h=From:To:Cc:Subject:Date:From;
	b=srDjm2OR+icJr6InORy6hB9Et8mZt7YKSYCYKk8rd9PM8f15H6wXjPfsW5BWBcxtA
	 rfzs9xlCI1KZ5e1+FWD7W69gMw7D1Of7Ezc816dZM7D8x2ulF9Urb4d8GJh6W2IeWt
	 YECUnauGjoBOjPIbd0dayFBbR/YjoogtnWmN1iOuwAsDZVjTx1GvSgjumKnwVNq+N9
	 G5/KlyH7nPYg2bGxbGbsPu71INdgmOtJ6GlTgPEjYOsa19V3oVopHoWzG0XO+p527o
	 LMHGSeE4mPM6Y6hCT9rNSRaj8HkAT0RgCXBVTYNRU7p0mceDkOa32deaQA3ktNejKk
	 n99Y5QGRhMXzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [RFC PATCH v2 0/2] dm-inlinecrypt: add target for inline block device encryption
Date: Wed, 16 Oct 2024 16:27:46 -0700
Message-ID: <20241016232748.134211-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is yet another proposal for dm-inlinecrypt, this one resulting from
the conversation at
https://lore.kernel.org/linux-block/20240916085741.1636554-2-quic_mdalam@quicinc.com/T/#u.
This brings in the work that was already done in Android's
dm-default-key but drops the passthrough support, as it doesn't seem
like that will go anywhere upstream anytime soon.  This makes the
proposal suitable as a replacement for dm-crypt only.

Compared to the other patch linked above, this patch addresses a large
number of issues, the main ones being mentioned at
https://lore.kernel.org/linux-block/20240921185519.GA2187@quark.localdomain/

Changed in v2:
- Split block exports into a separate patch.
- Return the key from STATUSTYPE_TABLE.  This is a misfeature, but it's
  needed to comply with the device-mapper UAPI.
- Don't pass uninitialized key to blk_crypto_evict_key().
- Use {} instead of {0}.
- Simplify inlinecrypt_prepare_ioctl().

Eric Biggers (2):
  block: export blk-crypto symbols required by dm-inlinecrypt
  dm-inlinecrypt: add target for inline block device encryption

 block/blk-crypto.c          |   3 +
 drivers/md/Kconfig          |  10 +
 drivers/md/Makefile         |   1 +
 drivers/md/dm-inlinecrypt.c | 417 ++++++++++++++++++++++++++++++++++++
 4 files changed, 431 insertions(+)
 create mode 100644 drivers/md/dm-inlinecrypt.c


base-commit: c964ced7726294d40913f2127c3f185a92cb4a41
-- 
2.47.0

