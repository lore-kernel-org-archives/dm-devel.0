Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABA247F2F3
	for <dm-devel@lists.linux.dev>; Wed,  6 May 2026 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778076952; cv=none; b=SSUtXLreYp+u3uQ+nJZl043p2oK1xMN5U+xh/C93wKUDqKJOcPvAewIZUZUjmKkfh+Czj5KvcatwBmhAp4bLuOqsmWeKe7SpHzPUXnbsEtWYAPBVyobsUWMzSgHU9yM/pijmlwT9B28zHSiqhxSIx7WShVoeK1JtmIdPcJjsXb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778076952; c=relaxed/simple;
	bh=zZcagGFZAjrjlPTdskd9mqi0QrGre7yqU1eShhuplxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Exk8VdJQNfcGC326XnLy4o5RAn83LwzDUGfnUo0w9OhpLMOqxzKTYlwhA/BZ4As3Buh3JUPoJ3Y565g1oxogvWj1Mx2tPoH0nlL0Lm8uMYLgDoL3Fvwact7xeH2mnKi8xbRyWKFwrSKx3QZldeH/Sov0rU+bwcvI4zhSuoHwA3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nKZjcGRH; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nKZjcGRH"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48962cd0864so8262965e9.1
        for <dm-devel@lists.linux.dev>; Wed, 06 May 2026 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778076949; x=1778681749; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Io/N+hHnLMI/zVIF68lkuWkyC9l4bvcPQWSmOV0m6oQ=;
        b=nKZjcGRHE/1+9TanovpgDomDi0x6vp7Jt0xLder8idjUF8ch6x8Y2Yyvbgnq0pFe8U
         WxktoGemXCcB8b8TQ41gR8kAnemqrGPDqga5EaPcmQ8C5R/sAOJsjlk3yf5SxoCHaRNa
         7d1C1FJ98CiTvo0EJboQvuJgnPR2pVnqoJ7LEnRw7frZTHSeOES5LES3D8c12FaicIP9
         Slz7515TOsVmMuKk1QFBznK2j0zuL0fHnuAQRHOVTnyWIMJFMfsj5XnwR198rmgtruwG
         hw74k/134rmBjts2PiJ8RiPF32oOBCcbs1c6epeuQcSU+VktkUUK8VlSd1SH/FJpAsRl
         Y/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778076949; x=1778681749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Io/N+hHnLMI/zVIF68lkuWkyC9l4bvcPQWSmOV0m6oQ=;
        b=JItRB7pTuCw/4jT1XvA3V6xTKzRGqOGB2SCQfllokpLjfYHItktHpMzlJqccBNbhI1
         H7IoranJvmOn8V9XbXkHheq3cE48YWIa2rXDajGulo3fzKWr3HWmAg+bX2DFNZWfzziw
         89Z2jPLtXq+tbCCVU2hAdjKT0502WCeWLw4SIMrwd7Wqokk0Si4FgI0swW/mrLbc+E9t
         UEXTybSBLsP68wrbp8i9SkOg93bY4QnEmd0A0S2oAzVQAHmlYc6PGXQ9QeW7r8kUlMFY
         5JXWFHc+6j75bOwf4NbEButR5b+GWdGwqUX/zrg89EQza6H015w0Cxm4wFO5bkrtczZ/
         Aq5g==
X-Forwarded-Encrypted: i=1; AFNElJ+rdPGn40IOOXvHahSpHQ+adjxEIMs3ShgJhLjKa0sD48/zm8KpS3DSJ1WD6N9LTAecqAMM1Yh0ow==@lists.linux.dev
X-Gm-Message-State: AOJu0YzTkUpXnNlQn2aq1U403WDswZPw8HpLH3/UySvy8hViTI1OYl7v
	Sno2zA6e519V0cZbHX29/Ma7/xIV/tvHL+IBkfc6BmxN+tQNlU9egGA=
X-Gm-Gg: AeBDievIGe+UIPvGveOlowpCiRb0HGVQpeGnOCOVEXKSofGMJqkCOH3+hIt7PUnTOft
	S28eukiAoVkpBNQCxeSEnPYbpFZbc5Ue8V4SjwEkglTq2jP8+ABvhEas3smq3kpzM4ysZIkMv5i
	KTTa7c9XkBK/mxhXnUDsJs/KpSAtozN9gcQmpm+r7Ob8bg0Ef/bx012ky43crl+9aiwipmYXU66
	w8bSof0E+hS9+X3j3cgPuRzUmvtPEP40UVQz3OWacWICspJxkTDU/jwIZewNdUNFjbaXVscUptg
	xE+3S8Hq+cBcBayqGDJgzAwmUCBbkGydBtTaY0VpbvkeWE6bGJDTqP/qJ/J2RFVLxaoB+rrM2ax
	o+Rs531Np8Es+8bSGPycnByYisWjWpp//LBI4hlkD4CFmzOICGK+7Mp3gOvhD+p3JTtVTg7VNtQ
	g+BepnmX+O9vtoL/sJwuxPL+8+q8PCyrkHD7fZ0WhvpokytALJq0sDs6huBy6UKk1a7qurdhpj
