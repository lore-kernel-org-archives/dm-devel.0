Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D16EE57DF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694443686;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WjZ5CzGQPa5Fukuhr+EjPMK0Y2WCYNzJQuEUM0upDeY=;
	b=N96IANBd895S0bicX81NV6zH2gbL1qx3CTUkctohlqZKDgPIWvE1ncXP8jDihUY9yOAcbC
	R1YGbclRCKDA/qr8+H3QbEsYdtN2KLq+23MzzjIqKzPvwy6Gd72lX5J7mUF7xeeHkfH9iy
	tLWxYU+spicUDMdj8aqUE/K3IVhbVvI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-D5MRu-eUNS2GYm6U0_I9vw-1; Mon, 11 Sep 2023 10:48:02 -0400
X-MC-Unique: D5MRu-eUNS2GYm6U0_I9vw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDA0F381BE85;
	Mon, 11 Sep 2023 14:47:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 586D440C2064;
	Mon, 11 Sep 2023 14:47:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2AAC219465A2;
	Mon, 11 Sep 2023 14:47:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C489A1946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 14:47:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9CB4240C6EC1; Mon, 11 Sep 2023 14:47:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 84E1640C6EBF;
 Mon, 11 Sep 2023 14:47:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38BElluM022486;
 Mon, 11 Sep 2023 09:47:47 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38BElfW9022485;
 Mon, 11 Sep 2023 09:47:41 -0500
Date: Mon, 11 Sep 2023 09:47:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230911144741.GK7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-19-mwilck@suse.com>
 <20230906224708.GC7412@octiron.msp.redhat.com>
 <5cef84987794cc449028055a63c522c1ea690738.camel@suse.com>
 <20230907191404.GG7412@octiron.msp.redhat.com>
 <20230907200257.GH7412@octiron.msp.redhat.com>
 <97ae2fd39a6f927441ebb861bf62d2e1a3223b9b.camel@suse.com>
 <20230908172215.GI7412@octiron.msp.redhat.com>
 <3bfcf097c6c1f770da4ba0d80d2a06a2d131fd79.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <3bfcf097c6c1f770da4ba0d80d2a06a2d131fd79.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 18/21] libmultipath: keep bindings in memory
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2023 at 08:25:05AM +0200, Martin Wilck wrote:
> On Fri, 2023-09-08 at 12:22 -0500, Benjamin Marzinski wrote:
> > On Thu, Sep 07, 2023 at 10:43:27PM +0200, Martin Wilck wrote:=A0
> > > Our bindings list is now partially sorted, which is an improvement
> > > wrt
> > > the previous situation. "missing the gap" is not really an awful
> > > problem [*]. Perhaps we could postpone this for after this patch
> > > set,
> > > and give it some more time to sink in?
> >=20
> > Yep. I'm fine with going ahead with this patchset as it is. Both
> > sorting
> > the bindings in alias order and updating the bindings if
> > /etc/multipath/bindings has changed are things that can get looked at
> > afterwards. And I'm fine with doing this work, if you want.
>=20
> It so happens that, by sudden inspiration, I've found an elegant
> solution to this problem (I think). We can take advantage of the fact
> that, for any given prefix, aliases with shorter string length will be
> sorted before longer ones ("mpathz" < "mpathaa"). By sorting the
> aliases by string length, and use alphabetical sorting only for strings
> of equal length, we obtain total ordering for any given prefix. This
> works for any number of different prefixes, and even if some prefixes
> are substrings of others. In the ordered list, the aliases with a given
> prefix will not necessarily be in a contiguous block, but that doesn't
> matter.=A0For every prefix, the sub-list of aliases starting with that
> prefix is cleanly ordered. This way we avoid the complexity to have to
> parse or compare configured prefixes.

Clever. That seems like a good solution.

-Ben=20

>=20
> I'll post a new patch set with this ordering scheme hopefully later
> today.
>=20
> Regards,
> Martin
>=20
> >=20
> > -Ben
> > =A0
> > > Martin
> > >=20
> > > [*] I admit that with my patch, we _know_ now that the bindings
> > > list
> > > will be sub-optimally sorted as soon as mpathaa is reached, whereas
> > > before the ordering might be perfect even with a large number of
> > > aliases, depending on the history of the bindings file. That's not
> > > a
> > > change for the better; it will cause the gap to be missed in some
> > > situations where we don't miss it now. I am not sure how bad this
> > > is.
> >=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

