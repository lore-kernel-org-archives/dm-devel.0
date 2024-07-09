Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23034182A5B
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561194; cv=none; b=U5Yh607spNLHObbpt7JbgXmxVBff/VzVyCHys9mcGBV7rXfU5N3ub66ItmPOQ+fssKnV4YHzLdVAtKGp/pBLCDUgUIt70LTzddF5yR75+Forf6Ij8Rzb28kiTn3myDULeGKfWWh1YdIo3n7hV+A1HHNo1OU8szH5HGsxAt/K7AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561194; c=relaxed/simple;
	bh=De2ULvfHpCB/v2SveMhQtfwHY8DDuOc8dTmCBqNjxlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs8FXFgQqVrm9qu6QumSTbD8NwKehrb8eL+uBggjQmBhzBJWh3rATq2l/lRwljF+6E9492QraGDdDdjiStnxyGLiWHmbN5nq9YOqR5DrQAw6ISAvb9lc2pT6P/fUc0MyfjuI6Wa4rNw0SxkdGwXQdiK6mcB5VDtJUwHPa/DVhZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bGVCua3d; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bGVCua3d"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-58b966b41fbso7196017a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561190; x=1721165990; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGBd+4Xgs23I2KXriLfSbwwgkqdZdBRNMvxgmEHfUm4=;
        b=bGVCua3difP/QZzAZfJuDkXjxRyIwnNx30rRETg/c+4MvCJCG8HOmEDugcmmCRUc6I
         4MdzOaD8VXSbOOiL+BDAEyap3P2D/SWicopIISmVJNudsADHnfJngEUFESbD56kk6xRH
         C0FqvzLRwE85ZPSDWq8JDdYmbuETJCmmz2JeJEu5M0qYjXNYXQpLcui/BFdKp/0CoVnC
         H4XCHsVk8nKCV5CoUX+EF8hb+uoAMv1zfl63+uF1nGaAdCQukk1lVyOZuBR0ra8aAYNv
         HeB5SOksqDuDtTB5Xcm5H0LrvXfdvt4wH9/ECNvQuS8Isp8hv2wHp/DZaBJg6nD8qBPZ
         gqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561190; x=1721165990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGBd+4Xgs23I2KXriLfSbwwgkqdZdBRNMvxgmEHfUm4=;
        b=Utx66MZExgVgXpcSE0QpFeqJ4z2AlNqB8UHIb5orEerWFe6/Wfdr+I+RxE1MGho6/v
         zBabLnfUxkYW6MsqA+CvU5euN5ZiOIwCEULUTFj/Xa7qEST+VoxgWSOw6QsDCJvvb9zl
         T1iFLjqHJ9cgGIE5nHTrXnVZGeJoThlvRYlZVtY/VBsR44J9jVw99nBgr3+YBUYVcfCO
         a6rzcN7oiJmQsIuxE2sdhvPxH5iR6m/5NUS+xRqHSvxWTy2CK8kY6IxsGMFGAj6RvYHu
         6LvuB+e0yvB2/GVWdKqkuhqGGXinYoMS/ZmUhwGrEAD7lyV8vAtC5Q0ZPbsWYaBjFkJq
         VFNA==
X-Gm-Message-State: AOJu0YwzO/ec72GtLfDufzE0jCNG2oOMhGfmn/aaNnXSZ+2rm3QnhuLm
	KGGKxT+O5p5V7FP1fKjX5pAQijAVC6rwOZo9WqdWotF4MUt1ztcI+WKT9lXD6trgWsAO+OahfIf
	g
X-Google-Smtp-Source: AGHT+IFaAd2vmQclDeDKdGTvT3LjL9RZK9nze2XvypEuX1J9cESyJzCwbqxFSl9YWip0tFQkiJqHZA==
X-Received: by 2002:a17:906:f110:b0:a77:c7d8:fe16 with SMTP id a640c23a62f3a-a780b87ef45mr227290266b.62.1720561190329;
        Tue, 09 Jul 2024 14:39:50 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a72fd39sm108826566b.91.2024.07.09.14.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:50 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 05/44] Makefile.inc: replace @BINDIR@ with $(TGTDIR)/$(bindir)
Date: Tue,  9 Jul 2024 23:38:56 +0200
Message-ID: <20240709213935.177028-6-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
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

