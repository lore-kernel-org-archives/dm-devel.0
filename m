Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD42FE33
	for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731595359; cv=none; b=fq14S5Nlx/IL60+YVmXAoSyjPdTbagJvS+rEYjQ4bI63BLgWUrMn5NTHhd7UebHYq6MAd1zaqG/t5wQSWUUFi12FSis//0U+a0eyvxgD2koCZsecsvac0ToIH2S5rOXkaD2fflkUOWhXufMBZP7FrEoDW6+eWSd9BtqnWyi3Pnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731595359; c=relaxed/simple;
	bh=4V84hF4cXAq0SVSxfm+S0RcFEgG06qiC6UAucYPU9Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3v+gK8MdKXvVuu+1RWRKMTXULySZ4FHbQBf0eV1WRMHDuwCIRqFj14Q83f+0fTqJOJtpDSGxIUXeBDaLUrIncFigjwfdte6OL6/8fZgHtfOmpHGBXi9oVQLNj2Kr5qc0N+/3C20PV/baFuvRGVj/1dSoKGjZ1sTT2irw26Ttvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DzWvLwHw; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DzWvLwHw"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d49a7207cso437914f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 06:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731595356; x=1732200156; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//W1moCu3ztz2I5tsrS0lgogDns7i7a2WO0QN7e4iMg=;
        b=DzWvLwHwjbEqiQZv5KLIELryNgyZ5vfPjLOVZxG0L4zjEFMUBj++7lFETCSmud3tLV
         5dKJ3gzEAkWHdTe0FyW2MbPIAQSPCAUQQGImuihF2xhQ+FDqm4a2r5TihL8ziYK2hmY1
         jbdz4ZO1ND52gs143B9yOoTMHOZz68PG4r42qzSEYuX2oW5LOJrCYbC+kBWXC+rq0iYe
         /4AhZoqhsN2D1lahMRY1C3ikgciJ42lG7SlmU8F1SMCZhGwxFW+S+9vVxomqirrG4gyp
         AuIy0bhe/VhoSCyQDnCv6/R0YTdcng/E/J9X/w3zuDMBtATY2oW6ymizFtukYPrRqJgK
         lsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731595356; x=1732200156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//W1moCu3ztz2I5tsrS0lgogDns7i7a2WO0QN7e4iMg=;
        b=Kb0Ry+ezPgdSwm7SxINW6/3FPUXA8THML2wNsE6/krJNxPr2eYw8h5jXezfpz8vrRJ
         jB+Jg7uZs7t6Fa0q8/aBOtk6j7Uj9NgsXwBxXlyxjHyGxjBOH2RsE/lP062iaDlJMU8X
         rH6QFrWELnmKmjvw9omyEcUbCDSVxgHpVu75Z+truZNzsgOLfYqFz0VIHeLT7wI4Y6Jf
         ttrT9tzB86y71OYQVFQwiMVvbOaMgOFcrCPh7MgX+Gtwt5HxJ2Ug1yrVuMQLqdwQuzcS
         hIwoWmXApn0kXMwyCmnU37TeTdtrZdtywCphu/i8R9/+3kPX7XhDCEC3kc7B/LHxFMsL
         hiQw==
X-Forwarded-Encrypted: i=1; AJvYcCVFnSGFUxcHmkmNCjUEkfrqvRzYQ2aXbP5uSMb54NZht7arYCQMlTXH/jI+Dt5rRPMkhFk3gwM2Cw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKtnlthyaiH4LwKnZDcqBLv8l0iLGUGpi5/D8d4HBodjaCko8j
	IFF1NcE8pSh+QE3o/0jSuJmzqWX9N7tcD3vC3JSUVHK9gO8++a3kghYMwnCe71o=
X-Google-Smtp-Source: AGHT+IFObBlnAVj/lw9nISGdN0wDV/odCA1crqWNK7JXWw3KJN2SXQS1Q70dNwSlDFINb3ZqW6xHgA==
X-Received: by 2002:a05:6000:4106:b0:382:1854:c8bf with SMTP id ffacd0b85a97d-3821854c938mr1842394f8f.12.1731595355550;
        Thu, 14 Nov 2024 06:42:35 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3821adbe7dfsm1629981f8f.56.2024.11.14.06.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 06:42:35 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/3] libmultipath: don't print error message if WATCHDOG_USEC is 0
Date: Thu, 14 Nov 2024 15:42:22 +0100
Message-ID: <20241114144224.248606-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114144224.248606-1-mwilck@suse.com>
References: <20241114144224.248606-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WATCHDOG_USEC may be set to 0, which means that the watchdog
is disabled in systemd.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 0e3a5cc..226ddec 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -865,6 +865,9 @@ static void set_max_checkint_from_watchdog(struct config *conf)
 	unsigned long checkint;
 
 	if (envp && sscanf(envp, "%lu", &checkint) == 1) {
+		if (checkint == 0)
+			/* watchdog disabled */
+			return;
 		/* Value is in microseconds */
 		checkint /= 1000000;
 		if (checkint < 1 || checkint > UINT_MAX) {
-- 
2.47.0

