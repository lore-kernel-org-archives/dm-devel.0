Received: from sonic303-20.consmr.mail.sg3.yahoo.com (sonic303-20.consmr.mail.sg3.yahoo.com [106.10.242.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5E1318ED2
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 05:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.242.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791178213; cv=none; b=gK3RKC+ulSjE92WfVaqiwNXC6PFCzduejQv5vz7g6sydJQqom/4dDARI3uDHsz7PUBYyd49lufdeLz0/kkgxzWINiH002nFCngPDLL1g7AlgK7VT2k/1Nd4Aipy7mI+WSzsJUWk+1+oM/pM9fA7ErdjrSzWdguoceZJQUQ5fANY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791178213; c=relaxed/simple;
	bh=up49Q8nRiL+XIYlgB6r+Gcc9TdkYuo59qnZWyA7cvjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9ce3v4uxVgDTyC2g5s0VF2suZSVOgzbwJik8g8uaK3XmZ8UZjau662g9qEiAMF8j3zjmiVx328m39cBUr53N/7NtTbdrMnKdZqlCIUSAzvhCY4T/etz2xJfga03pH9eSDVJuSEcdvi9CcTYnJTrn0OMqP95V1UFbhXik29j3Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=cp1ArFVZ; arc=none smtp.client-ip=106.10.242.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="cp1ArFVZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791178208; bh=HPuINpFiBgh6K9Y2agbO7PL4xSlfRMOqf5Liwk8WbRU=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=cp1ArFVZTQWkD3WvHfXttdO9XietMt4RmPjHKjd7NXsnJ3XpufloceTfG5LYYGpjSqvR7R9WdVqOA6R4TZ4H65BBDc1NTEn4shuxqnLB1B95ajFnv6nI4rVea69FexsU5paXwReXkBayzXrR67jER+smVb72eb96GTiwy8T4IE9Ox8GvLTrQE+qgEXCr+DpFBOSo/nxI7ZJfXuZke6ssAbh1qO6ZMCQGXOaSeOryPadJnsFrNLs6ZpAMbedUoiDe6xrAUGCLeR2Qmpg6RkbstVuQpFEuOXe+PVU0bBRpU/q8guWFDQWoAnHG0NlkCgN2ttl9im9abNCVPLQn895cnA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791178208; bh=zKFi148Ri4vaE02VJDoP0r2u2/NKdnxb59d0OfPh2CH=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=f4cZ6fM06W2EmInyNLJmrDFTuoBMZZkpTwLaCpG7bDTDK3dC/EVn59InfkCfGX4bBXQX3teLB+jh815wK3Zh2sJX58JfQbGyjCMAKa7dftt+ptgSEONyzSuj+c4Rgax6Mp1n5eqR0MTauIuJpsCu01pAAM3//w5fjSH1dWDk6p7A9peKH+A5PQCh8MM9x2e3qU0y4AW+qjqStxHWVu/exnAOsdOi+elcpOnjV7ucZnEzZsoDVhhUvUf6Hy2Ze6tpAKRgQ1e9i51g5pku7wuwdJ95IG52U8J7yH3ZnGMSz1FBt9wb84LP0iwPc8/ABn9kZ1wC7oPUHYrpOiyePulcvg==
X-YMail-OSG: FXqR_ugVM1lXr1hFrnfYH4OGo_RRLJuo3MoIl.eqkOaByBd8S.qKi9_.0RTByNx
 rb86.NRydP2Kl_mSpZ1Wn.oB.wTfhQSPsL04S69RFRaU89xDMGmGV5IcxFJlZCeTl3aKY.d3ZULt
 rV9AplhHMVNp4K_OGKj_mvHLmNfMkFBomwyAVg1Odo.O4_VYM.j2ikKIn.yHGl5O5ZBdCRTXWkiv
 obwO8y3Xtnio5ApyeoiBS23whaS9oC5uRmk.RoiBGN9TO6mbSWwaNs94OKlOwRe_.CTV4JmSfB4x
 uYu95BGsRuB4hOUKYATFkuMeXKPxcS1yt5qmMvWk7TY9lpkLT6rTPOj1Q_06yOlIF4LvZVbE0uXS
 x5650Zt7MRQF.61tTVi7cFEP1AtqTtCnFLC_DphLvXGduc.v7CxDkUR0hPrSXRAwyeTkb6gt3EuE
 R6yfob4T0LhHsJAa9HTqKPfo.ig1Qiv0AdDwkqV9.mzgEun6gOhmvpU4HnOs4gFM1apo4ZS9WGT.
 Absj3X0DSBCs8H.FDb.Xo.adtQUWAj8I8MpFgxIGlUoki0pi_1Tidor718AEI2m6.1i0Gjl53xME
 J3raU.9byQr1XTwaRkHPdjWVK4AnS9CsAQRPYk0xHrjUjp5sxvEuBMqYU26.mQlZfiKzrXyRho0H
 0pSTI75ZDQtwNbE2EaD5e_CJET5Q68wdgaWOBMWg.7UxEpmuU6_EDSrl0.s1xjmZuDQEQmVUf2W1
 wB1m15TJYvx.nJpwXm5a5FiTIjWr_HbUrBa9Ih18bddpsg5fmNFtsdryJ63LpXP88pLJltogiNre
 A2xrThaPmCRhkk.x3meK0CFQyIOSdeEU.HyWUiI0jh29N04vSyohT_GbCiNuZ_.sGcavvV15qH4h
 Fsuovq42o_lvqp2lKTbOkCgSGjWMvFMmDCkEkTdIyGFT0k.YQTeYCoWsxgdDtxGYjCMvRHnK9des
 D2KXvjOUkWUNLKi49mIPxvlgvc0_3ew4Xy1nwIbRjgQb4DcHTIC.oOJzZ5yrr.5ftRjivgO0u9pJ
 Wumrkpv4K65fjR6ri8KV7bX5nL6bjMdLlycv9JZkml.SZEgnkLCj.rk.2raC0meurEG.AyYtbtiv
 rzYEUL8m0zqcw3Yxl2.eXxm2KCPWGXNkuM.c57aPn2BUUI2tFpBX.9RBs_zoahQ4_UzKWJ5z3GM1
 ZgRN3k75lFf2Lq46Uaksvl1n44usBE.a8KRPTVYTNE7wOuuQfB7GwYrwKzKJZrut_b6oN4YQNvUW
 y_B.3h8MuldJAI85K4dDpe0U4hB6qPznLx7oAZPpVtsFGO9V6MIwFRruANmgRH_FYoUVn5u7f8uO
 1MW9VXMEsOjzWLLCQaonW0msCfcfANy1Lq414D8bGKq51UYZsD5M8REiKxzUtrfIjsQgFIvA5d6l
 zcBcAzdOUYNcvt914FZLVnmoT2CE6_6V5xEIt7_6mmQH4y7Pb6YonHptqNotgFirxBSWGoQmiRsz
 gAa6FVMWzCn_.T2rHD69_Gx7SaFhxlJ8GEmFjn5_By3kUqbDkfu9vmNgRk9bOtlGtg7w4u.e0W_b
 IydJhGmB1Vo8U2vdSSftzOr4rizDU8rr05NlyuilbQLrkum8g7E7lK82PrNDDvcSzefrBmaiHyCg
 egld0lWV_PYeAgXYA.hV5P6GI.S8htkKrzhNqrZfOrYbHom0FAiZgXfkPFyohoijfJCZpgZWQ8yP
 gY5jofi7fYqPFebNsJYTZoB3ung6zlMHDvl8eNwG_cVoeVcOQ04AmKYZJ5ik_ARuj2pPnNf6HhKz
 x87xqe._F0MtG46GkQLe9.UC5qhZmZTreOjsbqFrmK6CIWL1ZfoVuP88eRwhq2qFpxSUg2PoTV0C
 q50V1wL_lz4BPLUcmC3jbKU3CNkx4ro.LYrDed0lc1WRKUEmjFO2xqyfbYcknXlL1VNp5J26SZl2
 IKH397wUwRSjCEHfJofgx9cs8oe4H3cWjfhqFSt75IIf6cX.zQOJqpvevGC7Totq7GSxOy1nnFuy
 UovwCQJggQ7NnEwFoj3WBu7OsMJIPbi6ot66qp7Hv1vglsIVf4D12KHlVLJHmsL1nbgXck6tOMec
 MSVzP6wQTmFHy4nBO6Wfv7YC5.D6TQXpzxkeCnwNnUfZrt98hszZsx95Mm9YCORZezHaxoujyWnd
 CJk.3fNubavdGyY3ke9mRYfkmmn24b3glik0W0D7JwavgIHJhee7lj3V2yAJZLq._G6NxQO4rHEV
 gMt3o9mLAh0Z9OvLR1_GmEIKGsMnHp1Uzvxv4wvSdUBV01rCZbH.eC5L8FAUBe_mc
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: 1237a1dd-073f-43cf-9fbb-323d0e1568ac
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.sg3.yahoo.com with HTTP; Mon, 5 Oct 2026 05:30:08 +0000
Received: by hermes--production-sg3-cd7bfcc7f-vr22h (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 77555b61bdbcf6f8d66bc604be106356;
          Mon, 05 Oct 2026 04:58:47 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH 2/2] libmultipath: dm_flush_map__: retry the resume after a failed remove
Date: Mon,  5 Oct 2026 04:57:26 +0000
Message-ID: <20261005045726.71858-3-suresh.thelkar@yahoo.com>
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

After a failed DM_DEVICE_REMOVE the map was suspended earlier in
dm_flush_map__(), and the recovery path issued a single fire-and-forget
DM_DEVICE_RESUME whose result was ignored. If that resume ioctl failed
(possible under an ioctl storm) the map stayed suspended, which wedges
any later task in uninterruptible D state and, because sync() walks
every block device, hangs I/O node-wide until reboot.

Since the map is known to have been suspended at the start of the loop,
the DM_DEVICE_RESUME return value is authoritative. Simply retry the
resume once if the ioctl fails, so a transient failure does not leave
the map suspended. The remove is still retried by the enclosing loop
when retries are requested.

Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>
---
 libmultipath/devmapper.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a5570a85..bea7e804 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1062,10 +1062,12 @@ int dm_flush_map__ (const char *mapname, int flags, int retries)
 			else
 				condlog(2, "failed to remove multipath map %s",
 					mapname);
-			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1) {
-				dm_simplecmd_noflush(DM_DEVICE_RESUME,
-						     mapname, udev_flags);
-			}
+			/* The map was suspended above; resume it so a failed
+			 * remove does not leave it suspended. Retry once if the
+			 * resume ioctl itself fails. */
+			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1 &&
+			    !dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags))
+				dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags);
 		}
 		if (retries)
 			sleep(1);
-- 
2.43.0

