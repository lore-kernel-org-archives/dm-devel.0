Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F06C20314;
	Mon, 26 Feb 2024 10:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943499; cv=none; b=XrblNH0GIyGi1GQHazDAtRpxmfiDmVPLIVcpf/hprArWrxWd67LAYZ3O9QlOP58tNnKoU1MqJtPmith82x2J1diCcoLcAwcxb1MEzFO6FlZF8tvt5n2P4iPOmz3JSPmyToSesaN3/vEYaezdxNZt1jXCTn8F4kn01AChPdDE8pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943499; c=relaxed/simple;
	bh=hzsCenhqVervqFR03nuiQmMOWXDgHrCuxk16LwcLHhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eHenljjbm86KHpodfOQTovOGqbh4OYA8XzQRyCD/0vzQbR5kJgIWCPH+8iBlCcKO9ftfi1zl9czJ8S1DxdqSK0Kw+lEMrXHJuf1FZbuT8un6NhbfdjIZlkS+fEWD3QMpyGJDSqyCKLjSAUps41KcpCxWNSC1sWXqWIVZaueps9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZjmeguIQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZjmeguIQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HGtAw79TfbpqxN7DjdZnzGM38FdIDqy2dwX3NjUJYVw=; b=ZjmeguIQRIjZ+4YnjLk0iobgUQ
	3WP05jroLv8FXxV/Kl6+a6HFrtBlw9G8EznltNiW7LPK2gFW8ElMpLf+P5IIh1QemeM5mfg4JZPNU
	dnSN3h1lMZeApOhp4DJ9KNzE8i6dau+BF8ZFVHtiZYvv9w/vYbFkszH3vecSiceE9He1lxOIDzwDX
	PJiyKsfwTux0oJsJsxAAz+rE4K+ua8A7CARMRK8RiDXXfBAwolXp3Jxr97I8k67axK0wJmA0ESybF
	PHRbaZS5bPrQ0FjooIm2WoeZpH0jL1hs2u38+4qRsU8L13tNHmiyN4vdESXYdVyHWcghYNtqrUpo0
	gFFWJelg==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYGl-000000005AR-48Zv;
	Mon, 26 Feb 2024 10:31:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: drbd-dev@lists.linbit.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 15/16] drbd: split out a drbd_discard_supported helper
Date: Mon, 26 Feb 2024 11:30:03 +0100
Message-Id: <20240226103004.281412-16-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226103004.281412-1-hch@lst.de>
References: <20240226103004.281412-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to check if discard is supported for a given connection /
backing device combination.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_nl.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a79b7fe5335de4..94ed2b3ea6361d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1231,24 +1231,33 @@ static unsigned int drbd_max_discard_sectors(struct drbd_connection *connection)
 	return AL_EXTENT_SIZE >> 9;
 }
 
-static void decide_on_discard_support(struct drbd_device *device,
+static bool drbd_discard_supported(struct drbd_connection *connection,
 		struct drbd_backing_dev *bdev)
 {
-	struct drbd_connection *connection =
-		first_peer_device(device)->connection;
-	struct request_queue *q = device->rq_queue;
-	unsigned int max_discard_sectors;
-
 	if (bdev && !bdev_max_discard_sectors(bdev->backing_bdev))
-		goto not_supported;
+		return false;
 
 	if (connection->cstate >= C_CONNECTED &&
 	    !(connection->agreed_features & DRBD_FF_TRIM)) {
 		drbd_info(connection,
 			"peer DRBD too old, does not support TRIM: disabling discards\n");
-		goto not_supported;
+		return false;
 	}
 
+	return true;
+}
+
+static void decide_on_discard_support(struct drbd_device *device,
+		struct drbd_backing_dev *bdev)
+{
+	struct drbd_connection *connection =
+		first_peer_device(device)->connection;
+	struct request_queue *q = device->rq_queue;
+	unsigned int max_discard_sectors;
+
+	if (!drbd_discard_supported(connection, bdev))
+		goto not_supported;
+
 	/*
 	 * We don't care for the granularity, really.
 	 *
-- 
2.39.2

