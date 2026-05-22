Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3099A4779B0
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468284; cv=none; b=Wr4hwfNOBIuLsyjsJWlKbaRSfverwJ7aa1XjQOlPbe2sIqQCwqWscx9afoqTL6h7ndv3iaIIdHuAn+4p34gyINJs3ReDfMw4FKG9/BHJibhSvrxp04lZW2WRvBCdgysHU0upL+gk6/QWTR/DEzjg0eT5vqRnQ5MPykb/WY2Xqy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468284; c=relaxed/simple;
	bh=5676EvXfSCQ/ALhd7z1F9jhGhMTxi3RGF99qx4Ikvfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLHtrmPvLTVGlVobDrD6ELuZOu60rq0x7aRntM/c7QY6hh4031XHNwdj2P7nMQaGFrXc6pwrpGrmWnmgn77Q6Kwm30kAym3IyxCRBMGcONJsHkZX4kxKoJFCcJudz9Y93SJARIQWSdLxhcbf/x378MeLu9baRBU2ArYBRzCViBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VBZamHJ0; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VBZamHJ0"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49048e043e5so4147085e9.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468280; x=1780073080; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJNKGc6pMtucdlUZ8vOfhBN75A3wyRFUCBEKzsHn5qU=;
        b=VBZamHJ0GYJD/ApY7LiFtjiB072aEfzHfikiRMqfchkeRrJDy3aeyOHXQypBmuI3KJ
         e0UHm+GZimtZL9S4nWnbNleVy4OHvKARnpc5TsaN82JQnafN00FgHcbgpAgZt4x6fx4P
         QJoNItmA1HuTQqkw4v2KZo2oNWsbwG97mtN9/uQp+uxFEtC4s/FYvtr58UYRq7SrED1U
         lJ1ZsmVJuC/VBczYJ9A6GkGiZuNOKRnurILS9DfQW/vmwvGUmr3aqOrjvLXBxqZA3/e2
         r9eTfkXLb8TtIp97im1dN8z/iLjOizQuqcVj4/C3ulEgQYud7O4KB4+uPlAFbwN5483/
         WzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468280; x=1780073080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJNKGc6pMtucdlUZ8vOfhBN75A3wyRFUCBEKzsHn5qU=;
        b=YYKyHgNJru0WfydGcR4hfFquAzGge5GfWOg88HMOBF9DZ9j73rxsAHU0RsbvcBEd8G
         aeSUX4BAZMkZBzlYG7aPpHmq7WDFsQ/4vbfH5e42kEe2i910hlETE2o89PyJLm8Esh/J
         o/+7BCOYzTkx5EP/oKp5f43bDXUyY5H7vlfq45cw9rZSiaYfLYNyumFXblBuwKz85M2q
         8J5jgPvo0hrReXLmT4l8qhyoM30Ll1pvpzyTZqrsNvyUJeaMVvfF7eaULEQvlTgbd25M
         gll6JDzy7KDOOgd6/q2tYDYxZ4Dv5e4Hz9AGOfxhj7QalmxSsfDd2OmMLuPYuCGS9Ij/
         yq6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/+5x2g/t+wg5OEoqTO3NZfmsozko2zwjKvtfV6KJbi/me6O/x4CMvqVuR7ecO72giC/9X5tdDyvA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yznwblcz0CFft7m0zolx1QCvPVuhwOBIEIiLKstnnSEs0ahMwFO
	mGd13xIXDSUZtFHusnqKKIJ6nvf2hgI/YrzCxiSFPZlca5d/KECrSAGht60igXdyms8=
X-Gm-Gg: Acq92OFk7b4sN6rbkZeDIJShJQ1ZrXX+iZu91s5N4OQAnqIYdBJy2xnxQ+lEkm4jY3V
	LStAe5dCsGAar0HHZ2cjccUvf0tnV1/Jfhpe4xLQlN715n6rzm6R2XWDRi8j9xPCYEQ9BGxfgww
	FaYB5OwBK6kyghtnE0hLh4PQzHEh/uyasQpmjs9OGHH3cFxn6Ay9M+OVwOgE+ZTkFU6Ti/qOJe3
	Mng5juWRnlT+64lbjU4+wp/qNUv4cO942uX78ktA7gmKOcw0UBJOBfQnQx3DFxSSjha5NXdNzbj
	z5w5PtfASIeQj/bPP145jSGhl8xlRU2eCjQez+hTHye+KJgQOZqgJN6ivtQXaw9R/YjfAKMajUB
	1+SyzrlpSnAHHMpgTGzAlXbQuEMLoTjYHoToAaSK2SN1aFkgAgX0kuVFoZd9Wyby/AytuFUZI+E
	44O6A4MHVodXzaAFkFXpjY5VMnxBNw0vJCBVWtO+3npAok8BNXS3vxZnpNN9tLq9e+9rTY1aFv+
	OvC6lvkPTGusw==
X-Received: by 2002:a05:600c:a402:b0:48a:5546:61a1 with SMTP id 5b1f17b1804b1-490426b4da5mr51366755e9.15.1779468280090;
        Fri, 22 May 2026 09:44:40 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904561a160sm63918255e9.9.2026.05.22.09.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:39 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/19] libmpathutil: runner: reduce a message loglevel
Date: Fri, 22 May 2026 18:43:57 +0200
Message-ID: <20260522164415.846589-2-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't "log runner 0x7b724a07a480 cancelled in state 'done'" at
level 3. It's a fairly normal thing to happen.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/runner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
index da57ff0..8c6d6b9 100644
--- a/libmpathutil/runner.c
+++ b/libmpathutil/runner.c
@@ -134,7 +134,7 @@ repeat:
 		break;
 	case RUNNER_DONE:
 		st_new = RUNNER_DEAD;
-		/* fallthrough */
+		break;
 	case RUNNER_DEAD:
 		level = 3;
 		break;
-- 
2.54.0

