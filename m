Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DC4338900
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817134; cv=none; b=d5/nu/L+D2rw0VDmvFCkcT1tKW4PFpxZl2f5cDzhhZtzGjNYkmhDQwxCpmdK4dY/egrXKWvguy/zVxmVqJNj8Wz4hdDw8HXndZOvh5LPpeJBPbRNT5OsRaQYFEpfJ2IsNKEpXrjdb9aassVto4ePOCmxUpYJPp1FJ0kWqDe6D68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817134; c=relaxed/simple;
	bh=uN2mCeXtRibj9AoN+E6ERWnYGdm2jqUdEulN8iG3EqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TavO+vh6dl5c7h4vnBQ1QgxfZcurnq2WxMnogcKOoRyN5Ccdp+7tkSmDwSd0bTr8PuLnl3Zl26CWSqvjI3XtiwC+61gmhGP/McofbHoro/rbprF/MdVrErKjyeRZq9ShUckgB5aNl9mOBK3cwYQv3wsbKhYkqWsxfY4e0N+wZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tdl9UIa7; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tdl9UIa7"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-650854c473fso2417678a12.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817125; x=1768421925; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMcRyTFTGxAOGXL5IcAWWxOAxT/SWcUnPNSK92kiDhw=;
        b=Tdl9UIa7VXaf/T9L87/iH8P+sHByvNwARcscVimq4so+bvchEry/5DP1MPrFLD3ADg
         hI3MbyYqGEOArg3asMigxOJ5gWp3NuC3lDE29EwyCwRdhwDZn/5L7Rc9b7kh0aBfZWVx
         0lmT+xt/blb8KDpFYSTjFxSK6sUb59pV3N/FsEniEe/5nwz3h30+k5oE+c4178Mnme9e
         Il3wGSFD1T7yxJrfGzOsdwhh9mS3ANpwUtWDE/C5Kv/vVDO/9PWe8DJh1+vxn8RuPZer
         vh35FpWTlDxkLF8Ta/3OWeKh5ZR9vDpD7axzz9yYNK53m5Yw9PyaoxVM0IQzI5vLDM9v
         90+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817125; x=1768421925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NMcRyTFTGxAOGXL5IcAWWxOAxT/SWcUnPNSK92kiDhw=;
        b=b/v99aoNfPRDTvLrq0bWAg4fw7YCmPRdYRL1NPyKvHiPqngcQB2Vcovg34QjzulFAq
         53qe273sD9dJhqH1jt4KGrt3++PfRN9svO2hfle6fLf75MYtNbzRJ5yro1l2ahFey8hW
         eKmoApJCUSnB7Rp8CGjwhRaMTp+fYuTebfM3r586vH3lEHsl45/a5Kzjko91c1zIPgw7
         D9XkVUc36XglceDuanCvT0oxnUkpA0mOLx+2rbJxkEMvfbf4WMShDjXLKQs6FjjZeDfO
         Wl7Rw4U/yhV2AxxquDM9GbLFs7u9vSaE00uBNLymdRQOdL7d0L4FTwgPhnbg6NkvaBx8
         qc+g==
X-Gm-Message-State: AOJu0YwXHZmNLf6FQQbp/Nvsbag9zzIsnQJNs/dbEZ6T/zNxjGzCw5yq
	8COr09bfyK4JivypI5AX2LfLindBjSwUxd1fbZTA5MfET+zeyybrH63VUsKFeSLSmkM=
X-Gm-Gg: AY/fxX7ctPlOUi9FgvjHE1XGh5M2ttzlKUco6GuPQp9MZkELan4c/sNcHcvTe1H5mG2
	clqEa91XUzrVJEZNc84FnHYT2fW/hxP65gkPUAH6GAlnKZVsOIJjqeknAfUaD1PviI8oxN4fV2w
	RTvPC/EPnCKKworrhcuA65x+r4o3Mk1Jd+k39HVmjA23e1PeCcwy0ELaYOaZ0a9Ty/lysQH4ne5
	ZVgMzu5iAVKSM0qHTUNKuFtq44yvRBO78lEK1tgIM0PYLbmVlUkntFCErsMyoXYXcsP+MGawkxL
	OclciZIYgPDf54nZpUQVVSdUndYf07R1QF+Ugi6fUfOfn5jDEC9ceBkH5/Gs2GFokCbMaC2LFvT
	MEnpdzqKJr6kwWN1jWTh/YuAwliOOKFcpn3dUY0ibTkzuvjop6tYdZ4PH3zWDOseicRbZlfC5Oe
	PEDFx0aHyGvYJPmVisq28vaXcVXMWTfuLQnbRkM82U5buXAr5wIkZEqNxm4qKHJ0zrhwjX8sDv+
	w==
X-Google-Smtp-Source: AGHT+IHdmc3XnrKEiwsTaHQiZZZ5bQ1M4ZjHqQ8yMK1aK9nCYkaXs7ki/Nqdb3IqUQdb7vt/9YsklA==
X-Received: by 2002:aa7:c513:0:b0:64b:aa44:dea6 with SMTP id 4fb4d7f45d1cf-6507c16e5d9mr5067984a12.15.1767817125605;
        Wed, 07 Jan 2026 12:18:45 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507bf661fesm6166599a12.25.2026.01.07.12.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:45 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 05/26] libmultipath: export cleanup_multipath()
Date: Wed,  7 Jan 2026 21:18:05 +0100
Message-ID: <20260107201826.323977-6-mwilck@suse.com>
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
 libmultipath/libmultipath.version | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index e971af0..e37e9e4 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -68,6 +68,7 @@ global:
 	check_foreign;
 	cleanup_bindings;
 	cleanup_lock;
+	cleanup_multipath;
 	cleanup_multipath_and_paths;
 	cleanup_udev_device_ptr;
 	cleanup_udev_enumerate_ptr;
-- 
2.52.0

