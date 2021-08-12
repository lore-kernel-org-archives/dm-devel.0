Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581D3C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 11:11:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CAF156103A
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 11:11:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CAF156103A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-A9ZZ62FiPVmhPamRUeSqQQ-1; Thu, 12 Aug 2021 07:11:07 -0400
X-MC-Unique: A9ZZ62FiPVmhPamRUeSqQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89FB81008061;
	Thu, 12 Aug 2021 11:11:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BF6E5C25A;
	Thu, 12 Aug 2021 11:11:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 019044A7C8;
	Thu, 12 Aug 2021 11:11:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CBA6wJ017940 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 07:10:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9B81C1050184; Thu, 12 Aug 2021 11:10:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94B86117C2D5
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 11:10:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1FAB180F6D9
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 11:10:02 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-95-mgSQNKtOMsyC4MEt-ai61g-1; Thu, 12 Aug 2021 07:09:58 -0400
X-MC-Unique: mgSQNKtOMsyC4MEt-ai61g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 957DA1FF31;
	Thu, 12 Aug 2021 11:09:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 43A4B13C44;
	Thu, 12 Aug 2021 11:09:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id cXZNDoUBFWFiVQAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 12 Aug 2021 11:09:57 +0000
Message-ID: <65c25c39b00a37f88403d3a32dfdc154c1b8ec3b.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng
	<lixiaokeng@huawei.com>
Date: Thu, 12 Aug 2021 13:09:56 +0200
In-Reply-To: <20210726162827.GH3087@octiron.msp.redhat.com>
References: <37767722-8e6c-4176-d234-87134c21cd4c@huawei.com>
	<20210722214253.GC3087@octiron.msp.redhat.com>
	<85cb30a7-a873-b33d-4105-6e3e9675f105@huawei.com>
	<20210723165603.GE3087@octiron.msp.redhat.com>
	<02cba2a5-3fcf-bca9-d887-f8a3c0300582@huawei.com>
	<20210726162827.GH3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.40.3
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CBA6wJ017940
X-loop: dm-devel@redhat.com
Cc: dm-devel, list <dm-devel@redhat.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>,
	linfeilong <linfeilong@huawei.com>
Subject: Re: [dm-devel] [Question] multipathd.service start failed when
 /var/run isn't mount
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mo, 2021-07-26 at 11:28 -0500, Benjamin Marzinski wrote:
> On Mon, Jul 26, 2021 at 08:22:49PM +0800, lixiaokeng wrote:
> >=20
> > > > After sdb mounted to /var, we can start multipathd service
> > > > successfully.
> > >=20
> > > But when the binaries were compiled, if /var/run existed and was
> > > a
> > > symlink in your build environment, then RUN should equal "run",
> > > and
> > > multipath should should be using /run instead of /var/run, right?
> > >=20
> > > This is why I asked what multipath packages are you using.
> > >=20
> > This problem is found in 0.7.7.
>=20
> Sorry. I wasn't very clear with what I was asking for.=A0 Unless I'm
> missing something here, if multipathd is trying to use /var/run, that
> means that when the multipathd binary was compiled, it was compiled
> on a
> machine where /var/run was not a symlink.=20
>=20
> So, I'm wondering where your multipathd binary got compiled. Are you
> using a packaged version from a distribution like RHEL, SLES, Fedora,
> Ubuntu, etc? Did you compile it yourself?
>=20
> When I run multipathd under strace, I can see:
>=20
> openat(AT_FDCWD, "/run/multipathd.pid", O_WRONLY|O_CREAT, 0644) =3D 3
>=20
> The multipathd binary I'm using was compiled on a machine where
> /var/run
> is a symlink to /run, so multipathd directly uses /run, instead of
> using
> /var/run. I'm assuming that whatever machine your multipathd binary
> was
> compiled on, /var/run was a directory. Do you know if that's
> possible?

Ack. Lixiaokeng, can you answer Ben's question?

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

