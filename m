Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982B7C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 19:56:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-lEr30UfmPTOmXMBLz2-bdQ-1; Thu, 17 Feb 2022 14:56:01 -0500
X-MC-Unique: lEr30UfmPTOmXMBLz2-bdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47606814249;
	Thu, 17 Feb 2022 19:55:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C939452E5;
	Thu, 17 Feb 2022 19:55:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 060561809CBA;
	Thu, 17 Feb 2022 19:55:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HJtp1c005182 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 14:55:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0E6F72166B17; Thu, 17 Feb 2022 19:55:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A4602166B2D
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C8253C02B81
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-652-0lGeFJqVNbSOlcba-D4ITA-1; Thu, 17 Feb 2022 14:55:38 -0500
X-MC-Unique: 0lGeFJqVNbSOlcba-D4ITA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 866661F883;
	Thu, 17 Feb 2022 19:55:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4726613476;
	Thu, 17 Feb 2022 19:55:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id UGodDzmoDmLBVgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 17 Feb 2022 19:55:37 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Feb 2022 20:55:33 +0100
Message-Id: <20220217195533.4251-5-mwilck@suse.com>
In-Reply-To: <20220217195533.4251-1-mwilck@suse.com>
References: <20220217195533.4251-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21HJtp1c005182
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 4/4] libmultipath: only warn once about
	unsupported dev_loss_tmo
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

On systems with many devices, the warning that setting dev_loss_tmo
is unsupported for certain protocols is printed many times, cluttering
the logs. Only print this message once per unsupported protocol.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c165d9b..b969fba 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -843,6 +843,7 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 	int i;
 	unsigned int dev_loss_tmo = mpp->dev_loss;
 	struct path *err_path = NULL;
+	STATIC_BITFIELD(bf, LAST_BUS_PROTOCOL_ID + 1);
 
 	if (mpp->no_path_retry > 0) {
 		uint64_t no_path_retry_tmo =
@@ -897,12 +898,13 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 		sysfs_set_eh_deadline(mpp, pp);
 	}
 
-	if (err_path) {
+	if (err_path && !is_bit_set_in_bitfield(bus_protocol_id(pp), bf)) {
 		STRBUF_ON_STACK(proto_buf);
 
 		snprint_path_protocol(&proto_buf, err_path);
 		condlog(2, "%s: setting dev_loss_tmo is unsupported for protocol %s",
 			mpp->alias, get_strbuf_str(&proto_buf));
+		set_bit_in_bitfield(bus_protocol_id(pp), bf);
 	}
 	return 0;
 }
-- 
2.35.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

