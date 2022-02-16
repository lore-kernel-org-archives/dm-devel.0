Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DBCFC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 22:15:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-8QQ7pjbgPHe_Qxoy7hVU5g-1; Wed, 16 Feb 2022 17:15:47 -0500
X-MC-Unique: 8QQ7pjbgPHe_Qxoy7hVU5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C4401091DA1;
	Wed, 16 Feb 2022 22:15:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64BD445312;
	Wed, 16 Feb 2022 22:15:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 90FB11809CB8;
	Wed, 16 Feb 2022 22:15:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21GMFMX2029623 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 17:15:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AE1C111F3AF; Wed, 16 Feb 2022 22:15:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06D06111F3AC
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 22:15:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAF3510AF626
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 22:15:13 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-440-dIwcvBt9OSGhcYg9YBIwBg-1; Wed, 16 Feb 2022 17:15:10 -0500
X-MC-Unique: dIwcvBt9OSGhcYg9YBIwBg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8EE001FD3C;
	Wed, 16 Feb 2022 22:09:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C32EC13B5C;
	Wed, 16 Feb 2022 22:09:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id xwQ4HyJ2DWKOUQAAMHmgww
	(envelope-from <neilb@suse.de>); Wed, 16 Feb 2022 22:09:38 +0000
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: mwilck@suse.com
In-reply-to: <20220216205914.7575-1-mwilck@suse.com>
References: <20220216205914.7575-1-mwilck@suse.com>
Date: Thu, 17 Feb 2022 09:09:28 +1100
Message-id: <164504936873.10228.7361167610237544463@noble.neil.brown.name>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21GMFMX2029623
X-loop: dm-devel@redhat.com
Cc: Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.com>,
	Peter Rajnoha <prajnoha@redhat.com>, lvm-devel@redhat.com,
	linux-raid@vger.kernel.org, dm-devel@redhat.com,
	Martin Wilck <mwilck@suse.com>, Heming Zhao <heming.zhao@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 17 Feb 2022, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1 for
> devices which are unusable. They may be no set up yet, suspended, or
> otherwise unusable (e.g. multipath maps without usable path). This
> flag does not necessarily imply SYSTEMD_READY=0 and must therefore
> be tested separately.

I really don't like this - looks like a hack.  A Kludge.

Can you provide a reference to a detailed discussion that explains why
SYSTEMD_READY=0 cannot be used?

Thanks,
NeilBrown


> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  udev-md-raid-assembly.rules | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> index d668cdd..4568b01 100644
> --- a/udev-md-raid-assembly.rules
> +++ b/udev-md-raid-assembly.rules
> @@ -21,6 +21,11 @@ IMPORT{cmdline}="noiswmd"
>  IMPORT{cmdline}="nodmraid"
>  
>  ENV{nodmraid}=="?*", GOTO="md_inc_end"
> +
> +# device mapper sets DM_UDEV_DISABLE_OTHER_RULES_FLAG for devices which
> +# aren't ready to use
> +KERNEL=="dm-*", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="md_inc_end"
> +
>  ENV{ID_FS_TYPE}=="ddf_raid_member", GOTO="md_inc"
>  ENV{noiswmd}=="?*", GOTO="md_inc_end"
>  ENV{ID_FS_TYPE}=="isw_raid_member", ACTION!="change", GOTO="md_inc"
> -- 
> 2.35.1
> 
> 


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

