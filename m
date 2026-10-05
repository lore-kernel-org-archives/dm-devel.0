Received: from sonic306-19.consmr.mail.sg3.yahoo.com (sonic306-19.consmr.mail.sg3.yahoo.com [106.10.241.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104379460
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 05:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791178212; cv=none; b=KyPifcPXlmSZSTH26GSDZBwTZKU5aW89t4rUK5YW9ArmD/d/p6QCJZyKTODr+Jgmt3pU+5C3f/Dx+0u64WyPABUMzc5kA0u38d3FKpaYsbPG2cIObwlaarIGUtCRwmidWGmAkMpOMFmxTazIqCILNcl5kourZJ6/Bpz/Zjhit/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791178212; c=relaxed/simple;
	bh=9xUu3IfEVux1kiatx4FUnnwbvoJOyASzfYbABw1bXkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=pKev89BIqXk6+sHdI3HA+nii5fGFUiuX6nTA/LORzi29RcxBO0BWs3Yb0yg7qEk9ygKoPTfDid0+Kp+6JbXVcplGwPmYTlhTqR0d6nbLU2oMREe7MlzHkr/oA05n7TS+ziXZbf/sJ6zoeCCbZvtcgM3GBqQV/lsKgYzACk7Pl1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=qp/C1DF3; arc=none smtp.client-ip=106.10.241.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="qp/C1DF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791178207; bh=s0sddM273P4tCWj8NbsKqIcc/Go+t1E3R0VbXXFTV2I=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=qp/C1DF3yBiiY+xMVRtq4sFuBi2aj+ifJL33UxEe5pKm9ZVeV1bLcCYUB5vY+0zP3gHGk4Nm4/kYYdxdfhEmlSN8PIxqD5JyG6DJr3zdYEeMGGMeJExgGJVTZGkcXkh1KfBVM/7dMwuDfzQMl0O115hAfd1QgkD9i0GP16P5Va8mBfC7UUw1ProCELA1EZotzO0P31boC1roR221/0DSzE29TM7tPJc29LWYse9UB1cH0A/z4wJkloNx8IismxP52tp/MwZTuI3sCFtMTUCFjqiPVd4PwcG3WKdiG9hJMVF71eLv5rZokIREJP0kct+STV8xx5SdcjZpVGoJFH7rNg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791178207; bh=wPS7AppnJzbMaLzdw6MvzfYcI0j4NliX9jr4N7nBGmE=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Z4x0IvZ7FaOPsF+qLaGPY3Y0PA2PcrXxCz15E572lBx1GezubntUKxq3p8hXlv3ouRcKBEXDMgM7l62muxUEQ7F/K3IS1yoNVLZH2Ea0Jk4a6TTn0UXhEITsFZkSgAbbIfvE8JIkOftGyochQ2ZEVGEamIqTv5C5Lp6QozH8iUzynCHDZ6fri0+qRmfBjpaFihTnuhiWsFw4dbNRVKs60V3cjZrFI253dmSKdSiFh/zawluaJfEbR5fcZjHYWXsjlh6UxgpqFERsb0u3SZJb6OPw21pBl+53YR7zh5vcN9Vb8/LmBCBHIDreZ43QFR87UHdTCbY+0t1wCmjhCajG/Q==
X-YMail-OSG: cmwi_eYVM1mzTMevNvQ3u6hgV65oPCnPR4QEMsUmfKw7j4VMGZ1FJfSrWZHWr1w
 Q2GA9yMR_VSgnYt3IXGhgGZlYpsicCYG55MRd.hUGTh_i7.fEFYvOaCXU31Sx9eItwddwcF3wXxK
 XxApQrQomYOOxvoucj72T3zHO8B46kkHtoX2_qiMLt6hlubhd6dTiCbAzOWYl78GBvHXcBKaUoav
 jgtWJlUruYXhuwkBYmojEkZ1y.0_TTzaFAz.hs4YTz_DZwkvVDBgE5HWlGjMklVt.bmjitmLPGUi
 4c9yLKsYXbuwt8Ckik7iJdhJxr8kOCNm7jJRi_WoztMRkniDmQuruHqX6dZMVdEoQVTmFMpj9nvT
 xt4GG4RhvioCG37CuQTyJ4OsZZk0_eYbl5mbYDKI2H7u6hWo6HCMWfUS8qhttoqBh3KRG2hdrsSG
 0ScIBpm8ixFRkQ8iz0f.UK.nw01.wltxO7hhilB7K2jkT.rpT3ic57DpM3ystMYIjFWgeWCVGppb
 mxtzMm0iSiKSKTq9bYKzqh9OPqJyYsiP0eKHeHvMulxQVcwj3epq.i82KAgBYWHGoYzdGcN2biZm
 r5XOoKBaVNplwT.kF1OHmC72gqp0zSivvVq_m7GkZ7o.Q4GdJy_zefRdUZiD_OM2LSwv61sEFrEO
 bn9Rm6lbbgJ02X0AA2BWGSxPNu.7KKX1nU5lsdUoOkZjZ_g0BWX3RYF_Z_0T16Pulh_JcYZxlTxN
 d8imZwMF_96Il9wEc.n5JT024upaBQ.xKlVq_q6p6Wvca4g70GHZQ_W6AqfUYniSj1mi83o_iU5K
 NIQgJ6gyidXCtJz2cDRr8a55pbFjnNm7bPlJ6CEwTjo0detTPsO7NpejueJLaKROL1lBZTfG7cLf
 FSm_x4K4gFmcC5iLN2BPP5mJpxTy90kkjrmGFvFzolNLGNJXjI1m_vJNNO3CXmF1aAhYUfQuTNLb
 yJoOQ5dHoZykTV7dhEPnFoVmD1Z12Kg6hwF1MkZHIyFVNgjZsxs0tc6ASgzKSh.j_Ty9LaOHyV7h
 SVSyNdUWp5JHr5sr_iOGIFq30D826L.6NDgxkf1w0ubHLeMaLlyB6cKcFwLtDQpPcsZNzuzOPEhF
 ZV.DP0BlsiZhIq4gLsFeJr8KE8g2S4a.qb2_svkkUq8qiGudXLUYqR0D5hBk36WPfeqiQc.kUbGe
 q80ZEnK1dSR9A6K8TMj9X7WUR.UqiWty0CZ4UYMsH9MiWi8QyYt8To4x5M9rknOk9oZjiNhjpcnJ
 gCKh8Rhr.cZRAuySsugWXvTyoCHSMtP_p4aiDbjMghriS0occXYbQ.mghG7anT4.e418JOQaVDHq
 2WSvykh3UuNea_yotXFqoqsOLaqVzGeS8.qC4X_G6dPzZxQCHUhHKOrIacMZTycKf80rHPM0NWez
 IVNzPNsr71Z3Xl6lhIUUUNy05VJBFg2.9rKytlwdcPuIcbfeE1FDkyxE1JiGsnqdaa6_SgQLeb41
 79PsaJwx2eBMKtxV1cEEfG2oTWoNgoKogayq9Ovddk8kTUwPqfVCTSOZFVJNDI7jWVgBQmuOvs00
 ivVxxzFlsKKkrl52q0flDLbZPY7sLZ5JTJf4j7JyG.fU2SeH2yhLlt_iZD9pGzVogpV76oRfMZAU
 V3pEcdrorVZlrYATNi9bkw.1NObswSCJaXO5jmEy0w6jr4X9uJldW0X_A3RwZCbZoVPVy29FlZJ7
 yfv6k0sYV.nt7lpPgj7wHoocTE_IrC9eK_753Uj.cjCo4esnRpYrxqJsipapExaO6shBiF0BMGT6
 Z0G24r0x71Wlfem1i3euX21F5Zxg9xpmvQwtONZps15meUQ9NI5qtxXXO.TTDrecEqovMwwvlFfK
 9_nuiAMDmTbYLr6SepasqdP3EGAIbv9COCzyflA3M2vBJGVaisjX8BQQpOjvUu44Q4slpbDcTZpN
 GrwFwTYoKh4vA2rPchzD6UJcKK.B1ZlHyOPxAQmm_Mtm5sEoEDn_BqGXUl6VWR4mwQ4zwxmhauaa
 ySwvYyMDV3e4BqTfC2SbXzx8Jg1pu.qlnoW25TypZmVko8BX1bn3osSi7MJrCgtahCR06DFiorxW
 80k9Cf_NoWPOanalTjP3igSPkUjpqjBl9pTEOygYGBYsaPK9lsH483jboIDfv.nmRMnWYNLrMjYL
 kndIQJ1LPGCGDlI2MRDxr.tilLX4fdJSm0ZQahokLhxY.dS7FZNxpEYFIDd_OJzaQd80QMN1XbXe
 3Sd6vySeoXfyq2C0sV36kq0H.ibEApbsUmTnZ5.BpEOUOlVKkVeD44aWDAw--
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: 77800e2a-6318-4160-a841-a00efbe7c60a
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.sg3.yahoo.com with HTTP; Mon, 5 Oct 2026 05:30:07 +0000
Received: by hermes--production-sg3-cd7bfcc7f-vr22h (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 77555b61bdbcf6f8d66bc604be106356;
          Mon, 05 Oct 2026 04:58:45 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH 0/2] libmultipath: fix leaked device-mapper suspend after a failed remove
Date: Mon,  5 Oct 2026 04:57:24 +0000
Message-ID: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20261005045726.71858-1-suresh.thelkar.ref@yahoo.com>

Under heavy device-mapper ioctl load (e.g. LUN-number recycling combined
with ALUA transitions), dm_flush_map__() could leave a multipath map
suspended indefinitely after a failed DM_DEVICE_REMOVE. A suspended map
wedges any later task that touches it in uninterruptible D state, and
because sync() walks every block device, this can hang I/O node-wide
until reboot. The storage itself is healthy; the defect is entirely in
user space.

This series fixes two defects on the failed-remove path:

  1. Query errors were misclassified as external removal. Anything that
     was not DM_IS_MPATH_YES was treated as "removed externally" and
     returned DM_FLUSH_OK without resuming. But dm_is_mpath() also
     returns DM_IS_MPATH_ERR (-1) when the status query itself fails
     transiently under ioctl pressure, so a still-suspended map was
     abandoned. Only DM_IS_MPATH_NO now counts as external removal; a
     query error is logged and falls through to the resume path.

  2. The recovery resume was fire-and-forget. Even when recovery was
     attempted, a single DM_DEVICE_RESUME was issued and its result
     never checked. The resume is now retried once if the ioctl fails,
     so the map is not left suspended on a transient failure.

Only libmultipath/devmapper.c changes. There is no change to the success
path or to behavior outside the failed-remove branch.

Validated with a deterministic LD_PRELOAD fault injector that forces
DM_DEV_REMOVE -> EBUSY followed by DM_TABLE_STATUS -> error (so
dm_is_mpath() returns -1) on a single scsi_debug-backed test map:
patched builds leave the map Active; unpatched builds leave it
Suspended.

GitHub PR for reference: https://github.com/opensvc/multipath-tools/pull/167

Suresh Thelkar (2):
  libmultipath: dm_flush_map__: do not treat query error as external
    removal
  libmultipath: dm_flush_map__: retry the resume after a failed remove

 libmultipath/devmapper.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

-- 
2.43.0

