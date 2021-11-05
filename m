Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84150C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 17:35:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C133603E9
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 17:35:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C133603E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636133717;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rrzOvv9ALI408CvLto4WFFZvVnT63v6kQu1r0atuU10=;
	b=TEsCgP90Zs/hSrM+596ay+cUo6lO4dqeTRvCWLc689TjA5LAwIzWyGBiTCdwcqcV6I/nZs
	dtix1vUoFopAjnApI+oz5VzQYOYdAWjzcBeIMwn4Rz+HeATRNO438lYVf350GgrHBBEGeW
	4OMimd8gPZ6NvlNDaWxW+XgnVUBm/Ys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-g8D76oFVNPG8j7Iqiv87ww-1; Fri, 05 Nov 2021 13:35:13 -0400
X-MC-Unique: g8D76oFVNPG8j7Iqiv87ww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7F778799F5;
	Fri,  5 Nov 2021 17:35:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2301650B63;
	Fri,  5 Nov 2021 17:35:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A70211818480;
	Fri,  5 Nov 2021 17:35:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5HZ2hf006743 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 13:35:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1F4EF1054FF5; Fri,  5 Nov 2021 17:35:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C99F10429EC;
	Fri,  5 Nov 2021 17:34:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A5HYhgx011763; 
	Fri, 5 Nov 2021 12:34:43 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A5HYgWV011762;
	Fri, 5 Nov 2021 12:34:42 -0500
Date: Fri, 5 Nov 2021 12:34:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211105173442.GH19591@octiron.msp.redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-6-git-send-email-bmarzins@redhat.com>
	<5a3077f3cf5fd24e25fffd1690ca7afceec7ec46.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <5a3077f3cf5fd24e25fffd1690ca7afceec7ec46.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/8] libmultipath: make set_int take a range
 for valid values
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2021 at 08:34:33PM +0000, Martin Wilck wrote:
> On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > If a value outside of the valid range is passed to set_int, it caps
> > the
> > value at appropriate limit, and issues a warning.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> One nitpick below.
>=20
> It's a lot of code changes for just two cases where we have nontrivial
> values for min and max. I guess for uint the count of nontrivial cases
> was zero?

Yeah. all the uint cases accepted the entire UINT range.  As you've
seen, I end up using the int range checking for more functions later.
=20
> Yet it's an improvement, so I'm going to ack when the nit is fixed.
>=20
> Martin
>=20
>=20
>=20
> > ---
> > =A0libmultipath/dict.c | 121 +++++++++++++++++++++++++++---------------
> > --
> > =A01 file changed, 75 insertions(+), 46 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index eb2c44c0..1758bd26 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > ...
> > @@ -298,7 +347,7 @@ declare_def_snprint(checkint, print_int)
> > =A0declare_def_handler(max_checkint, set_uint)
> > =A0declare_def_snprint(max_checkint, print_int)
> > =A0
> > -declare_def_handler(verbosity, set_int)
> > +declare_def_range_handler(verbosity, 0, 4)
>=20
> You should use MAX_VERBOSITY here.

Sure.

-Ben

