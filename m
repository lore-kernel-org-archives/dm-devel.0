Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2556927AC31
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 21:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779484241; cv=none; b=bH1NhmvGAKossJeKBAJR0cCsM1nfwJhtUG2eohY8BTXeZlL5BDgYlY1tdbyjZzG96tpz2baVqgIzxMjpD87TcPm6sOHaTVGj+86+5jouJeO6zPaYmJu9Dif96haciQsXo7W7NrbghmgqpgVE7V1AXw/41V8BKf1lSRQR5YUCdFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779484241; c=relaxed/simple;
	bh=XM06oqCrFOqxADA5FIl4oxKiOh8rHCuu6STfOGMVFZ0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Zqf8elVtRjxGD9Rrv4X7SSG1NqG4JauZSS/NeKsM7EzjHI7UkwABXKF3wyXpo19j1EDA71sb2Fb1qTDDRyL1dNOlfJ4HaoHKR9dQDJvUMOgw56QkBmysqhBHPkNVxmwZjg2Nq+0H4c/Vxfd4K/tiDUOhzPLDhqX4rCnG2Tw0W7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jlXUfBPI; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlXUfBPI"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-44b7e8b65faso593350f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 14:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779484238; x=1780089038; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XM06oqCrFOqxADA5FIl4oxKiOh8rHCuu6STfOGMVFZ0=;
        b=jlXUfBPIefpwnqvyo3XTfMC+g1DDBJVvKZy9Z/tw7vUsI/MgCgUc8P3uHPLGoZWQeD
         vTUSoBYDYLbZ2/Sbr+CUIS1iYrFZ9m6/5JROMyRDyqqiss3VXhxfdfQmFQiAwp3cJVi7
         7B2MMrX6GSeKbFikZSJfNNLfCCrUeHmqGuH5kRZ7V5Hk9LzKDCwxI2ww8QaeDRboxEEh
         6E3f6On4zzis7QXy1MeEQ+yjoFjio8SMlh+Bx2nCy+R69Kt6K9w0r6sMoz9d4hps7M8v
         KxwqdnF4Vx1pYZWwVmsqFCNaNdl26rL0EYNhw0F0n18QQXq72Jy4nERztK7k8pN4Aujg
         OIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779484238; x=1780089038;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XM06oqCrFOqxADA5FIl4oxKiOh8rHCuu6STfOGMVFZ0=;
        b=q45w0FwJL+SLWgBkGBxnN3ifWA0QB3VNW/0hEdREIn3h8wnKdXjbsA9uz9lYyGpqW6
         +fMHy6xPSk75Q2VNGitbNquWckqgALv6qjPRBSkt/b5MQet+LNSjOJIh77bGjxycdDzJ
         EY9Eu9cqZBNsyFJ7BfWm7yZAHaoJMsqcK8klLxLBf6lHpSH3cdjfx1GyqVGM21Jyj1Wj
         CsQA/25MoaiL4EZsQLuAQaiAmJfWDzKymSCtWawUHHpLrEy70ngcQVJLbb7NZn2EG2He
         oHqtjpeSlS3/8r4R2Bw2fQf5Ii0TkEgGWWugtr68wQx2uQjoLHEutNrqbKeuJkN9NYiM
         tmyw==
X-Gm-Message-State: AOJu0YwpCGWKIW8DaY0IsYagCm44dkROnwNVbkr/waxjBpEHQouak51Y
	obRVEULug19iiUYIW/zAJ3rYQbElV+x+TWjZcvdrGyhtTT10MTI83XY=
X-Gm-Gg: Acq92OHKBrLV0deOWG9PLpWzcTHidZ2ViPjAXcLY2jfc0W28yyhdwpTs+eAvJNY3EqU
	ir055q6bIPfB0HF5KPnmE6gcivBhKhcSijNuu8x4SEGFiY8i6+nRjCmlJzehsqJOaKU4kWL0U84
	iGOT0Zh6Wt/w6RIp895kPME98VEPz6r07ayughfEzJzuXftyJw/Ji2KfHp66m0eeFjrs3D67XZM
	1CcC1Q75zYJ6Un1QwJmrvFkPo+il+2pRBDqqYq8go5xwBDC9DYOC8Ka0DWqMXlg961eRruC8qjP
	1goJQM8aXwjU2LV63gPtT25gJPuStK48uQmcN1wnFTOQLibSc1Hs5sNXRRjlCrlBKeU1cx89g6S
	qSOE1PROabg1egZmvXSty6V/q185hDOyoAcSN8sqoO/aIODSvDBGwrg3Z/m2GaQbxTUGTLkxeXu
	1M1vGXU6Mu43f4gqdc/UawJXYfNnvzmDiEepZxpwglaOmvqcrWPpq9tmEe+Yp/
X-Received: by 2002:a05:600c:b96:b0:490:4923:aa3e with SMTP id 5b1f17b1804b1-4904923ab35mr17780385e9.7.1779484238259;
        Fri, 22 May 2026 14:10:38 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454a0b9asm65790955e9.11.2026.05.22.14.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 14:10:37 -0700 (PDT)
Message-ID: <02a2bb69-c13d-43bb-bbed-2a1bd3007ba4@gmail.com>
Date: Fri, 22 May 2026 23:10:36 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Language: en-US, en-GB, es-ES
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [BUG] multipath-tools: 0 cyl reported on large disks due to overflow
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

An integer overflow occurs in libmultipath/discovery.c:get_geometry() when
querying geometry on large disks resulting in "0 cyl" being reported:

# multipath -ll -d -v3
... | sdgm: 0 cyl, 64 heads, 32 sectors/track, start at 0

# fdisk -l /dev/sdgm
Disk /dev/sdgm: 12 TiB, 13194139533312 bytes, 25769803776 sectors
Units: sectors of 1 * 512 = 512 bytes

# dmesg | grep sdgm
sd 5:0:3:100: [sdgm] 25769803776 512-byte logical blocks: (13.2 TB/12.0TiB)


The root cause is that struct hd_geometry, from libmultipath/structs.h,
defines cylinders as an unsigned short.

Since it is a legacy interface, it should either sanitize the log output
or avoid relying on CHS geometry for large devices.
