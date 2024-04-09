Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D2B12F5A4
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712671743; cv=none; b=qUw+qCTt5O0o90FbpHBqr8SVH6OkAcplf7R53TX/EgeGh23hqamO6z+M/b0Yo3ISvsg9srpVHbo03jrmUa07Jb/iPc8w863BgbzCzta8VymJlBhCLxT59+X3c8gOM0VJUDmw167qOdQW33vmCNgKfHc98HKMx0/A+IQ4jbHUyEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712671743; c=relaxed/simple;
	bh=ZyyZuaXiLhkdNUtizJgtkYZbeWilkJYooPnZeM4zSMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fKUk6UzDQ8VeTLNSOOXIFdB8Xt6ezkFryOzUsUoD+E/wq7J6i8xwVyUacS1Mie1zVaiqDS4eaWmj8vkmH1Ru7S2o72n+o0dst4FOJNx2iFGZ4xv42xT5gyj7lPkwDI+wGb5gpzXrAE5PEm+YuwFgDUy7YseJNEvLQ80W0pUazt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NgfEiKhS; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NgfEiKhS"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56e6e08d328so1412915a12.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Apr 2024 07:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712671740; x=1713276540; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5l0qTRTy2Nr2uEL2QPbEkwEA9HuItxmsyYtsz6T3c/M=;
        b=NgfEiKhSnwhZXbbg1mtbAWs+xsbT1IpxrnlRYcfXSE2P//zjA+AebQriED6roCzlDw
         0OxXdwC3ET6hszQq2O5kIZb23RZ+RIDrrg+kvPXKG9eEhm4a5LysKZPt0ebxxOS+9E1B
         vyv/63+x/gO2Ve7ILomBtLVKTK1ypPWIVCuxD+DP6oFA6hTBlB1GKpu51N6TRovalmAc
         qTzWoc/LJY6lTm5prsZ+mBnLD5clG5flP49WtrizzA+JwgKqAMadvfWI9V8aCPqKtUJa
         edwIuGm1zTwG8CQjf6NQ/zahXFBVLOwsSJfbKrHFjz3nAqz+aCPCsT+nagtmHn7n9Yaf
         fCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712671740; x=1713276540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5l0qTRTy2Nr2uEL2QPbEkwEA9HuItxmsyYtsz6T3c/M=;
        b=qIFGg+z2ktEM9s7ooR0XO6puG2rvF0bKX+IhBWIaejGigJpH2qjd0j4KqHMSWkj/fN
         eb+hR6tUE25x8iXCCgp73TpaIuh3J3iTRz7vlFArugCt4UJL/8btPWe9WjzdANcDQWv5
         go4x7SCWLFP4NUtlFUc5rc7EDgjg1lG33RaFJ+Tv6TgGpyPoo66eV2d8Kvra8aA6o5qJ
         E0HNZoAzbcXPEmgp0lA1Ik5OfQHK6YJMZRvKgoCpLmtoLDmTdYeQpQ0E5e1ptwp49Btr
         nd4IC3UuFCt5uWMOfTHIQggoC8QfTIkB3Sige/JrSqrnBw/avfNoELFCQ0j4SmQ277tK
         4r6g==
X-Gm-Message-State: AOJu0YwUrmjSa1pW6/6AkBCC7zyNsAZUCEwvYqdEW7q5CRz/P7agCblc
	PuDT//7Smjdn+BFyYbhadRu+qvmDjANI2n42UN8FpWCL0oioj4O4/m7XWTyF+X0=
X-Google-Smtp-Source: AGHT+IG+FxGPD8Xbzc7I2lKgMzV8hulM1SIkdorBz6W8CjrvvDvziH7Z2xGIGuY5TUscULXnzOzsYQ==
X-Received: by 2002:a17:906:f582:b0:a51:dd18:bd20 with SMTP id cm2-20020a170906f58200b00a51dd18bd20mr3837435ejd.14.1712671739695;
        Tue, 09 Apr 2024 07:08:59 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id i19-20020a170906699300b00a4576dd5a8csm5663689ejr.201.2024.04.09.07.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 07:08:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 00/12] multipath udev rules changes for dm rules V3
Date: Tue,  9 Apr 2024 16:08:12 +0200
Message-ID: <20240409140813.26774-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set adapts the multipath rules to the pending changes
for device mapper rules that update DM_UDEV_RULES_VSN to 3, and
applies some additional clean-ups to the rules files.

Changes v2 -> v3:
* 08/11 replaced another UDEV_RULES_VSN test (Benjamin Marzinski)

(not resending the patches that have already been acked by Ben).

Changes v1 -> v2:

All changes suggested by Benjamin Marzinski except the last one.

* multiple patches: check DM_UDEV_RULES_VSN agains "1|2" rather than "3".
* 01/11: this patch was wrong as discussed, dropped code changes and
  added some comments instead, lest I make the same mistake again.
* 02/11: fix label name in comment to match an existing label
* 04/11: added missing "\" at end of line

Comments welcome.

Martin Wilck (12):
  11-dm-mpath.rules: explain logic for device becoming ready while
    suspended
  11-dm-mpath.rules: don't import DM_NOSCAN from udev db
  11-dm-mpath.rules: don't import ID_FS_VERSION from udev db
  11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0 logic to 10-dm.rules
    update
  11-dm-mpath.rules: adapt coldplug event handling ro 10-dm.rules update
  11-dm-mpath.rules: don't import properties with new 13-dm-disk.rules
  11-dm-mpath.rules: replace DM_SUSPENDED by .DM_SUSPENDED
  11-dm-mpath.rules: replace DM_NOSCAN by .DM_NOSCAN
  11-dm-mpath.rules: simplify PATH_FAILED case
  11-dm-mpath.rules: make label names more intuitive
  kpartx.rules: ignore DM_SUSPENDED
  multipath-tools tests: fix CI failures on arm/v7 with glibc 2.37

 kpartx/kpartx.rules            |  2 +-
 multipath/11-dm-mpath.rules.in | 86 ++++++++++++++++++++--------------
 tests/directio.c               | 22 ++++-----
 tests/vpd.c                    | 35 +++++++-------
 tests/wrap64.h                 | 23 ++++++++-
 5 files changed, 103 insertions(+), 65 deletions(-)

-- 
2.44.0

