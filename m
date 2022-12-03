Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73CCEC4321E
	for <dm-devel@archiver.kernel.org>; Sat,  3 Dec 2022 00:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670025772;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2tyAjuZgw7i3g2A69C4eS5odj8LP0i5nsDRcHaYD5HY=;
	b=ia0dk1hpCdTdfS0209noHSpETyR2u6bkfCFN8NAfxLwTmttroY/NJ8SwjrjQ1wkM6HhOTd
	nZovOIWeJ5HdP+ny9ChlJ9Qo293+P69k1IP+lDsT+Wvh5mT2FEMCJwfLaAyKIjDWbQjN+H
	ytXtTmh3C2o796kSl1tt3QZJUCFyfIc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-Gdl_qX_AP-ujGUIQJQmsMw-1; Fri, 02 Dec 2022 19:02:51 -0500
X-MC-Unique: Gdl_qX_AP-ujGUIQJQmsMw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D30A8339C5;
	Sat,  3 Dec 2022 00:02:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF4ED403350;
	Sat,  3 Dec 2022 00:02:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B6C86194658F;
	Sat,  3 Dec 2022 00:02:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EBF1B1946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 00:02:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DBE282166BC0; Sat,  3 Dec 2022 00:02:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D45A52166B2A
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:02:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B632238041C4
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:02:47 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-473-EkwjbYb2PUaHIfCrRqyMgQ-1; Fri,
 02 Dec 2022 19:02:44 -0500
X-MC-Unique: EkwjbYb2PUaHIfCrRqyMgQ-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A0B591FDC0;
 Sat,  3 Dec 2022 00:02:42 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6D7E213649;
 Sat,  3 Dec 2022 00:02:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id Uo4rGSKSimNaZgAAGKfGzw
 (envelope-from <mwilck@suse.com>); Sat, 03 Dec 2022 00:02:42 +0000
Message-ID: <2ac89d4413992bd1158e4552d0632cf8c6a8dd89.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Roger Heflin <rogerheflin@gmail.com>
Date: Sat, 03 Dec 2022 01:02:41 +0100
In-Reply-To: <CAAMCDeeUkfetN6ABUcDTU29m0yR1gv7UPh8_2HtLg_ZPBougXg@mail.gmail.com>
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
 <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
 <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
 <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
 <e506d4c8d63e0fda3c28297c4316b49c0e2a9fb1.camel@suse.com>
 <CAAMCDeeAQL8yaq2HVE+hFdYv=Ax7aSCn0gqKEW2AV-jzzN9esg@mail.gmail.com>
 <cf398b5ccefd3a1a6f458ab5e4811f8f6afc415c.camel@suse.com>
 <CAAMCDeeUkfetN6ABUcDTU29m0yR1gv7UPh8_2HtLg_ZPBougXg@mail.gmail.com>
User-Agent: Evolution 3.46.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-12-02 at 18:00 -0600, Roger Heflin wrote:
> One of the Enterprise 7 variants, Claims "0.4.9" multipath but
> appears to have a number of recent features backported, so some
> frankensteined version.
>=20
> On Fri, Dec 2, 2022 at 5:50 PM Martin Wilck <mwilck@suse.com> wrote:
> > On Fri, 2022-12-02 at 17:44 -0600, Roger Heflin wrote:
> > > Thanks.
> > >=20
> > > The older distribution I checked has this for -T
> > > =A0 =A0=A0 -T tm:valid
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 check if tm matches the multipathd config=
uration
> > > timestamp value from /run/multipathd/timestamp If so, return
> > > success
> > > if valid is 1. Otherwise, return failure. If the timestamp
> > > doesn't
> > > match continue with multipath execution.=A0 This option is designed
> > > to
> > > be used with -c by the udev rules.
> >=20
> > Strange, I can't find this anywhere in the sources I know.
> > What distro is this? "multipath -T" in the sense I described has
> > existed since 0.7.7, so for more than 4 years.
> >=20
> > Martin
> >=20

Funny, Ben never told me there was a conflicting option name in RHEL.
I guess it's too late now, as I said, the upstream option has existed
for 4 years.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

