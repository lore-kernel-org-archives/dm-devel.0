Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FBC3994C
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qYNAsSst"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A55FA1FD96;
	Thu, 26 Oct 2023 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UVy80kE9lYPOCxupKyLCxiJwLQc3ZPyP7qlUh5H/OsU=;
	b=qYNAsSst25RsqtP0dc/yNCQkmn/gfI1C+z+sySqQMQuLRE96US/LexDHMJZJ9BV9Lud3bn
	2UXZyhSSVsdIvKiYiqwbSln06Yex1onsaRI49dCKrqyNI/G/NRcjkaxysmibB8mUB56XuV
	qEHw/BMTLQbzNm076juotPiZb8Cv0UM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 539401358F;
	Thu, 26 Oct 2023 17:42:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 0OIxEQelOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:31 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/14] multipath.conf.5: fix typo
Date: Thu, 26 Oct 2023 19:41:49 +0200
Message-ID: <20231026174153.1133-11-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026174153.1133-1-mwilck@suse.com>
References: <20231026174153.1133-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 226d001..2b70b6d 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -782,7 +782,7 @@ Specify the maximum number of seconds the SCSI layer will spend doing error
 handling when scsi devices fail. After this timeout the scsi layer will perform
 a full HBA reset. Setting this may be necessary in cases where the rport is
 never lost, so \fIfast_io_fail_tmo\fR and \fIdev_loss_tmo\fR will never
-trigger, but (frequently do to load) scsi commands still hang. \fBNote:\fR when
+trigger, but (frequently due to load) scsi commands still hang. \fBNote:\fR when
 the scsi error handler performs the HBA reset, all target paths on that HBA
 will be affected. eh_deadline should only be set in cases where all targets on
 the affected HBAs are multipathed.
-- 
2.42.0

