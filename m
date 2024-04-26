Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7483013B298
	for <dm-devel@lists.linux.dev>; Fri, 26 Apr 2024 07:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714116108; cv=none; b=QBme/U1CEqiyzA61BXifbLQB27X8ddlKFoaOv8UoBpmgOQfmV4nc3A7t/INgXFC9muYwdmYfMR+2dG06b0pqA82I2RtlrbmiM3laySV0fhDKehskSqd4jX3G7QSNSq3eT6B1CYOWG1AnjYG6TSOVJD+87wux3FhcIB3l90obLKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714116108; c=relaxed/simple;
	bh=ORi4L4bgAwO18CzIXnxnG8o1DUKEBmtAwP6XEZokH3o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YXiP6xCjuTYMV/3M7s1nLVy65ZjTd8gm8uvsowCzDBro+6IrF77BAp5xVbIm/h/Dz9oZGNgZuc0i92oPIGaeyjav9pwWDlh2TA6JNITjXqTsFRnuiBTUn+goFt17qT0XXabc+hS/6rJ/900ihW0x599KVq+OOIbETWe2/6z6Ukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com; spf=pass smtp.mailfrom=linbit.com; dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b=Y/AzE+fb; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b="Y/AzE+fb"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-51b2f105829so2378710e87.3
        for <dm-devel@lists.linux.dev>; Fri, 26 Apr 2024 00:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20230601.gappssmtp.com; s=20230601; t=1714116104; x=1714720904; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QRexq8HwdmSga2MQO7hRjA+guFSY+ssnXLOdMDXpGw4=;
        b=Y/AzE+fb9WhTQ4KqdTLEALa/9h2TdP16EnaQdSTPFvf7Nk6xEClT6FfxLzfguxIAY6
         HqmYDFf9+QK6ATLPUZMa+ZTPPywRW0bhjArQfr4PBDKZlfv7uCFlVF6O6Qp58Qc5HHzT
         8wa9rCrKhTHDSZ8rbdscyMPi/kI+CbjtZMpNxtsJ/BZno9PJGDa9L93W8MilMpDnl9NS
         eBM4WlEIp9SGC8pXIjXVoEhjeZ2759uvZ1NI6B6F1p8398uoNMN5OrTdnq12eAsxGypu
         DahJTxQf2SQ8zKDc8XcuOTZC6cSDJUP2v7Ho8K5/Gxaks+QQ7arXwpdox1rNLE06ABv7
         Le1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714116104; x=1714720904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRexq8HwdmSga2MQO7hRjA+guFSY+ssnXLOdMDXpGw4=;
        b=kWQYe4Kyjw/ExFnN0ab7iZ8WrqeUh005cqzk5n+NNAY5Apqfj8hScNc/6GwlULtWT/
         YNnwCJnQ8q/7aY82SBzMIa+wH6vn0uhJedy2IarsbaDCWrB6ZcB7HZuterIk1PrJ1w9h
         /0P9egSau7cIZ32cax/8KN+PTtO51ES9Gy1mZi/D+oJtTHolW7SpbmSzrVQfwUFg2Hnh
         kq7l6T6A32/DkybulI4ZIkHaxdhNScZ8PmB7Ynehxq8czgloiuFrMP5sANPHTfWrBxzW
         xiU2HnCmXzXgyH2En2CB8S1GcmsO/lyYhvkMjIoyfRMN0RPQ/WuTbFJXOn11VixcHLjq
         z9TA==
X-Forwarded-Encrypted: i=1; AJvYcCW3ylitBLhm6938eDMJ+VSVYJ69rdc33zRV7GWxE9h8cU1JwU0lR9/ufsYyXyoaqID1CBoRTolnJTT57hqYCl1h5fOfmFUfuik=
X-Gm-Message-State: AOJu0YwOIEt7WAd++kQai1qxlHgly8XPl9jkuZL0AeHheFN9bML1es2S
	sSnTnEn4I2kqizK9eegAS+5pyf0OoX5MBCHrqX29Z4HYY+n8NFUMczoKh5tIhDI=
X-Google-Smtp-Source: AGHT+IETFye/yi8SOFdPp4/fiVRdWzDTud16xMH9ZicXVvyZQ8AbxWWDDqeJO4sWy2gykGvetekfAw==
X-Received: by 2002:a19:750c:0:b0:519:611f:df49 with SMTP id y12-20020a19750c000000b00519611fdf49mr1521001lfe.69.1714116104393;
        Fri, 26 Apr 2024 00:21:44 -0700 (PDT)
Received: from jrc-a.. (213-47-229-24.cable.dynamic.surfer.at. [213.47.229.24])
        by smtp.gmail.com with ESMTPSA id o12-20020aa7dd4c000000b005704419f56csm9723818edw.86.2024.04.26.00.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 00:21:44 -0700 (PDT)
From: Joel Colledge <joel.colledge@linbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 0/1] dm-delay: fix hung task issue
Date: Fri, 26 Apr 2024 09:21:34 +0200
Message-Id: <20240426072135.291206-1-joel.colledge@linbit.com>
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

Best regards,
Joel

Joel Colledge (1):
  dm-delay: fix hung task introduced by kthread mode

 drivers/md/dm-delay.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.34.1

