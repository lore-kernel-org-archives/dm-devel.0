Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A301C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 08:07:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-LNj_7zv5NZKuCjv4A77zjQ-1; Thu, 28 Apr 2022 04:07:46 -0400
X-MC-Unique: LNj_7zv5NZKuCjv4A77zjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D3FF3C172CC;
	Thu, 28 Apr 2022 08:07:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7577714A4F80;
	Thu, 28 Apr 2022 08:07:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F6A91947051;
	Thu, 28 Apr 2022 08:07:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8DEED1947047
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 08:07:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7D81914A4F88; Thu, 28 Apr 2022 08:07:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79E9D14A4F80
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:07:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60E553804069
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:07:41 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-dNGz3xftNOKVUq6RbWYrxQ-1; Thu, 28 Apr 2022 04:07:39 -0400
X-MC-Unique: dNGz3xftNOKVUq6RbWYrxQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 20EA41F88A;
 Thu, 28 Apr 2022 08:07:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E6C8913AF8;
 Thu, 28 Apr 2022 08:07:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id JImbNklLamLJIwAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 28 Apr 2022 08:07:37 +0000
Message-ID: <1764112fec427e26bcc1304c55896277d0c11117.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Martin =?UTF-8?Q?Li=C5=A1ka?= <mliska@suse.cz>, dm-devel@redhat.com
Date: Thu, 28 Apr 2022 10:07:37 +0200
In-Reply-To: <568d96f5-470d-8d46-cfb7-10411cde3e9f@suse.cz>
References: <ecddb51d-7666-b18b-f295-58fc0397b4c7@suse.cz>
 <b002e110e01345eaee7ad46187fa2b1980faa275.camel@suse.com>
 <568d96f5-470d-8d46-cfb7-10411cde3e9f@suse.cz>
User-Agent: Evolution 3.44.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH][V2] Fix possibility to redefine
 -D_FORTIFY_SOURCE macro.
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Martin L,

On Thu, 2022-04-28 at 08:54 +0200, Martin Li=A8ka wrote:
> On 4/12/22 22:24, Martin Wilck wrote:
> > On Tue, 2022-04-12 at 13:19 +0200, Martin Li=A8ka wrote:
> > > As explained here:
> > > https://github.com/opensvc/multipath-tools/issues/29
> > >=20
> > > using -Wp,-D_FORTIFY_SOURCE cannot be redefined with
> > > -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3D3.
> > >=20
> > > Signed-off-by: Martin Liska <mliska@suse.cz>
> >=20
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> >=20
> >=20
>=20
> Hi.
>=20
> May I please ping this?
>=20

I told you this is in the "queue" branch in openSUSE/multipath-tools,
which means it's going to be merged in the next official release. The
main repository at opensvc [2] is only updated in batches, when a new
"release" is made. We haven't decided on the timing for the next batch.
There isn't much blocking it, so it should be possible to do it
relatively soon, as time allows. Maybe next week (no promises).

In the meantime, use my "queue" branch, which represents the "rolling
release" of multipath tools and will most probably just be merged into
the main repo as-is, or simply apply your patch before building.


[1] https://github.com/openSUSE/multipath-tools/tree/queue
[2] https://github.com/opensvc/multipath-tools

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

