Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C743943712C
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 20:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493086; cv=none; b=Xg/ZQa/XKO72tQgNMYmIQRvtFLdtxEb0hX8/2tBX73TbddarDEREd45lf3yyQG2hP8q+HEiuDBF2Z3jKYlkPWL8bIN8SHL0PVaC6CZOj30jvHa9olVLAn82+YTFBrd/N6etGxHvAw0kD2hC2/crOe+cTBhCNW7FgADloMClvQKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493086; c=relaxed/simple;
	bh=vpbeEaPR3E1pmaT/xNDC5hjULFUimCv8YKxCMpWM/dg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZTAT6V50K+tTpOhJElvTix9ZwTIczSS30XhKfLcSv8Qh3tLuKCqrch7u3zWqb2FlDZWXmhVlUpx4g74zlpROFszoA+/TNp2izCELLh1YIVGSW1iesvdQSdI0VIhCwpx2Ie5H9y81E7+d14WEXunyvIT+UVV5e0mn5BdWsITpqm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=PiM8ErB9; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="PiM8ErB9"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6711f05fb14so3807794d50.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Oct 2026 13:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1791493083; x=1792097883; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=V0S61SflNz3PvfgcGBGx11GkE7hBo5diSyO3i89hlIg=;
        b=PiM8ErB9YOBH3pDrFcRfakqLOs+ZntKl+RNI8tkgFL2g34gPyssbbSeRYFdNMBez9u
         2hEU8aaJs1qBHs9C0S7OAe6Iu7zLLiWpJhY+JdnCaOlczhoOsAx2XsV30b7/sCWK99/c
         TNVL83tL7ddOcwUHQUlJ5saUcuMb2k49fP6Yz5C2C95fFmkKBZTM7038bIFs1G/+2Flu
         Xs5apVqFiuVNAW6fPA4Bepl4b5e/d+AFtVAjgKxZ7q8lCRAiDMkQwhbA8fk66L+gTZjZ
         iXlEfqTV6rkzZ4zBKa1pS+2x4837/CsjW+FucR1K8rXloircrwJqvhoOCyZSk40ACiD2
         +u2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493084; x=1792097884;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=V0S61SflNz3PvfgcGBGx11GkE7hBo5diSyO3i89hlIg=;
        b=pWI1qOcOmZP1zCJHGLdXrzB36FiiYwprb32P7+IRfK5JhAhnTj56UmNiLOIUaI+jMf
         kVEeEEOY7RAak1Ro+3JzBuFoAG1OYTtMnzaYCFFdzIjabN3gcWO7LXtTKvC4y7XiW+S6
         OOIbvuCS+Vqdmu32D99jOn3F1SdXqYnxpeVHN8qWv0nBrp5ZQw378r3gdV2FT0GHcMlb
         uMYNf5QrHOAUIAuc7o//Ay7HiXkVCI4cbF0xGrdkoRhviG7S1c0He/zMPeGf875fTnjs
         Qf0tYob2cvuXpre0dKDxo6ZfFc0WBpi4989Z+YWSRePx9xfhpYbQGA+vKm026gl305SS
         3oeQ==
X-Gm-Message-State: AFq9FYKLoq7b4Trkv+UXLH0x+DzTWJ6VK/9GbDT+3oNdBKDxBwmovpUZ
	zF3vfGVZPjBTyMi7wILG3e6HOdChbKctujWrRbljNziHL5G1Cnzz0s9UQkjz1PKnSt/v
X-Gm-Gg: AYBFou2CVLbbHZrmoPvM0AITjJ8OveXEKS8JG7Pi0sjM55WCx/A5UI9k5vD1OJP6M7b
	j3BOD2r9vtrcAwoOYgAu6+mde+ibcf/69aRZkKox02rH8/wdQM4dpYjfHRfppRH10TSgPiOSojR
	MxcvaSIXoIHzRxrQDViFb7crp9kAwQWkeBECchtHomA7gFQRkOTe7XqDtcmU16tEncr+oGFGI8z
	15Dw+OrTfmfjrEf6ko/exD+LoGARiWrmB65hHiRXmUg6TbJS9qiKywYmL1Mx5WiWjIPbZ8vx+MH
	vs4T3oi35eoEfXV1zu1v1z3PzmwtQMY2eyKxCYRqp4cPMKnPJF7EnZFCRaAp74DC7QlOiYJX6mX
	jFNNFUOOFORhoQ1QcR5k3LT7j46m3neDeXygKK+gH4JMmTqrioByE+aWyeNeSnFaSDgIiofJT9Y
	QXKdRS9k+c8dQ8NeWOWXazyGh3qL8IOAU/2p957ljhmmnVY+knfFDB9CQaT4XLJfAfH4bJjv997
	HJ+2rYp84htWHeYa3gXKdj0UpqRBcDjl1Ufoilz9WpX44CkBM8D0nFy
X-Received: by 2002:a05:690e:d06:b0:678:4671:d9d1 with SMTP id 956f58d0204a3-679360087aamr34732d50.21.1791493083618;
        Thu, 08 Oct 2026 13:58:03 -0700 (PDT)
Received: from [192.168.1.110] (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67935707401sm78814d50.24.2026.10.08.13.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 13:58:03 -0700 (PDT)
From: Andrew Halaney <andrew@amutable.com>
Subject: [PATCH bpf-next v2 0/3] keys: Add well known IDs for
 fs-verity/dm-verity keys
Date: Thu, 08 Oct 2026 15:57:34 -0500
Message-Id: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WNQQ6CMBBFr0JmbU1bsIor72FYtHSQUSikrQ2Ec
 HcbbuDy5eX/t0FATxjgXmzgMVGgyWWQpwLaXrsXMrKZQXKpeC0qpt+9HrTDldkx5W1c2ScDWXS
 ROkLPKnG7GiXL0uAF8s/ssaPlaDzBzB1zuERosukpxMmvRzyJw//RSYJxxkUtpW1FqZR+6PEbt
 Rnw3E4jNPu+/wBcIMGP3wAAAA==
X-Change-ID: 20260914-ajhalaney-dmverity-key-identifier-4187b6233be5
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

This more or less follows the bpf keyring approach, allowing userspace
to easily find the keys instead of having to parse /proc/keys.

Signed-off-by: Andrew Halaney <andrew@amutable.com>
---
Changes in v2:
- Rebased / target bpf-next/for-next since 264d8fd2794f ("bpf, keys: Add a bpf
  keyring for program signature validation") only exists there.
- Grabbed Reviewed-by trailers.
- Link to v1: https://lore.kernel.org/r/20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com

---
Andrew Halaney (3):
      keys: add KEY_SPEC_DM_VERITY_KEYRING
      keys: add KEY_SPEC_FS_VERITY_KEYRING
      Documentation: keys: document IDs added since KEY_SPEC_REQKEY_AUTH_KEY

 Documentation/security/keys/core.rst | 13 ++++++++
 drivers/md/dm-verity-verify-sig.c    |  3 ++
 fs/verity/signature.c                |  2 ++
 include/linux/key.h                  |  2 ++
 include/uapi/linux/keyctl.h          |  2 ++
 security/keys/process_keys.c         | 58 ++++++++++++++++++++++++++++++++++++
 6 files changed, 80 insertions(+)
---
base-commit: e1d84a37cba984388988d2f1ddc84561413f0db2
change-id: 20260914-ajhalaney-dmverity-key-identifier-4187b6233be5

Best regards,
-- 
Andrew Halaney <andrew@amutable.com>

