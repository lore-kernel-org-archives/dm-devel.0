Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8BA337BB5
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817127; cv=none; b=SJpKdFSgRjF3d9AQ4heY1olUwrsUOXVRZ4ZjqNYCG8z7ls4WPoNKnhkajXKFQiZz6kohAE6f1RsMT/UVaZGVXocV0XzTisDQS+lpfYJ2hJiKr5ko9NMgavJew50d9ce5kKFg/Lc52uUX5mT526A26mdmlvz7Jwh0DnDMG/BER4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817127; c=relaxed/simple;
	bh=2mw4R9xUgpEID1+yzw64LclaqB547lu8GnaiMHY3LDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvibGs+fr5b74ZQ2HeyYco1CkUQyY9EioGy8QdIh7FH2lL0Ft0YpwcLmO/3iZp4EVXDpY1PVjExn0/riAD+xSQSPQ+Mu/ZJPpwPUIDXJI2tV1DYMRFOSDT+FUV1wf5E+7jIcNkXvhL3LdpfIACRkmHhq8AVNfa7Yk9Xd32mEf9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FVik7vp7; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FVik7vp7"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7277324054so435724466b.0
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817124; x=1768421924; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUDWfvQX+zbixVMyxEvAWD28Fqm+izRQyft2Ld9BCc8=;
        b=FVik7vp747FQ+hx4+fTZbYpkM1CVobZBbHJOQahTQxrg/I12UYv5HHEsw2+MPEUIHP
         yYiOv8zUrAlu5YnCkeI0BnjNpy/vp5ylSOXUeGKeuNnkHUA+5ymXw159ruRvdHj7ZHrl
         X15rL1+wikpBG7NDMvPK9FYxMPbFYnaw7LdvJcse5al4uEK8dLupfkp7TpWUqxEqJNqZ
         BgMnJtFvdAagFKwGkS6TftUNOLZLToC/LgO+6msxskRJ78ICuNuOZTeyooP9lfNgKM9I
         rwRKhd71AZLY3LW3SI21akAtpnbdg+iIhGsP4whE8MpwtxEnaV1zj0Xyxk/nBtZWZvY2
         iJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817124; x=1768421924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kUDWfvQX+zbixVMyxEvAWD28Fqm+izRQyft2Ld9BCc8=;
        b=dvfpJG+XQ/xSv9VwL0WHu6/Gydpasop7espzG7afApgIPyov1ZdAk6i1JrO9zh+inp
         A+6P0JF9UcDShMqbRebPghGKNdd00CQQiQ0vOUdRgqcUZsd04sz9l5dco/qkU4bdTFDi
         CXEdn0PBcCNhYDj1+hEtrqTloh2SE8WuwzPNjy2F5ciq1k9WAS1eekKp4rFRf3rpNPkT
         0vijplFB8ptgb6dbcCRyMaYOoDMK4ckeKI9UpTgcSrrYAICq+lyhsVulL0bayi57e9Ti
         SLDpHNm5Xkxcze7pTVT+VsJsM5m8/x3Jkmhi54m2n2evoWkDt7WZzQp/8LxcMW5LAa7+
         8itg==
X-Gm-Message-State: AOJu0YwCxgyZFAjrEcMl0TXkbjI0xKFrjUoMu5aGgRN2WJaQl969SoVV
	ZgQ2vDWYcc0QGoNMeHG/GAt5a+eBWuhmOsavUoNbV+VNHfCyUWh7w/sR7tTRzcyE3H0=
X-Gm-Gg: AY/fxX7+a3FI7Z9cHqBFc2QKRfA3aYcp1xLZuv4uE6t39EQdOXqPNtXwI9ixLD3zKQM
	k2mVp2SWmSR8GnZ8t6l+9tgt6hPf71xOq+SW12KuLVcTITCLDbC3ZJqgYqAr2Q/w/Z7Qh9t4f6t
	MytTo2hlDAyU8z9Rroeu2hxckTHsGupy8xVX1YOjvqErV43riVaGb+ODLeONWqmAx/o4qU6pFCC
	ST/d/I1BpUOWy7c9DXzNPU/rE8ldez4c6VXadX7rPzEZ9e7ZG45FFUlwHX29eXZHGX4DPfQNIkI
	FE9vozQEWQ4MdvrN8sEo1INDvCYnRMH5Alnbdm7+v0JC8z6SLjdW384LmI8GmMc3in4WdPUXhBu
	KIB6BUT4nxyTzq8rf+oBWJanCcn9onLVqWRlOveh0AZyN8tBI80gMkU57q0FORbn4/SBW4IM9/c
	ThZmKXxNoIRNM3RHy6cWmwhjkuG7ovq2JqoIpB9f746TeMFBLzIAdg5a7ezJIGeUXxZWcWaK2my
	/otlPHcmXjc
X-Google-Smtp-Source: AGHT+IE2AGO6ywhI/dHB2upvN59vMye+id8Rju4ZUaSDyiKR+AvfbNu4U/Ygf3J/9kgjN5fL8BnjVA==
X-Received: by 2002:a17:907:a4a:b0:b73:572d:3b07 with SMTP id a640c23a62f3a-b84451de1e0mr346186866b.28.1767817123622;
        Wed, 07 Jan 2026 12:18:43 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507bf6d5absm5582375a12.33.2026.01.07.12.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:42 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 03/26] libmpathutil: constify find_slot()
Date: Wed,  7 Jan 2026 21:18:03 +0100
Message-ID: <20260107201826.323977-4-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/vector.c | 3 +--
 libmpathutil/vector.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 3d54ed9..3e9f941 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -81,8 +81,7 @@ vector_insert_slot(vector v, int slot, void *value)
 	return v->slot[slot];
 }
 
-int
-find_slot(vector v, void * addr)
+int find_slot(vector v, const void *addr)
 {
 	int i;
 
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index 0701277..7b2c559 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -74,7 +74,7 @@ extern void free_strvec(vector strvec);
 extern void vector_set_slot(vector v, void *value);
 extern void vector_del_slot(vector v, int slot);
 extern void *vector_insert_slot(vector v, int slot, void *value);
-int find_slot(vector v, void * addr);
+int find_slot(vector v, const void *addr);
 int vector_find_or_add_slot(vector v, void *value);
 extern void vector_dump(vector v);
 extern void dump_strvec(vector strvec);
-- 
2.52.0

