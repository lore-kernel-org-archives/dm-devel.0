Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28EF394490
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 08:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790151032; cv=none; b=na99ZJMqMU/e/mH18EwOAIvJDQ1XltdldKijfQwcRaWF+ueKnl9AHGzNU+8bgc7PPgoav79mPPjeLdbhrko/gfODpGrcPbB2738y0HYZ7o568CH2suUf8/NUDMh2I+th0Emfb8/ZdkcQITJyUQ3gPBiyirt38Aun3jfLXuAEFuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790151032; c=relaxed/simple;
	bh=OJ4lfeqD9im+Foc6CNC2HRl00ysGMYvZl2GuC3Av6WU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ph4hOJpry9nkPJ1SpUxuniKh3fE2W9PlkBXxgufDhjvcSbwCLrMF7P+4pi/SC8aNgj/j62uiZxzK32XkTJ/rExpYYFIEHq8tDH8blk5Eu1kOLJTbgLe4UHPvluRRiMfVNnPbvwAzqBAcU+IzMyQu0GPyC0te2ZYuBzGajsoEdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hR7bRGz7; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hR7bRGz7"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccd4f99dso447294a91.2
        for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 01:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790151030; x=1790755830; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xhNFDOl09aEMZ8kpRAqjjIB77iovlB54t187rXigIoI=;
        b=hR7bRGz7GhWWD5Y/N5VDJYJgvbgIH+oqIS/eJbpWFW0Os8sHF5CtqM6boOjP8tWW76
         g4PFq/tW9V+nnrsvxo9F8Eis/kj06Vm5y+9frGRz4Kg4h2pW3ilYdWPZUinIhLg4GSnM
         yuxUAy789lsv+I1o9cJW6abwqjqbriSRooVki4ZBl65SvJkxYIFzLJ/+7fop3yFr9Twf
         gLDfwXFDrqhc7V800TDGsuvhB1+pDK+0KWAakYOK1ldPmUbXsRknVNwiRBtdYb9suyJe
         wD8aZ7FExC78nOYrRGUpc3c75QbRpkxdNgCmSLsYHQZFHTraX88ahVmLw1i87K5UqLtd
         PZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790151030; x=1790755830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xhNFDOl09aEMZ8kpRAqjjIB77iovlB54t187rXigIoI=;
        b=ShetOk9JIls2GbMPLqCG2yuBt6UtH2n0Cwp5eTq8VLuOkCpy6OMjkEtW5JXqYvc1Uf
         l+d6UAQRg0cEuEIl6X/xoOxQvsfDbnETCiXi00uJDstk0gWDLi3XeUZUxBbDgEzrrbQD
         FpPvWYoPbuklxmK4yei/sLh5gTolJJYPQQm+IUyHpJUPHXB8JC2OwHTo+oDoslXEipb1
         G6JP5fYL1PrypcFzjp0v/OvhRHhvhxxhMk4XH1F9IpEtl2NRF5P/eklGYGT8Idb242x9
         Qf18ZL5/Wrgzkc/uKGs1E+ecl5c5MOMPvTwctbam0S16R/9GYR3FhUtpEWvG9UEbF/La
         ez2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwIu4STLFrMZ3gt0UZxJ0dZK4EzWqoxdneJgPdtXzQ4pWDIlF6DcalZyJKF9nZQgxPF7coAU7OgdQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lsAwnd9dfXa2rWRlHZWErJlhlfDg43Umyx4OURGm8kH7u5fJuA
	GMX+UQW/eEDu+C8CuURE8PsIRpjO1vs6VYzwrJfjlJCRboFTM1YsqT2B
X-Gm-Gg: AYBFou1if/WZIulIM8eXiBbCMNz+b6YvLtzvW5LUFjwv8UXVJk+qFo8wYbAVgnQjZ5x
	XWzNed16zKYpMXSxlqfVP+18h6EG/dK4Mzx9Sn+Tknvx9PhmGn2IdGaYuu9oh7ofHn+NbwHtXXP
	wygt0uM7Fild4QmK3Rm9iV+bW8aVqbIADhXewphNLIvPfmBvIgDtqye+zlG7i9MMKQKIbLoRIsF
	B0qjnDQVBvRLCaY3LBHEIYqsxcHPPnZxp3b41jYCVzCyyRdvRjD0zoV1fsP9VgufKduqc/eOP6S
	VwiZSpVeBR+UHjd43dLDsQOsraSKUIy5FMbPRZWzvJPNmO5J+G0dvYwe1KK6ETYp4IKPtvLuRZC
	oNRrz3hdtsETfbMtYIH67WnAqEuhTBgBu6wXvuY8DTAtJ6desmtSzxbrMkbV5x06Tx/nPByDSrT
	UDs1sMyMxmgssFK/wZusoNUqHIpchelU5InACDQhPoGQAb5regtsHZOOY/ee4eBp+ZN8S1RuAO6
	jJEw7ysqBO4hGJQVPIRgX76ag==
X-Received: by 2002:a17:90b:4c8e:b0:3a0:3700:fe9 with SMTP id 98e67ed59e1d1-3a07e6410b0mr1649244a91.36.1790151030164;
        Wed, 23 Sep 2026 01:10:30 -0700 (PDT)
Received: from flow.bytedance.net ([203.208.167.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07de20ecbsm3726373a91.13.2026.09.23.01.10.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Sep 2026 01:10:29 -0700 (PDT)
From: By <xiaobai050@gmail.com>
To: agk@redhat.com
Cc: snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com,
	By <xiaobai050@gmail.com>,
	syzbot+665bae0a102933788e1a@syzkaller.appspotmail.com
Subject: [PATCH] usb: dwc3: pci: reject matches without software-node data
Date: Wed, 23 Sep 2026 16:10:21 +0800
Message-ID: <20260923081021.89508-1-xiaobai050@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A PCI driver_override bind can reach dwc3_pci_probe() with the dummy ID
from pci_match_device(). Its driver_data is zero, so dwc3_pci_quirks()
passes NULL to device_add_software_node(), which crashes in
software_node_register().

Reject the match before enabling the device or allocating resources.
All static DWC3 PCI IDs provide software-node data.

Build-tested with ARCH=arm64 defconfig and dwc3-pci.o. The runtime
reproducer could not be run in this environment.

Fixes: e492ce9bcaa1 ("usb: dwc3: pci: Register a software node for the dwc3 platform device")
Reported-by: syzbot+665bae0a102933788e1a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=665bae0a102933788e1a
Assisted-by: LLM
Signed-off-by: By <xiaobai050@gmail.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 6c1cbb722..d7fdf6ca6 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -335,6 +335,9 @@ static int dwc3_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	int			ret;
 	struct device		*dev = &pci->dev;
 
+	if (!id->driver_data)
+		return -ENODEV;
+
 	ret = pcim_enable_device(pci);
 	if (ret) {
 		dev_err(dev, "failed to enable pci device\n");
-- 
2.55.0

