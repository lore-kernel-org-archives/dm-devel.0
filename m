Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7893F1B7E2
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707943879; cv=none; b=XeZUo+r0V5DcB4f553ft/ETanxcT0Xuy3KpvGOrnKylR5k6xt6L2XABBPH2uh86xg3Zu9hkw0ONl1+3d+TDfJuyh9q+tkTQ2qSAKlG3mgGB58lZcSVcGL9WdXsKS8RaOtgOiju0KkS1JH/oHh3IgPD9/qrxdpBc+b4kGHgdo7Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707943879; c=relaxed/simple;
	bh=83Qx/n4vG0UL2YVedpyDB4Qdt7puM/QtHsCDDfRNxNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jBrO3qe7eqsMbUJAzaUh745wTp8ZCdYvjjJzgiiUljjY6zoXo8VnjMwSLfZBOvJvZgFfDcZ7YjVpOXpMLsvfMDFCgRnBwN69NHpo7LWZ78KUevHuAP8v7HxCGpaxEPPigKFklFgpZjAT5DWN9iVO+uOEmXZ9aBnPL0hlnm1+/L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QLnQg/kv; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QLnQg/kv"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33aea66a31cso71092f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 12:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707943875; x=1708548675; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=67An7Yq0SwR6INV+bLzBX06+aOnUuu5dgfHI9ClTRwM=;
        b=QLnQg/kvFcTwwt1BMp4bMR3Eqawk2fhLDI1BFgJZHA3g4jwLEbk8hCqUq3X4zGwid0
         hjzLMux71rwZGWDZlz1FtVzKxOOFD25/Ze/1xcrNOuET9/gXsXv4TQn83haCq1SnR3RY
         qIpUaG8Aw840tXkg8jYHin8lqy4sorvKUIZ0RuQGBZJ9lZu8OWipq9084ObtYOgkr/v9
         8ld0hCHdTIMuVmwmz0I99mN8OFZjsdNhneL5enFEhlr3aYqNawS7ZwU6XWTQOlFW6u1K
         KJ4JK9CeVxkL7afrQ8+fP3XZ8qhHdUNyzZd9kUC06OGFSuLQTTVW2QKIKMWRZL3LLrDA
         dfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707943875; x=1708548675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67An7Yq0SwR6INV+bLzBX06+aOnUuu5dgfHI9ClTRwM=;
        b=RWbVS+oNHqAPK8ImoEpF2RpXKt8K65mhDEELLkPzUoLxu6H2fTRtKod76QV5mPF3G9
         bFoF6qXXFpo/6PH6nZI/gxw0qejGU8rtmbQH8/7eUfj48W+MGuu1D/jVTQN7eBeov6SC
         qpNmnQMDzjQerEUDHw0H1Rb0tvZKouVtUQmHLEV8ad4DBBzANpz6ITdqU284CCUAKd6Y
         38wy3fn6+Z6mMZSweUl+Poodos5ZFnB+jSQLK/t9Ng75k6Uk8oevG7bo0vqVCFJFUR5R
         CZnL0Z0a7Tq4nIwGEPkWsqHTIjfoaj+KtVxhg4O7+j2HksQ4YPRiQl7E6trm2uDkBYFI
         0mSA==
X-Gm-Message-State: AOJu0Yyks4/Zn8Z9NQxHsoed109kZVxAgwi4FMtOAwgoW2IX9rkY5QcB
	8zabsQxEMIUezscYMOqZMnhrF3R8fot3Q0ex01nZUc6myOQc7BXVgCFhwy4KXeU=
