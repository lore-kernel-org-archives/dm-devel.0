Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B13390C94
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 11:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784286922; cv=none; b=NFGZ4sniWiDVvhaYsBM7KBNdpv8Is3idISCa4l4oT0PDHXNcdODjj/F5ED7C8m9SRArbFJBJcxwZuM74Jnl3yUdTywMW2/3zBVUUeXE7BA+VvhjoJ9pw4E+q3ymGWmomrFgREnJa6rKITHjg45aZCpNii4z4zEbX3Km+zU60+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784286922; c=relaxed/simple;
	bh=uouEDjzJ4EugLfQx38hjB4b6R36v0dc3U+eljI2dQmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mbLlD7EIYZzCh2KFeSeazKN7gp3vYNF8GQA3+qMWlli0ScbOM4HXNO1+N0fGDNX0YxmhVzKmjk8i6QCekkts9tE9mbVgB45XDgJatqNbz1yi+Z1aTcd9q1U+d4npyJs8FkKgHg6ueDkanEh6Jy17bNsYt5DZEw5oLqCrsqbqr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pjM37Hck; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pjM37Hck"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490791a3e92so9630425e9.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 04:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784286915; x=1784891715; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DIiKEFXfOYK4kjZR+c30u/MqqGI+SpOrxjJX+YcjlHA=;
        b=pjM37HckwHTwhZJy9Cfu8+KwAUdVMWDwwUpJppfuy3tvz7PiaXML83JyAnGUSQeaiT
         quYEkYJmgqe9UdXhmmSEBKA8hJ4jraJpoCQTWvO5bR6SldXSkuoRgZIAZh2zeo/KVgcq
         r1Z5KEqtnA/qC4pv6COudL4/PxSte4iPwNnG1vkZ4/0Pz+BUd7/AFws6YSZhSsJW7A79
         A7fWz2z+bclg2FxnhPau21m7RRW1vNcibPLzNTc2XmjfcP+5Qv1ZLAzPALKJ/AZYbsEA
         KQJukDU3bpZsipFKiaWSUkMySZ1UpMkE8eb45lJQ1F7R1XbkcGx+ZZIAt6jOEloy5a+g
         lN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784286915; x=1784891715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DIiKEFXfOYK4kjZR+c30u/MqqGI+SpOrxjJX+YcjlHA=;
        b=ipHqx79dHNIyQW488KEhhYeqqR7GdHVwDfw7slK/qZGL0MGAtFP2qkcmsqi5Evvi4M
         LtkEWVKdYCpn3Xxdg56vlN6Xs0qsR3lsZNmbWTdEpWwOWNf99F/xHs/yyOqiGbnTRk1k
         DJO6CdDziEvuXQQ05BqL3bf98MpfLO0B/tESLZd4WE7Ecm3kamTzLeKA5c5uc4maQNeh
         R+w3RhY6XeF/pd1WldBjGJ160HXlAMOGGzeINelTMPL7i2E5z+JufupSbo9na+bCPaEe
         2gWJLu/eFT7QIyciLcbToTFO/JeHzVYR9ZmW7fApcDps81COpRo6AtS2ObyfFPwcvOi+
         kaZQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro5azjN0bGCPi4xsicfrerCcp00sk9MD1BuEScXVGQbVwfSdwa1oXm/ae+Y8L1nKd+jB7kePS456w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy688fm/Q35M5yuPJ6xCNTM0CLwQ/EC0etjh++Y/ld7qE8nCAzU
	yn4RY89jSL4aWLW5iMFBb0WsCer8wiOsHZZOPSUjZJ/UHzYtOnvlyqU=
