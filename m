Received: from sonic307-22.consmr.mail.sg3.yahoo.com (sonic307-22.consmr.mail.sg3.yahoo.com [106.10.241.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B031B130
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 05:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791178215; cv=none; b=nZOoupZa/9qIlaJIKSiWbCFcpy/4PB4OKea6jQ0S+x3QEnJkr/rVvL3ZtU1TSm+ruS+MSg2aMQcdtWspt5qzATx7pPD4sIiPutS6SsdowUVx46gpQ8IipXCkxyd6bd3BpaiXLGdobFuK+/oJr0S48oFJdWzwdZQYSa3TIxCvb/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791178215; c=relaxed/simple;
	bh=B5Xlq/vr1mLNSgwVNaWZmXhoDBpgBh72Ez9RsI3nz84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2J3Ro5XZvDyPF0UtYhJGQSrizWD+9kK6GNLSA35eQSyW/29Dp/b2fmg3p6tURB8AClB8hsj/yt50bNQRiRBYeozhlr5eIyen3WEEukE2NlOo9qQXSEJAeRtyKFWma1rXXPMg4rHhDy84tIhFk5tA/D6lEpndCdvta/R+qx9GLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=TYQ6z+Ky; arc=none smtp.client-ip=106.10.241.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="TYQ6z+Ky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791178210; bh=cv+7A7z7V5jICR3770rwwghNVMdRopuu5qyakvK507M=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=TYQ6z+KyCWwyjUZY34XS8qUbdX+kV53xElcWTX7hikwVd73NF2EUJvaa/KRC4O06N5jnJ+nD6hRq1kaAB7/Bd09fnsZZKWDKFDdo8Etvj8K/2bPqPb2wHIR1ixHuFdiEZBGghpaqGiqjk8UlLTuXG0ZfBcuqzz86rH8ktWaKBVD3vgCM4RahPCr/bla128BvG6YHuyNKmAo9xAaK0nTaAqpv9KhUl06gFVFSq3vvTlUO5S50ARR5RpH5T02MKFMyST7z4GTj6caQEgqqLy5Lk9JiSylmxX2dGaXJrFtuuCRFVmG2fkhXiVKqf8KaV+wohnA/wV00YO8T84TPsbMSKQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791178210; bh=Z1miNN1SPtzYPyMWhFwh6FciWXJtWBAcICA3u0FGkXu=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ACfq0STZZMZjEkb/BFTsDGTZfhbD6ESbyTZKJey9gznLS2nEiL83QI55iI+MUORzT80C6oKeMKVYsdP9S/0H2DsnXW8y1alsnw42nU0ce+8dLpgTbPxxa1aU9oOiU/QZ7g5T3lmvTHIGMuHK8c7vn/xYLQ43oCgxfg08oPd8btq8Q4IVrt4p+Xj9lxtKkHG3eQbUjSrsvF7ptI2sEoVoUSJOvZi7J65zwcNM8CJFbVJ6/5za6IcpFTiA9nvBh6gyJWgCnAX7pZAnQ+vyxFzakJDhe4l1Hl7AXXCZ/7rl1TErgRgWGfVZsiRZitfrcFz1kwrZTd5S+iHn1bxMQ6yD1g==
X-YMail-OSG: FJyboiEVM1mi1YUBC3XIz0kwSgdh7dbV9uR1eatG2JD3qMJBBXv8hRpJmo98.oX
 c.U2DoKnx6S4uyP5xf6Z0BR1TxqPTvLzGbnHAp_uQ.Ppt_P34n3tiqZrB70MhMVLpiRZnWFsiYYV
 EJPMdZSTJ8k7YurtbnAC6krO.c90Fgs8rg0ikjlxowEVSlz6EQz2DOSeW6rYeW1F3I8EkTCZrLsg
 BLLSkl1bEnYKexJ.59QMvmbWrVyjnJSXfxUorNHYaheBoloF.nwgvbkZklLeA1Zzc64ENfBHB3U0
 WYalA8nMKtFsdTSw0RWhzgN3D3jk03nzDSS5_viczDAnm.K0BbI0BRvu6IoxnqfOjKTNQ1vq6ttE
 2xf_aFO_CqR_07alE3rHyaUwK11xwmK3BMM2J1Lt1yxue6SZ7qSji7o7o25z6fS5ONzk9EtU9ZCI
 wtPwm08DMV1jvicIzg6FnF_5.0gThdnYS7vSHBoCABz9eHKWJ8dHU0FTMuORBUHUERBijCqx4W2x
 CBirETgdxFWc13fjhNuuYyXM94iChtvkyX3daddHGbz.4ouCd3fDs0m3YS_FX0.E89Ot8XDfXW7j
 aJO3kibhqmmo1DC9oRq0sL6xx..UJLCOn0tpiHwszdkvVRbSZ_hKI5ZFKWcH8jBJKmLGnteqdFW6
 TroWoG.21m_T5_T6gCKf38BH97lI0BNTLWJLjoSO_k_FS3qkmF6vmR3T7z4_lJKYiRDJ7Un6b_U9
 V.KwEZ_13fF9BHx66CAHT3opUOtcROXboHSnmZRBYZW8zZMBbIzxACVKgJFCc3cDNR6hPeu3GTDk
 MpJw_SZyybFwqD.BFm2_ZOPccnfortMBn6rW8slC6RRFQiwwtt__KAERE0ZkNh_KWQn4P7YTQoOO
 lNnLe4iMNG2ezOPAK8uneeaSTBzV20MXXBewp995g6brQ3Mh8hlEdnyrd3sr4fz3jEVCgp4MhVnT
 MRLfxT_fo6lZ0KTdJAMW647KzfvVykw56qpSboir0Y1yQX6kxE952ZxxEtK68sbX0F5fB9roAawL
 3PIHtkGO26ntqavHWWMfn1trFWg6Ub1_U.dFTpvACzUjkaiHde6TITjuw0SvmRhLJTKCoGzHGZqQ
 2a4RTpkdtFd9lx9zx0MAfXV5HMk0Z54KKvj0JDXn6ARwp9QuIoZcZ7JM7j2Xup58.K_aqJWiF5Xf
 WLC.S5dn4xchV5AZ7JXi5Ha6mViNhk41NgFolDwHr0MDHRpsMa_b_IT4mrswLCxo9sMJdFON8evY
 2_b4_NZUSyzPUFLpo85wnhdjcwFlMVB9ARzogqjzm7wU9JQ4ksei.DWrLkA9q81XstBpxWkvYKvQ
 jWhmz6HpdqdS3I9nZDTaLGjrlS8m0JV45ZpBDpH_LqUoovYXIBfNrwEtWlqh78e4M9MOXzIvjKUe
 d3sJySYPSPhp3aErWEkYD_rO0KFmpSi0qY7J2XOS.gOtLim76K5N6VfXCoPlwaor_KWR8bkw06vu
 v.PAeuQKYrgRgVSsgDiv9CoH6wJBzO2E4NRaO_Yq._GDzmT5Pm2.Cat161Xr4ec_77t0KrKvzMGE
 Cs1UsBqUt.DdpafRTVZ578jCeGcQXt2Fm_dXKNlGTzDX5qKu8LmASoD3L2FLyEDYTdklO5IgJnMh
 Z22nKs8V81KFYJn0P6yuivMJGvtOAwGfWy0NdWyWG6Yer4MYJ0sPDt5LECIO095T6eP7egCP0Aeg
 oPofZDF6kVrfj.LBuPMET.xSYPqTXgShXrBVVi2fu7R1Xc3xyt67xqamXutzOiR0UaxZ9qS.Exyz
 8YmpKvAngLSQtUWIgpXpGPEYdUzgJf2NLj8bkUxSBTCagBsg4tQBH66jm2yDc_AEc2MdoHKoIR77
 6xem7BbpeQxWlNppkuFXdfclTJNibJmHWJblGlzyfy6eQlmHwcfRMPFgEi.r1ByEjCnj7H78Pet9
 3nDMn_l7SDkXi3y4YOWpT3YrZ1lxlU1f9yNJap4B4D8mloRBpZ_mwMFOt4r81J92UX8HALX4X7R6
 v22gcRtd7CbK4k6BmVdgQwaZsn1R3e_dWROz4tfcnPFiToH69Evfd1B7z2Q_8K2zylVHJv.Qp0yh
 4OTn6izoj90SmisJZS_8WunHd4u61_8zhGn4OM.2VP_Mu0IXMFtiEopprXWpBIf7ZNO4CFWI1MPu
 m4Mnu.9gZa8dqfkKvngN_c9QGSGEM7WO2l3TVes79g3CXqhJ9CR.6Q2vTISO7qDcITJYTfBAE0IM
 jmRw4_kXfI2mpIsKbgztzxPe1ww04tKmV.s1TQ47Sv.1nOq8RcSoxm07r4OY-
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: aa745d0b-a769-48a3-8a46-92e49b7bbb88
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.sg3.yahoo.com with HTTP; Mon, 5 Oct 2026 05:30:10 +0000
Received: by hermes--production-sg3-cd7bfcc7f-vr22h (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 77555b61bdbcf6f8d66bc604be106356;
          Mon, 05 Oct 2026 04:58:46 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH 1/2] libmultipath: dm_flush_map__: do not treat query error as external removal
Date: Mon,  5 Oct 2026 04:57:25 +0000
Message-ID: <20261005045726.71858-2-suresh.thelkar@yahoo.com>
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

