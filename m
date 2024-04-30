Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952C0171E7D;
	Tue, 30 Apr 2024 12:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481507; cv=none; b=O5MeUfhhhUy/FQEy+OW9B0JkPP5z/ZfuWF4O8LyY0pFrBtkprjfn6nI+qFYTO7Twn0dck2doVoXS8uYCp4gdhrMaJISISJiEXm6LnsTdTVTApF4aYjq73cYn4yU0wljUMkwmjgd7toPm8K2oH245HpIvnAkDvVPsYU7vcBarKO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481507; c=relaxed/simple;
	bh=qT5FV1wDyuIbJOJEkkk63B+2mhbo22ZqrX0h70L2NUY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJh+R0euvrPo6VZNDmLu3PUqpNaZ5cs1p8TGMvDsKPDxsFtokmhkLeNa4/aM5nuBOSyA+KYc5UVE6+gNjQo+j7yrMBYyIN0XtZU/8UuGCkpt3L9tV5x2KPUSp7CXKDKD+mm+AwFRmAElU4PK61cDATXQDYgnTkvTQM0x/qWyeKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t21A7kFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t21A7kFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2CAC2BBFC;
	Tue, 30 Apr 2024 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481507;
	bh=qT5FV1wDyuIbJOJEkkk63B+2mhbo22ZqrX0h70L2NUY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t21A7kFiWgWUK+NSTr0SybzpNBO8rwbvKI+u/GvsHn5iZAT7E975OK3gv7zO09vx4
	 VWd9z+5nE7R3LFOd/AY+a88LYlRiVdbMnbp+Pyrhsvwdnn6ybqDc6ltMWGQKawsSC9
	 vElkfPNIE72TKWJasvhL37W/TW5AFy0OMhlAjbFN3m4LphNvW3DgNduHWKq78fbiSN
	 4qo5F1VWJyvAvhaXvFS7A8urpJejBe1Whdwv2kexRp8sIGYRJQdP4uScI+wlUCwLF2
	 HGObLQ6M+zfIQurWbxItFwx1GFUwgwj3uSAmutyjvqOYjO5bxFXw9A1wppiioiVMVt
	 qf71+V9VflKsw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 12/13] block: Simplify blk_zone_write_plug_bio_endio()
Date: Tue, 30 Apr 2024 21:51:30 +0900
Message-ID: <20240430125131.668482-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We already have the disk variable obtained from the bio when calling
disk_get_zone_wplug(). So use that variable instead of dereferencing the
bio bdev again for the disk argument of disk_get_zone_wplug().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 0047fe66f22d..c819e3cc7a20 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1203,8 +1203,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 	struct blk_zone_wplug *zwplug =
-		disk_get_zone_wplug(bio->bi_bdev->bd_disk,
-				    bio->bi_iter.bi_sector);
+		disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
 	unsigned long flags;
 
 	if (WARN_ON_ONCE(!zwplug))
-- 
2.44.0

