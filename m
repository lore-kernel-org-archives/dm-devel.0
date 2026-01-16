Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBC6334C30
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563184; cv=none; b=R9t9AzykurcGf03pjDHkoB50nQuHGNCDp+F4mrYh1SbRBoSvfamYS7Ah34iJ18mziE8pYEK6+OKZRs8TRAccKM0/Gq1U9VzOReb53Rr1KE9lMDCq4DwXu51lCOxUk9S6MxChNMOOJztqeqTy7rZKshwSy5yXDN3MdPkIZELztWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563184; c=relaxed/simple;
	bh=zAh+pPhFJHXQQEq5mKPXyP0P8BSJg/0e4E+CsptPi0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwJeIg3i5FsnuiInBxbxyyenwdrGk5VRUcmdMkfWqrCAtJAYcyNnyvQoytgwTsHBnzdCOb9WZUT/Qt0rA/Olye+NACp+kWvfrm5/sIFlDwx0Q7tOwGtydCNKuAzDxM4MY50CjnQsS34CmOxrijzFa6ZjAe0xbcSrnkBvMhLykww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NCRmIre1; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NCRmIre1"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4801bbbdb4aso8601245e9.1
        for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 03:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768563181; x=1769167981; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpEc4zeahjkzePqOaQKnLlfWFAo1r4kHKso4ivZ++I8=;
        b=NCRmIre1qJZ0exc6qBJ1WWRS34hOxeQnfC3flm858dbg1NvbCgx7O5J3vhAD3+GGSO
         wG+NYQ/KRfNq5wjP7blpC64yXJv5GgfEl2t7To2tzlb/Y1wMmwUljyaP+FucITKNu92/
         7pfpvxbN3sa5zsr8y48NgilLpD0dcA04ThkUgrTNcxXxMK74rbCEYF0YhO/ubUSiJEWd
         aWJ4n/JJCWBtovBpQyyhifqxz8hxEA+M1NT3+NqWAh515kDJAXQhqSmtrCa1bWJ6iT7+
         WSMjN6NqSDy6oZTpnA+yi+ZtACHq81AR7H3tIfgOX3INptCTnHrzxbPnO+gi0iN7lR9Q
         zf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768563181; x=1769167981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qpEc4zeahjkzePqOaQKnLlfWFAo1r4kHKso4ivZ++I8=;
        b=cpY18ceIRZxA3Qb+j5Q1378YDyT8jLVtjuSh0PU6xMYZNSBOWSk0nKuf1rkFSEgz8t
         8mkwPDEWhikULEAg3UWH1E3BUAczD+APhTL2dH9QGWZr0bWVLbYprpHg8DYFy1v2wEvb
         8xsJZG2OOSamxTXReqvyO+Dsb7qL8imom8X6zCFBMDvhmwF1MejOje91sAZiRACvPMrd
         bIFsX5W9VZNjQXsJBZbhLFhTiZRcZiEwO5UNLdb/r+OFHr6K+GlpLATvmNBBUAPKDsk3
         s7i1qv0abhBxi8pYaMTLPMxzKb2FyyxIlAssHocBbEn2JE6lWzexDw0qpkZNV/+pWnel
         jWKg==
X-Forwarded-Encrypted: i=1; AJvYcCXVkeK9IeqS09Fns5qrQ9hrKWarC34OHfQN6jJj5Re00XXjsmFmle+zbOpQVtiiK09Cn0GxkpS5gw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyF3hstKwvq4PBoUFK+rvsD9S3Q9L0FDlStbrFbjqkSyF6RQmYb
	+5w6O4fJNZS8zxjKvZ6zdtoHtwUzPvOdDaBWfwDfh6s90Nhdoj7jX109Im0bZI12U+A=
X-Gm-Gg: AY/fxX6ineehgRHe9lq0rKL4zkVjovXZwJnfMCeOtrvPl1TBJVAxbllrPpIz30NXTFW
	qLBkd+btp9UuVdr7LY+VXhIG0VC+6s+Ym0/FWin1+GKaL/3byucImcmcWuhVBXMIiLK92JjLWGq
	o2bFwAPok3CpSHsMvuNYWXGnBhPGApYlriymVVdDOS6NhmGWWC+hhOvoe63G9MsBoYYlegOqQyQ
	csfuDUx0r44IZLEeHLZFu/UXHNz9nukgdA+rckRn4+S8kpjEr3jswb4BPzgvJYQjlGJK6g+xJVU
	42ACQSi4W7qGP4pgGFarUthnLnicBUs+9fbLyhnFa9uMQI1IxyBpGtYUf9Enq/WzZhZ9L/K3FUt
	KNt8Md8w3kNtM8RId/BGuNTu+u+uuuSDZgu0hI5V1Ihx8VQJk1raTSoIdQ29vRQ/YEM4EuLCyx6
	R+0F9AVNAaydZwKlz2I6SxG7GBuzeedw5driNgZiq+GTNKO+5GX9oDspilkeIU4UtWTqAKE74Ga
	A==
