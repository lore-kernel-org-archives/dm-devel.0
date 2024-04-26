Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBA513BC2A
	for <dm-devel@lists.linux.dev>; Fri, 26 Apr 2024 07:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714116130; cv=none; b=On8zo8rqJSB/cxXxAcL7JAqXP2keMV1nHtI76b/a05XSg9T/wLJrh8RRCyxP4+mBsltOROWbZl+uWeY5kdtsEr5VJNfY2P8WrZN+Tx7AWAWStAwf1KhJOQeuRYmccWssfe9MFAtiSf/oBLFM8MRFvdf3ANz2NDSIBK+vqMUifI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714116130; c=relaxed/simple;
	bh=lsn1yUNVgDxN5sg7AcoIfp4er4SAEJs0yTl4O93MqKE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EeWAMRcylb/dWZ4xu/qseOAGmieNhQhRsK5irdYkpnq1LdT9CVVCIZ2lcFAX7PYKs0ibBDDr7IZM0Ce5odJXv5e+CaG7cTHXPTXKxjoGq2ck/1z1cttdQy+BSHb2ooIvM+MN5BiqU+EPtEQBBLg/LaXDKszZNOCOgMj3Tm38J6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com; spf=pass smtp.mailfrom=linbit.com; dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b=XPwSzApC; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b="XPwSzApC"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56c5d05128dso1823909a12.0
        for <dm-devel@lists.linux.dev>; Fri, 26 Apr 2024 00:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20230601.gappssmtp.com; s=20230601; t=1714116126; x=1714720926; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7364mU7VG+0lNBM2gl5YqMInVzKtwNGYSeZkIZb3MAE=;
        b=XPwSzApCWPVDGhgc0XT2lpK/MK+HVkvDfBMWP1hNqRThNkRfJUMF1NkWRCfVhTBMVF
         DhF6PkUpXUVykyuPnIk83ZpJCDddpngmgm0LeJ3WujGT5bE128S9O+2YkyRm4HTwTuPf
         UHFFyXyDQZ3N5rozJPMBagLSlm4xONeEXkPVnYY/4yBMfVgHmHtumB20PcfRasdhFr7w
         yozHrRNWoJuDdr/D3lBw4/OzFbJne85UTJJL5+AI8inc36CCV4U2qitL2vtz7pHQziGc
         29XMkTXfZOwbDAL5lHFJOCWpFJ//TX8XAxqHzvhY5c89KdSiBihDKecfb1YQywwVfHcz
         ZSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714116126; x=1714720926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7364mU7VG+0lNBM2gl5YqMInVzKtwNGYSeZkIZb3MAE=;
        b=hbqtUc7n5Sp1WjVG4q8/LIkteiqRShVtEL8+7FPXJMaRspFl4WlXWk/WBIzRILOW5a
         qNcPMmk5L46gu9WYruaL9LfOstWQwX72u+LlZrsM8+dukEagaM9HH//sRpvNndYa/Qgu
         6b3rdCIBO1TeuznkFqZOf091of3u7mbv04ReKytcC8LXjUn7y5+boqc55CKmcnCajr++
         z/uVRpJr5JGLfy9gTPSPhk+cC5rSVcEDriRtJ933PYh+yb+kPZYtsbG8tDjIIm3dEjLJ
         LXHKv2XaYtj5jJYKA7JJslQVU7QOTcH/MfLNGvS5VZWbXXJKbzFuRWZpShiZXmjriWcK
         SDnw==
X-Forwarded-Encrypted: i=1; AJvYcCVIsqNsqkeiGahrT6+htaS9ZMt6MROW0eax8mM1zJVG4arBw5OjI7tEId0fm6YNMBffJkdOk5CWNcPilNuArpmc+oTj1JYpZOc=
X-Gm-Message-State: AOJu0Yzxln26Ey0qDsDwO/RgakPi7RIHXyAe5ak+4wd5AtJrb+zjgmL7
	YksTWLosqjZp6vv9tG7ItyPiy9ixqwSsBPnT5fnLvZh5drluimzxDBzxX6sz8F2JyYtFKg/3yEL
	31fU=
X-Google-Smtp-Source: AGHT+IFZW3Hp5GrJ6nbznAhM83CXdyqul1d9MJFpgyv9fU217OdOv284RWsRcFXCwZ+txOuo2qmzcA==
X-Received: by 2002:a50:c055:0:b0:56f:e609:743 with SMTP id u21-20020a50c055000000b0056fe6090743mr1209185edd.35.1714116126435;
        Fri, 26 Apr 2024 00:22:06 -0700 (PDT)
Received: from jrc-a.. (213-47-229-24.cable.dynamic.surfer.at. [213.47.229.24])
        by smtp.gmail.com with ESMTPSA id o12-20020aa7dd4c000000b005704419f56csm9723818edw.86.2024.04.26.00.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 00:22:06 -0700 (PDT)
From: Joel Colledge <joel.colledge@linbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>,
	dm-devel@lists.linux.dev,
	Joel Colledge <joel.colledge@linbit.com>
Subject: [PATCH 1/1] dm-delay: fix hung task introduced by kthread mode
Date: Fri, 26 Apr 2024 09:21:35 +0200
Message-Id: <20240426072135.291206-2-joel.colledge@linbit.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240426072135.291206-1-joel.colledge@linbit.com>
References: <20240426072135.291206-1-joel.colledge@linbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the worker thread is not woken due to a bio, then it is not woken at
all. This causes the hung task check to trigger. For instance, when a
delay of 0 is configured, delay_bio() returns without waking the worker,
so this situation occurs.

Prevent the hung task check from triggering by waking up the newly
minted worker in delay_ctr().

Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
Signed-off-by: Joel Colledge <joel.colledge@linbit.com>
---
 drivers/md/dm-delay.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 5eabdb06c649..003512bb5fea 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -274,6 +274,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			dc->worker = NULL;
 			goto bad;
 		}
+		wake_up_process(dc->worker);
 	} else {
 		timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
 		INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
-- 
2.34.1

