Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4661C1863B
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 20:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712866544; cv=none; b=ZHH43/+Y5+N/mpylfqbmnI4JzU4qK43aLAc4Pv7NXXn8uuy3VDtUVlfvMrgbBQomZ04J4lGr2ubUNffnktV8F0YlkFeY2D+c1Ha6MxFwBgfr4rqIekqSZGEoS74hx6hRqlUHQMvU5S8T57FxWle6TtIubzOjEZTfCitWm43wF0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712866544; c=relaxed/simple;
	bh=a77S/efIjrUe8D8VYvkKBhXjsHTJ5PTWISSmL0/UAJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nunonps91UbxborBl0hFmA9ZCK8NfHvCfwMGBA3eJr69tAaG26ZGVmsxO7PAtvm5W3vPoezWzkGaEM47W9W/h6aqaG5R7y8r3J1pEv+bL8i0fkol/8dt2ExntWiah0xy0Fh8w2SyaZV0xHUjG1hpZyw21vB2TaqXEfz/1yncsJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6eb5887f225so149556a34.2
        for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 13:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712866541; x=1713471341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E89Ymxr6pBktCBvEVx2AbT0sGVMZ1MopzKCYdw103iQ=;
        b=UCWjZ8w6Hiu5ERyEIFvo9l7Imp129sbw1Fsfy4yMeeLgZyhxfdsbM9AUGhIvb9GLVS
         9VD3w9e15dRsVqL+/WFZwGmd3TccHmTPV0BHsYk2X41p5QVG+9JE1hHjQEUlesVJLfpm
         S6OHPKXo0y2ld2ZI1UTaMHT7Y6wug75RkcFCnWFJdFLVaqBOCBs9x85F8sfFpEq6UPnY
         RxXlVa3SgtgmowzLYwyAGhj5KPFa/GaH0jTaJn0dwSio+ZJQNjY9QvgbLd1QuHrEh8YU
         XK/R6BYr70NCbt0OPpMRsWFR5Fe+eMTky4QB4wj5e6xmYHfSf9pMKazm86fw3D8AOuVm
         YNQw==
X-Forwarded-Encrypted: i=1; AJvYcCWUAXhJNl2Z49ekvy/x88OnpWjQ6PdVLsOSVsU3B1eRT2X7D6qQiTtlse4E5U3mmkiGqL3Ar/GzxlmuJ7Y9vxZoKyySzgPPk64=
X-Gm-Message-State: AOJu0YylPojoMcTzVyomvnTy5PqRbwXKorzwqV8qipmuNK4OXFf9+rvn
	bPQXj0Q5zah2iWRG4aW+aRw2/VAmYJyNAhnvGI56IVaRzxfQ5PPkSde81RdCbw==
X-Google-Smtp-Source: AGHT+IGMfloMnHcVdc0jLN1oWqDbdIKI9CSm7rrlvrKBYp8Xp+7b5Qg3914hRiBhSyMgDd7KUs1q5Q==
X-Received: by 2002:a9d:6c48:0:b0:6eb:5ac3:6143 with SMTP id g8-20020a9d6c48000000b006eb5ac36143mr106546otq.25.1712866541485;
        Thu, 11 Apr 2024 13:15:41 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id vr12-20020a05620a55ac00b0078d66d66d82sm1453999qkn.30.2024.04.11.13.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 13:15:41 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: hch@lst.de
Cc: axboe@kernel.dk,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	mpatocka@redhat.com,
	Abelardo Ricart III <aricart@memnix.com>,
	Brandon Smith <freedom@reardencode.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ming Lei <ming.lei@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH for-6.10 0/2] dm: use late bio-splitting and queue_limits_set
Date: Thu, 11 Apr 2024 16:15:27 -0400
Message-Id: <20240411201529.44846-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <ZfDeMn6V8WzRUws3@infradead.org>
References: <ZfDeMn6V8WzRUws3@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I'd like to get extra review and testing for these changes given how
DM's use of queue_limits_set broke Linus's dm-crypt on NVMe setup
during the 6.9 merge window.

These changes have been staged in linux-next via linux-dm.git and
while they should apply cleanly on 6.9-rcX they have been applied
ontop of dm-6.10, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.10

Thanks,
Mike

Christoph Hellwig (1):
  dm: use queue_limits_set

Mike Snitzer (1):
  dm-crypt: stop constraining max_segment_size to PAGE_SIZE

 drivers/md/dm-crypt.c | 12 ++----------
 drivers/md/dm-table.c | 27 ++++++++++++---------------
 2 files changed, 14 insertions(+), 25 deletions(-)

-- 
2.40.0

