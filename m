Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D114287
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379626; cv=none; b=Y7rXtgTF+biMNTrDWX49eYduA+kdHZDQzh0KXuTfJF3ewahRckgOdx82uFSWMNRpDqSFjeAxfV/cP3sTHV3F+HQxIeAUFBpVVURbR621YJ5p2D2TIstCONA2oET1P1Nihx+CgVn7Vx9lBgcJH6VSgfOIlzeBIVRpx5vUSLL+Fx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379626; c=relaxed/simple;
	bh=t8JuubzvwyRy9JUN1J5J8KG6h63BLDPZF1WeblTqHU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOjoaII351szlpg0oYx19dSIvrRHtJekbGk7ld1yDiudUbKzuGC+kWeC1WuTMADcVJ6erjZZcP81zWc5dBg5wktmAhWonGuDeN3bXvXinlHV6d3cM2MGcrgSH42NumvKCHu1z64QUyahPQpow/L/1ApAVbj2nhis03tiIR1W0y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c9/b+F9Z; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c9/b+F9Z"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a53f131d9deso447022666b.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379623; x=1713984423; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j25/ezTrgvO75oD7NPmOABy85ds+9Ko5ey38VCKJdw4=;
        b=c9/b+F9Z4GKkvmILAVxwLG2Ftdh9k4smfTaq7+dzg64xLvREZ+B4Qw6PWHp0P/bwNm
         QXdA9Sz5D1ueTAfJ41oScLxm9jNlpjfDbtJnlnXhNuoVNoOGyH4Ls5t9UJ5GOy8awb0J
         LtsxA5TMHxbRPQui3wSCgEGyMcF/OWuZ5Gs/xPVOKlHZL15p6yp10jY6ucVz7k2wfVJY
         6yD0aX+wnjabeQGH+0O0F5Wf1eKjgHSw0p4eX5QNIQhWMksgob85LQ/+sgn1NKGduuqX
         DJUydCJiujxDWf2OAMY5eveUJfqQixvLUrL5H1M7NInsgAijBLhFHWP0j3G2xpbTcxiO
         ux/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379623; x=1713984423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j25/ezTrgvO75oD7NPmOABy85ds+9Ko5ey38VCKJdw4=;
        b=DdHcy3ZaFAkr3OoH1HVyC+Qjtj8fqJWbFY0dObOhouzc9o7KIHMappBWaJ+1J75gZm
         Lq4VC5lGilo6cpM7C21ZBDK+RvJGxejd4zjPRscIeth4jAdqx5wYXR6UXcU4IBiFmIRI
         vjcRVTXipYgoobwKyFs6glBw6rUInznKDU9YrLJLPSyNUHpf0uaeJ2InzLevS/63Aa2W
         8ecj5rQylYsDxFlHp5JWtnHODvGMvyF5cE3oeiFrzsZCzO3g8562YP/n8LFlRk7nHx+Y
         JpxdHKlPM3nGH8GBkaYhF9WC6gLSmm2JE0ACDAdPkRwmEDQ1PqRcO9HbpaR1/pANaT9c
         BzTQ==
X-Gm-Message-State: AOJu0YyAsSMNpl/i3idUPY/wWLn/yLKETUzpjwg5MA/3fdAFrqXeGITy
	LWcLwK2TgD4hs4Epr1xPduX0slPJtrAnoxaHVWCrH7JquPM2sQuYuVFMAZtVm8DP6fBLw1gTkpA
	4
X-Google-Smtp-Source: AGHT+IH0LOkRzMbTkPAEfJre0iuh097+U9hyvPxW8ZEBTLOpYw4SK7mrCLjZGX9aZdlccMUO3FQbxw==
X-Received: by 2002:a17:906:851:b0:a55:6606:bbf7 with SMTP id f17-20020a170906085100b00a556606bbf7mr211138ejd.35.1713379623023;
        Wed, 17 Apr 2024 11:47:03 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id qb42-20020a1709077eaa00b00a5216df5d25sm8381387ejc.3.2024.04.17.11.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:47:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 8/8] multipath.conf(5): update documentation for max_sectors_kb
Date: Wed, 17 Apr 2024 20:46:44 +0200
Message-ID: <20240417184644.6193-9-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5.in | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index c788c18..b29a75f 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1311,11 +1311,36 @@ The default is: \fB0\fR
 .
 .TP
 .B max_sectors_kb
-Sets the max_sectors_kb device parameter on all path devices and the multipath
-device to the specified value.
+Sets the \fImax_sectors_kb\fR device parameter on some path devices and the multipath
+device to the specified value. \fImax_sectors_kb\fR is the largest I/O size, in units
+of 1024 bytes, that the kernel allows for a single I/O request. For hardware devices
+like SCSI disks, this value is limited by the capabilities of the hardware.
+It is crucial that the value of a multipath map is never higher than the minimum value of
+of all its path devices. This is ensured by the kernel when a multipath map
+is loaded, but manipulating the values of a map or either of its paths while the
+map is live can cause race conditions and I/O errors. Therefore this value is only
+enforced by multipathd when a multipath map is first created, or when a path device
+is added to a map. In both cases, race conditions are avoided by the kernel.
 .RS
-.TP
-The default is: in \fB/sys/block/<dev>/queue/max_sectors_kb\fR
+.PP
+Setting \fImax_sectors_kb\fR does not guarantee that all path devices will have this
+value set. It is not an error if the value of a path device is higher than that of
+the containing multipath map. It is also not an error if the actual limit of a map is
+lower than the value in \fI@CONFIGFILE@\fR. This can happen if the hardware limits of one
+or more path devices are lower than the configured value.
+.PP
+Normally the kernel and its device drivers take care of the maximum
+I/O size, and administrators do not need to bother about \fImax_sectors_kb\fR.
+But some hardware devices may report incorrect I/O size limits, or other components
+in the environment (e.g. the fabric) may impose constraints that the kernel cannot
+detect. In such cases setting \fImax_sectors_kb\fR makes sense. It should be set when
+maps are first created, and not be changed thereafter.
+If the setting \fBmust\fR be changed for a live map, set the
+value in \fI@CONFIGFILE@\fR, run \fBmultipathd reconfigure\fR, and use
+\fBmultipathd del path <path>\fR and \fBmultipathd add path <path>\fR to
+delete and re-add the same path device.
+.LP
+The default is: \fBundefined\fR.
 .RE
 .
 .
-- 
2.44.0

