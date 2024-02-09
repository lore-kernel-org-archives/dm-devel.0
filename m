Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B367580C1E
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707497734; cv=none; b=ZZlfqftOJBvHyxWRYQqQ2JZsexr35tUHRY3eD75Ph+eXWm4rRkdDH3rc68AZPOPIvkx4a0onkvIKSPGibjcztsk53FzLpoXlsS+hh7ofsgxxjlT2k2fIozq5oN3ffXLyyTPHkqzYbcov7QZ4ySBs9V9VNb45rVghV3zkZpfi8lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707497734; c=relaxed/simple;
	bh=kH9lcZgazreTj8Ny2flKgo9+XCPx+sRPzn23GF88NbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl0zYGgGJoS11iS+y74jM4y1brZ+jwOMW3Q/Mr5jFAstZuoVIFi3S2X2vy4LyPux01VtM3nEojR8+M0TwX5aldy/x6eda9V4NdFdyyPqxQxCo/tAbH4S0uHEGtK6gHSu0knyKR5aIPb5PpXZQaAMw/v/Zb+lDRB7lnFEuMeuIQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U6fP4B/Q; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U6fP4B/Q"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4107f854a11so3349335e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 08:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707497730; x=1708102530; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8Oku1j+uKnNtNBV9SeKgc4Lwc0+MXN/8VQvzoxpbKg=;
        b=U6fP4B/QKfAQE4zm9rW6eVbfhc2zJJbZ3Q61vtHaET0WDh/+Xje4kGFkizEhzV3Pt8
         ansmbmccFa7g28P+czFc+UzLkHNgZy15h5DYQ14jTTS/C/B9rTTvkk1unQ9k+TS/UM6N
         TmuUlFe/Zl6XA292HaiivuzgN3BM4AZgFBcBF2yOiqAy1NE/nudwhkx4wLCVUMfCgff7
         +xbY6VXo23S5xukYFqQkvNzHIAnFROfW+x/flR+JtbW8QNXhYkfELH6hISUf1H3g60Qy
         zJZSrp6JVlgKp2bBVHsSc0HgjjiwILiApYhhvC/d39+aFazje/Lnu8kUaxhgvgDylNj4
         l5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707497730; x=1708102530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J8Oku1j+uKnNtNBV9SeKgc4Lwc0+MXN/8VQvzoxpbKg=;
        b=oyCDjJCMgY4/p73QDJkjBIqgx77WpNIJftflN1TR+okFmjNQqhnDDV9mZoZrIMKjSp
         hfnmTQhqmtSlzWWOrn/UMtE9u3v1phg/vrcJc0NCQPVoCE2bIcbso8f6lIU6LYP2SEwB
         3C5K3ow5rTbnm5DcGhiwkASv1ZKLZRIdpYtpNgRLP1tioXY1lNeG5VnZkuyEISDAqVG+
         66YVDTdDHAR6mruCRwXPCTNT1fd4pO/ezjJC4kNLBZzw94NP58LCQLovZVKOlMWw3C3n
         Fv0oKN24NpGh1xV7SnoEUKaleoWsCjvnOo5aQM+yl3uoBtusT/OFdeaLuWFoqrFf/30w
         eqcw==
X-Gm-Message-State: AOJu0YxjOq2sgPU/MWT2BbUrp5NpWifF/R6kGjJw/hd/HTOuHW4hMGHV
	F6RMTnSICE/s2D0P3Kouu31Flnn3MfFrekN5N+/gCZUNlxH4YekQWGtEOPHCops=
X-Google-Smtp-Source: AGHT+IHp+yQc0h286pv9dp7U3DMCAeFVTrvuiIGJNuDirbK2GsKUlFVddITf8O7xuxjbBtujyS+4yg==
X-Received: by 2002:a05:600c:3d95:b0:40e:d30b:6129 with SMTP id bi21-20020a05600c3d9500b0040ed30b6129mr1648094wmb.13.1707497729942;
        Fri, 09 Feb 2024 08:55:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX23k4s0b7nv5CjN15PGm8rQ3X85eTUsG8r02r1NTlVZmP8c6odtdQm94sXNfgyY6USdJctZzVq/jRTe60HFLJN30DqUttrMAmEWDmNT9ahqxV1o2VawSOzSURy0BhC+y+YjVuLVsWjhjYc26brYGAFSjx2BDNSBrILGNmQD4Gn6GVC0rqiicVX
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id t18-20020a05600c199200b0040fc26183e8sm1217227wmq.8.2024.02.09.08.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 08:55:29 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 5/6] 11-dm-mpath.rules: clear DM_DISABLE_OTHER_RULES_FLAG for coldplug events
Date: Fri,  9 Feb 2024 17:55:12 +0100
Message-ID: <20240209165513.7661-6-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209165513.7661-1-mwilck@suse.com>
References: <20240209165513.7661-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For all "spurious" events, which includes coldplug events,
DM_DISABLE_OTHER_RULES_FLAG will be read from the udev DB in
10-dm.rules. Thus if a previous event saw the device in suspended
state, the flag will be set even if the device has meanwhile
resumed. Reset the flag if none of the conditions hold that
would cause it to be set in a genuine uevent in 10-dm.rules.

It would be cleaner to do this in 10-dm.rules directly, but it
cannot be done easily, because the flag can also have an origin
inside lvm itself; lvm sets it for various kinds of logical
volumes. For generic (non-LVM) dm devices, the flag is only set
in 10-dm.rules though, so doing this is safe for multipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index b6629a8..21f0c15 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -16,6 +16,13 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
 	ENV{DM_COLDPLUG_SUSPENDED}="1"
 
+# Coldplug event. DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
+# from DB in 10-dm.rules. If the device is not suspended, clear the flag.
+# This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
+# equivalent to DM_SUSPENDED==! || DISK_RO==1
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
+	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=""
+
 GOTO="scan_import"
 LABEL="check_ready"
 
-- 
2.43.0

