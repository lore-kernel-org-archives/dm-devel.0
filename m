Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D743241F3
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 11:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705578440; cv=none; b=YlPN1cGl+54fMuk+glRpGogZip5cf/EuGNi1t3tjCiSlTPo91MLC9Y91qCExx3SScbTUhbufklUGSkPoxwFPBfBFzMZZSJ6/vqV8nhsGQjZhtHBMlo3a411/vSA8y6UjKm08uGmFXR3fg5udTYpHLUCSEaKdreyM3Eh6xpOe5c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705578440; c=relaxed/simple;
	bh=r/2Vy0ChUsK+TtvZ6FOOmro15fuMCXoINuzJB+Sz/S0=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding; b=TxAOBDewHX6w3ojXKvjUvw+fVO2TXNIqioz6K2lCactK5lo4X70dMMxAfEe3QeQP7oBBaE87SUHlhRYMdefcGCXhCxmu4Xuen/cLoPMKNxVvYtDuP2+AaI3p5m9P2qZ/NbX01tgiGMg7EBtodoB9vaJQLSurIdzP8hp7vIrAhUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qj/ri1S8; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qj/ri1S8"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40e76626170so45043555e9.2
        for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 03:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705578437; x=1706183237; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b8f1FD4/zlhfLBAEFFLjrb2K9tmrbD6pU/7kF6ROXMI=;
        b=Qj/ri1S8mNxJVRoKehsPGAs1o1lOTIAr8iXknC8ccz7z2OFP2yIhCKNWtH5JRdqOtT
         uHb1K+i1JCrKFWOnUlqDQco0KzT2v3qfQER/Vl8P6CHeYc4WGPvEI8VERVZf5JHP8J2v
         8ttgl9bx6eriVTFxXNL2ZcOSERe1HOsEPId5OodSN8y4IFjEsP5zmYueE3oZOInRLwbf
         B5m8o+un7Af9f+pstT/7nRkFofNMP5PWEJctnIWrNzEcz/oGRzJ+a/ihLApQwCPVzIy+
         lWB74lelTI9RwYxUfDe7tkL01Mu5CRZoC9xjyOWpYGf0jC47mxKgyzXWhW3sP/0saAAl
         EHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705578437; x=1706183237;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b8f1FD4/zlhfLBAEFFLjrb2K9tmrbD6pU/7kF6ROXMI=;
        b=BUa4tJOAyhTRNXwfcpfOKmeSrHe3qkeg1x1PLDMP7cr2IxcYtKhO8BY4KhDKxosNkC
         biCbov6r4C97jNCLjrfV0wksUfdd3h0n2/IXyRjUg26l+n+Fooszc03IgwmDfupsFhUG
         KqtXJwWiKddNmgIUIFyKiM5y7EbeZNAjN8YfgVGO3NkwG8pVfxfPE/azJb0BHfO/u0kw
         PQB34YHJ4isndN1km8ooDs2KYeaNrg8AN8FAiCuhHlP3hUBj7KoAR6jF1RR07SlFWnBp
         1GyTAKXcZACF0AuURW0YRguMYK8TXg9KA3o3r+iKh4jD9gtlKdi2HhEIi8TzwcnhfkT5
         yBBA==
X-Gm-Message-State: AOJu0YxzR6bJJ20GRtzAkXQCHACWwNoTQc38XOUBDz87zY52SJ9mEX1s
	40U9nOlHkt0NVjuZxDPRa2iCmxsQljmKSEWB+bDMizecBb3H3xQh/OEDAoW0jixCUIPZrocY/hi
	z
X-Google-Smtp-Source: AGHT+IFajP+w7LfR73XzfqxKM+J3P5FBuvdxZWGwRtSbTIoB+ASXy1r5Km8E4tqQ7AT6a6erm0NCdw==
X-Received: by 2002:a7b:c3d2:0:b0:40e:53df:257b with SMTP id t18-20020a7bc3d2000000b0040e53df257bmr405605wmj.153.1705578436770;
        Thu, 18 Jan 2024 03:47:16 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id bg23-20020a05600c3c9700b0040d91fa270fsm25669656wmb.36.2024.01.18.03.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 03:47:16 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/2] multipath: update_prio fixes
Date: Thu, 18 Jan 2024 12:47:12 +0100
Message-ID: <20240118114714.3391-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reworked Brian's patch, and added a small cleanup on top.

Brian Bunker (1):
  multipathd: the local path change is not considered

Martin Wilck (1):
  multipathd: make update_prio static, and rename refresh_all param

 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.43.0

