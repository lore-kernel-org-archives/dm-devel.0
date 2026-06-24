Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5AC3D8113
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782312779; cv=none; b=VuL13WKnb5BWTl8FStYh0Ym9qtsCcn4/KvNB+Tqov5p0jygsrpdAZhPqDzt2b3qBTLEBmta3Tz5wZAELFDI/F/ObyLgsbnc65VM16l0A0PsHlgC9gWBesfspF8fPif7iKuYAygK9UBzhNhyY7u7538iQVBCuvRpa2fQELYp7HZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782312779; c=relaxed/simple;
	bh=4lIX3CSL6mRT767GfKgX/lace7SyeilSaO/bkxEAQVI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k8wsBN2unkG2z8+x4AW0gyfqFAfpPVoLlewGNd0vGH2/NIatjRU1r8LUQbYl8TvQ+RyOKQC72uP8tFDJ1stxjccpOSzLPeFATWcTPWYra93MP/dvX1o3y38AJtfPZ02FF2hS53LAevcQkhmVOC9t7htqN58KwUbjgqtApTyADYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/XwSVOR; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/XwSVOR"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b9318997so6037045e9.2
        for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 07:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782312775; x=1782917575; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sjn0jQ9j2YHkpOLgMbWv9P0/Gc0C0JiUOMhD76WOjhs=;
        b=H/XwSVOR3Tde8LDgbNEh2rs5tp+r5cr3XYtAFFvBT7wnY3uQ754ayGqy+nVIQRcdaQ
         6NbUZczUvztHY+jd+pD2KGRVVkA16/DR+SNJmknvBmQ+1D9DVhrEId7ZrU614emzeMMf
         bEbStFrKVrMYHnzLHPsxO2NfKXnCGPMO3PKmm/SF1E+YhGCH2GyW9M0Lg4eC7SCdl9zl
         jnRAlL6p8zBWdTz3/hWxlClea+moiKzmlz7ox8t74zAcYymGIUmavgozrnOYjwfBAqPW
         FNXpKMtWJ1yXev15LbkyqFg91SVuqqGSMeCAXxJ35CSBC87FQy+BqeOvAkdFZVppiBI2
         scIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312775; x=1782917575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sjn0jQ9j2YHkpOLgMbWv9P0/Gc0C0JiUOMhD76WOjhs=;
        b=pa8m8S+UHzZNdGXXi6tkndrZVGf/DyZh+KhmH+89RyXfhyurdK5clH/3gkMICZfY5x
         rIyRdd6/mYujZG0FV7f33P0n/wKxcqPRGlXdivH//aZj8g4wVRMjly2dlOHcphNSatq9
         sMd8zdvDyMvXKTgH3HG/c1/rSXs+EZfzsTcZe8ZNqC0fdZQAuz8TMYfqt6GfUUqXIWD5
         6CRAI0r7wczyY+T/JFbFNrN+9YCcTRG4SeFwHTFyO5goLa7p2a9Qks5MDgxduJyJLJA5
         PgLeOUnTlC1/Tyas0mSqIQm+GQakdeu2PteiXI269e7Qx43kSLzqKaeK9ojliqQud7n3
         eHhg==
X-Forwarded-Encrypted: i=1; AFNElJ8Ua9eSXrwTvj7lL66zL8qBsAD/gRdjO80+s4faEfw3iikvdAFhgqax8aF8KPJbBO4E7DR1j7Renw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyAvCsxI3XeNqGnDS7aq/99l+6cOwoa37rW8DjtqUai18UyFkYr
	f0muMRRDwh+8GAN6eRfrCvsKEE2BvFpFAR631YLHkDzjcwRRnDODx6GN
X-Gm-Gg: AfdE7cmaB9AUSrUCdmMFkUP1vwdVc9RmClMAg9CXFUtkTlHj/WRJzsT2USMk3dVTCiV
	WhyVC8speB25JwVOfEMi2LQV36Idr10gN+GbHQ/udnZQjDVnukovXqJ3EmZ249Nw/AYURVNp61H
	+MtTk7M+/kr9Ry48VBJlz3OPYGjYTeCT9PzDj1vVf+UciBtP1rWpUhPRv7LJTubLuymB5VjB9nY
	hm25bDvR/pMv24B0ygF6ReTpIVSAsyD8oOTclM7Uq2PWHjTzA+XGUVf9wx6tNNYl2buhYBHzvdH
	c7fKTJXOl3FOwXwkZ756GI8jIR4tNMc2lGALwMyGyGzlBz77k8FHpKjefg4X9/kmTDCPt0fevqY
	cjLpRq8f0HPY9xZwOxPvQwtjPVUdLo4621Km/mH9X6nOel5HeWP5ke395F9IaKryZcJvUJW9a3I
	xLvupcvZxL0aWDeZzH8zZ+MWB+0Vsh/Ws0sHIGCEk7TZol7mlnSgQDBJLUN7r9KzoVACzIBg==
X-Received: by 2002:a05:600c:8506:b0:490:b724:5085 with SMTP id 5b1f17b1804b1-4926087f25amr51464735e9.33.1782312774479;
        Wed, 24 Jun 2026 07:52:54 -0700 (PDT)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4924923392dsm735988005e9.2.2026.06.24.07.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:52:54 -0700 (PDT)
From: David Laight <david.laight.linux@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Tony Asleson <tasleson@redhat.com>,
	"Bryn M . Reeves" <bmr@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 0/3] dm: simplify list ioctls
Date: Wed, 24 Jun 2026 15:52:40 +0100
Message-Id: <20260624145243.2736-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Scanning for poossibly unbounded strlen() found the device/disk
manager ioctls that do a double scan of the data to check whether
the caller supplied buffer is large enough, and then to fill it.

If the buffer is too small the required size isn't returned.

So simplify everything and make it all less likely to overrun
the kernel buffer (copied back to user later) if anything changes
between the scans.

I managed a minimal test that the ioctls still work.

David Laight (3):
  dm: __list_versions(): Only process targets once
  dm: list_devices(): Only process devices once
  dm: lookup_ioctl(): Use designated array initialers

 drivers/md/dm-ioctl.c | 207 +++++++++++++++++++-----------------------
 1 file changed, 92 insertions(+), 115 deletions(-)

-- 
2.39.5

