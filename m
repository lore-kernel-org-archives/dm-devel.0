Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DC5338582
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817125; cv=none; b=osYjGmbudXiLrnArt3mY+ciu5cg02aOkymWmH3p8c/DTNyGm5GYxHcZhSITEXf21mhGyWkgqT0NEcFRG+LmZhHUG0zdFkcTEJq3T87vIH8QsRS0e/FmGgeFXTY1pmhn3KIjO636PuPxxqy1R9lT0XWCyj1JbAf9hrphS1+FBk2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817125; c=relaxed/simple;
	bh=eo3u7f5Qa99k1dhUAeEXGPDOKDwn1WZU3TAaj0JV5so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhYiE80jxKfJAjZeMNYVxdyYEfdnlD3HyGfUFbECavkxG9WgGeWYoqz5m2/jP7i50Ix57dD9WhfQ3GOGPQudWIQteYaDAgqTxL4Y2Q7JcE9gAfdmaD80X3bY3O6XFMF3U2e98FelWBic4mWUVu52Kxgg2yuKTyZ8Z9/XAhVpoL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JG7w9sAn; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JG7w9sAn"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64d4d8b3ad7so3805854a12.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817121; x=1768421921; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wO6+sKjgYCE+0Jb39O7QEN+DAwhOPH/9wWP9XP540Lg=;
        b=JG7w9sAnrdOXwwnLT8j6fLQWyTql/kfwrV5LADGBvQWWDRQqXFIUw+y5XkmWFniNUd
         7wLDVC3RsLPej3OWDenhZnvvRgB4qR7NRdyl8tRONZVBv9wE9isn1O173uOSGUi6hQ4a
         eQohwGifqCUCAIM9RtMOt2rN8lIRGWhzr2xY96447oF09g6AlVUVY6sIkbDkM7IthJPS
         cbYJn0JTAq6oo+9WKws6b4cXr0rpV/fwr0t6H85k89tJysQWD4kvEGR4UtoSieYTfiH0
         +XPqnwhXIk/0zMAeQEZo2UfyakLep3TlVYvJtVMU6NIftsfmDDuKrYVYUf5a6hVrrYSy
         6q2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817121; x=1768421921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wO6+sKjgYCE+0Jb39O7QEN+DAwhOPH/9wWP9XP540Lg=;
        b=Zn1GLa2V98ZkXMnLo51cCgQ4D4lQzSB+yhL9siF3rCkufWwcRqbkt9ff9oEzB2wfeV
         rHqpNuhlzu38ZUznmQ+ekd4VqdYVgJMUYvGdUvJMeXUaQRWf7bYEQATXloGc5G+ztINa
         tKVCsNeN74KJ+YjlGNYAVv12Dh5JCGpKxkWCtRIzc69oPmHWLcNZiv2Op8P+ESwlPla6
         AeQhwMPhSncPo+Cpl297dKsVXuw/iOMmLAP+wMrfUWf3xuKp/9oosQu2TWUN4Pp87Xjd
         0+JCJuu60efvbj1D7+FiTKhWKLBCGB1D1gJKkslHBATdYcKUEQI3Dz+1opbqV/Wueoc/
         JQkg==
X-Gm-Message-State: AOJu0YzVrjD4XybL3/agPIVHU2fZW3a5FdMAM82VWXzq3v5VGUa1hPbv
	grzE1vECAAxsyCME/TcigBVtrzssPk8wTD6Uijc+nou1DxwcsegdDR7737yaa7YPfUo=
X-Gm-Gg: AY/fxX6nlw4OCYGQnwqtgFJZhbVh9GcO3+atBBysQWWA8HvsuykoGZYaAgtdAoN1rN6
	SZnCyAbAMm1c/ZenhSSgMBtqYtmS50ef6EwpW4RNEk/TKd7dXM0C2e8UsXB24KyxG9ES0ypKHzj
	dA1B13OPaJD22C1X6P9vHstxjt9k0fdn3lxK55UVGCu09PNxj9Mi0j+BIaspHVNWviXS79M1lMY
	pQNOv+2M8e0biW6ieDjMvi4Md9GSMBYyPiIjJ5kiWoAieiVfC1UNDh1DQFRgAxoY1UVBLpFMLNc
	v3+svJrQw6p6+h9K5fb025Iig5VVZCsiVWPwfNONONznWt7e4fnWBLIlFldVvsDOuVGT+VWdZPt
	euKCpgpkShEY0T5h7a8BvfrHk4U/+ijIJWCvKl2k5sA+/Vv8jb0jU4ju+ZdxdT+SY85NIaZ6SGY
	qeMT3JcWfE/+leAXEsRLWSqEXpMTCMBwkzKc1YdeskkQyknabh9sso8uKeO5HYKI4exA3Vddj2k
	Q==
X-Google-Smtp-Source: AGHT+IG3mo+Q4Xnv37DG8hX7vtzEY4iFbxXH8qYpON3nLBfKhRniIKIKgy5oHcgYOr4YOh+hvvP5wA==
X-Received: by 2002:a05:6402:524e:b0:64b:654f:8738 with SMTP id 4fb4d7f45d1cf-65097dfb0c1mr3108100a12.14.1767817121205;
        Wed, 07 Jan 2026 12:18:41 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507b8c4048sm5729993a12.2.2026.01.07.12.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:40 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 01/26] libmultipath: drop drop_multipath
Date: Wed,  7 Jan 2026 21:18:01 +0100
Message-ID: <20260107201826.323977-2-mwilck@suse.com>
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

This function is unused.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 18 ------------------
 libmultipath/structs.h |  3 +--
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index dfa547b..1cbbea8 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -353,24 +353,6 @@ void cleanup_multipath_and_paths(struct multipath **pmpp)
 		free_multipath(*pmpp, FREE_PATHS);
 }
 
-void
-drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths)
-{
-	int i;
-	struct multipath * mpp;
-
-	if (!mpvec)
-		return;
-
-	vector_foreach_slot (mpvec, mpp, i) {
-		if (!strncmp(mpp->wwid, wwid, WWID_SIZE)) {
-			free_multipath(mpp, free_paths);
-			vector_del_slot(mpvec, i);
-			return;
-		}
-	}
-}
-
 void
 free_multipathvec (vector mpvec, enum free_path_mode free_paths)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9247e74..e7a0585 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -582,8 +582,7 @@ void free_pgvec (vector pgvec, enum free_path_mode free_paths);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
-void free_multipath_attributes (struct multipath *);
-void drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths);
+void free_multipath_attributes(struct multipath *);
 void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
 
 struct adapter_group * alloc_adaptergroup(void);
-- 
2.52.0

