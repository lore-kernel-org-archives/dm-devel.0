Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523166;
	b=zUnVvfx6Dll9ZcfZDgDoYcRnWIVsMyD5ZUkd8OIMGY7BOAVwOjilFX2cTvFFIKYT/XAo
	 eF/FhCOzJt2SCgHXyW8ulSNRiNMvqYItT8YIONDB749TpA6NJj0Kndy8FwRhGOvHICGVU
	 WV8UbqqxbtKH5X0VC2alYRiUB5MRey8HpGHGImrde2853vw5GUSrd0g4i5M7hED8d4ktP
	 2DJtviAsQof7ioFB+rsKMRETeigw14oBETITbWP8aF3CANcIY4IonlmYM3sv1nEIg+iB7
	 wK3H5rqel0NvgZpPRJY7c7i9+n1fInWP1WXXjao8EzecCwMd5GZP5o+i3uYuY7U7i7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523166;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T9Uv2op32zHohJupS53Sf7SqghzNQXe+QDtOgKlIHmA=;
	b=PixnV0oy8irulygdJyPZOkuJQ9BP2E44FtZNaQkvnHJG8R2uAXviEoQZm/txr/NxyM6t
	 AoYQxZDqN7Pw7bHQNrjMs4xQwtJoY4rbU/G6RpTKTCFCV81yC+S+pkr3fG4Yl5FQ+7jNg
	 CaMQmBeKkkohnUpUJPGZmseW6WDOYrb8JP5UxFXQYTzp0oR4lx1x3OYbgoABLLHOfIQ/b
	 vd0YxtQONokqGIEUyxpUbNuUTfJZ3xJaGP7G1959AtsCBtRwGnNIhfZHTNEGD0NlVApNW
	 ZtNuPDRmPzL0hufgnqq0ES/+5J6ChrXLZLMjPUjvFPJW/mWvfx24m+qskmJwYRKzemA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=QCXL8mwh;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A132D606A31E
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 12:26:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A132D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=QCXL8mwh
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso43653265e9.1
        for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1795523164; x=1796127964; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T9Uv2op32zHohJupS53Sf7SqghzNQXe+QDtOgKlIHmA=;
        b=QCXL8mwhjYk3Ld0qTvMEL2EAui9iuCaxedrcodVooIOrC4E6TigZp/Kcoe63YPOsbL
         BefEd+BQ1B9siSY74YsvucpzZ0jVk8C0F9/qI9/l9K7HtQ3okyzFvuwkcdugcvHNfcyV
         vOccL5Eig5eVoUa6wagCxekzZMebbLe+Vjj2l2Dg8wJQM+eXM2gCepOmB4EZY4+Sp8J2
         0xzyiAxOCRNzWkyfBaH1CJS+8gBeQM8Id7AsMgct4xZ69swMVQzA3+Y7PP1ukJRNHXwd
         3pi9ph5+7HWt0mV4O+ZvRr8FrzpEvCy7wb+zCmqD/p75C1Yx0NPyvRZcSxB53lCO3eDm
         BFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795523164; x=1796127964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T9Uv2op32zHohJupS53Sf7SqghzNQXe+QDtOgKlIHmA=;
        b=HHIETysQA4MPTnBeWNq40QUwvsSxbKT6y5KrbIWE++q8CPfNGAypEf74dbbX43RqWb
         5d5AgRZo5BWSWV8nzzp2REXQn1uSpxD/y7IgbG58ptF0HudnUwY988B8oYZbK67ijT5F
         fnc/9yS8m6pvNvd4PT0srnNHlTLeH1Ffb78tPKGE5w+wHMRusw1pvjchN6KJhgLx0AlL
         boxsHZ2uylDMyS9IADTR8FQ5XnpcbsxfE+8lDwUjmnzGNgA9nhUmjB5JNWDhU5MnlTZO
         BzgjNXEVy0zKUXUz3btznP/d/7W/3v6d6+0rOpWt5Okp+EgxRSwz3s1pj1+9IZNc4SPJ
         DvbA==
X-Forwarded-Encrypted: i=1; AL+hErHpZIxAXmi90kaulp3q7sNm9JTrPJ5fgR1rcHgvSPo2pnnu7Yr54XpQV8+CbprByPai9cJz/UTPsQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8ecqREEOlZeKTGGEIQl/qmDACfPlqBl+08Xv2b5jC9+PWBUuPs
	NGPV7exRrAl9ciyv1JqtJcxhG9TIPzBUyqKxYt4/MhC0lI4iNsu1Hfnhh2Whq7z0v+I=
