Received: from sonic308-21.consmr.mail.sg3.yahoo.com (sonic308-21.consmr.mail.sg3.yahoo.com [106.10.241.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5025E3A48F7
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 04:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791434822; cv=none; b=LKbjjmXWXaRWRhtzRu3wdXWpZ8zHmAAlaxiaQFfditRLS35IJhgVxWNpoJCksblUx0y/v0Bj+Ddi4epNVFof2cB13tgwYwggo2y3xjycREKUadDed39ks6PcXDlQUmDS4MKEdj8wPLq6a0VQUPTsiLEyBPIuECOCfTzX+LaYZwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791434822; c=relaxed/simple;
	bh=931ihF3Pds0B/1rygFY+2Q7jz4AhdARKIhdNeZyd720=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0nCWDphlurvy/qzIyg764UCnAu+ISnfmEgCahNW0Jah4QA0aJKjZ8tO2/1ZesvDJz1Q785+MtX73bW7f6N/vco3q3Kt6HpeM9mRO0X6FbJCoGiPKAongCEil80eIgjxKS5GGSQ3huNMAxW1OPd7sY3b2VFzVWdFGanaKKfk3mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=SH4sDMe8; arc=none smtp.client-ip=106.10.241.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="SH4sDMe8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434818; bh=bJdMikzLQdoQ4F+7XZdVQDaZf4iEW5CQdMWZMTUnigs=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=SH4sDMe8l/tIvOvzVSqZSmeDi8V3gwBLK8DfTovgw7Jw3qdV5stsboaX3NfAO+A/3TYJHZFtdN3GvswSNjeMnMzHNYjiIDHHZtzPQBrCZn1I61ko7UEVI4rLNOss/PtgxRWleZGX3m5a4pq3LAinBYZGvBcOez5VlfpxKwLI2x+nn1FPfOLSg7sv0ejUQRjPYlEuo+SfId1MQ/75dS9O/0vlAvENC6ISM42VdnceUyPyOrHSkNkDdFxgjBF5QZm9Xx9auHH5n1q+SWXJWAFSQ0GEx3OuwiJPPhVfMmPQcWJaEhle8aOxkyTdw4dQSSOqlwFAbARSysnQUHVN1dc1ZA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434818; bh=LmetwcU8+EEGF4kRXAH33Gc+ylEEyIBjnZOFnKBrvSg=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=SafCeRVhomdiIXkJAIkPFp5gOmHtFPSRz+sGC/QclhSReWlRnSyGAjXDInlnteTEeeRfef1y4bwE/6RhRdrOGe8LyfdGXshisVYThWmvWTHGV2UpWliHzvT+cswgKCEx3t3iIoj/0pUjyf0fLlWG7UzFJ10hwUajggzhGZm4HikvFJWVVnfy3YReVLfQLEqNOqHY6oCJQQUyORh72qMczcHOwTpg47ILie9V/Y46aE/PftIKKnlhd7/iHlmVnuLnXkjQTzBaLAo1nE0s+t/bVTkGlAcUh2Nslr7yLyaiWSDd/reOSOIn31TbuFWNDvNCjDwmxmSS6vqZWdEb+AyOCA==
X-YMail-OSG: IZ6n_eQVM1lTC.wq3fq9xenvvogWKj6vyc_QQ.6qnY1rmA0XCTJob9t4iokLagn
 gjD01KSUoSe.eWs6DIcZwvkIIRXMkxX8lyjns5jxE0KGKrxuUCD6RSoSOJI9eV4CdITS7NAcq7xK
 d0WsyC7Ci0DPCsqCAFQBFdLnnza5cy.K5C8aPx.cJDg8gy8QLUj33qSKaGxxlok1T8c0iy3C1SLQ
 FsjjHDAi.wkTJW458YOslqQCU7xQ5R56MaNgv4buhV0ufmeKqJ2KZgK_NCsRV9yxi1djlK.3vFLN
 F49Iggtb2oit79UCB3z9rwEQT.88xyBM.TMVq8O0Gah0uQVl0IZVt5efL4fx4zq8uzqcMiZenqUa
 InVLcVGTu_HQ6._zy3DpPNcsTZtChZPTWLC4Vm.4xpo_OCjOblHPHjCyIAYbC83WYO022jHHsFRm
 TR3R7IP44ek38IoHOFw74seWUGqQs7aMfjLc1pU.pT49CICXCfI1pqtdIlQoTIfC42k4KehrAlu7
 5OzUFUt11XZIz.u3kCQeQZCNhmH6m9dkJ42dNmsCKAaMwapUPfzh3XsZLrQLegdzlAdyn6Vuq.UJ
 MGyu0xAPpUK1SQGHyy4q0Mj5lkZIzhucvHHyazjcPYJF4kOCmy4kjqQ21CCxyuyMIltOFP7ceVcR
 CVIbXWv2_A5ut0DxPEjhwcbZAMJO4wdorgmBk4xWvvVoi3KyoM_HsTu_D3cq9yDImykJWBjOVBRu
 5vRlWW0hN916ksuenjR5Wpx6JJbMK6EDHDu60Xzb0kA1.CZHlcKPyMaVr8RH_CUVOH0c2kuV20be
 OziR0rkys.e1xgrDVSoGcB56wrTPhsdogLanaQrraRYFbqDLAhKa3ZnlZBai_JXoy_GZsJFPVscI
 f87af9i9tYoPa7uMZ4WYUPBDC4qVCcz6acx.HVGDURGpne.lyFJmzDI2KIj9jeF7AJ9sIv5N0FEH
 OAAFTAJOTlKAPLCceQmaKkl72Ax2.2AAbnd79l15PA9DKcQ301f3BbO36NmcEz8Asoa6WzafuIBz
 QMdC.XdjfWUPA9CUJtke9qiqJTWVky_dGajFbRZcYD6VCeJmB3ofH3P0wvvTNoCa7aKO5LU1pov.
 ys8EZY4QZB.j7Y4kv6PX9crxw7L1a4CaiRLbw7WQPkiwBNdEKP0Lau0mETBtdKKc.h73urFrTEBA
 CEyQJeb7eDMu9EnZ7FYV52Tb62Pze2JbGPj7EhAT9NuyFO1JfTMwbyVXeUcYDUw8ckMqYAw9pRRd
 mSuillvAlzRbIU4RmK1Me8d25ZIaH.X0rFL7KtmAZ1VHzORFF9YYYxTqIoXzDJrvTMseUDMEzjnM
 a1E4.Ly1qoYP19P0uK4liYiAih4_aE858NObPYNKy1eRvhv1cQ.6AUvCJQiGE2BE8UpdlzrLi_UR
 8b3JpeDRqn7_PSMPMj3bUMuCLPkfUiKs0yVMfDZHNW_Wbuh2lXsSr7dcX3mUqaSONW5EWzqEmMlH
 RpjnwnITVbggddlQMQ1G0rtLNLvMDaSjS3AIzZiMgaPdpWEYjKe.udxJxeN5JgvLkfwEVXxkpR_y
 fNr01aEndp5HphRt9CAbXzyA_PbtG0XXVAvahmO0HI3L_FWoLyU73IoZGOGSjcK0W9gML3COES4j
 mX0sMZ.B3BTEcCoXinakDEQSuNyhukDqn_FXfO1qb_Hs7x0cwFi0odIwAPM4Yf7eJ8kDLT_QSiwW
 nOr29KMSzmCEudeS5F.dj1eif4eFj0qJ2zrODsHcK14P7GNXJyoZOootyd9BoIL8TSWvlycmG0XE
 DRL1LMD.VhfG9Jy9s7Hc_uBSQi5AEU2Gr4V.b2hRyKAIMbAgGjUnAkI.n6iOQVKN3lkMWFeBeJ9b
 xeafzmWYPmwwMWbD0nerD5vn31Ml98HBYTLRB6jmJ7ng_JkRXauTsnvWsHbCp004eDd2HgJ..L8T
 OSUNy7fMSl8mP.MWpTK2gC.6pHj4pA6wBON2q0BpoVi0bJO_d4vHFwx2Wqql0LLW2oFtWEHXpnLS
 8GBFJM_afelMUChXApWymKF443kJNbFDEmYt7UJ_XvdsZpd758a5DCvnvIg2Dwl7R_kCLCYmtddR
 kmqaaQQwGCWABXfHgV9uXGn4M7Jn9zuHKp9SqZNHRWrMRbxhzr_ZX6HBREDw9xCwRuVYpEjDwjiF
 k2hyVoEp5edv9yKb384HXVvCN4Li1cyxCiyKge9VgrhlRGxJ78NtQsABO.7mt0hZHpCOs09TFCdZ
 9imKVkokSNiQPk24kXRxQ8IB6h_HPm4padE.TmFMu2qkQuaIpYxyrTHGEMgsftGgtxqKMFIUA
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: 4c2b2652-64a3-4cc9-b5ad-54432a4c2ac2
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.sg3.yahoo.com with HTTP; Thu, 8 Oct 2026 04:46:58 +0000
Received: by hermes--production-sg3-cd7bfcc7f-grfsv (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 97dacdb1586a69489947f11889b650a9;
          Thu, 08 Oct 2026 04:36:36 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: Re: [PATCH v2 2/2] libmultipath: dm_flush_map__: log if the resume fails after a failed remove
Date: Thu,  8 Oct 2026 04:36:02 +0000
Message-ID: <20261008043602.21390-1-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <136782c48a0b514ad107b3b2aef18d437e2ce9de.camel@suse.com>
References: <20261007092236.165908-3-suresh.thelkar@yahoo.com> <asZ2WTKM-SeIbsE6@redhat.com> <136782c48a0b514ad107b3b2aef18d437e2ce9de.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2026-10-07 at 21:21 +0200, Martin Wilck wrote:
> > [Ben wrote:] The issue that the second resume is solving is the same
> > one that lead us to add a second resume to dm_addmap_reload(). If the
> > device has an invalid inactive table, and you do a resume, dm will
> > attempt to swap the table, fail, and leave the device suspended with
> > the invalid table removed. Immediately issuing a second resume will
> > cause dm to actually resume with the old table.
>
> Right, thanks for explaining it. [...] it actually makes sense to
> retry the resume. [...] I'd appreciate a short comment explaining the
> problem scenario that the retry attempts to avoid (i.e. a short
> version of Ben's explanation here).

Thanks both, that explains it well. I'll restore the retry in v3 (it is
what v1 did) and add a short comment describing the scenario:

	/*
	 * Resume the map suspended above. If it has an inactive table,
	 * the resume makes dm try to swap to it; if that swap fails dm
	 * leaves the map suspended with the invalid table dropped, and a
	 * second resume reactivates it with the old table (as
	 * dm_addmap_reload() does). Retry the resume once, and log if it
	 * is still not resumed so a leaked suspend is visible.
	 */

On Ben's consistency point (always retry vs only after loading a new
table): the flush/remove path never loads an inactive table, so in
practice there should be none to swap here. But the retry is cheap and
harmless and mirrors dm_addmap_reload(), so v3 simply retries on this
path too. I kept the condlog(1) from v2 so a map still suspended after
the retry remains visible in the logs.

Re Martin's valid-inactive-table footnote: agreed -- if a valid inactive
table somehow existed, the second resume would swap to it rather than
remove, which would be wrong. But dm_flush_map__() loads no inactive
table, so that state should not arise on this path; it would be a
pre-existing anomaly outside this fix, so I've left it out of scope here.

Sending v3 now with the above.

Thanks,
Suresh
