Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D226213E8E
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528225; cv=none; b=brXncP97Jb7Nqg3i0WznFXpSTKVwcbaLvVPrXfCDMxvyQBKD9cs5tNzdo/VdjlxywDK/mrBVuUMMqEEv4kRNYnvcvANfqsXJR9ICnyfcCbb/Dhf4tM44lFY1xNaY8lWB54EI+PzhhU2lcSV/FLJeXfBKZo6g1yNbEhjMkU+iezk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528225; c=relaxed/simple;
	bh=v03/2E5UHyrKAtE/Wf+QAqPICQVH3pcMfg45GK6zrGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtlfuXqN4xqxBgmZv5IlmfNxXoOzG2sOuW/hMzH1y99OkHke19E0csgSr1MQgpE96xfasiVNQIbn7u9TkE8zSUAzF0ZFQHNtYZ+LOLsr4Iin+EdBPXl4RwSdS0HNjucA1tqa8tacgiyLjKPrC19VLvqlwuxR8x4HNjp3Xboaebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P8bGJWx/; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P8bGJWx/"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385df53e559so1870193f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528219; x=1734133019; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Arw8KiEgZEyIOEWH9GlV55ZY6YvkqG5QEueUyzNbHoA=;
        b=P8bGJWx/Q6LlDa0LVABZOQu+5vDQq+N2CNqM/Pz6zX6EBNBm19JMANNkjB7+A37IjM
         MA1jaDSkdw9vQum7T81NK9eF3MbCJZXcE1y1iFshSJcdjDZ6Btm1emWmBeWKgG88j1sf
         9gx+psBgVemU3VVxDb2SCrU98U0gS2eydbFwj1oKJIFzMC4FnIrua3LGGUqIgndCMWP3
         W9qpAbK1Ag1IoBAVgjGzXqobbQmksA9FZauLicX4YfOze6miLEkUgIL5MO1+FFGV9vk9
         /qUqmeFOQCZrYwp4wvi5FTdwZ4jZcojRF+TcBwVod5Ees2qVExl9KB7TqpbupquFKS1j
         javA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528219; x=1734133019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Arw8KiEgZEyIOEWH9GlV55ZY6YvkqG5QEueUyzNbHoA=;
        b=czC33L5aFpULPLyidgq2WlH9ngQIj4foq1ENgZPjMA5tgxHTHmIt+5uIT/iDfud3MA
         y/F7/FGsXIApVrIT0GZSVxu26OKznX5+nWw+S/HwqTlDVpUkn+A1NyLxABMivpaH09sV
         HlKLbV5jr80ReRYmgd6ssBA/UlllUZTNnzLChyiHfI+BlUW0u+QPtmicreuh6nZOEMFP
         Kw+VF6zEZTf7baQdk+1GnmqkG2iQHlfx71DB6CzwkJuMTg/gIElIgyEojGt+CU8rzQoB
         tBHDyC1ygCtxMyMixn8GTKE7/w6VnLy82FFjnMVOMsiCTEbum22w8SyNrrqMg0vOPRMM
         yLrg==
X-Gm-Message-State: AOJu0YzUFJ2mFRRHhWWQxUX+s6G9vklGcz9bGkSiKJ2EZJROjZ5qSg1O
	ibdUJqbYN5fHHlg3ZqrID4Xm75/ArprfXcb2+lbEwnKzrI6gXPg5NwRPsZkKpbU=
X-Gm-Gg: ASbGnctbnSZlXlAwEZrwkBMVx4C36r7ZLBapNAG8gq8gFMKG4QLPEWrknwH4VGnylSn
	Udx/wlksWyW306I+Vq5aVAFFQdIxbliNhgCJ0FV/lCf/gNPDnk3GwvxNmUVtSPhNPYfXB7soi6j
	uZlZWLyMwL3mtpme9XlW72SR921HsWlRDIxotwh0FnELz2SOhc+KJp5grGadNxJmuwUafrjfRqG
	m+2JTVQqt14TBFPuETIXh5vA7UGFedZ/GPzMPryU4pQo2yVqGKI1PJ9FDgN+HEjijkfPJwD02Ih
	giEs45jXnk6wj18chtSqOszjwapFdqvuGHjP
X-Google-Smtp-Source: AGHT+IH4eJ1YkK7JChR1Y7UZNcTK8xAe0vNju7Sy6x57FOw4dEyQ4qWk63+DugyXsAXXPkIHOFEyxQ==
X-Received: by 2002:a05:6000:2d12:b0:385:fa33:29ed with SMTP id ffacd0b85a97d-3862b3cdb30mr2799315f8f.47.1733528218647;
        Fri, 06 Dec 2024 15:36:58 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa6260abca2sm300927666b.155.2024.12.06.15.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:58 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/13] multipathd: only call reload_and_sync_map() when ghost delay expires
Date: Sat,  7 Dec 2024 00:36:17 +0100
Message-ID: <20241206233617.382200-14-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While we're waiting for active paths to appear when ghost delay is
enabled, we do add new paths to multipathd's internal mpp data structure
as they are discovered (unlike missing uevent case, where we orphan
the paths instead). When the ghost_delay timer expires, it should be
sufficient to call the more light-weight reload_and_sync_map() instead
of update_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e48fa79..8cca0ce 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2932,8 +2932,7 @@ static void checker_finished(struct vectors *vecs)
 	int i;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if ((missing_uev_wait_tick(mpp, &uev_timed_out) ||
-		     ghost_delay_tick(mpp)) &&
+		if (missing_uev_wait_tick(mpp, &uev_timed_out) &&
 		    update_map(mpp, vecs, 0)) {
 			/* multipath device deleted */
 			i--;
@@ -2941,7 +2940,8 @@ static void checker_finished(struct vectors *vecs)
 		}
 		if ((update_mpp_prio(mpp) ||
 		     (mpp->need_reload && mpp->synced_count > 0) ||
-		     deferred_failback_tick(mpp)) &&
+		     deferred_failback_tick(mpp) ||
+		     ghost_delay_tick(mpp)) &&
 		    reload_and_sync_map(mpp, vecs) == 2)
 			/* multipath device deleted */
 			i--;
-- 
2.47.0