X-Gm-Gg: AZFdTZdabg57qAk4Oxy79jXAjLFtiI5lPqaGifnmtQl/wPR303Db8FyAbXFFwivaPz4
	HTtvalEvse/k3HKdkr6iig7k/xSvo2B37y6wn/3oqqJPTe2V70gOd/q/QbM9t6XaXGldBehJvDo
	YxRDnm458r8VPwpTZt8dGpk5LI2EJm/c0T44VDisDmx+lSwrQWRbhfz64SrFUT3f69S4x7XIA+A
	jtyyFeFh2doUNG0XwgY5rKXbmRG8z3y75CwC5WNYObCIIiFymhNsRXzYPyof4Kay12R8lbmpey9
	6Sv507d9Y5SsT+MvOPEQFId9i5R8RE9WM+b4WeQW1UDm8y5sqfVz1VT/dlq2fqY150h5+3tv3r2
	ZPf+J60oPxxYa8OWb4UQYI6vl3aqET7poyIT7uyCgn3qXKMNj/jcbyALvihhXqtR/EqpnA5nNYN
	uuaQAeBT0OAnKSQOKmUaLCwAZ86tZLBQzxstia533NDNqlfjDrD8/pzPiwmhzI/rtSXzcnPEKfZ
	1iZDLLPUHnigVveZd6NF28qX5K9HIR/PNx0ETrZ5t33mQBm0rR9g4elMFbO8uPOo900FtOhfDzp
	JojoB93pgBpTgzMVCYfLL2GCbNs=
X-Received: by 2002:a05:600c:46d0:b0:4bb:8711:fee8 with SMTP id 5b1f17b1804b1-4bb8881894amr289262115e9.20.1795523163953;
        Tue, 24 Nov 2026 04:26:03 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8dcd:31dc:bf64:9564])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853ca452sm423615975e9.15.2026.11.24.04.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 04:26:03 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	thornber@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	den@openvz.org
Subject: [PATCH v2 0/3] dm era: a metadata device that never comes back
Date: Tue, 24 Nov 2026 13:25:58 +0100
Message-ID: <20261124122601.436965-1-den@openvz.org>
X-Mailer: git-send-email 2.55.0
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

We move running containers between machines without restarting them,
and their block volumes travel with them, so dm-era tells us which
blocks changed between copy passes.

About one move in three ended with the volume dead rather than moved:
the metadata broke, every commit after it failed, the target reported
"era Error", and the writes it tracked began to fail, which takes the
workload's filesystem read-only. Rebuilding the device recovers the
tracking, not the filesystem.

Three unrelated causes, all of which the kernel log blames on the
space map, which is the victim. Two need no bad luck: multipathd asks
every target that appears for its status, so one is asked exactly
while it resumes, and again while it suspends. The third is older and
wider - a transient read failure in the persistent-data library leaves
the space map short, and the next commit makes that permanent. dm-thin
and dm-cache reach it too, where it costs a transaction rather than the
device, because they can abort and dm-era cannot.

Each patch is reproduced on a kernel whose only modification is the fix
under test. Patch 3 must not be backported before patch 2, nor before
cca2c6aebe86, where the resize goes through the worker the two would
refuse.

v1: https://lore.kernel.org/dm-devel/20261118110239.2910290-1-den@openvz.org/

Changes since v1:

 - patch 1 no longer moves the decrement past the copy. Holding the
   copy's write lock across dm_sm_dec_block() raises the number of
   blocks one task holds, because the decrement starts by shadowing a
   bitmap block of its own, and the targets size their dm-bufio reserve
   for the peak without that. The reference is put back on the paths
   that fail instead, which leaves the order, and the peak, as they
   were. Reported by the Sashiko AI review.
 - patch 1 no longer releases the block allocated for the copy. That
   block is leaked on the error paths, as it was before the patch, but
   releasing it is wrong while the space map is in bootstrap mode,
   where blocks are handed out without a count to decrement.

Denis V. Lunev (3):
  dm persistent data: put back the reference a failed shadow dropped
  dm era: refuse metadata rpcs once the target is suspended
  dm era: construct the target suspended

 drivers/md/dm-era-target.c                          | 10 +++++++++-
 drivers/md/persistent-data/dm-transaction-manager.c |  9 +++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
2.55.0

