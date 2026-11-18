Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999765;
	b=JfVAIShJDv45unQn6IlniUe9DCN998/Y/z8WtdB+4SGj3/hyp4/sRln+0CjkKAPVm6Lw
	 75loNr6rG1UcEhGanqSiNxZMsQnqDTYpYbe2k4FqcLSGEcS/LglRd6mt2S4j4xxf9bGfU
	 u2YnIZcGTb7iQhiNgqAGuvmshWy8TNXthZdYIMVqO/NyZ3X44eGBvrC9/axrmfk/VQJiw
	 4a+FbAm1ZQ6kWEryI1Ol9PDkJ7iLAchjPKvNo5966tgGl5VjQIPNb4rJYk6SIDw543jVk
	 eomjwok+wZq+XdQ8m6tVLe1m4nZhhRPZXbYAMWv3CrVXUC34AVCmruF7mgyzyzzwaNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999765;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TNUJcoivapsKBW3NAQfMVs0W9NiOWzC1TnMHNTq8Zc0=;
	b=ATUQFx0qnRNXxD3uZBFNZA9oNBbjt4vPVX1aJZl7tKYNO0bJ+WFX2ou9zNUqnHqWQXz+
	 Ux/WQ3zLtUhXom3yj1YaXOBF6XKMtr2Z1YCdRpY/jCnUOla6egg972jz69l645TNj6Vdk
	 zuxoelJtS3rHJ5Y8nF1swBCzWCX0jANVfkNVOBBQ4E9czSjUt6tlXTdawj00o98g98OpW
	 UsgsLYYxVvKkxGaZmIZG2ivmcwWoEQILrtRbM+mDS3sqvGYlcUzpM6lWvfkILsrqjTecz
	 CYAzhj4HbKMk9FPuJGZDFyGfo2q0lmh2PO240Yyit16+he2lyZ6kYDWROm62gbjyyCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=ADU8rGH+;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A9606A33D
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 11:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 656A9606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=ADU8rGH+
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so664131f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 03:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1794999763; x=1795604563; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TNUJcoivapsKBW3NAQfMVs0W9NiOWzC1TnMHNTq8Zc0=;
        b=ADU8rGH+szuXS4zlYgzDnIpBKsUUSw/1SwwLONpa6MeNiqSi+AtNf2tXsZnCNE1plK
         lDOsIQR/4qsZVPvSPRRXWOH5+K9RzPetqjIDU8Xcf61sUpszFIQK/i8+iB11OtafD82H
         WOMLK5eA0FB0vz6QlXM/uAmXi38p5eDOPpkymxBhLACrZwZoI5l4JkPnxD3Hp8mOg7DI
         2H63fMYaEBesC2I+rWDSwEUmuBgdSPzKp3IucbW+dBjQW40q7u6CfaggIqPYIYRC2Fmz
         Jvjl3ReImaTI0I2+bCUNkJtGIpybysfWAG7Yz3nSeIHVWKrmJxHVUwf6vZ27LNKCN+ZC
         NVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794999763; x=1795604563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TNUJcoivapsKBW3NAQfMVs0W9NiOWzC1TnMHNTq8Zc0=;
        b=CWUsa60CMcc1+6/mbpufSqxu48ShBLOTPKak8+lrnPU405AXBbQKiEEcR0omKnADsn
         Sd82Q3r1BG0cecgOTN5VcjJuVsgcosa8rDJe4dfggCCvUmR1438BetSpa6xUff6NSTNv
         nbzu5tDu67T0HMVg3WePkqOwhcGFMX6635tGN3cwuAIqPQVhsYa2OmH4JfSqTFpzqD4u
         bZ1WZ1zBLGlQz8sUOpFS2Ytd1FRCS13MXjxMoqPCoNJcx78RDfgfRCvG6sbnhWY8fQof
         AmFly+2qtF0p3m26yx72V2+f/Ub3fLgqTPZUhy0/nPnlFsfsswF8/R8+pID4ITd5deZX
         ZsIg==