>=20
> > =A0declare_def_snprint(verbosity, print_int)
> > =A0
> > =A0declare_def_handler(reassign_maps, set_yes_no)
> > @@ -473,22 +522,22 @@ declare_ovr_snprint(checker_name, print_str)
> > =A0declare_hw_handler(checker_name, set_str)
> > =A0declare_hw_snprint(checker_name, print_str)
> > =A0
> > -declare_def_handler(minio, set_int)
> > +declare_def_range_handler(minio, 0, INT_MAX)
> > =A0declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
> > -declare_ovr_handler(minio, set_int)
> > +declare_ovr_range_handler(minio, 0, INT_MAX)
> > =A0declare_ovr_snprint(minio, print_nonzero)
> > -declare_hw_handler(minio, set_int)
> > +declare_hw_range_handler(minio, 0, INT_MAX)
> > =A0declare_hw_snprint(minio, print_nonzero)
> > -declare_mp_handler(minio, set_int)
> > +declare_mp_range_handler(minio, 0, INT_MAX)
> > =A0declare_mp_snprint(minio, print_nonzero)
> > =A0
> > -declare_def_handler(minio_rq, set_int)
> > +declare_def_range_handler(minio_rq, 0, INT_MAX)
> > =A0declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
> > -declare_ovr_handler(minio_rq, set_int)
> > +declare_ovr_range_handler(minio_rq, 0, INT_MAX)
> > =A0declare_ovr_snprint(minio_rq, print_nonzero)
> > -declare_hw_handler(minio_rq, set_int)
> > +declare_hw_range_handler(minio_rq, 0, INT_MAX)
> > =A0declare_hw_snprint(minio_rq, print_nonzero)
> > -declare_mp_handler(minio_rq, set_int)
> > +declare_mp_range_handler(minio_rq, 0, INT_MAX)
> > =A0declare_mp_snprint(minio_rq, print_nonzero)
> > =A0
> > =A0declare_def_handler(queue_without_daemon, set_yes_no)
> > @@ -512,7 +561,7 @@ snprint_def_queue_without_daemon(struct config
> > *conf, struct strbuf *buff,
> > =A0=A0=A0=A0=A0=A0=A0=A0return append_strbuf_quoted(buff, qwd);
> > =A0}
> > =A0
> > -declare_def_handler(checker_timeout, set_int)
> > +declare_def_range_handler(checker_timeout, 0, INT_MAX)
> > =A0declare_def_snprint(checker_timeout, print_nonzero)
> > =A0
> > =A0declare_def_handler(allow_usb_devices, set_yes_no)
> > @@ -583,13 +632,13 @@ declare_hw_snprint(deferred_remove,
> > print_yes_no_undef)
> > =A0declare_mp_handler(deferred_remove, set_yes_no_undef)
> > =A0declare_mp_snprint(deferred_remove, print_yes_no_undef)
> > =A0
> > -declare_def_handler(retrigger_tries, set_int)
> > +declare_def_range_handler(retrigger_tries, 0, INT_MAX)
> > =A0declare_def_snprint(retrigger_tries, print_int)
> > =A0
> > -declare_def_handler(retrigger_delay, set_int)
> > +declare_def_range_handler(retrigger_delay, 0, INT_MAX)
> > =A0declare_def_snprint(retrigger_delay, print_int)
> > =A0
> > -declare_def_handler(uev_wait_timeout, set_int)
> > +declare_def_range_handler(uev_wait_timeout, 0, INT_MAX)
> > =A0declare_def_snprint(uev_wait_timeout, print_int)
> > =A0
> > =A0declare_def_handler(strict_timing, set_yes_no)
> > @@ -616,19 +665,19 @@ static int
> > snprint_def_disable_changed_wwids(struct config *conf,
> > =A0=A0=A0=A0=A0=A0=A0=A0return print_ignored(buff);
> > =A0}
> > =A0
> > -declare_def_handler(remove_retries, set_int)
> > +declare_def_range_handler(remove_retries, 0, INT_MAX)
> > =A0declare_def_snprint(remove_retries, print_int)
> > =A0
> > -declare_def_handler(max_sectors_kb, set_int)
> > +declare_def_range_handler(max_sectors_kb, 0, INT_MAX)
> > =A0declare_def_snprint(max_sectors_kb, print_nonzero)
> > -declare_ovr_handler(max_sectors_kb, set_int)
> > +declare_ovr_range_handler(max_sectors_kb, 0, INT_MAX)
> > =A0declare_ovr_snprint(max_sectors_kb, print_nonzero)
> > -declare_hw_handler(max_sectors_kb, set_int)
> > +declare_hw_range_handler(max_sectors_kb, 0, INT_MAX)
> > =A0declare_hw_snprint(max_sectors_kb, print_nonzero)
> > -declare_mp_handler(max_sectors_kb, set_int)
> > +declare_mp_range_handler(max_sectors_kb, 0, INT_MAX)
> > =A0declare_mp_snprint(max_sectors_kb, print_nonzero)
> > =A0
> > -declare_def_handler(find_multipaths_timeout, set_int)
> > +declare_def_range_handler(find_multipaths_timeout, INT_MIN, INT_MAX)
> > =A0declare_def_snprint_defint(find_multipaths_timeout, print_int,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 DEFAULT_FIND_MULTIPATHS_TIMEOUT)
> > =A0
> > @@ -1385,27 +1434,7 @@ declare_ovr_snprint(recheck_wwid,
> > print_yes_no_undef)
> > =A0declare_hw_handler(recheck_wwid, set_yes_no_undef)
> > =A0declare_hw_snprint(recheck_wwid, print_yes_no_undef)
> > =A0
> > -
> > -static int
> > -def_uxsock_timeout_handler(struct config *conf, vector strvec, const
> > char *file,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 int line_nr)
> > -{
> > -=A0=A0=A0=A0=A0=A0=A0unsigned int uxsock_timeout;
> > -=A0=A0=A0=A0=A0=A0=A0char *buff;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> > -=A0=A0=A0=A0=A0=A0=A0if (!buff)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (sscanf(buff, "%u", &uxsock_timeout) =3D=3D 1 =
&&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uxsock_timeout > DEFAULT_REPLY_TIMEOUT)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->uxsock_timeout =3D =
uxsock_timeout;
> > -=A0=A0=A0=A0=A0=A0=A0else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->uxsock_timeout =3D =
DEFAULT_REPLY_TIMEOUT;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0free(buff);
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > -}
> > +declare_def_range_handler(uxsock_timeout, DEFAULT_REPLY_TIMEOUT,
> > INT_MAX)
> > =A0
> > =A0static int
> > =A0hw_vpd_vendor_handler(struct config *conf, vector strvec, const char
> > *file,

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

