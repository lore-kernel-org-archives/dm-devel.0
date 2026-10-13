Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2B9415F1C
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903329; cv=none; b=kQ+MDDApI3WBGy8S7qzgEwMdamX57uqnDV8TUSWDr3PpjjvROLZarJn3RWVVBqrdrZdN3RpHtql6qTC0IolNFEpxE8jteLVhF4p3mPMOPecsCVCLjNONJgx15KLZBc9XX4fN+6UEUDkCWLWXT7cljrthcgbs3mj8lNHsXeV4kw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903329; c=relaxed/simple;
	bh=sA+c0WYN2bPE37DjivosiMzZqIXScnG8RZ8vm73mDVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JY6jCFaBI/HUkGhU9L41e4VSGVYziNWVA2y6FyBzb3dFBjrYQjEqpEbMmwhYcJEEK9TkRJlyFV1B3o/YBvsK990c+d3xZCDnu6P1vSUABX9CTHWqgg4Bg7QSzMSk1+rygs50uywDIi/UAHh8tsi7XGgWvOQ5t5noJrJM7bYY1bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+B3cmtA; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+B3cmtA"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2a4e013a44so459499566b.2
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 07:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791903326; x=1792508126; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2TF+nw/u3d0JmPL6ecEUe1KLmlN203omllzFb/e1Krk=;
        b=Y+B3cmtAyaHWwl24ydh76l7mbBEsOb6ECjovnF8X/k06XfrH7UMQu1fweBrLMmobap
         0aUTa0cBOERKyekeZU3KvZjnGbmb/ZrHvyaZBjafaFJT8Kq6XJ/gx45p+U9X/3Q00rvq
         A8/I/l052cwZuPquhIprW5yErw8LRDZr6WeXdWQT+Cdsata1o8yOWp+1wkwUYAWqWbtD
         znWg4gJG7SxUNMrtTE7FOXMbUfMkTKgWxdj+VXTOpDZohou0xPRCY69+qoQjojMBh0JM
         6ySD0ql9HWFz12c1wxzdfKOTLI4d5M0ayoEBKfagmf+Ydj009jgc4vHB4GJ68IJjdwnc
         3Bag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791903326; x=1792508126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TF+nw/u3d0JmPL6ecEUe1KLmlN203omllzFb/e1Krk=;
        b=2k2ZOp06Yl+kw40zgM+ZukS0XFk6Hut90kkp+kC9A6viS6cccRRNjW7atsOA4Hf+fg
         PMULOnYB1dRx+viaUDuBJDXwG+VVvfhOaxiF/yNzeCSWRaR6DHWhwU4U/5FhMY+osaQL
         Ef8OOGxI6wd5nBoPYZ7jnkGr+nvpDLqFeSwkUeYf/uuethEBOYGt2sSVdYjAlUJwphcd
         0JJDBaPMu5AaAFO4z8/Ls1Ut0DoJ8V0kP2heZfGsg+7rUVIdb8eigWTFpfw+WimnHL8b
         u/khnEs8rBhS45yACZZjlxUAJhZqI6YxN7PFB9YKqx8+Z7E7OdPSrtnHPn50hqXIY6XK
         Zyog==
X-Gm-Message-State: AFq9FYLWBpalfTVoYKFttEJoI0RHQT3nd9s+/v9tP6WGRb17iGEkLmLH
	nYJvjJ7hhLnAORbuD+ZugcACH0LwQ88ER6mrsXSVYlAVu+hJ9u2r4PsSLrzg0H1+
X-Gm-Gg: AYBFou0WE8tqsE2PWxxvTLRaIsmGrwWtn+V1iMg6JNi3gOVG+vGmwJPXL2gh28WvNoL
	BeDbrkJokiL6SrQzddkPzAlcaamoMJ6vkGSwejvOLOpFWf+8fM50mLLMcLkLiWFE4VJ0thHEm8q
	BXCEi4rkxdD5c1V2D/6YmvvojZ8fIruzH51kdcLOuuny0YKpJcQWggwrX3B5PFU25Sf1Iokgfqb
	5KJOEb+Fyd/PuyAfNqfJL6Y67ZjjbRzdv/hdnBK04dmCUo2DqI6DDqHSe0FagGT0QBIc6X74uYT
	LqCzoGOFe/wX54uV7yNrZ8JEWlIuXPAeZuc4j9fpOhWRkji8wvpOfv54BY1i6FrLcb89htO6cz+
	eEaw/QQY/nXwBeOKxU3fvKa0mGPjJ0DaPc9d7WnPZTpb1K75RnWcMzDX3zjP48ohAG23pwLAx2F
	fVuzJDh71/zcmgUycbkrBfE4nczroAJt906oZMYLXVW5wfbbLFA6wMcWaY+MaagiUDpVfUYqv3G
	tW39/2y9mVzvl3PFUk4ZPvJ4MEm+YPCj9CZbvBv7vxJ1sg=
X-Received: by 2002:a17:907:cf93:b0:c29:4634:5c99 with SMTP id a640c23a62f3a-c31a9a06099mr1143506266b.4.1791903326142;
        Tue, 13 Oct 2026 07:55:26 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b179e03428sm6169161a12.37.2026.10.13.07.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:55:25 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/4] dm zoned: back off when reclaim finds no destination zone
Date: Tue, 13 Oct 2026 16:55:19 +0200
Message-ID: <20261013145522.17499-2-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013145522.17499-1-illofspeed@gmail.com>
References: <20261013145522.17499-1-illofspeed@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dmz_do_reclaim() fails with -ENOSPC because no free zone is
available to copy the data into, dmz_reclaim_work() still ends with
dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
keeps returning true, the work is queued again with no delay and the
worker spins on the same failing pass.

Re-arm the idle poll instead, so that reclaim is retried after
DMZ_IDLE_PERIOD. The next patch makes -ENOSPC the expected result when
an idle target has random zones but no free sequential zone.

Tested on 7.3-rc7 together with the next two patches, on emulated
host-managed drives (scsi_debug zbc=managed, and the tcmu-runner ZBC
handler under md RAID5). Earlier versions of the series ran on 7.2.6 on
three 27 TB host-managed drives used as md RAID5 members.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index c041413c729..315f0da99f3 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -540,6 +540,14 @@ static void dmz_reclaim_work(struct work_struct *work)
 	if (ret && ret != -EINTR) {
 		if (!dmz_check_dev(zmd))
 			return;
+		if (ret == -ENOSPC) {
+			/*
+			 * No zone to copy into: nothing can progress now.
+			 * Rescheduling immediately would spin; poll instead.
+			 */
+			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
+			return;
+		}
 	}
 
 	dmz_schedule_reclaim(zrc);
-- 
2.43.0

