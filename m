Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB8EC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 14 Dec 2022 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671031747;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8TKLA8GZAXo4L76EMl19z2VEWpS4+Bq4a+F2jMZM2cQ=;
	b=TLtJVqJFWQI9PmHU1eTOFTFIET3EygdOB75ZsL6wLAJ+2KOPn9vzdrwzeDfkzGVwadYXSl
	u2Hl/fj2i4jw7/J7oTm+X94L88iQCPLfmeUoLcBb/Kl5dcgk2rplQZWFO0DdLL7ULNvfOH
	UZs41SQatq+qabnB8i0AI3hMiEKU1dA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-Oc8M9M1EMC-unDcGOED4jQ-1; Wed, 14 Dec 2022 10:29:04 -0500
X-MC-Unique: Oc8M9M1EMC-unDcGOED4jQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E91A6811E9C;
	Wed, 14 Dec 2022 15:29:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 875B014171BE;
	Wed, 14 Dec 2022 15:29:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E75A1946A41;
	Wed, 14 Dec 2022 15:29:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E338619465B9
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Dec 2022 15:28:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C52302026D76; Wed, 14 Dec 2022 15:28:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8BCC2026D68;
 Wed, 14 Dec 2022 15:28:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BEFSvNb013119;
 Wed, 14 Dec 2022 09:28:57 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BEFSuvQ013118;
 Wed, 14 Dec 2022 09:28:56 -0600
Date: Wed, 14 Dec 2022 09:28:56 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20221214152856.GB6245@octiron.msp.redhat.com>
References: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
 <1670974567-8005-2-git-send-email-bmarzins@redhat.com>
 <2329a2afe95f32ba6520932cdf32c510980b6a88.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <2329a2afe95f32ba6520932cdf32c510980b6a88.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 1/3] libmpathutil: simplify set_value
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 14, 2022 at 09:19:45AM +0000, Martin Wilck wrote:
> On Tue, 2022-12-13 at 17:36 -0600, Benjamin Marzinski wrote:
> > alloc_strvec() will never create a strvec with multiple tokens
> > between
> > the quote tokens.=A0 Verify this in validate_config_strvec(), and
> > simplify
> > set_value() by only reading one value after a quote token.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> One suggestion below
>=20
>=20
> > @@ -496,6 +470,10 @@ validate_config_strvec(vector strvec, const char
> > *file)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (VECTOR_SIZE(strvec) > i + 1)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ignoring extra data
> > starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, (i
> > + 1)), line_nr, file);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (i > 3) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* There should only ever be one token
> > between quotes */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "parsing error starting with '%s'
> > on line %d of %s", str, line_nr, file);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "missing closing quotes on line %d o=
f %s",
>=20
> This could be further simplified. We know that strvec[1] is a quote. So
> the only valid possibilities are
>=20
>  - strvec[2] is a quote (-> empty string)
>  - strvec[2] is not a quote and strvec[3] is a quote
>=20
> The code would be better understandable if we just spell out these
> possibilities rather than using a loop that start at 2 and is left at 3
> already.

Makes sense.

-Ben

>=20
> Martin
>=20
>=20
>=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

