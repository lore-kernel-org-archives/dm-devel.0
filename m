Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9662F7445
	for <dm-devel@lists.linux.dev>; Tue, 23 Dec 2025 06:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766471647; cv=none; b=gy0Ir3l30Pne/LC/Ci3AUBvSp35ZBYxBj3w8TsWYE+4Z+E99zRWG5NaczjpAPv83SCLwe+ZfoWLUNmydeqtH15DyshUjhdQfnvuQkA8W2xo4rFJQ829gaTHLk8SG0GqF190AiYvR1l6W+FvYKuaUinmcZFCQD0CCUdRnj+DD7ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766471647; c=relaxed/simple;
	bh=zQMCxWwv+vy2hbOmutXkA1vn5ZNuVRvD6yhOueNtNZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nflj1T4hzDon7qgr7ulnuLU+G+GgxXMJJuQA2mZQamkjQB/kN5Z2lLEugpbo2HZpxli+Bowhw2YJDvc/O2lWsXILkjQae4w7Xmmy/luSyjQ4B1BSSfbMpz0Fq5Z85kjdWdjDH0bn0Bstr5mNSjjN5dyO7TCwIZDXwpPuYpEV4jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dfnyrO0H; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfnyrO0H"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37bac34346dso34521481fa.2
        for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 22:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766471644; x=1767076444; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=dfnyrO0H1Nq7ZRPIt2C/vGpxIe4Jz/qAkoW35IgXAd7d1d5PEbRjbqsbDZT4/Krv9F
         kvS6NSixruTPv46NDsUL5Q6XGpFZrNcLYiTXMIjnZoL4FznwLJE1ejAekwHQrFjAdMZ/
         rHzvIC0QUF7Qw9iQSe/8brdCNwgyVXVcZG0TkkYnRDpFAlvWXpGduJL7KrPvt5Ntmian
         I+t3nFf40mHK2RFRUkpjz/uoTztQnQvUIzUgUd0jv29E7NY8mGpZluiCm3i6FCzJFB11
         aQ28h+wNKhDZCLDuXsQxzTrEuFj5RQbgUWCUYgl0sn5sxHVTkKCHxQDOvwmYJZyGrsfH
         dw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766471644; x=1767076444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=dKwWglz60e26ATPyBrOrru/ugFkMh9qtcuvA5yL4FM2dgCuJ0gnhvJ5ET92UZems2K
         poEYYx3jd3nrXI+7LQSZ4Y3mDlLT9pb7zDTFLOSAUlaLbKu8O/aKH+c/u+wouxldA4zd
         Mxw7ITo58IfaQ5hTp2HotGMLErHqfPlKA11njN/jTrcfAagUpi+CWHzbYH7Y+3ysPi/d
         foqfmd4SkvL7hwIE6prlepjUb5wlNpS06KhIHVNgTV7vioIBcZpB97TWMgyriOK5uFTm
         Gv7gQ6kQWSTCtF8s4/jGrOe7ofDvUTzsaLppanbR9gsDYEHsSzU0bUmv/wLBMrMFBQlp
         ppsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjpoE99s6+Ku1Qun7XnLOLEOVhpADLt9ZEf5tvGs/1L07Vx6rg2smW3VBde0dmtqF53mTVSUNPQg==@lists.linux.dev
X-Gm-Message-State: AOJu0YygxzLL+F4rIiQfLAtrXyXjdeyE3+wIiECdI6YBSNE8f4ZeGRRc
	LTyQjlalgwEt8BNG3F90z8V5Mkk2sD0K7eGwwFHIRJaqkNMF5NPp9oD8
X-Gm-Gg: AY/fxX5XrniLirE+Pcu9/Jgh6/GVqtc3gVsniFh4frE0BgLY86SHeiRrCMTidl9CQ1H
	c8TcG8hATGxHORqmpO2Vdl+BrdGyjn8DaFoSvGgVpUjTIvZodjx8UIZz9esegPzghoZcz6bMBMZ
	8tgClf+gzApRIOJnbVSjn5T31Smw6E2bDoGVIuVv9Pswv625SJGL+3sO7w0/p7cxDMOPcnRgDD+
	ZrrNgK0UPlSwlruy0r2MxR6BbthQlcdFsj/tJs8l4Ez6Rc2VqBsUGTsWDjs0A2MZAiPnDSbUKXM
	WNsmTgEvEiVAXNczMt1K/ePr2HARdyp8dGSB5dm4qD2zSbJjJdDkAEQsM5jbo+82PSjW8ivyeGr
	AYJnwGTizQw2536JppT3I5HIXEyImbFO0i8fuTTAOABGD9azCh45ZUKcfQb1xtNvZioDBN3G25u
	srN6hB90Ss43AIuZkz3tc=
X-Google-Smtp-Source: AGHT+IFaFE0nlDnowk+Ou3U+M9eX56ZCvZ4aEX/mIAF0sQ5oS0z9Fh1vnyWDY8DQIpJC2t19J66zfQ==
X-Received: by 2002:a05:651c:1506:b0:378:e055:3150 with SMTP id 38308e7fff4ca-38121566b66mr43783861fa.5.1766471643890;
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381224de6eesm33742031fa.6.2025.12.22.22.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
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
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	safinaskar@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 09:33:55 +0300
Message-ID: <20251223063355.2740782-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

Okay, I just read some more code and docs.

dm-integrity fortunately uses bufio for checksums only.

And bufio allocates memory without __GFP_IO (thus allocation should not
lead to recursion). And bufio claims that "dm-bufio is resistant to allocation failures":
https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/md/dm-bufio.c#L1603 .

This still seems to be fragile.

So I will change mode to 'D' and hope for the best. :)

-- 
Askar Safin
