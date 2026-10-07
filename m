Received: from sonic313-19.consmr.mail.sg3.yahoo.com (sonic313-19.consmr.mail.sg3.yahoo.com [106.10.240.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FE345A297
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.240.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365601; cv=none; b=YBoDRnB2Jl0oVKoQ84gEV2U09/9tEWvfT8e6ptNsIFYgYa1QaFT3SG6mRWG0iTyDxmkOAc0siau3rwFl63+bWyUAAslUGUujTvv/aY7LmsE3hpMgQMa7HA6Px82GBpJsL+G5Dyjk0LNkGj4vS9TnoVGLOCoPDqOmv8kmxKjisto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365601; c=relaxed/simple;
	bh=0HeUp7n/QAv766O9UcxFw7tloWYMVutrudn8+cijPJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNrBZfBUNjSRKMst379O8f0O3FJaKz4FWF37NS0bnBKrUsVoXYXQTIqp98d3KptCbA3G71TiUh1Vca19c+CCOxyjyxkNtonfR/efi0x1wIc8dgupEr8S3Pi/L5EDnL8LSZv3hInecmGEz6i937ApY60ILO7/ciaZjMA+zisUYQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=AWEtXfsk; arc=none smtp.client-ip=106.10.240.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="AWEtXfsk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791365581; bh=S4lY2QyM2g2QhBi+CDd2cI2BfbCHOoXiE73b4h5UGVw=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=AWEtXfskverKZQcI+ZWBl3Dg18EVjueowYUu4Gu475x7nLTH2J7++Qw6RkK8YV+1RDIF2qBbLYz2ZcCjGeRgQkfAd2lFWTjJVq4eviCRP7wJUpzKPRwW7Un6P406/apbFQEKz/Q5sb73kbIojvn5I9op7b9Z6TtOpV9mZ1RaObUukzEE5zkkux6wpB17S7xBdfcwa3bs/jMVvSpdSr9PlEV3WPkIfBzKmayt2qSuogrAZXCJNKyMbfNzM3Cr3fntnmssvdxDjXvV74+OTbcYgOjbrjW4DF5Fqe2YWOqnCXH/sW7xjDDxQdWKg0ZgxqAzxyMF7ZFKyBJQGOl3Nbk5xQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791365581; bh=vsEqXbO7r0KjyzMhPoA6Rphz2j1Ur8Dyae/UnAmisLp=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=b4+WShcl9F0YgBxVNKmZCIcIHvs7PwtgEtwa2UAL1UI08kR3XKbDJwWhHcK2glxTu3qg5jqrQWjfcrVRk8E1+UWj+p+ixV9wCvEZ27LvhX8PcFtjC4FGpwBL5hzOKVf7OXyzFA1qBLKRBLHI+tR3/RUQVEF45jmc9ML7OuO7YT822z2jV7rgVTxJpflPHUglMGbqBDmO679hK9Fta1puu2M6oi3B/eiOF6yFA2JBugeFizo3KzKWPiAFqgS7hQxF2YlGFvtPMOZ1CmbeRILfJPIlcIYfM4/stvJLaZjpjhoaRyLqtH5GqAZBDhGKFO4Krg7QS4uOmYng7QYk1T1hFw==
X-YMail-OSG: DZqChWwVM1kEvsvUWpiWxP4qYaNFXEtRwIc_GH3_S8B9oVlinqymyi5.Ci8tNPr
 q6_h8l6EiRLGm.bL6uIN9sqRwbDS5ubP3kRt00TpsfG1m1syIO5ilykZ_qU.5_735x2KfqrlHMZb
 eH9e49NOVG_zHt1K8GPtZPp4JG2Ek2V_v9t8Zjdhs7HOvCSAr63mO5efDLY9s3l8idKhOPmtrLVP
 Y3kJ2b_ePzjfFValVNI6SoxfPf8VATI0sqIQ4wGLJEK7Ix_a83yPxNxgJZSAzwzdAi_OacNeFB2Z
 z7DFVOVvtvL.Tn8kOL3E95FMH1UE67J2ljDXhSHcVnewjqiW27.ovoCuhJQopMve53ARNEKzZ4tr
 DB6j1A5Hx..7_apzFkiCx0iobqijUQhSfFEyNB8Aj9xUTF9gmvrKqDl_aHYGS_b3T0yoaWgvvCqb
 zIRLyJXf9el07prb8VgrPC2dc22YeZFIGPJka5SvZP4lbHIwTL3IU0VEZ62ivg8lDF67CiyUQj9Z
 fPS1DQkYI2S_1yZRZRy.2Cu8YQjVgQBRS9Dh83usMT4Yf4YVPyQkTXVFyaS9GL9cHEIQwlKETQ.7
 QV4WdTmT8MjMpy_9S6sOq85IPj7kub5eYLufy7LsPVBulQfq2PxoUwOY7q.p5mkjiCz4Xdgs.gyS
 nyyp9bM7al_91lWV9RqJ_rLau_TJ6aQ0N9v_vzJgaia.WW4OcyXtUOBtYrFc4mvIKpXnpg2qj_ao
 ObOi3iRaRALwDXUM7YYMUdfPqtmPfGOkrXnx7Vmpt9YGwAJ.UBkHQSGvxmujDpko2uZhaNY9pc2g
 X1pwdvwjRxOgMOJH5Aai_.INeSeJe3WRrPzGaevZSiRFzT8F7dIyvA5DWZs33QKSn2rC22M64DP8
 4Pz7JzAqQHfuOgtUbQwMf7_bF2yD4I5xTHBWv43Y593bthuTDXWuGjKI4DDd.epGPqbq7266I.6d
 RdT_Doan6QrE5BcPprTVWTHBqOBKMaA050nR4A8oI9AlBzzFSDBx1zKAFxAKXVO5RffpUV7p8.5G
 iDzKI7ItzVe8zd_lzqht21l2gLknftOamW2shgjVqggMNOXKhQQYfTXlOtakCoCVNyzeCQkflSst
 3A7M.R_wavlSEzaU0fo4uq9oGqgYp8JwWG6YfoBFeOEU1XJP6mQBBXLLo466U9X3UE43w9wdNztJ
 3zXw3voiFKwSGWez11jajNCO6GAfM8qtkH3fj4Q3ei81byYzjnJTU9yjfLoj2MDpNttqtHPOcKK1
 otF6_pU8PzQWhOJ6olrMwknDkbDkRp9YVgYDeeQQTr7TUOYgHhnUgZsgDLOkPMeKvwG7p6djvuZA
 vonBf2ydtNqTE5eY59eyJUkCdQBQ3P6M5BHC9dtpSjLBq.4QUqkrHgK2EpXq3cie591KQSkc5m7n
 sJr91JHuBTos_t7gwYzBhThYulG.FrUhdsCzzAOqDerY8tUgk2BoS.HuhGEhhc8v53eYRN1W0pDC
 d3F6FH4tOh3QWaC16Y.bRB.C7OSeXVkmBMSyJ_3wd_jOzKbdEVm6obRWjeIaCZZA7GR4yvD8Bmh9
 rTTtp8NorxwCfqg7TvVsmtfseqMwdpE1VSZjw9QrPpuD56qC9v2T5S1V1grtyN6BBeeoEJEzGm5D
 2CA8R1mNHGxeEX88GftgAzXoxVvo.EuUn0jy0ux172jBPFAlC9fxjp2dD8amKSnHZ83jMvGUW9JM
 tv0DsUcrjWv8Guxpb2YzWSiKzCr8g_batOCnkVYKTX3c7pkOaByjFshTkHx7zXqhnK2siaoIfWxB
 KnX9eo27otXaBnORyXsXX36GgK0LUjybihN9p1wHw2jK.WDxAbmVh4yyL1_9MfV0zQvPY4U7ylk2
 csfoGovwKGAqwmcFjOWILZR5Xxn60MY1dj_s4Z4SHFgSEWSpEJcmSmOEIrsae0HESkJ3FF7yaQHx
 0bU5kbOzb93si5fJtGk4MNBvEvx.plI_p4n3psIvGKVEj.gFgh8ExjnJAgS1MDSwdPIc18vJ6n4B
 E.GD9SdPKDaOR3wtmembHgBxyuH4V1eRmQe7pA50f3Zp6wfYV9ufwW1z5cR78UYUMAJjmNBKF7A0
 KbNSUOwqMVlngXbgyCGArBHex6ayVT4Nd3xnAk6t9W969rvql1KTTPqiA7J0w0.1Vj__X8HNEX0I
 7hoJNiROKBhQ_FZUIXlqBfVAN3tF3Y_NZ9Hr8dzLcDbJ7F7vHzqx87_kiYtgXoJpmYbqXnP6MK6r
 mUvyiEqP.rWW8onDdMt3WGqe2eMj8wOZ89OC233loJX1gzyZ24eqMAizJ2gfn4TU-
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: 71ad8de2-d415-42ab-8416-f8ff2292dd25
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.sg3.yahoo.com with HTTP; Wed, 7 Oct 2026 09:33:01 +0000
Received: by hermes--production-sg3-cd7bfcc7f-rntbs (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID c6aa332ecc93d11e3ca3dbd3283b5adc;
          Wed, 07 Oct 2026 09:22:44 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH v2 2/2] libmultipath: dm_flush_map__: log if the resume fails after a failed remove
Date: Wed,  7 Oct 2026 09:22:36 +0000
Message-ID: <20261007092236.165908-3-suresh.thelkar@yahoo.com>
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

After a failed DM_DEVICE_REMOVE the map was suspended earlier in
dm_flush_map__(), and the recovery path issued a single fire-and-forget
DM_DEVICE_RESUME whose result was ignored. If that resume ioctl failed,
the map could be left suspended with no trace in the logs, which wedges
any later task in uninterruptible D state and, because sync() walks
every block device, hangs I/O node-wide until reboot.

Check the DM_DEVICE_RESUME return value and log at condlog(1) when it
fails, so a leaked suspend is at least visible in the logs. The map is
known to have been suspended at the start of the loop, so the ioctl
return value is authoritative.

Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>
---
 libmultipath/devmapper.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a5570a85..85c552cf 100644
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
+			/* Resume the map suspended above; log if the resume
+			 * ioctl fails, so a leaked suspend is visible. */
+			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1 &&
+			    !dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags))
+				condlog(1, "%s: failed to resume map after failed remove",
+					mapname);
 		}
 		if (retries)
 			sleep(1);
-- 
2.43.0

