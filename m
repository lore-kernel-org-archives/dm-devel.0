Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F762FFDDC
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006501; cv=none; b=TnIsS+pPa9vMBq1QcsBrSyfhCDlJOUXyTb9Ae5HOVGkaiWolXrKtRh+LEg5e7+1akTq2hA+WOcFhwHmwy1oXBQuFZNO+QPL5RmHPaV59rMEc3fOXHTMRLH40Jr60IVC502mcQrv+rrpNCr1bmC8l8+uu9yTRm7fQWEnmXZXi3u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006501; c=relaxed/simple;
	bh=fcwV18sTy6mpUh9o+FAQZuCgPGi4JWrKEZ9wyv+tESw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2wTy76rpUIHOUE8Pv9h7MsNE93k5jHVJP0K69808vxXxs2aN6mvKuAi/JqoV9MQhSY8y2uoJBA3Nzwlgy9lAxQ+W8QIH3jNlZSB1VmO58dFao5HrzqbJbtzrUc3b8iAWeWUprUAHfnT6WNmj8XXXXQHUY5bT8J996Fm8FLP2tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M5o5BItA; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M5o5BItA"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b75c7cb722aso1116847866b.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006498; x=1766611298; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpIMJg9/x7bziu9zNF4SUxcUetIZY1bVfvnyc3emT00=;
        b=M5o5BItAr27i/KelCWrLxr2UN7LKHaYl6jol7ExQwHpqbwCm1kTP+wNwEnbwc8Ixgh
         74nQ3mpSiRt50737txCx7AW1+nCRGdTUWD4qd/fy6oqdIugco9CWt3CXEXRQwGzDxCRw
         ZoDZUKJPHN+S/nF19R7RVk/53kGcja0v/aPdHp0GW+rWISBSXMEN1ZXkVkf3YB0rczyK
         xmUQYm3Ba4IUqeSZQ8TDNvwnQXpSlzmwBBG/nIFnw7tKH/Zjt1m3oQqs2Lo0sH63UV2O
         kjXhEgiqebpaw68JTTMOEu42fk0PS1/UA/KzC2zjX75dJBwX1YVH4/9KwbXXirsRXVqX
         W/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006498; x=1766611298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cpIMJg9/x7bziu9zNF4SUxcUetIZY1bVfvnyc3emT00=;
        b=OqXJ5CAiKJAgkfzAqx15t6oPkr/5PbW/laGYkCM2AjiodJifi+7f63HCeLOfCaL9s4
         u6mx1WmscQo+6DzEo5rhvz5wNS5twszA8cD8TvEuQQMYoefcdIC7YHkasoTOfu6iWFmd
         asIaWLMyVjFRCqfEXKW6GZajkJe6k1TyPxoeapOme7if3P3J6k1TeDPMGVP9L1dlkdm7
         aLit9gv2q44+f+n5vT8QIuZ+S1CaZDne+lytmSUXwxjsFdjRD3ldGimna3zwGBLT4Lim
         zWZ/DQ+yGh0wKN+890ofIUP/dmg+H/DETKiTB9xbPqjco/nfsRnBCLru5UoUypdmAiME
         wBcg==
X-Gm-Message-State: AOJu0YyY9cbsN00ZG1p8vC32487snzh8YUInAf0XKmk0PkEbY4LlCM6j
	0xdY/ehr4ujPUScgH4kPZFvx2QJKXe89AOG6VnPt/l57n1rtDTVtgjySVVhXuwhmJA8sedrncbt
	sGGR3
X-Gm-Gg: AY/fxX6vFGSL+P49t9iGtyntz7lyw/hD3WfSVo/Tkg5HMoSKW9BUlc/hBw3cdW+RN3P
	ArXacgZiHGlOTIu+yQc0zCwulp6+Pb9a4CJzI/1nrRFs9jbLy07EQP0uwipu03ICXZvDy1xX0ys
	qdlpY2D3hJTybIrsm5U8nkArikQsUQuyGXN7LoGehYj700bND4iH0hLmse4XeEiD53s/Y3rgyEP
	MkNpOjrfaku34vpkpmSUHf5O6esHk6ysRufbpMVt1ioVxxRrQluYV0t3i0GbdfOp4nATCdExv0d
	twMquHESd02L1WWkp+qmS5CHWMqJqCVk2H0HSU/wk8GCzEOi/0WF04HwR4quzHQM7lveOz0IMUm
	9XmkT454hkmEW0dtMZrbj2CXITI0nYKbGhTbXRrPpgCLB+FXD4L4d6dK2wEu9ZtU5U71dLywCZd
	s9D3GTyNkyHevk5PjpKxDidaM+HCSs1dVrB6nDDuWSmwN9idPsurqQz1NImb4dp5h+Fqh2UDjxI
	Q==
X-Google-Smtp-Source: AGHT+IFnkmjXOX+4KXq03PRDD/ah7eSyJxIfmVAO504D2VTh3nd57u0ljb1huHNx+ay1SeRHE0UNdg==
X-Received: by 2002:a17:907:6095:b0:b72:3765:eda9 with SMTP id a640c23a62f3a-b7d23a7988cmr1872587166b.60.1766006497910;
        Wed, 17 Dec 2025 13:21:37 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8023118af4sm30143066b.29.2025.12.17.13.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:37 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 15/21] multipathd: join the init_unwinder dummy thread
Date: Wed, 17 Dec 2025 22:21:07 +0100
Message-ID: <20251217212113.234959-16-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This closes a minor memory leak (thread-local storage of the
dummy thread is never freed).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/init_unwinder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/init_unwinder.c b/multipathd/init_unwinder.c
index b1cd283..d39e428 100644
--- a/multipathd/init_unwinder.c
+++ b/multipathd/init_unwinder.c
@@ -34,5 +34,7 @@ int init_unwinder(void)
 
 	pthread_mutex_unlock(&dummy_mtx);
 
-	return pthread_cancel(dummy);
+	rc = pthread_cancel(dummy);
+	pthread_join(dummy, NULL);
+	return rc;
 }
-- 
2.52.0

