Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892FA3D091A
	for <dm-devel@lists.linux.dev>; Tue,  6 Oct 2026 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319553; cv=none; b=C5ijfcCVuT07ACcr/0efq8EIY7qPYWN9dwIFlE6hTRvgwJmhmTZNjhViqQ65AjhgZQlipvcapQTy3SeH0scSPQnVLXtOGyh5BLcb//omMhw1FHCIe/qW+h1yd8SBaYQjIwwB6Ea2PRr3dHlEr5tiirp2GOf+lxNlYjAIUv3If8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319553; c=relaxed/simple;
	bh=H9jYNjv8XR4OcPd/rYUv8vS0ws79SlL03rMLwFK3UMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DWT+vTb1tok5QscZA+ai8pDq6bDZ++izLku89tbDUwkWozse6uF08B5z0oX43mb0OxF+pISYmYuSUJDaGRAeh8SPzw9HL6I/EU5ZpAzD6AdcWbN0qleXhRySwTiZJVK12fqo+xcAJul86eSjilyyiW1oA22GSY64LV/68Ap4MJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=d5CvfECC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ztT8nlzW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JrRatqE3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EG7fPrhs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="d5CvfECC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ztT8nlzW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JrRatqE3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EG7fPrhs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E563D1F745;
	Tue,  6 Oct 2026 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/85MdxFG6p7P3IwwYqK8JBVgUUab/Y3U8y795wDU6E=;
	b=d5CvfECCvguyXmm/UbCbge3rjIZEvWk8QO5y+R+Jbe2nz01FA4d14akL0KqeppQwhkN4xm
	zl2bNN/pC3oAbXOqKQxHYrY7suUdVwxPaiY3+VMaVEnrAjrwBL7x7RaFZRnunClt/Almx/
	Zyu0I+tAZGhUWTn+gV3B3+lbnuk58mI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/85MdxFG6p7P3IwwYqK8JBVgUUab/Y3U8y795wDU6E=;
	b=ztT8nlzW10S9QsAKJ6CQax/1XsyG39QrpSs1xbaC8CF3JRZLGyGCGNhJe1pf6oR+aEO83d
	IDYWiHediu97SrAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/85MdxFG6p7P3IwwYqK8JBVgUUab/Y3U8y795wDU6E=;
	b=JrRatqE3A3HQGMnbfmwySb/kDwngAUVyYcV6ZoAnwvT1Mkoaazov9A7XuCQhOrRjHrBYrl
	YSJZnEJgC8xD9uywHf5zfAJfVdApoA//WZ7BSTqoLzUPqYb/z/d+raCtcI4O12xm4WWfBV
	vpy2viH0IlGw9SOS3VbSl/kfoe2XKqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/85MdxFG6p7P3IwwYqK8JBVgUUab/Y3U8y795wDU6E=;
	b=EG7fPrhsh2AJuM0YE+7zLXxtSfbHgnZfba5AJKQdpPbHjnttgqmHVr6TUupj9XT/xh1e8R
	SQor/rL4/TUyH1DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7153137AC;
	Tue,  6 Oct 2026 20:45:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h2fNHvRdxWqCPAAAD6G6ig
	(envelope-from <mwilck@suse.de>); Tue, 06 Oct 2026 20:45:40 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/3] multipath-tools: unmangle WWIDs if necessary
Date: Tue,  6 Oct 2026 22:45:20 +0200
Message-ID: <20261006204530.993731-1-mwilck@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_NO_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.com:email];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Recent changes in sg3_utils have changed the way certain WWIDs are presented to
the system. This may lead to maps not being set up or even being destroyed
or removed. Fix this by "unmangling" the WWIDs similar to libdevmapper.

The main part of this series is patch 2/4, it's commit message contains
detailed information. Patch 3 adds tests for the unmangling functionality.

Patch 1 is a small prerequisite.

Comments and questions welcome!

Martin

---
Changes v1 -> v2:

* Patch 02: several fixes suggested by Ben Marzinski
* Patch 04: dropped, it would risk being killed by SIGBUS if multipath
  would truncate the wwids file while multipathd had it mapped.

Martin Wilck (3):
  libmultipath: constify functions in wwid.c
  libmultipath: unmangle WWIDs if necessary
  multipath-tools tests: add test for WWID unmangling

 libmultipath/discovery.c | 100 ++++++++++-
 libmultipath/discovery.h |   1 +
 libmultipath/wwids.c     |  19 +-
 libmultipath/wwids.h     |   6 +-
 tests/Makefile           |   5 +-
 tests/cmocka-compat.h    |   1 +
 tests/wwid-unmangle.c    | 375 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 487 insertions(+), 20 deletions(-)
 create mode 100644 tests/wwid-unmangle.c

-- 
2.55.0

