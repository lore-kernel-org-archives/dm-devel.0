Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A292EB5D4
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 23:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766013528; cv=none; b=JlDe/SYZXHFflRTcmbOza0LMDilwXX8T9urndgrQmD63NM7ynOu+ErXWeGk3ZijDLInosVa1z66+KhNvu9IykV7q8TKWG7Nc2y4ox1ZFdT6al3Mf7lKkjTg71de+7agrxUCT5FPKX4lAjermKmYf1qZ4N10SgB6prjkqbitDwos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766013528; c=relaxed/simple;
	bh=C1X5R0T9A6CrUnxpIm/QVXVuRULmzTp597QRk97zyjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX2bq2e0Cn+5T4JfYY83/QUXoQU0tS86k8eY7YP5kd93XhDiLcqmAzEEYvvkn/oi5VbD0o1WxEj4zgqW3zxCzaNvklOdgH8hdlqbPOUHLNiPgnPpJQDvt62Y+UzznHFEmEfREZVPMvKBBco6pFZQh9aUpJ3cFDJXBTtG2sURikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m712Gq8a; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m712Gq8a"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-594270ec7f9so12137e87.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 15:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766013524; x=1766618324; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=m712Gq8aXTeHqrdEiYNYZFwuKqU3i5ANi2LJWDCUQ3M7qvbUpL0v5Aac8cybpVRT03
         CXXtchIa67nua+K1DRpB9VLCoMmwPelUA0Py9ZfDwRXB9AxjAxZW4aC3+V72V/Z68x1e
         NOu3tIfRsNMPJUIF8xtp0jWKkjAjbgNSrTzdf/HktUMzKxqD50Xdc2nMS+OBhgWPLdEL
         X/EHfhkAJxE67CEKjZZ7kMoDXF8hB9GHzoUn236ubWonYl3tXjDEFS8H2lQxufINlxz0
         Th6ni8Eq0T9GzySne83SID3LMO4n9ftrC/WSCkzCVyPN75z7FJQT6aXvisQuoPVDQKul
         UdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766013524; x=1766618324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=fgz3h90pbvbL08oiFQ57xV6nXi9whSpybTfp0woKHRniQpSG6aQK5Bv8P+jS4kDxEv
         yZvtZsV5N/Hkb7nlZP5COdXrH7OiaY7Bh9nW04BQa4aGuBMNLqSZ9qNeitn/ClVAw2Uh
         rjVS/SLhM+s47ZB+cI1glV+nQD849Jq6oopfqRxpMXGLO+d4vau2SIXY5BlVUJtaLw6J
         DrGE9LiR1JFS1WTbmaOsAQoOoH5/01oQzOEAECw0fbszZCr97EwDu+5nmVL04SqVRIP7
         H6cX+DDXOiQ/WiBe6MNcizb+792D9bKyFKUmqpu8Rm13g0739tQeDBg7YxKo9OjP8x12
         YBBw==
X-Forwarded-Encrypted: i=1; AJvYcCW/xLDU8VIrTvtZrJXoP1PjOkXOsBL0ftbmU4q4k3t9rW3RWmV/ly5fkBxEWw6YjsXiZJxN3DYANQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yymxq9WcIL9eaMoZcM4u9Rfe2LYcELznHQxlWcT2YbvYp4xpKni
	5JTkaL3QZV1LkBpxt0y3x8bEAMibEaVcRbQ9DYana/MjWaQZcXOCXdHl
X-Gm-Gg: AY/fxX6h3ffSNQz0s68jcZHZ454syxQBByCG546vj6Y752Jf8CATK+NihXPehdnQuKJ
	Af1/O1qxYIyDdP+vC4TbmVpC9QDR3JG/vY14CwfqtFnFkd+eaNkGj2cTQw1ErKzHXn7WvWZxuuW
	kwgaTm7PlPqWQOlLY1nmR1o5aNMLrh21nmNpzIvZIHmY6Mlif5YsDD0t/gCTde32G5XuQO1LN9p
	fEwp7cAOVzycYCEo+hGHGZ8PENhKDEG+gh5YB/2k3WiIbazgj1gaSBdYHUFyIopiv9fGu0PS6PA
	ZZ2k8OWz9rPnnP0rUB1M4tz/RJqbRZ0J9jMP+/TJ1jwihptLrRkOBOJ+1I/uQtASYRoE7EFbCxd
	hCTG8fbrrlXzl2tpRNT5s/EI/bfs+sRBxF/eI6v1Vhpk+L6ZrRV9neB23sWH4EU7BxvytZtjmlE
	bcH37CEBaW
X-Google-Smtp-Source: AGHT+IFoFgIAi9PMNEfIKCxeozWxswujwd1S6MJvMAmdk00BzJYAqN7Mqo6fE4Jz6OZ88KHyEwKy2w==
X-Received: by 2002:a05:6512:3ba2:b0:598:edd4:d68 with SMTP id 2adb3069b0e04-598faa5a3bamr5789014e87.28.1766013524025;
        Wed, 17 Dec 2025 15:18:44 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381134b5011sm2807821fa.3.2025.12.17.15.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 15:18:42 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	pavel@ucw.cz,
	rafael@kernel.org,
	gmazyland@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Thu, 18 Dec 2025 02:18:37 +0300
Message-ID: <20251217231837.157443-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> Askar Safin requires swap and hibernation on the dm-integrity device mapper
> target because he needs to protect his data.

Hi, Mikulas, Milan and others.

I'm running swap on dm-integrity for 40 days.

It runs mostly without problems.

But yesterday my screen freezed for 4 minutes. And then continued to work
normally.

So, may I ask again a question: is swap on dm-integrity supposed to work
at all? (I. e. swap partition on top of dm-integrity partition on top of
actual disk partition.) (I'm talking about swap here, not about hibernation.)

Mikulas Patocka said here https://lore.kernel.org/all/3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com/ :

> Encrypted swap file is not supposed to work. It uses the loop device that 
> routes the requests to a filesystem and the filesystem needs to allocate 
> memory to process requests.

> So, this is what happened to you - the machine runs out of memory, it 
> needs to swap out some pages, dm-crypt encrypts the pages and generates 
> write bios, the write bios are directed to the loop device, the loop 
> device directs them to the filesystem, the filesystem attempts to allocate 
> more memory => deadlock.

Does the same apply to dm-integrity?

I. e. is it possible that write to dm-integrity will lead to allocation?

-- 
Askar Safin
