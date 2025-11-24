Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5957A2F8BCA
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 23:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028112; cv=none; b=uNvIW6WskQzX2seYAC5N6aiAfvJ66P2hNjW+IGbfuEerY1xrx7DhI1nQlK+vNtsWg1WV1uM33fH02ZZf1BZuDX9NMyHoVc2USy0fPCk1tEAdTj+Vt1iQuCwI79Lr9ZYtC9FtD50Vj/d6ngmz05Wl0PKUD0IaxyOA94HKvifQcbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028112; c=relaxed/simple;
	bh=kQ2j8AcbSkYMUbwaE2qHb1RGU9aI9t4eoz6R/zOVZnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZyjCfl8ytb9bH94LXxvx0GJrgd8UOG7FV3N4DV4vQfp9c8r0ID/Gbwsg5liDBBuDVxXDKclRqeJbIRb0VGtrnrMX4GxGgD4bcbYdgrIltW9J4oAadmcHSPgSOTUEOGpAAqdSh1NQZ9MKNzR6df5JBqO67BXi/95S3YI8WshNNPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aLdmTTza; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLdmTTza"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a435a3fc57so5184276b3a.1
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 15:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028109; x=1764632909; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XG0OrcuNbwg29Sl2OBnaF07hgRH6+GSGFVprGloS+Vs=;
        b=aLdmTTzaxX4hkqAs8TT1s9EVQ2wBeJX+1KjCgHFWt92/R10/1eXISVVjl+6Q7yN5ID
         9a+RzK3oqMsiK8pA0m8bQqE8+HByTD73NjnxGeTeSfGIDXVD6YxhF+TGecivDUTMJMrz
         obPlFRuKvXtIGhKoD86pDyvGG0sk4Nyp0sceS14dOBx+UFUWpMSaGb7eaHiv50a9R6kE
         q6cMM8rt+yaY0yxSOSIN+GsyZ8AEI8m65QsII2aq4HBS8qzb1YX2hrgJILK1SmGujzxz
         Y5C/mvnE9g1FWX/4VTU4yM1V2463J+eRH3EIzubs2/p/fdCECybbdSZ1M6SCYdBtskrq
         pZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028109; x=1764632909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XG0OrcuNbwg29Sl2OBnaF07hgRH6+GSGFVprGloS+Vs=;
        b=XM50styyILv55NluBsXTOoe8dQrOurQRvlUJB+cW6BjOFJP19qLZYdRgflpIf+7G5d
         tH8zvrRaeYaW5+VrsdbGmMtgeaqkLCoKakx6814GQwU6pV8HrBhAYGVaO8mQpcfw3ODX
         wYnBBekCdgQqtcwz+yiksgt2z9nXdYwgk5OQHgRpbD9amq0Fv9YYbzH49UTcu8Pr5hX8
         h+HCff14viE/NmNUJn4CaphbvOcqGd1w2JsMIGIbs9HlH3Q8pg7FzkB5m2QpowMbAaAI
         gEaJoUjdM7WAhmD7sHaXvcwnwZAHsnlfE3tR0HWNid9swL5k5fyui+ACFGEcZFegWRQ1
         0T+g==
X-Forwarded-Encrypted: i=1; AJvYcCX+Xkx3kFu0tteIRF50GmUcJz81moAM2AG46EOPCsSa2w83JxJO5i3167hcFAPi2rTxWQBgOuT3cQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKgkK9EAMaqzj9ng69udnPrxCrtaiAh3HuY8pVUVVOml8T7xdS
	zH1jMNkvA2iWYuU2MtKUJjF1MSsSMeP2eqXbIIsOOn63um0390B/lfb+
X-Gm-Gg: ASbGncu1b3k4XG+x/kD7SxQJQtjjGPMNQcTXIv8veoP8w0t5eEFGiIjbpVQwQVjSbAk
	uxD+1WWS1pVy4McW4WDRpSBTH9PBN6EwR+ex1UTtIata7I7KQIC+JMWRWFM50za4RfaumcNS7zI
	/Lq0+b48qcGMdGqyLgylV9LmNulPixM6K7o1XizvG/h0HWPgudt43wspRcQlr5YwJ/WpWldiJeP
	oIAglo3JJWAZij5sHHp0JiBJyOdCT1qOB7PyDy/FUM9zmEpthyGpwosCjP3vsQhT94xsNIHmNfW
	l1RwiSr2otOhGAUslZAlwam3qG0a+greSBTGtaKfhtQ+LGhvrESlSN3S3GHHBt4v2AeHOOmb5l+
	9s4bUNifRPdhSdeuy1zb8dc3ZnppOQwENp9ZSfrRhlmSOXM1eA7FRjgmyvIlr9EPM7qDeC1yWmy
	LJLU93B1yiP7Xgjt4Kl5rYew4eZ7vjQe79gHHT2YWK5TzLM14=
