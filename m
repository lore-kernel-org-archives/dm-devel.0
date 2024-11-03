Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC92FC2FB
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 22:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673845; cv=none; b=dfnzqxiYzWGhJWNdiBVjSp5oFWAQjBycNH/ut6kjHkvDSZQKieqo48vrQlMMqc6csjss8y/iNITzfINH6lWYQWGVjJUXq3UOZm/aAsfPMK1pHn1A0PQoLo6g6WTuLlVdl6/WnI+gFwRcOY611DDrwU1sPlVqgf9ytYM8Ial3sg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673845; c=relaxed/simple;
	bh=U2/W427d8Iuo75nyj3mLkSMkFE9hi9eCdp+2hXukr+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nAXlWDg+hfPf9HRGoiDPlDEPasIbBc0DGItxg8gLeGtl7w2OoxBJKB+xBTUFs+Gugnv6y/2gsKQqOp+HKzHdz9Zw61ylxWy0f8zcDuwQZhGjiNqUF7DgOoJV8TZgaqKQRCqeDfM/7lc/PGrStkdbWJQHR/8OHlEeudl2gRUpOW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JUeJEowL; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JUeJEowL"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a99f1fd20c4so475914166b.0
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 14:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730673841; x=1731278641; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P9do++KC2pNiKW1gZTG8xpeINPg3LnOk18WHaxMZMBI=;
        b=JUeJEowL+UHfQeFgOX8gBucWDSt152vVRztfAH9EiYcXmMe9SBnhhwUpwJLQkrPIRf
         ZCCVqGlOaAVnQd/a7JwBJQtSyqWzw7RbcTplwBOaESnnJTuiY6RVVP6CPlh7Hhr4gyMM
         IOdxdvKSZ59uT13ZMxrBYhY0yDRAj9m6lKcnTeKlpBzMeIzTkfueQuHluzNL4z36IioX
         rkShFe7PjC6NPZKl3jIgQyN3oztbp0jvipow1ZSU/UNNw3TDA23D5u0h4fzhSiqHAZny
         C9/O+4C8QXrlTtPRi0bnpXmePFU0JlZUrVtMdjEvwju6rkwQB8hXhFZHiPmfCbX1JpAB
         1Y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673841; x=1731278641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9do++KC2pNiKW1gZTG8xpeINPg3LnOk18WHaxMZMBI=;
        b=JzFYdXUvsrD+dXP+1MEwFjOR+PX+ZQtGFAeYERF4Jdmcbt0C31sJYfdbf/NvTdRz1r
         35lm1IjbXsY3MwRp9ZXICnVcqeOURAaa3dnPr//ygiiclnDwDSBAu8wZyJsNwzHKHJho
         H3TqA+w/h3MD4hevVQg4+hEq3BbWW4Oq1jTAKy9T/OfcmSHcZS0SN9UrFg+sBtprqNQh
         ZwlGWQRVFt6KWQQFRGs2epRkhdd8FVE1xvX7B+iz0GaoQrKGjR0kaTc8CYTn5op0xsJw
         GHUG8GpSOYAorHlEmo7cODOE3jBi97cqBgBkt9fk4pWlx+/wt+OZ96/5FKD/zp3SKPBb
         91Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUsocrTR8avLQ3AUaNo2B3n/eBnbf8uWsfjbYBrOpWwltdPai2xSHYgZ/zh+nVhkCpJPGQbKtOUXw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzcuG/Li9X8p0sJkL8u9wLnKMbD/9Tj6iMMk5pfNAOdQLQ2Mm0O
	zCQZfxg7CbbsRs6mXRN1mRBHoUuhoTwPlSBT8qwPcOAC910iCzmz4BMsd4rJObY=
X-Google-Smtp-Source: AGHT+IGAWSmioGI8uhNUsvdNDOB/qM1FIldZLI/v4FKVNvyHJn6H2RJGY3wHHdSuSJ92FTPP2Gvmxg==
X-Received: by 2002:a17:907:728f:b0:a9a:1792:f1a with SMTP id a640c23a62f3a-a9e5089a3b2mr1401730666b.7.1730673840808;
        Sun, 03 Nov 2024 14:44:00 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9e565e09d2sm473028266b.128.2024.11.03.14.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:44:00 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 0/5] multipath-tools: udev rule fixes
Date: Sun,  3 Nov 2024 23:43:44 +0100
Message-ID: <20241103224349.42582-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here are more fixes for the multipath udev rules. 2/5 is an actual fix,
1/5, 3/5 and 4/5 are minor cleanups / code clarifications.

5/5 implements the fix originally submitted by Ben [1].

Reviews and comments welcome.
Martin

[1] https://lore.kernel.org/dm-devel/20241022233349.247087-1-bmarzins@redhat.com/

Martin Wilck (5):
  11-dm-mpath.rules.in: import DM_COLDPLUG_SUSPENDED only once
  11-dm-mpath.rules.in: handle inactive suspended devices correctly
  11-dm-mpath.rules.in: clarify DM_ACTIVATION logic
  11-dm-mpath-rules.in: skip one .DM_NOSCAN check
  11-dm-mpath.rules.in: set .DM_NOSCAN if MPATH_UNCHANGED is set

 multipath/11-dm-mpath.rules.in | 44 ++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 18 deletions(-)

-- 
2.47.0

