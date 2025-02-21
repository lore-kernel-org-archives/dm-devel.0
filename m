Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A16B200114
	for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 20:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740170483; cv=none; b=MW866GyqGtGEs6wso2awMfBaFV4KWXF4VYTZnxTcWd257b4IeXcHtjZlscwwS3tJQJ1pmzc/GCo9jxfgZ0x7HO3uVCWLJQCijYVs1ah/VvaMX26gbSIIMEJgP7b+hgUM7WaQAU53B1lLc3vSrOSWvClOfX0KKd2kBcHMvI7X77M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740170483; c=relaxed/simple;
	bh=MFAWGGU7GmZ9x6twU3l+A+tqjjazFVdo4aSOJEGK8sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TgZFsQEAd0Uxz6xK2M1FhJBJQLQva+v5T9e+mmroeve9C9Y8TvPbdNWXWcqGGc99P0EWzwtlklLQq33Bux/FyEOWikT//5A6S1thwcrCsD9cpjUr1wmaUxLaZx8AF/5HiNR5mC02wv1w0Vso1lcBNBpGRTmKUqXpw4/LaKiqdWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fat2FoI+; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fat2FoI+"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e05780509dso3629260a12.2
        for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 12:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740170478; x=1740775278; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n2Q8hnSaH1rgXhVw+fSRuUSRgVRGzVzTgl8E3QJ7l6o=;
        b=fat2FoI+4wwIZzDjSV3ky+0lg8AUPriNcRcY0fYfbdEqiCtOnnHBPnsY94KKGlfqIQ
         kMI93OeS7Re/NM6JVlfHldCy3JGf5bzNtnyY+IsCw0+vqiYe1hafn8SPwdqs258iaZ/U
         YcMBke/5z0RnyT3vvCoF/dahnye1juRjeut0nmFQnQcEZbYrfmENVNDor4HexsXKMKwX
         0kIZp4hpBWuNZyP6MdIZUT7KEsfgTtq47Zi9z6RiNkqO3yfLManV2cMoRi3PDltsAwhs
         5gYhmiJTUAvkscv02chfD//RRGb0CkM8wbr9uFXjVuAa9a9wGygeAQ/T3Smn1F/PlaXm
         YKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740170478; x=1740775278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2Q8hnSaH1rgXhVw+fSRuUSRgVRGzVzTgl8E3QJ7l6o=;
        b=cC3uf25um96EskQvDVf/pNo5yyz1SJpJFyOkv22/jXIWeH/1r7MdCMU5WiBjX+Lsze
         ziqOvQrQ7BsANx9p466IK1lPrckNfzaf5vsebtVRlyZMKFcQUCLKVlqOwDszJAF1/WnD
         wIpzb/2cjxFYkeKF7MDEH6T8AH+ioAc8CK5Waw1neLUVzUeaTAs2Os7KjRnCtGeIVDKO
         bz3fScFoFk8f5/wUaAiVAIcjWYvg/b73uccCAABwP8wr8Vabe9KnoSwPBAAAFHou4Ty2
         YZXTBrDDqYlgzswCJnaoRs+E8ch1xCIrHP7sGJpTXwZMdJwJ1m/00RPZSo5wovOfxCaT
         r/dQ==
X-Gm-Message-State: AOJu0YyK+iM+N2zyykh4I12ernZv2bB3+IF9aFESyrjTiqrqAd4HoXcL
	4bHu7BKRmXIyQGJ9L5rp87c/GdDFnN2h0MZ7tZFFqAlC43UfnP8ts3wZPTi3FnA=
X-Gm-Gg: ASbGnctJF9NOEO1wuyyHo2s9QYqt1iZ31UKTov557xE/IFnztW1CyTz7RMDb2usQRU9
	hWlRcNapG+99RQezMXEXdW/Z8JxL+shdQ6qqh5hlKbDyjqEFQj/5cyluaBze8uL/1LP752SfK4I
	FW8xzh/0bXvzN4sCSEArRFR63Ompyo8lQBihyDB/8ADTGeIXAAv8tV0YlJ+ndNv0RwlpEypXZf3
	evriE5ddgT/3DTsl9ZOGoK4+A5AliPbzQsdahjE4jFdGJdw9YxPilZOSNZ9RSt7kDxiCaUaHQgg
	CuURZSCB9/EIRXqx+yGliW+dSe771OVJN4pl4Vi7vB9HA9w9c3y1DLTbj5xoeTRlI3uFRGWziT9
	5BCesWSNPnMwi