X-Gm-Gg: AfdE7cmxHGh4GOUkQI6WJu/k/pX4b+GDtw4N322Hd4fBshIovPP4WysYQqkYFIkx916
	UfUf8CmlvaZKVrae4wC9gMH2KIkjce8/qz9pBc+f5EqFMqIuK6bFk5L9FAdmIbvLd/FTfztANf0
	c7f4AUZQUaaYTXgHtAuDB95+AntTJdfJQMXaRVxNh9fmMv9tFAX38HHdSi1wQu6Y05/tETq6LdY
	Skgupm+jFq1zmuWVsRVG4z+DjuxsWqV4OS0eLwicBVQZGxN5NrZTgQpU+LF7NwtlMV5NzWeR2bm
	70/AdQRQ2Bo5DCce/qkomSDbjZvOE05xzIsskLW+UlV7XvgBUg1DwnWEop1XMYLA5SqLZmBYgZ3
	PW0bfHB1pQj0DQHRAEee4h0SDW3AMSTjm+iMfsaSomDWQKAYM7qFh2Ds/u2XHjOtSJX9j93LaUn
	sOniZxwpDWtIgb66edZEF18UBlZaKmqV/XFJeM
X-Received: by 2002:a05:600c:4f84:b0:493:bea7:6b67 with SMTP id 5b1f17b1804b1-4954a405403mr15045025e9.3.1784286914828;
        Fri, 17 Jul 2026 04:15:14 -0700 (PDT)
Received: from localhost (3.red-80-39-57.staticip.rima-tde.net. [80.39.57.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2edbe4sm41390425e9.12.2026.07.17.04.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 04:15:14 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Arnaldo Viegas de Lima <arnaldo@viegasdelima.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH tip] multipath-tools: iet prio; update header comments and style
Date: Fri, 17 Jul 2026 13:15:11 +0200
Message-ID: <20260717111512.63662-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Update the header comment to accurately reflect that the device IP is now
obtained from udev's ID_PATH property.
Additionally, move the header comment block to the top of the file, remove
redundant empty comments, and convert style to c++.

Cc: Arnaldo Viegas de Lima <arnaldo@viegasdelima.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/prioritizers/iet.c | 65 +++++++++++++--------------------
 1 file changed, 26 insertions(+), 39 deletions(-)

diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index 10152402..a048732b 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -1,3 +1,26 @@
+// This prioritizer allows path selection based on target IP address
+//
+// (It's a bit of a misnomer since supports the client side [eg. open-iscsi]
+//  instead of just "iet".)
+//
+// Usage:
+//   prio      "iet"
+//   with either:
+//   prio_args "preferredip=<IP address>"
+//		assigns priority 20 (high) to the preferred IP and priority 10
+//		(low) to the rest.
+//   or
+//   prio_args "ippriorities=<IP|CIDR>:Prio,<IP|CIDR>:Prio,..."
+//		IP can be specified directly or in CIDR notation (IP/32)
+//		CIDR can use standard n.n.n.n/p format or any valid shorthand
+//		0.0.0.0/0 to set the "no match" priority (defaults to 10).
+//
+// Uses udev's ID_PATH property to find the IP of the device.
+// Matching follows network routing semantics (more specific CIDR match wins).
+//
+// by Olivier Lambert <lambert.olivier.gmail.com>
+// Extended "preferredip" added by Arnaldo Viegas de Lima <arnaldo.viegasdelima.com>
+
 #include "debug.h"
 #include "prio.h"
 #include "structs.h"
@@ -15,32 +38,6 @@
 #include <sys/types.h>
 #include <unistd.h>
 
-//
-// This prioritizer allows path selection based on target IP address
-//
-// (It's a bit of a misnomer since supports the client side [eg. open-iscsi]
-//  instead of just "iet".)
-//
-// Usage:
-//   prio      "iet"
-//   with either:
-//   prio_args "preferredip=<IP address>"
-//		assigns priority 20 (high) to the preferred IP and priority 10
-//(low) to the rest
-//   or
-//   prio_args "ippriorities=<IP|CIDR>:Prio,<IP|CIDR>:Prio,..."
-//		IP can be specified directly or in CIDR notation (IP/32)
-//   	CIDR can use standard n.n.n.n/p format or any valid shorthand
-//   	0.0.0.0/0 to set the "no match" priority (defaults to 10)
-//
-// Uses /dev/disk/by-path to find the IP of the device.
-// Matching follows network routing semantics (more specific match wins)
-//
-// by Olivier Lambert <lambert.olivier.gmail.com>
-// Extended "preferredip" added by Arnaldo Viegas de Lima
-// (arnaldo.viegasdelima.com)
-//
-
 #if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
 #define dc_log(prio, fmt, ...) condlog(prio, "%s " fmt, sysname, __VA_ARGS__)
 #else /* GCC extension */
@@ -50,7 +47,6 @@
 #define DEFAULT_PRIORITY 10
 #define DEFAULT_HIGH_PRIORITY 20
 
-//
 // Entry for the CIDR to priority list
 struct ipprio_entry {
 	uint32_t network;
@@ -59,7 +55,6 @@ struct ipprio_entry {
 	struct ipprio_entry *next;
 };
 
-//
 // name: find_regex
 // @param string: string you want to search into
 // @param regex: the pattern used
@@ -101,7 +96,6 @@ char *find_regex(const char *string, const char *regex)
 	return NULL;
 }
 
-//
 // name: prefix_to_mask
 // @param prefix: CIDR prefix (# of bits)
 // @return: corresponding network mask (defaults to 32 bits)
@@ -114,7 +108,6 @@ static uint32_t prefix_to_mask(int prefix)
 	return 0xffffffffU << (32 - prefix);
 }
 
