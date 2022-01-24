Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E7AC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jan 2022 06:16:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-9VWNlBzRPBuZBWw3R9L54g-1; Tue, 25 Jan 2022 01:16:03 -0500
X-MC-Unique: 9VWNlBzRPBuZBWw3R9L54g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67A76801B0B;
	Tue, 25 Jan 2022 06:15:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B3DB4DC2E;
	Tue, 25 Jan 2022 06:15:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B067D1809CB8;
	Tue, 25 Jan 2022 06:15:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20OFQQK6019697 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 Jan 2022 10:26:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 90C69400E10D; Mon, 24 Jan 2022 15:26:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CF4740ED3ED
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 15:26:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73CB9811E78
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 15:26:26 +0000 (UTC)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
	[209.85.218.46]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-207-ZmgfYxS3MM2GJgGcYOou_A-1; Mon, 24 Jan 2022 10:26:24 -0500
X-MC-Unique: ZmgfYxS3MM2GJgGcYOou_A-1
Received: by mail-ej1-f46.google.com with SMTP id a8so22300427ejc.8
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 07:26:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=Q8tro22vmfvtv1qHxEcfE1lk9LIniWBhqByQR/FGqp4=;
	b=wn6DuaBKvcOCBXuIbGMMEFJsq5ZrDfyDemiI1cJTQjQqqGglX+oljk0izkyeYkFv/l
	CFkIcOmWeAvz8gdYv1BrMNv58GTwLDMfpjZ50LVqLJsdBTTWhepZqMuvMAywozf6IHc+
	SFOLMzyVp8BzgQWNUFfLhDCyupUKkvNgPslcVq/Ft5uKeRZG7NoQPHEYIOxatceeFCvK
	b346PAV/zunCXw0IOOTw59BeeIrNr5uuOmilz0sR3n4yDKrWGJL6zIfVviYX5KEGcMvX
	uA39ugZsI++8uLATjQyXRbg6SXtorx7yTX7asqO947OUkjMrLBddVtNclnOngU9s/sNK
	FKjA==
X-Gm-Message-State: AOAM532o0r0tG3JI0qwzmxxw8Vetvir4K81wxDclliKLAO/DgLs4C0cU
	Liqv4QSY4T/mMfDZq26o/Kp7oIB/ADj5J1Zg2+iQnw==
X-Google-Smtp-Source: ABdhPJzrhkH8rGDmJsc0J8PWfIRm2laAoDaGHEsQrYfJKnTZ+Y8iIFX0dfliY3hfTYS0qBJieSHzX4KYb0hlsIxdJ2s=
X-Received: by 2002:a17:907:e8f:: with SMTP id
	ho15mr13141064ejc.481.1643037983390; 
	Mon, 24 Jan 2022 07:26:23 -0800 (PST)
MIME-Version: 1.0
References: <20220124150209.22202-1-bgeffon@google.com>
	<20220124151434.GB20331@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
In-Reply-To: <20220124151434.GB20331@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 24 Jan 2022 10:25:47 -0500
Message-ID: <CADyq12ykDCswWZw05OdyYfP-zT6afuhXbckii1m1egQ2fSwB4w@mail.gmail.com>
To: Brian Geffon <bgeffon@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 25 Jan 2022 01:15:54 -0500
Subject: Re: [dm-devel] [PATCH] dm: introduce a no open flag for deferred
	remove
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

On Mon, Jan 24, 2022 at 10:14 AM Alasdair G Kergon <agk@redhat.com> wrote:
>
> On Mon, Jan 24, 2022 at 07:02:09AM -0800, Brian Geffon wrote:
> > When a device is being removed with deferred remove it's
> > still possible to open and use the device. This change
> > introduces a flag called DM_DEFERRED_REMOVE_NO_OPEN_FLAG
> > which when used with DM_DEFERRED_REMOVE will cause any
> > new opens to fail with -ENXIO.
>
> What is the need for this?

Hi Alasdair,
Thank you for looking at this. There are a few reasons this might be
useful, the first is if you're trying to speed up a graceful teardown
of the device by informing userspace that this device is going to be
removed in the near future. Another might be on systems where it might
be worthwhile to not have users with CAP_DAC_OVERRIDE be able to open
the device. The logic on this second case is that, suppose you have a
dm-crypt block device which is backing swap, the data on this device
is ephemeral so a flow might be to setup swap followed by dmsetup
remove --deferred /dev/mapper/encrypted-swap. This will guarantee that
as soon as swap is torn down the encrypted block device is dropped,
additionally with this new flag you'll be guaranteed that there can be
no further opens on it.

> Does it break any semantics assumed by userspace?

No, this is fully backwards compatible with the current deferred
remove behavior, it's not required. Additionally, since on the actual
remove userspace would receive an -ENXIO already once the remove
process has started it seems reasonable to return -ENXIO in the
deferred remove case when this flag is enabled.

Brian

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

