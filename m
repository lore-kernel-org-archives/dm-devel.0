Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B151123A0
	for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 23:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714261814; cv=none; b=lCk15NVRGMR6owgtBe6EC+AEzWHdFJsx7LGfLaMfCARijsL7jQkOy33EOlREJRFP5GqW6JGrWRoblcag29dQlisHOLqc2gQBrMrpu33+PzPMQkjUfFiWMRUgsYy6w7O6py51L+kSI5gKoB2Akb+uOlOQwZjjVkSHYqR8B5Nt4v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714261814; c=relaxed/simple;
	bh=Oanfkn1WumPD4nnUflSdIeU9zyHsSjQODo8UVniaG4g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TIe6oZcBgZJQQropAXAsN2oGzpDOH/LkseIT21lYN4wMnHe/gbT7HgaPtPfOgae2BKlXVBV60cC+hmnX8tFtMtcHUw5bAg2iToN6fLWdRnfNmGkXdaAA/LCHN0rECjOgVCN3IRU/Hj0UDTo2K0JI8/9FJ3aroxZZ4jJxby7Ci5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNNrn1mN; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNNrn1mN"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-343c7fae6e4so2780943f8f.1
        for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 16:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714261811; x=1714866611; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h0L8OVkZKjZMW7Awr07vjVZrU2gx/kh84Ve0ozzCbF0=;
        b=WNNrn1mNmx6CaOjAa3iAmLWneSYUPZHBUoQqNkM9na+F7NneJIUzNy0WkGYofCi523
         z5JJ3xyPApUNh7vWgUy/GaNAOYZJAqChX4VWEyx8WWuaTue3EmN1xNVZEWRHIVPgIP+l
         jtWkQZzCV68jMjThNyzTgajriKJfPr3RQngjvhO2CUU9V88fv8vHuyTXZwRIc0nRIla5
         w41cyLUbCNQkgvBguaYkj90krY5ajvT0CZaUrv5eQiCV3d16qmBLZq3HYbxzoT6krzZ/
         QLmXvLuf/DUEj4iR02cp5H5FpzxVsRFkaVixTyoMenzfPvLgPvLzMNLeepPeNrTsOttj
         Qf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714261811; x=1714866611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0L8OVkZKjZMW7Awr07vjVZrU2gx/kh84Ve0ozzCbF0=;
        b=H0iY14jr+27gUCjDe/aP22Ay75nADHAeJju21Uw6DBak90D3NEBD5G6shkuaNqBuv5
         8Aq3xczRI9ORvelmTEMRLEAxKJgnrEPJ5Kqy+2dE7rNhbkhWvxgO1QM/YwI6XSoaRKI4
         kT/7eHHzrFL/hQap93FR9UwVrNJGbuH2+mWOHFh8POwVfQEmJ3vLS8Bz84qTUPihVGJN
         r50hue2G68LjRPigEfUq7qe67UzCBTCKZSDnQiP96y8A6ctiUFDc9QRcEZ4SyqmZD0k7
         kfsx9S49dHzMpOvwI3Xtrs6fHr5Ptl5xrvM4s+67RUe+f7WGJNdM1+88iSR35poPjaQr
         cY6A==
X-Forwarded-Encrypted: i=1; AJvYcCWWVbskqfHP5x5axffyNo4wrlM2oAGaiSNhOV+9eUrh9fkQM09Mx3hVJ7OnvJhf2o+FzkXfwUgPKrdG+qiD1sj7p0NsRfayjro=
X-Gm-Message-State: AOJu0Yw7GwwQyp7rW6C9d4oL5paKT3dIzt5o/dFyMqHxLPw2ljIghkfj
	ypY4DwobpF2iGj7F1USiBnLiX1xZajunqM5382bwilexWmT/Ucg=
X-Google-Smtp-Source: AGHT+IEutopGC+wxxP7tMpiuV7eDAYKOCnGjyrlf918HBF5iBoq4LOeo3SpM+HdsCAJNzT1S70w3KQ==
X-Received: by 2002:a05:600c:46ca:b0:418:fee3:65c7 with SMTP id q10-20020a05600c46ca00b00418fee365c7mr4475070wmo.33.1714261810645;
        Sat, 27 Apr 2024 16:50:10 -0700 (PDT)
Received: from localhost (11.red-81-44-148.dynamicip.rima-tde.net. [81.44.148.11])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0a4700b0041b434e5869sm11030844wmq.43.2024.04.27.16.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 16:50:10 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 0/3] multipath-tools: docs housekeeping
Date: Sun, 28 Apr 2024 01:50:08 +0200
Message-ID: <20240427235009.8751-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Xose Vazquez Perez (3):
  multipath-tools: simplify comment in hwtable
  multipath-tools: unify text in multipath.conf.5
  multipath-tools: update man pages dates

 libmpathpersist/mpath_persistent_reserve_in.3  |  2 +-
 libmpathpersist/mpath_persistent_reserve_out.3 |  2 +-
 libmultipath/hwtable.c                         |  4 ++--
 multipath/multipath.8.in                       |  2 +-
 multipath/multipath.conf.5.in                  | 14 +++++++-------
 multipathd/multipathd.8.in                     |  2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.44.0

