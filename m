Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABF8C8FE
	for <dm-devel@lists.linux.dev>; Mon,  5 May 2025 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462636; cv=none; b=EypJlO8zNxHCLJfzIHYvJRHG0ZOslTXFKVgHwGNt2I0PYEMSDn5bRuQp15gpMcw8YRbozYDcY9CIwrC4h3g9fngPPkYiEzQNZQp1ORRLa7stsM3K8kDiqK/jNyQKdMSUlKcJl9TZnILizlUuY4WW7chdUgydPlmHbZ1woqbv+1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462636; c=relaxed/simple;
	bh=2y+2rni837o4vaYDuaWhLUGGEcZVxBMW5qG8F5rcABU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujbfplWWFy4Xxl7vBlONhnvUnWU7NxZ5KNDPcpZxigs9+PeJ2AbR6CyzJOjdZdR/PEgmBBG6fYXWHARyG8CSB8gqa+jjNwFjWCVGzPIGrSzP+M63pZI1jtkG5MMl5C4CkThCUadMPyjAFLjxGpC68diSPzsJPasjLDj9ha24I9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ffc+B5Rn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ffc+B5Rn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43ea40a6e98so40596185e9.1
        for <dm-devel@lists.linux.dev>; Mon, 05 May 2025 09:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746462632; x=1747067432; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/+8eIwIxkK4mdjWNZd2whNlnZReb1qalX0RUY8u/lQ=;
        b=ffc+B5RnJ5R8bffMNYBU3nlqm8OMLfowbplJR1GoO//4skxEJOn8Q36smbYiiKhY31
         scpunNoE23JcIIvHVUJudF4MyLesCmSMYVybYM/MGct6DSzemiXU/Tn255cTCrfmIcv1
         W6dcuLJhu3igTNQ51UVMOjO1mTM00+ZcHBPDRLuCem0lArqVgTmyYc3LncvrTvpvuNVV
         UknouNgwB0o6KInj1uVdRXU2khfWHW1csVdrb2IgPEmEMgEjk6aES9FsHKXcwYHYjmBp
         QwlTDZvni/LHRXmbgYTouelqY82i2yDsCA3b1i4XJV8X7aj4hw46kQn3HEEqPZ77ezDP
         SI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462632; x=1747067432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/+8eIwIxkK4mdjWNZd2whNlnZReb1qalX0RUY8u/lQ=;
        b=nDKM88BxrlAeqVb2JkU+UDLOAUhOFWefZlA+DJzvpZXsSZK1UEMO1QEzmcCL+th/Nx
         C4uhRGwkfy0J2E12f8E4iOoabX+WkVDhvEclWVF3iIwEyMurdvgqdL4UEy1wJq7tpTV0
         JMff1y2s14NPXFdI0Ww79EUBQZjhkbrG2mpel0QMo1JoypFHhTmjWN94JUTPj70voPwP
         zmdUpYi96+8pgCfLeYjv7oCnE8tO+9AQ22FIKD/dYvXqC/tYUaPhi9FjYUBS1D2iH0O4
         rRjh54hipcpeNaTtkJvImkeVeTrqo3T3jmL1MUbJWRMKrAJV817yBj2VEhtfsZvaeJlf
         6iUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYoh/gFssDyDxA6xINQhheHziExWm90vcKXuUDP2gWlJm7NrbKaVyG8IpLWumtF88zLvOKHnS5bw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxIb50aSeuXPhjOkLqgIIeGvrhfDWUSiPnn7AlaIKzh78iTSZfX
	feQ5K8ux7YdnF85BFZIHA8hYxsx/dPto6foafFefsvn38INPtLH49ZsYChGQn5o=
X-Gm-Gg: ASbGnctF+/HjwMgBAdQIaI1xeTN2jhcHTx0onbwIIWewiES8nGfN0leMYtxFbuhQYRI
	46gS5+vELODHeGd2cokOy5RPQN2+4VhLu7QR27zINNXeqPr8lsLw/c+QInzSOub2DtsrAPr3ToP
	lXALZtWuLFvAzOz1sILVLM8gomM35PVi72x3JkBQ6TykwAHeMU/prDeOtSDqjKz35Aww3nxaYiy
	Mo7QztQGMvOeH63UoHOEAgYHkCdVFcXiU7NYvO9efKpS3t8yKzn9jLuiKVGQezs7SGQGca1WX90
	ja6ukl8EOOqteY0Z1jcyeAUpItNhYzuXK1NgQCf6Q9M5CapKWl/oXYalM6GG9j0AbmIejAu7kwN
	AEecvclwY8wYT1aTVmPrOgoRBQYu0
X-Google-Smtp-Source: AGHT+IGbK907+aKtvSnvjrAP+BmA9xKnvh3psbUmUp3hROQUCS/NJyHOr97Z4dpW9AbcD0dy5kytRg==
X-Received: by 2002:a05:600c:4ec7:b0:43d:1824:aadc with SMTP id 5b1f17b1804b1-441c1d73a7emr78507825e9.29.1746462632099;
        Mon, 05 May 2025 09:30:32 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-441bc23bc06sm118027155e9.24.2025.05.05.09.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:30:31 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 6/6] libmultipath: prioritizers/iet: fix possible NULL dereference
Date: Mon,  5 May 2025 18:29:58 +0200
Message-ID: <20250505163007.59352-7-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505163007.59352-1-mwilck@suse.com>
References: <20250505163007.59352-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/iet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index f3bf64c..f5fdd42 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -101,6 +101,8 @@ int iet_prio(const char *dev, char * args)
 	char buffer[BUFFERSIZE];
 	char fullpath[BUFFERSIZE] = "/dev/disk/by-path/";
 	dir_p = opendir(fullpath);
+	if (!dir_p)
+		goto out;
 
 	// loop to find device in /dev/disk/by-path
 	while( NULL != (dir_entry_p = readdir(dir_p))) {
@@ -135,6 +137,7 @@ int iet_prio(const char *dev, char * args)
 	}
 	// nothing found, low prio
 	closedir(dir_p);
+out:
 	return 10;
 }
 
-- 
2.49.0

