Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F3C267F57
	for <dm-devel@lists.linux.dev>; Sat, 22 Nov 2025 20:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763843639; cv=none; b=iG9i3LpUDwNzFJXkAwhz3M+aoOsTycNDiJ8YCz8HCknphn+hM3ELGJwROUOS7UIR/ujNGkPSY5LbW0IY490z79o/ocPXhRXxUFVpjnzYYriLUJqbeNt56d+ptV3W0gR3JCe8yFU1BJ204ZYCNf7Qm/TFhRcNeWlf+jq8YkbrSec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763843639; c=relaxed/simple;
	bh=NHaFMiF6dxiCU0vMg8q5qTDPlG31ZZujzGUesGhT5hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OqfgAr3RYcKzHUABmOWlCvPUI0/O/bFzkefjEdQbJ3n0+4N/46mLO4PWdpZfzjHMh2bY4a5pzJpyhxAEY8KdtVnnyRlbLjdbAKcbw8Z4urXckjrHl4Ivz1VxlnYSr3JFRP38J9PcnB0u9DWKsQhlakNwSULZs6ycOX7kdrEWbpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jekE1Xbj; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jekE1Xbj"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-37bac34346dso24427361fa.2
        for <dm-devel@lists.linux.dev>; Sat, 22 Nov 2025 12:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763843636; x=1764448436; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFn2EwqFqpnjkFoKzC+88UIKZbJzPZxsjNZNiF3KFj4=;
        b=jekE1XbjT/IRhlo8FeigXqapbeoE+eZuRnO9/FeFB9MaaPBPRAzDnpyudUv34gWYzN
         aQr1512yk6l64K+d1V+xDYvGBpf2pysLvorI1pOJI/YOwUnltJKip4HleADclo0QLLzX
         5npT/EHDfJLRTZ4heopJU419CXwMRGEOFsS/G1IAR57nCuBqhySt0yieW8kJ/4tsKrFq
         8OLBdyv0k+JVTX7zXIN90C/MtZzyWuaH4iQvU6o4eU6BkzOpQ8E8QCztK56YRG6CACrH
         Hv71eXyOcXLcCKRlooFFX9GDBO/ErtGEQge9vgItzLbxRgbClDubMoWT1ZdRaNCZGZs/
         NLJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763843636; x=1764448436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dFn2EwqFqpnjkFoKzC+88UIKZbJzPZxsjNZNiF3KFj4=;
        b=BCK7WlAqsVl5Hy5sd2C52n0EPDEO1AA5Xw0zmR0zn97fSmzt+HfH7I7eChU31RxNfn
         SSREtFwx8mIUBNvKAhQUudhRdkGuAvtifMsz96wvogh8fIeX1Pr7rVjEPW6kG1SgC3Er
         vS3moUGoYrMGzIvReSfkIR4+qf/kyxbuIjNj+6t/WM8ZHTbLOHOoqlQSZMhSy8sFukvY
         4wG9Ff5TpuVByiE2cVMgshYGrpkMBWajz0N/qxj/hjLoQK6I55PNd+1ukKOc8y85ulZ4
         LTJfBIyWxeJScmt9YXHiApdCWhodK0RHotWKcSprBLy2Z64EyHi+cxE7HyHBN9nBDhH+
         V85g==
X-Forwarded-Encrypted: i=1; AJvYcCV0KS2NlvMFg2yxCrA0086sCZRJfpoAGLfjq+ZzQuPBXGnnfw1PrESbQUxx/b+MgpJFs0c6Bb5Tow==@lists.linux.dev
X-Gm-Message-State: AOJu0YwfpIhEQoT4FO1fxNZ+PUhkmYL6OsgYqCRLXipcDIShBhvvg12G
	HB4J7+tPOGeO2m6Bzy1Kxys1/hBV4BuKMS2g2G5RwGStroaKd3ZXFhRU
