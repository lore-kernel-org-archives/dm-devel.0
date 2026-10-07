Received: from sonic308-19.consmr.mail.sg3.yahoo.com (sonic308-19.consmr.mail.sg3.yahoo.com [106.10.241.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C466546C4AD
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 09:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365600; cv=none; b=bRqsh+QJDd6MvY1IKqKCI7XKGGXQfjwwp1Ac9aM8/lD+aCRYGaVmIxIUvRVrUxWKOKnkZq9Z2jZTFcryNKb8mOE8v/W7sFJ8qW3wxW8vCxJvDtRU1M150T+3Sqbym83ViLQCXzdKbrs+BpaU8HxSQk6ddZyrv5yQCUpUwgDPJ0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365600; c=relaxed/simple;
	bh=GdmP//O9x74uMXxWWkNS5iHrIEywalwBusSO+Gfd0Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9n09tZNoCW0EQgRLlYF9JKca/IUuC7poVyBTjaP/rq3lr/xVNOC+vkeQMCPp5v3xVeICW6YTg82YGjF3KuO3El5XXk/7I6bqMcPigNGmzPkV4sEb5plZebt5gXfZ1TkwvzFEEFmb4hy2OuNo4aAcWNdIm4mq24rkX2rpJNdRR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=AhF652N3; arc=none smtp.client-ip=106.10.241.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="AhF652N3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791365580; bh=IBxpQIOwLRR/MT1N1AELEGa0OcmEEjiGmE4hYqmUd3k=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=AhF652N3li0H8cQ/QUaWLMDkEvECTeq+Ly4CXNGwxh6UoUEbAUsSzNCgc/4t2eA5CPTyiho+iaOFIegCp0+e92dl3Krb8xOQeTxPh/8WhLhm3wVOfhM43aK1vlsDp8OcgY8f2oxX3BCpIN8DHHNS3aIGnFaVQMsb3RelsDcJkMQmieyBKs4Y2W6Tyi+Ko4SSFJ+9avDQ2TlOuX72I1NYzZSkdudTAvL+rLwUjCvpYtbLucT201/9FaHHy3jBkQ9hPDztGKtXaBViunuf6VdH6K2+s5ja0Jj0SVwbIEHe4ua8dgFFAoNd7SKbEm8lTX6sol8fLY1rrOqUVwRt0R9agA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791365580; bh=Uo2HsGv8SrV2lItv3dqJDFl5e7PuAhYVybRx/VDAFvK=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=s7RCA3dKKg30m+UM2gm9IAAZwWMtSzAj7hL4VJRtB3YKRubghF4YuXWShKQAP/HgXZIcG0qbkCVU67UmKHaW5l/uIweJ9YmEDeq1QHFxIc9Ko446td9Lt21zx/aDfxsVnvktd+aS+wkbfle9n9Gx4grD9RixOJVb8b2kQ4M7SvkP6naTpsiiZgBbl3yQxiseFlohCNejSz2/vmGhjsnkdck4b91cP22eQRDm20qlNtCFgGodkphewiUTyh+2WwnjFCizcYc8BJIfxxV7roqKVgPK68jhEK1R3pb5DQDiMw1dPkanGfELklhnRvlMqKNrDQw9aGF2QIAtucdv6vtKSw==
X-YMail-OSG: Gn1UhugVM1lCOPHiuloF5HA9.xoetMmjIWjhnVM3QE1WTy4wbuY3ci9xsjsDe4b
 n_2OXmtL0k0VV4c25sCatuVHyafLQcJNtqP_rEia58GehbZ5cHmBl3Eb9Br.YxwHDbX8v2L.VT_K
 nyotJtaafAIJXLG5Zm.ykMQUo7TLDI6FXsLqq5Nd7P9q23IHGaJaCGdAJW99uMyJMen24xmujZ.3
 3LrrqJVdl29U1ccFl3Bldz0NLrl1HYaLqrc8Fr1Rdr2nOJM_gZi4bFQibKiRfZdJ8pYKZVoi49qX
 Eiw80BGzx60i36c.yxmgaxjy.nGxTeLzGHuYBIaz8xdyAPQNZPElKKggxHLv6XQi8aNNXC8j0DTH
 pwNc_DGBeEQIMxyr7MSmaWP7VX88nuafH6EbQmqJ6Wu1JHPKCo3uPJD7n.LTbqlyL0Hzf9wU2lk7
 nKgLonqGczU9tIzvGGwiOyafUXIcA3xYWMXIUaFcGscYB8ZYXdRQDBZRE11ncdb3DnUuJCTCOSVK
 IEXHl4knzC8fgT3SJXCuQ1x2leu3DVS4ZWcxhjShhJbQFm2vWe6V7rlmNtj_68nD86UoxPJ8UzpX
 PEPOnFEya6Wv9eVq2kG.Ig2nVEn5uV.MKzOjJtDTqSwDkaMkKD4_vhPoYU1_T1aNATbIpgzcXkHW
 AZv6wblLAINbrnCPOV2H8Z1xfhbNU84jJzn6FpCc1e6ZTrUS4BlaKNeV3tvFfxQCHn.qTpCTTjKC
 jFkjJlwT5hJvzZmUX9jIo86MFQKUxhXwxths_HCWE7NEGPAsYuAmFi.UNTFBfU3mH2YtHiZNljoZ
 .uTzTjvVFKhPdWPWWNIifVB3fVQU02K0Go33Y7PXA366YLRO89l76ALaGx8fBc5zWuOkt6umbP4P
 I7J9xDDLKNFXMGaFX_waqK_RiiY1WClpdcu2q.qn5yA4mEdGdPr8_1i3jn0RpUXBgtQVjqiBD8fu
 DtFjOoMOk9dIJPLjfvHZiCmJYB_SXEzKLifx1F1AkzHnw6XvZ7.iXBvqIDKaqYT3.FqXJz3IwXVg
 Jvvg8.xGe6NNs5DBV5UhHhDGaX5kfebA3xuXO3t.f4B5NhCUcqD5OeMCNaCHxUFKsUmMJVb5x2xP
 uBfcv0REME4VCYx2YCbB7m9cEs759Zccw1HFkOGc44UZAAHhJu83jCKBeRtarCUFddyDfBbGGGNH
 I34Vk2IPCnJnZ1N5a.hH3qG1m7Ti3Ghjf2YjOJC6XlD26GvCwvjmBZdBbkWUAewzLZ8LB2riQeoY
 FB7PtJFt1LXmo4AEVcWDFJ00irwkFl50prS.cS.AwXx9mk8C_kkTdzLIcdIUpbTp7sb3nd2Gw.kH
 KiPBk6TOXuzpLoclkcGtaVpIbMCVfLusU8.4EpGqNt0vhoHsxf.ShDNqVay9iyKV5ad.ey3sBdyN
 Erx5xa.kVcB9w1I_QCyoU9ODnyWbnj5dLrZr6MtkYsq1xO3yHVKTNcNaIBq9qyMkFB6YthwMDbWo
 I_AAws5_SXoIVwVKf8Zkv1YifDrm46KHvH75m3A_TgVwh8qS7mLvp.Gw_Mth2O8Y08miLuK_4EMO
 MU2hZvH4J49A3EZMUIYoe2j2xZoNrq2xFh6xm2c7b._pIOB0zzUUH6TCdzsvNHR.ku.YSaqoDs6G
 C8rxKqdH6cZEVYvTCIZ3tk0DcLap4oTEgnxnfh5GoH_eOtGQpCdeWGwEOMCkne1I35e1WsmXj9w2
 ieKv5yy9rORCYU3lWKbnAkeLMysDn4FyAZTZZ3S5EiAe26ZHP1AjCR4rEfrAHi823vdrjFhJD9g.
 RGdf9RLAwBGUi0j_PmlpwZ.4i1T7bvSYB7DT7SoV7vTbAP9tWorynM7lrtqsAF0Nu06EW3Jb0QWX
 mVeER07Qm5Vx4WC0L.CfbSlCjrj7i48RN7cpCbgULHEeqjYXkR6vBPktMIyA.XmWG3HZ_WoXBMYV
 .ftk2vi96mtdGYJLUKQUnF8D0DM37MFxdgDKYj36Y_yWhtoHqlmFNnXpbLqsFnDB0pBU6LYiLBY5
 ..LtisaoeP2.2QUpppfg1KXpU3hcPZv4Ivxyrhjy0ka_zpz_BUYYRgHHIJ8I7yCbYEnw..REmGmA
 u_EBZp5eXDgmuMpbUxYuMFS1Xd_.Ml5AE1C.QnaPwkbQkdBZfdLDF4iAO0wQzTmILDhzoyb0eFII
 v5R88QmAks0WNLdfgP0UQiCnZHqklSh.1ckzUUmTNUmx_oA1B2Up2tyWdOf2iicrXVJM9FsMqG3l
 v14_PLcOl4jX6.tHWEyXpoBo9yDxZfJOPUnTpE.0PxyWjn2bufvp5R7xRtsj3J260FiVS0bsalVo
 oOhQ-
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: fce19612-1eb3-4f48-b73f-b103e9373095
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.sg3.yahoo.com with HTTP; Wed, 7 Oct 2026 09:33:00 +0000
Received: by hermes--production-sg3-cd7bfcc7f-rntbs (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID c6aa332ecc93d11e3ca3dbd3283b5adc;
          Wed, 07 Oct 2026 09:22:42 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH v2 0/2] libmultipath: fix leaked device-mapper suspend after a failed remove
Date: Wed,  7 Oct 2026 09:22:34 +0000
Message-ID: <20261007092236.165908-1-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Under heavy device-mapper ioctl load (e.g. LUN-number recycling combined
with ALUA transitions), dm_flush_map__() could leave a multipath map
suspended indefinitely after a failed DM_DEVICE_REMOVE. A suspended map
wedges any later task that touches it in uninterruptible D state, and
because sync() walks every block device, this can hang I/O node-wide
until reboot. The storage itself is healthy; the defect is entirely in
user space.

Patch 1 is the actual fix. Query errors on the failed-remove path were
misclassified as external removal: anything that was not DM_IS_MPATH_YES
was treated as "removed externally" and returned DM_FLUSH_OK without
resuming. But dm_is_mpath() also returns DM_IS_MPATH_ERR (-1) when the
status query itself fails transiently under ioctl pressure, so a
still-suspended map was abandoned. Only DM_IS_MPATH_NO now counts as
external removal; a query error is logged and falls through to the
resume path.

Patch 2 checks the DM_DEVICE_RESUME return value on the failed-remove
path and logs at condlog(1) if it fails, so a leaked suspend is at least
visible in the logs instead of being silent.

Only libmultipath/devmapper.c changes. There is no change to the success
path or to behavior outside the failed-remove branch.

Changes since v1:
 - Dropped the v1 "retry the resume" patch. As discussed on the list,
   the fault injector never exercised a resume failure, and on this
   no-table-swap resume the realistic failures (-EINVAL "not suspended",
   -ENXIO "gone") already mean the map is not left suspended, so an
   immediate identical retry (with or without a short delay) buys
   little.
 - Replaced it with a patch that simply logs at condlog(1) if the resume
   ioctl fails, so a leaked suspend is visible in the logs.
 - Patch 1 is unchanged from v1 and carries Benjamin Marzinski's
   Reviewed-by.

v1: https://lore.kernel.org/dm-devel/20261005045726.71858-1-suresh.thelkar@yahoo.com/

Suresh Thelkar (2):
  libmultipath: dm_flush_map__: do not treat query error as external
    removal
  libmultipath: dm_flush_map__: log if the resume fails after a failed
    remove

 libmultipath/devmapper.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)


base-commit: d53932bdbee02f440518ea384e63d7c4d3f66685
-- 
2.43.0

