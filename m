Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F182DC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 08:40:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-VhQzzQDSMb-fqsOCohe-KQ-1; Tue, 01 Feb 2022 03:40:28 -0500
X-MC-Unique: VhQzzQDSMb-fqsOCohe-KQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04F5384DA48;
	Tue,  1 Feb 2022 08:40:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E52B56A87;
	Tue,  1 Feb 2022 08:40:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6D5A94BB7C;
	Tue,  1 Feb 2022 08:40:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2118eLGi019123 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 03:40:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F11412166B4A; Tue,  1 Feb 2022 08:40:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECAB82166B40
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 08:40:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB6108027FC
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 08:40:17 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-38-Vd0zabBlMCmM98Ufl6efnw-1; Tue, 01 Feb 2022 03:40:14 -0500
X-MC-Unique: Vd0zabBlMCmM98Ufl6efnw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9EF8821117;
	Tue,  1 Feb 2022 08:40:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4AD4B13CE1;
	Tue,  1 Feb 2022 08:40:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 02ZCEOzx+GERVwAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 01 Feb 2022 08:40:12 +0000
Message-ID: <3f7f5039c4529912970f21fe699ad204dfbe5be3.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>
Date: Tue, 01 Feb 2022 09:40:11 +0100
In-Reply-To: <20220131133354.vfomn5gdlgrhue4g@alatyr-rpi.brq.redhat.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
	<1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
	<712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
	<20220131133354.vfomn5gdlgrhue4g@alatyr-rpi.brq.redhat.com>
User-Agent: Evolution 3.42.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Franck Bui <fbui@suse.de>, lvm-devel@redhat.com, dm-devel@redhat.com,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [PATCH] udev: create symlinks and watch even in
	suspended state
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

On Mon, 2022-01-31 at 14:33 +0100, Peter Rajnoha wrote:
> (just discussed this with Zdenek too)
> 
> The patch makes sense to me!
> 
> We added all the DM_UDEV_PRIMARY_SOURCE_FLAG and related for exactly
> such cases where we need to take the existing values already scanned
> in previous event, main use-case being the trigger at boot. We just
> didn't cover the 13-dm-disk.rules with the same logic regarding the
> suspended state to keep the symlinks - I didn't think it would cause
> issues (because, usually, after suspend, we anticipate incoming
> resume where the device is scanned again).
> 
> But yes, if temporarily losing the symlink causes issues, your patch
> solves that (Zdenek will push that upstream).

Thank you very much! It occured to me that if we want to solve my use
case with minimal risk, we could make the the case in which the
symlinks are preserved conditional on ACTION=="add" (i.e. true coldplug
events). Tell me if you'd prefer that, I can re-submit.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