X-Gm-Gg: ASbGncvf9ii9McmS41/vOPsxRm/6g5cBJbG/Z47WFlWWX/hZyGK+du9NywSYPFrJrdq
	v/888OzKDFbGwLA8b+vBOZ+XPL92x2FXpSnfCzLMxIHyl22M/Wl2cP6QZY71HIsjngWWNhytY/B
	sh605K6dSTOhXDwG44kP1gcGg3vdfygZsVsHNlxXnxsXNAEly8Q+YdIJS5pyYWWRoZ0vVKh6pb5
	xly/JXVFoYgqzwX/alGdZPkCjQlph1EdmHL9czVgRIHFnYl805HkiXvF5ZH23+d4wGCJ3QTDGcW
	QWk/HCKj917VLwLmF0OQsW+Hvg50oG20H0xO/XUQwvUW9jCohmvp3S2A/QfMW3ahQUpy3QObxeH
	N0ot1aqDT1Q5aDO7Mul4q0qkmIMrtYVV3m0evC2ec+MATF2UzH04UphqEz4hzZFFk25b/cT0wBo
	ZdklNpIqvo
X-Google-Smtp-Source: AGHT+IFhSsUjwtf7XXEFFhGewe4/WzYwa1EvQXhZvrF755UE0d1dYIej0yvrkJ/oBfshVizcRSlPOQ==
X-Received: by 2002:a05:651c:4416:10b0:37b:aac1:282e with SMTP id 38308e7fff4ca-37cd9287c95mr16773881fa.28.1763843635543;
        Sat, 22 Nov 2025 12:33:55 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-37cc6b597b2sm19299711fa.12.2025.11.22.12.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 12:33:55 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
Date: Sat, 22 Nov 2025 23:33:42 +0300
Message-ID: <20251122203347.3484839-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> 
> There was reported failure that suspend doesn't work with dm-integrity.
> The reason for the failure is that the suspend code doesn't issue the
> FLUSH bio - the data still sits in the dm-integrity cache and they are
> lost when poweroff happens.

Your patchset is impossible to apply using "b4 shazam".

Here is what I get when I try to apply it using "b4 shazam":


d-user@comp:/tmp$ git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Cloning into 'linux'...
remote: Enumerating objects: 96577, done.
remote: Counting objects: 100% (96577/96577), done.
remote: Compressing objects: 100% (93936/93936), done.
remote: Total 96577 (delta 7530), reused 20945 (delta 1607), pack-reused 0 (from 0)
Receiving objects: 100% (96577/96577), 267.21 MiB | 1.85 MiB/s, done.
Resolving deltas: 100% (7530/7530), done.
Updating files: 100% (91166/91166), done.
d-user@comp:/tmp$ cd linux
d-user@comp:/tmp/linux$ b4 shazam 'c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com'
Grabbing thread from lore.kernel.org/all/c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com/t.mbox.gz
Checking for newer revisions
Grabbing search results from lore.kernel.org
Analyzing 15 messages in the thread
WARNING: duplicate messages found at index 1
   Subject 1: pm-hibernate: flush block device cache when hibernating
   Subject 2: pm-hibernate: flush disk cache when suspending
  2 is not a reply... assume additional patch
WARNING: duplicate messages found at index 2
   Subject 1: swsusp: make it possible to hibernate to device mapper devices
   Subject 2: pm-hibernate: flush disk cache when suspending
  2 is not a reply... assume additional patch
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH] pm-hibernate: flush block device cache when hibernating
    ✓ Signed: DKIM/redhat.com
  ✓ [PATCH RFC 2/2] swsusp: make it possible to hibernate to device mapper devices
    ✓ Signed: DKIM/redhat.com
  ✓ [PATCH 1/2] pm-hibernate: flush disk cache when suspending
    ✓ Signed: DKIM/redhat.com
  ERROR: missing [4/3]!
---
Total patches: 3
---
WARNING: Thread incomplete!
Applying: pm-hibernate: flush block device cache when hibernating
Applying: swsusp: make it possible to hibernate to device mapper devices
Patch failed at 0002 swsusp: make it possible to hibernate to device mapper devices
error: patch failed: kernel/power/swap.c:1591
error: kernel/power/swap.c: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config advice.mergeConflict false"


It seems you should send patches not as a reply.

But I will apply your patches anyway, no need to resubmit.

-- 
Askar Safin
