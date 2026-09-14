Received: from mail-yx2-f3.google.com (mail-yx2-f3.google.com [74.125.224.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2758448F83E
	for <dm-devel@lists.linux.dev>; Mon, 14 Sep 2026 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404130; cv=none; b=sklrrnCK4MWq7Xd/Mo6yyeD8ZokifLI88M6/8hHj8yPU2SMDZQcDHC0rWUCYCusbc0BBgsbs6ptCkINyQMuxEBwLdBiI1vLfSeA+yswLvtdIMq/w3+BESja4A3vgigsO89P8K0vGp0Etkr/AIO1CQfuXoG/czlzVvgmsWKwTCIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404130; c=relaxed/simple;
	bh=fyPrl3WvozGTDDVsDO8MGVfKnhRCs2T8g6qKeea9uQc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P9b5zU4Uyu52yNwoY37zRXxi5qNU1WRAm+HqA9H/vnK05BqX8FZ/eYfNlNZCPo0X7ZprS3Ny0qX0i6aWeGVX8ldlgu64i/JZ9Szkrj7RXbP2ygwGj72pXbuD3z/wMW1iLZVTxD9OteuSGb3rvcL0rJLOcCAWEz4HcvKafb+TGdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=CSSPmmwt; arc=none smtp.client-ip=74.125.224.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="CSSPmmwt"
Received: by mail-yx2-f3.google.com with SMTP id 956f58d0204a3-66fd0af9eb0so1249828d50.0
        for <dm-devel@lists.linux.dev>; Mon, 14 Sep 2026 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1789404124; x=1790008924; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ndMM0TFrryHnZOvHnxhOWJr9tGmJVwIhyX6o7UKbX40=;
        b=CSSPmmwtLsnpkMnVxOZj+Pnww/BHr6wkwiuljzDnwkhxYZyJPXfmA4O61tLBrI1aoi
         0cETUolZVfBwBYj737oRNpxJYiGWy8CUup6UWp1VgQxYXaJu3fDGsaM61OWFdTphVR1j
         eTczYLf8uoOVkiy1KiBMheqNVVpQtzFrqlBpH4zWVWlU7kzSX68l9FWFHELF63/RgYzP
         2dPXGvQbYekD46WROVeBUYlKzNMdNRO7L4ecaba1epuStd+S6lcJE/FoFh4hcTkq7tct
         yw6pUkfPQlfzJla4y1XP30GaHTNOSBqR603bAY2pW7lKzNo2G1DUXt7bg21DDER0U6BN
         2O0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789404124; x=1790008924;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ndMM0TFrryHnZOvHnxhOWJr9tGmJVwIhyX6o7UKbX40=;
        b=jP++yK5W3aFZak6h3QfydWXnqEtmxnw2LOkBlt1eueGvGtgZzZ6rRx/zsQC0JeWQFk
         aDfLMPQsPqFLv9WaZjYhPbPHsqVdkilPYRKNR+gmOUxlzS+hJew2KfqjGMI/tpdJacRN
         jZ0ownrQ3GIyU2jfbQL9cjd4zMAGIYZDr+WQpV5c1lroga93bfizL4xvsKTm4mTjLL2G
         DqrYLSUWi5gBIKovTCMDrmiSBNcgfw1cB0KEUiy02IfHmmtmEZRaoZQvzhc9SpIM/FFZ
         L2GkGC9Ebb9sqhO+uNHweoFOzNgbHfHXLDP+uadc/qr+54wEeHepo1CDtU3Zw7E9sNjj
         NXTg==
X-Gm-Message-State: AFuF++nXMubFj4ryLEqjmK0OIdtsamv3WYPV00vuA+QhdEHac8/Jm7EN
	ZJJUWBebs5porGFJCvr64S2TZZ00CQG922YvIGxAFEQmhZMtaDOJIyneUtVC69Vdglix
X-Gm-Gg: AYBFou34Mc/gZupDd1z25p87DKAAosF+xR/8vVdwVvj44x17K6ODmANKBeZ0RFQ1I96
	pJNtFkEkA7e7PzHVTjyKQAdmQRFHiGs6FIdx9Nd5UORAIsT4FVFr2uHMtirQH0iobfqit4XlC/e
	rFpVYo6XgyghriQ/5vQJZ2Ef7RUT4nq80YcDgINw3YpkjhlIF2+EcDuFpVSklMaxe8rkeC4NV4V
	+HMD/G83i+wL1PT/zGvQOjAGRxJRPoL6VP20LpipfUGSR8EUMhigDd7FfZ8oHnSOukq6EpGTo1q
	NrbkSufdXHdC8/S+g/wXIzjzXQY2KMKotxnFKWCSKEc04V+2SUfmCGF9fbRx9NAtTs8MwBzzTXt
	/mN6kBU2+prwJP/ID029j14P7oks9SnxBD6Jrx8V0LHjbFBLw7CxHV/Vg69J9qL9CnGACdHZMXi
	4GT01wYARqINmZatNQTosFKbpoaKPGGU0pOFvU8325hFFyeowIBIL38qc/5bs1
X-Received: by 2002:a05:690e:810:20b0:671:4a9e:7c91 with SMTP id 956f58d0204a3-6714dfd252cmr743318d50.10.1789404124390;
        Mon, 14 Sep 2026 09:42:04 -0700 (PDT)
Received: from [192.168.1.110] ([2600:1700:1ff0:d0ef::d15])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67125df42a8sm4879023d50.8.2026.09.14.09.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 09:42:04 -0700 (PDT)
From: Andrew Halaney <andrew@amutable.com>
Date: Mon, 14 Sep 2026 11:41:44 -0500
Subject: [PATCH 3/3] Documentation: keys: document IDs added since
 KEY_SPEC_REQKEY_AUTH_KEY
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-ajhalaney-dmverity-key-identifier-v1-3-01922dc1366a@amutable.com>
References: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
In-Reply-To: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
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

The table of special key IDs stops at KEY_SPEC_REQKEY_AUTH_KEY.
Fill in all the new ones.

Suggested-by: Christian Brauner (Amutable) <brauner@kernel.org>
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

