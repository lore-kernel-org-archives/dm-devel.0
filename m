Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E94786628
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252318; cv=none; b=KXYCrje8UPpY4PYIEvuvsDeZ9nf0Fmvc9jXGx3kiAOZ8ryrYc6TpZejfMjWeb50lvfNumMk75UcI3vWsxdFT5k5VlFA/oZkshmYMYR+V990qdQJIYKz8BWetJMiziXu/6gwPtDHFDQSgkvwM8sUXgXdv9bzM0lyyHTahq6NkFOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252318; c=relaxed/simple;
	bh=SbxPe0o6BHfYK4GcDJTQ6A0N9TQeYLBu3EDy6jzypdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYo/WXgkExZiKfgpm+IU+pgMW1Ir7Jz2PaZtGw+jMqMC/itE7/o5Iz2JatO+RByYKcwOm/2ZEn3mwdpb1ggolxSG9vg/YmviPrD9/6wo2jUvLxDxDQrCTgVPnZD8bYVFdwAB7UO7Ue2hRjA4vszrrSs7IQGfCrrykhvkUaCfSJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ru2OUOeS; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ru2OUOeS"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-516d15d72c3so735989e87.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252314; x=1712857114; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6PtVh93SN9BLKoEq1f5y2Hw0dBNVHN3W0TFzp29tJM=;
        b=Ru2OUOeSziKLp4AbHwaBWSK3V921WvfUQI0ZwMuHzx2qhxOvWigBjWfbi7XSc+y6TW
         dl3rRDDcrBzj6fAY7yw3nOav5UiBXGL558w1BpS6nt6FcCr2Mtd72uTjjF1D9OeOqfZi
         hWI3HawpxhmA6GWZqoA86Gq4oBDqxyQdfvMIxqRzJAda9UR/G/05Ic0KL8xkPN0ljUFd
         qmCuBA0RDjtEqtbMKvxp4Isio9flhM7rmaKZqJLiW7//qHSLAsMnQ0yXV6rjt5bYw102
         T/FEHSEH0tLPd1tq1IQLpjwNd1Dk+bNlI22To1+m2wZfW+tRNmBh7sjORwkhkZsqgaGu
         ogbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252314; x=1712857114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j6PtVh93SN9BLKoEq1f5y2Hw0dBNVHN3W0TFzp29tJM=;
        b=P516/okhMvWMb8yEwZZKdbhRuYv7gJkygaCBL3GTAJuAlHKAIuWCbiUItg12R3QP1C
         SngmomQ57JT+GO6AH5reUR1gyshk4mC6xmgAWWkuqVkXmN5q4n2FX40VhJMIFHbX8Yfo
         wpide6KCSaQWKEniwoIcSoODdtGB9kV7XIz146urp5N8jYY+hc99oNEz1fYhIxA0jUNi
         d/cu9YtFmxB+HdFd/0OoJYWZNvoLRA1SRmqum+bw0Y03mm6uglJsgvQi5sT+ZDreCNae
         N34YxkS7aarK7W3OnI3RiYzMUMsdpuewNTZ580C+1AAVWCoouVvbyXRlBl7Oyj34Hc52
         1BXg==
X-Gm-Message-State: AOJu0YygqhBRe3CPxrhh2GjgaZ6szAKpXVqDAJBXMGGfEl7rUWU0oi8q
	B0khYw9cElK7a7gjVOXWnHUlQrfNnV9ah9STlH9KPacsbHFfZ2OAjTU2d39AR6U=
X-Google-Smtp-Source: AGHT+IE4cxrP2Hbx9jHCC5xnBgTQ0107/g6aOkIyErkhhqhSaUGTe7QoIVnkNs9GKYnIYtjOJLfYuQ==
X-Received: by 2002:ac2:48a7:0:b0:513:d3cb:249f with SMTP id u7-20020ac248a7000000b00513d3cb249fmr2330025lfg.52.1712252313756;
        Thu, 04 Apr 2024 10:38:33 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id y18-20020a5d6212000000b0034181bea3b0sm20774549wru.3.2024.04.04.10.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:33 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/11] 11-dm-mpath.rules: don't import ID_FS_VERSION from udev db
Date: Thu,  4 Apr 2024 19:38:06 +0200
Message-ID: <20240404173814.3143-4-mwilck@suse.com>
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

Use the same set of properties to import as 13-dm-disk.rules.
ID_FS_VERSION isn't used in any udev rule I am aware of.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/11-dm-mpath.rules.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index eb12b0c..4386b6c 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -126,7 +126,6 @@ IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
 IMPORT{db}="ID_FS_UUID_ENC"
 IMPORT{db}="ID_FS_LABEL_ENC"
-IMPORT{db}="ID_FS_VERSION"
 IMPORT{db}="ID_PART_ENTRY_NAME"
 IMPORT{db}="ID_PART_ENTRY_UUID"
 IMPORT{db}="ID_PART_ENTRY_SCHEME"
-- 
2.44.0