X-Google-Smtp-Source: AGHT+IGsJc67nHzRSaGN7J/UxQrgH96kyTpeGXuRk0eYF4SOZV90nUCcoNrz1/tW/LtO3V9QCDnQOg==
X-Received: by 2002:a05:7022:e994:b0:11b:ade6:45bd with SMTP id a92af1059eb24-11c9d708d4amr8669000c88.8.1764028109428;
        Mon, 24 Nov 2025 15:48:29 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93db4a23sm76988653c88.2.2025.11.24.15.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:29 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V3 6/6] xfs: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:06 -0800
Message-Id: <20251124234806.75216-7-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making all error checking
in XFS discard functions dead code.

Change xfs_discard_extents() return type to void, remove error variable,
error checking, and error logging for the __blkdev_issue_discard() call
in same function.

Update xfs_trim_perag_extents() and xfs_trim_rtgroup_extents() to
ignore the xfs_discard_extents() return value and error checking
code.

Update xfs_discard_rtdev_extents() to ignore __blkdev_issue_discard()
return value and error checking code.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 fs/xfs/xfs_discard.c | 27 +++++----------------------
 fs/xfs/xfs_discard.h |  2 +-
 2 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6917de832191..b6ffe4807a11 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -108,7 +108,7 @@ xfs_discard_endio(
  * list. We plug and chain the bios so that we only need a single completion
  * call to clear all the busy extents once the discards are complete.
  */
-int
+void
 xfs_discard_extents(
 	struct xfs_mount	*mp,
 	struct xfs_busy_extents	*extents)
@@ -116,7 +116,6 @@ xfs_discard_extents(
 	struct xfs_extent_busy	*busyp;
 	struct bio		*bio = NULL;
 	struct blk_plug		plug;
-	int			error = 0;
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
@@ -126,18 +125,10 @@ xfs_discard_extents(
 
 		trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
 
-		error = __blkdev_issue_discard(btp->bt_bdev,
+		__blkdev_issue_discard(btp->bt_bdev,
 				xfs_gbno_to_daddr(xg, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_KERNEL, &bio);
-		if (error && error != -EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llx,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			break;
-		}
 	}
 
 	if (bio) {
@@ -148,8 +139,6 @@ xfs_discard_extents(
 		xfs_discard_endio_work(&extents->endio_work);
 	}
 	blk_finish_plug(&plug);
-
-	return error;
 }
 
 /*
@@ -385,9 +374,7 @@ xfs_trim_perag_extents(
 		 * list  after this function call, as it may have been freed by
 		 * the time control returns to us.
 		 */
-		error = xfs_discard_extents(pag_mount(pag), extents);
-		if (error)
-			break;
+		xfs_discard_extents(pag_mount(pag), extents);
 
 		if (xfs_trim_should_stop())
 			break;
@@ -496,12 +483,10 @@ xfs_discard_rtdev_extents(
 
 		trace_xfs_discard_rtextent(mp, busyp->bno, busyp->length);
 
-		error = __blkdev_issue_discard(bdev,
+		__blkdev_issue_discard(bdev,
 				xfs_rtb_to_daddr(mp, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_NOFS, &bio);
-		if (error)
-			break;
 	}
 	xfs_discard_free_rtdev_extents(tr);
 
@@ -741,9 +726,7 @@ xfs_trim_rtgroup_extents(
 		 * list  after this function call, as it may have been freed by
 		 * the time control returns to us.
 		 */
-		error = xfs_discard_extents(rtg_mount(rtg), tr.extents);
-		if (error)
-			break;
+		xfs_discard_extents(rtg_mount(rtg), tr.extents);
 
 		low = tr.restart_rtx;
 	} while (!xfs_trim_should_stop() && low <= high);
diff --git a/fs/xfs/xfs_discard.h b/fs/xfs/xfs_discard.h
index 2b1a85223a56..8c5cc4af6a07 100644
--- a/fs/xfs/xfs_discard.h
+++ b/fs/xfs/xfs_discard.h
@@ -6,7 +6,7 @@ struct fstrim_range;
 struct xfs_mount;
 struct xfs_busy_extents;
 
-int xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
+void xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
 int xfs_ioc_trim(struct xfs_mount *mp, struct fstrim_range __user *fstrim);
 
 #endif /* XFS_DISCARD_H */
-- 
2.40.0

