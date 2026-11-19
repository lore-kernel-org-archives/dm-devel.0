Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105706;
	b=nPD2hqzG8nDPX/As9whNmobKX645m7fDZd2tjzeIxX/7OgwEr38RI8i8CmEJcjTara9w
	 3C9HKHQsyR0svENZ6kGN2RN+1UTwWg+RS8YNgxcL0v6IjK0PtntnsS9/Hujtfnji6kbve
	 QsfVWpnAT4pLcIO4dYfzPYXW9D+8UJRzMo6mG+lHGc8ZKHh7IfhiLWS7BYDbDPKiUthNI
	 LOhScYjuuDzttTVJeqxXO48Szqbtjhr01LdXTlInKnN2H9Rgg4PXnMD7sIjCn0t0rLpfd
	 VzfXzU3pN1CczUBd4Z2cv8LVsaVCxbd7FQFS+6WnQ/u9XpvaK1Wd6lVa5Xngz6YVG1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105706;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=siXpRsCnfzzbOgk7JozyRsSVm24gKBPMzEvF84sMpiU=;
	b=hhEO+bAi7E2P1TNzZhWKK2PqGi0ucpvs9IPazhZVQSIfb9JQivyH4cOkIGqGR06qvzuJ
	 jj9hmfbilZNiroFJXKKh0GWhrUi/U/+4Ev7Of6BOSQY4k7ahpCd6Xcx0/rup3LvijCviu
	 9hq22hGGPKbI/QquJNYCerh7PUEDzWQzKOuipsjzavhmePuPsbyYYHz0rn/Nr83suYZYR
	 RTiukXrITOqWWTvvdpF9HhUgu8LrgncVMEuzryW8JI0xTqK5RiDeolai+kpP5nko8vAli
	 vReLDyuUYgpfzVybQUzeeDFgY1iH0Dj+6e5apBTeleR1H23+9yrehlwUjEdAwZD6/Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hl6cU8cS;
	arc=none smtp.remote-ip=209.85.161.52
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C6606A324
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 16:28:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F40C6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hl6cU8cS
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6df5e315bd1so2031330eaf.2
        for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 08:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795105705; x=1795710505; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=siXpRsCnfzzbOgk7JozyRsSVm24gKBPMzEvF84sMpiU=;
        b=hl6cU8cSMYJSX3vRQLG0DsiBRgesiNwtlixSpYI+HQRzzIzKUdTESyiRhKyVtsAlzI
         hVAXEAHLQxMN48nAsVrotkIMmrG+h6gnm9Sl/0dI+ZRKK2N3M+/Qcs3iLctY0BvNP5WF
         PfOuGhjrmxh6ScJiY1rMgHpD/2KNgNDVU7OPb9SscmMPKnMyd4dBIpC5M+1KxAL38Ln2
         TBDHAAwccvWNb/ao4kucvln8N+U++hWniSv8qv8kj8H/QWPx9R2jzGU+yD9VRmDaY4S7
         QwxjKFfjNUwXhQ35GEi26lFTRVer1zotbsWUuAlN2vuobTRPM4UEZElewpF3y8gezRPy
         optw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795105705; x=1795710505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=siXpRsCnfzzbOgk7JozyRsSVm24gKBPMzEvF84sMpiU=;
        b=OgZEc1O+0peIUyy4oTqg4WVEmNHvCvqmUf6IBTYrXKufqCIByXWVjCLmsZ0ZMXMugj
         59uJUVPWidFbc+lvDXmZyZsfGs0du1axQfF82UiYKPb1q0pYCGR2ka/k0pylzwq2Ay/w
         o6C7AmyLytF+Sd96HSBqZVl6BWaoEOewGYhZLcfUjdy3T3LooUXD0+jjebzz5/0i3BZZ
         hMW23d7wwXV597CM64jWotTIvL/sxJ0yrRq1wvDaNLFJj0b64RBAgYIKW05JgqwjCYqu
         Lv/+MESxr7ztoldLYXNYC2iTm09yXgfHJu2IZfKEbRsc6aVb23EHTr/Md6ueubo7gtsv
         wgyw==