X-Google-Smtp-Source: AGHT+IFXgfHvU7WwRWpTEgliV7VzP81EfJPZ39T3u1NBg52De4T7wRMaNIm7904OrSr5twC7s9d1hQ==
X-Received: by 2002:adf:fd4f:0:b0:33b:6dd9:a75 with SMTP id h15-20020adffd4f000000b0033b6dd90a75mr2474438wrs.49.1707943875591;
        Wed, 14 Feb 2024 12:51:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVO+jtiEk0rNvEjJqVyoA2P1I+MO4p9Zf5yOzJZFe7XYAhMt0RTTWlSX5Wb5vXSaVTBekzuN2CW/gbtGduTQjl/1e6ClGpcxS8R3dX3WfY6aNKFEeZjM4gYyezfj3PhGJlHX7wU20KplFzUNfwpGQROhtdrVknTZnMqIAWWubNngT1S23zqYDiMFIEcmv/90FzNt/mlYSB6hoM=
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id x8-20020a5d6508000000b0033b1b01e4fcsm13348499wru.96.2024.02.14.12.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:51:15 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/6] udev rule and CI improvements
Date: Wed, 14 Feb 2024 21:51:01 +0100
Message-ID: <20240214205107.27409-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes v2->v3:

 3/6: make sure DM_COLDPLUG_SUSPENDED is imported from db on spurious uevents
      (Ben Marzinski)
 6/6: fix missing quotes mistake
 7/7: drop, already reviewed and pushed to "queue" branch

I kept the Reviewed-by: trailers in v3.
Thus 3/6 is the only patch missing Ben's Reviewed-by: tag.

Changes v1->v2:
 2/7: This patch becomes trivial, DM_UDEV_DISABLE_OTHER_RULES_FLAG
    is not imported any more, and my previous statement that DM_NOPATH
    might be set in an earlier rule was wrong; the test whether
    it's already set is dropped.
 3/7: looks different now because of the change in 2/6
 4/7: there was a flaw in the previous version, .MPATH_SAVE_DISABLE_OTHER_RULES_FLAG
    must always be set. z0-dm-mpath-late.rules was broken as well.
 5/7: looks different now because of the change in 2/6
 6/7: new, another glitch that I found while working on this code
 7/7: was 6/6.

Except for 1/7, I dropped Ben's "Reviewed-by:" trailer.

Changes wrt "v0" ("multipath-tools: udev rules and service improvements"
posted on Feb 5th)
 1/6: fix logic as pointed out by Ben Marzinski
 2/6: Keep importing MPATH_DEVICE_READY as suggested by Ben Marzinski.
      Don't import DM_UDEV_DISABLE_OTHER_RULES_FLAG any more.

# v1 Cover letter:

Patch 1-3 of this series are actually a v3 of my previous series
"multipath-tools: udev rules and service improvements" posted on Feb 5th.

Patch 4-6 are new. 4/6 implements new logic for setting
DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD, as discussed in the thread about 1/6
of the v1 series. 5/6 fixes a variant of the race condition that 3/6
addresses. Meanwhile I got positive test feedback about these patches; the
partner isn't observing any more errors with these patches applied. Thus
while certain types of race conditions (reload happening between
DM_SUSPENDED test in 10-dm.rules and blkid or pvscan calls in later rules)
are still possible, they seem to be rare enough to be handled in a separate
patch set.

6/6 is an unrelated new patch which is necessary to make CI for arm/v7
environments work.

Martin Wilck (6):
  11-dm-mpath.rules: use import logic like 13-dm-disk.rules
  11-dm-mpath.rules: don't import DM_UDEV_DISABLE_OTHER_RULES_FLAG
  11-dm-mpath.rules: handle reloads during coldplug events
  11-dm-mpath.rules: don't save DM_UDEV_DISABLE_OTHER_RULES_FLAG_OLD
  11-dm-mpath.rules: clear DM_DISABLE_OTHER_RULES_FLAG for coldplug
    events
  11-dm-mpath.rules: Don't force activation while device is suspended

 multipath/11-dm-mpath.rules.in     | 69 ++++++++++++++++++++++++------
 multipath/99-z-dm-mpath-late.rules |  4 ++
 multipath/Makefile                 |  2 +
 3 files changed, 61 insertions(+), 14 deletions(-)
 create mode 100644 multipath/99-z-dm-mpath-late.rules

-- 
2.43.0

