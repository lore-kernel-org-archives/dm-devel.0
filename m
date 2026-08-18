Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995CC37F32F
	for <dm-devel@lists.linux.dev>; Tue, 18 Aug 2026 08:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787042116; cv=none; b=o+L/t81KxX5upvXoFAOMJzSUV1s9I50oWj3jk3qO5Y68+sfI/xB9uZEMq8mOgqMlWew8tDYBAgXq5x018/y8wl8qHEBvd4H5Aokfxsq4GiqLmw79AOiIR2YNqCiAFJ2S2EWAuWw2RVtWWmYTbkj6FCrgLIPYsFo66Fdd8jd0TzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787042116; c=relaxed/simple;
	bh=CLQaSv3lamkgBL1GM90wlYcd4kI9IBfMx8trqh3HCjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3mvYfaZHDbMXs1OBA1A7Z0XwYCFyNRm9bQTPTNhlO8I2f3dwZwEXmwhVBCYddPAUBZUSAUiFHxwX6xSu65ck9TaqIuKRagOkyqNtSlGOPSIdl7U1cnCiK1YiAzIFy1tiW6Duk4DkG0H6Y6VHzxlOvmyWZeuZHNW3MktoSFHPqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AwjiECZn; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AwjiECZn"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84f3ab8751fso42207b3a.2
        for <dm-devel@lists.linux.dev>; Tue, 18 Aug 2026 01:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787042115; x=1787646915; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1V9rOlexPr/BBHeo5V1wTpFmsLr8dTCItzZ5QDRqTjs=;
        b=AwjiECZn0apjhKLMFqTsUXTGT4fk+QWjFytm0f1p5yF1Am4XNJcoovA1aNlcRgqe0w
         RiOX1BccWlYkpVfWoS8lMR2vQPJErv2osEku/1RVHA0F/CEspuGNo7fLPbp+TBMCwJqJ
         rnkpRhBLk7V+3kT27ASFyO3JyrqlUE9g2myeeQnXaBcc13sYkytVcmxkwfNMYPDjayaM
         t1AC17XhkDJcaB5P8h2AOWpyZfSUw+BzK9uLe2fXKk+ltgwGKOIy7c9qsm+jaZLmBibk
         2ca9bmoWCCKlRm+HnqUuTWRI8iU0GAMIL+eZMOmROH2S2N8R3CFVF3kHvWF+aYzxLlf+
         e/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787042115; x=1787646915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1V9rOlexPr/BBHeo5V1wTpFmsLr8dTCItzZ5QDRqTjs=;
        b=SNJzr7TevL9vCrz3dR4lU2Vbye2DfsusyneDLrfUzneS6vljHOPuBszDiXX7lfONCH
         djCsZKsAd535ytECFAB/pPSs1yEIfXnbGQNISPqLN6WyVfUVCXtdEAGuEPsUdt8z05+M
         lS/mA+O6Iw6cQ+LE52Wf0lJ80Wz+qQq/MZlssBLzJjDpeEWT+wLhnZoTMTUy/tNNfred
         Cnx1CNYfLhUkval+o/sQfRIWWg+HmaOMlhDN5fQ5j+2X4hBzyFUPk/dOkfecwPpjpiSv
         D6p+Nb3e9ebU4Lz78Ix9ye1stpEW4lh6xvydrtC1L3OItzt21WZiz4iWa/Y1+dngEVfF
         iGpg==
X-Gm-Message-State: AOJu0YxUvYbLzZy5EtiDFJwC1x8NIkEEoo3BZriZulJT+1zOtd+FPz0q
	7LgVfIsU5M5EtXffRp1hkxs1YtTLzRiKcSamGD4uUx0fxCPgIDIZ84Xi
X-Gm-Gg: AR+sD10FRK0FmeAoqMoOo91ymd/6N3prG90RsCTiRN2Z9Rrkau2Qy4en7lXGRtHMr+R
	luH7jxeN2/TQTpDiBQ9kiUpRtuSl9GBDm+HJnsxvXVjjEBqavtjmyFjCZD6evRabxrncYh8e/0n
	xUp1V80lPvuPsEwqgdP/Aep0e9HP2rdPQSe6clPTsip4vLUC7ewB72byCENN5TtIXRZ3ESXNPT4
	vuVYUJtGtXSyJgAy4Jxy+WmsQzuAKsdve34HdJ2PFrlb+lqiHuV2AKOOMIxwmgn5p6fExc6um/3
	hEGpNZYWBjvUY9bSWcsy6Ag4XTILY0zcbdqfFan4rr8SCeUYczCG0Po4Chg75tkukl7baXqafw+
	CdFsxB3Q1M5o6XPoFJbx9nmA3bk9zMHqsZH8CjRGpHMpWCGA8qUulZjO7RLtBbdfo1brQPPP+XL
	LOxt2HSGZq1ZvgNfM3W0p4qjf1p3ypT4qO7HduA9PQ8uBdaZ74mdZoqZAkOe+FsjHOX1MrHwACI
	A==
X-Received: by 2002:a05:6a00:4a01:b0:845:cf73:5bd8 with SMTP id d2e1a72fcca58-84fddf86f3fmr12810918b3a.1.1787042114885;
        Tue, 18 Aug 2026 01:35:14 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6f8cdd1sm1258581b3a.36.2026.08.18.01.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 01:35:14 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] dm-integrity: mode R resume NULL deref when DIRTY_BITMAP is set
Date: Tue, 18 Aug 2026 08:35:10 +0000
Message-ID: <20260818083511.352-1-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817100605.292-1-junzheyu1@gmail.com>
References: <20260817100605.292-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hi Mikulas,

Thanks for the patch. We A/B-tested it on Linux 6.6.144 KASAN against the
minimized PoC (mode B format, plant SB_FLAG_DIRTY_BITMAP, load+resume
mode R).

Results:
  - unpatched: KASAN null-ptr-deref in list_get_page via
    rw_journal_sectors / dm_integrity_resume
  - with your change (skip writes in dm_integrity_resume when mode == 'R'):
    PoC completes; no list_get_page / KASAN on resume

Happy to test follow-ups if needed.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>
