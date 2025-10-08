Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181B11FFC48
	for <dm-devel@lists.linux.dev>; Wed,  8 Oct 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759946094; cv=none; b=C9yKH1u4P2rdE8ppP3nCwVvSjejYVQMFcyS9GwvjAzOwSGwJd3YC+cih+udlgCIBJiq8IgqIZDYVxO2h1wqbLk25zohypXeFAXlDWHD0YYr4A79ctXKlUvmrIEU6tmgpK7peD10qyme8sksecXT9yBsTbUuPUm5UClBUKf5/cvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759946094; c=relaxed/simple;
	bh=1WUetKlauk9q6CO44k+lrfotpDff1uajdkaAQjZEFho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VmXraLfQN6/0D/2Z93xYfiM52q9KX03m/iRGqy82/PfEv6q+b8TKvnkDiP1foJKkO5NkrRQr0qUl6DfuFsBDwe5zkqWRaXNcuPpKj3iDx3pK1Ri7JNQJpHVMWj2z6MHwf85Lm/ykxL2HSaMEKRlLfTdmlZIXYGA2oT9kCRm8e7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMLbTOrN; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMLbTOrN"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-57bd482dfd2so127098e87.2
        for <dm-devel@lists.linux.dev>; Wed, 08 Oct 2025 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759946091; x=1760550891; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2+NzArl50yruflBXWfUivTM4ljt6tZKIzBIR3VQtiao=;
        b=kMLbTOrN9Hdlp1+sqQdZIAXPg+vURqBmCHLju87hgvOxDY2tGhXud10KFspJq/WzsE
         9/CBR5j0ZakfFb3gxH6OFM5JE3vOucEsuGRUAyO88QrCsOg4bEgoykiNBh6hvek5jZut
         sg095h8FBV2yNEdGF7JQYMmbE0gSxFlwzHhu7SIPCbCp/Tz7M8QukV0+tFyPcOyakNzH
         /VIG3Tn6BoN3bjpMKlEA28J6z3bcWwscLjYZXB+7c2tIweD+LYNicFUn4AsuuWZbK26R
         j909Q8mbxJRZRhpyiX3pzkgI4cLGwxxwSxJ6khOvGAbh8YAOXNkkmxmS9HJRaePgz1sm
         ZvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759946091; x=1760550891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2+NzArl50yruflBXWfUivTM4ljt6tZKIzBIR3VQtiao=;
        b=oo+Jp+XG1GV0lUBBy4LjMP0AmkgyKKT1Vrkoojl896HF0D6juNiIAklKE4iGazd+uW
         NjfuWbgavjFvoegtyTgb/sdNIqcIqO6tCISl+/FPP+rADMcN+KP/xNRyp6Oq+jN9ghsP
         /CB2e5StKyoA6M4Y22aC0CZiRtfmenHHGrxqSwWuoGoynQ5eY+4HI0Koaf2GIE8B0dR8
         HyD7SQpqex5sG+PSg7Lebp1UZ8E/E5NN//Ga/uo0UROMgSVoT2L0SXi4v43i5GLN/SFw
         +zpQMs6lHxNNf5mRGD1CLNERl/kuhjpzlrkIwDEj8ehvHMe4ZgRI/6HJBfIkYPR4w+3R
         QR+A==
X-Forwarded-Encrypted: i=1; AJvYcCXY9vnUkSIk9eqYoO9EsyHjlThLCMGzejSXo+mMwvk7UNh0doTtMzvDYkEwMkPnZuF+TOUjZRfgoA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxiG9Oow0iXhmpTINq+r/YjT7whIMQxwj2YKU10bM3kEv1WxA0p
	N/JqV2R3FGDXmarJEkjH76NM3VvAztG57hIZQjFAa5j3Ag2rvsiR5WqL
X-Gm-Gg: ASbGncvwi5fJhMsX6xa9gQTDgeVdWmbn6MEicGaGlO2gJPf6WKZ7JN/hYWpxrVFISWB
	6fHkwUh1WByzt04ep3FXtAad/hX3u2tJqhrKaANEuQfGgnMi4SZcivGAxeB9po4K6XjdllweMbo
	BnNJbUBpD2jUrlSeTZsKqltJwCMh7vbwSVe3V2vkPRr/gP6mkTgdiEkKunTKXfOiLtNnxGEG0cO
	DAP8gC63smJofAgE17B2WN++Jmsle6bHPTSgF/TAjIt4UH89iXbwB4tHBzilsxFxEvHHjS/VQLz
	3h1037rik3aVCEfC3vLeUeTgPeKGv6ChFxtWb76t4zCnjsOPayE7rLz7o21+BHy1sTaN6Fh9uNA
	L3r9NDjDs2i11juncvbhjQNLRcDDzozpBKu9jBZwDFoUTDE/47K0=
X-Google-Smtp-Source: AGHT+IHM0NlTwwUD2u4rFj4QdyCJdyEFBmUvYHEYRI/8BI361StlcHHVYHMrg98b5LX7XSOPdJfm6w==
X-Received: by 2002:a05:6512:15a5:b0:580:e43b:a3b9 with SMTP id 2adb3069b0e04-5906d88a399mr1136485e87.18.1759946090902;
        Wed, 08 Oct 2025 10:54:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5907ad9e010sm204634e87.64.2025.10.08.10.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 10:54:50 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>,
	DMML <dm-devel@lists.linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH] dm-ebs: Mark full buffer dirty even on partial write
Date: Wed,  8 Oct 2025 19:54:48 +0200
Message-ID: <20251008175448.342614-1-urezki@gmail.com>
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

