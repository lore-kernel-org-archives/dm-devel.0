Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBABCC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 07:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646121249;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B8EqtTtsH028kDO3/LMCIRsZ33poelfm0VbM+hmGpX0=;
	b=HWvAZyjHe1GRDUr/TaauvmonlUfkxg2q/Ld/7jtfz+JC4/ieV4hMPT9AbAf4pgs3ZQzjW5
	f+9vr82OlX0W3DKg5VYa080uOIvpHHU9g0tzQrVZSeAHCPaE2O7qeg601NG6aIzSlQHCcp
	Bp3m26hRto1Ch4mPZmyL0Wjq7/giysE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-Abl9Bxg-PDaPOUqW2DneSw-1; Tue, 01 Mar 2022 02:54:05 -0500
X-MC-Unique: Abl9Bxg-PDaPOUqW2DneSw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B7831091DA1;
	Tue,  1 Mar 2022 07:54:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 016F0100685E;
	Tue,  1 Mar 2022 07:54:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 479BE1809C98;
	Tue,  1 Mar 2022 07:54:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2217ru94024589 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 02:53:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C816401E57; Tue,  1 Mar 2022 07:53:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98C04401E31
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 07:53:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A03C8047D6
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 07:53:56 +0000 (UTC)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
	[209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-446-JsVVZ2C5NWiZKoZJifUomg-1; Tue, 01 Mar 2022 02:53:55 -0500
X-MC-Unique: JsVVZ2C5NWiZKoZJifUomg-1
Received: by mail-ed1-f69.google.com with SMTP id
	y10-20020a056402358a00b00410deddea4cso7308840edc.16
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 23:53:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=QVnFIZhFNYTKL1SBRvgDq8aonG+DvL7dUgSwlUWc5mM=;
	b=CEoI7chtX08dSmMh4L6Tg2seXWG5HPPfC4mBypp8CQNplFnCLoOWCqR3Y7OcBlQqvm
	VS1lyfpbpz2+20QAdDyEECyLxu8xqyo1BTZWR9EvlpgCsNhkyNrA1FtxKUEyRRPNalzW
	hPTUMNZL/dRWz+VcPNUjaJ0/ZHZ0PeAbtdt0RBMeIbLfzx0ljplzRjrwC4bCzVs+jA2+
	6vtwxMpDsNKhtdZsbwUNodtosquUTeUJu52TvBjiyrr47E4/shJO+VvKN0hgDQKDhNdr
	7iT9+SotOo4+gfZjbmOE6HSZd5bdyxozg2vyzULqjtq6FkYbtaCTHTlYxR5O9tcCxOK5
	4Spw==
X-Gm-Message-State: AOAM530g2KJ7CgE+JevsTvCK6WWHhMBpkqkmD25FfZkNTDMA3VOMo6yP
	v8RpGptZqfRlneUVRRYG7e9J7BWOM+29z+A1/NAylm+kO1nGNPTiN7+yam08UsrzzLZt2bVkcTI
	aqgZrWPgk7hVIgVk=
X-Received: by 2002:a17:906:d935:b0:6cc:fcfc:c286 with SMTP id
	rn21-20020a170906d93500b006ccfcfcc286mr18098682ejb.423.1646121234053;
	Mon, 28 Feb 2022 23:53:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysts8BwR7kcT2eYdWIeAKaNDkPSFZ3Y7NmajZMDMKGdqDOlJPCJrK4VFsbK9YtcY5F4jFAyA==
X-Received: by 2002:a17:906:d935:b0:6cc:fcfc:c286 with SMTP id
	rn21-20020a170906d93500b006ccfcfcc286mr18098675ejb.423.1646121233798;
	Mon, 28 Feb 2022 23:53:53 -0800 (PST)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com.
	[213.175.37.10]) by smtp.gmail.com with ESMTPSA id
	c4-20020a170906340400b006d077e850b5sm5073999ejb.23.2022.02.28.23.53.53
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 28 Feb 2022 23:53:53 -0800 (PST)
Date: Tue, 1 Mar 2022 08:53:49 +0100
From: Peter Rajnoha <prajnoha@redhat.com>
To: Xiao Ni <xni@redhat.com>
Message-ID: <20220301075349.ao7a2rbjqn627oq4@alatyr-rpi.brq.redhat.com>
References: <20220216205914.7575-1-mwilck@suse.com>
	<164504936873.10228.7361167610237544463@noble.neil.brown.name>
	<e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
	<20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
	<CALTww2-_rJDyVh2GLehJ8Yg9LOy4MnkvDeJnF2uunaOy6ONu7g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALTww2-_rJDyVh2GLehJ8Yg9LOy4MnkvDeJnF2uunaOy6ONu7g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.com>,
	lvm-devel@redhat.com, linux-raid <linux-raid@vger.kernel.org>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>,
	Heming Zhao <heming.zhao@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi!

On Mon 28 Feb 2022 23:28, Xiao Ni wrote:
> Hi Peter
> 
> In rhel, we have a rhel only udev rule that checks
> DM_UDEV_DISABLE_OTHER_RULES_FLAG. Maybe it's the reason why you don't
> notice this. Besides DM_UDEV_DISABLE_OTHER_RULES_FLAG, it still checks
> other flags.
> 

Ah yes, that's it! I've been still recalling this to be patched once.
So looks like it just didn't get propagated upstream :-/

> # Next make sure that this isn't a dm device we should skip for some reason
> ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="dm_change_end"
> ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="dm_change_end"
> ENV{DM_SUSPENDED}=="1", GOTO="dm_change_end"
> KERNEL=="dm-*", SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="linux_raid_member", \
>         ACTION=="change", RUN+="/sbin/mdadm -I $env{DEVNAME}"
> LABEL="dm_change_end"
> 
> In 10-dm.rules, if DM_SUSPENDED is 1, it sets
> DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1. So we don't need the check of
> DM_SUSPENDED. But how DM_UDEV_RULES_VSN? Do we need to check it?
> 

Yes, right, the check for DM_SUSPENDED is superfluous here so we don't
actually need that one. The single check for DM_UDEV_DISABLE_OTHER_RULES_FLAG
covers it.

The DM_UDEV_RULES_VSN - this was meant for future changes in case a new
set of DM udev variables is used or existing set changed so the other rules
know what exact variable set is available for checking. But I think the rules
are settled down for a few years now and I don't expect any more radical
changes here, so we can remove that check for DM_UDEV_RULES_VSN as well.

-- 
Peter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

