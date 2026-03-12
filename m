Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A9F1FB1
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 00:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773274609; cv=none; b=SqmJuC/ufMsRPECaDYabLFSg1HkXyULdeqITaGUSQynFQaZIqnk8S6GksJJtrDCEQ4W34ae+DAlSDSLWAdk39+u3nUc5ZVnrdPFhya79EomV7imbSvKsWugSX02mzaQD1GlqLWd59uKjISP9StvwxQtla4kyk3ydLvHZ38wReoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773274609; c=relaxed/simple;
	bh=H46vsjcFWjfyrcuc0NONDq7O9n1rO+xfd7TMEFF/Kzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rDhKYRdmZcv6Q9AeandjSQPtQhvgtwdfAvDArTThj1vuLHKgsCb3p/t52K3/qFITIxsOnOel025RP6sXKugDTFlCoQe5TLhiuLgUrPUsTRawAjGlv8STdatscvxsgz06RK3WY1l0x0CYHIRHWtqHOdw0BrMk1Q4V/VKby9m80aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OSJAF1uQ; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OSJAF1uQ"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2be0711f493so930143eec.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 17:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773274607; x=1773879407; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=08jq9kN+mcXQq6zTMIpGhphJoefCrqfLZOcQnYPyBec=;
        b=OSJAF1uQ22vnugAfwYyXBrUNE1zhkVRubko67RcrvCDguALhW2HV2I1DdrvFnCkqGS
         WgrDmshFSFaMYP70l5YH8EoKyiOCgaRqozbO29tuQQVJurLjZ9t3v/CVWKEqxIXedw1P
         +f6FQa3aoS5SEOH5VgLbaYZz5/h4jZiyJJtdRFKhHrowgkgsjoJW5HXnGHM1A/KiNsnk
         h/gSSLlx5Turpz0ZazNJwBiDpdtT4HGk+sVXU8fzhuB+SJfZeB/EmQdECjDVkxETjVdo
         16w1Gnv+zy0Pylwl1B4adOmAG1rRyFUZXTxohbmwqussapl7RsmxHUa4z9IoFtV03uSY
         k0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773274607; x=1773879407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=08jq9kN+mcXQq6zTMIpGhphJoefCrqfLZOcQnYPyBec=;
        b=tPMG9PXbzBfIz0HF/OoIyPz8lrer7yoNtj/l3h7u2v6atccOmTQpmWj1kgsRFs7qWo
         PndwVG+vK0f53zOnE1rFWGhPZgbqtx5pCYHlu98aVjwtHy6ZWr3nMINjR/cebg2/Vr/r
         2cJY+3gf8MPDeH3rlB6rUYaEJ7WODgQGZ70/zycPx84ekp7NBKNEBL/nLOkQgwn9EGF8
         bmVTL8zRy2ycAwTRJEnBu3B712I8ZfP8HXnl7ILhGLRreEqdxEwJmjtpZeQJwp7seS0x
         J10XvCKXk5Y44Bl2L1q6FaSKgpPQ3hsA46O1UNmncjq7CR7o/NQ0LIjS1yYjiaKksAHZ
         YpIA==
X-Forwarded-Encrypted: i=1; AJvYcCVtBZiPyG00/ST6xgUNcp66PVedYTjPARkcUMHNZJfkFW965NNIlVOGVFvw4cP4Hx2bOuQM39PKXA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyN5R69DVMTCgszTuFIeCQ8FgO1Yn71iN3ezFXmNIvfP5zz+Nd4
	WSlRRDSlnKUvRHvcktWNds0yhOrcQSOJ93DlegYkM0o8WoWFeg937hTBsjXD9CYb7JU=
