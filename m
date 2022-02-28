Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E232AC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 08:48:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-liV6L_tYP9ibft5CfQwEKQ-1; Mon, 28 Feb 2022 03:48:50 -0500
X-MC-Unique: liV6L_tYP9ibft5CfQwEKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C1981091DA0;
	Mon, 28 Feb 2022 08:48:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A8A683163;
	Mon, 28 Feb 2022 08:48:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 189BB1809C98;
	Mon, 28 Feb 2022 08:48:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21S8mbrZ021701 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 03:48:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3F5161402400; Mon, 28 Feb 2022 08:48:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B9D0141DC2C
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 08:48:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2290C296A602
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 08:48:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-550-Ci8fpy_LPJ6dBYcFoF-eHA-1; Mon, 28 Feb 2022 03:48:31 -0500
X-MC-Unique: Ci8fpy_LPJ6dBYcFoF-eHA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 858611F3A2;
	Mon, 28 Feb 2022 08:48:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 23D2512FC5;
	Mon, 28 Feb 2022 08:48:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id Kd6BBl2MHGJsQwAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 28 Feb 2022 08:48:29 +0000
Message-ID: <ff8030340e30963a1772f43e8bdfb6b610219887.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Jes Sorensen <jsorensen@fb.com>, NeilBrown <neilb@suse.de>
Date: Mon, 28 Feb 2022 09:48:28 +0100
In-Reply-To: <164557016782.28944.17731814770525408828@noble.neil.brown.name>
References: <20220216205914.7575-1-mwilck@suse.com>
	, <164504936873.10228.7361167610237544463@noble.neil.brown.name>
	, <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
	, <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
	, <164548656531.8827.3365536065813085321@noble.neil.brown.name>
	, <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
	<164557016782.28944.17731814770525408828@noble.neil.brown.name>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Coly Li <colyli@suse.com>, Peter Rajnoha <prajnoha@redhat.com>,
	lvm-devel@redhat.com, linux-raid@vger.kernel.org,
	dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-02-23 at 09:49 +1100, NeilBrown wrote:
> 
> But if libdevmapper.h is the best you have, then maybe it'll have to
> do.
> It is up to Jes what he accepts of course.

Jes, have you made up your mind on this patch yet?
Please contact me if you have remarks or questions.

Note that the patch that started this thread is broken; the v2 is
correct. With the v2, I was able to reach 1000 consecutive reboots on
a system with MD on top of multipath that would otherwise hang during
boot about once every 50-100 reboots.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

