Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19018176ABE
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804539; cv=none; b=SgGqy+Fr0Sq2zgcGNwBM/sJU1ECN6cbC6HzkWNmogRj6fWp+1YgmoBJYUd3mg4xj2V2CLowjHat76U/dcySKNIgYeNCOBmMNjT1OrqJZxoUSTXerXwP+GMsl1y4Pg53BW25HGY4z4a32ZdNYwu4SP7m1LyrWqVAJqKPolN0ZTo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804539; c=relaxed/simple;
	bh=9jt5Guh6ISKYfj1RD6Ts+RWxC5vRJx9WzJAyMCwWdkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y44Pb8Um9L+09c9DbTgfVWpPxK9ONdRP8+YhTSENzD83nchiCiDAoNwjJ5dq9t5IjzUau4vMuSfuR9IhewjCYPD1oZoEi2ZJBOzzfGzryxsb1vuNGub2jAnaZEtFkE4DCSt4OVdWyOHfrBXL48mqEijV3mpUAZMZ3uT25UCTEow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TdSzj4us; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TdSzj4us"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-58b966b4166so2747207a12.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804535; x=1721409335; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePu3SC1iZasRALA8wuHfQT1WcdAaMxxqS8D8uK8AGzQ=;
        b=TdSzj4usvsxBMSrENx994FYN0fhzJQER7B3+oxzMEHF2IWd6DTGYm67kX7ihW/455u
         ecp5c2RWZh0iwUe6295Kk9HViseekPVJMIoxn8Xem4ZLWIE/iunkR8R+WfIZuHpJVKVb
         2pmIYkRrH3UuYoTOAL3ToegCxGrcoVJ9hriQQD+b72kK3quxiiV+PpvmXE/UIIYUdtVZ
         xx8UI/Up+mzN2cnA+b3CEDn6I7HS9H18J3tb1lCTPaqqExJIrdyF2MPlrFgG0GAi6kUe
         6vgz5Dz0D9CbZhv6rL1f9UOmsYSFFnc6n532tHuLxIaJgBkcocX3rcCh2rbgI0XmcP6l
         dDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804535; x=1721409335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePu3SC1iZasRALA8wuHfQT1WcdAaMxxqS8D8uK8AGzQ=;
        b=aFo2j5oOec3EzZcJyos9kXZ5HyMZlwt5TChVLOTo2zklNBx4lJwAjUuvfPUHxk1KS7
         WwFns0N2zI7h95P+0eDyAFbrOCwFr9JoskKMZ7yYrtrIASX1TZ0gdQ6fzLhGpi3Gxlnz
         9sycYA5k902IdyxuIslxo1zz5RNhPIJ+xUbN/DBaNCEBD0zh6/iwI1+me3vRFVRS5TOA
         IuuacZBl3V5DRu8osAtmxHqJB1WJlPKoybZOjjvhkZfwfZaB+qPLk5N5vlXF9y70XIB0
         Ajdh7RAN7dAYp8VQThfpErWhzZsGxOKIY5JgodfqwrLcf+2b0soO/UDmqS/c6LcDXhMv
         UBJA==
X-Gm-Message-State: AOJu0Yw/uRRz0DtXbQoPEiWv62TxtFcEMPMHDrJ6CECJmYZLuhOnvXOw
	h2+bstZSp0kg1bkTpOfhpvkEJQBotaXHMOWVBhrHt2wLfiK6G+HZEikpPkpPgIKmcyU9LDUY7Xo
	l
X-Google-Smtp-Source: AGHT+IFoemqevxLEz+YDazk8f06DDSo/6GHTEPjFmdCZ1b6Ph0syjUM5JS+2hLFLRiXixEzwOx3ymQ==
X-Received: by 2002:a05:6402:348d:b0:58d:81ac:ea90 with SMTP id 4fb4d7f45d1cf-594bcba77e6mr9764182a12.38.1720804534815;
        Fri, 12 Jul 2024 10:15:34 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bbe2d338sm4812097a12.39.2024.07.12.10.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:34 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/49] Makefile.inc: replace @BINDIR@ with $(TGTDIR)/$(bindir)
Date: Fri, 12 Jul 2024 19:14:13 +0200
Message-ID: <20240712171458.77611-6-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The unit files and udev rules that use @BINDIR@ for substitutions
have the installation target's point of view, they must include
$(TGTDIR) (which is empty by default).

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index ed4a423..28b6032 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -150,4 +150,4 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 
 %:	%.in
 	@echo creating $@
-	$(Q)sed 's:@CONFIGFILE@:'$(TGTDIR)$(configfile)':g;s:@CONFIGDIR@:'$(TGTDIR)$(configdir)':g;s:@STATE_DIR@:'$(TGTDIR)$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g;s:@BINDIR@:'$(bindir)':g' $< >$@
+	$(Q)sed 's:@CONFIGFILE@:'$(TGTDIR)$(configfile)':g;s:@CONFIGDIR@:'$(TGTDIR)$(configdir)':g;s:@STATE_DIR@:'$(TGTDIR)$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g;s:@BINDIR@:'$(TGTDIR)$(bindir)':g' $< >$@
-- 
2.45.2

