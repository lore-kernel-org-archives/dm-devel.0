Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020651ADFF7
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 14:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545161; cv=none; b=FnFSCpfz+9Tb+SyODml8hGMpE982rqN/jfIPJkfuVBvNYhcVIa7TtoEqzxTwUna0O0mGxz05v6rfoMV6tLG177BuBC3m1MrNqQdiBpp2nN+qqjsRZHbu07RdCu8kCBSiERiP8TdkH72s21sYylrEHQnOnxczQ02NKi/RnZK7/yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545161; c=relaxed/simple;
	bh=DAgqZwztbKCIJUmO0+4RGw0DiDD9dQrsMi4rYlDdqOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO9IFlMkNRO7gDn+m0CA0tlR/OmOfcFrsBUVyYPnJmJKgO1nk2pj88iOG3vBCzB8GsVJfDUKPe5CfDGItefSP3sWCGYMvs7gVlq6WManah39bN1b/FE4+gK/vHKosexbdHu+ucSOOJ2zEA1/5LDwy9w72oph3YQK4qMCduW2HGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KO7wLMh2; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KO7wLMh2"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5ceb03aadb1so6180657a12.0
        for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732545158; x=1733149958; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0qx70Y/+Ua8CN+cqC1lWtwHCs3avhbEeh3ep0x0uZA=;
        b=KO7wLMh2g+LidE04ymTMVkm6U7jhjP+Bi2N7KvZdUrYekcbUMSrx89RHx3PoPxulR9
         dS+RebGnSS3hAFpyTaJfXfEFqC5uifYvisMY4vwt5gRAHe+9ks8d33NjfP+0W0QlAOp+
         sAEaBqCjwiDogBT8afV6uw9LTRLBiT72phWBo0pjMB03W00F2GKsmZorbhwmX5NWzmBO
         fM2RmfKMwhLjhz4FuQC2rcwGYd9X4FKdBoWxFTaypcbJ1r/OAjOfAxwqNnbaLbdqVM73
         98ujDT5eszvElvCWICuUJyr550WEcWKm5hkiei+NjY/6fN6qvX0DKaLOVjwRz9YG9IHc
         fKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732545158; x=1733149958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M0qx70Y/+Ua8CN+cqC1lWtwHCs3avhbEeh3ep0x0uZA=;
        b=rt2ZhMnBxboBpG3sQEgiIs5LF7b/bvaTngDLBZ1tXdInB+2VFdWCpDR0XI2V15oEOG
         zmresER45RUfGyHGyBoppmTr0TnC/cGStQAs//sE9+T3oTVpkT/v9x2QMHR79YNZ913e
         Y9xVBZhhMqlAdv6/CM5ht9mGQwfF7fsOMU6cdoGXbs2ObMtxGMBXdvyVSuGE6/uisreZ
         VzKbeDIUqkuZQrK7aXu3BEjULRVi4cNwZCnjbsKz7RITzTTMzyWN4hqXbSowlruPSnrH
         v+S/p8Fhcjqce+Xm5roUbiqrKy07uk+pK7QFS8cL0DIE82BPwx3qSy8HQwF61bEvR7SH
         qXWg==
X-Gm-Message-State: AOJu0YxRQQiEy3Dfo5kDpYGOA6R/4l4yqTjCfC/s4D9gEb+GqY29O/bi
	OhbErkdw0fK1WO2rGwDGjLCaYpxxVEq944qMXNScrmjXVj3bW33IiNpRIhGmHk4=
X-Gm-Gg: ASbGncsBOlFB+iJmxNQs3P9il9xaKWl5aRh210Cj7ZYMB3RiHWANnpjZk7bqpCM78/M
	Cm55NHUMflqBThje73YWmDFk4PyJNHw8w8NH1FOCEpt/9bfY1XYW5Y+PDaRv251chJ6QNDkq9Tc
	ZqMqJLA8gQEbi3fVSfGm8hlHcpawVsNZ5sWM6cnSKzmSW+pw7PpGFhOnXfJWphfcUFUCGbCvr87
	vgzgI/gUrk+agThs1G6vzrgLyX79dMTR0VbCMKZ1TeumfbAbtm5118bTIBTYnowZn9GWQt0G50J
	bOVs+NBtDyx+5vOSKmxCfjJaYG0oYZI2abs2
X-Google-Smtp-Source: AGHT+IE3pyFjCcEh0j9B/7zq7F4fJTsaAy+nun62bQIf66gBWvIT+e93ra3npaDgfrYjdBnlQllVWg==
X-Received: by 2002:a05:6402:5113:b0:5cf:9cd1:1f77 with SMTP id 4fb4d7f45d1cf-5d0205f42f8mr11227551a12.8.1732545157835;
        Mon, 25 Nov 2024 06:32:37 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d028f28ccbsm3656120a12.1.2024.11.25.06.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:32:37 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] libmultipath: pgcmp(): compare number of paths
Date: Mon, 25 Nov 2024 15:32:23 +0100
Message-ID: <20241125143224.51934-3-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125143224.51934-1-mwilck@suse.com>
References: <20241125143224.51934-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pathcmp() makes sure that all paths in pgp have a match in cpgp, but not
vice-versa. Check the number of paths, too.

Fixes: 90773ba ("libmultipath: resolve hash collisions in pgcmp()")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d0e9c95..55140d0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -442,6 +442,7 @@ pgcmp (struct multipath * mpp, struct multipath * cmpp)
 
 		vector_foreach_slot (cmpp->pg, cpgp, j) {
 			if (pgp->id == cpgp->id &&
+			    VECTOR_SIZE(pgp->paths) == VECTOR_SIZE(cpgp->paths) &&
 			    !pathcmp(pgp, cpgp)) {
 				r = 0;
 				break;
-- 
2.47.0

