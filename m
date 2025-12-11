Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6102882C5
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 23:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765496768; cv=none; b=Z+Kdq/Vl5djQd00TcTSY1WkEtYhC8wiQkCWbquxAzzcMVmpZWd2LRKG7+1cKm2vH5+8v7hdhtz45uvef9Mj+LeBYhpbukS5Y91TFoZVNr5QTYyoguh5/Ll1xs2pKoNTWxl9j+LgqKGmoZaiRSxmFJDRAzWcq+nUXPfHqtZ2nD2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765496768; c=relaxed/simple;
	bh=uspyl7GITTkRih6K9JB7TiTvCIvF7GXrYQLU+PmzkGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nezsFRkjRAsJUIV+dMgfmxayM5SEu/zlDYvSYWZgnatkRo49QF62v7mNkg11s/7iLQsG+dW+eRDvfDcZfUibblx0r4E422y0dela96sg51cTOmOHy8trqwNxs0Dnn1zbeAz4jav06Kkk0mA8P2i5xWWVl9DWpCAk1raKRc8lv4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=O++YEnMs; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="O++YEnMs"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2953ad5517dso7100535ad.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 15:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765496764; x=1766101564; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pCX8OebmsnFHXEHD2/ZNIRPbs/WwIU0aMpfMSSDkQTo=;
        b=O++YEnMsF1LVqenVLjX9tUcY+NQOJGV7HSgRCxt9AcW/jSGj0B39WHyu0Dtm+O9rNN
         Ur7LCEkxNjORmqK6ZkdAQvsbzCoCqbkO33jblPqU2dXNUFeRXu7bRIV4PgmJoo5Xs3Z9
         /9urrMvby4xBu/rjbiG19NSNH43IG7W0vCNYD6laJzSof9uX1GfGHqjqsvw3UZ1d1B4b
         PuWYXUcZN5e/13BYUMiAuLtrYzutuxGqx3kYubaeKZ7mzwss4v2Czx6a1XJgjeU62+jj
         zZ9Y/lFp+SVpvCgEuGRQiHFLBv0WYbSoTFhqZi/7J7HLfGnbjc0dZeLBsx7jWGGUBIp/
         a5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765496764; x=1766101564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCX8OebmsnFHXEHD2/ZNIRPbs/WwIU0aMpfMSSDkQTo=;
        b=Ul6ZIzZ5B5EhmGwBpD1UZ61I5sfN5hA7nEXAALcPqiY+nxGHEF2WR7flMrbWW5KWR0
         U7agz9CNPbcN4NB50vSyP9IlukU0nBnfe0T/3zX55t8J/8gWpAZe/qLPBZPgKZ4fnAc1
         0K1bvjKjiKYvsuTf/NAfX1fL8F0awGvraWFCWzwmavX5it59EcH4sRyvLXXzgiVExaJu
         oGbcizVZceekV5KcWxOl+ncH/3/hK6+Rkbw1OJ2hnlZlFWmbnDbhe4YLc1KhfujxQoV5
         F01PhazxwS9hLZOQJWi2IrqLcHtfafQ3Sxno/dLynOt4Ld2Aa6A7i2nf+Wx0t4NvJiNy
         N9Ng==
X-Gm-Message-State: AOJu0Yy9uHAUeK2w63BQn/Vs1E6b4DJBygmGBhqqEb5otoebWD+gnpiU
	Vz8nGGX1DIyu7h4tLMJ1IFlbAqu3z4T9TeWyRTwp6oyZf7cMV9Sx+tPtK7aX1+8JXFqquwDoK+Z
	W3s7BuZrWIas/F89lxmdoqnNGM7L3nWVflIXqVJ82eW6KDeaDYhkCwQbiGMQ7H65oV6PmeOvTmT
	qwwMdmzTkqBkwg0E+4c1S6jYoZWJHCCvVYSIH7P7Wz94tu+Sg=
