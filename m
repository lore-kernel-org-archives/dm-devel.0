Received: from sonic314-21.consmr.mail.sg3.yahoo.com (sonic314-21.consmr.mail.sg3.yahoo.com [106.10.240.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5B34BA42
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 07:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.240.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791357394; cv=none; b=fvVWqfqBr0aWRRb/IuQjQhi9kyiV692lYHk5iFJCOPREpP3vJtQiHGUSpmCpdObvlA00xlEzSOtBA0FAlUviXvop1QDqtyEMptvCeU0TcvxYbVEf8oX6Mqsez2iGOGLUYdYgzWl0NJhD0NHRX+DVKqNAsksyBp3KJc0jo1n2SNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791357394; c=relaxed/simple;
	bh=hEHStFnj39pZcfCK/Cuew9gIGaN9qWbEZ5CjLJzGev8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ydl6k9R5/6mGAXAo1Dpr2Uf+1sV/6tIE4+q4aBG6Q3AYUV6rRhpbJjMhXcmWS2G7X/9yxocqRMd7lg0kT79pla83l1PSTj8iYVEyAkvHg2Q7HwmdRn5jTJASzWwUG/qt3QLcqLtBppEXw1M+J/EgBkor2LWq+Msa0bqJA64BUHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=VnsgyNBH; arc=none smtp.client-ip=106.10.240.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="VnsgyNBH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791357385; bh=hEHStFnj39pZcfCK/Cuew9gIGaN9qWbEZ5CjLJzGev8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=VnsgyNBHxtbU+mPb//JLz7EjtFkEa7aTi1Ax3QmzjRwO9+Rff7CC0basj/sIqPUVOtaIT9nSIpmf1x3EA6MS2Cuj1j7nQKjBhg7sizPGR4s3fm0D2q5hGTLqA1X0OTZKbabdlWvCoDvMdNG+1B4F6yAvUK1n6IGlpwA5hwPc8TCqU/1ws/xs8BFq1qoVjFW/czvaGRF2pkrfEmH73f38ZVEHrplYggNnlNA3nS7lyMeTmBPlw5xhuG7FbCJANITssrA/sXDfUyvmpnD/Jr/+4/LK7e/vYLzPo1Cr83ebYxUTjwfcWbl+IW00LkiAS8PWH7K1bW92j4XhHK81No7CeQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791357385; bh=930YVziRhyS7EYtqAzHUjECXM6Wp7hrbHuj2SO9lXea=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=HGF3STKuhaz5RHOYktKmn4YkH5CgB4ltNV2k24pbfZwydDUyKLF/DmGZ8cCQyhnpMxYB7nVXYbfFdPUkxYF0SNb6+bdyAaPbsAdVFGhZEcqahO3y5tdIWazA7Z7dQWSmGv2+8SNET0buM67niFzIJm9rbpCQcoJCjpjgS3UqCpEjCZCakQwFavOkAOtSdrquvETjAMcUakvjI3FXM+9VhZRKvXllAhJE/nMLIdknY1GOcEmIW6KfQEC4/uQgGWLMplPBovK9LoN6GvG/9HOWUjaDzZjhzTmbHzav8cyNP0hVd+dqOVQ5Ttg94jjZWG+6pabXBxoUJFp/tVXwrHBMGQ==
X-YMail-OSG: yVesg3wVM1k0SP_wuHXqnWkx0ojagKnUlzfa2e_7p9srZ3SHP2onKnP1EGxam00
 .tpOgHOpBr73cSuHRxzAPHN60FyKkGnLjPTq.NuRkUQjWcqLnBiAMDJGqh4KPKqNVvs.86dAvT7Y
 NUlpH57ccy48hUKxnYG4cc.B7UKB.nirwWOAVPty2PalY7I9Ro8znwZratSlG17oEHTbVNUC5qQa
 DHYHXDFJPVlUNMJx0aiJebELXDG7B8uaXETgS4txcSx4IGb0n5OQMPNwBIDUIZuU2fQ9bkR.DjcU
 W.dIZKh2n9MXrno33eu10bPh5Vbnp0UUk.O0oTcqXYIMSsYC03k45FgpmLvPD6hC.6NOQStlxjRU
 EF9_CyQ6ZG4uMUAPMG0eJjdq5oNtY.2LJy0HxmlQ4uMve5Mk6DQXGN3hJFZSxzakW.3JkfJxL3Ei
 mHI0o8o3SYN590A55q8aJasRirnpzUzDSV.SZZQOmjq9HFeeAPctEYOXQC_unduN5kaFuLyKOF9M
 hamfdFd2.dbBVe32FEeE5JhZ.kynnsFDuvZ5Ltf6q0_MEQ8jfOaYE8llc3jPkn0hDZzQMcWy95Kv
 Br1MjtVHmLCt53xs_ZHleEN5FJTAPE23R7bWmxsGH2LVpNrWh5b_9tsa63FQ8uymxodjkQfUuJlZ
 JNrgg543FtTGJbT0U8MQCGnXSjByZhUrPcAC5yzxkgVBV7bWIyZ5oOUpiZGYwp38jAnQ9a_42HYp
 vDhf6BKme58yex09J1FNkI.7LIbDByfbczwyXx.daDRcacWg2R7bGSw0BicIUMBGfhUOenKla2Jn
 EaFcgkIl9s8GaizIcPx4bWeaYoLucXLNF5Ui04eQ1hfZikNDbINhuDzWXkL0kOQgY6hXwN5Vi623
 Vj38t_HD_3A0pGS8XKAbL_z0_4lK0332cH6_W8aTjkuE3z7BCLCYU0IJNijVFVn9BF2nSB9piflr
 SgFV0RKiuJXZnmu20FdLijy5iEV_7TtFnExyaaRNmsnLqI9C4MgwzlQ3TmkSKgZEDf6qmxeI8nWj
 XakKp0rnlrutBSXKgFpU6VyHZS_Qlb7fcQcP7wW.OAo4hSZkq.4adgez7UEQnstsq_Nc35wUAsoJ
 7W6TkHkkcEVMk2kkikvP54fOkDB_TYfIYcoDc620pxlfA2t2EGH5BdvdzBKD5PAu_uUZkGUwiN8f
 aGfmDUYme0njtmFwQwJTjiQJXYj0wkGzOSc.kELwBwedlBckBqai84Ht3eWHQXcWAgLXXi1OPBle
 mGsTPdYUFjmLezy2nqP0SGL7Z66ukPq1XNt3laempDmQlABzgRUzgmu5zmRjpl_fMJVCEx95fc.0
 ollFRrnii0n0LH1Pe76lOPQXHWT8Sbqqb5iR90D_1qCKWEnI.gEVro4lAowvGISCxYovYUbkPMZV
 b37J7UK2_ej4KdbgeghypEpa6BvuLAowZeY17sOhkoprTnNamSQw2yK0CufNdRGwzJsGPeeouh1M
 t35YWoTc4BR3OUi9o..cBV7KYcg2YbNUjLsO.ki3LhgF8iLcHU84Kpxt6WQHWjie6FaMTRqvPAQZ
 sz5ipI3b1mxQfnRauAojHME68n.m4v7THbjolH879AZ7FGN6BbyqjeyjLbIn02FLC_jNis4kKl74
 Kqen4SzRE2LYuREwD.ds1.FMo_JkDCajlubMOLrtXsBTFIjf4BYsqJaic5hC1Trzoke1cnqMBlog
 qoI3DEFajglZG.dXKYw_dEOu9I8nSKFed6KPPfWiBcCAlAs2hAEcj_fU83pexBmx853em5UU.i9a
 Yd5gXxNVE6UZh4LedSP_.DpD5ZxG_gpxWaWehULBjrz2fm.hKX.lAoutb8WVZB5KVCq19SAg763R
 cxUdQuJeco8T_LSFVsRkEZl03UfqeQrzQaE9r4iXlp2XRTg7NM66Vam6Nd4hWVerTFum184XT74o
 llYQ.IQSeq6hidIxpXsu7YSPo6EzMgAH29X13iOjeftn1hFJYPTOzWmrjMb7dzJZU.UYT9Ou_uc7
 vLxUIzEsxSAoMkBlm3qX.4yE16tqfCvgW806yRNYG4CDDLy2rCUKeAU0XcewoH4d1SJuE2csjhk9
 60mgmVi3fDhGcGyEMe3hQILe5SrvrQm_wZOBYg..rtv_M4jQWmeq.hQ2XzULCOJUutmuYJyMiS5K
 .7g7xZ94asTNPV5paxGjhYES_axQu2Jks4qvn_QY_FqbIjm06MNx3hY3.ZP_gr0wabsIJYnbhyB7
 lKmfqXFOU9Ib.DyL0QcWjpzpc6._JbjlE9H3Nvd5Vo2i5XV48vT.xic6cbdmHSvhr
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: a38e03fd-03e6-41aa-9e3a-753704c98989
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.sg3.yahoo.com with HTTP; Wed, 7 Oct 2026 07:16:25 +0000
Received: by hermes--production-sg3-cd7bfcc7f-84vh8 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID c61d76c2d167264dcdc77a2d4fc6a426;
          Wed, 07 Oct 2026 07:16:23 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: Re: [PATCH 2/2] libmultipath: dm_flush_map__: retry the resume after a failed remove
Date: Wed,  7 Oct 2026 07:16:01 +0000
Message-ID: <20261007071602.97962-1-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ea3d358c00cad3559658023d6bc98937c265218b.camel@suse.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com> <20261005045726.71858-3-suresh.thelkar@yahoo.com> <ea3d358c00cad3559658023d6bc98937c265218b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2026-10-06 at 23:07 +0200, Martin Wilck wrote:
> Have you tested this, and have you observed cases where it actually
> helped to resume a device after the first DM_DEVICE_RESUME had failed?
>
> Would it increase the chances to resume the device if we wait a few
> fractions of a second before retrying?

Thanks Martin, you're right to push on this.

Our fault injector was written to reproduce the exact sequence we
observed in the field: DM_DEVICE_REMOVE returned -EBUSY, and the
following status query then failed. So the injector deliberately forces
just those two -- DM_DEV_REMOVE -> EBUSY and the next DM_TABLE_STATUS ->
error -- which is what drives dm_is_mpath() to return -1. It does not
force DM_DEVICE_RESUME to fail, so the retry branch added in 2/2 was
never actually exercised.

As a result I can't claim to have observed the second resume help. The
extra retry was purely defensive, in case the resume ioctl itself
failed, and I agree an immediate identical retry with no delay wouldn't
add much. On this no-table-swap resume the realistic failures (-EINVAL
"not suspended", -ENXIO "gone") already mean the map isn't left
suspended, so neither a retry nor a short delay buys much.

So I'll drop 2/2. Patch 1/2 is the real fix for the problem we hit in
our environment. If it's useful, I can add a condlog(1, ...) warning
when the resume ioctl fails, so a leaked suspend is at least visible in
the logs -- would that address your concern?

If you agree, should I resend patch 1/2 on its own as a v2 (with 2/2
dropped)? Please confirm.

Regards,
Suresh
