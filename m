Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602379;
	b=bqfN4qU1eAsm7EpPUB0btFFDaROHU+rby2AW46jMXwWvN/IGKEkUI5iuPLjMVeiXdJpr
	 BbTHkD8ujrQ7PgT8XqWH3VZRN5M6wxWoIyPuPo+vPXcSzYXXfxWPvAL/c4w9iCgMzuL3U
	 xBtD0uIbuHZhV+oduUqbRPfUSJ6WQ3LvqY5KVwGKhrs24xi9ZyZIsKC2SQOLlTR84pkhI
	 gc8Phr6hfI6Zwpc83+nSldGK/5bmGA/h6H0BPPuUn+XRhewz1v1FgbaaMAKTeSKLsv7+1
	 pM5rvSoFzsK+NBc9Y7BoiAiOAnlgzLgV2iJT5wpSVT71ieExC1TJDoazm4a6Higan1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=wFvOxC9WMLAN+zsoxE7iDnAuZnU6LNP1k5uBUsFCR40=;
	b=ja2KFz3NEdsdCsmsiKjDnTvGGwVtAyQuidcWR0FWgIyGPA7y+KkTYAhkIbIWonJ7brWH
	 XalobHRuFGtuJ+gsjpBEC7R3SMjZQ1fzBAfUNyjTuDm33qjRWqPf4vto4bdTGoqUjOF6O
	 dTi7dLeJq8BxRtF6H2sK08aDZ7N0zXWn37h7xd7j8c8zZeITNo8BGCOGV7+w+FIFyBGpN
	 KkZZWA6VbJZm/96IXCuHc4uC+RGNJNzWGKWegAfvXWNAQ2cD3l8SKfgsClPVjYE/wNrPw
	 Q1nLNc9LRkY8JLTNN6iE8jEA9T1xPl1l2zeoFeLl2/2+NYJdE2qZ9Xhh+URbviucdcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uJ7wOZRj;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F2606A32A
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 644F2606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uJ7wOZRj
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb67b3a18aso5313875e9.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602378; x=1796207178; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFvOxC9WMLAN+zsoxE7iDnAuZnU6LNP1k5uBUsFCR40=;
        b=uJ7wOZRjPCAQTQjTo+Ej/OnOFmzlrFW8RUMBqhj0VM5OnkViLgsnrgWibZ52ep31Dn
         /w9S0nFVcmEE6GQvuiJTaFC1VJ5XWOPef5Minnf9oJMXlwTS2yfXjrHFQ5Zd1V95PR17
         jekGceUEp0ayJLcGTr8m4QnpSHMzV8F7fnS63XWeU+jFOEDXHobD1RrtKvF2taBzQs0J
         OcaYeeMRDz6Rc6KWTp3iTfOjZbcYdqENS7BHgHlobU9IlogKQ+bscNr7cxaCHFQR5zVx
         9P7O0RnMSSQHp/o+vTWYvDXwfkVZ8xXn69D1/ybIrvyB2QjpSzFponld6IN67L7wF2RL
         8tYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602378; x=1796207178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFvOxC9WMLAN+zsoxE7iDnAuZnU6LNP1k5uBUsFCR40=;
        b=08Pf5JjBlxO1Ys/CVukYMvv20s78XU98d8Xo34geONwaoj9PkvAel1teHMMM2K7wrE
         3kffOMofJrl51CTgVM+B+ApJY7HDm6wTc/HzMLTETx9viYcV/5+mN7c+5xh3bmp+nBCT
         /QJyqKpUmeGKINIZp2aK+gfJCdOWK/iSqPKMq/YuC4ffiIokobhVjphDcp4e14SMKrWR
         7M9sEiTIxnKhMQB5vJVsmf/NJAi/v+7JVXAA2D30AfBTyV2uVYWEJzwPWz3ioYBlPzV4
         AS2C/yq0+4LZ6JarSnK3Kluj1kSaGX1nDfhjPMuOVDKk5MqzI4DAiIp2nmqmmIsWNXXg
         RLTA==