X-Gm-Gg: AY/fxX5sq6KtlNiSDRfmfmfZpOCc72hDFEUO8i6FoPaDxqWUVA3Wc5WqpIjqdych/dJ
	+TrprgSElQYIO6h4CIO8IOdaUtRJ4HwF+61DUvKz4xIBJEd0x6F6Gon+YpjhD9SsI6xMUB6SrQB
	vjGVos9qDP8Om4+ZKUE04871/1P57mtT02UZgAea/Y1vl8ykLw0XriXF5nIDUBs4Yi7l1uy1c2n
	45rVxKkCwVDk9dlRPux1Fo5VOYMCR5iVOORWImQtue7z3ul+KAnO69MdBNnM5f3z941BhZfFyZa
	kByLpDDy6QwIcTPpDMvfZsNHmHle6mCf5oJd5WciI7dpfTHjXnZcDHzmP91i9+bUmln2eMGJpIu
	SsTcXA2aBXIS+A6Nk9KgZpBCup+FymcD082AN68aNlQt3SsetQCHkTQL7sGmp0Fo9puuUiN7IuW
	JgGEzKjeEhOAxHivxUm/kxVQERPerKEPp460Logs54Ym+1ZunG5HEW8lYZV3BEaQFyWIQKYv3mI
	4hQ7gaXCWMnQOFzXvnLhFTPblM6aqSvh0s+CkYWBB4=
X-Google-Smtp-Source: AGHT+IGjGkyMSce4dCrA6Dp+f1MFZclWKoc88WW9uN3aMtx1m8Qbs3OomzqCpd+2eO1D5EJeBjg+Bg==
X-Received: by 2002:a05:7022:ed05:b0:11b:9386:a38a with SMTP id a92af1059eb24-11f34c71505mr176526c88.45.1765496764292;
        Thu, 11 Dec 2025 15:46:04 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.78])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2b4867sm11920594c88.6.2025.12.11.15.46.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Dec 2025 15:46:03 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev,
	bmarzins@redhat.com,
	mwilck@suse.com
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH v5 0/1] mulitpath-tools Add purge capability to multipath-tools
Date: Thu, 11 Dec 2025 15:45:58 -0800
Message-ID: <20251211234559.26489-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The changes represent "v5" of the purge disconnected paths feature. Here are
the key modifications:

1. Renamed purge_path to disconnected with Enum States
Changed from a simple boolean purge_path to an enum path_disconnected_state
with three states:
NOT_DISCONNECTED (0) - path is normal
DISCONNECTED_NO_PURGE - path was disconnected but purge was cancelled or
alreadyattempted
DISCONNECTED_NEEDS_PURGE - path is disconnected and needs to be purged

2. Enhanced WWID Recheck Logic
Modified the WWID recheck condition to trigger if either:
 recheck_wwid is explicitly enabled (existing behavior), OR
Path was previously disconnected (new safety feature)
This provides protection even when users don't enable  recheck_wwid, since
disconnected paths are much more likely to have changed WWIDs

3. Added Disconnected State Recovery
When a path recovers to UP/GHOST state, the disconnected state is cleared
This happens after the WWID recheck, ensuring the WWID is validated before
clearing the flag

4. Improved Purge Loop Logic
Changed from clearing purge_path flag to downgrading from
DISCONNECTED_NEEDS_PURGE to DISCONNECTED_NO_PURGE
This prevents infinite retry loops if purging fails
Better error handling: if prepare_purge_path_info() fails, continue looking
for other paths instead of stopping

5. Fixed prepare_purge_path_info() Error Handling
Now properly cleans up and returns false if dup() fails
Previously would proceed anyway; now treats it as a failure

6. Removed Redundant Code
Removed the clearing of purge_path from reinstate_path() since it's now handled
earlier in update_path_state()
 
7. Comment Improvements
Wrapped all comments to 80 characters
Added clearer explanations of the logic flow
Better documentation of the purge loop behavior

Brian Bunker (1):
  mulitpath-tools Add purge capability to multipath-tools

 libmultipath/checkers.c       |   2 +
 libmultipath/checkers.h       |   2 +
 libmultipath/checkers/tur.c   |  10 ++
 libmultipath/config.c         |   2 +
 libmultipath/config.h         |   3 +
 libmultipath/configure.c      |   1 +
 libmultipath/defaults.h       |   1 +
 libmultipath/dict.c           |  14 ++
 libmultipath/discovery.c      |   3 +-
 libmultipath/io_err_stat.c    |   1 +
 libmultipath/print.c          |   2 +
 libmultipath/propsel.c        |  16 ++
 libmultipath/propsel.h        |   1 +
 libmultipath/structs.h        |  14 ++
 libmultipath/sysfs.c          |   2 +-
 multipath/multipath.conf.5.in |  22 +++
 multipathd/main.c             | 287 +++++++++++++++++++++++++++++++++-
 17 files changed, 374 insertions(+), 9 deletions(-)

-- 
2.52.0

