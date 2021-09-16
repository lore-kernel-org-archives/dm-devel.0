Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A9CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 08:03:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88C5461108
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 08:03:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 88C5461108
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-Yj7p7gLrODWw8f46rMWkYg-1; Thu, 16 Sep 2021 04:03:14 -0400
X-MC-Unique: Yj7p7gLrODWw8f46rMWkYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A16B1018F71;
	Thu, 16 Sep 2021 08:03:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AF12669ED;
	Thu, 16 Sep 2021 08:03:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5555D4E58F;
	Thu, 16 Sep 2021 08:03:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G833wv020612 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 04:03:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B323C1011011; Thu, 16 Sep 2021 08:03:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF21B101100D
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 08:02:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA1ED8007B1
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 08:02:59 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-293-Y0hGftMNOBaAo2OCVEB2XQ-1; Thu, 16 Sep 2021 04:02:56 -0400
X-MC-Unique: Y0hGftMNOBaAo2OCVEB2XQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B69D31FEAD;
	Thu, 16 Sep 2021 08:02:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D41A13A23;
	Thu, 16 Sep 2021 08:02:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 1penFy76QmHIJgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Sep 2021 08:02:54 +0000
Message-ID: <cc9c5ac40373b2f44fc5ac94e39341ee844ff5cf.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Sep 2021 10:02:53 +0200
In-Reply-To: <20210916033237.GP3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-31-mwilck@suse.com>
	<20210916033237.GP3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.40.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18G833wv020612
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 30/35] multipathd: uxlsnr: merge
 uxsock_trigger() into state machine
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-09-15 at 22:32 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:41:15PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > This patch sets up the bulk of the state machine. The idea is to
> > fall through the case labels as long as possible (when steps
> > succeed)
> > and return to the caller if either an error occurs, or it becomes
> > necessary to wait for some pollable condition.
> >=20
> > While doing this, switch to negative error codes for the functions
> > in uxlsnr.c (e.g. parse_cmd()). Positive return codes are reserved
> > for the cli_handler functions themselves. This way we can clearly
> > distinguish the error source, and avoid confusion and misleading
> > error messages. No cli_handler returns negative values.
> >=20
> > Note: with this patch applied, clients may hang and time out if
> > the handler fails to acquire the vecs lock. This will be fixed in
> > the
> > follow-up patch "multipathd: uxlsnr: add idle notification".
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/uxlsnr.c | 145 ++++++++++++++++++++++++----------------
> > ----
> > =A01 file changed, 80 insertions(+), 65 deletions(-)
> >=20
> >=20

> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0set_client_state(c, CLT_W=
AIT_LOCK);
>=20
> I don't have strong feelings about this, but this state machine
> doesn't
> want to always fall through. sometimes, like if you get -EPERM, you
> want
> to swith from CLT_PARSE to CLT_SEND.=A0 If instead of fallthroughs, you
> just put the switch statement in a loop, and simply returned when you
> wanted to break out to uxsock_listen, you could jump from any state
> to
> any other state, and wouldn't need to have code to skip the actions
> of
> some states, to enable the follow throughs. Just a thought.

Good point. I'll give it a shot and see how it plays out. The end
result will probably be better readable.

I'll also work on your other points.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

