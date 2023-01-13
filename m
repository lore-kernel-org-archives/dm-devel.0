Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33078C54EBD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Jan 2023 09:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673603025;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dpd+EhhRdMeORzJxeQ5n3fynUgs66mLGl9ReziBcr6U=;
	b=eronou6VwwZBmmTty/isIDohF8ZbKvby6f0Ncex0+rSQNZMKwsT3hhdEuscCLjLuqNvWSh
	XoAUarprH85uSoPcrET1XjdFINq3jwbMIb3VDjHS0O7W/Tc2qbFGt8cvp2YSNCLX8xB+ir
	XO2IeWwCPbTNBHGePsz7SrfAWIqgnWY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-xWYgxlmsNT2npyYG1_BVag-1; Fri, 13 Jan 2023 04:43:41 -0500
X-MC-Unique: xWYgxlmsNT2npyYG1_BVag-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC3F118E0A63;
	Fri, 13 Jan 2023 09:43:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B87B74078904;
	Fri, 13 Jan 2023 09:43:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84DCF1947055;
	Fri, 13 Jan 2023 09:43:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BDE471946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 Jan 2023 09:43:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE139492B06; Fri, 13 Jan 2023 09:43:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A65C1492B05
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 09:43:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 811C318E0A63
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 09:43:37 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-301-gX2GwzVANoGHWE3--mQXhg-1; Fri,
 13 Jan 2023 04:43:35 -0500
X-MC-Unique: gX2GwzVANoGHWE3--mQXhg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id BDA284EEBA;
 Fri, 13 Jan 2023 09:43:33 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85D161358A;
 Fri, 13 Jan 2023 09:43:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Ab3pHsUnwWOafQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 13 Jan 2023 09:43:33 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 13 Jan 2023 10:43:08 +0100
Message-Id: <20230113094310.20367-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 0/2] multipath-tools fixes for GitHub reported
 issues
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Two patches that originate from issues reported on GitHub.
I couldn't figure out the email addresses of the reporters.

Martin Wilck (2):
  libmpathpersist: use conf->timeout for updating persistent
    reservations
  libmultipath: pathinfo: don't fail for devices lacking INQUIRY
    properties

 libmpathpersist/mpath_updatepr.c | 11 ++++++++++-
 libmultipath/discovery.c         | 22 +++++++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

