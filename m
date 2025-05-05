Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AFA25A347
	for <dm-devel@lists.linux.dev>; Mon,  5 May 2025 16:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462628; cv=none; b=bOvcmYAE9jOJM0BRoJSugViBnm0PiGVV3m1MN3X91JqUc5rbS1Z2samgOnpGM9jqt7Yh+W8UxA4FlymnGXO/CUiST8kcbxHuD4nvHO2B9e+mPv82H0yZ0t27F34rjGz1AxWiJTFXu63Co2RSx0HOU4TRusK4uiLX0d3WasfcaC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462628; c=relaxed/simple;
	bh=ez1/HjE7MadwY6icQIZ8AvkZMbpQATX5YT6qNc0tAT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZnxc99/APVsRcda/wQQxvUjE89gndvpHXyuc2DRz9GQHN+y2n8wGWuZExYwpPmwyiRsKYqZhTu1taf2OCrCMTjLNeT6hurVQ/xNSeRv8itgJ+SUZ3YtTO206Zu6vfwJpjv0/q1XOdzsOHstDO93bLyohyyFm8/SnBj6nuVMaaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UibwvuUz; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UibwvuUz"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39ee5a5bb66so2987460f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 05 May 2025 09:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746462625; x=1747067425; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2T/Bu4YROn5HbpCHKiW6ATA5yTthmYetQy0WYVYyDU=;
        b=UibwvuUzfiDxrccWGlg9HMKmMsZrtgw3kDt2SNEsHO76lCU2eOS4Y7bVzpHBE4qIZ1
         vJcJDdMVdFxtDSsLmQkZkzkgcp81cbQLAiopz8V7FuMZkkgk5RI9lfEni8pvwMM371PH
         m49CdDyImYR8W+MBumTiahPFiDq/68hL4mLKHjU3+RxdLhynE8mMZasokdcAc2LUtqAw
         tnGiM6UAXpjw5n5aFl936RaGRKMKycIOC+hO8pv6sO0XOXtU+RMViogRzfwWeVnfSmIB
         Uu2HgmMQGMZAWiuBPGgMnsIEp2DCifz0A+RYaWmNvLQTxrJty7VfNjf06jUZilK8sP/3
         Kdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462625; x=1747067425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2T/Bu4YROn5HbpCHKiW6ATA5yTthmYetQy0WYVYyDU=;
        b=g5OKwY3WY9oqKk5Y2NuAgvqPSeQmgFUOherA1Wsc5nQhf5Q0P0zxCJC9M64QsfcR85
         FCOsa9Gkbo7gBWfLpvRAcdm4a2vj1Sx5bZclP3RnDn5u9+rhsyXDsnc75LbIrTvYNGUx
         CYb/FVwJ3Y8gvJ3KJfEDM16ANu4PRep4iKfKe2YQLDVQsv3hxPe8KQeqAaOxLJAAuq8q
         y+BgGDfcJ5j0XK3DC0oALTtEo24u8aoGh68XTGZZsVHX+/8cRrtPv20ia2UrIs5JcXL1
         J4vQMd6qg2QeWt2V0hA6fW6JGPrNWVlVn8HX1nKIVk6VUbP3RhVrqSXBeR0UP/CLnSd+
         QK8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUnsIzuGo2gybhNR4XM1djah4aGahDGgIQ1l5NNaw111fmjcWxif/k2hCWI9FGZRCTFEMUTqzZvmA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxv1Zx00uri4rg69BM9fW02cFfmXIs2UBRcC+zz503HyYDMau7X
	RcDrokQuXRASTusD1ZhsC/ciQBVmdkUhdfezIIG6FPegk5ObR4+C7NcoinIbqvM=
X-Gm-Gg: ASbGnctWmlVuC4GP/aHFkY+3FyTwFRgNn7metrzwOKqDw237smKwc43+XzkdCo4c/Xd
	ZCp/ynHpKpMIyET3ab3FUTmAsUjEXxZQiMOT5HHIQo6ycst+3SeMYsiUnaZGpBAGS4BC6Arsqie
	aK1P/6Q+WAQH3GiP7UeA0GN/UxcfmBXpX/ALUHI3DRK5uUUM3zRWnL8xiqUg/f6BTqV1EDPPHGN
	hcuuMFt28Fg9XBba1K/VkrUdCFHzne04ionLJqpLj9gFQCWy6uc89xMkCgkoAxdjxX2x5hslQKb
	FdUGcBQEbTp2qg+jDXp1/qgy5Fk7rOMKdWJRqrMqsDdGibd/QiRH9akSBjfdZLGtYPHpl7057BR
	bcpIYzhTaMMNs2Nuim5ssDxwErB3q
X-Google-Smtp-Source: AGHT+IGGi0dOwXNDoIxu8Y6Lfk4XW8kZmYxrN1N051H1rrLIHhARDFOvEpdpe3qD1cvNxyvjG0ILBw==
X-Received: by 2002:a05:6000:240d:b0:3a0:7017:61f6 with SMTP id ffacd0b85a97d-3a09ceaff3bmr7705419f8f.14.1746462624746;
        Mon, 05 May 2025 09:30:24 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099ae0d3csm10691683f8f.3.2025.05.05.09.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:30:24 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/6] kpartx_id: fix shellcheck reported errors
Date: Mon,  5 May 2025 18:29:53 +0200
Message-ID: <20250505163007.59352-2-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505163007.59352-1-mwilck@suse.com>
References: <20250505163007.59352-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx_id | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index f9211d2..ffd3424 100755
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -25,7 +25,7 @@ MAJOR=$1
 MINOR=$2
 UUID=$3
 
-if [ -z "$MAJOR" -o -z "$MINOR" ]; then
+if [ -z "$MAJOR" ] || [ -z "$MINOR" ]; then
     echo "usage: $0 major minor UUID"
     exit 1;
 fi
@@ -53,13 +53,13 @@ fi
 # Set the name of the table. We're only interested in dmraid,
 # multipath, and kpartx tables; everything else is ignored.
 if [ "$dmtbl" = "part" ] ; then
-    dmname=$($DMSETUP info  -c --noheadings -o name -u $dmuuid)
+    dmname=$($DMSETUP info  -c --noheadings -o name -u "$dmuuid")
     echo "DM_MPATH=$dmname"
     # We need the dependencies of the parent table to figure out
     # the type if the parent is a multipath table
     case "$dmuuid" in
 	mpath-*)
-	    dmdeps=$($DMSETUP deps -u $dmuuid)
+	    dmdeps=$($DMSETUP deps -u "$dmuuid")
 	    dmserial=${dmuuid#mpath-}
 	    ;;
     esac
@@ -67,7 +67,7 @@ elif [ "$dmtbl" = "mpath" ] ; then
     dmname="$dmuuid"
     dmserial="$dmuuid"
     # We need the dependencies of the table to figure out the type
-    dmdeps=$($DMSETUP deps -u $UUID)
+    dmdeps=$($DMSETUP deps -u "$UUID")
 fi
 
 [ -n "$dmpart" ] && echo "DM_PART=$dmpart"
-- 
2.49.0

