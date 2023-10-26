Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E381BDC7
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PyRGlW9E"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B575E1FD95;
	Thu, 26 Oct 2023 17:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WeYzT6YCwXsqjey6PFu0U4I0DWoTtQXTtOVuZEdF84o=;
	b=PyRGlW9EJvSdvngtKf2I99q/jBmaNJForrbVCGctM3QjauX3NC9mfSm0LnnKvDEFxTJIq3
	bJlunx22qzrjIqjD+hB6dsTEToU/T3QU6piUz/BGeF06pJTOcX/O3eCmCjK2NHh5YUa3MQ
	mIS0iGtT7lnVTfM5M6DR49SqdfEktF4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C7211358F;
	Thu, 26 Oct 2023 17:42:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id U7haAwGlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:25 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Guan Junxiong <guanjunxiong@huawei.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 00/14] multipath: aio, systemd, and documentation improvements
Date: Thu, 26 Oct 2023 19:41:39 +0200
Message-ID: <20231026174153.1133-1-mwilck@suse.com>
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
X-Spam-Score: -0.60
X-Spamd-Result: default: False [-0.60 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 MID_CONTAINS_FROM(1.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[];
	 FREEMAIL_CC(0.00)[lists.linux.dev,suse.com,huawei.com,gmail.com]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

This is v2 of my "multipath: aio and systemd service improvements" series.
I have shuffled the ordering around a bit and added patches to fix issues
that had come up in the v1 review. I also fixed the error handling of the
aio code in both directio.c and io_err_stat.c.

Cc: Li Xiao Keng <lixiaokeng@huawei.com>
Cc: Miao Guanqin <miaoguanqin@huawei.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>

Changes since v1:
 02/14: re-added the io_cancel() call in libcheck_free() (Ben),
        changed the way I fixed the directio test
 03/14: new (error handling)
 04/14 (was 3/6): no change, fixed Ben's remark in 05/14 in 06/14
 05/14 (was 4/6): avoid cancelling requests after calling io_destroy (Ben).
 06/14: new, avoid iocb starvation (Ben's remark for 3/6)
 07/14: new (error handling)
 08/14 (was 5/6): take systemd version into account

10-14 are new, documentation changes that seem overdue.

v1 cover letter:

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

Martin Wilck (14):
  libmultipath: reduce log level of directio messages
  libmultipath: directio: don't reset ct->running after io_cancel()
  libmultipath: directio: fix error handling
  libmultipath: io_err_stat: don't free aio memory before completion
  libmultipath: io_err_stat: call io_destroy() inside
    free_io_err_pathvec()
  libmultipath: io_err_stat: use higher number of aio slots
  libmultipath: io_err_stat: fix error handling
  multipathd.service: require modprobe@dm_multipath.service if available
  libmpathutil: remove systemd_service_enabled()
  multipath.conf.5: fix typo
  Makefile.inc, README.md: fix docs for prefix in split-usr case
  README.md: update mailing list and contributing information
  README.md: Extend the section about NVMe
  README.md: fix formatting of Changelog section

 Makefile.inc                                  |  10 +-
 README.md                                     | 115 ++++++++++++------
 libmpathutil/libmpathutil.version             |  17 +--
 libmpathutil/util.c                           |  58 ---------
 libmpathutil/util.h                           |   1 -
 libmultipath/checkers/directio.c              |  33 ++---
 libmultipath/io_err_stat.c                    |  75 +++++++-----
 libmultipath/valid.c                          |  16 +--
 multipath/Makefile                            |   6 +-
 multipath/multipath.conf.5.in                 |   2 +-
 multipathd/Makefile                           |   4 +-
 ...ltipathd.service => multipathd.service.in} |   4 +-
 tests/directio.c                              |  27 +---
 tests/valid.c                                 |  24 +---
 14 files changed, 159 insertions(+), 233 deletions(-)
 rename multipathd/{multipathd.service => multipathd.service.in} (85%)

-- 
2.42.0

