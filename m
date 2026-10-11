Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451F931E82E
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791735456; cv=none; b=mNogV5ZLvxQHuhFnINm3ddjjNGUq0Erzi1ephGUPGPHWj/8yvHzXssh0ikd9p0HM5aylwpjpXEJ7TdCJH+LWPAjDrP1BIiPjgV/w8N9/jkDp/JUaltVeOZbVAB+2Zm/R5jThWs311NUdRkc6QqbSLa9BaFbwOa3J3p9EuDnt6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791735456; c=relaxed/simple;
	bh=mYHP1i0YB7oOLKfMJTS+JLnqxINc8T4sPhpgL6ZDkeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJBPytTnCll/NaGpEnbxHzyworcLz0RmyVPb2EQz/co0dH4ezetDtkkq/WDSUIEIJwaLo4JkmhhcF2Qr8iNmwA00ytcmbq4yjXhMaRHLGbJE4XKkPRoq2mbjbL2L68p+qCyGqVBJVQyzDERHgyMaEu4BpRkW3zg311uSLXjfxeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bB9a3xkc; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bB9a3xkc"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2e4df2e26fso156665166b.2
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 09:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791735453; x=1792340253; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mYHP1i0YB7oOLKfMJTS+JLnqxINc8T4sPhpgL6ZDkeQ=;
        b=bB9a3xkc1kVAmf51jWNeF1hWCvOBnwXg8BChwXLSJuG6PN2k+rCvZLpMWxFgZq8YEJ
         WKJUxo5QnRaKfTX0CRaBv3VdUoq33iFX6/53Nm+pBNxXMyqoS2uQdG+S8xUGyy4pWZnk
         1h12Re0YZ3K/r1QOnObpGfg9InMXel0Itjr1FjSOuAlpyAVIrtJthP0X/b51CfLEweez
         s2gsyAbsOqYtnOMJJHfZ+Wk6l0GJYa9qFJdSsndYsCtmwAN1V49k2HQ9xPZUsilH1W95
         EZ1rVzqVtRLgSIXkpzOtbdoAsS8kJpOVfiI0KPKWE83ihdI1yDoqCk87Skx2SrFapo09
         Gbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791735453; x=1792340253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mYHP1i0YB7oOLKfMJTS+JLnqxINc8T4sPhpgL6ZDkeQ=;
        b=PG0H+70Ln9ZhVxIyuaBT4he2DpACF3Br41JLnQCXM2+xENuBkHkfaMYeoV2198qnAv
         +cDJC2NiBPY3kiiMPCbN+0ZsbRFAJaVyD94+D1kuk4zHVG4p/AYEb1agOA0JcNdnlgPT
         2jWWG5PE8MNOpyZeXkkjZ4fEsca/8Vk7MNIWNXhz0EftZVIUeAXVKu2okWBLn4RIuPZZ
         pEPEfQqiW6MIuEuQs6Dk6WchwcOELGDVoNuEw0fIgs/acYRFm7H4590CtYKehVbBNxCZ
         h8e5mm+faV3BW/YAmg2BAj2L2dZFXwlqPBWX/W2RmhaPzjnzx1fWdzXpLuahqtB1Lfh7
         mNPQ==
X-Gm-Message-State: AFq9FYIRrcQ2jRyRGBWq/BJPwva62TdMRzD6F2eW1T0h3lc8ui5xu0HA
	nNhY7XM3kRo3H7wNuEvHDWAwHCtE1T4lZgi5/1zIsjRkVn6V4teEdpxA
X-Gm-Gg: AYBFou1Tyc7ZoHhmoKmT5i/1UUsHfmxlDo9Ob/WAREYvnqZ9OVXjN2sMSLZ72bCLO4r
	1irn8I6+8wdjZ3mKfgK73GeBEz6DM68ehaJGkuX34MJ/Tr4+OGS6n865jiGcaCPQ0NMSsUrhDgT
	Jd9a1i5Lgf4N7OlPEhw4R6DyzsoP78hemuwscucunj3GMuCubx5MIbRDIlPtjXE34GG2MExBpco
	YfgshXtojyehCpJpl8+tVC95KSd0hdyjuq6UFjB46WTsvqcvQ5Zsd+rDgnrz4DF6mtsFrVPX+3B
	8JFeRdU5pqWtJ2tlsyv2BlskkwgCWsYG2izSD4sTfef8Gr2KfH9CS+0KoIhIqGTwW0mkRTHiyL+
	q0sfMBPsMbedOw+0XFtLuvMLUXg4rJq53QDmyIb1CwkRmnI85t6QiYORc7+YGU5EzY9qzZAvS06
	1CgZwTw12ogjWMz29tuU+axU3N9ydP5Xb88Uw4ZIBI+7aT+i3vr50KNUPaMWMmSrPLiNTjJN7uS
	V3s1X+d5gDHFetMtpPggzhPghgfVv2cbO0w5o7/ZVl/wYgWxQ==
X-Received: by 2002:a17:906:dc8c:b0:c29:555e:bf2 with SMTP id a640c23a62f3a-c31a9fe3cf5mr692093366b.41.1791735453256;
        Sun, 11 Oct 2026 09:17:33 -0700 (PDT)
Received: from localhost.localdomain (host-188-122-3-146.finemedia.com.pl. [188.122.3.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a3805bsm373462766b.16.2026.10.11.09.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 09:17:32 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dlemoal@kernel.org
Cc: dm-devel@lists.linux.dev,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dm zoned: back off when reclaim finds no destination zone
Date: Sun, 11 Oct 2026 18:17:31 +0200
Message-ID: <20261011161731.394-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <8d1ee370-2785-438d-9c5b-8363584a23aa@kernel.org>
References: <8d1ee370-2785-438d-9c5b-8363584a23aa@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Damien Le Moal wrote:
> Patch looks OK, but is "ilofspeed" your full name?

illofspeed is not my legal name, but it is the name I use for all my
public work (GitHub and this series), and I understood
Documentation/process/submitting-patches.rst ("using a known identity")
to allow that. If you need a legal name in the Signed-off-by, please let
me know and I will resend.

(Resent as plain text: my first reply had an HTML part and did not reach
the lists.)

illofspeed