X-Forwarded-Encrypted: i=1; AL+hErF4PI4thXJbedEI6JFfcV3Ok2zpTLhCNF1rkCjUngwYHJBkVRrOhNaiMe6um3rtR7enYrFlDoPtkA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/w8/j91wwhGYBpJMBQTCQ70nSObZ033OCKGH+ErlVdPMq7leTm
	oj9MdOZd4PyVRFOlP6XOP1c86RzROhPC7RYYDGPOcgcYfPPVldgjtjx+35re6nknHrc=
X-Gm-Gg: AZFdTZejPPiBZDL0HPJQnnRJ5WNTBu+dwgWxOKQ391Ux9thbXORuF34hpkrXchQr0Ep
	AFx8SMMacmpyzAlE6dSWFqFa5w5Bti6bNhEnWO7tjOKD8jMQv/JENXoTyQd6faFIxfCuE7UBSBf
	GONLIpHuCEjavN967mtjS5IduP2jiIBP5+QRgvFD9XI05xitx08l7/Zn3zPmNwqpABJNFcEPV8l
	zC+oLbL8m5oA0eQwFP7r1tn+aViR6oCCmsvoMtHE7sUrFzU+dvtPmfcRHjoqpzZwdpmQAGDWfGp
	rIKZkRg7WLnMp8iZWPdnPuHxTngOW94G8BOXTTQs0OtQzUP546e45yFX8PwE3LlB76yTI3IVvKj
	UuTDc/74BaQMDAiUYz9xdVL2XPlomvB3PmKtMo+kl/l/iE/dgwWS4sircCvj4HduerfWFWlISw2
	PUWD3w5Jl7pUihOsjZ7BanVHIZ1FYEFE8YTCUHXuUO9v9FHv6NyDhcebo8y0NtOGmp2YJ7yXwRl
	QsFl24JYK2t66DMIiBJZamGTsR3YspMvOefCll04WISkb/99UkUuaVAfG7ELxQ1WvQlTgyItqKY
	1S3F3M5vPmy4QckXWVWN1tBaLbob
X-Received: by 2002:a05:6000:29ca:b0:493:2eb8:e7d2 with SMTP id ffacd0b85a97d-4a63a98b0d3mr3226899f8f.41.1794999762580;
        Wed, 18 Nov 2026 03:02:42 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8c09:3cc3:6efa:ac1f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c1145esm3943277f8f.52.2026.11.18.03.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:02:42 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	thornber@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	den@openvz.org
Subject: [PATCH 0/3] dm era: a metadata device that never comes back
Date: Wed, 18 Nov 2026 12:02:36 +0100
Message-ID: <20261118110239.2910290-1-den@openvz.org>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We move running containers between machines without restarting them,
and their block volumes travel with them, so dm-era tells us which
blocks changed between copy passes.

About one move in three ended with the volume dead rather than moved:
the metadata broke, every commit after it failed, the target reported
"era Error", and the writes it tracked began to fail, which takes the
workload's filesystem read-only. Rebuilding the device recovers the
tracking, not the filesystem.

Three unrelated causes, all of which the kernel log blames on the
space map, which is the victim. Two need no bad luck: multipathd asks
every target that appears for its status, so one is asked exactly
while it resumes, and again while it suspends. The third is older and
wider - a transient read failure in the persistent-data library leaves
the space map short, and the next commit makes that permanent. dm-thin
and dm-cache reach it too, where it costs a transaction rather than
the device, because they can abort and dm-era cannot.

Each patch is reproduced on a kernel whose only modification is the
fix under test. Patch 3 must not be backported before patch 2, nor
before cca2c6aebe86, where the resize goes through the worker the two
would refuse.

Denis V. Lunev (3):
  dm persistent data: drop the original block only once it is copied
  dm era: refuse metadata rpcs once the target is suspended
  dm era: construct the target suspended

 drivers/md/dm-era-target.c                          | 10 +++++++++-
 drivers/md/persistent-data/dm-transaction-manager.c | 13 ++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.55.0

