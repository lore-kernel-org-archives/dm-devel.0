Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 372CAC6FA82
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 16:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662998430;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bxE8DoH6A9UZNngIPfUJYxX8PANUZrOjsQwVHJ0n1MM=;
	b=gJIJAt04SMfzIlpQWopFXCq/3Zz1gHOMqZbdVMmJuv306XfmLxa4HW1BBhQfV4I7MUWvTQ
	XezLygfe8lqN7tBHSP1N02qqJ+OZgGifrIIYbZufKJ9Z+Ruuh3OcF67kywZOT+r+nEN0DM
	eRS6ALbYdhqxJz9NMcLCqHijK1hXZhM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-NbEk_leVNR-pNEHOKEizQg-1; Mon, 12 Sep 2022 12:00:27 -0400
X-MC-Unique: NbEk_leVNR-pNEHOKEizQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41B7A845D94;
	Mon, 12 Sep 2022 16:00:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF72E40C6EC2;
	Mon, 12 Sep 2022 16:00:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C34DE1946A44;
	Mon, 12 Sep 2022 16:00:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 639EC1946A43
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 16:00:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D87A2027063; Mon, 12 Sep 2022 16:00:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C182027062
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 16:00:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E4A11C0014E
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 15:59:46 +0000 (UTC)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-319-Ka1eXgJrNDa3IzCyz0sKhQ-1; Mon, 12 Sep 2022 11:59:43 -0400
X-MC-Unique: Ka1eXgJrNDa3IzCyz0sKhQ-1
Received: by mail-wm1-f72.google.com with SMTP id
 o25-20020a05600c339900b003b2973dab88so5042481wmp.6
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=BM4ixkvnt5GnI69YTUU5bD/FuXGGfwf8jwCz1wTfcHo=;
 b=GfELdFL+SVsIFImS2opTQyqdlJYFlpk3w6j6bxmF9ApEs5yXFlz8C3jBAOdBAOnq6f
 LaQKeEAr7mUfFuUZWcv0zOV4mOXNEwScSAsaqT5INAtsd7m/JLEr5L+DHIxdxldcUZVx
 IEt+dOXGurgflWLKlEl0/EGcGAxWs7vd3i2gtMu8N4JEefSaDylYDQDiAt3TkTacRYWU
 1sVH+tYGmgu31cfOZGix3CS6YLH/fQoM9l1/+yXLL1g/jNR6V+mQ0T0G2tAF/vkboc9A
 tAxGmurc+T/KYBZL+favXJ9iGDA2FFkCRoxHSOodnDJlP6rqsEHYQUfFEljmiQTdTDES
 nEog==
X-Gm-Message-State: ACgBeo3j37PJuBUJkbIJSMbZ+I2kAWtgERbDJdhNzQM+Fb4Z4xfCKoxs
 VuX94cOXZ92Am56YkTYIaOiSLuZx2jN1GSkvSegS+7AkDCAjLz+sappbxN0RNtS0iJ5cQJDpzMi
 Zl10/mxx+lN8vQ28=
X-Received: by 2002:a5d:5642:0:b0:22a:845b:d6df with SMTP id
 j2-20020a5d5642000000b0022a845bd6dfmr3804198wrw.416.1662998382080; 
 Mon, 12 Sep 2022 08:59:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7du5WkS3YYqxbuWqdw/rRBgzdIFM3zJDibJn6BFJAXN0dymNo/vdzy/bdp/jz3ZdCjHvfDLA==
X-Received: by 2002:a5d:5642:0:b0:22a:845b:d6df with SMTP id
 j2-20020a5d5642000000b0022a845bd6dfmr3804190wrw.416.1662998381915; 
 Mon, 12 Sep 2022 08:59:41 -0700 (PDT)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
 by smtp.gmail.com with ESMTPSA id
 k4-20020a5d4284000000b002286670bafasm7812610wrq.48.2022.09.12.08.59.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Sep 2022 08:59:41 -0700 (PDT)
Date: Mon, 12 Sep 2022 16:59:39 +0100
From: "Bryn M. Reeves" <breeves@redhat.com>
To: "Pra.. Dew.." <linux_learner@outlook.com>
Message-ID: <Yx9Xa47V9REfs2+c@redhat.com>
References: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
 <c7b61c01-a12a-9ed1-d3d0-f82b765a166f@redhat.com>
 <BY5PR14MB389395BF1BEB0118582907A186449@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BY5PR14MB389395BF1BEB0118582907A186449@BY5PR14MB3893.namprd14.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] setting up dmverity using device mapper IOCTLs
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 12, 2022 at 03:37:19PM +0000, Pra.. Dew.. wrote:
> Thank you Zdenek. We are developing a embedded system with very constrained memory/storage. So we are trying to see if we can combine utilities like dmsetup with other Rust code for managing storage in our embedded system, while only including the parts of dmsetup that we really need. Hence I am trying to figure out what is the best way here.

If you are working with Rust then you may want to evaluate the
devicemapper-rs library:

  https://github.com/stratis-storage/devicemapper-rs/

This is an implementation of a high level interface to the DM ioctls in
Rust - it obtains some constants from libdevmapper.h via bindgen but the
ioctl handling and header parsing is done natively.

It's been around for a while and is used by Stratis and some other
projects. There have been a few discussions around a new userspace DM
implementation in Rust with a somewhat different interface but nothing
has been written so far.

Regards,
Bryn.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

