Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79814409295
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 10:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629493; cv=none; b=h6/ofkXWzzUDaCFb3Nyl3if7np1JZ/pc6kQNQXqVtOfHhQquLOw2oYHn5m5nbyNzFK5dvPVO9nXcfFC/8btR1YHWlnmqwM1GCHdnrnMGCblLM+vhajrTWf5H8WJ//k04Niqgm5mhJVf9RR7l3bib2R0cMleypCzXeHpEjrfaPuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629493; c=relaxed/simple;
	bh=u8KE7tOv1NAK+yYw3Pg7PLgziE5oKxWQEikBeXkrfbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi3GgRVkq0n+C9pbiuMGeVz5v2VkaJjYTs9kboSK3QWl8LIT1s1AJc5+jLUVLQJhawGH5oD6QKGZmuXyq0pMwjFfjOFNxxdGqYhv5jiwPlr8pGplVwzjrhbWTZpCuiW+PKzsgIhHTtjZpttXo11cNm6+padPfNUzJEPIlAfGjpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CLM5zew/; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLM5zew/"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c263415982eso74582766b.0
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 03:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791629486; x=1792234286; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ko6JSjHDJVAp75wXxPV5/JTHWYjHqaA5e9bKEbYokVk=;
        b=CLM5zew/62gFp5Qi+/+5bWO8wfu7IJ/PIDZCx6Ro2FVrLdp0k3vIrCh8MLUdylcwR7
         aYhWhKle8y86ChBUHn8QNw5c9pkLN+eOh6II4INwgZQB93bo/2vBN4Yr5HR/LTLLtwqQ
         GELk6t7lIdAGB9XiFTsDJvIfG1T7fKdPGfgIMeVbmqGRPAtaqbqxcyA/5z48h6GB/0zP
         3K91wNU7OZ29M51fVTPaPCGmbrFL8h84l2c97XhFGGxk+CJdnd7wn7/PtT+EvvvYFSam
         osMjusPO2qQMv0NUot0ZleP/1PrrGEeiEX5JggtRxiKa+RJEAuDTcwQ6UHrAvUYVwzvu
         Jhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791629486; x=1792234286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ko6JSjHDJVAp75wXxPV5/JTHWYjHqaA5e9bKEbYokVk=;
        b=d7KXLgtbDmWsOqeQEWtJf5t7X67+ofIvGVIEJGIgEsWvqBGT3or1ia6xr4PwH+IGKd
         2y/g8AlYI8ossHJ+UHOPz2oerFYI1BJZLvU/RQ4KnWsZIww/zrYL+JN4o49BlY0zA26+
         /BH8bDhmt03lBQ0qi2K8h4YM5YemDaL9kHh+0Je6JZXVul7vMthG3771IKrOGhjGNf2w
         Rn/pExDEnEvGbr6JIGRYqzOsKken0UIW/yqaG+DMiUa54qIm/yctqmSVE1pfpFhhynbM
         yMEw7+GpiVjrTMOEXJFT5eLZR6Gx5n9uX5IeBNNrgjTdWhFtpqvoSPEIVUZtPFJbKNT8
         NzKg==
X-Gm-Message-State: AFq9FYJZQxWmIzLwOXeH4OU09btQZ/zVJd+8tyHtqe7NbDLaNgcOeqVP
	sueRFUNjVvFKLA1B6nmw5usl/1GZ9OWkMAwxH9YnSBHn+rXdzU7PBuNooBndxEJzT9gdQ6Fvrrk
	=
X-Gm-Gg: AYBFou1whKc5ioXFtLVT+GQlyNDk0BYa3NPxjDR/ZOG8saicMFpZo4i3HSzE++gxnfW
	J7Ma9UA1ILfhriaInDdL+XvnLsFnDuSCY7n89v7tE/WV9OlsjptdK9oe7e3+3qa+VC42kjW2sHQ
	NOzS1Mm8Z7YWUlbIKdyuSozRGP0xaWhSpV16shlAN1yxnx2MKbv68WD0bh5/DGaljuz+H4OSbVt
	iixcM0fk8MstJJ/1glJgFxvC/b9qkakMwnVWHzdzlDBDf3c4HlNaCkGhjHF3TcCMQ255eY4MFuK
	ls3VMWssXQhjmtpaOiJ9t/WX9pCf9Pi1E5/fjeUbNB25sPNoMCLCUA98noaynMqsiUDdPxYTwBJ
	ExvRP4tnlPFURiQGEqsIoy2Zl9sJ/Nkp5c6tf4Q8b0dZINOvnsPgMcD4flvbYg92uVQfI1nXq78
	cY84F5AvSQtFCf9bydhExFz5FhdluidlGCxYoasViCUKF2rO0HxM+sFDUAmUhmC4Re4XH6YCCfq
	h7g0kKOS4wuL4Nypi2jeCSoaj8aKHLlU8nw2VcClFNpaqNK62QcEuTzHNeT+RV/0f0W/RQZ3HNl
	k46YsbZJgLwUGYw=
X-Received: by 2002:a17:907:3d4a:b0:c26:22ae:b66b with SMTP id a640c23a62f3a-c31a9fa1d4amr470333766b.15.1791629486397;
        Sat, 10 Oct 2026 03:51:26 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9766743sm229984566b.4.2026.10.10.03.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:51:26 -0700 (PDT)
From: illofspeed <volvo.mail@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] dm zoned: back off when reclaim finds no destination zone
Date: Sat, 10 Oct 2026 12:51:20 +0200
Message-ID: <20261010105122.398-2-volvo.mail@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010105122.398-1-volvo.mail@gmail.com>
References: <20261010105122.398-1-volvo.mail@gmail.com>
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

Tested on a 7.2.6 kernel as an out-of-tree dm-zoned module, together
with the next two patches, on emulated host-managed drives (tcmu-runner
ZBC handler) and on three 27 TB host-managed drives used as md RAID5
members.

Assisted-by: LLM
Signed-off-by: illofspeed <volvo.mail@gmail.com>
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

