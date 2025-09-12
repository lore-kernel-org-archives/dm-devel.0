Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0839A28DC4
	for <dm-devel@lists.linux.dev>; Fri, 12 Sep 2025 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701317; cv=none; b=Hd71mIO+1JrT7JT0t4boSrmMGOe6Doj+fpW5dvz0ece5n1RFdUf4DBXpdDDW4W7L6Oxnxn859aV/GND7jd9b1G6Q2tegsPqViCwLfn703TOpE5b5lPuj2JlFuzR442DoxFV6mxeva8t/YmNqFrJw29+WPukdQVJIINW9kfSuaFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701317; c=relaxed/simple;
	bh=NMeUAJJ2t0j7WslPNUedttzj6X4H7z4BTO0KWTmRzew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z/8MvZjw8BjxNoVWcfbv+SPIJB1eHkmSUdqGOAc2OqwDVZEYlGDnm/UssHrsNn3nh7emDw0NK94VbkMA45J0cXlzcm7Zc9RpLWuubrvMp8IuwsTqc0tZifoUCvb4A5rUY3v/gKO0oQzIXrhY1XDLGBt2FdzLaeDE+dDuGnENqCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=moA6xRHH; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="moA6xRHH"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3d9e0a6aa4aso190422f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Sep 2025 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757701314; x=1758306114; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7durCQ3OajROyXU7AAbi113LyXq37EOO0GE60QYsz64=;
        b=moA6xRHHXQLt0p2uReeUdRLeE3kycFvBU48YziYi2hy48uIjwC291fLeDMK7tLQxSY
         tEDIn3vPb1+f1Pg108jGQsGVeRpLuP0OGmYknNHf3JBJuSUhfpJXiRiwW//NSJGJkdgA
         yINlyG24OpUMv3K5NFNgWr5kTrU4sOrTXkOM/97DvX2GJPvXhhgS+zNBqpkW37DXKTnl
         kF6t2IXxAh1HC4m4SsiYf8k3zPALSQxt+YkL+t1MUKLHfHfZszvxOFVdyJTfUOeArOPC
         LSeHLSMIwRRoS6HoHnt1IdcqRcXL3nFrAoKiR31T/2JW2px0qWGQs/IcpFLuhGfFtLQY
         FP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757701314; x=1758306114;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7durCQ3OajROyXU7AAbi113LyXq37EOO0GE60QYsz64=;
        b=GIKSuSoi7VBNKtd//zUVFZA7pAqhGQKTCAzkpIJ1iZFN5rdVZbySyL/HR9PBhFKIqZ
         a8+rkz/25M2YGB46I8zFwIn9Zg7KYLDe8zjVUqTJWKbjrBNviSOF7XZ5xJQrLuVSbABZ
         juY25146eBaT8zPj8DsIzCR35UCEUiDAHi6B1wXWG4/LxKvHASWLpKCZaj0sEfNDY8rq
         5FQtpedwasjRr6bNydjWbuvXY2L3RwtPFHP0YBfKi5r333uGaVGvYm9gfzzico9CtlSp
         0YL4/l76cyGyQp9uzbhdvUta/1Hnxw3PqmYLR9b4wmbfBJchWWRYJA/iNb+JoFpCbA4M
         m5HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYN5adV2Mn+BJRuNHgrwnPnqoRCs6zgypZTrJyROpqbuIzySHzfaTKxX/LpsrSF3eDeewkoVU+5Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YyOBGMPf4deSPAf7n1HJaLvt2ATQgCdeWIt16kYMOzVQoXvD6dY
	nXBZso37gScx/7HVUoweK+SE6nUwcHQcLMHpZVjx5yIxZ+zHX2cdKn0=
X-Gm-Gg: ASbGncsnL06VuO9hfEHMrfk4ycZ5dJPNxIxP8eQmV7ows+P1nd4sSFJJHMxDGX8Z6Sa
	b3PEKGKa5ijCcsydYb2aK478T3qifyDFVt+5TAHMkzpgtlNtAZYmgDu6+xP1BNdySQHEh7TrtD1
	C9aXLLhM26iPb7Ti9uo0/WNx3Frw6n9jnNWdlFNa/6whr/u5Y5noMJeyrURmuC6/D9vZo6NM98t
	KQmvgMciAfHeYnfV18/KrJg1W8OAUoy/K8XqFyoeSHLYbW1XQ2gS2x3tDbTQZo3w6ET7k/lp1yp
	ESLBpvslwsBba+XkDYsD+noDvsQMJMQae1wetP1gSgDs7EbiP2mbAoTD51Sq9d/4r2yCt3CALVX
	ZwvE21QKtvjsGT2E7mGXW6AFMKG9YpOt2ZRGKOeugi69zzXEU67BbGsZqKDn6
X-Google-Smtp-Source: AGHT+IHHEK8gRVh3JjzDP+E+5efQYXp2z3oLSo9ALDHjHdLd7SQ6MV4EsWVmuc2IcfuCx6xY6SYBTA==
X-Received: by 2002:a05:600c:1d22:b0:45d:d57b:69bc with SMTP id 5b1f17b1804b1-45f215c6e70mr16274655e9.8.1757701313779;
        Fri, 12 Sep 2025 11:21:53 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607e2d43sm7378194f8f.59.2025.09.12.11.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 11:21:52 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add new info to multipath.conf.5
Date: Fri, 12 Sep 2025 20:21:49 +0200
Message-ID: <20250912182150.116717-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Document the static vendor tags for nvme, and dasd devices. And product tag for
the latter.
And fix NVMe example (s/NVMe/NVME)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5.in | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index f1158f7d..3c9ae097 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2024-08-15 Linux
+.TH MULTIPATH.CONF 5 2025-09-12 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1653,9 +1653,19 @@ The \fIdevice\fR subsection recognizes the following attributes:
 .TP 17
 .B vendor
 (Mandatory) Regular expression to match the vendor name.
+.RS
+.TP
+For DASD devices, it is the fixed label: \fBIBM\fR
+.TP
+For NVMe devices, it is the fixed label: \fBNVME\fR
+.RE
 .TP
 .B product
 (Mandatory) Regular expression to match the product name.
+.RS
+.TP
+For DASD devices, it is the fixed label: \fBS/390 DASD ECKD\fR
+.RE
 .TP
 .B revision
 Regular expression to match the product revision. If not specified, any
@@ -2030,7 +2040,7 @@ the foreign library name in square brackets, as in this example:
 .P
 .EX
 # multipath -ll
-uuid.fedcba98-3579-4567-8765-123456789abc [nvme]:nvme4n9 NVMe,Some NVMe controller,FFFFFFFF
+uuid.fedcba98-3579-4567-8765-123456789abc [nvme]:nvme4n9 NVME,Some NVMe controller,FFFFFFFF
 size=167772160 features='n/a' hwhandler='ANA' wp=rw
 |-+- policy='n/a' prio=50 status=optimized
 | `- 4:38:1    nvme4c38n1 0:0     n/a   optimized    live
-- 
2.51.0

