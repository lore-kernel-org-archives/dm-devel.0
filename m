Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CB0C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 09:31:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-P2Dp2ZA2OXu0bU9RDmEl9A-1; Tue, 22 Mar 2022 05:31:00 -0400
X-MC-Unique: P2Dp2ZA2OXu0bU9RDmEl9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 791963801EC8;
	Tue, 22 Mar 2022 09:30:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2048B140241B;
	Tue, 22 Mar 2022 09:30:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9D50F1949762;
	Tue, 22 Mar 2022 09:30:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4AFF81947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 09:30:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC73C140241B; Tue, 22 Mar 2022 09:30:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7A7E141DEF9
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 09:30:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF11F3C1EA41
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 09:30:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-taCw3vzhMdWs36McGyx3yw-1; Tue, 22 Mar 2022 05:30:52 -0400
X-MC-Unique: taCw3vzhMdWs36McGyx3yw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 93D9E1F390;
 Tue, 22 Mar 2022 09:30:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5CCCB12FC5;
 Tue, 22 Mar 2022 09:30:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Gde1FEqXOWIrDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 22 Mar 2022 09:30:50 +0000
Message-ID: <e86df86dc511e0092e15da399e2e713561fb13c9.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 22 Mar 2022 10:30:49 +0100
In-Reply-To: <CAPt1nt4Ug=Z0mn1TUzmKevYqm3Uqy-sGXBc9rQRdZUgHFi3i9g@mail.gmail.com>
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-12-mwilck@suse.com>
 <CAPt1nt4Ug=Z0mn1TUzmKevYqm3Uqy-sGXBc9rQRdZUgHFi3i9g@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH v2 11/11] multipathd: remove unhelpful
 startup / shutdown messages
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-03-21 at 19:43 -0500, Benjamin Marzinski wrote:
> On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
> >=20
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > These messages are noisy in the system log without being actually
> > helpful.
>=20
> I've actually found the "start up" and "shut down" messages useful a
> number of times, for tracking when multipathd starts up and shuts
> down.=A0

Makes sense ;-)

Currently we see the following messages for multipathd startup and
shutdown:

Mar 11 09:30:00 bremer systemd[1]: Starting Device-Mapper Multipath Device =
Controller.
Mar 11 09:30:01 bremer multipathd[363]: --------start up--------
Mar 11 09:30:01 bremer systemd[1]: Started Device-Mapper Multipath Device C=
ontroller.
Mar 11 09:30:01 bremer multipathd[363]: read /etc/multipath.conf
Mar 11 09:30:01 bremer multipathd[363]: path checkers start up
...
Mar 11 09:30:52 bremer systemd[1]: Stopping Device-Mapper Multipath Device =
Controller...
Mar 11 09:30:52 bremer multipathd[363]: exit (signal)
Mar 11 09:30:52 bremer multipathd[363]: --------shut down-------
Mar 11 09:30:52 bremer systemd[1]: Stopped Device-Mapper Multipath Device C=
ontroller.

To my taste, this is too much. Of course, not everyone is using
systemd. Without systemd and with the part of my patch you acked, we'd
be down from 9 to 3 messages. IMO either the "exit" message or the
"shut down" message could be hidden at -v2. I suppose we could decrease
the verbosity level of handle_signals() to -v3 instead. Would you agree
with that?

> Since people generally run multipathd constantly, they rarely
> appear more than a couple of times per boot. I would prefer if they
> could stay.=A0 I'm fine with removing the others.

Ok, fine with me. Do you insist on the "--------", too? It's mainly
that which bothers me. If you look at the typical boot messages of
contemporary Linux servers, no other daemon uses this strong emphasis
for an informational message. The informational value would be higher
if we printed a detailed version number including HEAD commit ID, like
other daemons do.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

