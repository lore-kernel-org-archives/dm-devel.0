Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B7343CED8
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 20:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493091; cv=none; b=acOQQrFO6+jESWNZwXN4vBJZHZESMPwAKaAbxm8Tf2iTVDFIYk4D6R043alcqlaYSQqOXwANoqGNLXFlSGbsKsZmdOcXupytqT/jbmay+PUwH1+O3YbEFGBCZCtKcPgBRWhBRXvW5SKQDL/T5Z9pL0zkSVAr/QpvkDM7fyOF69Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493091; c=relaxed/simple;
	bh=vQAwyxNj3AED0ZWDQ7B3q4d5Ag5/7cRBweYxf4EerGQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=svN6/LCyE2AATAClLpO8y1595TS6nKk7rcAGXs6+KxTlugveXHTFzQIK4+nwOh2JVJX8LruFwxpHT8kOV1TMvE2F/9VsP3yZA7HUsQ0dG6RSY0node3EZCliklz/drq2RlI6ioTYR8oaKgaypMMZOwv40rAt1cpN9Ng6Uk7Iyts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=Y6ooOmEz; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="Y6ooOmEz"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-678febd9307so1414130d50.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Oct 2026 13:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1791493088; x=1792097888; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LSvHBJQxiIqbp6o9z5pfgV7EhGFvpIA3j/HhyOfsFYA=;
        b=Y6ooOmEz+8w8Z9iGnf2gtVbMUFNnQaNt5jYvGr/R0Y/Pus/rd28HXJ33TEoGeruBH5
         3KKkpXU39Rzmq9Q08wdr09E6gQEkuRUgFF3ZdduzLkMOOO/oCHwqdttEUwLJXbVwQ7ig
         kBalr+d/nHycaL7N46v/UTQhyZLu0Sath/h1HP4GgllkiYGyjVUEIRZh/+pweQMGDNT/
         L1b3slxRdHdiv3phxrlIfSxvg8w2aaN32clH8FHBe5jKwNt++91xsT1C+IashSDO6Tt1
         Au52cO2ElvRmCNKOklezbZUKKL8xeQ862sAM4UihFZEzNgb7odLnqRWPLxbvcgSDeGCQ
         xR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493088; x=1792097888;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LSvHBJQxiIqbp6o9z5pfgV7EhGFvpIA3j/HhyOfsFYA=;
        b=isD0la1jVLKd5q+Jl+m2YX9dJjhXMjU4MGZPftKz6ZW43XKtLd7+rTQzDvarTSyf8x
         KEvjk1ypYyLmzMcFuMun7UdZXOHelST4ky/Ah8t5wePJbKUsLyG2fbFz+79AcYslySQv
         PW4M/yPRdiIEPeWc9zwTzDWZhzoa/y3SLLsX1msIWPv6Bvd4gdpU5UUeD9BgM5euf7z7
         ANiikm+1HHH4VmeNA9FM4jBGpOdg8BaBcIGPOfuOpoxB7NMfQ6jhkqb6RpYwWQYQW1Xs
         y2FEhL6B46qfpvrprNfNlB7xPbMRWLnHOVGDJGLpeerlhAdQgvRYJ3Eb5YC+FOKoLonz
         VE4Q==
X-Gm-Message-State: AFq9FYJBuOsHPmReH2irPU79scuZlwH7zfja1a0xn+mwlTBeKhFpPGds
	fgBWzLhIjBs6uvFvghjLEwyr6jUbFp/1P9TL+QSb2uaAiTTXR1eknSNaHOTDqpF1qSAh
X-Gm-Gg: AYBFou3w3sXh6iQ3WU6ThT1RD6/tumcs0LJuM6PvVlQCrE72nUly2BA0qBIT6aj6aKH
	3uAm/h4BFIl6HYKs/+F9Swzov05OB4GNgfaK5HN3P1vReHRlkP4Qq31uKSJfC8nWwk/FTkeI4BC
	3CTTqO45LEPNDZTqozuGxC575XXFx1k1eyBlTamhPUMN0eIFnxPw51AL6BXrUpAiYPBdLHeZDwY
	VSKWKPepeSZMYC/Mmzhz5l6rANofykvlQOGJ4nH00mrS05LOO6SGREJ79ZZEuG73DT9OAfgts1p
	LqnceYITTvZ9Gu8JR3/iiKzMa8nQFSkMpZxUF4ZTZGVaetayGucZ9PuQS8UX7IDI1KDwPMXkdy5
	qb3XOx4TCyERgTWA3d3Tm/4nEFC1TbegZbSKFPQx75eAGjYJ7o5a4lapA5qRzn2LVn9VqABf9KR
	QgB42zB7iFjAxsKr8gEbJa+19rADQRUML9QZVdQ+Sl2gig1SueXXr3SocTdS/vRRBJpw2iWiGN7
	ZzzP8nzeY8zi9C0D5vu1hgfvSzapX3TbKytvATISrc7sFe+/RdvRCY=
X-Received: by 2002:a05:690e:4391:b0:675:6803:98bf with SMTP id 956f58d0204a3-6793628b5b5mr14774d50.45.1791493088070;
        Thu, 08 Oct 2026 13:58:08 -0700 (PDT)
Received: from [192.168.1.110] (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67935707401sm78814d50.24.2026.10.08.13.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 13:58:07 -0700 (PDT)
From: Andrew Halaney <andrew@amutable.com>
Date: Thu, 08 Oct 2026 15:57:37 -0500
Subject: [PATCH bpf-next v2 3/3] Documentation: keys: document IDs added
 since KEY_SPEC_REQKEY_AUTH_KEY
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-ajhalaney-dmverity-key-identifier-v2-3-008456d189cb@amutable.com>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
In-Reply-To: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 bpf@vger.kernel.org, fsverity@lists.linux.dev, linux-doc@vger.kernel.org, 
 Andrew Halaney <andrew@amutable.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.14.3

The table of special key IDs stops at KEY_SPEC_REQKEY_AUTH_KEY.
Fill in all the new ones.

Suggested-by: Christian Brauner (Amutable) <brauner@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Andrew Halaney <andrew@amutable.com>
---
 Documentation/security/keys/core.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/security/keys/core.rst b/Documentation/security/keys/core.rst
index 326b8a973828..37ed42382f16 100644
--- a/Documentation/security/keys/core.rst
+++ b/Documentation/security/keys/core.rst
@@ -372,6 +372,19 @@ process making the call::
 	KEY_SPEC_GROUP_KEYRING		-6	GID-specific keyring
 	KEY_SPEC_REQKEY_AUTH_KEY	-7	assumed request_key()
 						  authorisation key
+	KEY_SPEC_REQUESTOR_KEYRING	-8	request_key() destination
+						  keyring
+
+There are also values that refer to a specific kernel keyring rather than to
+anything belonging to the caller.  These keyrings are not linked into any
+keyring, so a search cannot reach them and the ID is the only way to name
+one::
+
+	CONSTANT			VALUE	KEY REFERENCED
+	==============================	======	===========================
+	KEY_SPEC_BPF_KEYRING		-9	the ".bpf" keyring
+	KEY_SPEC_DM_VERITY_KEYRING	-10	the ".dm-verity" keyring
+	KEY_SPEC_FS_VERITY_KEYRING	-11	the ".fs-verity" keyring
 
 
 The main syscalls are:

-- 
2.55.0

