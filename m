Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C1128384
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707943884; cv=none; b=NhSgD0DTCi/9DeIyZKoL80m9srnvYEGN/oMOxmXNEOO3R8C5Pk9CNe5W7ogktihqC/sNZ13Jm9MYRf7WRMVeoS2ep1hsIphwIcIZ0loxnT4Y8vVzS9k5W05BJaMPY8DGI+CnXqe8KRolsuMG1AkoJOkIkGmjIR290uJbw7RagoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707943884; c=relaxed/simple;
	bh=lyd+Hn5EV1Jxlzol4gxngwuwjTdxREoiMADFtespBH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E03mfY2qmSetdG2U5PnVVhWK7zM8L6D2TgOxu359HvigJEmzk4ZEetP1967SnwjA50ml4Tlq9ZZ/xVjxlUq4OHFh+pmWczTtqHqUNdks8405zqxwj69QWdkQj9lWDtOoBY8JRt0PoCnr2iJQvY0nN02U6Sd0hoZM+/nDMafj28k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HrKu9ci6; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HrKu9ci6"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-411f895c8b6so1272995e9.1
        for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 12:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707943881; x=1708548681; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kOug5bTIRYU66LDQvPGyaqGUA0HW8HK8OywBmD/pqc=;
        b=HrKu9ci6x0Fm7ork8chUs98EJfHcaxqMsNmia7m43ecfLcn7FHq8jtp7lWZ7b75oVI
         CQYmwlI1o+m6P0QWyZxSJALps5iRXBfSpOGf6MipnRc15ke3/8f8SIJbWce+fOFMuUWg
         47zMkE6zhpq66Xf0ESrZLQ/61CXjZenTiHp2B6wBXtjV7MjLg35fyrjbcY+47iupz8rF
         Fr41HWcKu1pk5/Goevi2zy0Ne/2bz01IGkeFQv1bOzGAi9xR819l9uYJR9xyB5jDmaST
         h2vTyf+Bf+0RsDbKfYrIR9jZcR6hbmKOoGU10MRDGzN6M2MvDIgWlsfFdttf9tgRUf3g
         kVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707943881; x=1708548681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5kOug5bTIRYU66LDQvPGyaqGUA0HW8HK8OywBmD/pqc=;
        b=pLvD0Ns8x//5m+pV5TS7eNsfGAE7uajQH6YP/BV0t1u+uwXzY+0R3av99iZv1v6oe9
         kc3+zAB8F/kfe+TIe8MDCYi4ED2gUKGh4B5PxZG4P8rO1fBfrbgguJqB6s1/a3RzTaHh
         Z2uoMXT6ltn8gaQ8TcqwSmxrklsypUbkQbIcXw1iVblP4vjrZ6wmOVzljTtLdwfGJx4W
         a/6A2QUZVyQIaF/q8zvLSe5RylSs0oPiyzqdbfU6T9z8IxFO5GIjpw4D6xCfXa0veqr1
         /XXWB1QYKMfI/6Me4Pm1wgSoS0lnYQ+g0cv8XCOtqu+upo5lFA3+ikjYrLzVottuBlsx
         Xa2g==
X-Gm-Message-State: AOJu0YxSgEizkl+i4qPTv2Bmgt7lQ0XsRoxK8JYf+RVqjTXlXv/+DZKj
	Y6Yo7SbbTlHAMIJ6b+eaRbdlz6gPwnftlWBiL23KbnjdfC+JMMSCfNoPCjV2xUlJ44uyZw2INud
	v
X-Google-Smtp-Source: AGHT+IENexf8wmIWmmSO9xoMcnNML9q7FWBzYStSB/nNQI5tiYc8qVK6aPkezCQ2dhZebpBlUoYqXw==
X-Received: by 2002:adf:f4c7:0:b0:33c:e1f8:9444 with SMTP id h7-20020adff4c7000000b0033ce1f89444mr2487029wrp.9.1707943880849;
        Wed, 14 Feb 2024 12:51:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUaSqhRY4VbjQtyiM+/VAgXHbDuDXfBmXxn9V1NVWq1+GYuLqMDsreKILlNSl96QjUG31HdmHxuiDBGJ3+95xXnFH6mxEUdIa1GWd0SXvhEeA9gxh5tEGQLGjB9Ry6guOG/xYaUh5ge9FbimFDOuvpkbPJrwXZ2fTGmg51l65IzLpO7NTkLnEPu7AyHg7lP0df25JpMxJYll6M=
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id h2-20020a05600016c200b0033cf041c03csm2295840wrf.55.2024.02.14.12.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:51:20 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 5/6] 11-dm-mpath.rules: clear DM_DISABLE_OTHER_RULES_FLAG for coldplug events
Date: Wed, 14 Feb 2024 21:51:06 +0100
Message-ID: <20240214205107.27409-6-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214205107.27409-1-mwilck@suse.com>
References: <20240214205107.27409-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/11-dm-mpath.rules.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index cada176..82b0204 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -9,6 +9,13 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
 	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
 
+# Coldplug event. DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
+# from DB in 10-dm.rules. If the device is not suspended, clear the flag.
+# This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
+# equivalent to DM_SUSPENDED==1 || DISK_RO==1
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
+	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
+
 # If this uevent didn't come from dm, don't try to update the
 # device state
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
-- 
2.43.0