X-Forwarded-Encrypted: i=1; AL+hErGZ2XNJtQsVV1QvKR78reNHla9L3D/Hlas4gQqIn/2iS+niOhtGZKIZUm01jTSFXW2oRTirh1teAA==@lists.linux.dev
X-Gm-Message-State: APuU4Z93frS0ot+x6+ynBpEBLSRizxzsCisU9rQwV6SEGfFbhEIx2Omb
	EEGa+8lpbGAhwooFJLwcyf1NjdFy46x4L0D3ApcvoKqNhqUHJPdmOVR3
X-Gm-Gg: AYBFou1g4st19yyRNKA6wU6odKZ47zkjxLJjON+QJEDLSFXmCi8FZBR7MAgLvAnOXS4
	EdagE0N21IwI3xFZFbMiWgy2F6b4Yf6dzzTtgqG3lRLU15R9jtAc9eOk0GsEbxjReDtnd7VUg2F
	48rkuDBO5vEXZ2GSu1mxwF2aUvxj5yM4is5lSvMXmsATpuRxtEpxaBNrDH9vP5HDLJtcdWeZ7aT
	a/mAe+ZQJnqyj4GnPjlGlp5PN/XLwlKWysnwJSt7p3xTUa+VhemIE5uyagdAvAleiKlZvFutzIM
	dHqkGBQXFuO1OEOiBALA60nzTUy9dEEAW8MIHejzAer6vnHGpKAXPkIZ2h9tcxIYMdAc28US0t7
	oRh+Jf/91zQmebdRLrRn5c5adswTGj9A+A1zL2uzh7A1ElyK4qIUB4pqfevUJXk49rhu0mfbfsr
	dYDlJOtexAqbDUiFQSJ0fLTTKe71ek8aIxlStWmGExrDWyi9BD/5UsXTwwzpEXYeQp13QRFOe9l
	wdyVt7uN0QhITmjPwt8fR6VfptM7u+2IT3ywaqkb9WQIGosuKHuaxOLbwMmJvjy/ADtN3SvuX2G
	eEDlEEu3EQkIxA5jEQje+UuOEPH5tHUXSGdtGsds2sbsr48NptJj1PO5hGAj8tUHPdp8ldU/x2i
	I+hUAoH9z
X-Received: by 2002:a05:6808:3505:b0:572:6179:36b2 with SMTP id 5614622812f47-57a0a4056f9mr472016b6e.10.1795105704869;
        Thu, 19 Nov 2026 08:28:24 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-57775461e70sm4530581b6e.0.2026.11.19.08.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:28:24 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: mpatocka@redhat.com
Cc: agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	zkabelac@redhat.com,
	okozina@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject
Date: Fri, 20 Nov 2026 00:28:19 +0800
Message-ID: <20261119162819.1627180-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2033a6a7-b8c4-99cc-f351-e83579a238ec@redhat.com>
References: <2033a6a7-b8c4-99cc-f351-e83579a238ec@redhat.com>
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

On Thu, Nov 19, 2026, Mikulas Patocka wrote:
> Is the kernel dropping dm-bufio buffers too aggressively? Or is it not
> dropping them so that they consume too much memory?

Both, and the tension is why one global value cannot work. Our hash
areas run from 0.x MB to 40+ MB: the 256 KiB default makes large devices
re-read evicted hash blocks, while a uniformly large value makes every
cold, idle device hold memory forever -- and most verity devices are
cold most of the time, which is what small-memory systems complain about.

> Could it be fixed through other means that are more general? (for
> example, having a global dm-bufio shrinker and dropping buffers from
> the client that has the longest unused buffer)

A global LRU shrinker would tell hot from cold given time, but:

- Our userspace already knows which device will be used and when, so
  it does not need the heuristic, it can drop exactly that device's
  hash blocks, precisely and immediately.
- On low-memory devices we need the memory back quickly, not when
  pressure finally ages the buffers out.
- Verity, thin and cache clients share one pool with very different
  access patterns; a single LRU lets them fight for it, while
  per-client floors keep the shares apart.

Thanks for the review,
Yongpeng
