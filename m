Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574569;
	b=rt7yMcVKKtmJcKQs6C6rSvA11MLrfvrsnJfdH/YXTe19RbRke7tyzsgmvSU0dr4tRHLl
	 n8XNMw2714c9r4dkuCKwcNGyIQTorctgEz0A0SHbsH51WtGlpfCLL90RGQoarCHaTuuXp
	 IlHkqV7TYTkItPtGyIFN/r0N9y5qwcTY85KGzHyRlYPfR090l9kNVYor6cqYC6EBMRWGJ
	 8zvWpIXpuekrk8wgtKFnu3J6CD9ScjyCwWv4PHKQO8yIjCVvbhKy9PtQMfFkvwmrBU1YI
	 ZZ2ow/Ys615lm9ps9NM2bqes7TZFhe/MBUkAVNInrC8493mAwBKOIL25VX9235OAwFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574569;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=OCqe9AyXJd3LBzeOoHkBIS9K3aQuD7igVNLXvGN0vBQ=;
	b=12mI7THtp8AuMFcjcm4TA78z2nfslWTFR0hYLQdL4366VDpMw/l8M6Mxvp4dUfzkQXb2
	 pwWkprddHKmlllMZsjwH/+XfqgFZLhqQQSiicsQ7bluqiXUbGVhaJg+N7b0+l3OHgCNxJ
	 XV9nH1wU6Y0i72mPaDYxfPxUxppN+zUSU+F0KA4XIllQS/fWhxKvu9gClSy+hFOHXZkxX
	 tKgd+wcQ/Qez/pgNZ2btwdR8C0mXPV+NkW3mgCoy5mc2hHvQJf9ZTVPs3btpkSa3pTSSy
	 n2mrb0GVZP+OutIGxsrebACDPP3f+mzR1lWXDxAdhxOHlkYVpWNFRg2C2cEt3NR9iLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m+3kM27c;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B42606A885
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4B42606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m+3kM27c
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb5ef25ba7so42895e9.2
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574567; x=1795179367; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OCqe9AyXJd3LBzeOoHkBIS9K3aQuD7igVNLXvGN0vBQ=;
        b=m+3kM27c6baCK6jVLvq3NaZJNIU5lA4HltRoZRIITegjCSJq7yiZqaHNO+iTqspUJ8
         vdsnP2zpSmeHKirH3efiTjUqzzC0oNXap13GbRj+x9XEy4MIvKILE2ERCstH7qg1ycH7
         0ERhuBxjVCQt/nJHjfPbBne8q7zcJlFfMrjclijo4Y8nB7hPt8zWmk5Rqm2rlkeSklYL
         r04Erjl/V9kabtFDwoM+klgoKU3MDb5iRIqB/KxBSCXDIpA5mLm/kJWD0j1yRKr94CuN
         WWIfXxmJk58XXoIL9mVbwNmKVkqeFVOCsExTjeVtRC58VbddIDWacFY5hCz+klmWj9az
         SkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574567; x=1795179367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OCqe9AyXJd3LBzeOoHkBIS9K3aQuD7igVNLXvGN0vBQ=;
        b=tRBbpaJiiF3ioX9y/QB1re3sKxkr7XQwwwA7Gefy8ZE6GM23iiovsVivvk6sdFnHKV
         x0kfuAV6/WjbXrHs0qYG0LqZm6KCyhUNbPqFeSOteK3vBIEAUz7w4cwvlKu2eJxKSkHB
         ltzViV3arSJkT/iPDtFc/eUSRwadO3lMtIhxNDDmOQMQ7VZS8KDam5bbT6TXvOATK6cA
         9y0yDROfnLQrpca9OlykxffbYaZRhN404gQPdscHGZsDeOstCRCQmdBlSnondT4jokpz
         q/qQcNRYLgONnnKxET1TIvmsd7fbbmN9sGkRif2pWVJ6x6BabdLuoikOrjKf2PQVUGci
         49+Q==
X-Forwarded-Encrypted: i=1; AL+hErEa6mmcz5CA0zXl1lfrsbT40azFrz81Hfc9e84fPoK0pFZOPtX5EzI7uM8WkwlXZyToDorXHhge3w==@lists.linux.dev
X-Gm-Message-State: APuU4Z/5zp1TEYZY7ebmdKdDeTCvp8UzCHUZe0wuknKKfUH1C11kTK/C
	Lpo03dNxYVqBSl+jJsyRLV10I6lkuCEU2iBR/HU0Jv1o9mvwF/VoDfs=
