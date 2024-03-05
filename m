Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CED59B5C
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640374; cv=none; b=kcRGMps2F3lD72GfWPWWBuDVR3RJXFZxKJDcuHcgZ+rCavWRa8IXiXxPPxTBMc0GKQyYWyYLooH8KIHCfjUQmGuUMkzfH6lgyp3ZjL8fB3Lle1LDUF41eagYpWQjXoPc9vZkT3aiBNAOD95m5SeWuezlpf2a5Pe7rP9um16H66w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640374; c=relaxed/simple;
	bh=h87Ur7G/Y4jKEacfNU48rg1JaHg9qYFEuSMfZOYYFCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPrfmRW0SlTgxrWrB1082vShN8hgG67OrjvEMERygvut0xCEBrYa/WYxP0pB9OFr/oCYY6p2ZZRHOo2RYcw+AHlleZwzs49OsFlGebEXVlgFnL+6FmJpppDbCqSMPd+FaNLjTjiTFEzjwP+d94gs/BD3YzdWMg87Y9lQCmGyrp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D0+ycs73; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D0+ycs73"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5133d276cbaso4295578e87.2
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 04:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709640370; x=1710245170; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gra59CEdOdjH+awRNYyYaZsgl4i35ArARZaV4qrZPQ=;
        b=D0+ycs73BnXr77tG2Lc2I5nv0W5nbR4KdGwnUjg5pQp0DOQvNj7z4hzOI6epbqaKPt
         sbNBiweSz/34dF23vhsiweu0boODKBSVOh6WRRJF0GEWzGUW0Ci2wnsqgobIwtlxX9Ut
         biK4Bd9StrKIOTVkJUDMOTd172em1HgFQnWqIuhLZz48GBLG87QRYkDJKxlAWbUM1jLQ
         aiGt1ArtBfJ5e5bvbCliH3jKTq1kKplqqKHYj32WU7lSiseImsqyk9CdmT10Qq8t6KtC
         fzU5ZliEJft5TMrra0AUR2LgrOVcQEiKyLawp+KbY/Bs0kSL3To+d1ZS+8s41QgetEYT
         JDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709640370; x=1710245170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gra59CEdOdjH+awRNYyYaZsgl4i35ArARZaV4qrZPQ=;
        b=Nbm9KfxQ2QvDWfTTFdr2LQXLCub8CbQ5smLAhey8wOiLUvWIWiQzA6RpMSWg7qyKqs
         gYcFvVxUFgvPvemk5kS6yaKE0NGwGGxj1jRosgde4+tQthmmpoHY9sDhScT/JdDLIhh7
         1ZH5MegXlXPlKcpizQWWUD8HJGofN+uVr5ndQBzVTQoUIwSMNufMjLxbnHnPDZnllRsv
         AkEgQmETDu/Wvxw5txK5U0M3AO4H5UQxILzufZ8DMLekmhReQUsupRNR1bTbid/k5D78
         UFBXUPBKzRS0bcWrmnwTfkkzyz8TFFCH8r/d34QrlMZZI8cX48y/qlpNj60OuTajrBww
         CfMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZcDDXuoH9NYYb1oWJWtB4zv5yglAOpUkw6ZnxPh1w0nGMh9BZHV9t61niaWwpg4VMjIp4eRdjmR6zPdPFPjFmL8gr1lesT8A=
X-Gm-Message-State: AOJu0YzQuoqGbXTwHND5Fhcq0qOlk0fEZfJmtkjhe9WBzW8jWGivAeCA
	lnVtN5Y/m4u8ykmGAGN/DpZ6hF3muaoW0SaYCM54+7OUEMHW/Nd1XyIioYGlQiU=
X-Google-Smtp-Source: AGHT+IFfM6Y+4a08smpeFUGCYwp0YHIcoOOis/u6Mgr+qJsPQ/ZZiCWyKp8oubHyI86E8w3lR6VHjQ==
X-Received: by 2002:ac2:4c16:0:b0:513:26b5:139a with SMTP id t22-20020ac24c16000000b0051326b5139amr1256347lfq.23.1709640370267;
        Tue, 05 Mar 2024 04:06:10 -0800 (PST)
Received: from localhost ([2001:470:6d:10f7:9114:d168:fb53:9a37])
        by smtp.gmail.com with UTF8SMTPSA id iv16-20020a05600c549000b00412ea92f1b4sm2555533wmb.19.2024.03.05.04.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 04:06:10 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 3/7] 10-dm-rules: don't restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from db
Date: Tue,  5 Mar 2024 13:05:46 +0100
Message-ID: <20240305120550.11617-4-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240305120550.11617-1-mwilck@suse.com>
References: <20240305120550.11617-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We use DM_UDEV_DISABLE_OTHER_RULES_FLAG to tell upper non-DM layers
to keep their hands off the device in question, for any reason.
One possible reason is that the device is supended; another is that
the cookie carries the flag of the same name.

DM_SUSPENDED is not restored from the db, but evaluated anew for every
uevent. Therefore DM_UDEV_DISABLE_OTHER_RULES_FLAG shouldn't be
restored, either. Use a new variable DM_COOKIE_DISABLE_OTHER_RULES_FLAG
to save and restore the original value from the cookie.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/10-dm.rules.in | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
index f83fbec..e5cc10f 100644
--- a/udev/10-dm.rules.in
+++ b/udev/10-dm.rules.in
@@ -48,7 +48,14 @@ ACTION!="add|change", GOTO="dm_end"
 # These flags are encoded in DM_COOKIE variable that was introduced in
 # kernel version 2.6.31. Therefore, we can use this feature with
 # kernels >= 2.6.31 only. Cookie is not decoded for remove event.
-ENV{DM_COOKIE}=="?*", IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
+ENV{DM_COOKIE}!="?*", GOTO="dm_no_cookie"
+IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
+
+# Store the original flag from the cookie as DM_COOKIE_DISABLE_OTHER_RULES_FLAG
+# in the udev db. DM_UDEV_DISABLE_OTHER_RULES_FLAG will be or'd with other
+# conditions for use by upper, non-dm layers.
+ENV{DM_COOKIE_DISABLE_OTHER_RULES_FLAG}="%E{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
+LABEL="dm_no_cookie"
 
 # There is no cookie set nor any flags encoded in events not originating
 # in libdevmapper so we need to detect this and try to behave correctly.
@@ -58,12 +65,13 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", ENV{DM_ACTIVATION}="1", GOTO="dm_flags_do
 IMPORT{db}="DM_UDEV_DISABLE_DM_RULES_FLAG"
 IMPORT{db}="DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG"
 IMPORT{db}="DM_UDEV_DISABLE_DISK_RULES_FLAG"
-IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG"
+IMPORT{db}="DM_COOKIE_DISABLE_OTHER_RULES_FLAG"
 IMPORT{db}="DM_UDEV_LOW_PRIORITY_FLAG"
 IMPORT{db}="DM_UDEV_DISABLE_LIBRARY_FALLBACK_FLAG"
 IMPORT{db}="DM_UDEV_PRIMARY_SOURCE_FLAG"
 IMPORT{db}="DM_UDEV_FLAG7"
 IMPORT{db}="DM_UDEV_RULES_VSN"
+ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="%E{DM_COOKIE_DISABLE_OTHER_RULES_FLAG}"
 LABEL="dm_flags_done"
 
 # If DISK_RO is set, it's an uevent that changes the ro attribute of the device.
-- 
2.43.2

