Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DB61D524
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 03:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707361474; cv=none; b=MprZ7xdU5wTBox0Z4t02orkv7zWhRKvQUOEUI36g/Cqqwmh+PO7OR7GPQIuxAAY1XTZn0IqmHFVaAFxoAIBm9Jh0y2O62KsXy0xiOAlEwmpYnRDF91nL13S3oFHEvMd2TmQW/IYkXO0HcjD8ps5djH+sbTadOmwN/zOBFYFwdaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707361474; c=relaxed/simple;
	bh=2P9MV6RHN5KJQKqu+yqRYADldva8DWhpe7v+sKOnJWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PifEWX7IFR6RuwD2prQrbMmr9y/dalY3xeu05llMSJqjWv8Fn7fIiV8B1WW5kQmP3qWVb/01JFE2MQsR3XgpmevpztylBylKvUCDG46FIzqeAd7jV6r6yTvDsQjpIx/1QqtqyTYlYt3/Kh9LfgiOEG1H//9HedcwtIybjFt5+mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gCelN7c7; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gCelN7c7"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41001c6e19aso2390985e9.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Feb 2024 19:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707361469; x=1707966269; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bO5MiMgVF1SodORLz1Hn0vRMgnZeGd616YOfIo4ueQg=;
        b=gCelN7c7wLnIkVr+ObLA8FbJxM7/S9bPzpr7bNCLQkJfgAsdUS9uKps7AcETH1X3n5
         6E7G8KBp32gjB6wDN+HVqKICGHk2obPNEXh/o8LbIMcmofdNJCqE1trrX2q6nxBVR8ep
         b/qQ5bkGuIRGKHbdugHcZZ9+lPIoD5JcmyQM3ap1RFfcbBXc6yWfrom9mjsJFt7b/ulw
         XbJLhZ0dVrTPKtZRa9EuouLh45KLl4xvMpicqRsvEq8VjE8brltB8N5rweSVUwiTqd4V
         or2MslGY/8O4iecppcb7mzbZTpvu9+zAGY0ti4WIdYWo1eO/3axXGyeO9/LducY3/qaZ
         2/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707361469; x=1707966269;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bO5MiMgVF1SodORLz1Hn0vRMgnZeGd616YOfIo4ueQg=;
        b=b+cOGK/OA2iypdZpU8834i5oOMSrraHUxqYIuxhHX391T/P3ZZHoqQWS7CebxIQk10
         5aJ0CAFCmJHB2u9MTTFJ5KSCS2qxSyYO9514EYFItv6NmInykp/g9RPcjl9xKbRttMP+
         9mBA+qFO2p06IacTI+4Prd+J/gNj2kHZNLwzTmFaHoSQM7CF1LNUlC99LiX3ID4Jok0g
         UnO2vXPeRuu5Fcpmhp6f3VEeMvx2vvaT1pcxg+x6+AVnbNCVQoAjXxBJWoRFTmr5t2BX
         ayVU8FYpotoMaCtuRkhwz9XWsPZ/UypqNsleLa39QPevV4MN7XwlKdbS052BatPP1SUh
         lwuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKPH3PsP/qORtgy1VGLNIOq5pBaRbWDCerJtAGiZE6tJC9X36qKaubsQFmu6Ou87mkAZ1LIWALSymPmTpooZE3vhEw4xM3KEM=
X-Gm-Message-State: AOJu0Yxize6Oz3KPGO5I9Au+V6IhHFlGF+xHA2ON3b4xKTsWMfHBbfvp
	6UoXvx3jVAFGFe3XnTcmbV6g15SA/cbbcruJaTzWAyqgUs0Ee0Y=
X-Google-Smtp-Source: AGHT+IHO9XOnb60j2Y9uy94Hhz9S8ZKQi+aIBrg/LmA0gxt6SxdqjKq0aMVpoW92Qrj0Bj36a6/QJw==
X-Received: by 2002:a05:600c:310f:b0:410:250b:23e9 with SMTP id g15-20020a05600c310f00b00410250b23e9mr834956wmo.10.1707361469113;
        Wed, 07 Feb 2024 19:04:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXPK/z83zQEl7p2+STBPsTmRKnefBJBB4RCYS25Gp58zlgM+7hB7eTWm4CxGI2ZnUKllseY+YdP9184hXhcEf9P+mPir870LctitsSs9FerkCV2QYPwZEUWkSnvRQWC+NfM/4CyGNR9VKaR76IrZMiZVDTxVwRm3fQ1+MrejDTQuLSTfox5qFHGtXuJ4H94
Received: from localhost (116.red-81-44-164.dynamicip.rima-tde.net. [81.44.164.116])
        by smtp.gmail.com with ESMTPSA id fa8-20020a05600c518800b00410000a1a29sm306866wmb.8.2024.02.07.19.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 19:03:09 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: remove extra hyphen from CFLAGS std option
Date: Thu,  8 Feb 2024 04:02:49 +0100
Message-ID: <20240208030249.40523-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html#index-std-1

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 06bdd5ee..e59425d3 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -104,7 +104,7 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DSTATE_DIR=\"$(statedir)\" \
 		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
-CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
+CFLAGS		:= -std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
 BIN_CFLAGS	:= -fPIE -DPIE
 LIB_CFLAGS	:= -fPIC
 SHARED_FLAGS	:= -shared
-- 
2.43.0

