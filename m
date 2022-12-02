Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CB8EC4332F
	for <dm-devel@archiver.kernel.org>; Fri,  2 Dec 2022 22:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670021556;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=csaQLbToxNFekxORU8gcqMEjmTqpgT0Ojf1XyPHU2Gc=;
	b=Jo755+w4oEHEw3a6+fZJGT8EhxyFsRMuPGG/mQt59HTzODCmJz/B9VHfkgiSaZBLS/0UL0
	zYChm7GIuV32SDb8XgS+t9BBiH4UYdnWSPTvffvBZBjwP/fa5H4POErzwubBfxTAyBmlrf
	S3lnU65DKUNo5mzd9XSmQKP9rU1kVxs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-4DJqFkqBPgWQWfDPCmynug-1; Fri, 02 Dec 2022 17:52:33 -0500
X-MC-Unique: 4DJqFkqBPgWQWfDPCmynug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C440811E67;
	Fri,  2 Dec 2022 22:52:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF6E640CA40C;
	Fri,  2 Dec 2022 22:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F037194658F;
	Fri,  2 Dec 2022 22:52:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 93F291946587
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Dec 2022 22:52:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 77E6D40CA40F; Fri,  2 Dec 2022 22:52:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 700BC40CA40C
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 22:52:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37EB6185A78F
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 22:52:28 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-668-EDE_J3-iMCGfoyF3HHt3jQ-1; Fri,
 02 Dec 2022 17:49:32 -0500
X-MC-Unique: EDE_J3-iMCGfoyF3HHt3jQ-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 556B021B14;
 Fri,  2 Dec 2022 22:49:31 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2207513644;
 Fri,  2 Dec 2022 22:49:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id h3qpBvuAimOESAAAGKfGzw
 (envelope-from <mwilck@suse.com>); Fri, 02 Dec 2022 22:49:31 +0000
Message-ID: <e506d4c8d63e0fda3c28297c4316b49c0e2a9fb1.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 02 Dec 2022 23:49:30 +0100
In-Reply-To: <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
 <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
 <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
 <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
User-Agent: Evolution 3.46.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 2/2] multipath.conf(5): improve documentation
 of dev_loss_tmo
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-12-02 at 14:48 -0600, Roger Heflin wrote:
> Reading through it, on the line below, shouldn't it be -t (not -T)?
>=20

No, -T is correct. -t prints the entire internal table, most of which
doesn't apply on any given system. -T prints only the settings for
hardware that's present in the given system, which is what most users
will prefer (I assume).

But thanks for reading carefully. Appreciated!

Martin



> Line:
> +the multipath-tools built-in settings override the default. Run
> \fImultipath -T\fR
>=20
> On Fri, Dec 2, 2022 at 11:58 AM Martin Wilck <mwilck@suse.com> wrote:
> > On Fri, 2022-12-02 at 18:57 +0100, Martin Wilck wrote:
> > > On Fri, 2022-12-02 at 18:31 +0100, Xose Vazquez Perez wrote:
> > > > On 12/1/22 11:32, mwilck@suse.com=A0wrote:
> > > >=20
> > > > > From: Martin Wilck <mwilck@suse.com>
> > > > >=20
> > > > > The statement that the default is 600 is wrong in most cases.
> > > > > Improve the description of the default and the dependency of
> > > > > this
> > > > > parameter on other parameters.
> > > >=20
> > > > I did change this patch to move "default value" to bottom.
> > >=20
> > > The problem is that there is no easily explained default value
> > > for
> > > this
> > > parameter. Nice as the common "default value" format is, it
> > > doesn't
> > > apply=A0here.
> > >=20
> > > If you have a suggestion for improving the formatting or wording,
> > > please speak up.
> >=20
> > Sorry, I missed your other email because it had been sorted into a
> > different folder.
> >=20
> > Martin
> >=20
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://listman.redhat.com/mailman/listinfo/dm-devel
> >=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

