Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC6437E5C3
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 08:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791878525; cv=none; b=tFEzzGlpnmRQ116vD0pLJkSDdCLHA5Hh/VkeF/QytsUmnUndKQxzkqKSlOkq2fyvjpewn3NskgQEPPcldbEaNblMdpdID1SRKHB18xa1kvOfCDQs1z1EWfYfEZho06Zi6fxmu1wtMpxdvtquUTl+drcOCv1OekRsBmMHJsrvkSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791878525; c=relaxed/simple;
	bh=t4orIt06GtaIMZNSl8mfu6p1hQPfMKIS8AfG8Kga2MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t88P4TKEa5fDaUBqtogYioUMu/vwsE116Ki5LetG5TCgotOLd97e8UoNaTXwXiUKmLvklgCBGOgE+qRtyAQ7HHuOwKbjL2ZBuRLi6OV2cw6OD1lsQn1vOp2uIPLaX4wOPxj07R4od2hxG4MXy2YHGKg0U52rzyfl9FfjEUHEyAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=soo7F2cR; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="soo7F2cR"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c34bff61551so282493266b.2
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 01:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791878523; x=1792483323; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t4orIt06GtaIMZNSl8mfu6p1hQPfMKIS8AfG8Kga2MA=;
        b=soo7F2cRXqYVhBa1zCfnROUnki/P00FfG16NK+cCdgG/8EYbHSskFyFwmlvASbFoiM
         OWxRxPwtsXRKADOzm3IMEilgRq62wAdQjOBPEZLlfrNQnS8eC8lg4T4LS4SlF65kUhaC
         k8rPG1h1C/ndQS4K6McIcV1BIt1W35FKZqmZXBbs32hM2spumIeT2WcKBcfeDG/MsOs+
         2APgTksCzgPkCSKLYnXuo/NSVw1qpe29FegKf9dB76MD0YqO/lokL873U5pl1HV9U9DJ
         4ZnY7kcmI25POE7hkd8tOnLjrpbaAVriHAYHP8cDeA7KhUsdYe/3udysjKZjvOIfb5xK
         0+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791878523; x=1792483323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t4orIt06GtaIMZNSl8mfu6p1hQPfMKIS8AfG8Kga2MA=;
        b=pR6Ro9WcNuxVCY2jWuBFv5nE3S2r8haXiqwSYpNkDb/HT5URVazjFq4SAfho8XjrhR
         0R2jCODEf8c2XNIZrVCEOVl4msojFzOIwBVMb87pj1sqBCPLIWph2viBORTcrXBnjtcv
         YrGRKQvWzNVcqM38mm/twbvBxNJ8vDJNLHNsS5ZqOJCOa5G3Vi3WXVNJ8Jz3WuzLoYwU
         0CyTQ4ptzIFKiGQUvfQa3IvQc6g3koh5DFld3RRCfTEWs28xr+4KF3RR33FoXE8EFXwy
         B2hco69cGvwkBAEVEPHYMtZjTh8WmayhIX1AjnLlMvnwyEKtYq/Zsz2K44bQ5ENnuscE
         uaRA==
X-Forwarded-Encrypted: i=1; AKwUvBwgw0ExISOgDqX2tZ9LQNxr7ovQrcYYzCI8YnojC+TcaFUP5yRWp2o0YXLEoGQEA8Nyhj3HMaNQIw==@lists.linux.dev
X-Gm-Message-State: AFq9FYLnVidJV03oG9+nKS9QllgXxx4A13Tvnld9YRRKqBT3yR4y815N
	y7N+SvqRbRrK6dCob39FQRVBnGWOBf/ORa9n+/Nkpy2mlJ2lGhgWlHiv
X-Gm-Gg: AYBFou0SN4SgFLd4YpkaROWZJlj/2PGH3LU52Pokhig923Gu79d7dE2p2tAfcvQNK4E
	1IVDFudDYiCMLgD+VwEZlEMnkf9R+EG7LEByw/6h9Zq539vCFQEo+DcORElvMBpXXNY4g7YQFqM
	jbGNRwoobglvbBy4F8+8ZXpjaXE0bkm+2DiXwyRJrHvy8ZmK2gU9CxQ1mdWCihOEJRqrmg8f9uF
	Yb0FoHs1xbTLm7asf3bFRAL2s+E6liPJSNvXqRuHTQ9vdDuRg80RqEXVKiVsC1B5kTUt22a89S3
	PDEefgVJV477c0jAEHx9DUegrxTUGbQW+exoXKMFu+axZeCycemqq25JrBJGNqWfInHGDxFudHM
	GNCq1AI4oPVzqSay/CUPh92K6UIH+M4HFfv5WqXexr7VbPpI3jzSzGZyNFmIksxv46FJVyCzFOR
	be9N74c+ral+vIEyxVSCJ/5WaVVs+CBbDsqNb3axRopJNODLU2Z5c7LeH7MZ5KfshD1jVrurhb0
	wcuPrb0Ut5sSiWn
X-Received: by 2002:a17:907:3eaa:b0:c2b:4142:2db1 with SMTP id a640c23a62f3a-c31aa0d82b6mr1250747766b.40.1791878521335;
        Tue, 13 Oct 2026 01:02:01 -0700 (PDT)
Received: from localhost.localdomain (luna.k.pl. [193.239.59.185])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3626dd09d2sm119890966b.18.2026.10.13.01.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:02:00 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: hare@suse.de
Cc: mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	dlemoal@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dm zoned: back off when reclaim finds no destination zone
Date: Tue, 13 Oct 2026 10:01:57 +0200
Message-ID: <20261013080158.558-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <b2a6b9f6-53a8-4250-aae6-a0837f0f598d@suse.de>
References: <b2a6b9f6-53a8-4250-aae6-a0837f0f598d@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hannes Reinecke wrote:
> Reviewed-by: Hannes Reinecke <hare@kernel.org>

Thank you, Hannes.

Mikulas: this patch is unchanged in v3 (only the author name and address
changed), which patchwork shows as accepted:
https://lore.kernel.org/dm-devel/20261011175450.952-2-illofspeed@gmail.com/
In case it is not too late, Hannes's Reviewed-by applies to it as well.

Kyrylo Biryuk
