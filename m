Received: from sonic311-22.consmr.mail.sg3.yahoo.com (sonic311-22.consmr.mail.sg3.yahoo.com [106.10.244.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F683B8D79
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 04:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.244.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791434286; cv=none; b=D+As7hMf5ykibUYh6XXFoVwxxp/VhUIu7xA0M3FrC7Zgin4BBwFCTHpx27IMQqhRMrN19lRRhvUlih5sWyI/IwRA2d7MjQ2ldzKgDXqU71S6VHzu1wCAWUkiZsERPt9Wb23W2dil/DtzQ6wpr/YJoe0kNf6kV+Gdn59bkmchoSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791434286; c=relaxed/simple;
	bh=j4Xxq//HZN7Slf1mqRAetQbinYZnBnA7UU3/CfgE8as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WReIZUEaTAObvDxnwhlEVdU9JPE8rbovmoA6Y13p7YUzH1bjpSz5USq0/iIFbcQFcO0NmGzHmbzOhtNl7mLC4YCvzHSixt0ayjz8iFJ9O1W3H7JUe+LWpy5uK2B1MkMFuQWFui9S/6rXw1xwH08P3nvlhhe9FIHRfQe4ut02H7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=LFwNDbx/; arc=none smtp.client-ip=106.10.244.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="LFwNDbx/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434282; bh=b+axz3YM1fo90FeTOJXF+gpEBSj6ksNG0zqKMoPkCsc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=LFwNDbx/eJEuKpRkZ/NqIaAJKyTcEk1jjYxk8Yq9Qxs+HxRxwBpucYUDdDB+MwAUbYMsG4v57VS0k5arNLGWG92cQwf9aNbUJjogH0mNpcqLSPnPZXm82EBe53ggdiq2qreEK+AZX6gKQ9kOr1eUnQqmVE+QURDkbZd/lLVpIlfS5C8tg0zAavoYL/gDJaDO8+p+/3+WMWIAoFnapU7CMFT0bdfTkjJJH4M5OVGoQvL/2Pu8Kh5xq268SmNEqnchcEIkSVby0NwgaKzw2RxK7wt7VfdqORIBATjRtf0mcEGcpKzBE8ccSEyT74Z95C/AUp+0elJx6MKeMIwwuWiTGg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1791434282; bh=5O2eZDFAADfGQawitJkLtx+z+YbnQGzaaHr7m664fY/=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=loddMWVKwLIFROF7fpHdf8U1YgskrQb8NRqLLj4uCzVL4jAa+BKSiC2Ws/NZA7dRDtP/thABdkLL3NOdC62RsI5dbnZSqUfxuoVzYwWu6ZZgM4fXs174Qaw4UYqDe16Eg1r3/S9oeCqm3RIx64sPdEjQ0/NerGsJ5/H3Z0rmXQ9fws2P2Q/Tv72bbbIHlSZHQmh8zJSQ4QKS8L/7HKu4f0HBYDwc/cO+kHgbNWE2/ZdE631FT45xx8ETTvrU/7H1Ax8vOBhskFR3hWfnJVZTo0TCLzVmmc0G4eptXgU0g3Y4X219y6sQCFUdpGb/ni8LTvUJ2y1XbzkLgOGIbFtdxQ==
X-YMail-OSG: cZ9TmG8VM1k1RmXqxonChiIhANDsnMBUAZ8EhpoyQZ9qAHB14mFKPoNypHg9p8v
 FhBI9ecvSBbcVcfGvrcveoRJ2oVb8thw7uiWJLCbZ0Za_71wJDdnxE7X_JlRosnMYiBIY.50nMrR
 y93LPNoTndxeVAQjgq1Xv9hor867Q3KhRxCwQpWYZakDCfurhr8TwwL_FiYKh2Z3ydpUvYGSeiLj
 tO5goObtGVMXgTxo1U19mKq1.EGnvtvr_6M7Su7U8Jgoc2vongf95kFKGbFwQxg5Zmn8cRDC7ptH
 B.D1BTfrqAOyal.Hv_DqCLgZ.I2EAFwtkf74Mp34o1byLWzgn0TvEPh3VV5W0h7fmQcfdR76Kt8p
 .fCRFxXjzHeYihWvGzvchjiMpGVwx35d_Q031fI7kCMIx5FQ385CzK8uStBF5c_xmE_aHnw4.mcY
 l2McDq_PdEsCNDWFPvnFNv2.sGdvVXLyNaqTVvJHyEgn1t65e597sML15tqmOviCIkW8tjZEjnHm
 ChGTVCP8yfxfcFwTwUae3OwPrerxCTlS7xmD4TyfWnZYClszIsuLN_agMu82hYqBUVOhLGy7AbZm
 FBlUBjxL4Z9gF72DgV8Mj16W7h1VWjBZOr.CeBFpoQdlklv84oO9Q_kqm7c_HaL02JvVUNDpiAAK
 H5CJiQn24sgzrkA1Rk.Dhs7tQGc3rSZkZE0JqaKQhJRRwO2KCZaItyczzMSG1h64.XqipJazCDIA
 Dn7Kp2O7pdYqznvwF3ZPD_P5mrIwVlUy9ORZx9gTAHdu03VE2qlUFWF6Zn2LpLEFS.aGhZHgKlal
 cMHWbSaxIajuCvgAGqqS_Guuljn_SquwgfhQukzuxCN5vooI.BxZ0gD9KiRvnJI7oZDZMnkHxsH4
 AVKjKu7tpEKetWLXkVEzzdnb1YVzfofcWWEin4Zms9tuKEaepY4yr0_enRiLqfu6_B8mH0_CiCMr
 VeKT48kX986qsbkvb3myUEwFJn_7XGrRqClRLqNS1NaWUMeGgXw3suQczMtZzY3lI39v5UPuq0mM
 XwSiCtnqUil0XzPESC_B3mbY0EFtjb7la.Iq3s6g9aPL4xsDsNG9ZTwZc6iz3JnEEZqusBmFisrG
 lgY.l79dk7wGERm.OLoWZ5c8d_stYFLsSKTplWmMed3013PhzVGNYR1WT7aKU.VvZGWzBQxuyQ_T
 SfUwY.DBP9E9kkh8YwDJa9LPQlpV1XJNPXSu2bszjid3lj79YXeDGzfTfZv_25Ynjotqp1KGvnnO
 zikqzXN24Z9JPWpsMm662D8Bfs.ISmgJz7HqVyMOduWgntMQmuHlwxVN3AfHPUUg73lKqf9XoSzp
 _ikDGp1CbLjz6gBzFe8DprxHf6PiPSW6txBJ76TN6u0jDyBqL1ZHlyaGFvcQnS.vEqY5tgTZcN5n
 H1rGRarnm5PXyTkpTSsf4qfYfIptT0N3hZOmNQgr47W05GttqI_UHAp8wLkQlyWDYsUBXeRAzIfR
 7scIulRD4Q3SRuBVaJbezjemh.mvv4IaBvafdR23HwIy8FfCP0gptJtwG_97BiYMAi68S2X9R9Mo
 k9ZHtAgxoZCPvnBXZjuerX_shggKZg4c2IBkDVY_BJ6zGWczGKkwn5dDGnBfbDSb_toC7aYLLk0c
 btwEETRlFFZsvMsAAiTtVU39CZvFfoyR9HxWfWf.vQThoQ2GY0AQTVveLPJamlbfNQTzYKG_ag9_
 hOjmjgZ3ickj.RRDbHSQp8u7EzZkGvGqmOS2L44ybpTWCq5OEXr1922NYR5QDoU0R1iNRfeA3EZ8
 0ByTbKsShQferLfaHuWnhSHGRJfZupYgNmdUeXRWfrvQfMgVx11YpsFVkKDafmEZvMBPU_v9MrsP
 Wf72KuTCDd4.CO3vx7WnW2sIuUhjztaTwpWTU5rN6OiieOIFZBn9o5FJWgkFVg7ekaFJk1ies3vW
 DWckyUvK2E9BW1uUw1I5IhUX00juSAVH_2G7C01qDw.F_1RX4cQ6TEot.mn4R910zLSUTa2SHpG5
 0KEiRaioS_t0XKLE2453k7gtYV8NID4G3ild.TM8rJgvCtUxoUUQVaN8mAQXsPJsfYboU5M_lR5j
 btncOsin2l3l7pZTDWMIMGXmGjdev3JETQ_1LgaQc25SZMkIFJM2unHIWoXwenjY2W9V2nls7RlC
 h0ESsWqFA78uOwIHSuztCdciNLDDFDU584NrJ2qXa__drI6GWUrNLcLmRogh7o9wYZw.mp1fb4cY
 3nTK32gt289kqCjqr8KWVGSTSFyr4UDQuv6RfWkNl_mCX2E5Hwb5aXbPk6HJ_MDLW2_lj
X-Sonic-MF: <suresh.thelkar@yahoo.com>
X-Sonic-ID: 3a8c42cd-597e-4a66-8498-26c7c3076c28
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.sg3.yahoo.com with HTTP; Thu, 8 Oct 2026 04:38:02 +0000
Received: by hermes--production-sg3-cd7bfcc7f-9nsxm (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7fbaa42255083875bb3346c67ecc2047;
          Thu, 08 Oct 2026 04:37:58 +0000 (UTC)
From: Suresh Thelkar <suresh.thelkar@yahoo.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Suresh Thelkar <suresh.thelkar@yahoo.com>
Subject: [PATCH v3 2/2] libmultipath: dm_flush_map__: retry the resume after a failed remove
Date: Thu,  8 Oct 2026 04:37:49 +0000
Message-ID: <20261008043749.23389-3-suresh.thelkar@yahoo.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008043749.23389-1-suresh.thelkar@yahoo.com>
References: <20261007092236.165908-1-suresh.thelkar@yahoo.com>
 <20261008043749.23389-1-suresh.thelkar@yahoo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a failed DM_DEVICE_REMOVE the map was suspended earlier in
dm_flush_map__(), and the recovery path issued a single fire-and-forget
DM_DEVICE_RESUME whose result was ignored. If that resume failed, the
map could be left suspended with no trace in the logs, which wedges any
later task in uninterruptible D state and, because sync() walks every
block device, hangs I/O node-wide until reboot.

A resume can fail if the map has an inactive table: dm tries to swap to
it and, if the swap fails, leaves the map suspended with the invalid
table dropped. An immediate second resume then reactivates it with the
old table. This is the same scenario dm_addmap_reload() already guards
against. It is far less likely on the remove path (there should be no
inactive table here), but retrying is cheap and harmless.

Check the DM_DEVICE_RESUME return value, retry the resume once if it
fails, and log at condlog(1) if the map is still not resumed so a leaked
suspend is at least visible in the logs.

Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>
---
 libmultipath/devmapper.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a5570a85..e3f71bc7 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1062,10 +1062,20 @@ int dm_flush_map__ (const char *mapname, int flags, int retries)
 			else
 				condlog(2, "failed to remove multipath map %s",
 					mapname);
-			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1) {
-				dm_simplecmd_noflush(DM_DEVICE_RESUME,
-						     mapname, udev_flags);
-			}
+			/*
+			 * Resume the map suspended above. If it has an inactive
+			 * table, the resume makes dm try to swap to it; if that
+			 * swap fails dm leaves the map suspended with the
+			 * invalid table dropped, and a second resume reactivates
+			 * it with the old table (as dm_addmap_reload() does).
+			 * Retry the resume once, and log if it is still not
+			 * resumed so a leaked suspend is visible.
+			 */
+			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1 &&
+			    !dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags) &&
+			    !dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags))
+				condlog(1, "%s: failed to resume map after failed remove",
+					mapname);
 		}
 		if (retries)
 			sleep(1);
-- 
2.43.0

