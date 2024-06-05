Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCE717C79;
	Wed,  5 Jun 2024 02:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554288; cv=none; b=oHLdde1Uvqq1Nksy1oE0qiZbVmLrjXyYMtoq9XMjxwqJT3g0gbKkkYtMUcLVk1fnr2Sg6gvZC7mVgIK+b8kUb6Tg8kDO82NcMW8L27m4L2W48PfBfTtVi7BbsVntFwnjigGbvLX47GAgxB0mFwIatrhqTw2CJI/SFxO3eYdnSYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554288; c=relaxed/simple;
	bh=QAr1sy3azoURsM3x9ZOBOj5e90yuFQes+5sd1vPDfhU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tvcvUQyqMrsyWXLLJxO8Tag5dKy3W6//ntfinDD+zEBbPMvKzCtAY3KsuwY4A3oJ5PNLcu0x6g9aTyv6EDInvKs+NAAAHxzVn5sRYGcCUHhkv5bpfjGCs5+RQ38UIfBp9kuWWtKnZVZGFAcwy5UP8ql1+NBQzhdJCMebK7KiM4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ek0j5HrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek0j5HrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18150C2BBFC;
	Wed,  5 Jun 2024 02:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717554288;
	bh=QAr1sy3azoURsM3x9ZOBOj5e90yuFQes+5sd1vPDfhU=;
	h=From:To:Cc:Subject:Date:From;
	b=Ek0j5HrBJc9dHv5gpxhgP7Nlgp73WTA3azHQ4m7yjEBKrGh8/V6drRkiTQh73Zdbq
	 cRDnUnyPFG9odAU8LAdS8Tr/XzayLM8UVNIo8dG4IH9Bs2VeZKUjdmSuatGboKxeeP
	 fJL2OluTB5zBtcG8pWU/+6jeZyi7W9xfa8H+057m7bCh5sGBN4PzIOtMdN9Zh2cQVc
	 YwRQUeTMd6sPcTqOZ+pdKPGnfSZB91yixj+op6i7QWaeOFKUqpBycQZNIUveQOjeq2
	 yMGg/KqZyK2KXd52QZbVNlKmxKOVbOI8RYkRSCxsflP7yF94KnQHKerkPiZtgzk0k3
	 M+0F4L5+7Wz/A==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/2] Fix DM zone resource limits stacking
Date: Wed,  5 Jun 2024 11:24:43 +0900
Message-ID: <20240605022445.105747-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is V2 of the patch 4/4 of the series "Zone write plugging and DM
zone fixes". This patch fixes DM zone resource limits stacking (max open
zones and max active zones limits). Patch 1 is new and is added to help
catch problems and eventual regressions of the handling of these limits.

Changes from v1:
 - Added patch 1
 - Modified patch 2 to not cap the limits for a target with the number
   of sequential zones mapped but rather to use the device limits as is
   when more zones than the limits are mapped and 0 otherwise (no
   limits).

Damien Le Moal (2):
  block: Imporve checks on zone resource limits
  dm: Improve zone resource limits handling

 block/blk-settings.c |   4 +
 block/blk-zoned.c    |   5 +
 drivers/md/dm-zone.c | 220 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 192 insertions(+), 37 deletions(-)

-- 
2.45.1

