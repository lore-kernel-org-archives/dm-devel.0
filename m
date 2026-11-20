Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173518;
	b=U7x0rbrUZmfz2YYXNMxlyk3MVkuRyLhi8udI3fkKCmxx26AAZjE355UX1FVgCpaBsTO3
	 pHn6cY7cUugO/iLIReIPCifZJLNnX/y/NqqH/iHW6ViFG1V3y82BHbwpfboaSanPM+uHl
	 Uvb6Ey1KPbRcKBB+45ouTePeSRsiNIUR7SkudtFeS4yVoGzW5UiVOgBMA9JkqwUQ//cju
	 mqkoCs3chEWRaEVjWLMaYDGAzkAD/IMzkq4XiStZWyDBRrQy4hFqAB0gDT0fV514jlwO9
	 N/WFafy2+mPFU4Fq42AObRZlWtdhGf4H7rUinGpg+KXWEfWdS35sw+2FFrNymBtSk6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173518;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GVuAUaZMskqzeiLFr56cuMAxOEFeqJFepRj8B7tYuqg=;
	b=Xf6DHkqEW6mi1FFRVSY+GpmxxYiU3osFjjjnlJ1ypGV8FDrCsBhxF30mKQ1S5AVvitoD
	 Q9WHN7v+huT4LhrMeKb7i1H00QG5/6Uj07fkCbl2QIqqSUlrSJQwqAnT+sDjs2Yt6r/kz
	 Iz/byYKSH8QzskuTpCGqv/mgOMhtlCSaNfL6CXp0pxLFkmy9Xvdx91L73xmq3PsRMCkFv
	 beVEug4aZe8YirOaYO3PcZpCMbcWwdSaH/J/bBWtGT5RzWMDS6s/LSpA9ELMXt70dMeyE
	 +7hvB/P7/1mC1A58oZY/Oby0Eb5q6t6UCSzE6R9u4s7oypQF1O1J7skBh2nYMCOeSPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MBW+ItH0;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B36C606A326
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 11:18:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B36C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MBW+ItH0
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4d28f75d62so138748166b.0
        for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 03:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173517; x=1795778317; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GVuAUaZMskqzeiLFr56cuMAxOEFeqJFepRj8B7tYuqg=;
        b=MBW+ItH0BWm1rEQblbMuJlsDcOndueHMozWBjDhpHmWijq4JtMt6DFRaTqB3u4DOjG
         9jYDW1b+Qpu6z0hNe/7nDT0ChT9WgoM7Rka0d5KJOnYgG/c7sdDfU8tWeUdKTR7xdvDK
         MZAbEj1f2rRymFNLVaY/zYV7YxajhTxGKsoCjN7Qv/qxC8d8WCaQctKVabUz/9TPsRkF
         sXrX7rWoegnvE8f6ebjVqXS9RaFFFtjRbsGQBsDPPzidD8Vq/JrhejsaTcw9XwdLYqiA
         9b+BEknadOKnIlys/w5SVYGXsH8XoR5CoP+Yd+jwYV8Hv/ePqWjZQ86K0GZh+d4zokml
         kkzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173517; x=1795778317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GVuAUaZMskqzeiLFr56cuMAxOEFeqJFepRj8B7tYuqg=;
        b=nzlzm4MnT/+MILPFVHnl9XOT1/kzmGJ9RmKYuIqbtzg+aempuEqbCaGWl9H/hsuSG3
         A/dbPDyW+ZLDpOodjpRzSNtgn1UrCZgyy8RC0b+u2vF0jpk1gdZ+jdrxRbDaG/wbjlOL
         g0hDdZ5j9Q0o8MH7tzkSIMaAPzf51eSugPYhKOpzVjTJCyvIo1wE/GoMYwiUh5w/RvLH
         d7zNZbLd4f4fh+FDMBcpym3i6D/dkCCTlc3a5s5pH9zOR4Q+Vrrj6PAjwQpv+BmaN0LA
         cBYmfVdiAo36uMin5nucrp8xgHoRxP6Ili3jgbOqNL3UtYqlrTWiQXz3jf2qwj5+El/r
         ygWg==
X-Gm-Message-State: APuU4Z9oOiLKxCQReKIdNoqAYqS2Qmawi+MfzxS3OmqkM3CdN40s6xl2
	c43uJ5ynyonRSONEBZ3ZMyOAOR66N9/UnfxKiTNbAlv1ZaFRAbRsAkQp
