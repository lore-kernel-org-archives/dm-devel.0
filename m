Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2B220403B
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423771; cv=none; b=dRFTvNd1ApwLFZRdiX5YXQjBkrNkKtjStG5b6tqJZOo5leZBMyjha6pChF0bbICBoa50oF5cBgHyLUF7CpNOJHDfXAy+suReraP1SFuJRWK2TNq/EI8tBeLrRyrVBPV6fftGEtqj4xgMbPHPngQIXha7u9tNLrne8FaJeeh1W2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423771; c=relaxed/simple;
	bh=pUBw9dJdIcOMGAyKnfBAIFglZUQ7IfyIo4FYXvu9d14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRshA0MxW4thFfr7p+4yhXezYAenrAdkTmJRHiaNVOq87b/ZKs6LZUY+0e504+tMAcPV3LF6AOu6/E+fVFVvBX7FHwP5KSZxHlJU5n+0M++LtLBS2iV0s9CZIxiXXuHem65XLB7I7TKdPZagVYIiBtCflhHI6lVYrurgLKkqNOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Oux4IFnK; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Oux4IFnK"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4315c1c7392so51210755e9.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423768; x=1732028568; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjNB+oiHmZFHR0jfD4d+nOio5EngsbpfyK41dRdJzmU=;
        b=Oux4IFnKlzErb7RDccBVJ4fVXZsM3xDfoWySP6Yd+80vFaBkiZj5AIG+bvR9eIXbYi
         n8LD5XNli+LfCCzQl/rNXbhJsrPCCZNGo/PKZzBdvyOjiVRrq2AsCVY9MiveZCkArYRb
         Es9fC9Jynu9Gtm8w3WZQhHJ75tiTnt+aplDQPPNSgFqWoyADAI22xxNL0L9z1ov2y5fz
         sPJMtkN9oF86pDMidGkyjq0ucLWefSt1n1W3T1wzH5wIWqSMkTZZc3rMJTgqPt2KHofF
         M/f/WwqGscBZLMBvzzvMC0khhdTeT+W96SNhgGA9n67pc7kUXwKemC3QyBLvy2TUZjEI
         m4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423768; x=1732028568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjNB+oiHmZFHR0jfD4d+nOio5EngsbpfyK41dRdJzmU=;
        b=DDY6uC6pwbG8RsF5p72ZXuBZ8NHa0uT1AIM3uV9tIvEwuhLhWfzdMT8Ay835tgHBpW
         T8Tzoa/R6cF92cs5dBvKwiW5KeCx+Q1cUxDAcJZkuAtN5+WM20rPPe3WSGvSFPuoJNff
         KKP7u3osZHWdIr4cfoD862k9/NGFpGJDBrjzsvx+hQ07vx/dM9c0fqg+Sggs4ijAaHza
         dPJ8vbpG60/QkqInPBVIyaGC1RZGD9oSF5A6srHhPeVwTy3RJxzqfL5KD7Gr+DDUZIel
         RymlDt6xbpZG6OEtuUIWEahqzP0eQf0nz/8B8ZakwrNrFX8sxC4Mk054vLq0943oRzV+
         QAlQ==
X-Gm-Message-State: AOJu0YxeVOzhOAJlND6k8RuTCaE4VR7mU/VSTkMlfZDTz0GKKOxBz7Eh
	90pg0cN4ftqjsXkj8Nk1NMG5ceaKpYyYd6/S+pnXJ77xjE9Jizh28uHuslK7n3s=
X-Google-Smtp-Source: AGHT+IGYS7eW7ZGOvqLISSVAqN5wvsNEQZd5jxzPL6zRxKFbfR+Y2ROYFY6+HSpjJj9vP9ai0oLnOg==
X-Received: by 2002:a05:600c:3b05:b0:431:537d:b3b4 with SMTP id 5b1f17b1804b1-432b7503540mr135966215e9.11.1731423765685;
        Tue, 12 Nov 2024 07:02:45 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432b053069fsm216752965e9.4.2024.11.12.07.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:45 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/12] libmultipath: don't log boring state messages at level 3
Date: Tue, 12 Nov 2024 16:02:14 +0100
Message-ID: <20241112150215.90182-12-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Even at verbosity level 3, it isn't interesting and actually disturbing
to see every successful state and pending state logged by multipathd.
Suppress these messages at level 3.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 11 ++++++++---
 libmultipath/structs.h   |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1d48c30..ae9fc8f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2018,15 +2018,20 @@ int
 get_state (struct path * pp)
 {
 	struct checker * c = &pp->checker;
-	int state;
+	int state, lvl;
 
 	state = checker_get_state(c);
-	condlog(3, "%s: %s state = %s", pp->dev,
+
+	lvl = state == pp->oldstate || state == PATH_PENDING ? 4 : 3;
+	condlog(lvl, "%s: %s state = %s", pp->dev,
 		checker_name(c), checker_state_name(state));
 	if (state != PATH_UP && state != PATH_GHOST &&
 	    strlen(checker_message(c)))
-		condlog(3, "%s: %s checker%s",
+		condlog(lvl, "%s: %s checker%s",
 			pp->dev, checker_name(c), checker_message(c));
+	if (state != PATH_PENDING)
+		pp->oldstate = state;
+
 	return state;
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 1f531d3..4821f19 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -375,6 +375,7 @@ struct path {
 	int state;
 	int dmstate;
 	int chkrstate;
+	int oldstate;
 	int failcount;
 	int priority;
 	int pgindex;
-- 
2.47.0

