Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999767;
	b=2S0grYt2zLzKRNWZju1293QUfTBXEUtqbb+PKuqeVaMsOGxa83kszZK9DfshDH2v14fZ
	 c8G0HlYDXOwbXSnHui/T+qc/ydWO2+Ff45ob28TPPRAiwwkVWZKD0v/waMR8GAnf0rVib
	 NfCCA+UmCpRdSa0xGibnh68iy9MAcn/RUEQizdk9VYt2HV8u+jCC7e3rD/qgdDN7PjhGa
	 LVqORIVX3OpxbJskMN+Xhchp5oIlz+VcVMxqjeWZmn51J1Fnu5itx4nac0NQmRIax5lH7
	 ueC6FHAdMC08A15+gOXgLEZPLECT+CYlmEgt3bSEAsc6Gbl+MgMTI1aChFsSinCX13g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999767;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aaVCz9shF8ZFyzO5/5N6GKpW3bexM2Ih05SHuYmSwNk=;
	b=jKha3okgGsKMSW6M0X8mlFe5eKhw7BqEqw3dTBiLe5zlQzw6xWnMv8cp7F9lVfZYjO55
	 eZSU0jMDDbQkI4P9gQyXXCbp8jm+1tj+i6mc3akfDURJpa9LDH/Sd7sW7+jJPtgu6wkGH
	 ir6+9v2GKwOyoyEbex6CZ5WahjeljQKYS+C5eybbiYxquA9bulxvAgvya0atHW6aQXbM/
	 37PpXqzCXFOj0tBtn/a5jBNEyYlUQNg87Ks9nSzqeMAjYT2+2v3BuooznvmP/hRL1XrEt
	 vXxS1Rejp+aLaXkJmysWi4Jq5b+EGMsGMqWMDESMY/YW1a89iX+pi+XUUrfS67O4cwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=ec+1kIez;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3DE606A33F
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 11:02:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B3DE606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=ec+1kIez
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4a357b1c649so444176f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 03:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1794999766; x=1795604566; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aaVCz9shF8ZFyzO5/5N6GKpW3bexM2Ih05SHuYmSwNk=;
        b=ec+1kIez2g8JMAOmdTtMvD8b8j7n33cegpzvFJQLOPqgosF7wucCF9j1kcxBsi4lXi
         kul/+1ythjpU2W55VNGGMidYTdLpKCN4YsPDzxrlV1+FdXs+BV4U/Hv95Sy48V2EliIl
         Nsh4HVKQW6dwoK9bClfaZBU+U9bT+gmRgls7THMXmEr+sBGJjNZUtreOHpVVxfH35a6F
         KaB9lI3Ighyukc7fLBOErRV9SiQ4Rae6I06rBSyS9FY9xPyXQQsjTchnE6+u2DaVgQR7
         i55Qs8ksl8IIBZOL9Bo3vX6GUTwAr5Iq/aHPhbq2/CqLWg4eRWiBRt7/9nTAuRZky2lP
         1WWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794999766; x=1795604566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aaVCz9shF8ZFyzO5/5N6GKpW3bexM2Ih05SHuYmSwNk=;
        b=2VWEabVyiqu4zlVatpYDq0l8PlPyAVnzAueTyw1EcTjgiUd20YdcdhZimLPFwEYQk4
         6DAaHyGtRCIJC4JTmOD+5akvY5KCR2NsAsQKVd+dbMQ5boVSokohIlq6raSUOkHbrY+I
         dK38PBezFDQ6fJOs1sQej6VDNl76BU1PNq+xKnk5w99hr9lo/bShLOekVfTcc54k7Sfq
         T58cr7ZiDLV8iaXQhslqGq2N7QwV6ZH/DQmNH7eqYYpaaWZokRcgAbzJ9lsUSmH3icrH
         xJRvhftyNtVWZxBepcRZBh2S1soyLD8r6Z38t7jMI23x/NJnxVlfSNSwzvAmBLA0Pl5e
         ZB1Q==