X-Google-Smtp-Source: AGHT+IGfOs4j8lI++aU8lu+q3FuEyis0rdvDdM90FGjxp+JTJj6s6oqbmqCpKdkvF8jTn/V1F4ZMIw==
X-Received: by 2002:a17:907:2d06:b0:ab7:d7fd:6250 with SMTP id a640c23a62f3a-abc09c1113amr419873066b.43.1740170478249;
        Fri, 21 Feb 2025 12:41:18 -0800 (PST)
Received: from localhost (p200300de374627004d16a5f447740583.dip0.t-ipconnect.de. [2003:de:3746:2700:4d16:a5f4:4774:583])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abbb73a108bsm803535066b.141.2025.02.21.12.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 12:41:17 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 00/10] multipath-tools: provide pathname and abstract sockets
Date: Fri, 21 Feb 2025 21:41:06 +0100
Message-ID: <20250221204108.70631-1-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set is an attempt to fix https://github.com/opensvc/multipath-tools/issues/111

Changes v3 -> v4:

- 08/10: retry independently of error condition (Ben Marzinski)
- 08/10: add a const qualifier
- 09/10: adapt to 08/10

Changes v2 -> v3:

Many, as a result of further discussions on GitHub. multipathd will now open
both the abstract socket and the pathname socket /run/multipathd.socket by
default, and client programs will try both sockets before giving up.  The
"use_regular_socket=1" build parameter is not necessary any more.

Note that we'd switched from the regular socket "/var/run/multipath.sock" to
an abstract socket in bb89077 ("multipathd: switch to abstract sockets for CLI
commands") in multipath-tools 0.5.0. The rationale back then was that creating
a pathname socket might fail if the directory structure isn't set up yet. As
we now create both, and fail only if neither could be created, and as there is
the early /run directory on modern systems, this argument shouldn't apply to
this patch set. The name of the socket has been changed in order to indicate
that the new approach is different from the old one.

Changes v1 -> v2:

- Introduced the mpath_fill_sockaddr() helper to cleanup struct sockaddr_un handling,
in response to comments from Ben Marzinski on GitHub.
- Fixed double remove of multipathd.socket during "make clean" (Ben).

Martin Wilck (10):
  multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
  multipath-tools: add helper mpath_fill_sockaddr__()
  libmpathutil: add support for Unix pathname sockets
  libmpathutil: move systemd_listen_fds() support into multipathd
  multipathd: make uxsock_listen() take a pointer to fd
  multipathd: allow receiving two socket fds from systemd
  multipathd: listen on pathname and abstract socket by default
  libmpathcmd: try both abstract and pathname sockets
  libmpathcmd: honor MULTIPATH_SOCKET_NAME environment variable
  multipathd: honor MULTIPATH_SOCKET_NAME environment variable

 .gitignore                                    |  1 +
 Makefile.inc                                  | 10 +++-
 create-config.mk                              |  1 +
 libmpathcmd/mpath_cmd.c                       | 25 ++++++----
 libmpathcmd/mpath_cmd.h                       |  1 -
 libmpathcmd/mpath_fill_sockaddr.c             | 32 +++++++++++++
 libmpathutil/uxsock.c                         | 41 +++++++---------
 libmultipath/defaults.h                       |  1 -
 multipathd/Makefile                           |  4 +-
 multipathd/main.c                             | 48 +++++++++++++++++--
 ...multipathd.socket => multipathd.socket.in} |  3 +-
 multipathd/uxlsnr.c                           | 34 +++++++++----
 multipathd/uxlsnr.h                           |  3 +-
 13 files changed, 149 insertions(+), 55 deletions(-)
 create mode 100644 libmpathcmd/mpath_fill_sockaddr.c
 rename multipathd/{multipathd.socket => multipathd.socket.in} (84%)

-- 
2.48.1

