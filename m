Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF83A32A3C6
	for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755602208; cv=none; b=sO0ijPWcMZuvaWymFh/Yh44LisAZhzfeCrEln2unWs/rVA5GZPfejiVsT6Lz/xSUSj0QYmMvWl79vDdORwstrDvvW4HfevWc4yZ7/oA8YmJ3QGiSIXBL0s0/5/S9ig1saXVeufOAxWoRMyjYBxe/vkOSC7ptNNZnaT9FViy85mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755602208; c=relaxed/simple;
	bh=1RgqftUzP8ZOFs84dBFBrH5d9aSvLPHds2WeGJKYgNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WXBtnVxS2p72V6D5no4U9HrjVQ44VVQfxXYRG5b4AACzg/5BG+7JiQrFIBZAiNRHkURW9lCK4+ESGPNvATeo+H75yTKNsQsiIZ1oCE0icoNM4eqbTkIm93De2Eisk/fwde0sYWqUnk51CgXWwiT3ox4n3TTg4aaGn/iGDmjM82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgHwpC+e; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgHwpC+e"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b003d05so873185e9.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 04:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755602202; x=1756207002; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ru0e4pqocRWcS1MvPzlktvsHunErnNzt0vSfk38dJZI=;
        b=JgHwpC+eKXr8CMk/yq6GHzMx7Cj9rknmfQXIKLQdG5FTPkr5gvhNtl9GP4skaf88XB
         zEwTD4dQMvKMzck7ltnpR9rKqR3dXK77F5PFx6ZDhDo7MJsxZXoa0mVydZ0ni5A3zyxN
         WNYtNoHNNysKhQDKCBPyHEoParRKeNaAoN0zfnPnXY1+EQJs81Ql5u5ClfpaUIoxOLZy
         QP+z6vzF6eq3IGFJGgAfm9O7RWgOETZVk4YL2QYzODw9KsY2R+whhp/rA4dYYnE8tUgy
         ZpouF9d1sHIqq/KmAQBmZCIjnn7u3iOmQyGbydCDjT9Sl1Jn5eZ8ku9gHBpM291Lys8Q
         lPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755602202; x=1756207002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ru0e4pqocRWcS1MvPzlktvsHunErnNzt0vSfk38dJZI=;
        b=m2GMvPMOAC2TeXcAOrqyrShaV/+loFuAXX8oAAXOD0gudrAhjUzlAsu8qFhF+ZvZ2r
         Puv4HJMuqzghq6DUltjTn5g8v13LJOkQNdXGWMdPeQIE20ZGgEZ2ylTYwacWVWpLW10s
         3o+u/+TRwE4Ezu8S1Jnclo0AS24cy5fGBx3smeLAD6DRlZsOx2szPYb1wIhthVc9C+eE
         HcVCuG3mnW4J6TsVfdkFmSEGbOECXZnJ6ebx5miyNHTM59F5Kjn7hWA/a8VMUD31mLhi
         DpZE6Zn6sj5VqgwXB8CadfQxbZUoWDKdjc6F016USaAJ+fur/udJvsFM35UoYnh+r7lx
         VDFA==
X-Forwarded-Encrypted: i=1; AJvYcCUrqHK6sY6kZ89ow/Kny/OyvOFEVQEBtRaGDc+yjH8iq7YGjHa/arAYKJzPC7FCIiNTYOJPl9HQRA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8+XkGu8MDOTRjmGUp4E0h4dwjJ5YfK+GAUMvMgyYJzea6DbxJ
	7qP9md+KmkQDMjchUjXZm3JCg/FBQjb+x5CxlAwXVI7XtLe5r+6YEsA=
X-Gm-Gg: ASbGncsGaFqE1QqqKbDVUUieR0KWdLSq2s3hP09t6/6TS18/GKWM0O+WUn02vfwh7cv
	Cjm9Sex8VAvvdSHyrtEB2Pwikz7zCHRk2fgcY9erZpu40/DOES64UXBj02qdfTewmQikGWhzMHm
	hAFWyyay8JHBgq9Uigp1T/kGlsJ5RzRa+59Myt1Tt2O3zQrFRwporhcf7FXnp9eyhZXeNHacIFW
	I+ajBbu0eQSZrdknVNWqOfvtO/npZuFd3gl8relR0Tq68ao4Em+cMzgfI/DE9DYb/jaUKVc42IO
	9X5qbsMbWG0jDDt9gMuQoZz/gE2bLkJdGeUWEjxjbioyEy+U0tH9WoTwEQOpeVg8fR08oTbOQBq
	OwpyvHlRR9vYoTGup/oA9sR1/y1RxXof7YTiTLa0ZdVe0wsOa3P2NP/MKENX7
X-Google-Smtp-Source: AGHT+IEjJ0o5DGL4y9TOsIn9ugdBJNIj8kFoFW53rL7KFzsI7YsinGg3Plurh9O2DBq6QatfYXDUww==
X-Received: by 2002:a05:600c:1c92:b0:454:aac0:ce1e with SMTP id 5b1f17b1804b1-45b43e0086dmr8414275e9.4.1755602201497;
        Tue, 19 Aug 2025 04:16:41 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c773e57sm222640615e9.23.2025.08.19.04.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 04:16:40 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
	Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Martin George <marting@netapp.com>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Zou Ming <zouming.zouming@huawei.com>,
	Li Xiaokeng <lixiaokeng@huawei.com>,
	Randy Jennings <randyj@purestorage.com>,
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
	Daniel Wagner <dwagner@suse.de>,
	Daniel Wagner <wagi@monom.org>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	BLOCK-ML <linux-block@vger.kernel.org>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2] nvme-cli: nvmf-autoconnect: udev-rule: add a file for new arrays
Date: Tue, 19 Aug 2025 13:16:36 +0200
Message-ID: <20250819111638.252890-1-xose.vazquez@gmail.com>
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


[ctrl_loss_tmo default value is 600 (ten minutes)]


v2:
	- fix ctrl_loss_tmo commnent
	- add Infinidat/InfiniBox


Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin George <marting@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Li Xiaokeng <lixiaokeng@huawei.com>
Cc: Randy Jennings <randyj@purestorage.com>
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
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@monom.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: BLOCK-ML <linux-block@vger.kernel.org>
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
 .../80-nvmf-storage_arrays.rules.in           | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in

diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
new file mode 100644
index 00000000..ceabba31
--- /dev/null
+++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
@@ -0,0 +1,38 @@
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
+## Infinidat
+# InfiniBox
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="InfiniBox"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="InfiniBox"
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