X-Gm-Gg: AYBFou1GuOwtbCADuVPS9JFRG/QBwzD1mBQNqrnmoF/fTNtk5e590KjoaWDTZuTyFnV
	eJKRgied8LPIuv2/ZsD3xEV9AfYmeZgogoR+o3UUuCHKuXDErNzMNRxUyxjQzsDD9+XRkDqe5gD
	Wh7EzYp+qoF+TkZPs7gsLsNDsmQdVXRhg029tWGs4zYegNPNvbTo7urL/QpkyOu7uh2OaBiTViX
	oBGnONekS5pAiWj2/bmI1MXcw1+pZwQorovt64qqlhfMEKl7yQCkfBLDJjknBxHt3c/ub5c2RIK
	SEFYksghGjhDQXP/RQbqXsEMR0sq4gN2IVGiB6g4LHfyI00X3ycaINNirc7gY3awq3v71YnzAAA
	SMePDcH2hQHnBQ7kG5NDwfXRHnRh3atw9doU0IwCxupEAkWzpzM1SHYFM0tHLaJHNr2t4xb7Ono
	HhpuThPmzPbneFpRK6NUgzqFIE2ck5qk76amHShhHUP2khE4SiYxtTXiM/eIse+pTe+6r+xdWhP
	j2AqYOph8yJOLpFF1rkwTMST/kNUtvU9VCuM1/ynbowGx9gMJUKFoVBYsHWxNcOT3Q9GLt6w2ml
	8zOSFYAgZRWgiDW0f7mnI3XN88wohcTq6GVlsyeWdPYCnCXHQI/nM7EuHjr09aMJ4Q==
X-Received: by 2002:a7b:cc89:0:b0:4a1:7dcf:be1f with SMTP id 5b1f17b1804b1-4bb55a3717fmr31246435e9.1.1794574566955;
        Fri, 13 Nov 2026 04:56:06 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm259031495e9.1.2026.11.13.04.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:06 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 01/13] multipath-tools: multipathd.8.in: fix mandoc WARNINGs
Date: Fri, 13 Nov 2026 13:55:33 +0100
Message-ID: <20261113125549.504780-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

mandoc: ./multipathd/multipathd.8.in:36:1: WARNING: blank line in fill mode, using .sp
mandoc: ./multipathd/multipathd.8.in:44:1: WARNING: blank line in fill mode, using .sp
mandoc: ./multipathd/multipathd.8.in:80:1: WARNING: blank line in fill mode, using .sp
mandoc: ./multipathd/multipathd.8.in:118:1: WARNING: blank line in fill mode, using .sp

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/multipathd.8.in | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 632cbe40..461e960d 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -33,7 +33,7 @@ multipathd \- Multipath daemon.
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .B -k
-
+.
 .\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
 .\" ----------------------------------------------------------------------------
@@ -41,7 +41,7 @@ multipathd \- Multipath daemon.
 The \fBmultipathd\fR daemon is in charge of checking for failed paths. When this
 happens, it will reconfigure the multipath map the path belongs to, so that this
 map regains its maximum performance and redundancy.
-
+.PP
 With the \fB-k\fR option, \fBmultipathd\fR acts as a client utility that
 sends commands to a running instance of the multipathd daemon (see
 \fBCOMMANDS\fR below).
@@ -77,7 +77,7 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
 command contains whitespace or shell special characters, it needs to be quoted
 like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
 the \fB-k\fR and the command string.
-
+.br
 Commands can also be issued without using \fB-k\fR. In this case, the command
 string should not be quoted. Command arguments that contain whitespace or
 special characters still need to be quoted, like in \fImultipathd show paths
@@ -115,7 +115,7 @@ socket file can be useful to communicate with multipathd from different
 namespaces since it can be bind mounted in them, unlike the abstract namespace
 socket. Multipathd will accept \fBlist|show\fR commands from any user. All
 other commands must be issued by root.
-
+.PP
 It is possible to change the sockets that multipathd listens on. If
 \fImultipathd.socket\fR is running, multipathd will use the sockets it listens
 on.  A maximum of two sockets can be defined by \fImultipathd.socket\fR, and by
-- 
2.56.1

