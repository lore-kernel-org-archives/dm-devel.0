Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C224DEE020B
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 19:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694632137;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ESt4elgaXgTNgRva2HdKDIu+ixBGGJAhuf3nzRcVhyQ=;
	b=PwnfoAuhCiZkQA6C+0DhyMP7SsXRy16GSMgXplJCCFv9rsCxnJ4wVFuHlOa5ScpnV6cht0
	vieb7tyvi4fF/XdiZIxbKdam3UmH9N1NzLm8x81Qc1jzZrUUqT6Y+2LDi6fN4Wt3oHmr5f
	H9RgrvKvscg9N5HZndT4uMk1r5jw9uY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-jkSNgv46ONCkB8x2UBz6FQ-1; Wed, 13 Sep 2023 15:08:54 -0400
X-MC-Unique: jkSNgv46ONCkB8x2UBz6FQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40399857A9E;
	Wed, 13 Sep 2023 19:08:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 266AF2156721;
	Wed, 13 Sep 2023 19:08:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D8E7519465B5;
	Wed, 13 Sep 2023 19:08:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 58CB819465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 19:07:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA4FA40C200B; Wed, 13 Sep 2023 19:07:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E34A740C2009
 for <dm-devel@redhat.com>; Wed, 13 Sep 2023 19:07:31 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C554A805568
 for <dm-devel@redhat.com>; Wed, 13 Sep 2023 19:07:31 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-4eB7FOqJP_CQglSmTGT-8w-1; Wed,
 13 Sep 2023 15:07:30 -0400
X-MC-Unique: 4eB7FOqJP_CQglSmTGT-8w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 567871F385;
 Wed, 13 Sep 2023 19:07:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 089B613582;
 Wed, 13 Sep 2023 19:07:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id xjcjO28IAmXIZAAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 13 Sep 2023 19:07:27 +0000
Message-ID: <2be32e1cbe3405866c83d9bab79aad159316019f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 13 Sep 2023 21:07:27 +0200
In-Reply-To: <20230913143809.GW7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-23-mwilck@suse.com>
 <20230912230048.GR7412@octiron.msp.redhat.com>
 <592dd1bd954e2ccc33e1e0d837421d649fdafdf7.camel@suse.com>
 <20230913143809.GW7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 22/37] libmultipath: sort aliases by
 length and strcmp
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-09-13 at 09:38 -0500, Benjamin Marzinski wrote:
> On Wed, Sep 13, 2023 at 03:53:25PM +0200, Martin Wilck wrote:
> > On Tue, 2023-09-12 at 18:00 -0500, Benjamin Marzinski wrote:
> > > On Mon, Sep 11, 2023 at 06:38:31PM +0200, mwilck@suse.com=A0wrote:
> > > > + */
> > > > +static int alias_compar(const void *p1, const void *p2)
> > > > +{
> > >=20
> > > I'm confused as to why we need to pass p1 and p2 and pointers to
> > > pointers to chars, instead of simply as pointers to chars. We
> > > always
> > > derefence them immediately, and only use the dereferenced
> > > pointers.
> > > Am I
> > > missing something?
> >=20
> > I wanted to make the relationship of alias_compar() and
> > mp_alias_compar() as obvious as possible. mp_alias_compar() takes=20
> > (struct mpentry **) arguments, because it's used as an argument to
> > vector_sort() aka msort(), which has the same calling convention as
> > qsort()'s "compar" argument. Therefore I wrote alias_compar() such
> > that
> > it takes (char **) pointers. This way we could use alias_compar()
> > as an
> > argument to vector_sort() as well, even though we currently don't.
> >=20
> >=20
> > Does this make sense? If not, I can change it, but I think the
> > function
> > should not be named alias_compar() if it can't be passed to
> > vector_sort().
>=20
> It's fine as it is. I was just confused as to why.

Can I take this as a reviewed-by?

Thanks,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

