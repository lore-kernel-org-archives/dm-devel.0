Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24486340A57
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791735458; cv=none; b=UQmUTujuSeGFe0aQ3GjumUkiriTrLQn3Bqh/JqXgeU6mPicmpE+G46H/ZGQNUEXOc3rDIw3QcXnDGaQUBAlHh60QGPiKnI/nxCApKNArAVlgoa1LQOyZ7FTIS3HR9zssAaTUjnOCpZ1GZJHKfgmOKC60rWODZlraFB4Yu8ZcIJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791735458; c=relaxed/simple;
	bh=JviAVD7CAW7E+0vcjillo9AKIV4/oAfZhVWG33RBMgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dd69n5Q6Wamjm/hqtRM3U3+Lm7OM2ansK8URC/PNicsAx0Fdkcp51AH/jTXYOMUO6ViLWjtDc9PH8XTIjA3PGGKP3xjrYG2w8kqip1mRYQamD4eLAF651BvIYNRHScODQePVdWz0+nLNHp1M+2bRH1qAeklDsMwWqMtLYaBUXy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZyJ8jYcM; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZyJ8jYcM"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6afa651700eso1708540a12.2
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791735455; x=1792340255; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SrO8rMXn4hw9ZgBNUuWR+KCvckoUGl7U23CGJiIQkKs=;
        b=ZyJ8jYcMXCKK6H1QFI6sVBLaAzEXCuMLTxDsFoaKQJBNEQ3i39ymFx9Jwko6uII+Vp
         Qa7xiwwteGORMs0TwuSkouzkGPJZr8HZAPMw2T2LFEoy3nAMqAATGDY5IAdbC3WRRnyV
         WBGjKY7+B3QIA9RGKI8ASj3uVn6OVphwB0clvh6ZWx5Ux6hq/nySJocTJrPqKO6BR9yo
         lCLHo5wLG9JPjdD80Vnp0EkI4i2t9eHV2ad6yFyYgazdXp/Qd4ClODj1XM44zKharagE
         A+dM1GlAy6FbOr46y9DQqoloxnMcoQT62dVeFm9atipAm7zBWGzn/1+1L+4rAskh1Ey3
         61kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791735455; x=1792340255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SrO8rMXn4hw9ZgBNUuWR+KCvckoUGl7U23CGJiIQkKs=;
        b=qlS/6KTMT8sTkFJApI+pQH2AIC34NFO4xbNKbw4HOWE8qesZ+C056XWKBA5T82kot4
         vLJYmnd0VfnZnJFpk8qSFxRd2m9RO4p13cVhf67voVWG8lqw/VBMgM6H74Mm90Ju3bsW
         eZSnQQjDC2QlrQCrE33T8jIzY1lxUHWXk1UKqogM9Hzi5s0rLH5mEUW/OGYFx/mgqAVk
         0oY/m3UylZFowvLNFhtSqCTnCLDQr09KSyUoEGfrfXgQf8R4DSO91zENdVqcFNad7rU7
         fr3OjNKMLSAI/lTcggB24z/Hpvc/JI2tcbwijZ8Jo6VavDDNbXFDNjhB2Nas/CzOt00L
         3+Aw==
X-Gm-Message-State: AFq9FYL18YFi5+GYwlXviItvpTQnb2OxiMUoc3SEvyFuChKjbgoz/OuD
	01StmMSdE+RKypc5bdRvrZWasLCEjl+0nKjkydxh+apljLzPo1wXAHT5
X-Gm-Gg: AYBFou19LYyNTDrg6h4irT/ugJJny1CRDhsseg+SKqhHNCYkbUW7uNRrxE11LrvHidA
	DeT0MeHwjt7kq9IPvsOKXYClO5rKa/Q520hATKbvi3B1kV/w+EsInkYC/p9rOZZIxFNxQxHyqJz
	w5K62wfl0MAjbMkdaaq5OvWvMdVlTjB2V6N/ItFu7BxEY03rVYR0yukKVtPRqImhkbu1jVchqj2
	DlQAYzo0VMtHnLUQdCk/o1Ja8zERPEHUGjuClR55sBaZ8rs/VlZ0yuo82NQ+U21QylRYHeR2UQI
	A9t0MsRXozfE0znFqKXc5K3sWnC+Nxx1Byt46WHAUvWO8EKS7/rKYLmNLdWNAZS/TLZpm0Cs77t
	7i5xzglTGLxwS4aGIvyOmdnsH7apirg99doF6lGbIJfxuQpn+zxhA+b7yT1PIHd6PZm2si/IO9V
	fllG5W1GuzUT3ORZoiHxnNUdJerHiBC14UC5XvTMwoQRy7a02o+JPFiwATZJPSDoOcFzJjjCkL3
	OWwdTZzJsa2ncMv8ARgiUHHBK1uZL6hMs+l0Elo0lIbx8lVAQ==
X-Received: by 2002:a05:6402:46c2:b0:6b1:c2d3:6a6e with SMTP id 4fb4d7f45d1cf-6b1c2d36d23mr535539a12.8.1791735455046;
        Sun, 11 Oct 2026 09:17:35 -0700 (PDT)
Received: from localhost.localdomain (host-188-122-3-146.finemedia.com.pl. [188.122.3.146])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b179dd395dsm4065484a12.17.2026.10.11.09.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 09:17:34 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dlemoal@kernel.org
Cc: dm-devel@lists.linux.dev,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dm zoned: do not reclaim a random zone into another random zone
Date: Sun, 11 Oct 2026 18:17:33 +0200
Message-ID: <20261011161733.404-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <d4adf5de-9d72-4977-b4c0-3e1f163872a1@kernel.org>
References: <d4adf5de-9d72-4977-b4c0-3e1f163872a1@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Damien Le Moal wrote:
>> +	 * Without a free sequential zone, moving a cache zone into a random
>> +	 * zone of the zoned device still frees cache space. Moving a random
>> +	 * zone into another random zone gains nothing, and when the target
>> +	 * is idle it repeats forever. Only fall back for cache zones.
>
> "fall back" to what? This comment is not clear.

To a random destination zone: the switch from DMZ_ALLOC_SEQ to
DMZ_ALLOC_RND just below. v3 rewords it:

	/*
	 * If no free sequential zone is available, a cache zone can still be
	 * moved into a free random zone of the zoned device, which frees cache
	 * space. Do not do this for a random zone: moving it into another
	 * random zone frees nothing and, on an idle target, repeats forever.
	 */

>> +	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd) &&
>
> Long line. Please split after "DMZ_ALLOC_SEQ &&".
> Also, is the test for dmz_nr_cache_zones() needed? dmz_is_cache(dzone) will
> never be true if there are no cache zones.

You are right: DMZ_CACHE is only set on zones of the regular device, so
the test is redundant. Without it the condition fits on one line:

	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_is_cache(dzone)) {

With this change the reproducer from the cover letter still shows 0 MB/s
on the idle target. I will send v3 once the Signed-off-by question on
1/3 is settled; patches 1 and 3 stay unchanged.

illofspeed
