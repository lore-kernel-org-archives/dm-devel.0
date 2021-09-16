Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3845C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 10:53:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 17B7161216
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 10:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17B7161216
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-ZomHjScsNxaj0LukukzZaA-1; Thu, 16 Sep 2021 06:53:37 -0400
X-MC-Unique: ZomHjScsNxaj0LukukzZaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC8ECC622;
	Thu, 16 Sep 2021 10:53:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A633E60E1C;
	Thu, 16 Sep 2021 10:53:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 518C31800FE4;
	Thu, 16 Sep 2021 10:53:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GArSAA003772 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 06:53:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 396E310F99B; Thu, 16 Sep 2021 10:53:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3337211411E
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 10:53:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21D04858F14
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 10:53:25 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-405-qKAHbRWUOdqz6KE5JsfiRg-1; Thu, 16 Sep 2021 06:53:20 -0400
X-MC-Unique: qKAHbRWUOdqz6KE5JsfiRg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3AA112237C;
	Thu, 16 Sep 2021 10:53:19 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0700B13CC7;
	Thu, 16 Sep 2021 10:53:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id oiclOx4iQ2E6BQAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Sep 2021 10:53:18 +0000
Message-ID: <cb505cd84add0d70896e589281203c887c13a58f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
In-Reply-To: <20210915222023.GQ3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-6-mwilck@suse.com>
	<20210915222023.GQ3087@octiron.msp.redhat.com>
MIME-Version: 1.0
Date: Thu, 16 Sep 2021 09:10:57 +0200
User-Agent: Evolution 3.40.4
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18GArSAA003772
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 05/35] libmultipath: improve cleanup of
 uevent queues on exit
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-09-15 at 17:20 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:40:50PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > uevents listed on merge_node must be cleaned up, too. uevents
> > cancelled while being serviced and temporary queues, likewise.
> > The global uevq must be cleaned out in the uevent listener thread,
> > because it might have added events after the dispatcher thread
> > had already finished.
> >=20
>=20
> There's nothing wrong with this, but for the global list, wouldn't it
> be
> easier to just wait till after cleanup_child() calls
> cleanup_threads(),
> and then call cleanup_global_uevq(). That way you know nothing else
> is
> running.

That would be possible. If I understand your proposal correctly, that
would require calling cleanup_global_uevq() from cleanup_child(), i.e.
from the main process. Currently uevq and the functions handling it are
static and only visible in uevent.c.

By taking the lock in cleanup_global_uevq() and calling it from the
listener on cleanup, I can be sure that the dispatcher won't see any
more uevents if it hasn't terminated yet, and that no no events will be
added to the queue after cleanup. So I think with this patch I can also
be certain that uevq is cleaned up for good, without a need to export
the cleanup function, and without enforcing a certain order of thread
shutdowns on exit. Do you disagree?

Thanks,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

