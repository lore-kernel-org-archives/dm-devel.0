Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F67C77B61
	for <dm-devel@archiver.kernel.org>; Tue, 28 Mar 2023 16:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680020432;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6dMhInsBFDK1nguceT+j2xyOYH/MEMZ+VROR3+3CLB4=;
	b=R7y1m7nx52QspWx0B0CTaSv9PClPf/ps6ECtRGFhoZDoNMQwBo32VYk7fBN1HRu2eyjPrf
	cxMytgMiQWG887HBVMzy/TZRfjIT0iUiSObgWMA+bCcEEAXv+9Oo5GvD4xFrikhg7kyh63
	ZeVyB+/RLlYcdLaWj6JgThKFWjl/1Dw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-7A1ReTMANmaqq3_KzMQanQ-1; Tue, 28 Mar 2023 12:20:29 -0400
X-MC-Unique: 7A1ReTMANmaqq3_KzMQanQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7857C885621;
	Tue, 28 Mar 2023 16:20:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8CBF202701E;
	Tue, 28 Mar 2023 16:20:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84444194658D;
	Tue, 28 Mar 2023 16:20:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5E6E194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 16:20:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79547492C14; Tue, 28 Mar 2023 16:20:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7189F492C13
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 16:20:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5474785A5B1
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 16:20:22 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-eA1jE24JNcCUt8-DbWtOdg-1; Tue, 28 Mar 2023 12:20:20 -0400
X-MC-Unique: eA1jE24JNcCUt8-DbWtOdg-1
Received: by mail-qv1-f48.google.com with SMTP id 59so9469750qva.11
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 09:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680020420;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=qNePyZVhF46MgApZif7o0Vp4G6hH5tDt7W+hgWF9iHw=;
 b=ksSMIOm8Ke6oqc9fwaykqr8S0jpGOiE3vB1AK8Oa65F1ime7TONyxF3Q6y7GtmLjfi
 K+tQXDBhVPqVmNvg1LkBcMyQAR8fYs9bKl8D3aUJjNw/vbU9j/5NrbU0W07elJ+PciMf
 gt2yv1kEVmcg1DOhqwNRa49qXUi+NMyo5XzTfVoge1rjRR9Kfi83VAr6GGrQsNDktz1Z
 BP4XsmAEund0i8oUf6W01Jjrx4TKVuy7H5eLzxCtQq3TceCetXxZovmdm0KhAFu8E3qI
 rNmVuKQw+2TZ3p3NJTqzHVS2vdJiQqvX9opf86uMREzk9iB5z9iN/cGFDEI3xUKP1pAE
 Qcow==
X-Gm-Message-State: AAQBX9dZUN2/HBS+fNKxOkGnXGA8N/9i6QuZvduuMHCdnVfBjfYVBexl
 HO5HYw15dAmRKSLiih2zA9f74yTqUax5YAfWWpRuZCg=
X-Google-Smtp-Source: AKy350bdgUn43fOH9QjmIjYksZ9rQZnA7XCcToBf17wJ3rGyq/cCqV0DYM9v9Eryz26sEVZJBRod5A==
X-Received: by 2002:a05:6214:1304:b0:56a:cf18:599b with SMTP id
 pn4-20020a056214130400b0056acf18599bmr32516383qvb.14.1680020419815; 
 Tue, 28 Mar 2023 09:20:19 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 198-20020a370acf000000b007488171e090sm670857qkk.15.2023.03.28.09.20.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Mar 2023 09:20:19 -0700 (PDT)
Date: Tue, 28 Mar 2023 12:20:18 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Gwendal Grignou <gwendal@chromium.org>
Message-ID: <ZCMTwjEIt6QO1u3o@redhat.com>
References: <CAMHSBOXxdtGxQ8MTv4Tz+fcngaOJS5r62Br6VEDJESg2g5jP4w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMHSBOXxdtGxQ8MTv4Tz+fcngaOJS5r62Br6VEDJESg2g5jP4w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] dm-clone: Request option to send discard to source
 device during hydration
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
Cc: Sarthak Kukreti <sarthakkukreti@google.com>, dm-devel@redhat.com,
 Daniil Lunev <dlunev@google.com>, Nikos Tsironis <ntsironis@arrikto.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 27 2023 at  4:24P -0400,
Gwendal Grignou <gwendal@chromium.org> wrote:

> On ChromeOS, we are working on migrating file backed loopback devices
> to thinpool logical volumes using dm-clone on the Chromebook local
> SSD.
> Dm-clone hydration workflow is a great fit but the design of dm-clone
> assumes a read-only source device. Data present in the backing file
> will be copied to the new logical volume but can be safely deleted
> only when the hydration process is complete. During migration, some
> data will be duplicated and usage on the Chromebook SSD will
> unnecessarily increase.
> Would it be reasonable to add a discard option when enabling the
> hydration process to discard data as we go on the source device?
> 2 implementations are possible:
> a- add a state to the hydration state machine to ensure a region is
> discarded before considering another region.
> b- a simpler implementation where the discard is sent asynchronously
> at the end of a region copy. It may not complete successfully (in case
> the device crashes during the hydration for instance), but will vastly
> reduce the amount of data left  in the source device at the end of the
> hydration.
> 
> I prefer b) as it is easier to implement, but a) is cleaner from a
> usage point of view.

In general, discards may not complete for any number of reasons. So
while a) gives you finer-grained potential for space being
deallocated, b) would likely suffice given that a device crash is
pretty unlikely (at least I would think).  And in the case of file
backed loopback devices, independent of dm-clone, you can just issue
discard(s) to all free space after a crash?

However you elect to do it, you'd do well to make it an optional
"discard_rw_src" (or some better name) feature that is configured when
you load the dm-clone target.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

