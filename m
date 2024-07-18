Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D32A145A03
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721330068; cv=none; b=Z6uDEmUV0FGVqa1XmrmOMX32NmchLB3CHDpguC0NNZUqk5KQ0T+Ny0LxOKmCzMDsPmg5WzN14tb0brsPDzB1/gw7bU7iSHfFc8fsDqdokaiGyyOLiinDFY3GSeCUrV9HkVU1jD54ijP03hxhfG0pfKwqFjuwYIcTGhheBQylukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721330068; c=relaxed/simple;
	bh=cGukjkx4ybXwfS5r2W1o7SOnFPfg8GrC0VGdgprANxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZFZssHXU6LftHXZRb2vGrB1v+bEYBuepVzz1AZCddvj+Um6NjjMeHQjAZKMHlwgkSLa7O+4xg8CGfpBkRP94CJqmVyoJ7BQEzH8/iExCh/oAatGnxecrYHq6f6lw3DeiPeYdslxMgqeHzC5Sp+9hyNraeenEHGy2WbfORqF3+V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RN4LR4Ss; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RN4LR4Ss"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77e85cb9b4so149405666b.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 12:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721330064; x=1721934864; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ub4GU1aXt6KU0fDjkkGt7lzkLPsQQVBO4D0+Tb84Hkw=;
        b=RN4LR4SsEAI2d7FgXB8kJoHoFyoKferMrP946oi0asYs4raDchWeFTwozFN2mP7MaE
         E9R4pC3OTNYYVWwBTgz4dRemd+b4YzS06wSI0RzuUXqc9KtRf9S1e/j7+klablBqlDm/
         jpOlv94JsxoXCuT3rMQ5fVhE480oyBlurfPXwsuNc/xARfcZCsDk6ZvyrdJN9qd386+a
         aHGcGyBjWTnkkoVrWfHF/i05SRigGgfir/LgEP6oPzul/9+joMdOM5nAmleggBsetUsw
         dIuZ7j1B1uD0T1n6PjgZGrIh4H7rT9pyp9F4Pw9TC5Z8ct6mPNLNdUPD7SXEwmqMmwh9
         NmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721330064; x=1721934864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ub4GU1aXt6KU0fDjkkGt7lzkLPsQQVBO4D0+Tb84Hkw=;
        b=H5KKQDlFjCkkBb5pRU0+onvTGzsRoD554XPyw+tQ4w8mKEaeuuxQYHlt0vlLEajhtz
         TXcmUhvsga5uXtXvMnq5os28RYLUWJ+VvOM4pkS7dlrHvKs9hrabeop3XYmAOGwBLH1+
         8KcR0v6KA5T7iVkriTYAjMyOdhmEFKJmYY0DoGFovMYcTtrkGHBbcvTXuwqomoRXNcoN
         QTgBJVvkENPjpu7zkqRfhYhY0qEKyo+rhC7MpAydk7B0EgzgkNWZ1aS6pXw0k0HRvkEJ
         gviFYIdYUn9LDLGxkzrM2mD3Mj3/oO8hj4O6U73BU1f8aIMJ0nJXsWY8w1rd4FZGYfM7
         Xktw==
X-Gm-Message-State: AOJu0Yxw07rwyqsqi5pLhH6rHeYS5Q8ZgBIBDCGa2jfn9LCO427NOTez
	bRdQWTot1iAuQHbn+hMRJeYaWCODWiDwqiCS/Bpteruwk1dVh8jylCeX8kFjX5E=
X-Google-Smtp-Source: AGHT+IF+TAem0hjupthRIMGa3U37m2cb7B6WGoiIj2rvgjNynjGQqm4isNegOnylZxvfOqtzaKic7g==
X-Received: by 2002:a17:906:84e:b0:a77:e1c2:3ab with SMTP id a640c23a62f3a-a7a0133774amr313221666b.50.1721330064269;
        Thu, 18 Jul 2024 12:14:24 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc7f2361sm589836966b.120.2024.07.18.12.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 12:14:24 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/4] multipath-tools: coverity fixes
Date: Thu, 18 Jul 2024 21:14:17 +0200
Message-ID: <20240718191421.110487-1-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin Wilck (4):
  libmpathcmd: check len parameter in mpath_recv_reply_data()
  multipath-tools: use signed loop variable in vector_foreach_slot
  libmpathutil: avoid size_t underflow in strchop()
  fixup "libmultipath: use libmp_pathinfo() in update_multipath_table()"

 libmpathcmd/mpath_cmd.c    |  2 ++
 libmpathutil/util.c        |  4 ++--
 libmultipath/structs_vec.c |  3 ++-
 multipathd/main.c          | 10 +++++-----
 4 files changed, 11 insertions(+), 8 deletions(-)

-- 
2.45.2

