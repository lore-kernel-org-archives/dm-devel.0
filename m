Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E402510962
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252316; cv=none; b=A+mm+6oU7NlhUpUaB6/hDHDCeYt8Ht6aJqq27mTfcZrMqHUSMi+V7PaTxGxRDyykvygnyYPnHgOuHOCx72+BkUVo3DFOJupc0551Fm0t1vfY7PqvsT93pJXJUdNf1JzDVKeoLEloj/hA8qZHrsbGb7vEAO00vnxtBnjaX1ylG6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252316; c=relaxed/simple;
	bh=118idaGOIrb6OnyPQ4OJ5pvzS8mkCrleQrlanDcQULE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CSbzxjCqoiRjIRHfMfr/XCjseZED0OBEYHTFgHmtuZwgVOChtA7cdF1rFGsGP/47tgCSWn2bjNN9Tip8+3fVpfcc/iZjw57JD3EWKfkz6h0LQY/g5Mu0vxY+1n6Qe0lbMxcQrwl5gdj7I/i3LsL6UN2YjABP4j266HyKI32AthI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OtvHafJT; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OtvHafJT"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d23114b19dso14921561fa.3
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252312; x=1712857112; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KZGo395r0TT4rsl7mT8jylY8/h/XLQjeFpI67vMS4V8=;
        b=OtvHafJTTTmeZr8pF5q1oI7mMaYcYP8uHWg9hEXt97lgpbDVrWTrIwlv86NUD9IIR1
         H103v68qp6X98OGSY/muUSNGn8ul4Um4wppOpUjuGAGLAGzuMyr0l5ukWfRUAAcgNiIo
         1eA+cYEJ/dlAQpr2dBE657CAimvPo2cBNcaYtjxEpYlCpR4tfaFXevNpJH6EZj472WTz
         aM2cAOfI1Pl4p7lDSyRrpWzp24ch9TLw7XiYyO1mX3v6qn2J6OmkxiY1DfOqcL57bASM
         nQugGqYSq861P34yDk3N6SZht2pGd7zJr9yVt87jvO5freZ/w6bEqWoGiCcJJ6q4ijSk
         K0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252312; x=1712857112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZGo395r0TT4rsl7mT8jylY8/h/XLQjeFpI67vMS4V8=;
        b=a293UYZj5yubWcD1e3h+UgTyfGJMCvv6GZIKmgAXhInfzUsIvJ8ScJ9nbYO3BMxJ+d
         dJ0aIs+V0o8G1JC0JCYPIFTJkQcN52LuSOeOw8XYQhf1l/o7jm0Cy6GZw1Mx/oPcMf3e
         Q6yVrsJJvnSWzscNgRQESDSdZMvBGr2T/LARD/02DOidysbboELGuqzgNckAAuGMUtBk
         qTxm/N7CRoHLoSoKuuSp7yVDvoWWelKY2SHwTmI0hQIeyMFRO8FPfI+K0kErqDfTg7Q6
         JbPzyFKSwg7Xkj5Db83Z9YhjY0wQYweSZzfKK/Ah7c5Jf/TpnxzMLcK7l8jHTIMNu7eh
         R9ng==
X-Gm-Message-State: AOJu0YwY3PiB+tyl+s0ZonAInIt5/K0WX2SHIGtCdKUocwlB9D+TE+cj
	rtMQTkD50GK/E+ZLR1SxVAaMkDipczfcJMGT+3U/lgo4En69ppv1iKtmZKI0QYs=
X-Google-Smtp-Source: AGHT+IErUQyBG5jZHYthX7EDYo+1X/CmiGYqi5QZTmLpf5M3ORZiRTpm06ShgcidrzxFIiSNbNSvcw==
X-Received: by 2002:a2e:804f:0:b0:2d7:7db:8513 with SMTP id p15-20020a2e804f000000b002d707db8513mr2400103ljg.52.1712252310581;
        Thu, 04 Apr 2024 10:38:30 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id o34-20020a05600c512200b0041627ab1554sm3390509wms.22.2024.04.04.10.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:30 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/11] multipath udev rules changes for dm rules V3
Date: Thu,  4 Apr 2024 19:38:03 +0200
Message-ID: <20240404173814.3143-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set adapts the multipath rules to the pending changes
for device mapper rules that update DM_UDEV_RULES_VSN to 3, and
applies some additional clean-ups to the rules files.

Changes v1 -> v2:

All changes suggested by Benjamin Marzinski except the last one.

* multiple patches: check DM_UDEV_RULES_VSN agains "1|2" rather than "3".
* 01/11: this patch was wrong as discussed, dropped code changes and
  added some comments instead, lest I make the same mistake again.
* 02/11: fix label name in comment to match an existing label
* 04/11: added missing "\" at end of line

Comments welcome.

Martin Wilck (11):
  11-dm-mpath.rules: explain logic for device becoming ready while
    suspended
  11-dm-mpath.rules: don't import DM_NOSCAN from udev db
  11-dm-mpath.rules: don't import ID_FS_VERSION from udev db
  11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0 logic to 10-dm.rules
    update
  11-dm-mpath.rules: adapt coldplug event handling ro 10-dm.rules update
  11-dm-mpath.rules: don't import properties with new 13-dm-disk.rules
  11-dm-mpath.rules: replace DM_SUSPENDED by .DM_SUSPENDED
  11-dm-mpath.rules: replace DM_NOSCAN by .DM_NOSCAN
  11-dm-mpath.rules: simplify PATH_FAILED case
  11-dm-mpath.rules: make label names more intuitive
  kpartx.rules: ignore DM_SUSPENDED

 kpartx/kpartx.rules            |  2 +-
 multipath/11-dm-mpath.rules.in | 86 ++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 36 deletions(-)

-- 
2.44.0

