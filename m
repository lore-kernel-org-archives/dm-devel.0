Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20676568A
	for <dm-devel@lists.linux.dev>; Fri,  5 Apr 2024 00:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712276634; cv=none; b=UwlDcUkXciI/cucnkmh3HYhMDPC65kmoOXdq2FM32O1WcieSVe+9g1Nxv48CYweyYQ+Rh+mGF66ootTpPaXryyIpa+6FGeBTs41IF+qPnRi7rOUPJ977X+x0EgHEDr+/M31YXpHenp6kCTun2pK/atwvO/TboN5FhWyl+KVn7To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712276634; c=relaxed/simple;
	bh=lhvmV7pMKo74xSs7wy8jPXsXcF2uNhMsDUXmPvw8M7o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a1nMvq55X0WAdRxH8tDXw2ijl5nJRZ+GzmIZDdQJTAFztr+bp7m0RFWJR70INQZTbBFPFWaaMT3r1hGnPge2XC/9yWOCDduw0/CXvK3AS12FJvHKEn539A/626TJ00v/ebb/CQZLpsgQ2T3GOCZhpSteyf/f58ORXV6bfG74/pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=efficientek.com; spf=pass smtp.mailfrom=efficientek.com; dkim=pass (2048-bit key) header.d=efficientek-com.20230601.gappssmtp.com header.i=@efficientek-com.20230601.gappssmtp.com header.b=uS1dyWfD; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=efficientek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficientek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficientek-com.20230601.gappssmtp.com header.i=@efficientek-com.20230601.gappssmtp.com header.b="uS1dyWfD"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-78bd22f8257so97195685a.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 17:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=efficientek-com.20230601.gappssmtp.com; s=20230601; t=1712276630; x=1712881430; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hxgSHz7zrOzEdSxZ0uecDYQ/XyXaOHsHW1eEbu5IzTE=;
        b=uS1dyWfDti5+vjI4mQTo/vohsvsJdOvRUXdUKrgCH+ZFfx+hU5QYueWeJTyh+CmsoH
         JvAzSagZIblp6JPIcFEgzP5IK+A0GgcdelY33B8sR3g0X0qntLYC4uOM7dN01tPht+sE
         i9mDHXr5SR25y1l6I5Ztl/5ogpIj6aOjUnDMW0Jc5lduo1yxMGN9CtRy+FjagHHHk84H
         2mTyO/dhrajP+05x0nsB1tkIFx7cnBofkaChcWlgrc4yCtYzs2Nwr0o0SPz22ADYA24z
         +7Xovsd78ZNVpN5ZDThGJJBTHPU1aDKaR5ZxsUv26w+VrPVdzgZo9GvmoBwz+bJHLKEg
         LAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712276630; x=1712881430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hxgSHz7zrOzEdSxZ0uecDYQ/XyXaOHsHW1eEbu5IzTE=;
        b=lBmT0N25wN73hX8y9v+O8hpPfyw5IhV4KL693ZTKRXfBeq7VySDxHVyD7QaZa6gYDH
         GxJIqCsY6NrAZ3QOmrEkdaW4899pUJQ530spvUKnFgh5OVI35YBrrt3ac3XQGaU1GQ1O
         R1qRzb8rzUniRQY4JPvEg9UKW/TR9G0dHHup44Xo9ueC1JLp33PdOz6GGACswKj7c9YT
         Eg7tOck4aS5s0wLAQQ8TbZ01lV+352SUZ/iZ6u1pFdLgSwvIZSFHSSFRhD9/csJCPkP5
         au661NdeU3y3in92Bff9dbRWinjf80/0W8MXVDfPcxcVdHRsfmh5dWlsgNyIQjQPmKsw
         aaRQ==
X-Gm-Message-State: AOJu0YzjrHmOk0CaL6C0DgrE/N4jkDPB+i/6XW+DMlrGb1JpFyyFevvJ
	Bq2ixW1+BtfqkzcOtB7256pxBwUJ9uCyOS9yoDeHR1IP/d5lw4v36oqHfzBno9Enj49Sj6wsLpw
	=
X-Google-Smtp-Source: AGHT+IHs7TR4wmQwKJpGFIhkZLjZwalJn5CsViv+m1TTdh45t8LGJ8OSuEOkduwIRvMQ9aSIiGZduw==
X-Received: by 2002:ac8:5cd1:0:b0:432:d8ca:cd91 with SMTP id s17-20020ac85cd1000000b00432d8cacd91mr4371704qta.59.1712276627709;
        Thu, 04 Apr 2024 17:23:47 -0700 (PDT)
Received: from localhost.localdomain ([199.58.83.10])
        by smtp.gmail.com with ESMTPSA id ff9-20020a05622a4d8900b00432ff1e29easm219052qtb.97.2024.04.04.17.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 17:23:47 -0700 (PDT)
From: Glenn Washburn <development@efficientek.com>
To: DM-DEVEL ML <dm-devel@lists.linux.dev>
Cc: Glenn Washburn <development@efficientek.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH] kpartx: Add -N option to allow specifying a devmapping name
Date: Thu,  4 Apr 2024 19:23:32 -0500
Message-Id: <20240405002332.442743-1-development@efficientek.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running `kpartx -a disk.img` will create device names like
`/dev/mapper/loopNpM` where `N` and `M` are positive integers. The issue is
that `loopN` is not known before hand. `losetup -f` can be used to figure
out what the next loop device will be, but the loop device might be taken
by something else between then and when kpartx finds the next loop device.
Add a new option `-N` which takes a string argument that will be used as
the base name of the devmapper device.

Signed-off-by: Glenn Washburn <development@efficientek.com>
---
 kpartx/kpartx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 46cb76bac678..750b889327e9 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -88,7 +88,7 @@ initpts(void)
 	addpts("ps3", read_ps3_pt);
 }
 
-static char short_opts[] = "rladfgvp:t:snu";
+static char short_opts[] = "rladfgvp:t:snuN:";
 
 /* Used in gpt.c */
 int force_gpt=0;
@@ -99,7 +99,7 @@ static int
 usage(void) {
 	printf(VERSION_STRING);
 	printf("Usage:\n");
-	printf("  kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n] [-v] wholedisk\n");
+	printf("  kpartx [-a|-d|-u|-l] [-r] [-p] [-f] [-g] [-s|-n] [-v] [-N name] wholedisk\n");
 	printf("\t-a add partition devmappings\n");
 	printf("\t-r devmappings will be readonly\n");
 	printf("\t-d del partition devmappings\n");
@@ -111,6 +111,7 @@ usage(void) {
 	printf("\t-v verbose\n");
 	printf("\t-n nosync mode. Return before the partitions are created\n");
 	printf("\t-s sync mode (Default). Don't return until the partitions are created\n");
+	printf("\t-N use name as base name for device\n");
 	return 1;
 }
 
@@ -312,6 +313,9 @@ main(int argc, char **argv){
 		case 'u':
 			what = UPDATE;
 			break;
+		case 'N':
+			mapname = optarg;
+			break;
 		default:
 			usage();
 			exit(1);
-- 
2.34.1

