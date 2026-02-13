Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B03036073C
	for <dm-devel@lists.linux.dev>; Fri, 13 Feb 2026 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770996408; cv=none; b=YyDbHKiIXpqHG8si2TedZRshWRyDueH3Xib/khYM9rUjFH94l8Cy5n0KgfQ0zjVq+lEyA4X8076LKrSY3dyhMQAR7TYrYOF+2fh6DPJ+8DguUa25LmfS8YCurk8XU9iOM/8gFkbgktJ4JDNszOZ2affgfV82kOPYQOi2u/um6Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770996408; c=relaxed/simple;
	bh=TIyYhBjIMdhMFqURWlwOaH0ft6/je8jcM72gBZMgN1c=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:From:
	 In-Reply-To:Content-Type; b=YH2qQXH6sPSDEubjlinMbGGveLHAuSzc2yAyMJ8S/ZzEKdUw3jD+hYqHRR0QbqhHuQYhHGpSPJmGtX3md257RKKp5Dvy52eMP7TUwaIxD0QWnHRBV2wQSfvzdB0kBMkUQjiGm3tpsUJUyud5ksLtrNOhwpRvn7Yyq4Ms4a0klY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jLEOZ4J+; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLEOZ4J+"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8f7fd33bd2so17362966b.3
        for <dm-devel@lists.linux.dev>; Fri, 13 Feb 2026 07:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770996406; x=1771601206; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:to:references
         :content-language:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TIyYhBjIMdhMFqURWlwOaH0ft6/je8jcM72gBZMgN1c=;
        b=jLEOZ4J+MQ6dl5gFdOZvp1uJIYSWwpWIpQJCRrJZeyvl7kR8sN4ZTaGU2PpOmMAk7l
         c7JtLPwv86gtyg9Eocow1nbUFt3tbn3b5/ujGVlRJNMhlPa/MwPSVfH5SzCI1mPl0GcH
         yB7pJH0c+ec2vNZZIJ3YNodEzTgpMq+qIbtBDegovtx9uWZ/+q6DRAnoxFDiv9/uQuDb
         eWcim+yElJP01x2LEr1Y4qY18o1lbXPLbu+j/87h0g6vaACcjsx78Ji2dYw9+PF0Ddr3
         u091Gpew68LaiGlXET1Fb4sE1Q3SD3jQ+oPiSGnUKMaP+L+2H/X09YJDyUdTMBedON61
         oTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770996406; x=1771601206;
        h=content-transfer-encoding:in-reply-to:from:to:references
         :content-language:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TIyYhBjIMdhMFqURWlwOaH0ft6/je8jcM72gBZMgN1c=;
        b=OnkVXJj2e/NPnpHjR2QPD1DXUGx+HES3tids2OhdL7RTLsBs5HEiJOYlV2nZA3YO/F
         Gl37j5RXQzYzN2z88UXxj9r0azG3DQugXW+Whsp8lgXhbuqvfj1ZGGwQoOcSAfVEYEi5
         51mzYZbUStSHxyxubqKz8y6FcedQbFvrMs80EPv/Fh3oLpgWr8AlQGLxBh8PuiUiCJby
         wLlB3afhDIP+yMiBpyB9qalhxjfMRPkRQ9fKUCTDrxH2V8y0FqScBr765T6Tp4JWW4EP
         PazLrvGvpXONvnpJlIK2c+P5gS/hWktXBQakW5hEdUmiwCPxa7F7E/n+aKPJUds4+0qn
         AAQw==
X-Forwarded-Encrypted: i=1; AJvYcCXAirPZ0EyIs7+Z5Zi8ef90l42lpQBZpWygMs9P2h9SD6KWrMAqgn9ORtLuZQofbRuJnyi9IPs8LA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi1+2o221zy+20r6RiG4PB4rzr/skiqI6IGIu6v/cVUfBymB//
	EdvWU0b1hi+nFQxc6bRbDlU+lSPZzsLoXrxQuUIEd4a8jpoVjvlu1ew=
X-Gm-Gg: AZuq6aJI9i70qrmVgNMy2UqbzaW1iYd2hl0nAMQAKAiSwJzwbTylJdiKnzFPo+3jETv
	nGfrn1kTvWjiy/dAWgiTVSy+eQb2aDZEcgB4trMY6NBD0kZVX/OrostaE/e4GPH6wm0VsI/po8+
	HggB6xgQVP5Q9jWOJ0Owp6EuoafU7BuTkiiQl0Zn7IDjj7Y9WhGagsX9IoxxNNnjkvaPROQr0gv
	CxoR+z4rUV43Wy6B8TuxRSrlDkH+y4V3d4CeVhEq4o+mjYWW3qxoKRtZgdrnIokIIp7CgVQihUl
	L0nPF75eXqsc9r1TGckKk6lk4HRZUzbiLOo5Ra408pkCiu7ge5Rp163WO/66AuCFWv+/SnvEOUD
	L357sWbVmienrbsOgqsGvdKzLCXfuj5GAYri4H5HkSz/TR4SXNGI+mzGHAKItI+OliWnVnkHgND
	BQfURAYZUoPU2iV88rPpVoC8xEX/DhlcAqZ+FA1TZZ+8m2/5G1Xy0WB2DXmVY3Xw==
X-Received: by 2002:a17:907:6eab:b0:b87:1e1:e562 with SMTP id a640c23a62f3a-b8fad019240mr90172966b.8.1770996405545;
        Fri, 13 Feb 2026 07:26:45 -0800 (PST)
Received: from localhost (218.red-88-28-8.dynamicip.rima-tde.net. [88.28.8.218])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8f6e9a6a24sm263458766b.20.2026.02.13.07.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 07:26:45 -0800 (PST)
Message-ID: <e8f58a8f-8116-4c68-b408-96b21a6480b0@gmail.com>
Date: Fri, 13 Feb 2026 16:26:42 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Fwd: [LSF/MM/BPF TOPIC] Native SCSI multipath support
Content-Language: en-US, en-GB, es-ES
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
X-Forwarded-Message-Id: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


FYI: https://lore.kernel.org/linux-scsi/69349b51-72c2-47f9-948f-f89843af62e4@oracle.com/dm

-------- Forwarded Message --------
Subject: [LSF/MM/BPF TOPIC] Native SCSI multipath support
Date: Fri, 13 Feb 2026 14:19:11 +0000
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
To: lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

At ALPSS 25 I presented a proposal for Native SCSI multipath support. Let's discuss this topic at LSFMM.

The idea for this is that SCSI could natively support multipath, like how NVMe host driver does today. It is intended as an alternative to dm-multipath support.

I have been working on the implementation and I plan to post patches in the next cycle. I am looking at a 3-stage approach:
a. create a driver-agnostic multipath library, very heavily based on NVMe host multipath support.
The library would support features such as path management, path selection/iopolicy, failover recovery, PR, delayed removal, gendisk management etc.
b. switch NVMe over to use this library
c. add native SCSI multipath support based on this common library

Thanks,
John