X-Received: by 2002:a05:600c:6048:b0:47d:87ac:73ef with SMTP id 5b1f17b1804b1-4801d7d2524mr30555355e9.13.1768563181454;
        Fri, 16 Jan 2026 03:33:01 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4801e80c477sm46216985e9.0.2026.01.16.03.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 03:33:01 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 2/5] kpartx: remove "hotplug" mode
Date: Fri, 16 Jan 2026 12:30:39 +0100
Message-ID: <20260116113042.140719-3-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116113042.140719-1-mwilck@suse.com>
References: <20260116113042.140719-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This functionality has been obsolete for a long time.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 78 +++----------------------------------------------
 1 file changed, 4 insertions(+), 74 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 6f2ec4e..9bdd204 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -145,56 +145,6 @@ find_devname_offset (char * device)
 	return (int)(q - device);
 }
 
-static char *
-get_hotplug_device(void)
-{
-	unsigned int major, minor, off, len;
-	char *mapname;
-	char *devname = NULL;
-	char *device = NULL;
-	char *var = NULL;
-	struct stat buf;
-
-	var = getenv("ACTION");
-
-	if (!var || strcmp(var, "add"))
-		return NULL;
-
-	/* Get dm mapname for hotpluged device. */
-	if (!(devname = getenv("DEVNAME")))
-		return NULL;
-
-	if (stat(devname, &buf))
-		return NULL;
-
-	major = major(buf.st_rdev);
-	minor = minor(buf.st_rdev);
-
-	if (!(mapname = dm_mapname(major, minor))) /* Not dm device. */
-		return NULL;
-
-	off = find_devname_offset(devname);
-	len = strlen(mapname);
-
-	/* Dirname + mapname + \0 */
-	if (!(device = (char *)malloc(sizeof(char) * (off + len + 1)))) {
-		free(mapname);
-		return NULL;
-	}
-
-	/* Create new device name. */
-	snprintf(device, off + 1, "%s", devname);
-	snprintf(device + off, len + 1, "%s", mapname);
-
-	if (strlen(device) != (off + len)) {
-		free(device);
-		free(mapname);
-		return NULL;
-	}
-	free(mapname);
-	return device;
-}
-
 static int
 check_uuid(char *uuid, char *part_uuid, char **err_msg) {
 	char *map_uuid = strchr(part_uuid, '-');
@@ -239,7 +189,7 @@ main(int argc, char **argv){
 	struct slice all;
 	struct pt *ptp;
 	enum action what = LIST;
-	char *type, *diskdevice, *device, *progname;
+	char *type, *diskdevice, *device;
 	int verbose = 0;
 	char partname[PARTNAME_SIZE], params[PARTNAME_SIZE + 16];
 	char *loopdev __attribute__((cleanup(cleanup_charp))) = NULL;
@@ -247,7 +197,6 @@ main(int argc, char **argv){
 	char *uuid __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *_mapname __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *mapname;
-	int hotplug = 0;
 	int loopcreated = 0;
 	struct stat buf;
 
@@ -258,24 +207,7 @@ main(int argc, char **argv){
 	memset(&all, 0, sizeof(all));
 	memset(&partname, 0, sizeof(partname));
 
-	/* Check whether hotplug mode. */
-	progname = strrchr(argv[0], '/');
-
-	if (!progname)
-		progname = argv[0];
-	else
-		progname++;
-
-	if (!strcmp(progname, "kpartx.dev")) { /* Hotplug mode */
-		hotplug = 1;
-
-		/* Setup for original kpartx variables */
-		if (!(device = get_hotplug_device()))
-			exit(1);
-
-		diskdevice = device;
-		what = ADD;
-	} else if (argc < 2) {
+	if (argc < 2) {
 		usage();
 		exit(1);
 	}
@@ -337,12 +269,10 @@ main(int argc, char **argv){
 		exit(1);
 	}
 
-	if (hotplug) {
-		/* already got [disk]device */
-	} else if (optind == argc-2) {
+	if (optind == argc - 2) {
 		device = argv[optind];
 		diskdevice = argv[optind+1];
-	} else if (optind == argc-1) {
+	} else if (optind == argc - 1) {
 		diskdevice = device = argv[optind];
 	} else {
 		usage();
-- 
2.52.0

