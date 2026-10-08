Received: from sonic308-21.consmr.mail.sg3.yahoo.com (sonic308-21.consmr.mail.sg3.yahoo.com [106.10.241.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30C337CD52
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 04:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791434290; cv=none; b=GlUb0U1Ym8mnecQd7YLRnRW6gGFKkSvIABf3GYZMvwDwMDtAGUUX4YFcOxPikL4q4xM1CrjdWv897cZgI18GoPAbW6uRgD11e9Zy44EoLvFo1F+rMzSb2KCyHNkduC9VH77XxU+DESTrv+PQM2d4U6Vs+MvFNOYI1Dy2oxBGcJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791434290; c=relaxed/simple;
	bh=SqBDR2h011+96Wkyrefi29VbcAWcMEi/UybMPn06Q5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIx96fOa+2lg04uyIC3DFAJxsY4peQM9RwVu7JQRaznT7ns512ipCUTdryCxkmaTS5rwzwonwuTa1G5683KZ1aB//HSz+HZ5YU31vc7bvTlyMWjFFub85dkNC5coU51RgQtU1CA3WKxBOMUFEIxYIbAg0btBM+NXYH6eumbm5bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ZeCWmAhj; arc=none smtp.client-ip=106.10.241.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ZeCWmAhj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434280; bh=ZbTpvZEWEQZ9ymgZHVD0ZmWAX1UO3ZgnIAm6W7qRErM=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=ZeCWmAhj6CMPfjiCfU4P3o+NrQpxbWsrbtzsPqpry2teD5vKME2Tl3EaNgQJFahOI7cNm4As6Omiqc5p6U72H0U63y86DDiy5og4FAtUXbUQadLwCHHZLNQYV5Vk9R0+yq/+BQLl4dUHT5Pfq83RPGTP9Nz7jSgIjKO2S+Lq+o2c0VPpi9Vg77ovCmbt00jkGUsuLpeouy/ouVQJm5Xs7e7eH14STDOSfGjPtU7/FKEoq9pqDJzYbV6itafsO5fvcI19RQaJ5YNuGUgCgY1s9wYYpxLrbd2uacLexLvaNCJ1XO3fofZCsLerEHbilgUR0pcm/8vlzUqBv58/RRs8Hg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434280; bh=rJxO5+LMc06ODx0J4lW0nCAdK7dc4f9HxtBfaTwxIk7=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=d59jLSjSAstdSqEwbNwKiqlTIwbe0vkfyr4HRv2KnODyhKUm9OpUayq2FUwMaoVhoe32p4CBMPT1xTEfXOSgGDIwT1DDDQxkzzuuV8El2anCtNlviyzKdJ9LlRhMEd6besl+9y5pSP4XE19v33f0MpFnhEhVNrwcFZwweMBE/EpDfAEGWzgw3xaR7dCTnv9LbMAcS786sLO2x4lk6PRcGB178ypSFam/FycEnKEoxhlbZky3FUcLrBYUz2QNw7ZSNEV5NDfs4v6KIuFuVIq8shYXodA6EOK/zrz1uunvoXih7m5Q0fpy21x41axDLIESVohRGL2hNu3u5MC/ib9liQ==
X-YMail-OSG: 0lFTlxEVM1lLHAY.LPQDLMd8kgw4_fQaBVwZNKndVxa1Wwb1j6UbWbejuI4lm.e
 gIgdLDaMCJqYynjBq23Oh_spZF4NSa8HQIbxL1B0Gj6FAp_.V8NhI9m4Yj4WY3ZgKAeyS8_s5ycl
 as3ddrEJi9XTU3qO0j6_oGsgXDolY8i_44crWDD58UWeJE4WAEu94.0fwN7iM5gBQdS5op5XBsAj
 yrvkNdYuB9jNVxWg4QhUrQ_6dDSLXSIUWTIW2rIBMVRo9gRyF6lWZkA5dH44n6mDVQZw6ySOLlxI
 1dK_1t1fMjK9OjzXK8jKr4koXXv1EEXLuIXe6OKrDT5sFEdSTXfU.o4THYFoI2SQ.MyZ0PivFBUL
 1KFmiXIuCGRZAbdMrsbRTBUEI7oP5HhwP2faPz_HM8cmjntPzkiXCtgaiWnyDmjTqvrJoS_Nk945
 4KyMyWwDlwL2l1.pkWdKdKyk8uZYHBd0elKPsRZlG7tQknqZ2GTFrt3gcKEkjT1qm..mymMHMnfi
 oevJ2QOmXplPX4S.LaxV038Z0vALEIjWnoA5O8j9rYIqluBMVohKz10gQa.vIV0kW1MLIZWNxjGl
 jDVucUIommcTHsRz.HOqebLlxxXDZZNbWBgvYC64uOULBZ.JPrQz4YsP86BGqupbHGyiXig4WwJh
 juzKDVHbgfFj_iQF82mvrqK8JpDECH_MZ7mZ.z.wtOE7RL9Q8rd.g.Qpxoa1cjMWvbkZu36L3.46
 ZCrTqjzwL1m1llVKwQ0JzT0VvCJ8eadTXmuM1vOeQBn8gUdTJ6esWmZk.Y0tvUoGm4XXLrALMUW9
 s67e6nxCRJ3KI0XvDaG6uUxyQmwl8lc53IqQmR7h7FUpHvXsmt6_Of_Ukf1MSas_vgm5yuM8afXO
 I5pHmUPnRHSkTkbr_nx24vW.PTtCzQJB3lsRtql6w6vnYHa14JpoTBpe4vdIw5llEO4aGVSlnfYh
 9oKp5_dJcpqTnDwTzirvNPBX_qIdCaNJfEU0zL0Q.Et6Q1v9drklGnSkzOHiJREBnjMC_ZX8CJfC
 lXfpcBjHaRLBMbSmACZL0qF5aElE5loiFfxTXcsR5j8iZIiW2w9xGFmIiuafhkHToLykjssnANyc
 VkjqWntVyt2niVVwFkalhAdPFHX33wY5fcMrcUmBcvE3t53f8CdQQZtJam80YLXkHcW8p4XAc6Li
 FZddA1G0RSlFlLQByC3c3qv80EEMjxPksrcNcb2K799_edOpiFl50bn0deGbApMAnqM9s5LDKn.8
 Gx7Oo.d.LGsm1mZ_.av0eRhkMlWaWmCoefGN.oMZpz5G.v69edIJFrIDsbMf5Jb6w5VmaWQdvwr2
 6k9OKlrYl7NNZKBWly.cDML_tDoE.YUPpB4KaU3qFIdXQG8AQ8YvO7WE36_xJdy9pA32x68MrlLd
 aSfr.0btVsQz67qH4bsMHSjbW0q3H_YYDDJAwxPDeBY2EabO7wTf_J80G_DMLAscp9sRVzs3Yqtp
 iB1YN9sihOASUXXLQqSpdDaqS.sZOXNEb_b4UUgFdjFAka3ocepYQqo0w7__jWIZXK48QMxTMBMl
 gdMIfQksgDiWB_8YLPbS9kY4_DFSrY3cjOb0zmt7s0q7EDlwAqIuwHgbT5x0hBnQOZWbGFkhDtdw
 G7cVGG2eGETks8S8lgTLKpKYHPJoLVmIzSPAbpGImErBDs_AC3jloHj0Rj6u2L.JovyyGAmxqltr
 HwuVl2OOkuCqbzfEjVWRXJDNqJ4r2TF7cCyg24t2XgxjnIjKZ2UFps602ZNsjZRdQachZ9SlWdiV
 OgCANCBE_hoVtwmsr6uTMEWKXId6LjPvqdn1WfZ85qwPsHgCf7gSoAr7voVRc.A1E7zHgvIM3uw_
 Tklmt80XjFDNTMH13O8Ah0Ugx6VB1uUuwh8TPlgcDTgurHNVv.hLpJj4QPTmGn_l.bp2OiDboBsR
 SO40gSF2PqLeZA6JQveiXZaX6OIR08MWHTNACIOGUVGkrak4v_B4exPoM86yr72PJg6C73My.WLD
 pt9rP9SepNUa558zlNQlLK_ZzIkNoWTJAWai9lfmeLEBBd6PTBUoRlE8KqDdfvMdy4VC1Knq.mg4
 XOVATm3brETD6qeH_.Mk5Fe.9DRIDoNCl72Hnla5N0UgcpF2v6gtZwkEhGilzLIbLkimcBGbIzjh
 aT4VK1sRFIFMudffisDH1cjG92B5itoyWQkgcIwV6Mnj4KbNJgQKPqcp5pxNiWsTvftfERdh7XeZ
 8ETtJzzcKYGzYGHgWldfw1mKz06W.othayz8VJ87icfGhlRBTV1quqfnG6koExOoy5oFHP2ZaMyn
 h3UwQEiQ-
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: a29483d2-7f5e-4e3a-86cc-e4da370e994b
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.sg3.yahoo.com with HTTP; Thu, 8 Oct 2026 04:38:00 +0000
Received: by hermes--production-sg3-cd7bfcc7f-9nsxm (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7fbaa42255083875bb3346c67ecc2047;
          Thu, 08 Oct 2026 04:37:55 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH v3 0/2] libmultipath: fix leaked device-mapper suspend after a failed remove
Date: Thu,  8 Oct 2026 04:37:47 +0000
Message-ID: <20261008043749.23389-1-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007092236.165908-1-suresh.thelkar@yahoo.com>
References: <20261007092236.165908-1-suresh.thelkar@yahoo.com>
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

Patch 1 is the primary fix. Query errors on the failed-remove path were
misclassified as external removal: anything that was not DM_IS_MPATH_YES
was treated as "removed externally" and returned DM_FLUSH_OK without
resuming. But dm_is_mpath() also returns DM_IS_MPATH_ERR (-1) when the
status query itself fails transiently under ioctl pressure, so a
still-suspended map was abandoned. Only DM_IS_MPATH_NO now counts as
external removal; a query error is logged and falls through to the
resume path.

Patch 2 makes the resume on the failed-remove path robust: it checks the
DM_DEVICE_RESUME result, retries once if it fails, and logs at condlog(1)
if the map is still not resumed. The retry handles the inactive-table
case (dm fails the table swap and leaves the map suspended with the
invalid table dropped; a second resume reactivates it with the old
table) - the same scenario dm_addmap_reload() already guards against.

Only libmultipath/devmapper.c changes. There is no change to the success
path or to behavior outside the failed-remove branch.

Changes since v2:
 - Patch 2: restored the single resume retry (dropped in v2) and added a
   comment explaining why, as requested on the list. Per Ben Marzinski's
   explanation, a resume can fail the table swap on a map with an
   inactive table and leave it suspended; a second resume recovers it
   (as dm_addmap_reload() does). Martin Wilck agreed the retry is
   worthwhile and asked for the explanatory comment. Kept the v2
   condlog(1) so a still-unresumed map stays visible.
 - Patch 1 unchanged; carries Benjamin Marzinski's Reviewed-by.

Changes since v1:
 - v2 had replaced the retry with a log-only change; v3 restores the
   retry together with the explanatory comment.

v1: https://lore.kernel.org/dm-devel/20261005045726.71858-1-suresh.thelkar@yahoo.com/
v2: https://lore.kernel.org/dm-devel/20261007092236.165908-1-suresh.thelkar@yahoo.com/

Suresh Thelkar (2):
  libmultipath: dm_flush_map__: do not treat query error as external
    removal
  libmultipath: dm_flush_map__: retry the resume after a failed remove

 libmultipath/devmapper.c | 41 +++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)


base-commit: d53932bdbee02f440518ea384e63d7c4d3f66685
-- 
2.43.0

