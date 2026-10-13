Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D0540F73A
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903327; cv=none; b=fusq68wmM+Y+3xegeY6fHr/9a6uuRSIolvGrkedw2w8u0tl9mkEKcah+3mY7kj76q8QpSGCGFGHnLcd0JW1ni4FvEqemPVntAffaYM1CLLM2bRcB5T6/2UQART8QkqRp6cb8bmF5OFHsUQqFtz6ZBibstrYwmlqxw63DU4QCn7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903327; c=relaxed/simple;
	bh=gjNX/CWNpI50rVnvxvJfgkNoOMgqeJJz8BT5hbq7fLE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oV/S2meAXet1NRXvHb0dquSYwCaMO+j2y5kndmPGfjOJ0swq2ZE1u8KcVXAbYSBEDrXQhsDcX95/HHtTMIcMv0DvyzkSA+LdeLFYCb0haDXg7B55pt3AxRUzxoa15HQXQvCvTKBMJI6A04Ixyrv23o3a5F4GWPyg81a2XH8eYx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AxFyNoQ0; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxFyNoQ0"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so4179825a12.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 07:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791903325; x=1792508125; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jCzRjuNiQYuIlt1ayBRVrkI/N8zFISckqW/w4VRTdfQ=;
        b=AxFyNoQ0rqcoB8yPRwetgjk/0dQ4bIyFOjdND/j1pBDkHCnbJCq3Y1hC39gu4LsDdW
         PrFJi7p+nuRVb8AK4CWzdiiRHcuqa16+hl80nOxdpxlyBa5RXRKt+4CEt/I8/gZz5Gr4
         jDCfcwmp7hgH1OeMpygtHLg8T0RTLj5TrmBSkEERju8j8hxMraojDPH+vlzIFdmjmRsa
         EeW9sX0GtB6sofwfv9MNJhkyovODw2IKX2f3QtqlGtBrlnLA4hiVFPPVtMlHnasRbi8T
         J98AGjKcBR7J4oAXwOWlSmytBHOxjrSjt8H+HgIJAywo1gZtt5LFkshq8jIpIH82/45p
         jRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791903325; x=1792508125;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jCzRjuNiQYuIlt1ayBRVrkI/N8zFISckqW/w4VRTdfQ=;
        b=eWNwwSOiV8HAiGeqIrTAmBgjbCjr6SykmZwpkSeENWMCTilDEppkaMECIkYF4bcE03
         qxIwRYD9No5vbqB1VmQue/nFqQsD5I7uOeVWPB2gbDfpLaUf9PFNPs5TZk2g4voIg4Do
         vCnQwEeilj+rOIf7hS3cyPnlNqV9Db/XRm1LTyEDHFkUtYVETaSp9O2/KThNh6aiBwzY
         tXRLwkRtovqSuV1PaiwfEY5GYTnnncpktpd9JPP9j0++tL1wUlSAhgl6krLhs344dFTg
         OeFbN9+l9tCRlwY6NdiJuIi3oS8iokjIG1L55YR8TdyXpyPa9AMhrkm3OyAf5E8bOId5
         giqg==
X-Gm-Message-State: AFq9FYLrMN/rft4BJUCkU2dHJ7uSxoJcKw3Ze00se44thWGZ9qceHfii
	nhXoqlsVwQM2dlXm0ocxNvz0u8I/LArbobfAEGsnKMGvXmYiO18D5e8+PxpdW7An
X-Gm-Gg: AYBFou3H5I/umcIWELIbWBs+vNlxP+LUZ1EgkInP4DUPh/Uq2pjnPripF2fRwbBFN8P
	/EKVJ8lbRQJcq8l2yIHZU2sslSjD+4zy6PXIu2Mef/3VQDaMbSCUczNs9qScitMMgL1ivUweL/3
	Nj5M2Di697qJju1JXN/zEodFqWZRq1MHdV19beYW0jQtOa7NlgPIb9JV1ccN/mpJraTFYOi250F
	Yb6IwSByxh7bn9YY0JLXxVPCqHd+JKCDIl4VtUWFLERbJlIBb4ZF9QpRWUDhnEsYGEOzxoK1F+X
	/Pzf/T0crZtEksGOh/z4nDlK7TBKWrFt7IwCIpCxBzce/ojGG3iLOqnOwXFIsp1eg/I3M94Nh54
	cu4TkSh9dMPh2VRB1/xPGw8qvFctimmVWlzDPw5CZ+bZQQYBfOXSAg4orCT0MEPvAnMIq71X5Eg
	0OTGA7ElNzyffhbVlHMDzMUcWw7xuyiThEUDBwwHB9IfNGasS6dALFjPjO/n0agvdOKKBIm8PHq
	yfCI9zq9k811gIf9IJ3vwXf8myRdbWEkjosjihWncnqf8U=
X-Received: by 2002:a05:6402:a0d8:b0:6b1:d2d6:4013 with SMTP id 4fb4d7f45d1cf-6b1d2d656aamr3347810a12.17.1791903324468;
        Tue, 13 Oct 2026 07:55:24 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b179e03428sm6169161a12.37.2026.10.13.07.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:55:24 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/4] dm zoned: fix idle reclaim problems
Date: Tue, 13 Oct 2026 16:55:18 +0200
Message-ID: <20261013145522.17499-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas,

I noticed too late that v3 of this series is already in dm-7.4 and
for-next (24646f6ed3, 2cca719c63, 5829edd027), so v4 crossed with it.
This v5 is v4 plus one more fix; if you prefer to keep v3, I can send
the v4 changes and patch 4 as incremental patches on top of dm-7.4
instead - please tell me which you want.

Patch 4 is new. While measuring an idle pool I found that an idle
target whose random (and cache) zones are all free never stops running
its reclaim work: since 90a9b8693f1b ("dm zoned: reclaim random zones
when idle"), dmz_should_reclaim() treats "idle" plus a non-zero total
number of random zones as "reclaim now", dmz_do_reclaim() finds no
candidate and returns -EBUSY, dmz_check_dev() checks every device for
media events (a TEST UNIT READY on SCSI disks), and the work is requeued
with no delay. In mainline the loop can end when a pass finishes while
the target is busy with enough free zones; with patch 3 the idle poll
stays armed, so the loop recurs whenever the target becomes idle.

Measured on 7.3-rc7 with three emulated host-managed members of an md
RAID5 (idle, 30 s average):

  stock dm-zoned        181,195 SCSI commands/s   32 % kernel CPU
  v4 (patches 1-3)      187,707 SCSI commands/s   31 % kernel CPU
  v5 (patches 1-4)            0 SCSI commands/s    0 % kernel CPU

With patch 4, the random zones filled by a 2 GiB write burst are still
reclaimed once the target is idle, and on three 27 TB host-managed
drives (7.2.10 with these patches) an idle pool went from about 155,000
TEST UNIT READY commands per second per drive to none.

Changes since v4:
 - new patch 4 (above)
 - patch 3: Reviewed-by from Damien Le Moal
 - patches 1-3 otherwise unchanged

Kyrylo Biryuk (4):
  dm zoned: back off when reclaim finds no destination zone
  dm zoned: do not reclaim a random zone into another random zone
  dm zoned: keep polling for idle reclaim after a reclaim pass
  dm zoned: do not busy-loop idle reclaim when no zone needs reclaim

 drivers/md/dm-zoned-reclaim.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)
