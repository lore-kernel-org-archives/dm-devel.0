Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6EC3F9F2E
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790328; cv=none; b=UgeRZtEbG0z3Fae2j7yE92UG24wacul2hqormaI/T/fyxIcCTrJx6/f76iKcl0l5dRqaq1lwVvoEoWAd9UmhRQ1b+FIjW/HE87nCVXCfiLxWyXRQ9uD/C5gylgSQkJkA1xMBSVw7LX1YeFHtnBfbPQgkQxHSVzg9mQYWqAUmLcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790328; c=relaxed/simple;
	bh=JovVvhkeUYB8+XDsJGebrklBoqpEX4MFBESCZIq6jcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cen41bl3GXWogJwiW3fyZX50dR6p7V/eg5zjz/RACvxSZWN3+Dakj1Xm8+uvn3hL3hMEQRTWucpUD234pzZVoZ/P+H0Mbax9QeG/cIMPlpk27tqcgCHOaYv22PHTzLeSzoZiX6dh6LKEEuThqOQI0N+R02ujKflKTBCR9H8umU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZqD/84Wg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZqD/84Wg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490791a3e92so1072035e9.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 06:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781790323; x=1782395123; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GAdD5je/t3dWorCy0JuFmH1Msln2sPsjQnIFLG29NdA=;
        b=ZqD/84WgiGegJnbU413iT41w6IG9Dota0YdU6FuE8SnAWpJpusqUIXTwVw4fQuxngi
         IxmXdgYXfqxfhcgzSVsAcTkYb6Ka9PdmRK/ioy/N4TZ/CC7N7amKMEF6TOqxO6t3IoBG
         pJWnI2YmNrabtqEQ3s9hXlEZdS7BVQW4W2exMyMf97zs1++qixjNQ2oMru5h3n0UvH33
         P4+L25VHr/NaNgkRfOBGhC4qOiyzc0ZTvK2RmaGt6tH3gR9B+EvXYwquCg6lK5W/GYtd
         nID22KMEcLcm5rJ2nkxXIHD82oK8KLTwgtl/9UuqnH0noyaK36hFyz3ks8WXNLeiChOj
         7Gvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781790324; x=1782395124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAdD5je/t3dWorCy0JuFmH1Msln2sPsjQnIFLG29NdA=;
        b=iwRqRdK/niYWUcALh0QU8IQZY7I9d6m1s4yiOP3PJHpjRxe/B2SoECssY9u9Tci0zx
         0efTlbjWqNHPU7zJhKCINGY881nDXQmYzvnpgbysSzNnrLIFflz26+Zo0q+BetIruZuN
         psrs1W+KxlBn7j5tJDHttZtT6DHvTLVUcAhPzQ1AHxU8lzMmoy9/t6tV1T+5WBZHDH7B
         DIYsF0w7olwJ7nMBj6kYW4f/lnzqaeTlf4sYahPlFofW0wSqnihnP5otcyMY0XtLh4Bf
         /Lhiqx9/6laPNieun0ruJxzEydMl0LnabpLZyP04Djxm7nGYsz6k55394GJxWwiCl5hC
         iZ5w==
X-Forwarded-Encrypted: i=1; AFNElJ/0AhR9x8Q8OpO/3YOJrYuVn7LVglbNt1cgtlXXNNK/9ucQUSbuV1epPEzLsxkeqnuOqR7emKCK+g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxx12sdAHQrif8MfSm/XD6eE+AoQZlnvGY2IIqrIfY/x5klPx4a
	9VAw7/ebK0jk9EEVt2Yml5deImcF1RwGLwKgdEMDDKac06bnPuTfs60=
X-Gm-Gg: AfdE7cmnKTh+vM+4RsaveO/9sCC39e+y5IEQA60NZNb+NwTAZLewfToO6ifr/531AX5
	vccE355cosSg5wexYjtKCyAQURHIKlMJcapHn/1ObbFMBFWoFvq7X+2j0xOXVPQN+dcn/j95g8E
	ejHBVY7YHo+5XWOYivKGj0FR7UMfvWkLf7NsKXMshj+a8eIku0z802FKBNDVWfFlLbaykzjEYNg
	25/nL+zyVYkvwVI9oWEs9xRKR8FAdJQTy2w8VBu3towDpIhUb2eXUlG3AYKhJp5YGZiynkPR0fE
	y0cQlvU0lMtQ0TXOr0kTsSfDhpIn6CzVr8FWPQYAdaK53DB82GBhMs0THa2C9eQ9deNyHaY2VTE
	tsKEFdJpBlzd/Lz/TIZsRHpwENGDqFVHBC14xXRXxLb0UnlxmKVjtBnM2MTTRgoOT4kh3ee5k6w
	pBBXf6IK30wic3m+6pUq2FDkJiHqh4ZfM+4LAYWg57phVYKq2092NwGovPiw==
X-Received: by 2002:a05:600c:a20b:b0:492:2df9:c2a1 with SMTP id 5b1f17b1804b1-49238233214mr19105895e9.2.1781790323365;
        Thu, 18 Jun 2026 06:45:23 -0700 (PDT)
Received: from localhost (241.red-88-28-13.dynamicip.rima-tde.net. [88.28.13.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a4601esm273263895e9.1.2026.06.18.06.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 06:45:22 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v3 5/8] multipath-tools: clarify path selector descriptions in multipath.conf.5
Date: Thu, 18 Jun 2026 15:45:20 +0200
Message-ID: <20260618134521.16878-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Selectors operate on the next individual I/O request rather
than a "bunch" of I/O.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: fix typo, s/group/groups (spotted by Martin)
v3: revert v2, "group" makes more sense. (spotted by Ben)

 multipath/multipath.conf.5.in | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 422ab120..5b730801 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -2,7 +2,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2026-05-27 Linux
+.TH MULTIPATH.CONF 5 2026-06-13 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -193,20 +193,18 @@ kernel multipath target:
 .RS
 .TP
 .I "round-robin 0"
-Choose the path for the next bunch of I/O by looping through every path in the
-path group, sending \fBthe same number of I/O requests\fR to each path.
-
+Choose the path for the next I/O request by \fBcycling through the path group\fR.
 .TP
 .I "queue-length 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe lowest
+(Since 2.6.31 kernel) Choose the path for the next I/O request based on \fBthe lowest
 number of outstanding in-flight I/O requests\fR to the path.
 .TP
 .I "service-time 0"
-(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe
+(Since 2.6.31 kernel) Choose the path for the next I/O request based on \fBthe
 lowest total size (in bytes) of outstanding in-flight I/O requests\fR to the path.
 .TP
 .I "historical-service-time 0"
-(Since 5.8 kernel) Choose the path for the next bunch of I/O with \fBa dynamic
+(Since 5.8 kernel) Choose the path for the next I/O request with \fBa dynamic
 algorithm based on the historical service time and the number of outstanding
 in-flight I/O requests\fR to the path.
 .TP
-- 
2.54.0

