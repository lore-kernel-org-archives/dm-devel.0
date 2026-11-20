Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173514;
	b=OqtzA212jC3HEAwwNvqSwmsBfQHcrLMlfaiOy/IRM8KFMTawkgiJQPg7iY1CaWUkzc7e
	 bX+lAgH8FbzRX/487W0u9257adYy8kdPZAixpd+HHrIErqVvI/1W1mMLCjnpQ7ZMo7pdN
	 QsBBcZgrZ1wyKbVfLMAt47s2hzYYFpr93wwXv/xjqb3o7XO6fRR3q2/GGZE24EHXQRi+X
	 MVBLRgziK3mDvoYFK+m3K4r8VFU0Y1rg4yqv8qsmQ8ivQYJKUZRfENAqFWMWMFdpSOwbh
	 QFECQlx5wf/U2TJYeVeBmxZ+K+A0uDU62+80xO83eRg8XtjuhR9SA8maD+HLwY2jcIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zpsVdJ3WbR6kE2v38VJhuAhS7jEKmVk9lGuvUfsu2RM=;
	b=WQ9bUGD+jjJ6f8BWHGnrq99XuZnUbJ/ND0gYFKIJpEkCCcVMzRqIf3jXSEX94UtsEbPA
	 Sx02XFTUXDRArIaMwkR/KYOzfSq2wp1eGuEYXwLVIdY64J2Q5dZ1zOG/Mgi/FmUqOQFh1
	 Qxb3u9XxLoWbfBWl4mgtTIyMUhAMKzzlzc25orJvlZ83lEgy01lclRuGmUt/BkaGfZbYo
	 IDPxcuMEnIX16HGOErYXoaVrdQ1GgkOl90ulsGf3Ara92NNyJ1kwyNfQ5zwc94ItDWbEZ
	 GMYPhfvGgn+qlQirMMQsXGdfPKAR6x/ezwXkl6T0+ayCWwLcsbGDBBEk2416GrQtB1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cx4wiKvF;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA556606A320
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 11:18:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA556606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cx4wiKvF
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso645203f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 03:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173512; x=1795778312; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zpsVdJ3WbR6kE2v38VJhuAhS7jEKmVk9lGuvUfsu2RM=;
        b=cx4wiKvFH97aiNs+uX8FNs4RPzhUCa3nk6G2WPPryj2IS+UMeokV5zTxMX1lG3v9pq
         ao4TvgN25L9DA5CP1v08bN0+9R5nmSKpIYK/hibAWJNGt1s9NZgJHop5H1xP2pyzRm6O
         Mxo/Rjf+MGxGk8JEIJRNA8qrjVQXMvpLSjiQ4XVcI7Aw6CO7Xqj19+gYx71HUThVH3tt
         ZLPcOPFFN8bG1IaOI9r9y6feIzQpsFZso+x2iqDfYgOtSSdurRpZNBZdeA/8DWLIkaAw
         5WJl3APeECj6e6siiM9erzqSG+XOjzFaX7XkdlcyAOeRMzQeBFdx35Vcpr+fQ/4QmJVo
         1ONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173512; x=1795778312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zpsVdJ3WbR6kE2v38VJhuAhS7jEKmVk9lGuvUfsu2RM=;
        b=kn5bOftdV7fWHnNE4wNHWzUfx46j/S6bp0lkgxKu30mVQvFQDOEMDUQhqsznM2pG5R
         KC+xE3GfCRuMgWgJWQUdtPiUxNhgZWcM0mCSlc6V4Zbmv1ne637C7JoCgNwmbVkks9Y/
         9JsVZTdk+EoNYSCPhoofAxBGt95KHuMEeJp7+qdLyYWFU9AjCV3HwUIfheaQ/nC04GSC
         AAdLmD1Yso5cH4E08TgqPwxawvqm3WKw2c/f3OFEWctCsx8FwCA355o/NPqBYfUUudDu
         CVSdrBgkAYMMQBE6IGBtPfKHztNRB05MaGdVKB2s3zVbGDoL2ztsuXGBqQsaVDLIkUXj
         pYCA==