X-Gm-Gg: AYBFou2+7yaay9je4t2vpcQJfm2lbPiMHxJdhsxxY6/cbe16Zx63qADZIyD3ps8VSu4
	kxnHGquG3W+lHdx44QBk/rrB3GDUawBOUQbKv0cFVoD3b8QYUdWiXWCuFjUH8sDlLUiRFsz85gA
	YGr4by6NHu6Z9ZfVinXnJ7I5XQy/wCYmgp2x34oCSVsiHJJSABGRD83ZsHBkxSAaMKqOGbcx464
	7w+42HIgJkN+eOhkdRIU8nnYcS+Jg1nE7LhjHCnu8Yun/8KSGlW0VO4aSVj+TSzWQyYEmkfrQhL
	lojvJJ3tVZ+DudSJO67vpunCxnnvW+4Z23tTA1oZyoeZolXQ20RtmUPOYSBk+aBOO2CCIr5kKof
	MH5EGKnaj7goHROigLlzludQqy+4YeXa2O3fRm/Ue33H1bh1ZkGhwTm+2eGdJppNtfSIMqwusdK
	w6U+y1COisF/92vEgb6oouYUV38UQYOT70rrnVMy86rHJ8vzJ8CHIfUm8NRm0xkeix52K68+Drs
	OfNkYDjpoIu0WdtqfFAY9ePeVXfH49M2BfNUJ5tPf6INR2soEr0zafF3JKHSuFoXW3IcsFjhKAX
	In4R2qXpp7W+MKWa9cEzxw8z0OZPHn8u5Vl/2tb0Qrd/pamZ3lTiPw==
X-Received: by 2002:a17:907:6095:b0:c51:24eb:4de9 with SMTP id a640c23a62f3a-c513ac634admr257163466b.34.1795173516536;
        Fri, 20 Nov 2026 03:18:36 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain ([87.116.183.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d60sm4985562f8f.3.2026.11.20.03.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:18:36 -0800 (PST)
From: nenkov2004@gmail.com
To: linux-raid@vger.kernel.org,
	yukuai@fygo.io,
	song@kernel.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	neil@brown.name,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH v2 1/2] dm raid: Clear MD_RECOVERY_WAIT on reshape setup failure
Date: Fri, 20 Nov 2026 12:17:56 +0100
Message-ID: <20261120111757.4705-2-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120111757.4705-1-nenkov2004@gmail.com>
References: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
 <20261120111757.4705-1-nenkov2004@gmail.com>
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

From: Hristos Nenkov <nenkov2004@gmail.com>

rs_start_reshape() sets MD_RECOVERY_WAIT to keep the sync thread
from running before the table reload. If setup, check_reshape() or
start_reshape() fails, raid_preresume() logs the error and continues
without a reshape. There is no reshape-related table reload to wait for.

Clear MD_RECOVERY_WAIT on those error paths. Keep the bit set when
reshape setup succeeds.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Link: https://lore.kernel.org/r/4d13edef-f454-437b-8910-3a905697303e@fygo.io
Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>
---
 drivers/md/dm-raid.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ac019a0f5..e132951f3 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4004,7 +4004,7 @@ static int rs_start_reshape(struct raid_set *rs)
 
 	r = rs_setup_reshape(rs);
 	if (r)
-		return r;
+		goto clear_recovery_wait;
 
 	/*
 	 * Check any reshape constraints enforced by the personalility
@@ -4014,7 +4014,7 @@ static int rs_start_reshape(struct raid_set *rs)
 	r = pers->check_reshape(mddev);
 	if (r) {
 		rs->ti->error = "pers->check_reshape() failed";
-		return r;
+		goto clear_recovery_wait;
 	}
 
 	/*
@@ -4025,7 +4025,7 @@ static int rs_start_reshape(struct raid_set *rs)
 		r = pers->start_reshape(mddev);
 		if (r) {
 			rs->ti->error = "pers->start_reshape() failed";
-			return r;
+			goto clear_recovery_wait;
 		}
 	}
 
@@ -4037,6 +4037,10 @@ static int rs_start_reshape(struct raid_set *rs)
 	rs_update_sbs(rs);
 
 	return 0;
+
+clear_recovery_wait:
+	clear_bit(MD_RECOVERY_WAIT, &mddev->recovery);
+	return r;
 }
 
 static int raid_preresume(struct dm_target *ti)
