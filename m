Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D86C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 07:35:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DDE8611C6
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 07:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1DDE8611C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-vxtjBOgyPtK7F9oUBew0ew-1; Thu, 16 Sep 2021 03:35:03 -0400
X-MC-Unique: vxtjBOgyPtK7F9oUBew0ew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D47E71006AAB;
	Thu, 16 Sep 2021 07:34:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6E2E60E1C;
	Thu, 16 Sep 2021 07:34:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 21BE14EA2A;
	Thu, 16 Sep 2021 07:34:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G7YuEc018901 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 03:34:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F0E69F809E; Thu, 16 Sep 2021 07:34:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB244FA72D
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 07:34:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CC6B899EC4
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 07:34:53 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-18-eYRahgJaOji7-LRiYrlG2g-1; Thu, 16 Sep 2021 03:34:49 -0400
X-MC-Unique: eYRahgJaOji7-LRiYrlG2g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B46C22327;
	Thu, 16 Sep 2021 07:34:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C71FA13A23;
	Thu, 16 Sep 2021 07:34:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id QLy5KpfzQmEeFwAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Sep 2021 07:34:47 +0000
Message-ID: <7bb868e4ff09dc2de37542009762e321a614df7f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Sep 2021 09:34:46 +0200
In-Reply-To: <20210916001329.GZ3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-15-mwilck@suse.com>
	<20210916001329.GZ3087@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18G7YuEc018901
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 14/35] multipathd: add "force_reconfigure"
	option
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

On Wed, 2021-09-15 at 19:13 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:40:59PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Since e3270f7 ("multipathd: use weaker "force_reload" at startup"),
> > (multipath-tools 0.7.0), we only reload those maps that must be
> > reloaded during startup. "multipath reconfigure", OTOH, reloads
> > every map, which may take a long time on systems with lots of
> > storage devices, as every DM_DEVICE_RELOAD ioctl involves a
> > suspend/resume cycle.
> >=20
> > The logic we use during startup is actually very robust and catches
> > all cases in which a reload is necessary. "reconfigure" operations
> > are often done because of configuration changes, and usually don't
> > require a full reload of every map.
> >=20
> > This patch changes the default behavior of "multipath reconfigure"
> > to "weak" reload, like we do on startup since e3270f7. The behavior
> > can be changed by setting the configuration option
> > "force_reconfigure yes" before starting the reconfigure operation.
> > "multipath -r" is also affected, but "multipath -D -r" is not.
> >=20
> > It would have been nice to have introduced a new cli command
> > "reconfigure force" instead, but the way "reconfigure" is
> > implemented, that would have required a major rewrite of the code.
>=20
> This looks o.k. But I don't think it would be that hard to add a new
> multipathd command to reconfigure all the devices.=A0 My personal
> preference would be to leave force_reconfigure off by default, so that
> we keep the same behavior, and add a command to force a full reconfig.
> I'll try to work up a patch with my idea that can apply on top of this.

The problem I see is with the "delayed reconfigure" approach. We
notify child() about a pending reconfiguration by setting
DAEMON_RECONFIGURE. If clients can request different "types" of
reconfiguration, we would either need an additional flag, or a new
state (e.g. DAEMON_RECONFIGURE_FORCE) to indicate which type of
reconfiguration was requested. And then what to we do if while one
reconfigure is running, the admin runs both "reconfigure force" and
"reconfigure"? We can only schedule only one reconfigure operation. We
should probably assume "force" in that rather unlikely case.

IMO we should not implement _both_ a configuration option
"force_reconfigure" _and_ an additional command "reconfigure force". We
should decide which one we want. If you can come up with a reasonable
logic for the latter, I agree it's better.

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

