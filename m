Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795452047;
	b=Dg4qveCEPMr3ksUmuTD7yeiKAyjR6zzvD/izcRf5YobGtXCadPOhxqToiNgh3PlTICG9
	 Pv9gmUU4tWV8SEslcpzW7NNs2ZGwh6VeSmJ1Axwk7mpsDUQwDVDPCCB0rBFENH1nRjvKE
	 DK/hx0ehWNJpbBdaG9aWC83p+SBAe/UBM7zAlcq2bnbIJE8LcIm0vAI9wkq59fTy5MU9F
	 PcdOMxGmAwA5t/UnFdJdXsMq0XNd/lgwl7sZkElsHmQCStAaICpFdh6tSHrbaSk6XWVl/
	 PrMXg2/gbwZt2/zuIEfSN7+mi8Om+vnce/shP4SnmPlMZK6txGxO2eV9WajTPiwOfsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795452047;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=P5/ZiEeoOQolEtqZd6duqT2B+ydqubbd46Mv2EwUK7A=;
	b=j4mWyNYk5uc6QCRgUBVlyiIU04taqC7i07uEnmalsxpnxBMQKs8AgmrLEnXrbjZRiZvr
	 v+KE4ePDiPlE2aAu5xJBp+7oIMw6BsUif1lhuwawTS760RPdbIgEJrREpkDWGHzBh5ia2
	 n5hGvYm9i6OusQp/h2FtrOprmM/RDyonhMfCs2O4FDRgjEMVxPQJWsucccNJL9rXaE/vE
	 6R0cWSHTFqJHaDMMMwUgBwJgX0tw1LldULuwzt214ZBTDHRWTsCkrzQac1YbPRCnPGy/C
	 9WP9DyThb1DpePo5LXB91Bw6NYDoehNanlA51QQo5hLns2Zm7owZ5STFkSRPzUgkjdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q2kG7G5z;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75A4606A31F
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 16:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C75A4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q2kG7G5z
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1a2af4c8d00so5967958c88.0
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 08:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795452046; x=1796056846; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P5/ZiEeoOQolEtqZd6duqT2B+ydqubbd46Mv2EwUK7A=;
        b=Q2kG7G5zqkKWCthMvkq1yKcVfYacxv8Lf3F5eqzVkTraWCHLYoSbXG3ApKGD/xf746
         Z9U4lplVAOru8KqMHz0x0UNZ2T/navRV2ZaI2cLAJxmAlZyCZMg6EeBfsAvbqon+tMkX
         davVqAyUzm0phYWpQUc7u1w/wJMENA5WaB5ByQaYcCxq8e+PUUc+DGFMD/9KTwq8YVLw
         U6KzZibDBdR/W6ZwRG3K8OXWJwvRcq8StE3/PAjwEkIXQpAOa0gr+PgGLa3s80Dh0VNv
         Mgo8WijESdHGNxpYqrWYOGd6K1KIduj299T2GxHQ41ycqUWNdzafSkM6+7anEvV8TfJj
         5HwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795452046; x=1796056846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P5/ZiEeoOQolEtqZd6duqT2B+ydqubbd46Mv2EwUK7A=;
        b=KB6nFiq3Ao/5A5uJoVRaRsXn6XmzBvJNxLNTNYka1EHhZ2/JR+POmLJioe9nCv8ARy
         5UtMVGP2qDiygsst4g2oKOqzuwIpmj8YXI8f6qr3GqaKnJNBwmNt2TUJYT6+vQL9s3AH
         V75ohSdNN6BkwggCVnQIjQPHFeQ0crzjynPKsUtpjRssk281wPWE0ASLwdXFGQppVNL4
         O3Z9cRraGzaELtISXM1t0nbXSdIFaDZkFPk/PybTI62SwzM1nzdhThBy6yKtrvSM+6to
         y9Eagf7TvpdqOR7brvQtmI6qv3Ki595ujz2uBk+7Ap1oQ805EHWVtLRsyoIzv5fYS3SM
         SCJA==
X-Forwarded-Encrypted: i=1; AL+hErExUBnmHo3SEugGIgK5VffvTEkN6lnOJCC8r8JZ8uUguQtXYzWAvXyZnNPgEUgVviLysgn5icM3qQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/v+i/Rc4Qly/rNYB8sd9ttzvCQ5aPzP5Q9u+SqtzGsNEb8jSJ+
	FOcwf2KGEPzko3j8dUuXLpUh+M+JeAazpMoe+0NzTQWgRAlICao9FdDj
