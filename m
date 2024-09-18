Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89099189F41
	for <dm-devel@lists.linux.dev>; Wed, 18 Sep 2024 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726665863; cv=none; b=XyBtvqmSKfgSptPyOBq1H7HOVf3Oq6AT+dgsKHoekocOvuquaQdGidnOMSxYFNTrg8zmUXB4l+SZ+jXVGDBmp0NYmQ6Yf4ch/I+BAA9KMm2m0GuERkzHMc4Jie1Shu7G0qSzr/VhfRadocw+eunQrbbC2XMh24F2J/LK8VLk33M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726665863; c=relaxed/simple;
	bh=dNOyc6yx3NH63mp4ylHB1CXRSC1Yw4nnqKxpT7UdOEw=;
	h=From:Message-ID:To:Subject:Date:MIME-Version:Content-Type; b=G4ztcLbn5/8tY2QkSecrFWdYaWbyb+v9aiYpdo3KkzAW4KieRjicWu9Ol/+QskaLezc+8/IixgU2HQujEGpxNC99DPjKdFpQJqltPvTQbY6Q0eZ1e2l2lK97qm/CEvAFPboUZ4wRjD54hohvBfcB41W0vuU4ENVtbpbyzn1wTgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EH+VMIk8; arc=none smtp.client-ip=209.85.216.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EH+VMIk8"
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-2da516e6940so1218714a91.3
        for <dm-devel@lists.linux.dev>; Wed, 18 Sep 2024 06:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726665861; x=1727270661; darn=lists.linux.dev;
        h=mime-version:date:subject:to:reply-to:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MxitZxgmvoGPY/D0MWsatY/SG1INnyxTi18mvHYSZYE=;
        b=EH+VMIk8F6Ac8Z/pMrcx2w6AmsZV9mYJw+5WoTm3LKaiUkb7LFYYC9hABGQaATNwQ5
         Ar3xGxiHADtM2+GT0ALK/kt0X0lPkjAGsTWI6Fsojn99rznQHlBj0mbbxeAAvoSC0YL8
         kv1yPIpcobRMIKXvgphmMOcoXyDIk3vz0M/PkuHkI+w2mEH0TS26/7Vndm5Z/B+GJ9w9
         FYNsI9VwwJVibft/n/7hoqufiIs06sSrW+HVtCkrIrwGzopYK1n2v2hPV7Bi4K1ekcNw
         puO6qzc0NrbNxVcI8Ld5HYsKDbAyINDCY/3hlInTuRKGpeGdxcOPo4Q6f7XN81Kmh4iI
         q48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726665861; x=1727270661;
        h=mime-version:date:subject:to:reply-to:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MxitZxgmvoGPY/D0MWsatY/SG1INnyxTi18mvHYSZYE=;
        b=HFHkWVzCMxxwHGafqx9poN+A1q3GOjhyJ6Vaj1ixuVAjXkg03SUoi15drlrPOQ+usa
         JQ+aFeMN91uBRIE/nC+Qx8k/PY4MR3/VJYVijA0wwcKpLOsbEge0XHrxPMQ43VC+SgDI
         QuovK2to7ZNSbdKmlgIiIs5rEKqvw4XAByA4sp0PYDvk88BCABMEvkPLfhvdC2QsWd3y
         DV/NpTBci4Yxb39rhiltzMA0sJltaLmXLz5BH5GCgaewFsiVI7m+NEooOkX++nIrjORO
         J1AgKPZK5pEyiRp7egChVC1SnxZse6zvEFAVJSAtryGVZheqjORyJsXfllYwSmvMNLKZ
         yxHw==
X-Gm-Message-State: AOJu0YxmD8sKH3yqLmPixQ8lLgUZj5wh/0U0V3H+0FfGbiCHOsDGh5gU
	Mj+hiaCbAFcTJpGAw32AXmI1nFqQ/io6ujVz55rOx2X4otiEpF7AhozDTYwI
X-Google-Smtp-Source: AGHT+IH23RtCaLzgFyRLHmj47AKlBth1Vl7xiWRJlcoM4lChiK9fOms8NaHIraoOZLQScBAw6PBKaw==
X-Received: by 2002:a17:90a:4a97:b0:2da:5373:5255 with SMTP id 98e67ed59e1d1-2dba0078d03mr10336986a91.6.1726665861681;
        Wed, 18 Sep 2024 06:24:21 -0700 (PDT)
Received: from [103.67.163.162] ([103.67.163.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd608b64dbsm1599548a91.18.2024.09.18.06.24.20
        for <dm-devel@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2024 06:24:21 -0700 (PDT)
From: Michelle Fangman <pardeepbanna32930@gmail.com>
X-Google-Original-From: Michelle Fangman <michfangman@outlook.com>
Message-ID: <202bcce78eced8add6d6b597e6381c1c5fbd917b6b0e62ba443410614101182e@mx.google.com>
Reply-To: michfangman@outlook.com
To: dm-devel@lists.linux.dev
Subject: Baby Grand Piano  09/18
Date: Wed, 18 Sep 2024 09:24:15 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello,

I'm offering my late husband's Yamaha Piano to any music enthusiast who may appreciate it. If you or someone you know might be interested in receiving this instrument for free, please feel free to reach out to me.

Warm regards,
Michelle 
