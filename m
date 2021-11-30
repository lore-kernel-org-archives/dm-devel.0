Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A22C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 20:29:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-uImwBIuPMtughViwGLRrHA-1; Tue, 30 Nov 2021 15:29:07 -0500
X-MC-Unique: uImwBIuPMtughViwGLRrHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 082CD192CC40;
	Tue, 30 Nov 2021 20:29:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CEF705D740;
	Tue, 30 Nov 2021 20:29:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0D4DB4A7C8;
	Tue, 30 Nov 2021 20:29:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUKSFjX025063 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 15:28:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 84EF01121315; Tue, 30 Nov 2021 20:28:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80C191121314
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 20:28:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7B40185A7BA
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 20:28:12 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-90-dsdXPd0XN5aBSWM-Nd1g7w-1; Tue, 30 Nov 2021 15:28:08 -0500
X-MC-Unique: dsdXPd0XN5aBSWM-Nd1g7w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 61A271FD58;
	Tue, 30 Nov 2021 20:28:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C8B213D71;
	Tue, 30 Nov 2021 20:28:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id oKBTBFeJpmFMWAAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 30 Nov 2021 20:28:07 +0000
Message-ID: <c6893070dd0d70420104ed071f7f45a365bd7faf.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 30 Nov 2021 21:28:06 +0100
In-Reply-To: <20211130165251.GK19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
	<20211124204118.GP19591@octiron.msp.redhat.com>
	<52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
	<20211129192729.GD19591@octiron.msp.redhat.com>
	<d9260ceb655395864041a5037bac5aab6f722cf0.camel@suse.com>
	<20211130165251.GK19591@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 03/48] libmultipath: add optional wakeup
 functionality to lock.c
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2021-11-30 at 10:52 -0600, Benjamin Marzinski wrote:
> On Mon, Nov 29, 2021 at 09:52:49PM +0100, Martin Wilck wrote:
> > I agree. Also, I realize that we've bumped the library version too
> > often in the past. If we add a function, we don't need to bump.
> > Because
> > a program that needs the added function will require e.g.
> > foo@LIBMULTIPATH_10.0.0, and this will fail for a library that
> > doesn't
> > export foo (which is what we want). Likewise for function deletion
> > - a
> > program that calls the deleted function will fail to link with the
> > updated library. OTOH, programs that use this version of the ABI
> > *without* using the functions which are added or removed are
> > unaffected
> > by the addition / removal.
> > 
> > The only case in which the ABI version must be bumped is when we
> > have
> > changed functions or data structures.
> > 
> > Furthermore, I believe now that the habit (which I introduced) to
> > list
> > added functions at the end of the .version files, with comments
> > indicating when they were added, is useless. We should rather keep
> > the
> > .version file ordered alphabetically.
> 
> So we not use the minor version anymore? 

Perhaps we'll encounter another use case for it, or we find a flaw in
my reasoning above. I wouldn't remove the digit.

We could e.g. bump the minor version in an official release if there
are only minor ABI changes wrt the previous official release.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