X-Gm-Gg: AZFdTZeQ2fZ4ZkaCalcURV2WQaQaw6FM+MLMEqHkqDGLMLRQ4jtSvyoiVPXg/UapaZM
	k2wIxfDyUgxVhnzovJ5EnZBOVUyfRelRBVmc+qHLdp1URT8Cn7kgScx7KzuPQUqzmsX3DxqKiLI
	6QUPVGcSYGxFSVKlrtvMNqSXG4BP3W2fNJLhlB/DNXyCVxrOkY70rC9bjbJfC80nEKcgc7DOIj6
	WfberD4aZXV4bOTX/Y7B5Fal5gsL8XILFz+3+VF016dSzSa2CfZaZQrrik4lvhaxa4ingGCehHu
	1g6Fn5vxlEk1Ti+jITOVC6DuXzuXZJ+W3CPfhLQkqzg+KG6Rju4Jt/DnppQAyFnwWU7uRP2x3uG
	TwFFQR/gyKyxCRxflDKZ3/LI/3dOEvuaymkkPb5Zl46vg0mmDlRoMKgEXReQTpS6DioQKS6Lwpw
	SojS9KuJWb9l/N+c0sg+EqwiBLUtUAZlRyvJF9eltPgiLoImOAToLb/fCCQxTEeCOsuj7MIK7HL
	scuNoXlqnd2/ICvX2C26UtkeKztbxBH+Z91JiaoQeL5c8d6Sl1DrQTwdkoVWVvzuelRvLPZkHEx
	L4E+zVryU21u4bJ6ac41Dn/tx9PcxO+o6xPNqvFwOff2w0zR4PgjAEp4zXsyl1Kj6tW/SINvTO0
	KTgd0PKwY
X-Received: by 2002:a05:701a:844e:20b0:1b5:6c13:c76c with SMTP id a92af1059eb24-1b56c13c7a8mr6689110c88.15.1795452045824;
        Mon, 23 Nov 2026 08:40:45 -0800 (PST)
Received: from lounas.tail428e48.ts.net ([157.131.129.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556847fdasm33225486c88.13.2026.11.23.08.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 08:40:45 -0800 (PST)
From: Louis Thiery <thiery.louis@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: ming.lei@redhat.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Louis Thiery <thiery.louis@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] dm: clear REQ_DM_POLL_LIST on embedded clone bio
Date: Mon, 23 Nov 2026 16:40:21 +0000
Message-ID: <20261123164021.463361-1-thiery.louis@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a polled bio is split across a target boundary (for example a
dm-striped chunk boundary), dm_split_and_process_bio() re-submits the
trimmed remainder of the original bio and then calls dm_queue_poll_io(),
which sets REQ_DM_POLL_LIST (aliased to REQ_DRV) on the original bio.

When the remainder subsequently enters dm_split_and_process_bio(),
alloc_io() clones it into the embedded io->tio.clone, inheriting
REQ_DM_POLL_LIST. alloc_tio() only clears REQ_DM_POLL_LIST in its else
branch for non-embedded clones, leaving REQ_DRV set on the embedded
clone that polled normal I/O uses.

The leaked REQ_DRV flag is misinterpreted by lower layers. On NVMe
(where REQ_NVME_MPATH is also defined as REQ_DRV), nvme_start_request()
calls nvme_mpath_start_request(). For a single-path namespace where
ns->head->disk is NULL (with CONFIG_NVME_MULTIPATH=y), dereferencing
disk->queue triggers a kernel NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000050
  RIP: 0010:nvme_mpath_start_request+0x28/0xc0
  Call Trace:
   nvme_prep_rq+0x5e0/0xa90
   nvme_queue_rq+0x40/0x1a0
   __blk_mq_issue_directly+0x45/0xb0
   blk_mq_try_issue_directly+0x85/0x100
   blk_mq_submit_bio+0x6c9/0x710
   submit_bio_noacct_nocheck+0x127/0x330
   blkdev_direct_IO+0x230/0x680

On stacked DM devices, a lower DM layer also sees REQ_DM_POLL_LIST
already set on the incoming clone and treats its bi_private as a dm_io
poll list head.

Move the REQ_DM_POLL_LIST clear out of the else branch in alloc_tio() so
it applies to both embedded and non-embedded clones.

Fixes: b99fdcdc3636 ("dm: support bio polling")
Cc: stable@vger.kernel.org
Signed-off-by: Louis Thiery <thiery.louis@gmail.com>
---
 drivers/md/dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1881d8611..79972f17f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -628,13 +628,13 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 		if (!clone)
 			return NULL;
 
-		/* REQ_DM_POLL_LIST shouldn't be inherited */
-		clone->bi_opf &= ~REQ_DM_POLL_LIST;
-
 		tio = clone_to_tio(clone);
 		tio->flags = 0; /* also clears DM_TIO_INSIDE_DM_IO */
 	}
 
+	/* REQ_DM_POLL_LIST shouldn't be inherited */
+	clone->bi_opf &= ~REQ_DM_POLL_LIST;
+
 	tio->magic = DM_TIO_MAGIC;
 	tio->io = ci->io;
 	tio->ti = ti;
-- 
2.43.0

