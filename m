Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E16D1EB36
	for <dm-devel@lists.linux.dev>; Mon,  6 May 2024 07:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714980372; cv=none; b=CubBv2L740grikyQDQh74DhVe6U9OD9L2O+hoN8IDCXNcEkpAbP3nKiS2lgNHaqrgWobYLzfpL3J1FwICqn8yBcBU3cpRE65L+ryI924MHjQSKGp/vmLbaUb4yAv768x4Ri7m7APe4zA9ichMc/8ibysyNHOaCAd9cwox/F1IkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714980372; c=relaxed/simple;
	bh=kNlC3ytR6jF8KFvH38aTFlOjsB+JSnIeAJcLtaQm2ys=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jr054WVmzFfCNeYc/89r0gfvs6s9unEhcoetXOqq9E6mzpeqNUV2gfMZzQlGSYUUf5T5hExad+8isfMmxMulR5vdenMIecEr8D5D5vIVng1Fw57tAH+WcfFzFGU3HXJxXLFaReMONby5dRsniIi3K5lOhwWyLHbBhakcGmz02ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com; spf=pass smtp.mailfrom=linbit.com; dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b=p+JV7sNr; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b="p+JV7sNr"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a59a609dd3fso245521166b.0
        for <dm-devel@lists.linux.dev>; Mon, 06 May 2024 00:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20230601.gappssmtp.com; s=20230601; t=1714980368; x=1715585168; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C1s5Au78z3qxhcC37ngaPrO+T+4+oXjIpiq9d6KPXx0=;
        b=p+JV7sNrtr5YQiaL9cJ1umwmDx4Fe1SfpjUtJmmnzzI1cu/h4EmKttgBPw1fQWvxUX
         hTMYl+0NlX8fOWDLbu2vOzI3/yCcdetiX8Cdd9+asT38DmOkbkEMS6XREfiUOI5VwKJI
         67qi53G48EwNagk+Byx2aavttkwntHAbWa7MXwCdAMFA1JDD5aXxw0lFNaDakx0uzYt1
         UO6vd88vHkX0gfbAlndaX2zWvLcE76+6ypvu4DcXjy7ULwODRJH9hGMvlF/E+Z8QsZAF
         t/Qc7mrBC3BE4hOdyd4LF1ppe4954Dk2vUXMWjuVQqGUmorJDwADCZIolWrQ6ZVInS7k
         TkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714980368; x=1715585168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C1s5Au78z3qxhcC37ngaPrO+T+4+oXjIpiq9d6KPXx0=;
        b=d7cfEgIgJ4w1ycuiuuD+rJ/YPodMM8x4rbIPyQe2i+R3ysO9vuQYbUQonSzBQaAGft
         ycRc8ddPQcaZwoSrhQKmy/b4OjbDuffkGzNHBVgxfI/plzOVz/tBMKbS4szysl6+1b3g
         vHCdpwnSccVfJlp6KCIz3XIz3+3FUXE6K4QLvjqWrFTtCnpOML9hvXV9EUN9YmCM3E2e
         kg0+Hprea25oE47Y1HLsLzBsxX1ppB/yO19WzTORPS1Qtu4GriEJmVd5DxAhZkxjXxBc
         Oe5et7jPSIJifEznpZhFekeSs4+PImDSPt3uNNo6rW6JWUqlSma6UPwB4Dg2VOLCZGiw
         p4YA==
X-Forwarded-Encrypted: i=1; AJvYcCVw5+95oGhM0tuvMVusqODHRe1del47o+otsvs0go7GeQ8m0vT77i8H4zf1JPCphFTXd0cYyprrlGXhcnOOJTCbp4Pphb92mLI=
X-Gm-Message-State: AOJu0Yz2iCoYVHI5S6Vh0B+DrJEG5eMRGEN68ByyRcJ/rYxIVgP2tjwm
	+WPXgsHrpsdmsdC59wJ5EH6fTcetKjyBZKTkww6dpxoaeZ8XVOOGRmfROoUQHHI=
X-Google-Smtp-Source: AGHT+IFrbGs1O2fanbF809F8RXY6VU0WzF/1lz4jI9rBNxf2GDcabB3G12LmCd5CDLAyuh2x3yW7tA==
X-Received: by 2002:a17:907:1c28:b0:a59:bb24:a61 with SMTP id nc40-20020a1709071c2800b00a59bb240a61mr4310500ejc.30.1714980367753;
        Mon, 06 May 2024 00:26:07 -0700 (PDT)
Received: from jrc-a.. (213-47-229-24.cable.dynamic.surfer.at. [213.47.229.24])
        by smtp.gmail.com with ESMTPSA id oy17-20020a170907105100b00a599a5dec53sm3552611ejb.125.2024.05.06.00.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 00:26:07 -0700 (PDT)
From: Joel Colledge <joel.colledge@linbit.com>
To: Christian Loehle <christian.loehle@arm.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] dm-delay: fix hung task issue
Date: Mon,  6 May 2024 09:25:22 +0200
Message-Id: <20240506072523.399767-1-joel.colledge@linbit.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The tests for DRBD encountered an issue with dm-delay when testing with
a 6.8 series kernel. Specifically on Ubuntu 24.04 "Noble". Here is a
minimal reproducer:

virter vm run --name dm-delay-test --id 10 --wait-ssh ubuntu-noble
virter vm ssh dm-delay-test
# truncate -s 100M /file
# loop_dev=$(losetup -f --show /file)
# echo "0 $(blockdev --getsz $loop_dev) delay $loop_dev 0 0" | dmsetup create delay-volume

After a few minutes, the following is printed to the kernel log:

[  246.919123] INFO: task dm-delay-flush-:1256 blocked for more than 122 seconds.
[  246.922543]       Not tainted 6.8.0-31-generic #31-Ubuntu
[  246.923753] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  246.924932] task:dm-delay-flush- state:D stack:0     pid:1256  tgid:1256  ppid:2      flags:0x00004000
[  246.924940] Call Trace:
[  246.924950]  <TASK>
[  246.924980]  __schedule+0x27c/0x6b0
[  246.925002]  ? __pfx_flush_worker_fn+0x10/0x10 [dm_delay]
[  246.925011]  schedule+0x33/0x110
[  246.925016]  schedule_preempt_disabled+0x15/0x30
[  246.925035]  kthread+0xb1/0x120
...

This bug appears to have been introduced in Linux v6.7.

The following patch fixes the issue.

Thanks Christian and Benjamin for the comments on v1!

Changes from v1:
- Use kthread_run() instead of wake_up_process()

Joel Colledge (1):
  dm-delay: fix hung task introduced by kthread mode

 drivers/md/dm-delay.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.34.1

