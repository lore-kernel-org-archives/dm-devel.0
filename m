Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FFE848A
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252315; cv=none; b=qfKgXXDKGwuOgmYjV9/mr0HOzMCFzgf9PuFq6/kcjM1qBWhejWadHhkMmgVu4LSmmJis1buIwC9CEJ/ilOB7X7+sJ1uOSqBhUHdpOb4wBDgJWnEucxtSny5urfKuIcewm5HTBHkn2aZMfak2gOTwx76y+p487mJxnmkmdNY6DNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252315; c=relaxed/simple;
	bh=R9krPcnPywqdn26nAFUqoYVBZTfZtNypxe2SzSuofkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiIktdJl7xj6aEvH4FiYjjhNRUWAyzFTA0Yzi7QLp6cf7tcNbRr9ceFvtSwqXp1M0KN0Yb6fl8Dn0c2HKcfe7jCKm3hzHYRG7QHbC0DWmzEqKwoXUo0GQq63Rf07m4lID+03Br7iv76cEQ6RsR31rENQ52fihOx+CywutmMvFew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UqB7heyP; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UqB7heyP"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4162b016168so5572405e9.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252311; x=1712857111; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WiMrwLgdHE+jNt2pM+jjCDSzLRojD3n4NoUteq8aT+E=;
        b=UqB7heyPNeFA+UIBc8DUGZMfSD+me/Fj3mLvA6jlupnLSpqvHnNjOA9/RxlHGZwv1x
         oZ9/hEzh4aYhtByz1EWF+jPntGAjM4jT9fz/88ZyC8py+Z31gIzHQKa1QFA9HE9hIrXG
         tT0r0L7dz2UvmktcC24uH34clt81kUmYhwL9PUSSN+Ngowi3seMtXZeORmefUEf7d17c
         FhwnxLXxFwS2J9cjc4xNzSMi1O2mWYNVjSfBCf3YxQ+H3qF4D2H3dWd904o7m7UHl9fm
         QfIBCLZS/3z1o6BIL5k7XCH9+8s7s/pfJBrE8diBWls6nwL42Fi5H/CGDTKQyMesHhIH
         +P3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252311; x=1712857111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WiMrwLgdHE+jNt2pM+jjCDSzLRojD3n4NoUteq8aT+E=;
        b=wJ1FuKWtzPdkpQz+JoBQDMYUGw6IFdve3aBjuwSZb5P+ENk/lsrawfeOektMZKftX9
         fK4z4qbW4+pbwiOEb0nNnEAsubKHuEWX2B+qDPE0acUjLcyFxbgrVGZ5F5fIf8Ag5J9K
         lbMNZR0PCoETYWXFLQAgFCns5HXKjRvfxj3cYCETtptDsSCQmTmATDmdtM4oKz9a1fIz
         0RKR31NDEBou/ohI8MDpIzEkSqXG0JaSH6Kc/s3v7ONkSpYN2J/KFqTXCwgL7TR1cCVk
         NEfxI6ffBp8FCPzGNvu7EeHwwNuP4e3RU680g5ANXqw3fhCxeIYVQ29Zn8jRTmkPplDH
         maIw==
X-Gm-Message-State: AOJu0YzRC9he/FihXOcn88F8xGIsE9B0Zx1wIJz/BZcPcNbkXNjDYmhM
	e+6aWm0d5ghNONmJzsP8JeKNHQC7AYJk/spfr+6CPZbsLVPEOlSTysS7HbZ8mFg=
X-Google-Smtp-Source: AGHT+IGKqX21qsY280BdmVT7Fa5Wbe8+3lTOXbNv1PNhokGBWimXH2WEu/JEguAyQnG5UKbko7mxOA==
X-Received: by 2002:a05:600c:1ca7:b0:416:2ba9:34f2 with SMTP id k39-20020a05600c1ca700b004162ba934f2mr136578wms.4.1712252311576;
        Thu, 04 Apr 2024 10:38:31 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id hi5-20020a05600c534500b0041624db414esm3386972wmb.35.2024.04.04.10.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:31 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/11] 11-dm-mpath.rules: explain logic for device becoming ready while suspended
Date: Thu,  4 Apr 2024 19:38:04 +0200
Message-ID: <20240404173814.3143-2-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240404173814.3143-1-mwilck@suse.com>
References: <20240404173814.3143-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a comment to explain why we must set MPATH_DEVICE_READY=0 when
we see a device becoming ready (number of active paths 0 -> 1) while
the device is suspended.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index d9585ab..b8d19d0 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -98,6 +98,8 @@ ENV{MPATH_DEVICE_READY}=="0", \
 # If the device comes back online, set DM_ACTIVATION so that
 # upper layers do a rescan. If the device is currently suspended,
 # we have to postpone the activation until the next event.
+# In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
+# MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
 ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
 ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
 ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
-- 
2.44.0

