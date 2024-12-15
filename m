Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA433997
	for <dm-devel@lists.linux.dev>; Sun, 15 Dec 2024 10:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734257666; cv=none; b=OAMMF5r+VP7F+4s8dl7bI9knU6b++egUlGeHaLiOJEg8uaRMEUrb0QhfKTIlpPPjzOJGvCWfmtDdwZ8My1yDY6rq2q4SXciDood6ySuo6+tZJe+3CMmlAJ4hhrW8i6NzoTzIqFCR5tlVp2L31lgMbLifziZE6Q64dy64KSZ5ymE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734257666; c=relaxed/simple;
	bh=T6I5sFPvgXQenvHGDpF7a9tvT0DreXjvECBpiuAyedk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iD4RJf6mysAZGXuCBzpMVLCplX5Vp45dhUkrTd7bbffr8FzVauKHVNTEbQIUVdiqZu/VSon26n/Ds/wXkG3XIKK99X+fCj9zb/ySS8LPVxO2CAcCttX09ymhUi23jkeeb3IAbi5vSUdmfQdYw0W88bCFSuJbSQm5GGFYz+fUbbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OzIpXCoQ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzIpXCoQ"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-725f2f79ed9so2372167b3a.2
        for <dm-devel@lists.linux.dev>; Sun, 15 Dec 2024 02:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734257664; x=1734862464; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xqNjjk7oEjBBCzGWGGRo1tlNVo/ASpAvWDY2FHC/tA=;
        b=OzIpXCoQ+7DL4eznL2IvXN8yTkAMUY+M9WkYIvS27PsVl5LdC5q7qBgMnsR4D0cwa1
         fQOrHPu5Jq0pgZi3NwJtWB/7hKnroPXN67SSvd1+By43VxoxH/W6jnAxhia1jebNJvZ9
         zO5DwM3o1Cgk8+7kPCDYIthcBCdM2idq1cp2wFtCRKp2/ulc69ZX7DIrNzEDoTOvckZi
         U7GR+3LjPK3pAkp7cHNqMCNXFROsSYKav/G9jzF8hRQhcxtWjyyptFRXaMLkVpV4vIvw
         cRDmSQE8To2owqLXyNwCUWj8CpuX8Bvf9zV9dtppm33mExIfnuMxNaT5Hodlrc7E1AAg
         xzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734257664; x=1734862464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xqNjjk7oEjBBCzGWGGRo1tlNVo/ASpAvWDY2FHC/tA=;
        b=DC/XIgOfJlH5rdDKL0nHEWcNGHuJJmNJF+1wrhOCbuBrfbFYTVmI9s7QTeYfbH8iom
         2rwgsmRbm1rkBW51+IarSlthAS/74x1sUl7+SmFI4f6UCuSp92RWkVY4UnzY0ZzQXJGV
         DSVw6p7V8c7xr7tgLpSWOH7FlpaKIQdZ3DiDCOv8uWXXZeTAOXYwMKLAoLuEFy2Vhnsi
         b/i9PQN82ult3nOrB9IFuizm0oM3q/SSlEJaSp/3LSZis2e7CCsplU5mqCYW11F1syYT
         VB1+/2FLPYptiMrJXLM4sXCSqieJa3xd0gYd5tmlIvN+AcsMAHRnywRumdrENQVE8gq+
         HMrg==
X-Forwarded-Encrypted: i=1; AJvYcCU8RImBX1AAcIqlbAWuG2YO5SToAEYwN04vxAG9Dib0a8Ems2yV/AAF7YxzkDwnIBE0fGMDMkTX6w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx81zHVesfXcfWwm2uIcL/FsN/11s5Sxv87iuc+cFE1b7m+khN8
	886ueuaQ35zcZnj1H9fUr2BdswDjQs4hEZO+Y/IJ7p4OdooTvrp6
X-Gm-Gg: ASbGncuIcyIcgvPVftGdUgHps6uZfqHYinn4+MZdt6DzbzwwXheDxbygzwpPKgM6ex0
	Mb+lENNkmhgIeytTGLVc72evS3O2BwPtliY9V3O+543LT3Ci7PZAgCiWx+uxUUuxQkZqRtR/p2Q
	201XAbucMxY4r+J3iPh+wH6vfA/6OJG8WbDFG4A3Xr+QDnMxRfLb5yjGnxH58TRUt8w9BatQlUH
	UwRFU5Uc3Cyknfe/SUa4H7l8v4VLe1WhAlG5sC4QXhZKbOu1rAT0VTZ/9FvvfOQ5iW/M2Wf
X-Google-Smtp-Source: AGHT+IG+xe4V3gMOmWzfmbscJyj3mj8PuzdPQlwEW+IjcFStJ0C2iV7Qej0RE73ZtI1KNm8nn2Ugxg==
X-Received: by 2002:a05:6a20:c996:b0:1e1:a693:d623 with SMTP id adf61e73a8af0-1e1dfd917camr12694780637.25.1734257663984;
        Sun, 15 Dec 2024 02:14:23 -0800 (PST)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-72918ac5264sm2807705b3a.21.2024.12.15.02.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2024 02:14:23 -0800 (PST)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: snitzer@kernel.org
Cc: agk@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mpatocka@redhat.com,
	pvmohammedanees2003@gmail.com,
	zkabelac@redhat.com
Subject: Re: dm: Allow the use of escaped characters in str_field_delimit()
Date: Sun, 15 Dec 2024 15:43:33 +0530
Message-ID: <20241215101336.1456-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <Z1hrfMRedzEJb26O@kernel.org>
References: <Z1hrfMRedzEJb26O@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> It would seem Mohammed cared enough to write the patch, but not reply
> to you with further clarification on why it needed...

I thought I had already replied to the concern, but it seems 
the message didn’t get sent, apologies for that oversight!
College academics kept me tied up, and I lost track of this,
apologies once again.

> BUT, in this instance it follows that: if lvm2 is allowing weird names
> which require escacped characters _and_ dm-init is used then dm-init
> needs to support handling them (dm-init is all about _not_ using
> normal initramfs with lvm2 in all its glory).

I completely agree with your point and am more than happy to 
provide further details or make any additional updates to 
the patch if needed, please let me know if anything else if needed. 
Thank you for your time.

Regards
Mohammed Anees
