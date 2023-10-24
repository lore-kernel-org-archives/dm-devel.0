Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937EE2B773
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="h/l8FPK4"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 682B41FE8F;
	Tue, 24 Oct 2023 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698166186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ItnH+kcvP9dPW8BmsG8kOBYbo1WRo+Hhu1SU9yx5cpk=;
	b=h/l8FPK4gQrJjS4WSYCD7jBEScQ66vExXKYYTCwHJvXPxxomCH2mrlz+llheA+1HnG0W0R
	/Mmg5ZAcMlpvzPJRWDV1aiCFZgTw7ae7vbUfLkOgQoH1C0h/oO+dHHtL/VgHnae4vEC8yV
	UVaC7irlwdiGArZi8I2GlVQmRaEIExc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 256F5134F5;
	Tue, 24 Oct 2023 16:49:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 0+TKBqr1N2VadQAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 24 Oct 2023 16:49:46 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/6] multipath: aio and systemd service improvements
Date: Tue, 24 Oct 2023 18:49:31 +0200
Message-ID: <20231024164937.14684-1-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.90
X-Spamd-Result: default: False [0.90 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[6];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[43.19%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

The bulk of this patch set comes out of my attempts to solve
https://github.com/opensvc/multipath-tools/issues/73 and the insight
that aio memory can't be freed unless either io_getevents() returns
the iocb in question as finished, or io_destroy() has returned.
aio handling in multipathd needs more work, because io_destroy()
may block for a long time, and we must avoid to block, but I would
like to postpone that to a later patch set (I plan to add a generic
aio framework to libmultipath which could then be used by both
the directio checker and the io_err_stat code, but this isn't finished yet).

The last two patches are improvements to multipathd's systemd service and
kernel module loading logic. They are unrelated to the others.

Martin Wilck (6):
  libmultipath: reduce log level of directio messages
  libmultipath: directio: don't reset ct->running after io_cancel()
  libmultipath: io_err_stat: don't free aio memory before completion
  libmultipath: io_err_stat: call io_destroy() before
    free_io_err_pathvec()
  multipath-tools: systemd: require modprobe@dm_multipath.service
  libmpathutil: remove systemd_service_enabled()

 libmpathutil/libmpathutil.version | 17 +++------
 libmpathutil/util.c               | 58 -------------------------------
 libmpathutil/util.h               |  1 -
 libmultipath/checkers/directio.c  | 21 ++++-------
 libmultipath/io_err_stat.c        | 28 +++++++++------
 libmultipath/valid.c              | 16 ++-------
 multipath/Makefile                |  2 --
 multipath/modules-load.conf       |  3 --
 multipathd/multipathd.service     |  2 ++
 tests/directio.c                  | 10 +-----
 tests/valid.c                     | 24 ++-----------
 11 files changed, 35 insertions(+), 147 deletions(-)
 delete mode 100644 multipath/modules-load.conf

-- 
2.42.0

