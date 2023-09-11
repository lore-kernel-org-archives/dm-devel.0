Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D142CEE57DF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 06:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694413521;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QEgHYkCcRcR4l2FlpRhzoncY7Gu5VMIjQiXz0zkabyo=;
	b=CUPGkYXcUR25EiJALukWQf9KeBI6NfETti2s/jsZnWvOR1QaMu2IampMTX7arHViya6LRO
	WMA3XKZ0t9vRWKHVDWFLSnhBqDqU6kfClvbFRSSbjPTAvOxMRbS87mhDpd3CndPieAQ3Ku
	5tRjxXIOHZTY5P0eB1OtOmHnjOjud9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-iJyAn80nME-97toJcnFNWQ-1; Mon, 11 Sep 2023 02:25:18 -0400
X-MC-Unique: iJyAn80nME-97toJcnFNWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F04E101FABA;
	Mon, 11 Sep 2023 06:25:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AD7940C2064;
	Mon, 11 Sep 2023 06:25:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0319D1946597;
	Mon, 11 Sep 2023 06:25:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF8E31946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 06:25:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B779E492B05; Mon, 11 Sep 2023 06:25:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B03B8492C37
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 06:25:11 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A62A3C02B64
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 06:25:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-4GpF3dwnPKuVNBNm2EmOSw-1; Mon,
 11 Sep 2023 02:25:08 -0400
X-MC-Unique: 4GpF3dwnPKuVNBNm2EmOSw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 8E1461F460;
 Mon, 11 Sep 2023 06:25:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6717213780;
 Mon, 11 Sep 2023 06:25:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id MzeBF8Ky/mSNRAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 06:25:06 +0000
Message-ID: <3bfcf097c6c1f770da4ba0d80d2a06a2d131fd79.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 08:25:05 +0200
In-Reply-To: <20230908172215.GI7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-19-mwilck@suse.com>
 <20230906224708.GC7412@octiron.msp.redhat.com>
 <5cef84987794cc449028055a63c522c1ea690738.camel@suse.com>
 <20230907191404.GG7412@octiron.msp.redhat.com>
 <20230907200257.GH7412@octiron.msp.redhat.com>
 <97ae2fd39a6f927441ebb861bf62d2e1a3223b9b.camel@suse.com>
 <20230908172215.GI7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-09-08 at 12:22 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 07, 2023 at 10:43:27PM +0200, Martin Wilck wrote:=A0
> > Our bindings list is now partially sorted, which is an improvement
> > wrt
> > the previous situation. "missing the gap" is not really an awful
> > problem [*]. Perhaps we could postpone this for after this patch
> > set,
> > and give it some more time to sink in?
>=20
> Yep. I'm fine with going ahead with this patchset as it is. Both
> sorting
> the bindings in alias order and updating the bindings if
> /etc/multipath/bindings has changed are things that can get looked at
> afterwards. And I'm fine with doing this work, if you want.

It so happens that, by sudden inspiration, I've found an elegant
solution to this problem (I think). We can take advantage of the fact
that, for any given prefix, aliases with shorter string length will be
sorted before longer ones ("mpathz" < "mpathaa"). By sorting the
aliases by string length, and use alphabetical sorting only for strings
of equal length, we obtain total ordering for any given prefix. This
works for any number of different prefixes, and even if some prefixes
are substrings of others. In the ordered list, the aliases with a given
prefix will not necessarily be in a contiguous block, but that doesn't
matter.=A0For every prefix, the sub-list of aliases starting with that
prefix is cleanly ordered. This way we avoid the complexity to have to
parse or compare configured prefixes.

I'll post a new patch set with this ordering scheme hopefully later
today.

Regards,
Martin

>=20
> -Ben
> =A0
> > Martin
> >=20
> > [*] I admit that with my patch, we _know_ now that the bindings
> > list
> > will be sub-optimally sorted as soon as mpathaa is reached, whereas
> > before the ordering might be perfect even with a large number of
> > aliases, depending on the history of the bindings file. That's not
> > a
> > change for the better; it will cause the gap to be missed in some
> > situations where we don't miss it now. I am not sure how bad this
> > is.
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

