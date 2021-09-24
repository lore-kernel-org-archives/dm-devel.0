Return-Path: <SRS0=pCrV=OO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE9FC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 24 Sep 2021 20:45:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B58761242
	for <dm-devel@archiver.kernel.org>; Fri, 24 Sep 2021 20:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B58761242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-N0xkmBfyOEaDA0rD8sY8wg-1; Fri, 24 Sep 2021 16:45:07 -0400
X-MC-Unique: N0xkmBfyOEaDA0rD8sY8wg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15F39801B3D;
	Fri, 24 Sep 2021 20:45:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C52D71F445;
	Fri, 24 Sep 2021 20:45:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 910931803B30;
	Fri, 24 Sep 2021 20:44:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18OKiurp024100 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 24 Sep 2021 16:44:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 38C3B101A7F7; Fri, 24 Sep 2021 20:44:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33B21101B738
	for <dm-devel@redhat.com>; Fri, 24 Sep 2021 20:44:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66926811E78
	for <dm-devel@redhat.com>; Fri, 24 Sep 2021 20:44:53 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
	[209.85.221.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-150-ol4CRwdSPIiOq4fzo8Ykjw-1; Fri, 24 Sep 2021 16:44:49 -0400
X-MC-Unique: ol4CRwdSPIiOq4fzo8Ykjw-1
Received: by mail-wr1-f42.google.com with SMTP id w29so30928741wra.8;
	Fri, 24 Sep 2021 13:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:from:subject
	:references:content-language:to:cc:in-reply-to
	:content-transfer-encoding;
	bh=SS6kAIG9JIuJkBAA6L+8wenG9ISDyEU/rokccqEKmyM=;
	b=Oa6Ax7oDJlJUrvRo5X9msZMvejT5ItiAmCkGrvD7TS2HwwuDS8tedHiPFYtF6Z1ekO
	gquv4hvAEjuorlNsqT4BWLKqHECJrOFvytrTFLHXI8m/F+94VU/UxpMzBMca+UzlLhkB
	MFSwlomp6V7gpe3ea7EEuAmwhn98iYV4Fz4MvQgvRMQFvhZw8WI1aEfrnT8DlFPjQoHa
	UtV1GoJ1uDqFVzEG3nV4oi7T3YZekzrH6bkGrpQBtVtAEpdsZb5IUd92y/+w30ZAM5Wr
	Hxe5yhkeApOBTpIkdahtDjAaXmWxZjYUJGI5CTP6w8tnPvI1aZm1lVEFE2EgL0a9GE82
	68jQ==
X-Gm-Message-State: AOAM53040U1xFtL8x7Vw4nOVDGwnR1LU6SylYRx4+VAa6U5qm675ntCy
	tdliZ1b6C5GIWzjSB6oe/aslxz68Bw==
X-Google-Smtp-Source: ABdhPJyGTmQxFAhqXCetN2YkimIoP0jzrH8w6CPkJRGtGhR8WqLLsoP2r3E6AiF2RSVQGSxJ3DrPSA==
X-Received: by 2002:adf:ce89:: with SMTP id r9mr13556994wrn.238.1632516287902; 
	Fri, 24 Sep 2021 13:44:47 -0700 (PDT)
Received: from localhost (7.red-79-159-142.dynamicip.rima-tde.net.
	[79.159.142.7])
	by smtp.gmail.com with ESMTPSA id i6sm3604027wrx.61.2021.09.24.13.44.47
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 24 Sep 2021 13:44:47 -0700 (PDT)
Message-ID: <9bf07d41-44e3-0f44-0cff-59b7379fc490@gmail.com>
Date: Fri, 24 Sep 2021 22:44:46 +0200
MIME-Version: 1.0
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
In-Reply-To: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH 0/4] Add "reconfigure all" multipath command
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/21/21 01:21, Benjamin Marzinski wrote:

> This patchset is supposed to replace Martin's
> 
> multipathd: add "force_reconfigure" option
> 
> patch from his uxlsnr overhaul patchset. It also makes the default
> reconfigure be a weak reconfigure, but instead of adding a configuration
> option to control this, it adds a new multipathd command,
> "reconfigure all", to do a full reconfigure. The HUP signal is left
> doing only weak reconfigures.
>   
> In order to keep from having two states that are handled nearly
> identically, the code adds an extra variable to track the type of
> configuration that was selected, but this could easily be switch to
> use a new DAEMON_CONFIGURE_ALL state instead.
>   
> The final patch, that added the new command, is meant to apply on top of
> Martin's changed client handler code. I can send one that works with the
> current client handler code, if people would rather review that.

This change is going to affect some places, raw search:

$ git grep reconfigure
libdmmp/libdmmp.c:      snprintf(cmd, _IPC_MAX_CMD_LEN, "%s", "reconfigure");
libmultipath/configure.c:        * If we are in this code path (startup or forced reconfigure),
libmultipath/foreign.h:  * don't support it. "multipathd reconfigure" starts foreign device
libmultipath/foreign.h:  * This is called if multipathd reconfigures itself.
multipath/main.c:               p += snprintf(p, n, "reconfigure");
multipathd/cli.c:       r += add_key(keys, "reconfigure", RECONFIGURE, 0);
multipathd/cli_handlers.c:cli_reconfigure(void * v, char ** reply, int * len, void * data)
multipathd/cli_handlers.c:      condlog(2, "reconfigure (operator)");
multipathd/cli_handlers.h:int cli_reconfigure(void * v, char ** reply, int * len, void * data);
multipathd/main.c:                              condlog(2, "reconfigure (delayed)");
multipathd/main.c:      set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
multipathd/main.c:              condlog(2, "reconfigure (delayed)");
multipathd/main.c:reconfigure (struct vectors * vecs)
multipathd/main.c:              condlog(2, "reconfigure (signal)");
multipathd/main.c:                              reconfigure(vecs);
multipathd/main.h:int reconfigure (struct vectors *);
multipathd/multipathd.8:happens, it will reconfigure the multipath map the path belongs to, so that this
multipathd/multipathd.8:.B reconfigure
multipathd/multipathd.service:ExecReload=/sbin/multipathd reconfigure
multipathd/uxlsnr.c:     * do it once per reconfigure */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

