Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735DF23182D;
	Tue, 16 Dec 2025 23:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926419; cv=none; b=Z79+IP0c4P9kxOQgFI+DqOII8vBUorfaF8sq+q6PufZ2/5gx4NI0hjkf04Bku2frpX2qUK7Hadc8EZXFc0//YOQIy99Cwfyo91p4X2rjEAgrzpAMwLc6afKpYlagApjS9gxPd3/n0hYoml3uInP+FCkf1EuccIp9D6HLMsGWe9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926419; c=relaxed/simple;
	bh=WbRP8jOAHE1pnAdaZFuddMijcaU6gIVmzB6W39srFbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JztwwDcOVldgH58SSnKYDv1NviyJ1yOPRLeTOYQBVZ2C9IDCjdSLnvCuZLWHfvtpBtaRpiHtSNlgdQ9kztnT7PZXip5nbED8WJ6P5v7jiD9rbPXp3ItXSFZi3f7fLms2QgvnggxWCcSwp3A1WjS/YgxVxl7i5LdRSKkwfgyWaNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5TjyfHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5TjyfHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667AAC16AAE;
	Tue, 16 Dec 2025 23:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926418;
	bh=WbRP8jOAHE1pnAdaZFuddMijcaU6gIVmzB6W39srFbc=;
	h=From:To:Cc:Subject:Date:From;
	b=u5TjyfHpxfLJk8vlFVHIZ5//Jx0Hg80jjx5TG1juO8X/u5zPuJVjkWCcUJucFlQtp
	 TPz+EOe3mmLlFlYP7G2wXEVXnNJOe5LiXFaefTzNSMPn7nL+qmFUVOJCZi4ooWQcjw
	 vy/jIO5/y8KN1z3u22yD1x/fj1utf3rZOuBNhFJinvesgc6JcNyha0XdRkp/IwUzr+
	 TpkdNZW/apqwIy1DXd5Dt6RTezyV1NCHRKFB8QQHmvfXkKs/iY/QhUGDRXsDrT5Zm7
	 CrP6H8fvRG0oxxK0bye1f7azRmMpIh70svjP61bKVwnI9MaqWU19F5rEQBLL4xbN51
	 5wKUDrWBrjDOg==
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
Subject: [PATCH 0/7] dm-verity: FEC optimizations and fixes
Date: Tue, 16 Dec 2025 15:06:07 -0800
Message-ID: <20251216230614.51779-1-ebiggers@kernel.org>
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

Eric Biggers (7):
  dm-verity: move dm_verity_fec_io to mempool
  dm-verity: make dm_verity_fec_io::bufs variable-length
  dm-verity: remove unnecessary condition for verity_fec_finish_io()
  dm-verity: remove unnecessary ifdef around verity_fec_decode()
  dm-verity: make verity_fec_is_enabled() an inline function
  dm-verity: correctly handle dm_bufio_client_create() failure
  dm-verity: allow REED_SOLOMON to be 'm' if DM_VERITY is 'm'

 drivers/md/Kconfig            |   4 +-
 drivers/md/dm-verity-fec.c    | 130 ++++++++++++++--------------------
 drivers/md/dm-verity-fec.h    |  34 ++++++---
 drivers/md/dm-verity-target.c |   5 +-
 drivers/md/dm-verity.h        |   4 ++
 5 files changed, 85 insertions(+), 92 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0

