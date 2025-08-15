Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866C723D7E3
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 20:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755289301; cv=none; b=CJQXM0bHMpwbH7dJrS0mz7pln0RbEXmCAgqjae01twPJGfMfh16bN8p40c7tPmUPGdUKIM/ILLkFoLwvIJrfuC4n/bvVItsYZnwQo5HjrFw28AoDIq/MKhuX2CcWXZVk5IHTmEhzR6eYLD+BiUm152A60jeDhDjWu1rmwxAi/ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755289301; c=relaxed/simple;
	bh=tQr7WRhH8Zba8Vjdrrkzh7Y/7f/EOmeJuAq9zCW2Kgs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ghGjNt7pQhtQ72eMETwYG4n3s5TWvnkG9Orvobg+VzsgJsKl5mWstMimuOw4kbBpyYWmACEID8KPhrvvYeR0yf5Y/xZrR2CMn4svyx5+gKwWFjB5FDQJOLntmrGfHpm74KPs3uR9AV3dNfC4nrU+N+QLrtukXL3YRle2BYJJ0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PTCyWGGJ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PTCyWGGJ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b9d41d6e34so51714f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 13:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755289295; x=1755894095; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Ylcn4Wco/h8ojb6qCegLZ80xxCJcrayUH2qQLbr8Hc=;
        b=PTCyWGGJIJWJPaWm/0T6HqH8NL5H/dlq8U2Pu2gtvVGnI+H0TTy5D3ZwVp95SWoGx9
         0xopocBBYFIed/px5TQNjN/75TQR4dfO9MGc+GVylMP4n4mtlx/hB9hv75dmp5whV0If
         daSleMSpJQm9Q+3D5b9YKn2CvySTRHB0hBnOj5VnDQNHZWLYVEGZS6fDCA4hWl3yxnrB
         O0DYCZyTWuaCpgu6Ao0bqawbGmLFXriym09r9qGSa34RN2Mk5zQ89ujSVKX8FuRZGPb0
         N/PHVOkg8m5vzH3ciYs+Tg5XM8j/cUQiOvlBn+4qHKeIei7uG1r3mT7lVwh+9AClAVNs
         XwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289295; x=1755894095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Ylcn4Wco/h8ojb6qCegLZ80xxCJcrayUH2qQLbr8Hc=;
        b=PQ1xfyRt9mnjhCvlqAyQLjY1ihbXkCLQWeBrL6HcsIDBu87p3Pgay5JMCcDjjW24TJ
         UVDBJ7w5Esl6f6OwmWmAb7QvqjxOjmI5/iSWb8BJzcy5JUS5LVAU5nZqrSqwbfAymNSh
         CnZ8ANyE4HDJW6o4NwWquvmvbVc94l09prbesfhrjXEj1BmRkqlI7/7IjlYkRzHT8WQ6
         Sj/QE8tdGFUCvZfb+xZO1kQKMy3SV8PRJbqprUZa78sgM1IK6IcN1/6QZTmjEuWYFiC5
         UMIXTeAY0mZ311w4wzs1gNoR/W8gKe+twVx2DNuAdiVCMLeMteNELpjsX5gbE0E3kNbV
         A9NA==
X-Forwarded-Encrypted: i=1; AJvYcCU+5V6K4mwNp/kFBtCU9cPMU2TJez3nr9ODg5IxhShP1mES50AnrWsce41SqHR6mVmCGmNZ/1NOog==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6zZ+wJXZUxbI+9rltUQWhFUqLZAxFwOA8LZ+t1B1xo6Hf/9W/
	4vbQxMtlJDkdqM/QbwlNAAs1fQ0XO6KcbL8Kb+deDJbYWvla+yku8pI=
X-Gm-Gg: ASbGncs8Yb11Ec2EUnFBokHlgWNEbY6bULV6POZ3ICaHIwyum29rCzlTL0ysKwGqwJn
	iG9IP1bBvMWih8bpLCCxaQ+ygSovgPfdlwjefUAUWlhR4uodQMhW+10KPwLxBZaHAKHZjBXnz0m
	EKUtKS9djvYFrks67KGjeBskG+/gp3RScTh5l3bvJA5IsB09j7rTrCrT15vfwOfqbVRdoGw94c0
	fm0Xh6PtRVg4xT0ktAO9GvXN0DTbY/D1JJwRvLdj2tyJdwh6A28mD6q7HusrjTgk+ZGFqKGVbxz
	WDtTcpofb5ZvjWciucGudSU2YYP5HUKZ++e4qFSyL7W69PW1hJw0FQDsDHEjGItwDiTavJhe3EJ
	wSTRiaY/MTyg/8LA84c8hz004bUBxXzu8UhZ1ALv4/NEJK8+cpOFSZWejUYuy
