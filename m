Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D963C43460
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 19:54:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 057E661408
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 19:54:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 057E661408
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620849239;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gsVZXaBQE27Tbn/YCk1a9N2qgrWUySkSjZLa026eWVQ=;
	b=gIBEOc928ximrLHelnJthrFtKVu9c+BIdM3hH5kr9W7koomwUZpKMiMBPqJC3tWvdPmSGa
	bxfpEqTgUiPzRF0LScJbRRcBv5ZgGSZ8k5CHbtmNrpbgq4Js8Fu2sxlBzn5F4Ij0TzKrjF
	5MudYWL7zwSCFw/Lr2UKUu3aR6shjec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-k-mpDJQnP0OSbTV8_lpvSQ-1; Wed, 12 May 2021 15:53:57 -0400
X-MC-Unique: k-mpDJQnP0OSbTV8_lpvSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 735F281840C;
	Wed, 12 May 2021 19:53:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C7265D9C0;
	Wed, 12 May 2021 19:53:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 410A055343;
	Wed, 12 May 2021 19:53:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CJroqV012661 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 15:53:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9626D10023AB; Wed, 12 May 2021 19:53:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2BD110016FC;
	Wed, 12 May 2021 19:53:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14CJrjVp004676; 
	Wed, 12 May 2021 14:53:45 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14CJri2l004675;
	Wed, 12 May 2021 14:53:44 -0500
Date: Wed, 12 May 2021 14:53:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210512195344.GF25887@octiron.msp.redhat.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-5-git-send-email-bmarzins@redhat.com>
	<f186788dcb161fd44859a0c8908c2eb83d3bee0d.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <f186788dcb161fd44859a0c8908c2eb83d3bee0d.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] multipath: free vectors in configure
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, May 12, 2021 at 12:36:42PM +0000, Martin Wilck wrote:
> On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> > configure() can retry multiple times, each time reallocing a maps and
> > paths vector, and leaking the previous ones. Fix this by always
> > freeing
> > the vectors before configure() exits. Found by coverity.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0multipath/main.c | 7 ++++++-
> > =A01 file changed, 6 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/multipath/main.c b/multipath/main.c
> > index ef89c7cf..25c5dbfd 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -466,7 +466,6 @@ configure (struct config *conf, enum mpath_cmds
> > cmd,
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0curmp =3D vector_alloc();
> > =A0=A0=A0=A0=A0=A0=A0=A0pathvec =3D vector_alloc();
> > -=A0=A0=A0=A0=A0=A0=A0atexit(cleanup_vecs);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!curmp || !pathvec) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "can not all=
ocate memory");
> > @@ -578,6 +577,11 @@ out:
> > =A0=A0=A0=A0=A0=A0=A0=A0if (refwwid)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0FREE(refwwid);
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0free_multipathvec(curmp, KEEP_PATHS);
> > +=A0=A0=A0=A0=A0=A0=A0vecs.mpvec =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0free_pathvec(pathvec, FREE_PATHS);
> > +=A0=A0=A0=A0=A0=A0=A0vecs.pathvec =3D NULL;
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0return r;
> > =A0}
> > =A0
> > @@ -1053,6 +1057,7 @@ main (int argc, char *argv[])
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_flush_maps(1, =
retries) ? RTVL_FAIL : RTVL_OK;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0atexit(cleanup_vecs);
> > =A0=A0=A0=A0=A0=A0=A0=A0while ((r =3D configure(conf, cmd, dev_type, de=
v)) =3D=3D
> > RTVL_RETRY)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "restart mul=
tipath configuration
> > process");
> > =A0
>=20
>=20
> Nit: I'd rather move this atexit() call towards the beginning of
> main(), after the other atexit() calls.

Sure.

-Ben

>=20
> Apart from that, ACK.
>=20
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

