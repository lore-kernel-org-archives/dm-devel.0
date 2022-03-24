Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEABC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 21:19:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-2vwFN6xDNLe0ASb0r6-9RA-1; Thu, 24 Mar 2022 17:19:44 -0400
X-MC-Unique: 2vwFN6xDNLe0ASb0r6-9RA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80388811E78;
	Thu, 24 Mar 2022 21:19:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2951111F3C7;
	Thu, 24 Mar 2022 21:19:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8AEF3194034B;
	Thu, 24 Mar 2022 21:19:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 163141940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 21:19:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 01B00400E872; Thu, 24 Mar 2022 21:19:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F19F140CFD0D
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 21:19:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD72F1C05AE0
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 21:19:37 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-Q7KcP8wLM4iFrHeYN66lbQ-1; Thu, 24 Mar 2022 17:19:36 -0400
X-MC-Unique: Q7KcP8wLM4iFrHeYN66lbQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A536C210F4;
 Thu, 24 Mar 2022 21:19:34 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66B7812FF7;
 Thu, 24 Mar 2022 21:19:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id aGgUF2bgPGLBJwAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 24 Mar 2022 21:19:34 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Thu, 24 Mar 2022 22:19:25 +0100
Message-Id: <20220324211927.7152-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v3 00/12] multipathd: fix __delayed_reconfig logic
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4003639796764832523=="

--===============4003639796764832523==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

Hi Ben, hi Christophe, hi Guozhonghua,

here's my new take at the race condition issue reported by Guozhonghua.
This patch set is meant as an alternative to Ben's recent series
"fix looping when reconfigure is delayed". I believe that by removing
the special case from __post_config_state(), the state change logic
becomes somewhat easier to understand again.

I hope I got it right this time.

(not resending the patches 1-10 which were already reviewed by Ben).

Changes v2->v3:

 11: Keep startup/shutdown messages, but with less emphasis
 12: New, as discussed in review of previous patch 11

Changes v1->v2:

 04: reset __delayed_reconfig if no delay needed (Ben)
     only call __post_config_state in IDLE state (Ben)
 06/07: unblock reconfigure if maps are removed, as suggested by Ben
 08-11: minor logging fixes I found useful

Regards
Martin

Martin Wilck (12):
  multipathd: child(): remove superfluous if condition
  multipathd: set reload_type in when calling reconfigure()
  multipathd: avoid busy loop in child() for delayed reconfigure
  multipathd: reset __delayed_reconfig from ev_add_map()
  multipathd: remove volatile qualifier from running_state
  libmultipath: add callback for remove_map()
  multipathd: use remove_map_callback for delayed reconfigure
  libmultipath: warn only once about deprecated options
  multipathd: improve logging of reconfigure()
  multipathd: log state changes
  multipathd: make startup / shutdown messages less noisy
  multipathd: decrease verbosity of handle_signal()

 libmultipath/dict.c               |  15 ++-
 libmultipath/libmultipath.version |   3 +-
 libmultipath/structs_vec.c        |   6 +
 multipathd/main.c                 | 181 ++++++++++++++++--------------
 4 files changed, 115 insertions(+), 90 deletions(-)

--=20
2.35.1


--===============4003639796764832523==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4003639796764832523==--

