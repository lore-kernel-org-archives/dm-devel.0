Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DCE5F874
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 19:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714676409; cv=none; b=NkEhy+83z2Hw5/uiXcwYqms7dVdyAXj7Uri1nf4tQg1ZReeEqYusPu7zkr9ek0l4nIu9XfIwq6s8gZNTgOH8tPYj71d3jxbRCI21gMq4VAx8+XSsIOHiY4EsXEBgap8Y6axbyzRbw8noFKojaA77exBVc5jaebW1P6yg3csHEEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714676409; c=relaxed/simple;
	bh=HtytLVTSyPxL4T9+4hmkv5MEl6jp79SGjnlbKkZWU3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RiAL7/l3LdyL6fvCftCa/GYG2wrq7hMEvBBbvLgPLNrJyRwNFZlbcqmXhSjuXltA3vFFIlzfagQl5xYEIVIiglXVY2Q/6B09DTu0ZwrVgx49p+aYYweyTGXCOASWYNdAtbCERBxTrTz7ttzR9+736bVkucSTf21sQ6A3rh1i4Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SS5q55FQ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SS5q55FQ"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a595c61553cso274447566b.1
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 12:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714676405; x=1715281205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EPV82MTwZ2t3iYeUHWS6JRN2jcwyGb9nNPm0aS0wIVA=;
        b=SS5q55FQxq/aq6wluq9REljwieo7BBS+8Jy5a+Cc72jnvHOPcEkEgPA+6S+5pVIiOl
         sjycZhTO6+SA/SzdNJEXwIH5DcVWY5gMWZlUk4GkGIvQzUKmPa6AfRYEyPL6b4g60VfL
         +wauY53uLgWXYH0ltqNUENVM3kypANr8a21VgVqc4VL3dGJrZ1DK6ZF7on6Pfnmho8Kx
         tF9yxAGNzfViXqgtiORANKMHxX6aAqiUqF+d6nkb6NbS3PDrixFRjRhaYcaXMLTvJ6+P
         76iX/vxji+l/Nj9/6jkhp6FgisksCddyaxzNmhqCTPYxpHSxEr34vVufoLbVJ3yahNFK
         Fceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714676405; x=1715281205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EPV82MTwZ2t3iYeUHWS6JRN2jcwyGb9nNPm0aS0wIVA=;
        b=ZQzQFjrT9KYBUE5Ujbi0ZSL0D4fRxu8UOB8BUvMRn+V2FFWCWeg6UQLIqLmFJ2hW1S
         r6Fz2iYio9kutemkcRwAOxfrfgRwEWrrRbBlmDFJXHBkDMHdEgRa5G01RSAvB67PDmLX
         Uc4KHHknoO1N3supAkUUZ1NxmjR3a9iUyWC5vp/Nh+blTLTHnOHxLviNlBdNt8qwmiGw
         dQbQcvun7vl6l6jxQ08HmgqxgKwfIClvIEjt5qsoy6lOANf5iug9HMjwGOG8wSwwPwP5
         1NkhQG5GH0aFsKqkZliNuysWBByJSKjRTUJ6ApZpeGEoIZhezlm8dKUDveeAxsObQOiJ
         eZOQ==
X-Gm-Message-State: AOJu0Yxh+f3s2LNJ58zJT0SlYfEZzD1NnKrOfPahZoH67/ROskU9MAK8
	iyNbFPEVeJN07r1avYB9lQYdpd5G2ArFihK+q2erQPY11sVpwsbf/wXgLeVoS+BSQN3rC7yNxm6
	4
X-Google-Smtp-Source: AGHT+IGNH3q0hWW/QvNoQyf2+TZy5crmX6c1nriZ0whod1LFJsnduANfiEUq4yDDGiHmqYcGjr8SmA==
X-Received: by 2002:a17:906:7fd2:b0:a51:d204:d69e with SMTP id r18-20020a1709067fd200b00a51d204d69emr267561ejs.7.1714676405217;
        Thu, 02 May 2024 12:00:05 -0700 (PDT)
Received: from localhost (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with UTF8SMTPSA id c17-20020a1709060fd100b00a526a992d82sm838717ejk.4.2024.05.02.12.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 12:00:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] libmultipath: use bitwise flags in devmapper API
Date: Thu,  2 May 2024 20:59:43 +0200
Message-ID: <20240502185946.31192-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series goes on top of Benjamin Marzinksi's late "multipath: fix hang
in flush_map_nopaths" series. It introduces no functional changes. It
just combines the multiple boolean arguments to _dm_flush_map() and
dm_simplecmd() into a flags variable. This reduces the number of
function arguments, but that's not the main intention. The symbolic
flags improve the readability of the code by making it obvious which
flags are passed to the respective functions in their callers.

Martin Wilck (3):
  libmultipath: use bitwise flags for map flushing API
  libmultipath: use bitwise flags for dm_simplecmd API
  libmultipath: add argument names to some prototypes

 libmultipath/devmapper.c | 94 ++++++++++++++++++----------------------
 libmultipath/devmapper.h | 33 +++++++++-----
 2 files changed, 62 insertions(+), 65 deletions(-)

-- 
2.44.0

