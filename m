Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93737C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F33A6141B
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F33A6141B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-_08QkG_9OhybHdv-MNy28A-1; Thu, 18 Nov 2021 18:20:41 -0500
X-MC-Unique: _08QkG_9OhybHdv-MNy28A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 507D91006AA0;
	Thu, 18 Nov 2021 23:20:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39FE367843;
	Thu, 18 Nov 2021 23:20:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 15F0E1832DDE;
	Thu, 18 Nov 2021 23:20:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINEEQ8005218 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 016A751DD; Thu, 18 Nov 2021 23:14:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFF5251DC
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13C56811765
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:11 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-66-zYTuPIsLMqamJXOxCXnCuA-1; Thu, 18 Nov 2021 18:14:07 -0500
X-MC-Unique: zYTuPIsLMqamJXOxCXnCuA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 09249212CC;
	Thu, 18 Nov 2021 23:14:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BB35313AA8;
	Thu, 18 Nov 2021 23:14:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id EF5XKz3elmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:05 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:38 +0100
Message-Id: <20211118231338.22358-22-mwilck@suse.com>
In-Reply-To: <20211118231338.22358-1-mwilck@suse.com>
References: <20211118231338.22358-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINEEQ8005218
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 21/21] libmultipath: update_pathvec_from_dm:
	don't force DI_WWID
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

For existing paths, we don't need to force setting DI_WWID. It's
pointless because it would matter only in multipathd, and all
callers of update_multipath_table() / update_pathvec_from_dm()
in multipathd call it with flags=0, so this code won't be executed.
And this makes sense, because the path would either have been
cleanly initialized via path_discover() or an uevent, or pathinfo()
would have been called in update_pathvec_from_dm() in an earlier
invocation.

Also remove the misleading comment, and make coverity happy by
checking the return value of pathinfo().

---

Note: I haven't fully made up my mind whether we should act
on a pathinfo() failure here. For now, let the log message suffice.
Because the pathinfo flags are usually clear and pp->udev exists,
the only possible failure would be filtering by foreign libraries
or by devnode, which seems highly unlikely if it hasn't happened
beforehand.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index df5709a..bfec840 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -149,16 +149,15 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 			 * uninitialized struct path to pgp->paths, with only
 			 * pp->dev_t filled in. Thus if pp->udev is set here,
 			 * we know that the path is in pathvec already.
-			 * However, it's possible that the path in pathvec is
-			 * different from the one the kernel still had in its
-			 * map.
 			 */
 			if (pp->udev) {
 				if (pathinfo_flags & ~DI_NOIO) {
 					conf = get_multipath_config();
 					pthread_cleanup_push(put_multipath_config,
 							     conf);
-					pathinfo(pp, conf, pathinfo_flags|DI_WWID);
+					if (pathinfo(pp, conf, pathinfo_flags) != PATHINFO_OK)
+						condlog(2, "%s: pathinfo failed for existing path %s (flags=0x%x)",
+							__func__, pp->dev, pathinfo_flags);
 					pthread_cleanup_pop(1);
 				}
 			} else {
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

