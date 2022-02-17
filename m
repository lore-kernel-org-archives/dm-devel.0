Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C94C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 13:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645104146;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LsjdU6mS0Kt3GhUPE+v4GbYi0beL3HWFPa7g+Q0ym4M=;
	b=StHUVGE+nvDBptsjjoezP5Yd6sdBs+vfYLkO5bHGuOzFQ8sWqQJap955kC365q0vmIQFIW
	MpBpDN+QE0TTV/uKoHUE1rGdQf9/GBRQkjXpwPWolw53yjfLMEMjb42HR9P73lVNMHqqSc
	odlt8L2fuJCNqhjWsdqOG5rKOcKEO1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-HcwXsfTCOJOSW20cg1_hQw-1; Thu, 17 Feb 2022 08:22:23 -0500
X-MC-Unique: HcwXsfTCOJOSW20cg1_hQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3FDA18460E8;
	Thu, 17 Feb 2022 13:22:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E329E7317D;
	Thu, 17 Feb 2022 13:22:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E8CF44A7CA;
	Thu, 17 Feb 2022 13:22:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HDKqCh003406 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 08:20:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 69A2C1120AB8; Thu, 17 Feb 2022 13:20:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 652891120AB2
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 13:20:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B0BE28EB7A4
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 13:20:49 +0000 (UTC)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
	[209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-665-s8ACg1uwPbu71cOBZTPWUg-1; Thu, 17 Feb 2022 08:20:47 -0500
X-MC-Unique: s8ACg1uwPbu71cOBZTPWUg-1
Received: by mail-ed1-f72.google.com with SMTP id
	n7-20020a05640205c700b0040b7be76147so3500541edx.10
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 05:20:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=k3CtLIYPfTzwt5ZNE3qDndhQiDTLTVFRSOAzXK0i2vw=;
	b=LzyZFo/9K8Qvabt6lI3VbJcoSQ0mlXroc9ywClAAzw+QM+IlUEWL8KVamSVQAMm420
	CAZt0O48LU7sJ7k1vthSZ9mVXJVYQxLgJJhsLK3fpsRc4bOKs1vZf4L21DI6yFZH9wIr
	6X69HvRpSY2oyMc0NaSkQ6N1zj4OVIGL5EYU3D0Ojm44Li4mIWO/bWtGT1tM2vyMt3PK
	Pbvp+ZD1Mxwv5cj4T40OI0a+Wdl0s6PsObPdIdlMMxNjh+KVLq+EXy/Mz0Tfr115tr3y
	7XP8Zkk7q7JbC99GQ90EFrPcwUnivSU39CNa+9hacoHMOOe3rd7ASHlAeqq0CyTUeKTB
	Co6Q==
X-Gm-Message-State: AOAM5313MfzbdUMbUyvtZa8278sDQfwsTQX2A8RlOQTajeKtbFgMFhPO
	B0UcLuR2DH4ZHbXoSoqyDD+BSEMGE9XMmbOMMOBcgTyrDzU7efLpeUT6csinksk3ChQzLI/WPs7
	HknFTDEg2zC0+mrc=
X-Received: by 2002:a05:6402:35c8:b0:410:b9fd:67bb with SMTP id
	z8-20020a05640235c800b00410b9fd67bbmr2485145edc.69.1645104046574;
	Thu, 17 Feb 2022 05:20:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzG+5YCeI2QCHM8NsHJGOwaygRT178a8hfMJag9L17lixwktIJKGCIddnV26daajuC/ekHVg==
X-Received: by 2002:a05:6402:35c8:b0:410:b9fd:67bb with SMTP id
	z8-20020a05640235c800b00410b9fd67bbmr2485135edc.69.1645104046424;
	Thu, 17 Feb 2022 05:20:46 -0800 (PST)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com.
	[213.175.37.10])
	by smtp.gmail.com with ESMTPSA id 18sm1132582ejj.1.2022.02.17.05.20.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 17 Feb 2022 05:20:46 -0800 (PST)
Date: Thu, 17 Feb 2022 14:20:42 +0100
From: Peter Rajnoha <prajnoha@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20220217132042.dmmkhecvvylnyc3b@alatyr-rpi.brq.redhat.com>
References: <20220216205914.7575-1-mwilck@suse.com>
	<164504936873.10228.7361167610237544463@noble.neil.brown.name>
	<e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jes Sorensen <jsorensen@fb.com>, lvm-devel@redhat.com,
	linux-raid@vger.kernel.org, Coly Li <colyli@suse.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 17 Feb 2022 11:58, Martin Wilck wrote:
> The main reason is that SYSTEMD_READY=0 is set too late, in 99-systemd-
> rules, and only on "add" events:
> https://github.com/systemd/systemd/blob/bfae960e53f6986f1c4d234ea82681d0acad57df/rules.d/99-systemd.rules.in#L18
> 
> I guess the device-mapper rules themselves could be setting
> SYSTEMD_READY="0". @Peter Rajnoha, do you want to comment on that? My
> concern wrt such a change would be possible side effects. Setting
> SYSTEMD_READY=0 on "change" events could actually be wrong, see below.

We need to be very careful with SYSTEMD_READY as switching that from 1
to 0 would cause the systemd device unit to stop. And services can be
bound to device existence (that is, systemd device unit). If we just
temporarily suspend a DM device and not completely removing it, then
we might get out-of-sync easily when it comes to notion of device
presence in various parts of the system.

One thing is device presence, the other are various sub-states that
a single SYSTEMD_READY is not covering, like the suspended state...

-- 
Peter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

