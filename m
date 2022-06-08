Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7E3C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 07:58:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-L9PAy7P7MDSIvyFki1nkhA-1; Wed, 08 Jun 2022 03:58:28 -0400
X-MC-Unique: L9PAy7P7MDSIvyFki1nkhA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BD533C02B6C;
	Wed,  8 Jun 2022 07:58:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29E4A2026D64;
	Wed,  8 Jun 2022 07:58:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E9103194704C;
	Wed,  8 Jun 2022 07:58:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7CBF81947042
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 07:58:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FFBF2166B29; Wed,  8 Jun 2022 07:58:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B9042166B26
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:58:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20E233C02B6C
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:58:24 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-MBdD5DCjM0-NFM4OQJy5Ew-1; Wed, 08 Jun 2022 03:58:20 -0400
X-MC-Unique: MBdD5DCjM0-NFM4OQJy5Ew-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 0E2971F892;
 Wed,  8 Jun 2022 07:58:19 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C47C113AD9;
 Wed,  8 Jun 2022 07:58:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id XZZULppWoGJSKwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 08 Jun 2022 07:58:18 +0000
Message-ID: <1b00794e0d3d195fa1f099b0f8dc44846c2db66e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Steven Schremmer
 <Steve.Schremmer@netapp.com>
Date: Wed, 08 Jun 2022 09:58:18 +0200
In-Reply-To: <20220607223240.GV5254@octiron.msp.redhat.com>
References: <20220531203905.28702-1-mwilck@suse.com>
 <20220607223240.GV5254@octiron.msp.redhat.com>
User-Agent: Evolution 3.44.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] multipath.conf(5): add disclaimer about
 vendor support
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-06-07 at 17:32 -0500, Benjamin Marzinski wrote:
> On Tue, May 31, 2022 at 10:39:05PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Steve, does this address NetApp's concerns properly?

Regards
Martin


>=20
> >=20
> > Add a disclaimer to clarify that entries in the hwtable don't imply
> > any
> > obligations on the vendor's part.
> > ---
> > =A0multipath/multipath.conf.5 | 12 ++++++++++++
> > =A01 file changed, 12 insertions(+)
> >=20
> > diff --git a/multipath/multipath.conf.5
> > b/multipath/multipath.conf.5
> > index d57c810..c2d34f1 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -1490,6 +1490,18 @@ section:
> > =A0.SH "devices section"
> > =A0.\" --------------------------------------------------------------
> > --------------
> > =A0.
> > +.TP 4
> > +.B Important:
> > +The built-in hardware device table of
> > +.I multipath-tools
> > +is created by members of the Linux community in the hope that it
> > will be useful.
> > +The existence of an entry for a given storage product in the
> > hardware table
> > +.B does not imply
> > +that the product vendor supports, or has tested, the product with
> > +.I multipath-tools
> > +in any way.
> > +.B Always consult the vendor\(aqs official documentation for
> > support-related information.
> > +.PP
> > =A0\fImultipath-tools\fR have a built-in device table with reasonable
> > defaults
> > =A0for more than 100 known multipath-capable storage devices. The
> > devices section
> > =A0can be used to override these settings. If there are multiple
> > matches for a
> > --=20
> > 2.36.1
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

