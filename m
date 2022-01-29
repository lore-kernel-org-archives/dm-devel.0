Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B60C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 29 Jan 2022 20:47:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-qnjqECB8PpmI_KKsWJNp7Q-1; Sat, 29 Jan 2022 15:47:05 -0500
X-MC-Unique: qnjqECB8PpmI_KKsWJNp7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59F3C1006AA0;
	Sat, 29 Jan 2022 20:47:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DE966107F;
	Sat, 29 Jan 2022 20:47:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C4A394BB7C;
	Sat, 29 Jan 2022 20:46:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20TKkwGP007266 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 29 Jan 2022 15:46:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 07A6F492CAD; Sat, 29 Jan 2022 20:46:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04115492CA7
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 20:46:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9E3E3804502
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 20:46:57 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-575-ae2XBShFOEyQq7nH1kY8xw-1; Sat, 29 Jan 2022 15:46:53 -0500
X-MC-Unique: ae2XBShFOEyQq7nH1kY8xw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF48B210F5;
	Sat, 29 Jan 2022 20:46:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B47D13ABB;
	Sat, 29 Jan 2022 20:46:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 5g21H7un9WEkBwAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 29 Jan 2022 20:46:51 +0000
Message-ID: <712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Zdenek Kabelac
	<zkabelac@redhat.com>, David Teigland <teigland@redhat.com>, Peter Rajnoha
	<prajnoha@redhat.com>
Date: Sat, 29 Jan 2022 21:46:50 +0100
In-Reply-To: <1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
	<1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>,
	Franck Bui <fbui@suse.de>, lvm-devel@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 2022-01-29 at 21:05 +0100, Zdenek Kabelac wrote:
> Dne 29. 01. 22 v 0:21 Martin Wilck napsal(a):
> 
> > 
> > AFAICS my patch eliminates the window for this error entirely.
> 
> 
> Ok now I see that there is already skip for DM_SUSPENDED
> and you patch likely only tries to preserve some existing state of
> links.
> 
> I'll need to get in touch with Peter here.
> 
> I guess the idea behind was to avoid read of device that will be
> resumed and 
> will automatically get a new event - and suspened device itself
> cannot change 

Thank you!

> - but that fact it's been loosing existing state was missed - I'm
> wondering 
> why this was not seen as problem before.

One reason is that we're now starting multipathd earlier. This has a
lot of advantages, but it reveals problems that were hidden behind the
"After=systemd-udev-settle.service" dependency of mulltipathd before.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

