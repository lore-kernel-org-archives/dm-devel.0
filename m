Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0345A2FC007
	for <dm-devel@lists.linux.dev>; Tue, 14 Oct 2025 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760453257; cv=none; b=PAEdSPtCIcr49C+ZBhhihcbmZ6FZC4BOHIMb2Fl85LSGcu6/Pvr1R7AMvj2bG5h/6/SuayY/VfXnmp3bzP/bahmyIk4sXviTxt/LydXFHLVTwXXGP5K4uWRuXyfyrzMsClJ30JdkkCG6GySpyxmrv1R49Cv33IM+qEgq3moIkQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760453257; c=relaxed/simple;
	bh=1WUetKlauk9q6CO44k+lrfotpDff1uajdkaAQjZEFho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mc08JrQSCbBtBABj1FHyo9fgcGVZURwCoUwqsJxqB+cNS56kxojTP7mO4A8Wj+7XW+9ur1Vg46HyuK8AKF+n4hChrHTmqOtugB3JABqFqASNIqcGMlemkDx8EysGCOeQSjP14UslueAl/9xsnjVpIePzp6C7pXb3FAaoHUk0l+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ldVhgppd; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ldVhgppd"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-37634d352dfso42051981fa.3
        for <dm-devel@lists.linux.dev>; Tue, 14 Oct 2025 07:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760453254; x=1761058054; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2+NzArl50yruflBXWfUivTM4ljt6tZKIzBIR3VQtiao=;
        b=ldVhgppdepFtveFg1ylbwutYIYyAAqHDhTrqbta1NtDCQCWcxZaA4RHOBqt9nW23Ha
         WrHLbiyravExOaFu9SCAmrb/Kdze6srORmhB3FloxXBk9CmXA4EQkHa/Z7mGyrNE9zrK
         sSWa+PEFNnjlFNWo/17a6edTpyYc0hjQ4GyJPkqGNHOOVyMAC8yPg+qv5+3FlfjBEMcV
         2VH3MWLiH8B0zWdUp57s1qBY60oLtaqJ8acuhXCGjAmNYW7G547bt/85UDaE6t0LeHnw
         4UBoZ2MN2995NisZ/D+EsiQvO8UsYdnAVZbQ0ZbOY9Fc6THcvmgxJJgBw9oP9+u3amfq
         RHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453254; x=1761058054;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2+NzArl50yruflBXWfUivTM4ljt6tZKIzBIR3VQtiao=;
        b=des2YrMCs/IHja5Pi5dhE1FDPCQIemlrqSVZESGqdsodgUtZPc3WYueIz5YcFrcT4j
         un4zzz5iYcOUyoD6cTAMKlA2BlOBAAZyHIkWYEERfFJSV8uoaRe0Lq3SL5WsP3mMZdtI
         Ye5wAo2Kl1FZp2OygkIbpY8y0UvvdoFaIpdSdiMdqG9yajErvjOpyDgM1Buw2o0Fgzt5
         IQFA3GeYnqor72BLcHdgzkFVpWn+5epKusELKi/RxsOgmp4nV3YJdtX2mowFK8ehLgTF
         uJDamwpItKKf1zM0Ei2GURbRJj9Ioq5p5zl7Ew8Li/5qLLElkeDujxRQmrry/gDwOhDm
         QcIA==
X-Forwarded-Encrypted: i=1; AJvYcCWp298tbHqUcWnyoSv+bYC4ZhWArF9Xx1t9lNXRnKusezQecmfoxO51qjvqGBIuwW3w8a+eWz0EtQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzFeZKtEHGe+HQlxvK7Y9eRavIZptPNJdAzXU8AbiCEdNaa4Sy9
	0WXZ7EvOp+uydDMisvS6mx7aGMe56qMmUON7ZOrAIK8/gGLVpS3kRkSZ
X-Gm-Gg: ASbGnct3kdHSgxdwu59V2j8h6JAEyyXFga9vnTeMiWqqa0GggydhBdt3Esmzxp2lNGc
	0Ubh/TaZaVT8qdtCglONkdYT5GUcB6oHa2nYU+5ndcWrresbPdDly0I5ore02izzW/Rad/QLdhh
	2TsifyG/ylFAyvDo3hzDpgCEGURNNYtVgFFCA6bZZPOVMWEGbX89erWW3YUd09KXyeapZlVEH6J
	UwWl63cqOXximqgeOoBcUuksN8s/vUBGMyj14cxvaBB4MEguL1iX9XmP0BRyxWf7eENOwkj6Cym
	ic5evSHSvHj+m9VLmLOjZRZlLA5ci0Tz7zs14KAH3vYFlhhEB9iy5jSP8ezXLesJJ0dhALov4qv
	WT7lf95jbs9cp4ouZbsDICxVWOk2mgBRiQHsg61E+hJAWEQ==
X-Google-Smtp-Source: AGHT+IFK4F5kk10SxvIDhTT4eCmKcDyB2K6FviG7CeDm523qbnVyJMoPw+sUVAfd7ZSWE53ZffFc/A==
X-Received: by 2002:a05:6512:b89:b0:581:9295:1b02 with SMTP id 2adb3069b0e04-5906dd532a0mr6183384e87.27.1760453253740;
        Tue, 14 Oct 2025 07:47:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5908820d8cfsm5311007e87.57.2025.10.14.07.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 07:47:33 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>,
	DMML <dm-devel@lists.linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial write
Date: Tue, 14 Oct 2025 16:47:31 +0200
Message-ID: <20251014144731.164120-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When performing a read-modify-write(RMW) operation, any modification
to a buffered block must cause the entire buffer to be marked dirty.

Marking only a subrange as dirty is incorrect because the underlying
device block size(ubs) defines the minimum read/write granularity. A
lower device can perform I/O only on regions which are fully aligned
and sized to ubs.

This change ensures that write-back operations always occur in full
ubs-sized chunks, matching the intended emulation semantics of the
EBS target.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 drivers/md/dm-ebs-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 6abb31ca9662..b354e74a670e 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -103,7 +103,7 @@ static int __ebs_rw_bvec(struct ebs_c *ec, enum req_op op, struct bio_vec *bv,
 			} else {
 				flush_dcache_page(bv->bv_page);
 				memcpy(ba, pa, cur_len);
-				dm_bufio_mark_partial_buffer_dirty(b, buf_off, buf_off + cur_len);
+				dm_bufio_mark_buffer_dirty(b);
 			}
 
 			dm_bufio_release(b);
-- 
2.47.3

