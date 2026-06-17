Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9B724E4A1
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 06:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781676086; cv=none; b=CmAPlRQymLfg+ogTGLv21yh49aZL1xR1q8bvDoCFky0gRjz/xmE/V/5Rq//gou69ttZEBWEKojteD+r6dnA+HQeDF+BASTgPwIb1sgzIdg7hHThnemM7ufBBGWt15xcrV3cA8XYpw6PWCo+D3OIYAfpGGN5vmfaTpIHTTJ6fUZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781676086; c=relaxed/simple;
	bh=f6SxtyUXCY5JpVqF55AEeYUiybHy8EEYeYD7tnUL00Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E5V8J8vW4U1pFu5wcOZKkx2qzdhXCzE2K8+fJkfCmCb6wvHY9j17bvTS5aQv0l/BMBm1le2xSyhRUvahdn6Kd/wWuoWwNKiKrS9ZmNKIenBOgWEBbzIRks9H586SPDfp7935hfz2Qm7K9NdCRWY1AYfl+N3LomQSOnT49HbncfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dyEc0rM3; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dyEc0rM3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Nw
	61rscYDZNJ22tteAYOqgeN52PU99tAFx0plKFyBjM=; b=dyEc0rM3rOHTS21Fjj
	mxcacxmCh5LUINP3GpO0HYw0N7Py9G6hEn32nBjNC/zQGtMz9DekGRooS4zKpSVO
	dRzmqBup8pqPaC8SSlBsd9ZU2wKKgz+K6+einRaeMCNK5GPUxucz3dRmchtV4Ysf
	cqeR8b2Zvx4oRX60EMyPpfm0k=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDH8pUWODJqtz+rDw--.4521S2;
	Wed, 17 Jun 2026 14:00:55 +0800 (CST)
From: ghuicao@163.com
To: Mike Snitzer <snitzer@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH 0/2] dm era: fix metadata_open NULL deref and error propagation
Date: Wed, 17 Jun 2026 14:00:51 +0800
Message-Id: <20260617060053.71051-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH8pUWODJqtz+rDw--.4521S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF4kXry8GF1UKw4DuF4xtFb_yoWxuFbEgF
	WrJw1qq3y09a9xKF4avFWayr9YkrWxWrW7Aa9YqF43trZ3Zr93Ar95tr4Syrn3uF4qyr1U
	u3s0yryrAF12kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8M8BUUUUUU==
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC-Bc6zGoyOBe+IAAA30

From: Cao Guanghui <caoguanghui@kylinos.cn>

This series fixes two issues in dm-era:

1. metadata_open() returns NULL on kzalloc failure, but era_ctr() only
   checks IS_ERR(), causing a NULL pointer dereference.

2. era_ctr() replaces actual error codes from dm_get_device() and
   dm_set_target_max_io_len() with hardcoded -EINVAL, making diagnosis
   harder for users.

Both are straightforward fixes with no functional change for the
success path.

Cao Guanghui (2):
  dm era: fix NULL pointer dereference in metadata_open()
  dm era: fix error code propagation in era_ctr()

 drivers/md/dm-era-target.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
2.25.1