X-Forwarded-Encrypted: i=1; AL+hErGI64GBzlv20zvB+h3PSiuEH+6P5vvX3tm4QqejO1TPQMmS33pUprjUrBkdP7msJErO+gokTHVbag==@lists.linux.dev
X-Gm-Message-State: APuU4Z+QnJ8pS7Q5O4m9JX6Pmk7cXyNOJEm2Ds10XY8GEt4EF1L9zjhC
	lqOoJlhfP3KrALTWe8ygojHWHwkMseCwShNMvS/aicvC9IHQjZCnhXJnCofzXlCT9qU=
X-Gm-Gg: AZFdTZfAaRqGAgVk/2Lmn9dv1Et7WbnBBx3OnmtxzDAdCenwAGBbm6eCvwRvFEG0dCh
	/YUYKDpoP/t2bWZCrLn/dZq0Nz1x60B3az+TN/s9hxnWrFnzZcqXGRBujUX/Ky4NhtzVsMuayTs
	uoQ/otSLlwq/0K16eHOxQB6hifgzmjZ7tskshbq2F80mC70rlbHjCtvzNW3/9Rc0Z7UNr5rRFyE
	j6Es2X3vnC/onZPehbJqMOc1Tw5JgOT/NKZ+GMNJDz0Afsw/966tL186Q/m3dI6WEthIB8k5Pbz
	Qy5oXv+RJdnjF6vM4QHdcZE4XWn5mwgL+q850ZDorg97FDdlfGVd5f4PqDjjrtfJDqKY85bN8CD
	TpdB/7R8yyUiMmJIXk3US5zt+WI9MFU3/fu2XrYnR9/+Cb618vMhVXDPwGcEu1n5lI1g/u0brX8
	Xiuvb3XcI0zG1eEnZrxUnJ7hYnndNdcUJPhymMtgumzM452ay6eOXws458jId+MskeEOIzAw5oI
	77D3D0Uym/v4tF4Sl2jdoV0IvPMiw8tGX727++MIIdfhQF+PCVh0HY/ps0xnabPrgebwMhMzk5/
	CVVUyOD2HH8TsW/+9V1+mLXCkqM=
X-Received: by 2002:a05:6000:40ce:b0:4a4:6669:7f9 with SMTP id ffacd0b85a97d-4a63cd0f053mr5455559f8f.49.1794999765938;
        Wed, 18 Nov 2026 03:02:45 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8c09:3cc3:6efa:ac1f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c1145esm3943277f8f.52.2026.11.18.03.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:02:45 -0800 (PST)
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
Subject: [PATCH 3/3] dm era: construct the target suspended
Date: Wed, 18 Nov 2026 12:02:39 +0100
Message-ID: <20261118110239.2910290-4-den@openvz.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261118110239.2910290-1-den@openvz.org>
References: <20261118110239.2910290-1-den@openvz.org>
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

From: Denis V. Lunev <den@openvz.org>

era_preresume() resizes the era array and commits the metadata in the
thread that resumes the device, and starts the worker only once that is
done. That is safe only while the worker cannot run, and nothing makes
it so: struct era is zeroed, so era->suspended reads as running from
the moment the target is constructed, and an rpc arriving before the
resume wakes the worker alongside the resize. Both allocate from the
same space map and take the same metadata block, which corrupts it:

 device-mapper: block manager: validator mismatch (old=array vs new=index)
 device-mapper: space map common: unable to decrement block
 device-mapper: era: metadata_commit: pre commit failed

Every commit after that fails the same way, the target reports "era
Error", and the writes it tracks fail, which takes the workload's
filesystem read-only.

Userspace gets there without trying. multipathd asks every
device-mapper target appearing on the node for its status, over its own
uevent socket, to learn whether the target is a multipath map, so a
target is asked exactly while it resumes.

Mark the target suspended when it is constructed, which is the state
start_worker() already assumes it is leaving. The resize and the commit
then run with the worker held back, as they must, and a status query in
that window is refused rather than served beside them.

Fixes: cca2c6aebe86 ("dm era: only resize metadata in preresume")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/md/dm-era-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 29b0602e7849..d40a98169b04 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1557,6 +1557,7 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	spin_lock_init(&era->rpc_lock);
 	INIT_LIST_HEAD(&era->rpc_calls);
+	atomic_set(&era->suspended, 1);
 
 	ti->private = era;
 	ti->num_flush_bios = 1;
-- 
2.55.0

