Received: from sonic306-19.consmr.mail.sg3.yahoo.com (sonic306-19.consmr.mail.sg3.yahoo.com [106.10.241.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F02F3DEFFC
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791366092; cv=none; b=d9SAml4LHqNBu5Jk4vR8YqaMdewID2ZXIw1SmzAxfGbuoP7Egwfa5oOezq2+wU6nnvUqDMFIZ1KGlKDnqEfcqpUczu5ajK7Mx7Sq/HfnonXIlrowFDsy0CDH5PIf6tEiUP16beOvd7szgMmlfM2+oMRxH5eAvHnqByhzKfQG+7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791366092; c=relaxed/simple;
	bh=J9lPiyBmumR18Wx3U76GLLxRTXqmLfsqlTeOKy+5c6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emJnhkjqys8ZeGmQZy3xy+D3F39q0EhwNGBnovGpadU5mchRT7wvmuNTDo9W2546vc+LQYkRQcFQDhteqeKjNgwzTPJdIPyuPZesPjhuGn+Ef89uOeop2oirNo+QtGeDmAPL9T56meE/z2XdJa870O4jek7nw2HW1WitVBI/k9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=NYISNcPY; arc=none smtp.client-ip=106.10.241.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="NYISNcPY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791366081; bh=J9lPiyBmumR18Wx3U76GLLxRTXqmLfsqlTeOKy+5c6Q=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=NYISNcPYIlJQiWvkTm+VRQEXS4yFc52nZrxBq8f/lE6+oE+x30G865sW/YS0mudFgPqshcRKuEgbA6n2k/WYkal7OkK5nQKNEOmUsoYAiCloGXL9a47XFa+wSsTp0JX7Z7oRIXkuC/t71Utek4fyF6rBKwEg1jQLLLU/++igGwAN1C6O24wSo4bW7jZoQa1nmtulCIdmKtLtSqv5KwPDMkC27SyQrgcW81UR/qYDJkb3y18msJhRTApsVWFlC9r2csk4V/6oXuPNL8EPA8nLsEz7he40ANxQcr+DBAWDGENPITcTjLITKWW4PtKa2m1SNSZWs+ii2vgyn7LatTsLIg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791366081; bh=/MBRt8TPx61pAHju4y7olbjv8rKogHxDIX92mGy4Kou=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=LDe1XIh5+gF3qBl6xkZTP/Dm+lnaLCIq7y/cWqfxvIViKxYDMlby0nIsdcqkcCMKPwxdj0hxqZCBcoj3s6MQ727ntIamZI1lY3/4foaxritBZvRnD1gmHPMXg2ce/+UnMfQm0oEyywSiZXTY/bXgF714lIxRa0DUm90aVZynOkCvw7UF3q7fkDRV35hOlnqjlyKwdrWh5LHImltF4oKd44sWw1bUxFSCvWtCL61rHwi32rJG9W4IQRuSRLRE9KRPUvd1yk/fZX+o6Ke5BUdB3LC1G0NQqih9G0JbqIy/XqDbaVLtJx0oYMwkfWBL21FCKUWjWd2B8nv/e3L4MUnxWA==
X-YMail-OSG: hpnuf2sVM1n03RuaeDK6i_2d13fYmTxjNd3a15LxPiCuo8HAh23IYGk22PSjNVN
 uoKcANEIPN4yZCQNqXEVV8Mwj4YwlwEM1MbymdTdLyD_nbBiCru57yJ.vQ_BYM_s._FHk3qBYyVD
 rPiebinEGLETdE4Pm8.9eTSk0J25k5aiTnI.xMgwMG40vFhh77fdnpWAZiSAX8bcFuFYq2e0rx1s
 1Md1EVp.3Mx1JLxZTzgLGpgou5eDG97tfxIfFr_3hbyua8PxTT8KrU8bs7xgH3Fpa.oTdaiW.pmi
 mjI8EhZ1zJ8qQLm2W3ACR_zjYI63enwASeqXyjzs3_rDIiUrOUbVa5g8wdqn4nptmyWCFLOmwInI
 MFBLOLf90N_FmLeq35W7jXAAYC9GSbpve7znJfbcHpIXLVZlPpa_p8g54rBT0EEIPrXtaJhAYD9p
 ls.Hkayl3KIo1QVQgShZQ8uf1HL7N6BNj53VwQQj0kMRtZ2EQRjVA2iqrxhqvtx9cU6h8CLhYDXv
 QPiQSWwXs5gejpEcg7oyOzl0kEYsI2eTnk3zoNbjkouN9r1icB0XTHEX8reXn6nvBlStsgIuouOt
 FSqHfBMDsnllVocrGONUuSBk_QVSbeWffY00AApuGxhwkx9vMFXPJVJJa.XeafHEH4vUoAObC8YT
 cYNBe_Vmgno7eVjDahFGbtjgmM5fDJKzloykPn5zlUlLRz05iMXTkvxb.D4EwBpujCi9t0rvqvHF
 I_lKCpfdKpYAEr2JTlLJIko8ZCGswVY_2SrsS3qJksI3V_nk7AgJbneMOnRkuc262lM9FyWfv4Vo
 XR8t9kpWGlyzJt0MtBUPAJb7Osah0ap8d6F_7o11pBdrs.U2AEvbrLn1UGMHSCzUbfnUsaFA5Yhs
 K5ysaUHlbglBAi2cLT2zNzrQN21zZaPwKa9u3HScJ7mcQqN2W1lnaPWY7gxABaqQzfYTOQqQ7S1f
 unl0j_.zcofASa7AduqhFH.PBsMp.xDp98kgkzWPYscjfwwr4AoxorERi9T0VMNtQCtnbpYZevpl
 Oco8kld8SgRngPEbUMCJAxmzNfWMJgefDpFkM8.8eG9qZwkeAVtQrHKl0_SX8C0F1VdMkHCNv23v
 2XG76E1rJ5YpKl7.9_ybOugvHX_4B1QbPx23wZHd_F9995kA1YUDVX_Awn0BpjXmMTawbZgE8sIM
 QnDvUyvOkDJ8KazASYb1Zvy0piUQe7cz5VIMg9fJP0hM8lImW0cIZFxzZvV1WWg4oqD7fms7SN.X
 h_INxTrjbEwIHg.Ci0XXnDhUshklfy9QiCpQV5n6TkJWWw0RETPzcKJjRjsFYOynaEaqOuSQ_nwg
 1Nn15tjLyvQQiKlF_bDSjOtP9TDTHtYWa0pivPBiCP2IBcLgoSoouTBnqx5FqDWtlyXYElFsq9eQ
 KAD._fIU66jYidfWdgtdjHqZvS297fFlVL3Sg8A4_hrNKytC07e_fFpJXWKe1.TaiUDUBGN3MbJ8
 hwKW6H0Khl8okq5VN.rquBJhosHUe.ETKwXcWvi0Mo1zNm0h2N1beX0iuUbAEgdP0cAEjaJi7P.s
 QU0bw9RkCTkq.NcwzGeqEqIJRtYAVWJfckbhSxoXMbahqfT_HCDgQ4itceuOG1scUM6ghgHEWnJo
 PG1Jx1S5rF99N9e70gF.sa.sQZ96ExcbYfPxdYrByq4ab5RO_rxErJY9KVynFmXf4r1WZaDPbxac
 fyRUsoeLz1RAipLobVOYK2IpXvvjNjtWZUwlrczLfTvurzHShGTTn6eYKKBrXZIHGzpzZT.FymbG
 q7DivFpkSSkPw3r10TOMEkh5cuNs.Lqs_QO2BG9fKKh7tcD5pPDEArPiwB_6L1g4jTC4SDRhlwic
 .671VsetcRrRM1As7asG5SD6qwgHy.Z3hpOpowPDc8iCkDia_9KPFTf2Qq_5JQEmoAXVYHHCJN7L
 uz_exdwDg3Ubigz_QEJRbNV8qJ2v5ZYrvFqgvvBICYpNJAQcpUKjBOgMNTrI49zScc37G.7_7Om.
 6DS_rmA.tLhqcUWVsXK.nGTHWgvkGQAK5KSlmKZcybPbgBGT.tzPJP_sG7Wk7XO1yk5Dh_cGm9l6
 UHfIIub4R66UUOmclUsf8ealYC9bhyQ3cgmKnT0ICBE0lWvVwojOZcSWB63lY8V8321o_Pqq2k3o
 oNA2KWP4SWn0zykIYs.BDUwrGa_mvm3Aplo5Sn117AkzR4ccIDVJ8c65JHjxm0FUpPRjpH1Tlrh.
 3A8WqrdgX4JjPiGmInKbKh3aKOPTTVLISxJjrMoVGakXQ2LvmP5xWU1wgv06BoPyd5g--
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: 0add3c01-834c-417f-8878-68b17cbaea63
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.sg3.yahoo.com with HTTP; Wed, 7 Oct 2026 09:41:21 +0000
Received: by hermes--production-sg3-cd7bfcc7f-msncq (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7e32baa5b17075585022e5973c0ec528;
          Wed, 07 Oct 2026 09:09:55 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: Re: [PATCH 2/2] libmultipath: dm_flush_map__: retry the resume after a failed remove
Date: Wed,  7 Oct 2026 09:09:33 +0000
Message-ID: <20261007090933.154981-1-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <445963a857738a314bbc580c614e54b05a56786b.camel@suse.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com> <20261005045726.71858-3-suresh.thelkar@yahoo.com> <ea3d358c00cad3559658023d6bc98937c265218b.camel@suse.com> <20261007071602.97962-1-suresh.thelkar@yahoo.com> <445963a857738a314bbc580c614e54b05a56786b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2026-10-07 at 09:22 +0200, Martin Wilck wrote:
> Have you ever found out what the exact reason for the DM_TABLE_STATUS
> failure was? What was the return code of the kernel / device-mapper?
> Can we perhaps make dm_is_mpath() smarter?

Honestly, no -- we never captured the exact errno of the failing
DM_TABLE_STATUS ioctl in the field. The diagnosis came from the vmcore
and journal, which showed the leaked-suspend symptom together with the
LUN-recycling + ALUA storm, but not the return code of the status ioctl
itself. Our fault injector used EIO as a representative transient
failure rather than a measured one, so I can't give you the kernel's
actual value from the incident.

On making dm_is_mpath() smarter: on current master it already
distinguishes the cases via libmp_mapinfo__(). An ENXIO from the ioctl
(and a !dmi.exists result) maps to DMP_NOT_FOUND -> DM_IS_MPATH_NO
("genuinely gone"), and a target-type mismatch to DMP_NO_MATCH ->
DM_IS_MPATH_NO. Only a non-ENXIO ioctl failure becomes DMP_ERR ->
DM_IS_MPATH_ERR. So the "device is gone" case is already handled; what
reaches DM_IS_MPATH_ERR is a genuinely ambiguous failure where we can't
tell whether the map is still present and suspended. Without the real
errno I'd rather not reclassify any of those as "removed" -- that is
exactly the misclassification patch 1 removes. If we later capture a
specific, reliably-benign errno there, we can special-case it then.

I'll send v2 shortly (patch 1 unchanged + a condlog(1) on resume
failure).

Thanks,
Suresh