-//
 // name: parse_cidr
 // @param s: string containing CIDR block or single IP
 // @return network: network as integer
@@ -149,7 +142,7 @@ static int parse_cidr(const char *s, uint32_t *network, uint32_t *mask)
 		prefix = (int)val;
 
 	} else {
-		/* no CIDR suffix -> exact host match */
+		// no CIDR suffix -> exact host match
 		prefix = 32;
 	}
 
@@ -179,7 +172,6 @@ static int parse_cidr(const char *s, uint32_t *network, uint32_t *mask)
 	return 0;
 }
 
-//
 // name: free_ipprio_list
 // @param list: pointer to list to free
 // @return: void
@@ -193,7 +185,6 @@ static void free_ipprio_list(struct ipprio_entry *list)
 	}
 }
 
-//
 // name: parse_ippriorities
 // @param args: full prio_args string
 // @return: 0 if ok -1 if not
@@ -223,8 +214,7 @@ static struct ipprio_entry *parse_ippriorities(const char *args)
 		int priority;
 		struct ipprio_entry *e;
 
-		/* A single IP without CIDR mask and priority attain backward compatibility
-     */
+		// A single IP without CIDR mask and priority attain backward compatibility
 		colon = strrchr(entry, ':');
 
 		if (!colon) {
@@ -237,7 +227,7 @@ static struct ipprio_entry *parse_ippriorities(const char *args)
 
 			cidr = entry;
 			priority = 20;
-			entry = NULL; /* consume the only entry */
+			entry = NULL; // consume the only entry
 		} else {
 			*colon = '\0';
 			cidr = entry;
@@ -291,7 +281,6 @@ static struct ipprio_entry *parse_ippriorities(const char *args)
 	return ipprio_list;
 }
 
-//
 // name: find_priority - lookup IP in list of CIDRs
 // @param ipstr: IP to lookup as a string
 // @param ipprio_list: list of CIDR blocks for the search
@@ -367,7 +356,6 @@ static int find_priority(const char *sysname, const char *ipstr,
 	return best_prio;
 }
 
-//
 // name: inet_prio
 // @param
 // @return prio
@@ -440,7 +428,6 @@ int iet_prio(struct udev_device *udev, char *args)
 	return prio;
 }
 
-//
 // Prioritizer entry point
 int getprio(struct path *pp, char *args)
 {
-- 
2.55.0