X-Gm-Gg: ATEYQzyHrvXb0MViY0g8PP0hw5J6cGyZvEdLbV9KHvSKYtxmCAHFjouI3Xr+Wzo51iO
	BKs/12CFIAuTsh3z/oxcT6eFw/OTHlUI9j10evbhSj2wJ3N4AMeUXNFR6xIAJWDZaxR263mvoVm
	WnaI9H7QpnoRTBb8PeRYXoLlcbAKNPsoxAxJ0zjK6f3jGxVtmFkCPNKVoASCtrslOcedt4Kp4cK
	TztkgUTjDQ0B9TymBfBu3YeyuCdiGRZhzYiVXSbrAQcq0Ob9vu4tUSGwj3W1HW602RofIKWpwB5
	vEFK0bXGyFKGSsOpfOo3B4QLmAvsK+ILCj/CT1r8vO/3ObFTo2QasWwYQ0DgHFM/vC/MCieuCyt
	0rDOlAPwhAT2oaHnvr9QKc/x6LCLTCxK45XZjt5bHMTRiJ/Zv961cuCqd8xP17Nj6pk5fk2K/aF
	UcqMctjs+DWyCPkcujKtgEXD4sQRgNukSFh3Udxk/cqkMBBrqJRtThS4ym8Id3v5VwEMX8sib6o
	GSLZUqcsONLlpWN9zraWbKJGfB1BSiZPshBdaMDaqVKi8nKYg6jBWahQnVigLcoiw==
X-Received: by 2002:a05:7300:a506:b0:2b6:bb18:c70a with SMTP id 5a478bee46e88-2be9447abfbmr670028eec.15.1773274606375;
        Wed, 11 Mar 2026 17:16:46 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be8aa73ba6sm4375169eec.25.2026.03.11.17.16.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Mar 2026 17:16:45 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: bmarzins@redhat.com,
	mwilck@suse.com,
	dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH 0/1] checkers: add alua path checker
Date: Wed, 11 Mar 2026 17:16:36 -0700
Message-ID: <20260312001642.53321-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For ALUA-capable storage arrays, multipath-tools currently uses TUR
(Test Unit Ready) as the default path checker while a separate
prioritizer determines ALUA state. When sysfs provides ALUA state
(the common case), no RTPG command is needed for priority. However,
if sysfs is unavailable or detect_prio is off, the prioritizer issues
RTPG, resulting in two SCSI commands per path check cycle: TUR + RTPG.

This patch introduces an 'alua' path checker that uses RTPG as the path
check command, providing two benefits:

1. For configurations where RTPG is needed for priority, this eliminates
   duplicate I/O by combining path checking and ALUA state retrieval
   into a single RTPG command.

2. RTPG provides richer path state information than TUR:
   * TRANSITIONING state detected and mapped to PATH_PENDING,
     preventing false all paths down during controller failover
   * STANDBY state detected and mapped to PATH_GHOST
   * UNAVAILABLE/OFFLINE states properly distinguished

The richer state information is valuable even when sysfs is available,
as TUR cannot distinguish between these ALUA-specific conditions.

This design intentionally couples the checker and prioritizer: the
alua_cached prioritizer consumes state cached by the alua checker.
While this blurs the traditional separation between these components,
for ALUA the path state and priority fundamentally derive from the
same underlying data, making the coupling a natural fit.

This patch sets the alua checker as the auto-detected default for ALUA
devices to demonstrate its benefits. We recognize that adopting a new
default checker requires careful consideration; the auto-detection can
be adjusted or removed based on review feedback.

Brian Bunker (1):
  checkers: add alua path checker

 libmultipath/Makefile                   |   5 +
 libmultipath/checkers.c                 |   1 +
 libmultipath/checkers.h                 |   1 +
 libmultipath/checkers/Makefile          |   3 +-
 libmultipath/checkers/alua.c            | 426 ++++++++++++++++++++++++
 libmultipath/checkers/alua.h            |  15 +
 libmultipath/prio.c                     |   1 +
 libmultipath/prio.h                     |   1 +
 libmultipath/prioritizers/Makefile      |   1 +
 libmultipath/prioritizers/alua_cached.c | 225 +++++++++++++
 libmultipath/prioritizers/alua_rtpg.c   |  12 +-
 libmultipath/prioritizers/alua_rtpg.h   |   1 +
 libmultipath/prioritizers/sysfs.c       |   7 +-
 libmultipath/propsel.c                  |  25 +-
 libmultipath/structs.c                  |   2 +
 libmultipath/structs.h                  |   3 +
 16 files changed, 721 insertions(+), 8 deletions(-)
 create mode 100644 libmultipath/checkers/alua.c
 create mode 100644 libmultipath/checkers/alua.h
 create mode 100644 libmultipath/prioritizers/alua_cached.c

-- 
2.50.1 (Apple Git-155)

