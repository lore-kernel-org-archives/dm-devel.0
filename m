Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95216C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 16:03:26 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-RZrHI1xjPYun3bnlPJvCJA-1; Fri, 28 Jan 2022 11:03:22 -0500
X-MC-Unique: RZrHI1xjPYun3bnlPJvCJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 103F55201;
	Fri, 28 Jan 2022 16:03:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E8257CAE1;
	Fri, 28 Jan 2022 16:03:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A7514BB7C;
	Fri, 28 Jan 2022 16:03:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SG3A9h026429 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 11:03:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6BCCD2024CB7; Fri, 28 Jan 2022 16:03:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 673072028CE7
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 16:03:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C6F6185A7B2
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 16:03:07 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-15-0QM7DcHrNXyORIR94ROgmw-1; Fri, 28 Jan 2022 11:03:01 -0500
X-MC-Unique: 0QM7DcHrNXyORIR94ROgmw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C99D1210FF;
	Fri, 28 Jan 2022 16:02:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 593AE13A0A;
	Fri, 28 Jan 2022 16:02:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 1PxwE7MT9GHCWgAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 28 Jan 2022 16:02:59 +0000
Message-ID: <d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Zdenek Kabelac
	<zkabelac@redhat.com>, David Teigland <teigland@redhat.com>, Peter Rajnoha
	<prajnoha@redhat.com>
Date: Fri, 28 Jan 2022 17:02:58 +0100
In-Reply-To: <a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

On Fri, 2022-01-28 at 16:57 +0100, Martin Wilck wrote:
> 
> It's a race condition. It probably happens while multipathd is
> reloading a map (*), suspending it during the table reload. The
> device
> will be resumed a few fractions of a second later (so yes, it's
> "quick"), but then it's too late

More precisely: The suspend state itself may actually not last longer
than a few ms. But once the symlink is bent to point to the wrong
device, it will remain so, until the CHANGE event following the device
resume is successfully processed by udev, which may happen
substantially later. And it's that longer time span which matters for
systemd's mount attempt (or LVM device activation, for that matter).

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

