Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2532745C
	for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 00:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771978042; cv=none; b=hPPDuHD2wGjruzGNXQORpQQEtmt/+j349xuCS37RMXQqKYU37tSiv5IYhObd3qB85LPiG3wXMYu5Al3odjhx1kBCqHpF9rXmwJ9DR54N7Yv0d4XUjIrK47clDkRhXFo4JncsdbNiC3ml4x8sJIkUVEtFVEwIf3gnlwqnxtX4DRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771978042; c=relaxed/simple;
	bh=TmVck+FldsP6JAM+f7tHdpVNV1AQOfdjvZD6NWwaNTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q769QgZ00BxEZaPiEuWbNjViuCFfTFjOwRIMRQCP0xnWIBsO8aIZz2dgn4ca8vqqum/xVdHwBhrD47tYHuV3876E4nwKYIGYbXQqa5mzdf57efcys/1kQVecFu00c9iEMRo27xQsO7DLDtSbi5lIELMK6V6uAM+dWBYfc7syS0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jKaaHcIi; arc=none smtp.client-ip=74.125.82.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jKaaHcIi"
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ba7e98178fso5641657eec.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 16:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771978040; x=1772582840; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tYhhsa7kCZNvYr93t3sYKWAVnQ12TUikgigc7L/AwWs=;
        b=jKaaHcIitmR/ydiQtUbMPDWOANfqKZkdT/Pkq88CSXekmqzE+O4Xooj5AqmPj5715x
         Sy3RQPTvdlLpaHLp8xAVm9Du47Ty7E0Fxw6GTBDsw8nsASeiRBZWxKd+vLuopZtf9G+f
         1m5F4c30/oiNdqo5eiNknI2lQ1A6z7ElSe/cmMhXWuyLaA+CPzIr9+hu+Kg7TDB/+Jmm
         mtK2YIeaN+VpTS12FuSokJoWqRjCwZHBiXRTVOznqLOKCPvjt/bl2RlmW8FwuP6q+xWj
         jdmJ2s+RZpyQebY7Vee4OfQ/2tnV7zLhq7rCD90yJiwnavCe8uo9raeAmK7dYvc0RL+l
         dm2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771978040; x=1772582840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tYhhsa7kCZNvYr93t3sYKWAVnQ12TUikgigc7L/AwWs=;
        b=QYg4G1yrqrOMPe+SdNKBug4recQtgOUcMLa2BKhhSFT8OMuCvo7mwBtR8PSLcEL+FV
         WS6pWMUCeqqiQx0GFcfaPgmbyWQBSVim08BWASWr0MJckSwGG2N6gbSoPX3jZ5N6G0b6
         0yWW9qoCxMV+DPetD7dsAN95ON0jlwyHVsH/1ikhui6ANFYqtQ6wXNmr58l0ycBHfMII
         2dGz4NUSuGzYKiA/LVNdzgk6Jm6lqTuYVY9lQ72AOHsl3oxm0qgu5+D2rdtUfv9NuKb0
         gZ1XVnyO7Ue3vLQPILiN9A0KHgPwUc8l4C0OAwNfcsfgMpYske7A6eSWhXJVwn5xiKES
         AfNg==
X-Forwarded-Encrypted: i=1; AJvYcCWvnzenxveonIJ1s+XkZouJDyPydFdTttHQygOR3baJw/Esby6CwbPY2gF1K7xvzse6yIehneYojg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWJVhRLa0kSMU2ztVp+sMAnRN5adH2YkYa7tf5rXAiJBx0+Rmz
	/3CQ7sB6//imXsDy0u5hl6lLwCACmRFjjPpveO3Bfiu21d68R8aD0VRif8kbb/rpQuIE78vSwbA
	GcgJDnYSDWRWiLV7Bzr3pQA==
X-Received: from dycqa7.prod.google.com ([2002:a05:7300:fe47:b0:2bd:b038:ae2f])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:dc0d:b0:2b8:209d:5983 with SMTP id 5a478bee46e88-2bdc33aeb7dmr127538eec.29.1771978033558;
 Tue, 24 Feb 2026 16:07:13 -0800 (PST)
Date: Tue, 24 Feb 2026 16:05:31 -0800
In-Reply-To: <20250619111806.3546162-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250619111806.3546162-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225000531.3658802-1-robertpang@google.com>
Subject: Re: [PATCH v2 2/9] nvme: set max_hw_wzeroes_unmap_sectors if device
 supports DEAC bit
From: Robert Pang <robertpang@google.com>
To: yi.zhang@huaweicloud.com, Zhang Yi <yi.zhang@huawei.com>
Cc: bmarzins@redhat.com, brauner@kernel.org, chaitanyak@nvidia.com, 
	chengzhihao1@huawei.com, djwong@kernel.org, dm-devel@lists.linux.dev, 
	hch@lst.de, john.g.garry@oracle.com, linux-block@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org, 
	martin.petersen@oracle.com, shinichiro.kawasaki@wdc.com, tytso@mit.edu, 
	yangerkun@huawei.com, yukuai3@huawei.com, robertpang@google.com
Content-Type: text/plain; charset="UTF-8"

Dear Zhang Yi,

In reviewing your patch series implementing support for the
FALLOC_FL_WRITE_ZEROES flag, I noted the logic propagating
max_write_zeroes_sectors to max_hw_wzeroes_unmap_sectors in commit 545fb46e5bc6
"nvme: set max_hw_wzeroes_unmap_sectors if device supports DEAC bit" [1]. This
appears to be intended for devices that support the Write Zeroes command
alongside the DEAC bit to indicate unmap capability.

Furthermore, within core.c, the NVME_QUIRK_DEALLOCATE_ZEROES quirk already
identifies devices that deterministically return zeroes after a deallocate
command [2]. This quirk currently enables Write Zeroes support via discard in
existing implementations [3, 4].

Given this, would it be appropriate to respect NVME_QUIRK_DEALLOCATE_ZEROES also
to enable unmap Write Zeroes for these devices, following the prior commit
6e02318eaea5 "nvme: add support for the Write Zeroes command" [5]? I have
included a proposed change to nvme_update_ns_info_block() below for your
consideration.

Best regards
Robert Pang

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f5ebcaa2f859..9c7e2cabfab3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2422,7 +2422,9 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
         * require that, it must be a no-op if reads from deallocated data
         * do not return zeroes.
         */
-       if ((id->dlfeat & 0x7) == 0x1 && (id->dlfeat & (1 << 3))) {
+       if ((id->dlfeat & 0x7) == 0x1 && (id->dlfeat & (1 << 3)) ||
+           (ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
+           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
                ns->head->features |= NVME_NS_DEAC;
                lim.max_hw_wzeroes_unmap_sectors = lim.max_write_zeroes_sectors;
        }

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=545fb46e5bc6
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvme/host/nvme.h#n72
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvme/host/core.c#n938
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvme/host/core.c#n2122
[5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6e02318eaea5
