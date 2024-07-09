Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE5C189F21
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561217; cv=none; b=Tg0qx/ESGIMEUcUCBS7dr+JKTx5B/x1HhaAZF9/K0jYQXIlXyfrlxR6pnx+EHq79kZdAl6NU0DA7fM35WfG6R15Q+Oo+YbxrZ6MWu9UbUUpHapla7rfht/9AJEvrytYe0pRzop4cSzEdqmZlljpHig4XnKH2A8cwdGQWokwfa80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561217; c=relaxed/simple;
	bh=iZ29QZrcYZnNe+IaRELv6nHBtY/jVjcMX7dhu4w8YbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXzEqKZ+OMRF52BV0PiUq5to4buc4O2zAQqzj0zdWbemoxh2EfRg+PYs/s2E0Vk6W5/uetyMM/HkWH5yA6Ad3BWzA/H/Hxb7TGNmjBipLzboAu/ZZ2PiPcNlH4cfqz+o4qFxow1k4XCK6cN3CI3JBR23lmW3gD1yPLfoulckz0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gKlv5wj1; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gKlv5wj1"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa6b3so3144528a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561214; x=1721166014; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG/dXSn88oAvpGgcBIy+n2sDLL8i58301n9d0qtzZys=;
        b=gKlv5wj1tayafY0Bp+nks3eJlEKRK7f558MVZLL92jpSXYJUaije4aQY4tJ0kLxPdm
         L0EqJiwyvaTVms1wROALLH4ixswFnwp7s9m2fZNy6pAKLn8IyHBqlqhFNK5ZAB0opjr3
         nKxPylc/c9DTt70PrS7tiT8+42yK7/TIS0c8ISiGVghaZHLqx9hYa1M1+inUqEl+5g5r
         ObRrfk+XcBAMVOq8gdWTrFU1yVpLDFc/G+9ZTdyEx6u11uw9HP7poeQTQY7140eseW64
         RU3TJeUYESv1bbVyeLNNZ6qUixksW7UJVGgRRwDsTcLauqdI4xF+BZ0M//HJvX0E4hbi
         A4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561214; x=1721166014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG/dXSn88oAvpGgcBIy+n2sDLL8i58301n9d0qtzZys=;
        b=vMoYxWKlh7PBQ/3R1b/Y8J+3JXyaLzuAOZH/MvDdUIEGjpU0C5E5Hux9YepyPoPYA3
         Ifx6mQGTqAjZT4prISeFXFQK3PQ3ciQAmCNXpZ8C8FyrtQLoyGDnQC5xBnwHNtgQ5uRz
         zTPHTpvLbNo0uFh48gRkQIfmGhktGs78hZ8ozjZsbCgRXVMds2xyqlA1g6G0AOmzTpZf
         hOkyU4OArGDyx02kTR0URsEJFw7JVGj3ox9PZLjERKOxjWHknL39rVx6Z9FDpbI1YHkQ
         khyUBWNjEIySTiGVhFNc5Ywzdq+ZBi6sUDRuB84f2ah3btZgdRc71/HjAdJxabIC8cFH
         pnFw==
X-Gm-Message-State: AOJu0Yw3hKcbwoU6h0QBTggEczlqUjFy7FxGXVeSvM0Ng4qamhUrDJ5m
	CDFMr7dbrK0HI8sKZiWYPFY3mfJbAdBjTSMJGGFcGNv/0UnMUg+Jw+FuND5TpO0=
X-Google-Smtp-Source: AGHT+IEEi6FJ4GAbCML7e3I002DvLCPNGk6Tx/rBmJbGyvDvFBf+oxY0lQu2f8r7RKp+tJORY0Fk1w==
X-Received: by 2002:a05:6402:13c7:b0:57d:4f47:d9f7 with SMTP id 4fb4d7f45d1cf-594b7e7d0f0mr3632711a12.0.1720561213753;
        Tue, 09 Jul 2024 14:40:13 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6de0a2sm107528766b.54.2024.07.09.14.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:13 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 27/44] libmpathpersist: skip redundant dm_map_present() call
Date: Tue,  9 Jul 2024 23:39:18 +0200
Message-ID: <20240709213935.177028-28-mwilck@suse.com>
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

dm_is_mpath() returns 0 if the map does not exist, the additional
dm_map_present() call is not necessary.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 6da0401..5a5ac3b 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -185,7 +185,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 
 	condlog(3, "alias = %s", alias);
 
-	if (dm_map_present(alias) && dm_is_mpath(alias) != DM_IS_MPATH_YES) {
+	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
 		condlog(3, "%s: not a multipath device.", alias);
 		goto out;
 	}
-- 
2.45.2

