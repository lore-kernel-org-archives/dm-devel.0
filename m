Received: from sonic313-19.consmr.mail.sg3.yahoo.com (sonic313-19.consmr.mail.sg3.yahoo.com [106.10.240.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFD83E0754
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 09:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.240.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365603; cv=none; b=Ja34JE97IaqR/Hrv7yaOgr65gexlfDni9vI5SZGn3aKlU37sUa+M2m0EkpZTtyXOlfAZ1v0raiI7UQuIjIZTb5agXXutTrOg5pG5z8ByOiMm6U802kcZ7fxlSBZ7mZGA/qF/zsESdiIvBGNK/gxHUH44IhSCukuSUSq05d8uSkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365603; c=relaxed/simple;
	bh=l95/+/RyjgGt9W12BZKaUvc0XYk+4SCwkQqXKYqpE0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHLlATgy6lsahazPwdXeC07WXErPgPd14rSYlCh0sH1anGdBxxwQUth2Gjv46mgyUcyYelGRY/xMIjYTEzKYRIKph7SyWEbCX7vIUGNSERsMorxAhbVX4ClbgNp9DjLhM59tOwpeEiV4x2C2jeV6iMP5eoQoQhSVeY1QCNtkmVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=EY7kP3qm; arc=none smtp.client-ip=106.10.240.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="EY7kP3qm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791365584; bh=5kcHwpSpU++ojVGe8gUWq+naTa316eEPqQBGG3YkYb0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=EY7kP3qmhG4u1QGzbQ32pm8CdY/+fe7GPgyAqloao6XBXSjykceXheo7Ae4BdGzJYXfycL/y8bbX3dyVHOo9dS8d+2p/G+ENDqmdQ7Z9UZevIMqTBwTg1wiQ18FATpu+Fajm7vCMoT5OTqU9pWrw7MzymDT5e2K9nZEw9z9FdeQKjnVOJ4tJDzZLIj/HkvAKmoOzZDqfrwAfMUjbF+EE1KJ/7V9BlKQrw+EdKbpcUFtr/WIx8UG0wIt9TD3Wffbjcrh7GB2G89mkbncpRGFmeHf7lENBI2MZfs4hfDPKCXEbPEBYcu14R2echbK0WAD3J4rK7YuxcuXwL+AK6KGMtg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791365584; bh=0MFEuVi/c5x+rVNbUFSDknYd3VPoSbObdyqqqSFogLi=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=rZwRDig4SIJzmI02I4BzVPrNRwjVu4Xy8Nsw+y34WMS789wpVxwjMQibrj0KOP1TiMALrFoZ4ipuKCNhUjxZXksKzw+Pn6BkRfD4gwWsRMguXXyr2fWK6RFSGn1rREvad+WHUIZlFZpwOHTlNRxABgxm8vreVERdvNaW7xCfgI09qQzJ7U7X+7fRs5jpR4ST+x/ZzusbCHiwtIvnFILG0gw3DdF8PoSeGdEylKdZvxKHYW7ZVFtel4JzG9EWmEpRzd9r4cPdekBrBV3hWB24ApPe/HFoYO/S4WPjc/R/ryvEuLDU3k0ChJh3hcLBp49bD1F/StTjGYZvR8ShJSlHJg==
X-YMail-OSG: mt6mrBkVM1nPWEqvHVnXuamUdf5iDmhRMrZ1SVeWbm.XY0Dw69NX8hZDDbqWm_P
 H2sG0iso8Gtj2_dQHTduFLtWv1Dse38fHcpseRk05IaNgeWm9s6uQQId_wL2eJ9BPpzsBxl4N7pG
 OMlIiQD1nHwVlDmifzQJ9HjJwXt3YnpMzAg88z1niOkv3u.BssZ4z6pki1yyvddOM0lnBZ_hTa5g
 PMbNXhy97DTZ2AdqF08apo6hLsEoNCS9CsfXiE6M1dmfzU8mb7JYY2V6TUEC6AfH.nVv.i1fqZlo
 IdaZBokkyxXJd5B6FaNxHDLYlhydN2RqSob3Mg5kqrtjfa6o797ZH02KpmOs5uReV3QWAfnTS7z5
 klTpkJ3y5WEADP7xmYV1aTTx3WLrvYI3ufzxk.oSZQHIBgKxXwcNdogWfe0Wa1FjqqJ0iTmcgnpE
 .VqFQXwd7Lhfz5dGOi8Y9kp8mzeKBJOBvVN0Ow9gOhtHWzVQOj3XZQdup8SeVUyH3utUL225o3ve
 z.HO8kLqZCtL5wxD3lOEl0YhMcDHnJw.OTM8ebUdVZkGA1AYjiQnQSYyad95jXRpABtGWTly35Nq
 GrGVaZX.AMguSEJH6r9qQQreBadvYx2byAuTalDs81gJ.i.57VU4lDWRJYEb870b2X6q0500gfbi
 RQa6GhcgnFWE5UdK3ThkHWEXx7C8E2kEa.qq._3bYnOaLxEAvuw2G.Tq81rB0yKwA61XCIq8FMZk
 zoh2opbzhn8fYCiKtDnODm0KIgR3Pg1RCaAZ2sqY2EH2EYURU5ukwYCeUe9nsm3rxbmf9fdQt9M.
 Y0iSv1BOm6URA4hjY6B.PduAyaeBCM2JlekB4KQMdIEBYGvzYJmNDeHk41AJiPgydlu_cbBDkzpi
 kcqE.qxW_BMlGXm12RMSPZcb8D3t6TlRS4VMntZJ3QQLDbomNW4Te0qUQqEdKB_CHdkHiKKpQmfR
 oJkuDrcbZJXQBHtKou6wA7kq6TwbIIX1a7MkACGj9Kw6Gh8rlBkDCeI.CJ7sBjrEqpdcrIwiWZYe
 hUZkFm0N1jY1B6dQbgmYJVnkfIEgNN8a4AFdMi4wBCYcuby9.EnKOs4cFKlT1F_ltlp8Nh4RCYHe
 1AFw4f0FZXkovBy4h7aLZXtQa6SzLBm8R0usJRdMHpx9sPsvdLCyE0FxnKihUmG4ZJYOLe4weEKU
 s2x74VUVtcJZfrpiMrRKdOZwh9XFxUvZxKqa6FPQTG0.4od_HGa0EaoQ75LNcL7ngcQwpjCurE9J
 XURyryOQJ4GQtlrHnnQ6KhHTbX_QxWSX7UZLP7JV07PYj1l4xG3J2JDfoB7SuaCZM1nW_Q1MlZrT
 HiL1uHjmuGLah4pNP1YzA_aTqJbehiq7P8Rsg58KtfOdXLId29cfJYLpqt0yE4ICPNCIa2q0PejT
 GrU9CzedzqgnTNIrf8kNmyBbE7VcG8_F7Nxn1cmNkdW1L7SAjXL8zkxy0UhscyN8aRSmrQuZFtB4
 gT24smEFpba.JtlSJfucpKZBxrDRF9LVRPFM8Jy7sxRrtebLNGLwpqm0nqlv6QinTwOw.IBXmLKM
 YzS82irMx1RBFwg1eH8fY5W_EIhl3LIeMQtpDr81yaN6i9XW3dA1AbI5_lHF_uPkID4dOwqLOOpM
 t2O8w.z66qF4eelVAPBe_UD4zfdoh31gS7_1wAc62dht3TX8ZoNRbub5KvEeoCPqyps9wNT6mjKL
 XQfW2Mcip.28vxTpX6PJrnWEsLeTdu4VbNj2MtjGM3O3lsC.Mcig1fFgXu81gcbCNgtcwOzY1xn.
 JGmacEXoOIDc3gjjySH0VJsDER1IlaQuAllSiIzAiUjRTzkFUBZBWY_vLIpIr4z2T8LSMP4OA8pS
 54tEPqq6F.QbChrBiRlD8s1x04FVNTFtHWQE4h05HwABdZJtyn07mPsq0IV7BFxf0LZ8F6d4HWFg
 LK7JeN6EuXg6Xlf3UCOEkUbYqpg8YF4iH8mUYjF0LHq8ZuVphWz2ohTO4gCxlAjKMPzl03cq.yho
 fIl4Ldz1fjqTgU3ivUAtjCnFY8kCfIBQeFglfI38XB5kBEb9wgtDgCAb20J2.gGF.PWFmip6pPQI
 aTJcieTXU3uun.rduPIJb4EgJu50bOl_TjKeNfCVF8_6nsFNoc4JguMd5Q74T9VwaMGq5RDBTlBi
 Seyb1cFrW9BirN4yU.ht3aVGHpAlX72ikw5mcExFwkaOplzAxxiW41nQ2r.BjThhk6NhJ_OWTmb4
 JhUhn4Lnrzef9sl7Up_JS1J.KxRBkZxce.7tEY0gvbPVWbrRd4yjHtjLMMIw-
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: d4c9af00-e82b-4078-85a8-50c6dceb29c0
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.sg3.yahoo.com with HTTP; Wed, 7 Oct 2026 09:33:04 +0000
Received: by hermes--production-sg3-cd7bfcc7f-rntbs (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID c6aa332ecc93d11e3ca3dbd3283b5adc;
          Wed, 07 Oct 2026 09:22:43 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH v2 1/2] libmultipath: dm_flush_map__: do not treat query error as external removal
Date: Wed,  7 Oct 2026 09:22:35 +0000
Message-ID: <20261007092236.165908-2-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007092236.165908-1-suresh.thelkar@yahoo.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
 <20261007092236.165908-1-suresh.thelkar@yahoo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a failed DM_DEVICE_REMOVE, dm_flush_map__() classified anything that
was not DM_IS_MPATH_YES as "removed externally" and returned DM_FLUSH_OK
without resuming the map it had just suspended. dm_is_mpath() also
returns DM_IS_MPATH_ERR (-1) when the status query itself fails, which
happens transiently under a heavy ioctl load (e.g. LUN-number recycling
plus ALUA transitions). A transient error was thus misread as a
successful external removal, and the map was left suspended
indefinitely, wedging later I/O node-wide via sync().

Only DM_IS_MPATH_NO now counts as "removed externally". A query error is
logged and falls through to the resume path instead of being reported as
success.

Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e3870f59..a5570a85 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1042,13 +1042,26 @@ int dm_flush_map__ (const char *mapname, int flags, int retries)
 			}
 			condlog(4, "multipath map %s removed", mapname);
 			return DM_FLUSH_OK;
-		} else if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
-			condlog(4, "multipath map %s removed externally",
-				mapname);
-			return DM_FLUSH_OK; /* raced. someone else removed it */
 		} else {
-			condlog(2, "failed to remove multipath map %s",
-				mapname);
+			int is_mpath = dm_is_mpath(mapname);
+
+			if (is_mpath == DM_IS_MPATH_NO) {
+				condlog(4, "multipath map %s removed externally",
+					mapname);
+				return DM_FLUSH_OK; /* raced. someone else removed it */
+			}
+			/*
+			 * A query error (DM_IS_MPATH_ERR) must not be treated
+			 * as "removed externally": under an ioctl storm the
+			 * status query can transiently fail, and returning
+			 * DM_FLUSH_OK here would leave the map suspended.
+			 */
+			if (is_mpath == DM_IS_MPATH_ERR)
+				condlog(1, "%s: unable to verify map state after failed remove",
+					mapname);
+			else
+				condlog(2, "failed to remove multipath map %s",
+					mapname);
 			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1) {
 				dm_simplecmd_noflush(DM_DEVICE_RESUME,
 						     mapname, udev_flags);
-- 
2.43.0

