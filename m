Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EB537DEAA
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 21:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349523; cv=none; b=OI8ZUtS7EMRqH6N/M8d56kWZ1lYI1ADP5FFtkBfNRMXiP+O1U5PjE+4ZhU6vTM84ITiRT7gBlVAqlvZ4wpR3Nv0tJ9bZuZMwpnYSXdc4nGsgp1N/xSxINol2A3wH71O/bEljXGlbky8qX2l1POgHo6jd6mFNtNleTw+kuooQo3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349523; c=relaxed/simple;
	bh=ZOGZLNz80LFnN03as665nlykWPmZKB7PUGLuZ8BYLrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=dmVh6BHKu2LJfY7aOXRaXKDFMIvL28+fkrCDdd0uC+Y9NNS2fdccbu13+BE61gCfRc+35gmwB2J4lUozSsnToAiLS/o7Ki2qhEpcSUtHZMf0gVRxmN6E7hTSGZr/OpBRalPdfDTx9n9Ov4xKKecv3EcaoITPMf//y3aSfsqk0+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bq6NDM7n; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bq6NDM7n"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4853589700fso760535e9.1
        for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 14:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773349520; x=1773954320; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Kvczvfb6NHBT+oBoDYU/stDa9gqjgg6rGXeYbp7MTw=;
        b=Bq6NDM7njJSzVKNA227a9T1XoFbQfvoSTO5ZIQ7gHgFKgE0tZLXhdS8KiqWoIlT948
         di3L517b73E10tln3ghw4BViRwnJAEnJIb92EPDyvJ/rhe3KF2garD7dpySIAiYh+NZ1
         7KvBvvhzeMLv5puGq63oaRLUI37lP4V1wHiIeNjoJRE9lHvjiuW3QxsZCuJWJVQcGVSo
         sYUDdEmoXMufjzTcBe/qROOx3h85QqnXEKH0L1KQlht1iIDzMD0yYUjF1XHS5SqKpnf6
         eb7DwRHtYs88xpFA4nm3mYFV/e7e2SInltfOKM3hVFdAfayMlT8vAEZq3zYMR/JGXn5V
         YdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773349520; x=1773954320;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Kvczvfb6NHBT+oBoDYU/stDa9gqjgg6rGXeYbp7MTw=;
        b=ldV3bzJSETLW+COY2JF8SaofgugZYyy7eZwnZsXGp6MF81KbZIJYeNIGWeQMFcgcMC
         uMIPvNIiYHkdpXbCMeWID+QA+mUXuhHHd39eYQK6qaY8G97p8o9wJfj/b7HSdk0AqQXY
         hc2oDUzWeg5qf2fvW7wfpctfVmKv6MkNO8knx+bc2Oi/uLI0pMED6NXiizCkQ5yr2VE4
         ihA9VnPhgKdjytPpQVRk12o2gjRXfN0LaLduf/oxk0tgrMliOeUIDC1blmRA1s4NFE/l
         LtLMuRze9W2qTx0r7ovlG4S+tqCbOEidhri7a3zJ80Vln29UsGY8Pcgp0a/AG1z9tS6C
         N3lQ==
X-Gm-Message-State: AOJu0YxN+vAfIn0KaB1IMNzzA/rGjUXA0wM2lJfyyRaofHk1oSB3fhMG
	Hrz4OUKOw4aiH8Wisq0jVGzwlvB5mxd7/ccFukMdgrDzMBqTet+kisY=
X-Gm-Gg: ATEYQzw57S1zg2QTkfhwG5gIJjB11Q6LtQt45/e49eCzm8BTzvrkvr1PXHT9NyTf0EP
	AIzguLGwnBToZt1/fnRgxB5be3rtFmK5CLWz56+Nqydtcok+HgD266bk4igMUjeSSVVvnVMo/+2
	ixOUn2MhU9ZQVEiT8HYQ+NJZSr8juRiDfhYHG8kIDAtVTtVNRISit4Ngh+ZwKhdyLMfIF3Lm74T
	52hiA4wvK1S2hk6JbP8yJDPGtIfgt1lS11ciB4baCSVwrUpt7oGuzrijSn0VmQr91AdATvqwbOA
	BtY3q+Sl+4VPFfP/fwfaaUqGzDlKrMwDbtE2vUAL1yWRjpuBdIvLVHTRugp5kAJE0KpWFuqMsl4
	ON+De9W/KobeE82EYnhfKRc4P1VELBqoqW8ngy/nyAgdeU6cXXL3L9seGeh1n9fQ4rt4oSdEwaT
	q1Mzy6zLNVUl74Gy784dft372qyfSYcVQO4vJM9HG4YFFglseR1QeNOiBtRqHYEX/1P+g=
X-Received: by 2002:a05:600c:83c5:b0:485:2fe9:33a7 with SMTP id 5b1f17b1804b1-4855670529bmr6262535e9.3.1773349520219;
        Thu, 12 Mar 2026 14:05:20 -0700 (PDT)
Received: from localhost (219.red-80-39-142.dynamicip.rima-tde.net. [80.39.142.219])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b66e3f8sm156441785e9.14.2026.03.12.14.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 14:05:19 -0700 (PDT)
Message-ID: <2fb4a070-607a-4e59-9766-e793d4af49f6@gmail.com>
Date: Thu, 12 Mar 2026 22:05:18 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/1] checkers: add alua path checker
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
 Brian Bunker <brian@purestorage.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 John Garry <john.g.garry@oracle.com>,
 Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
 Yanfei Chen <vincent.chen1@dell.com>, heyi <yi.he@dell.com>,
 Nigel Hislop <hislop_nigel@dell.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Steven Schremmer <Steve.Schremmer@netapp.com>,
 Martin George <marting@netapp.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
References: <20260312001642.53321-1-brian@purestorage.com>
 <91ed7162-719f-4ff2-9951-913fe8096f08@suse.de>
 <bc54bb449129d0a026e69a502d82ef54793f33cc.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>,
 SCSI ML <linux-scsi@vger.kernel.org>
In-Reply-To: <bc54bb449129d0a026e69a502d82ef54793f33cc.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/12/26 5:48 PM, Martin Wilck wrote:

> Actually, multipathd could use TUR for checking unless we receive an
> event of this type. multipathd could listen to those events and then
> retrieve the new device state(s) from sysfs, without sending an RTPG
> command itself.
> 
> We wouldn't switch to the alua checker by default anyway, so the
> vendors that prefer the sysfs prioritizer won't be hurt even
> if that doesn't work.

Just one observation: currently there are ALUA arrays (NetApp E/EF, Dell Unity)
where their own checker is preferred.
As well as software-defined storage (Hitachi Vantara VSP One SDS Block, Linux-IO
(LIO) Target) where directio must be used.
