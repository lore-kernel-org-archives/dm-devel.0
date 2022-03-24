Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3D5C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 17:17:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-nEd1VbX8Ouuy4CddIpgR3g-1; Thu, 24 Mar 2022 13:17:26 -0400
X-MC-Unique: nEd1VbX8Ouuy4CddIpgR3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20CD21C04B6B;
	Thu, 24 Mar 2022 17:17:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1D6FC15E60;
	Thu, 24 Mar 2022 17:17:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 62D0F194034B;
	Thu, 24 Mar 2022 17:17:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 352FC1940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 17:17:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7B841454536; Thu, 24 Mar 2022 17:17:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3B8D1454535
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 17:17:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6A443802AD2
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 17:17:19 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-G_kmZbeuNVyejxJ8IeSyZQ-1; Thu, 24 Mar 2022 13:17:18 -0400
X-MC-Unique: G_kmZbeuNVyejxJ8IeSyZQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 3C4C2210F4;
 Thu, 24 Mar 2022 17:17:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 085C713A7F;
 Thu, 24 Mar 2022 17:17:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id k85OO5unPGLCVgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 24 Mar 2022 17:17:15 +0000
Message-ID: <a3703816e0b652fa94831016eadf9fb6d48fc1f6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Uday Shankar <ushankar@purestorage.com>
Date: Thu, 24 Mar 2022 18:17:15 +0100
In-Reply-To: <20220324170809.GA2213089@dev-ushankar.dev.purestorage.com>
References: <20220309200325.2490463-1-ushankar@purestorage.com>
 <20220323231023.GL24684@octiron.msp.redhat.com>
 <3fdc891239f9c45f8b4c034eae9ded9572f2a0ad.camel@suse.com>
 <20220324170809.GA2213089@dev-ushankar.dev.purestorage.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] multipath-tools: update mpp->force_readonly
 in ev_add_path
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2022-03-24 at 11:08 -0600, Uday Shankar wrote:
> Thanks to Benjamin for the review and to Martin for taking the patch.
> 
> > https://github.com/openSUSE/multipath-tools/tree/queue
> Benjamin, does RedHat take patches from this repo? The
> device-mapper-multipath spec file seems to point to git.opensvc.com
> (which is dead), and the upstream URL christophe.varoqui.free.fr
> refers
> to github.com/opensvc/multipath-tools. Will patches committed to the
> above openSUSE repo will make their way to the opensvc one (since
> openSUSE forks opensvc)?

Yes. I create github PRs from the openSUSE/queue branch. See the past
PRs on github.com/opensvc/multipath-tools. 

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