X-Google-Smtp-Source: AGHT+IFljB5Ln/Tudt+a3E5R8ncefZQrJRNisqhDoxJaiqKOizwRXTpFBYvPTGGTkK7LobAriER9EQ==
X-Received: by 2002:a05:600c:1911:b0:458:bb2b:d74a with SMTP id 5b1f17b1804b1-45a21895d32mr12468775e9.5.1755289294539;
        Fri, 15 Aug 2025 13:21:34 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c78c221sm74372375e9.26.2025.08.15.13.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 13:21:34 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
	Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
	Martin George <marting@netapp.com>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Zou Ming <zouming.zouming@huawei.com>,
	Li Xiaokeng <lixiaokeng@huawei.com>,
	Randy Jennings <randyj@purestorage.com>,
	Thomas Song <tsong@purestorage.com>,
	Jyoti Rani <jrani@purestorage.com>,
	Brian Bunker <brian@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Marco Patalano <mpatalan@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	Simon Schricker <sschricker@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Daniel Wagner <wagi@monom.org>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] nvme-cli: nvmf-autoconnect: udev-rule: add a file for new arrays
Date: Fri, 15 Aug 2025 22:21:32 +0200
Message-ID: <20250815202133.51160-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

One file per vendor, or device, is a bit excessive for two-four rules.


If possible, select round-robin (>=5.1), or queue-depth (>=6.11).
round-robin is a basic selector, and only works well under ideal conditions.

A nvme benchmark, round-robin vs queue-depth, shows how bad it is:
https://marc.info/?l=linux-kernel&m=171931850925572
https://marc.info/?l=linux-kernel&m=171931852025575
https://github.com/johnmeneghini/iopolicy/?tab=readme-ov-file#sample-data
https://people.redhat.com/jmeneghi/ALPSS_2023/NVMe_QD_Multipathing.pdf


And it is unnecessary to set ctrl_loss_tmo to -1 for NVMe/TCP devices,
because it is the default.


Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
Cc: Martin George <marting@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Li Xiaokeng <lixiaokeng@huawei.com>
Cc: Randy Jennings <randyj@purestorage.com>
Cc: Thomas Song <tsong@purestorage.com>
Cc: Jyoti Rani <jrani@purestorage.com>
Cc: Brian Bunker <brian@purestorage.com>
Cc: Uday Shankar <ushankar@purestorage.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marco Patalano <mpatalan@redhat.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: John Meneghini <jmeneghi@redhat.com>
Cc: Simon Schricker <sschricker@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@monom.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: NVME-ML <linux-nvme@lists.infradead.org>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---

Maybe these rules should be merged into this new file. ???
71-nvmf-hpe.rules.in
71-nvmf-netapp.rules.in
71-nvmf-vastdata.rules.in

---
 .../80-nvmf-storage_arrays.rules.in           | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in

diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
new file mode 100644
index 00000000..a2c952a5
--- /dev/null
+++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
@@ -0,0 +1,33 @@
+##### Storage arrays
+
+#### Set iopolicy for NVMe-oF
+### iopolicy: numa, round-robin (>=5.1), or queue-depth (>=6.11)
+
+## Dell EMC
+# PowerMax
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="EMC PowerMax"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="EMC PowerMax"
+# PowerStore
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="dellemc-powerstore"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="dellemc-powerstore"
+
+## Huawei
+# OceanStor
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Huawei-XSG1"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Huawei-XSG1"
+
+## IBM
+# FlashSystem (RamSan)
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="FlashSystem"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="FlashSystem"
+# FlashSystem (Storwize/SVC)
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="IBM*214"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="IBM*214"
+
+## Pure
+# FlashArray
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Pure Storage FlashArray"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Pure Storage FlashArray"
+
+
+##### EOF
-- 
2.50.1
