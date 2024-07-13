Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655A241C77
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720869034; cv=none; b=Iu0ZjDYLFPF9ffkmTindHUUOFJhzNTjZKZYK78wfjQ+0DfaKMofJT7pVMjQtxO96Ki4aQgFwjYDcvMNX9FHODXFAe6w20UGoQgwc2lAcunTFpJ+RDbBWFrS9OqM1RAQag/A9JNwG3Vw1+e8xu9veGmxhet/ZFVLP8+r98DyOzXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720869034; c=relaxed/simple;
	bh=vNmZCEARofUlbRfz6OIEvi5VfWgo8Akr1zQwniLks3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TNzf+GupWajSUR+LxVOYmPuS2jl0OQR29kCHbPcPBVW7mmIEj3XRjSh6ms2o1hQHT/cWQgAzSOdYvMXewKDfscW2FN4NDUXDcwUZIMMQ6AEf++gV7GjzBArUCUvmxeKYnvfGWiSYQlJ9H5eTwI9JEqYGxW2QHmDKe1OM2QP7m2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iuTBJvkp; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iuTBJvkp"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52ea7d2a039so2957658e87.3
        for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 04:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720869030; x=1721473830; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y++6usS3zSR+0SK1480TAjLlscRgSvO8w1f6s4XMbo=;
        b=iuTBJvkpJa3g+ehIvIyDksBz3nTxmwhPVjOt4GB2Oz49g55O40XIjcdduadIDHY9rz
         4l+1S89KTR3q46SnkGeMSlpM+h6/+k/h/f2gGGoXIQoqHZX0PcTe9PGdbJysD3ktQPpn
         yhB6qcAXlNtaZ4XySKDCqen4VityzZz6Dec3hbvZvMYbh7inhCfVkM5vqDoGGTxKsR5E
         8EQDcxlpgGKNZ+8topYUsYJZiud9mZgrRp8duR/KNCRu6WxZarBkKgtLi4foCIZe9iqn
         yREde9U1w79KdEZj3KSXjuKXcKmzGPnL+d++HkihkSHgscpEn04SkxcA7izwaX4qIYiB
         rSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720869030; x=1721473830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Y++6usS3zSR+0SK1480TAjLlscRgSvO8w1f6s4XMbo=;
        b=hXaIqP9EVrMQ3XcCuofDh+MD1XeRec7lyOC1zF3wJYKeP7ZYuiZWPV5HCPzeZLi/9P
         XcBvVXzXUOG5FKCWXi7y3Mimz/oIzwLPYnlO3jWFILpbCS1L57nhGdgriJhP4G9fA2fu
         9fBx+8nXkWjApBRS3xut8k+MGnYHE6yQWPbJpDV2BOBLUB6rRYjCXETS5AyZi427rpY7
         nrzbs57SWt6gZy4/LFxUKQkQxG2skj7kczEdwct2d+00NmvCM6j2NVl5oinRpQgYmOZ3
         2GOSA3ub0M7inBuJeDDaChmVzvqP9yaxHmB8rY52QiDRGE2Zv8RgLFwfeLIwyEdQPIGN
         tsIA==
X-Forwarded-Encrypted: i=1; AJvYcCVDah1JFOmvuOFymGqtfDsINF6Z6aHlT58IBAXwZ4l0BhEQpDbWToVeDEEMsMiGV9tUsKivnNNRm7ytuDaTyQnHf98svb2R2lA=
X-Gm-Message-State: AOJu0Yx5lL7ft5FKM1fCaPHaMrbbnxWPee/1nAfKmGJl/HFXYhs7hCI/
	RHZmamBKW1Ir2D5ieUozvCzaT8YDV6r8CNZdbwLpv7YLe6MwW5U=
X-Google-Smtp-Source: AGHT+IHTpJdiTKqBA3S6Chsc99BXlQAtuK+d1DMwl4STj6IcHJufTKf5ZVt4m5FbR/41C0j0b8imJA==
X-Received: by 2002:a05:6512:3d0e:b0:52e:d0f8:2d30 with SMTP id 2adb3069b0e04-52ed0f82f30mr1455665e87.59.1720869030104;
        Sat, 13 Jul 2024 04:10:30 -0700 (PDT)
Received: from localhost (14.red-81-44-167.dynamicip.rima-tde.net. [81.44.167.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f27877dsm50538085e9.26.2024.07.13.04.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jul 2024 04:10:29 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 0/2] multipath-tools: add more HUAWEI devices and vendors IDs
Date: Sat, 13 Jul 2024 13:10:19 +0200
Message-ID: <20240713111025.104048-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Taken from Huawei UltraPath multipathing doc:
https://support.huawei.com/enterprise/en/doc/EDOC1100362072/4a563777/showing-array-models-supported-by-the-ultrapath

=====================
HUASY   Dorado2100
HUAWEI  Dorado2100
HUAWEI  Dorado2100 G2
HUASY   Dorado5100
HUAWEI  Dorado5100
HUAWEI  HVS85T
HUAWEI  HVS88T
HS      S2100
HUAWEI  S2100
HUASY   S2200T
HUAWEI  S2200T
HS      S2300
HUAWEI  S2300
HS      S2300E
HUAWEI  S2300E
HS      S2600
HUAWEI  S2600
HS      S2600T
HUASY   S2600T
HUAWEI  S2600T
HUAWEI  S2900
HUASY   S3900
HUAWEI  S3900
HUASY   S3900-M200
HUAWEI  S3900-M200
HUASY   S3900-M300
HUAWEI  S3900-M300
HS      S5100
HUAWEI  S5100
HS      S5300
HUASY   S5300
HUAWEI  S5300
HS      S5500
HUAWEI  S5500
HUASY   S5500T
HUAWEI  S5500T
HS      S5600
HUAWEI  S5600
HUASY   S5600T
HUAWEI  S5600T
HUASY   S5800T
HUAWEI  S5800T
HUASY   S5900-M100
HUAWEI  S5900-M100
HUASY   S5900-M200
HUAWEI  S5900-M200
HS      S6800E
HUAWEI  S6800E
HUASY   S6800T
HUAWEI  S6800T
HUASY   S6900
HUAWEI  S6900
HUASY   S6900-M100
HUAWEI  S6900-M100
HS      S8000
HUAWEI  S8000
HS      S8000-I
HUASY   S8000-I
HUAWEI  S8000-I
HS      V1500
HUAWEI  V1500
HS      V1500N
HUAWEI  V1500N
HS      V1600N
HUAWEI  V1600N
HS      V1800
HUAWEI  V1800
HS      VIS6000
HUAWEI  VIS6000
HS      VIS6000T
HUAWEI  VIS6000T
AnyStor XSG1
HUAWEI  XSG1
Marstor XSG1
NETPOSA XSG1
SanM    XSG1
SUGON   XSG1
UDsafe  XSG1
=====================

Xose Vazquez Perez (2):
  multipath-tools: add older HUAWEI models
  multipath-tools: add more tags XSG1 vendors

 libmultipath/hwtable.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.45.2