X-Forwarded-Encrypted: i=1; AL+hErGR2/zTW0qE/gfiSAAnBSToldacyS9NwHKbiYYlJr7DkEMu8AdrDGm7mJN3JqLffY6jNnHskowlZQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z999xMwKPAVlxrb3AvDObzRmneYei47gj1QucVjYC2MsJbHPoSK
	H631g2VbRfHvHr3j7J5kUItcvyg5d+lusnGcfB/YHz44iIh3s1EOCuyEQTNy+NA=
X-Gm-Gg: AZFdTZdMtiQCjbeTO2NFuSTdWdfJfz9ALsJNBRjV+v8u/CuvNxqVPlWMfxzeL/EwrxN
	exEeoxy+jeG6/irSBvZtgaH0wpXKHpM0S8q9QOflRUHlW5f5kS2mN5E7WxhxRrBeKpYQiSEyGW7
	ozV8MRhhJSIQNNnou7meVfFfkhVcV5v9ITFV4PPoClJW6gHyQekEvQJ0+VJHbdkNXd9opK1iv6N
	pPvSskasCBB2HBg3yIl+9oVAxSmtbvqfqiujYClXjkORnKus4A9Lhq7t/4bPGckqGEh8XyRsP7C
	2N9ecc8OEiPVe+gCaaUsXZpE92F8tk/yjQV2JiKG3O9ahhGy1il5KhrfHM6D0SkPNYpr9X0F37k
	McGiZlbg+Ok+P7xAjs3e36RihWwzGDaXZWAK+e5qzcP4pPkT+wENIw47Lb00JR7flXVRS/tXipg
	wAZhiMSjUuvefZOJgQ5stXshtEMoBuIO9+l8lC3cy09KZqB8DaYczV0l5JMg+8N1C4STVfa2Dzo
	KE8K4Rvkd1q/LoNibRwvKXerY5by6nfS7Pv9Ast38hS/yLJsj6iyl4sLujkmD8DvvBlJnFRcUej
	Hv7aQOkgZsUAR9jegkHalp+gZ+30OGhGk+qwGXK3psBCuMHx2fPzGkKpxb5x/9lcog==
X-Received: by 2002:a05:600c:8210:b0:4bb:7ad8:99f2 with SMTP id 5b1f17b1804b1-4bb88785da4mr326756285e9.0.1795602377732;
        Wed, 25 Nov 2026 02:26:17 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8533579csm443835085e9.2.2026.11.25.02.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:17 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 7/7] multipath-tools: multipathd.8.in: restore the original layout
Date: Wed, 25 Nov 2026 11:26:04 +0100
Message-ID: <20261125102605.82009-8-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102605.82009-1-xose.vazquez@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
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

Add a blank line between paragraphs.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
from :
 -kcommand
        multipathd executes the given command (see COMMANDS below). If the
        command contains whitespace or shell special characters, it needs
        to be quoted like in multipathd -k'show topology'. No whitespace
        is allowed between the -k and the command string.
        Commands can also be issued without using -k. In this case, the
        command string should not be quoted. Command arguments that
        contain whitespace or special characters still need to be quoted,
        like in multipathd show paths format "%n %w"

to : (as it was before)
 -kcommand
        multipathd executes the given command (see COMMANDS below). If the
        command contains whitespace or shell special characters, it needs
        to be quoted like in multipathd -k'show topology'. No whitespace
        is allowed between the -k and the command string.

        Commands can also be issued without using -k. In this case, the
        command string should not be quoted. Command arguments that
        contain whitespace or special characters still need to be quoted,
        like in multipathd show paths format "%n %w"
---
 multipathd/multipathd.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 461e960d..71228fac 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -77,7 +77,7 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
 command contains whitespace or shell special characters, it needs to be quoted
 like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
 the \fB-k\fR and the command string.
-.br
+.IP
 Commands can also be issued without using \fB-k\fR. In this case, the command
 string should not be quoted. Command arguments that contain whitespace or
 special characters still need to be quoted, like in \fImultipathd show paths
-- 
2.56.1

