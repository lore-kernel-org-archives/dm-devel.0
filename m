Received: from mail-ed2-f10.google.com (mail-ed2-f10.google.com [74.125.228.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E33832FA30
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791735459; cv=none; b=QJo7U2bTvLOojn+WU5uvrtxZpB4Jon8Up9sC6DKyLJlohOgbMWEuVO+Eq3Ct1cSp9//O2V+3XddQhjuc5kXsjypsqU+UOmYTrEDJCfL3iXEbVRh9Insb6brnRUPiPucGtkMMSzo3N3BtbbqpEU+aSEqXt9VbxARNyDBgRe9lPTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791735459; c=relaxed/simple;
	bh=FZJWwERuJMGXxgfYc6WlmmI8oHDZeiRfC+lXTHDo5OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSxwo8aj4wWI2EKtYsXZ9JUaqumtamwBOIM8ow1H7CIdBS2+/OSVwon85mX/A92A8uvhzGFGOhP9q1wprFyfHow+gjDyd+Qfn3mX27j9Y+3BZoLBtZx6u+DusilnqHzXt37N7HNh9L1LyJ7Bhd6vw9mcPsgiDS5BkrCmzYgjDm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fs5eirmv; arc=none smtp.client-ip=74.125.228.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fs5eirmv"
Received: by mail-ed2-f10.google.com with SMTP id 4fb4d7f45d1cf-6a14f2e937cso813459a12.1
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 09:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791735456; x=1792340256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FZJWwERuJMGXxgfYc6WlmmI8oHDZeiRfC+lXTHDo5OU=;
        b=Fs5eirmvAG2VILvxFMk1b7+iLGagVYPwKktwxqz7VdMFf4lotHkGKa0sGQTC8qs44L
         vPZoYoiAm966tn9LsKMVaWgRkxsY86LqbnyiimMQHwoFJrlbVb1bf1+ZisCkj6yUdYJK
         0iN2v8OJIs4i6YnZGgx5PkHZ2Q4n7WqDVCZ686vgqCAWUjL3VwmUJ79RMlMjo0zAA1pc
         YqWHne8szgQZuO2Y0oqHbZR8Pz8X+VcWVwiJywSHeGf3AER4TJLdiivxgy/k7D3F22bM
         qCjoKZQ5eG7/YVms1lcfGlyAtpvdLp5f45VQU1EX9qD8xbhxLsdKn6VvVDTaDYlZJqZu
         mHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791735456; x=1792340256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FZJWwERuJMGXxgfYc6WlmmI8oHDZeiRfC+lXTHDo5OU=;
        b=kB5ObmmNAH5dUg9vR96ef76cUJGSKRDPCb2kSVcPWgpQM9l2G9sBWeS1EDKHvK06B9
         evh3bOp2nUObrAmj7rwKURKRnxOQwUkE6U45u1ZqBCcAdl5h4/mX27cmo+3HayAIzhAb
         TBc6lkifefRTuTx3qTBiWJweAkuSs+INNQOuOhFix9DwusJEA/3wEESpIvS6vb63HXwH
         HJT+8lDatJn2l1hV/fThzI6cuucTiyXOQOmFKSP8pFgVSwHGzYhpmkrMFKwbgpnDyPXV
         7iMpfMwqKhngbO6V4LSIp/2torMG2jkx1ZE7eVbcQqOoik0yMJZu8U4+bcaxNkWipxQJ
         A1cg==
X-Gm-Message-State: AFq9FYLUXLZoG7b2eF68+G1PiowWj4YSiAOJqsN+uYQmEdyhxbl1Hhdb
	QSVQV+POckl6B9mMX901tREonDNBxdpxMr0I6q4Q/xK1doDSeS+85TzH
X-Gm-Gg: AYBFou1sOEbYxUpIY297x7TDxOb/rRhhlDtnwLPOd+ijkzFrZuoVAtRuGNJq0dX1P+g
	DK9LKG65dHpuWxVXIoMzzu9wgGOa/pU08RuX5b7FFmEUPVZRp6ge4AM7PtfO79eVqwdPOIclcu8
	9NJZTLbcCEHIaKP0b801WTBB8/edMmEBd6FNJ+yzZbfDNlXU7/SPZOKzqwH9pLRCS/jgkkxJyip
	NY6r087VoaPqWrB2rE+I8YwRA2ICxakUVwNfm8O49+BBrdWWhxdUlH5+JOrWxOxQlafTDRGRvk8
	+z0xrs5uFR0Xtl8vycRmoIxALwSiWOZXR7cVZ3tUZ/ldKXx2DyAf4sg6zsGLcF3QCiB8Mie1vA8
	vqFLusZD+G5OnxnFsE3S33oaGtmnE29MFQhjnRdHB8sMLY29a25fIFHNcbhtnuXJsJlUz6cy3Wo
	eEK7qYRJcYUH34x4jEEt9+KsoeI/x/U4eEExwufMUDo5d1QtSSYqX4dP3pWLF3vGbwtn2wDTwRH
	oh39Dc/o3DqI/5T5BL1oGIjjiAaGoYrhp5llczRl1Qj/gi1dQ==
X-Received: by 2002:a17:907:c19:b0:c26:19de:9ae1 with SMTP id a640c23a62f3a-c31a9f92fafmr746232366b.32.1791735456445;
        Sun, 11 Oct 2026 09:17:36 -0700 (PDT)
Received: from localhost.localdomain (host-188-122-3-146.finemedia.com.pl. [188.122.3.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a74bcbsm372905566b.38.2026.10.11.09.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 09:17:36 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dlemoal@kernel.org
Cc: dm-devel@lists.linux.dev,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] dm zoned: keep polling for idle reclaim after a reclaim pass
Date: Sun, 11 Oct 2026 18:17:35 +0200
Message-ID: <20261011161735.414-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <bfbbb428-5a4e-4b61-8fe0-fd0c6c506c64@kernel.org>
References: <bfbbb428-5a4e-4b61-8fe0-fd0c6c506c64@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Damien Le Moal wrote:
> Patch looks OK to me, but same comment as patch 1 about your SoB name. Please
> confirm.

Same answer as for 1/3: illofspeed is the name I use for all my public
work. If a legal name is required, I will resend.

(Resent as plain text: my first reply had an HTML part and did not reach
the lists.)

illofspeed
