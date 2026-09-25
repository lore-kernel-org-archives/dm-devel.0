Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF7A3ACA5A
	for <dm-devel@lists.linux.dev>; Fri, 25 Sep 2026 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790372449; cv=none; b=X6Zxqh4Xc8Ft9FZPF2W+fuYn5uTd4OC3jY1jtioyrZxoKRu9tag1SwsC6KmMmQOU1x7VFeGPgMbzJ+KSyV+OEqS324TNgg44H79Hl3Ebefx8jBHUyAANexPfZ+Yml5L+nyz47z2PTzgOhqXGbav7CZLbeCqqQ3NQ3a/GrbYKi5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790372449; c=relaxed/simple;
	bh=ns899MpisHtYOnMBMO//vkPeQe1Jw+LNKAT6+Ge5Jrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fI3a/18lU/jYvpaVQyjZ7VUIwL1ZVIc/9tEjRlwtyRNAjPdcx9F+/bwZC7y96Z802TulRXAab3GPT8x4jwWnQS0TTbl55qVsNGMyRh/MgG+uXQFjc9smpHzKxpSdBDd7eTyqf0Y52wyms5VftNdAqcvdQuzpDGTEycZOVKrrntQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ccDO0Zve; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mqsSST9Y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cicmuqNB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JVENuh/c; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ccDO0Zve";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mqsSST9Y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cicmuqNB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JVENuh/c"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B6B661F388;
	Fri, 25 Sep 2026 21:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=obTyTNvKEQ0yfTzB/9ui21ogG19Q9qBKd1rMm6AwLj8=;
	b=ccDO0ZveU0MyzRRQSzCJG0/+/7BKSLUEkFxtw094TzZRxxriFqlkvvNEmk0N9GVGHSadCG
	tothEft1lJlnEEz7I2mh1Nbgybu/jkkACA9vF20I1J+HImaM7478v4gTy84RcsOqaYJPuA
	z9bACDsM+8wffpNiSy6kz8bAAe4xE9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=obTyTNvKEQ0yfTzB/9ui21ogG19Q9qBKd1rMm6AwLj8=;
	b=mqsSST9YfWlfo+qmE0QRR9AyCjQM2Eb6gRx5YLay804Hou9ybXC9Ir/BoiQkeqeHTNvBad
	3txQB2TUfh8FyJBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=obTyTNvKEQ0yfTzB/9ui21ogG19Q9qBKd1rMm6AwLj8=;
	b=cicmuqNBhWeo6Pd6DI46V21Xy8Zi1uVWsBYyS1hSffxnNuEpKrF0vQ1JlWbccPtKCUyWb2
	S/NZ5uMFRjSWzxkl61pxcvJFBJDCBjsymAMw4LpKWM+AFjvRKGwv72abnzlVK2gXp94CZk
	Zoz784Syr4oyC1h5jo/Cg8unPK0X2vo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=obTyTNvKEQ0yfTzB/9ui21ogG19Q9qBKd1rMm6AwLj8=;
	b=JVENuh/c9OvLulUwlTX0hQFvM9/Z5oHqCC2+IDvs9P38QI+JYtxk/YC27Gth06rYt6OlGO
	ZL/C7dEK//3oqQBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B9C41321C;
	Fri, 25 Sep 2026 21:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7imQB1XqtmoZLwAAD6G6ig
	(envelope-from <mwilck@suse.de>); Fri, 25 Sep 2026 21:40:37 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] multipath-tools: unmangle WWIDs if necessary
Date: Fri, 25 Sep 2026 23:40:05 +0200
Message-ID: <20260925214014.2464499-1-mwilck@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_NO_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:mid]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Recent changes in sg3_utils have changed the way certain WWIDs are presented to
the system. This may lead to maps not being set up or even being destroyed
or removed. Fix this by "unmangling" the WWIDs similar to libdevmapper.

The main part of this series is patch 2/4, it's commit message contains
detailed information. Patch 3 adds tests for the unmangling functionality.

Patch 1 is a small prerequisite. Patch 4 is an optimization that occured
to me while looking at wwids.c.

Comments and questions welcome!

Martin

Martin Wilck (4):
  libmultipath: constify functions in wwid.c
  libmultipath: unmangle WWIDs if necessary
  multipath-tools tests: add test for WWID unmangling
  libmultipath: use mmap in lookup_wwid()

 libmultipath/discovery.c | 103 ++++++++++-
 libmultipath/discovery.h |   1 +
 libmultipath/wwids.c     |  82 ++++-----
 libmultipath/wwids.h     |   6 +-
 tests/Makefile           |   5 +-
 tests/cmocka-compat.h    |   1 +
 tests/wwid-unmangle.c    | 375 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 523 insertions(+), 50 deletions(-)
 create mode 100644 tests/wwid-unmangle.c

-- 
2.55.0

