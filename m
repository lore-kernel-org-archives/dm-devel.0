Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAFF191F8C
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 08:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737361087; cv=none; b=Jkt5AkLGlsQMsqqTiK4tRewa3EEfcPiDshMYz4o+8an7kQfbqaCFpckh4G0EKvygfxB4XveQhct6458Jy4VXgzQ4gggyIOY2f69uJxp8kFvZmH49FvbGWH7wV/xkX643Rgl0bJtioleYZ1l2hrPlPJa+INvyncOoBTQIFnPH850=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737361087; c=relaxed/simple;
	bh=mdzH1D7R2qW04qZ+UJr5pyC73O5m7PJFlr+ov9wLm98=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bzNbfdSKlZSzpeOhjJV7dd+s3C7DjBtMcG8gFLQOZsoEuCXXVLubKmK+/vtcf2lfzWh8W7YniX6EzeUol+NCFFAuYcHR+so0IM3gxf9VwDsczH1TDGvkD70aNIkV1TyLGnN8IVDfZ0RsL3nHl/yNRwCoc6eCFLXtCb/CX7QsQ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yc39V344Lz4f3jLR
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3F1061A1316
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgB321+kBo5n8sHjBQ--.22840S4;
	Mon, 20 Jan 2025 16:17:56 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	houtao1@huawei.com
Subject: [PATCH 0/6] dm-crypt: misc cleanups and fixes
Date: Mon, 20 Jan 2025 16:29:45 +0800
Message-Id: <20250120082951.1423804-1-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321+kBo5n8sHjBQ--.22840S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKr1fCrW5XFWkZF48KFWDXFb_yoWDGrX_Ca
	95KFy7Gw1UZFn7Ga4vvF45JryjqrZ2v34UCFyUX3yUWrn3Xws5AFsrGr4fZr1UZayDXFy5
	GF17Ars3Aw17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UpyxiUUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

From: Hou Tao <houtao1@huawei.com>

Hi,

The patchset contains misc cleanups and minor fixes for dm-crypt. These
problem were spotted during the code inspection. The patchset have been
tested by running fio on dm-crypt devices (both with and without
integrity feature). Patch #6 is tested by asynchronizing the
crypt/decrypt algorithm when using random IV.

Please see individual patches for more details. Comments are always
welcome.

Hou Tao (6):
  dm-crypt: set atomic as false when calling crypt_convert() in kworker
  dm-crypt: fully initialize clone->bi_iter in crypt_alloc_buffer()
  dm-crypt: use bi_sector in bio when initialize integrity seed
  dm-crypt: don't update io->sector after
    kcryptd_crypt_write_io_submit()
  dm-crypt: don't initialize cc_sector again
  dm-crypt: track tag_offset in convert_context

 drivers/md/dm-crypt.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

-- 
2.29.2