X-Received: by 2002:a05:600c:1f95:b0:486:fc61:541d with SMTP id 5b1f17b1804b1-48e51e124b9mr32527385e9.2.1778076948868;
        Wed, 06 May 2026 07:15:48 -0700 (PDT)
Received: from localhost (8.red-80-39-165.dynamicip.rima-tde.net. [80.39.165.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4505558e213sm13671647f8f.25.2026.05.06.07.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 07:15:47 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Aviv Coro <aviv.coro@ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	Caleb Sander <csander@purestorage.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Leech <cleech@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Christoph Hellwig <hch@lst.de>,
	Clayton Skaggs <claytons@netapp.com>,
	Constantine Gavrilov <cgavrilov@infinidat.com>,
	Daniel Wagner <wagi@kernel.org>,
	=?UTF-8?q?David=20Santamar=C3=ADa=20Rogado?= <howl.nsp@gmail.com>,
	"Dmitry V. Levin" <ldv@strace.io>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	James Smart <jsmart2021@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	John Meneghini <jmeneghi@redhat.com>,
	Jyoti Rani <jrani@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Li Xiaokeng <lixiaokeng@huawei.com>,
	Marco Patalano <mpatalan@redhat.com>,
	Martin Belanger <martin.belanger@dell.com>,
	Martin George <Martin.George@netapp.com>,
	Martin Wilck <mwilck@suse.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Randy Jennings <randyj@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Simon Schricker <sschricker@suse.de>,
	Steven Schremmer <Steve.Schremmer@netapp.com>,
	Thomas Song <tsong@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
	Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
	Zou Ming <zouming.zouming@huawei.com>,
	BLOCK-ML <linux-block@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH RFC] nvme-multipath: optimize path selection in queue-depth policy
Date: Wed,  6 May 2026 16:15:41 +0200
Message-ID: <20260506141544.125089-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Move the zero-depth check inside the optimized path case to enable early
exit. It avoids redundant condition checks for non-optimized paths, and
eliminates the per-iteration check at the end of the loop, improving the
performance.

Cc: Aviv Coro <aviv.coro@ibm.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>
Cc: Caleb Sander <csander@purestorage.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Clayton Skaggs <claytons@netapp.com>
Cc: Constantine Gavrilov <cgavrilov@infinidat.com>
Cc: Daniel Wagner <wagi@kernel.org>
Cc: David Santamaría Rogado <howl.nsp@gmail.com>
Cc: Dmitry V. Levin <ldv@strace.io>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Ewan Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Smart <jsmart2021@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Meneghini <jmeneghi@redhat.com>
Cc: Jyoti Rani <jrani@purestorage.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Li Xiaokeng <lixiaokeng@huawei.com>
Cc: Marco Patalano <mpatalan@redhat.com>
Cc: Martin Belanger <martin.belanger@dell.com>
Cc: Martin George <Martin.George@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Maurizio Lombardi <mlombard@arkamax.eu>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Randy Jennings <randyj@purestorage.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Simon Schricker <sschricker@suse.de>
Cc: Steven Schremmer <Steve.Schremmer@netapp.com>
Cc: Thomas Song <tsong@purestorage.com>
Cc: Uday Shankar <ushankar@purestorage.com>
Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: BLOCK-ML <linux-block@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Cc: NVME-ML <linux-nvme@lists.infradead.org>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
Status: Compile-tested only. UNTESTED on real hardware.

[I do not have access to this kind of hardware]

Feedback and testing are highly welcome.
---
 drivers/nvme/host/multipath.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 263161cb8ac0..7d212f6e865d 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -409,6 +409,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 				min_depth_opt = depth;
 				best_opt = ns;
 			}
+			if (min_depth_opt == 0)
+				goto out;
 			break;
 		case NVME_ANA_NONOPTIMIZED:
 			if (depth < min_depth_nonopt) {
@@ -419,11 +421,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 		default:
 			break;
 		}
-
-		if (min_depth_opt == 0)
-			return best_opt;
 	}
-
+out:
 	return best_opt ? best_opt : best_nonopt;
 }
 
-- 
2.54.0

