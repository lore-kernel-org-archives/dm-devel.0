Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E71241E7
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705578441; cv=none; b=W2sCKyB533Pu+bM5e+2nhSJQrbNAnXw01p5LqDyK4YffikiBJuJa76n17l+cyTMveW0tSacos3Jhsb3KqldOEkiPquUkqA49pV7UbfCZSZF4aBqgAcIKNG07BvdUFVwJ+kqVm7NsiSeDGkMaXi73utAIVI2WGYgi0SreFf04W3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705578441; c=relaxed/simple;
	bh=dQbpOdOENhOo0Z1h3+pm5zgm+nEe/woAmGEO2C6BZ4w=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding; b=MMNS9I7+SnAsf8bcFbRGwd1e8NLHzOoPhAwZ5frk5hL4pq0ZXqp7L5YayMNKkjzwwe3BdJ2LmD897SOPSwPrvy7vSngDCz7Px1MhbtGngwsPZ8rQj//MC0h1k4D0qj3Ln617q+ODr6SygL1uPsfj3HcZh3mmDNAYon04WHklbZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bekGWisN; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bekGWisN"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-337d6d7fbd5so98235f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 03:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705578437; x=1706183237; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nAz3mKCfKuePlbUvwO+G6A4gU2qWyszjsqBGE4AW3XE=;
        b=bekGWisNHavfe1Kt40VvBDlteaBmdvAauKuAjlGq5S3uONHtQdtpKBWu9qli5rCrMR
         5XL9CegIGFQM/uDNxZFh2ZjicKpFLNnJuF29aYjzIAdHr2Ohd8kk3Y3zv++7+HsAWVmn
         YALJbB5Ny1sGKUX+zAKRp5roQ33NxEyU1ntWAeWGgPD06d2/cpZtssZJY5m135k45l+k
         gaPZBazTLgUNMmp9MYRfuwLyJ2NDDuExrZ7UYmgLgsIu3i0ficJ8+N4P2lm/6wr2A7T+
         zJkP3RiQhGK+EIIf0DQUiW+oqXBGRJOAI4WmKC1c9aWUHpJGFH/SBTUq3EjVpexbLuo8
         iTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705578437; x=1706183237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nAz3mKCfKuePlbUvwO+G6A4gU2qWyszjsqBGE4AW3XE=;
        b=FODAGH3xgnG1sOjfZyCNbS6B1dyPklht71vApEqx1mLNRqN2deoiprVfKP88gHUjV3
         6njw9FEjlDxWZ9B3lTKb3B39k09kiBS9vkILuiWqeKBkB2oqx5mBhSiUbUjh3y9Yid6A
         Na8EjEasDQAA59CzxGKxLLkv/60Nu/9Em5DKQyESQCkcO4qe2OWD8uqnAyyPrZiSo3cT
         arMsjNuSiJ1gX7LFI7R2WOcGKJ60RnndMIp3JtENSAd44ARLBdiPtGkgZYfJ5VXkqTB/
         A6M4G8xR7rV7+YXrAl2jTVIhvnATph1OAxG0h/ofr2c1MGFG0oZaJI9+3Nf30hOywtsu
         FOJA==
X-Gm-Message-State: AOJu0YwMSTgPrhduiQzK1qntpU4ujeP4sJg+/yvxTjQvyPh11GZbhbq4
	nPEbV0V9J5sqVq/0gODi6H4reer+qyLSv/kdhc/G3KbSFxe5O/JhrrUX3Sh4yFM=
X-Google-Smtp-Source: AGHT+IG9iBqUJlCSEPmzskuLR2JNrPTFhgULW3jA+1OLJ2C9z39cl07Vq4QZUyGGcYMhNlWG550BPA==
X-Received: by 2002:adf:eb82:0:b0:337:b01a:13ff with SMTP id t2-20020adfeb82000000b00337b01a13ffmr492175wrn.58.1705578437680;
        Thu, 18 Jan 2024 03:47:17 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id f9-20020adfe909000000b00336ee9edbb3sm3860011wrm.94.2024.01.18.03.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 03:47:17 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Brian Bunker <brian@purestorage.com>,
	Seamus Connor <sconnor@purestorage.com>,
	Krisha Kant <krishna.kant@purestorage.com>
Subject: [PATCH 1/2] multipathd: the local path change is not considered
Date: Thu, 18 Jan 2024 12:47:13 +0100
Message-ID: <20240118114714.3391-2-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118114714.3391-1-mwilck@suse.com>
References: <20240118114714.3391-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Brian Bunker <brian@purestorage.com>

When update_prio is called, there is a check to see if the local path
has a priority change. Then all the remaining paths are simliarly
checked.

Only the result of paths not matching the local path are
considered in the calculation of 'changed'. In the case of failed paths
becoming again available this can lead to multipath not reloading.

The result will look like this:
3624a93703c9f34490f6140a100011010 dm-2 PURE,FlashArray
size=3.0T features='1 retain_attached_hw_handler' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| |- 1:0:0:1  sdb 8:16  active ready running
| |- 9:0:0:1  sdc 8:32  active ready running
| |- 11:0:0:1 sdd 8:48  active ready running
| `- 13:0:0:1 sdh 8:112 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  |- 8:0:0:1  sde 8:64  active ready running
  |- 10:0:0:1 sdf 8:80  active ready running
  |- 12:0:0:1 sdg 8:96  active ready running
  `- 14:0:0:1 sdi 8:128 active ready running

Where the path's priorities are updated, but the path group is not
activated.

Fixes: 6ccd7b8 ("multipathd: only refresh priorities in update_prio()")
Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Seamus Connor <sconnor@purestorage.com>
Signed-off-by: Krisha Kant <krishna.kant@purestorage.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fbc3f8d..2cddd85 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2115,7 +2115,9 @@ int update_prio(struct path *pp, int refresh_all)
 		pthread_cleanup_pop(1);
 	}
 
-	if (pp->priority == oldpriority && !refresh_all)
+	if (pp->priority != oldpriority)
+		changed = 1;
+	else if (!refresh_all)
 		return 0;
 
 	vector_foreach_slot (pp->mpp->pg, pgp, i) {
-- 
2.43.0

