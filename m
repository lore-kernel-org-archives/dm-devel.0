Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B06EC8733
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 14:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694096602;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dHpzaZm5/O5itcZYQ6cXLB3LVsjnb3UHOQq0Lbl1RBU=;
	b=YfjMTsYo51EJstNCQPOeCuULXRF0dmON47OEDDzxCP6htfqP4rauQiBqBelnnGWAMgc62E
	W84Og4RIlOIpyjPKxVAQwjk6IFUjFSFKSIJM83QSfIHj1bnxlRx1EtZoIPX7R4HvgS7dyp
	sPhdsjVtdTLYf+LBGhDoJwN8Gh7ZpyY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-Gh690YkIOxKXC_-j-E-hYg-1; Thu, 07 Sep 2023 10:23:18 -0400
X-MC-Unique: Gh690YkIOxKXC_-j-E-hYg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CA4580523C;
	Thu,  7 Sep 2023 14:23:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D16F7493110;
	Thu,  7 Sep 2023 14:23:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D1D0194658F;
	Thu,  7 Sep 2023 14:23:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B5DAF194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 14:23:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1CD421EE56B; Thu,  7 Sep 2023 14:23:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A1A921EE566
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 14:23:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 750F62820524
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 14:23:13 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-118LH9j7O6unfVJ_KZnz-Q-1; Thu,
 07 Sep 2023 10:22:54 -0400
X-MC-Unique: 118LH9j7O6unfVJ_KZnz-Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id CA7821F8AE;
 Thu,  7 Sep 2023 14:22:34 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B324138F9;
 Thu,  7 Sep 2023 14:22:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id HKQtJKrc+WTbWQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 07 Sep 2023 14:22:34 +0000
Message-ID: <3660a822f53efbeab83dbdf19b035c6a40c86163.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 07 Sep 2023 16:22:33 +0200
In-Reply-To: <15ea4cca19b287bab47bd212218cb66bad0acdda.camel@suse.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-5-mwilck@suse.com>
 <20230906224248.GO7412@octiron.msp.redhat.com>
 <9948d7855eba709714b5b487240e44a309288f07.camel@suse.com>
 <15ea4cca19b287bab47bd212218cb66bad0acdda.camel@suse.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 04/21] libmultipath: never allocate an alias
 that's already taken
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
Cc: dm-devel@redhat.com, David Bond <dbond@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-09-07 at 15:33 +0200, Martin Wilck wrote:
> On Thu, 2023-09-07 at 09:24 +0200, Martin Wilck wrote:
> > On Wed, 2023-09-06 at 17:42 -0500, Benjamin Marzinski wrote:
> > > On Fri, Sep 01, 2023 at 08:02:17PM +0200, mwilck@suse.com=A0wrote:
> > >=20
> > >=20
> > > Again, unless I'm overlooking something, I don't think we need to
> > > check if the alias is already taken here. Since we know that a
> > > device
> > > already exists with alias_old and the correct WWID, as long as
> > > alias_old
> > > is a valid user_friendly_name we can just use it.
> >=20
> > Similar reasoning as above. We could perhaps remove these checks,
> > but
> > we'd need to replace them by comments explaining why this condition
> > can't occur.
> >=20
> > We could (and maybe should) move the call to find_existing_alias()
> > from
> > add_map_with_path() to get_user_friendly_alias(), so that we have
> > the
> > entire alias logic in a single place. The mpp->alias_old field
> > would
> > then only be used for ACT_RENAME.
>=20
> Well, if we do this, we would need to pass vecs->mpvec to
> get_user_friendly_alias(), which means that we could use it also for
> the alias_already_taken() check. It's not exactly the same because in
> one case we look at internal state and in the other case at kernel
> state. OTOH, we do trust that the two are in agreement, right? And we
> derive alias_old from the mpvec today, anyway.

Ok, this doesn't work. The kernel device mapper mandates no naming
conventions for map aliases / names, except that they're unique.
The mpvec contains only aliases of multipath maps. But it's not
forbidden that some non-multipath map be called "mpathc".

OTOH, if we have positive evidence that a given WWID has an alias
mpathX assigned, we do know that no other map can have this same name.
It just comes down to whether we trust the mpvec to correctly represent
kernel state, and I suppose we have to, anyway.

Sorry for the spam. I'll just remove these these checks, and the
corresponding test cases.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

