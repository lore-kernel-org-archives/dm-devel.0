Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C6748D873
	for <dm-devel@lists.linux.dev>; Mon, 14 Sep 2026 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404126; cv=none; b=uoALp5yq10TqkbQNE6D+9MBW4OyqasR1Qe0LjYeBNbmg90ns4ibWFPteofRNXY7s+04Xh2mdH7f091evtEssXH+kmRLG6NVXleOzhRAcaRJ6HgYmiSZ3XDeL2p5UuTub71GNcb66oiFj2cdq2mYFPbby6+Z+Jd4HaGoCTbnEuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404126; c=relaxed/simple;
	bh=H1l4m7LqRJnZ49EJ8tR396A7/0u8ejG0VymqYOqgnNY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kypA3ii7DGkVUXMOXVmFwH0ZjyHE9TgykoJpOrgYQcUDFCxBAH+b3B7zGYg6Y7bsvMGi/ulmjFfblWISwCvbeooKmvQXi+EMjvTEVfAh+p/GUFI0v6R0MSsHdzBDFylBq5ZvXWgclxZEDJv1c3dYup+ODUSpL1HZoVKpv4xycBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=Ks8yhw0G; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="Ks8yhw0G"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43daa8f4so18213727b3.3
        for <dm-devel@lists.linux.dev>; Mon, 14 Sep 2026 09:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1789404122; x=1790008922; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OKDUxsVBgyG13X1UZt4eR7O3fTMlydeoVTGRT2zzuL8=;
        b=Ks8yhw0Gj69jiXAqQmf6hIFwFxORAFJaOcR0d1tP5jJF+O1WGihxlsRuFcmKR6/mV+
         bW+k9sp5vWpVlYufLNDOz1d3sfkU6kI4FTNRmLYPXERIj/OAZbDkNFzn2/V80fRoLE27
         DqOzeZnLOk7w13+VyWon46b176/nD9z2dtdp0441GSnAFeKRghfcGN8LQBDsmeYlyQkg
         VRFpB4uTN29tcupqnnUD2KAR/IczBjuh73sPrXGmZdT4XVaT9xW5nt5ic1tG8aIY3Ppk
         XL64+BqXaTI4w+h6056bdMjl36u0HWA7hZd0J6/Fd8YZFrphKwUlsRHdMeWCwC7OGXBk
         lDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789404122; x=1790008922;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OKDUxsVBgyG13X1UZt4eR7O3fTMlydeoVTGRT2zzuL8=;
        b=nHXKhvqVpMS5Kxia88zaSS1YaKYsbXoMgizm+gfMfyNZnyktOEErodt7Dv3aKRBXDw
         Z+3cJaIWZ6yh4YR4uNDEEizrYvd0Iasc56urhrOi2F8eiYlpYRUd3VT+fOf36Wjs4JTY
         Hic0S+1KEnfDhCZgI5WwAi/nRiD5/eCQNy5Dn8xZubLRcip69oIn+W5wtBu8Wz/8ZsDy
         4WJm7yVHIpaAOzyeelJhp+1JeR89rXpt7tLOTGeqov3eO7/aKBFwe1IjHi0TGlglZwrQ
         BNXA3bzD2GPFmoKx0Dv2DezMECyaJFrxqxbP7q/hOQNdYAkZQO1AoSsPZ01dhg3NpP65
         e5wQ==
X-Gm-Message-State: AFuF++loaTl+7tt/SaYP4hXjYrQQcVWlfmIKTQNlsiAJkIzSRy+oVmxx
	MoIYN4FP9dUCvomHAwBTVgfTLsG67zaj/mtfoX50iXPk6VcBwrelejCGgqu4uNBs+WnV
X-Gm-Gg: AYBFou1ZfoghM6uU76dtGn2krXaUWLXKKAV9AfLuS1CpGZPV9WkMsG06IGOVFlCBsEr
	w9pzWUlz8Q5Kdy5flKJwX2VpLoAs98hD2cRxyD7pFCjrET02yKtUAFUhgfoVIS73CkRc3zBq+L8
	5zV5Gl+duT5yj+BYPqMhs7Qk/2Js5UAAPcIrPKO/ZuvPQ2VkGPT0c6l5Ino8tn8xkeQo+bBvH1n
	AQj0q6E2q583hssFu+asqIVzj/HWWmrUIEp8i2dcFZb6/p3NXfTMVGfXtl4W8Low8bVYNKM8ckH
	BmOb82eW/R53nv2FB0nOteRYEXORBtl8TBxCppOoMaRb2/dAZJe5C91J74HO1gue50tjRYQvSYt
	6KBtEodezRrjIUrgd2fxhbeCkSg5LE5PQQuKIPX1eBx9XQQLyNT1pH9vRzHp3zfdRAzDAK3VVv4
	W3Yf4Q4w1mZ8Su7iBOMdAbsfGpTHwvJFBE1BIk364dx3CqyWHWiqHzQU0yAbhN
X-Received: by 2002:a05:690e:12c8:b0:66d:132a:875f with SMTP id 956f58d0204a3-6714e088222mr1068042d50.47.1789404120256;
        Mon, 14 Sep 2026 09:42:00 -0700 (PDT)
Received: from [192.168.1.110] ([2600:1700:1ff0:d0ef::d15])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67125df42a8sm4879023d50.8.2026.09.14.09.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 09:41:59 -0700 (PDT)
From: Andrew Halaney <andrew@amutable.com>
Subject: [PATCH 0/3] keys: Add well known IDs for fs-verity/dm-verity keys
Date: Mon, 14 Sep 2026 11:41:41 -0500
Message-Id: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3NSQ6DMBBE0augXqclbIYMV0EsTFyEzmCQjRAIc
 fe0WL7Fr9opIQoSPbKdIhZJMgaFuWT0HFx4gcWryea2zu+mZPce3NcFbOx/i7bzxh+FeIRZekH
 k0tyuXW2LokNFujNF9LKeH017HH+y3YXWcwAAAA==
X-Change-ID: 20260914-ajhalaney-dmverity-key-identifier-4187b6233be5
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
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
base-commit: 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3
change-id: 20260914-ajhalaney-dmverity-key-identifier-4187b6233be5

Best regards,
-- 
Andrew Halaney <andrew@amutable.com>

