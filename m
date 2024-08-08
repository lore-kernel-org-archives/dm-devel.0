Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8BC19049E
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130829; cv=none; b=PGgw1+PhFY8xjeB1Zo8Qu5ZYwVnPzNy6izK722A8NUrEOHz7fZgDXtFQB1Hi4YHgeM76tgZim36myzueJlU2yPbxPqBKlVQ4FosPWympr+u54PQxUJ58rHk1aDOKNleZguLbq+Sij4dl/Y1UX6oSDJwHwiswVdxx0fBGyorlwoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130829; c=relaxed/simple;
	bh=RBZENBhEOZn2aypmo3EIll4pjz3OgDpjP7jPkRbSzSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ+FXXO1Fjhg1lVUp7K34O+Yg/bENNXuCFsfScDJtl2UPcdo3TpQ9NkIw1VWt97PDSczTb10Nz4mFANB69dD4qJzbc+qJOCtBw3HzInu6d8HyKJDPADyKLyut76xZoxtgMfikj7Bztjg6qrlu5kfyH2gmMtciAkSbzIgcPNdylY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KO5iwTov; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KO5iwTov"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a79df5af51so3319408a12.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130826; x=1723735626; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qqv0EfF+RgG/HZJTMIyd6xkVgeZiuOYgYYOXbs60qnU=;
        b=KO5iwTovnNz0bf8w2i/dTfzLcjl1FJ0M08wHoCEVuOuX1jYDxyh0CCX38T+V41aJuI
         WNsQsDibIRY9hLmstj6rJtIWHQYHRjoSG0gT3TwpEN1ujjcociFH+sxIpeOA2mNVwplv
         KrZMvch4GWgzM1AF9pa0wgM0ghuvQGZxci/ykb/Qu10QuNNoRFHkrVbXdmdBKgu/uo3J
         oWo/jlb6ULWGY5lHx+j6wfT4wAlv5oaPnE8QiCAyAjs5m727Jq3J/pcPrEnEf2VoFi+3
         Y7J/CenUdBeNktFWlfwR0NaRnY/gKCplfGv9ION7lIwM80YrwXxC23rWi+wL4veNURp8
         u+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130826; x=1723735626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qqv0EfF+RgG/HZJTMIyd6xkVgeZiuOYgYYOXbs60qnU=;
        b=SDQppAdcyZuMGKm7myEfs9tW6c1S+CyAOrRc4xgRExxiQ0eHfNk9J2J5aZc8R5mSMu
         gJlwRMm8pGV1kgOe3hfDcm5WcBQy8Q/nO+jhmeLun9OfK/meWWD3L1IELKqWW9pL7y5c
         11Jf/MPIL9n//zADY+/ZVLm4v/12bLXFglSTdCRaiqbHVwxtqs6NV/8ZlLEUc/2evbst
         jnD1vN394Kcpqi57ruoo6GreeGv7iG10Ff4YPQ7ENA2MfThDGIize5gxxWYOGFB4L6iD
         3kAOCoGTacR+lOGDcOUsIFUVb3h6JR5xtFz9XEEudPP1ZXUap4LoeWJ8I4kgC0/nzyAs
         C2Ng==
X-Gm-Message-State: AOJu0YwNPqJqggrQWhsJy5oQTiROMxvWSNaB7ui+2iMv4L64TZXWDtLE
	ll8F+z5zKEd2sRUQnVjChvkOX4amlUO6QGqmOMxmnbSfIpMOQY75j0770fXQ7Hc=
X-Google-Smtp-Source: AGHT+IHdGP02BDzOL67ragK8Vdk5ft7tzKcU1vhl1jZGo2EH2+9beAsGwuRUnhJKOsOPVbvj7GXGyQ==
X-Received: by 2002:a17:907:c888:b0:a7d:89ac:9539 with SMTP id a640c23a62f3a-a8091ec7f4bmr173210766b.7.1723130825708;
        Thu, 08 Aug 2024 08:27:05 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9c0cae0sm749198266b.56.2024.08.08.08.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:05 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 31/41] libmultipath: remove dead code in pgpolicies.h
Date: Thu,  8 Aug 2024 17:26:10 +0200
Message-ID: <20240808152620.93965-32-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/pgpolicies.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
index 4469f8b..c1983e1 100644
--- a/libmultipath/pgpolicies.h
+++ b/libmultipath/pgpolicies.h
@@ -1,12 +1,6 @@
 #ifndef PGPOLICIES_H_INCLUDED
 #define PGPOLICIES_H_INCLUDED
 
-#if 0
-#ifndef _MAIN_H
-#include "main.h"
-#endif
-#endif
-
 #define POLICY_NAME_SIZE 32
 
 /* Storage controllers capabilities */
-- 
2.46.0