X-Gm-Message-State: APuU4Z+irz33EXCwB2QU8meEUvh4KiyRGSEU8b+W3oR4Fi68tRC6Ng2l
	WSayL7NomnV33xQP484WahkbKVVA5ebUpbasvUVamt69n9jowCbKgD7N
X-Gm-Gg: AZFdTZeqbCAQynDM1xCLjefQ0rBu5i2md+HU+KnmkOnpKk00jTi2wk6vt5YzpYnQEm2
	PEeoInFrKxnyk2AabGvYn56Au/pQxv86hLHwp+IbTaMKdVqZaGRoBUzC0qE94SepJVie+CtJHrn
	p2+V90rP3vM93WdombmYQg/tizfYJouAPDg5WkI0VvjMpLbQth5Dga/7DX2C6ccmyLYLwt+RA91
	Ohgy67tmN371AH1novXEIJSeHRMosqTCHA8Lz2dCABWEpPSDhjsH13qw3UdvP8QK23gkjTH9heo
	qeHre14a07Tq+TUqMdPUPV7M8DXk92E0Ii6Dzmb4+2dDa2Ok2sTgvHfj38qEJuhD2UoxTTQPdMM
	ANFbTl589x3U28oYH9t6J7UFHz8eS2IGAJCVijFw7W73v7bq5TJwU5hFeYwhuA+rvAReOtbWxxj
	y48nETZ5EGKD2oC0XAzls74lnGOEjcKzXlJeDgZf56Kuzk3h2rXFEQiwXOVL95EfZNE7AXEZjck
	d4YMJmdxPTb2UJbC+L55f1ILwyxG7kdikFCqAXCUDnYJ1pin57XCQa9COMI3cpQaPLh2UXCx4JG
	3uiko2A9UTf89Lz9xGRek+1k8nDiLq0BMKQtUrH4NgcjpP113qUu
X-Received: by 2002:a05:6000:4705:b0:48f:c4fb:6bb6 with SMTP id ffacd0b85a97d-4abb400bb83mr5164503f8f.12.1795173512177;
        Fri, 20 Nov 2026 03:18:32 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain ([87.116.183.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d60sm4985562f8f.3.2026.11.20.03.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:18:31 -0800 (PST)
From: nenkov2004@gmail.com
To: linux-raid@vger.kernel.org,
	yukuai@fygo.io,
	song@kernel.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	neil@brown.name,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH v2 0/2] Fix recovery flags on failed RAID10 reshape
Date: Fri, 20 Nov 2026 12:17:55 +0100
Message-ID: <20261120111757.4705-1-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
References: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
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

From: Hristos Nenkov <nenkov2004@gmail.com>

Hi Kuai,

Thanks for the review. This revision implements the ordering you
suggested. Patch 1 clears MD_RECOVERY_WAIT in dm-raid on all three
reshape setup errors. Patch 2 removes the recovery-word reset from
the RAID10 abort path.

Checks: checkpatch reported no errors or warnings for either diff.
Both affected kernel objects built in WSL. Five focused userspace
checks passed for the dm-raid flag handling. I did not run a
live-kernel reshape regression test.

I used OpenAI Codex to apply the review feedback, prepare the v2
changelog and run the checks above.

Changes in v2:
- Add the dm-raid error-path fix first, as suggested by Yu Kuai.
- Keep the original RAID10 change as the second patch.

Hristos Nenkov (2):
  dm raid: Clear MD_RECOVERY_WAIT on reshape setup failure
  md/raid10: Preserve recovery flags on reshape abort

 drivers/md/dm-raid.c | 10 +++++++---
 drivers/md/raid10.c  |  1 -
 2 files changed, 7 insertions(+), 4 deletions(-)


base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
