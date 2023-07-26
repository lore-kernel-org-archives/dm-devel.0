Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272D6C001DE
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jul 2023 23:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690415199;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OxY9q/WE5BH6zgh7GSzlOXYLy58My9lwdmYIOqZNsEc=;
	b=DAXRZOw0oI/Uqum09bKIPA+UPvC/CL9dKnnkxvtGEzsH3YSSaIJ83S2Tor1gQPdPYJMzyY
	vqydrAtbiPRNYd8EZnnPr86gWr7+hok1vs8z3jIiOTjWUVx/bZNn/+tGRg8L5ECAho3SaJ
	aqxJkZUCUzBSVU2b5q8gL/IBUKJv6SE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-681-4m23HAftPyysW7a0ia9mhA-1; Wed, 26 Jul 2023 19:46:36 -0400
X-MC-Unique: 4m23HAftPyysW7a0ia9mhA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 994038564EF;
	Wed, 26 Jul 2023 23:46:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EE85145414E;
	Wed, 26 Jul 2023 23:46:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DFD951946A6E;
	Wed, 26 Jul 2023 23:46:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B698A1946A6E
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 23:34:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FB7B2166B26; Wed, 26 Jul 2023 23:34:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9852A2166B25
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 23:34:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B46C3C11A05
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 23:34:03 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-ClNIzBM9N4aeFt71IZ3uEQ-1; Wed, 26 Jul 2023 19:34:02 -0400
X-MC-Unique: ClNIzBM9N4aeFt71IZ3uEQ-1
Received: by mail-qk1-f197.google.com with SMTP id
 af79cd13be357-76c562323fbso48316585a.0
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 16:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690414441; x=1691019241;
 h=mime-version:user-agent:message-id:in-reply-to:date:references
 :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=JyD6brWfay5Kmnzh8GFewzS67t7xdwsyLUWArEuoir8=;
 b=Ebe9tN3cgaTEeVHCw2HeeamjZFf2DPSP19K1LhjY60Q7gPfkHRgaJU4CeKSMucBycb
 H5fL3N37Ayk678dJs3+dF4FbY7jVGZw+tBxaGHQV1FI/gFDu9o0ub2R3urCooDnNDDoD
 b1bJ58oe1QYMA8QQfvwvWlhYnVYJ6Q3NPrjQwR4kWZf+9hXs+xjXWWvvVjD+YshMxSfe
 w05uy2YOhKufkoa5iH1aUol5wdRPWZFoGXkATpRfNT+tTjuevVhziDOzbykVkeTVmJi0
 KBg6o0YRxQ2fX6I/7637U9pQcw/0SG2wU6NNReaOlGS1M8KmdlrhN0t78+BTaAKIkRPh
 66sw==
X-Gm-Message-State: ABy/qLZPBOA+prGXuTmrn+PFTDrAWMVHs/mTOOSgDrl3h/8AShVZvJOA
 tvzejJUdcmwb5JNYNLOisvRnHYoW/FNQl5iGh6lkQBoI/xFmF2HE+qm5jUImj0rSQQrQjD27ffs
 d0UEHLvTJ8x5mAhE=
X-Received: by 2002:a0c:b30c:0:b0:5f4:5af6:1304 with SMTP id
 s12-20020a0cb30c000000b005f45af61304mr2936970qve.16.1690414441706; 
 Wed, 26 Jul 2023 16:34:01 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHonF7eBvYZRAZL1IaNans/eUBaueHJOyyYpEdyvlAkALF78WyY3NVe/g4RFEr5upDuwwY0Fw==
X-Received: by 2002:a0c:b30c:0:b0:5f4:5af6:1304 with SMTP id
 s12-20020a0cb30c000000b005f45af61304mr2936960qve.16.1690414441482; 
 Wed, 26 Jul 2023 16:34:01 -0700 (PDT)
Received: from crash ([66.187.232.65]) by smtp.gmail.com with ESMTPSA id
 c23-20020a05620a11b700b00767303dc070sm13060qkk.8.2023.07.26.16.34.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jul 2023 16:34:00 -0700 (PDT)
From: Ken Raeburn <raeburn@redhat.com>
To: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
 <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
 <509f4916-a95f-216e-b0ab-7b7a108a48a0@dorminy.me>
Date: Wed, 26 Jul 2023 19:33:59 -0400
In-Reply-To: <509f4916-a95f-216e-b0ab-7b7a108a48a0@dorminy.me> (Sweet Tea
 Dorminy's message of "Sun, 23 Jul 2023 02:24:32 -0400")
Message-ID: <87bkfy9riw.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [vdo-devel] [PATCH v2 00/39] Add the dm-vdo
 deduplication and compression device mapper target.
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
Cc: vdo-devel@redhat.com, ebiggers@kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, tj@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:

>  There seems a natural duality between
> work items passing between threads, each exclusively owning a
> structure, vs structures passing between threads, each exclusively
> owning a work item. In the first, the threads are grabbing a notional
> 'lock' on each item in turn to deal with their structure, as VDO does
> now; in the second, the threads are grabbing locks on each structure
> in turn to deal with their item.

Yes.

> If kernel workqueues have higher overhead per item for the lightweight
> work VDO currently does in each step, perhaps the dual of the current
> scheme would let more work get done per fixed queuing overhead, and
> thus perform better? VIOs could take locks on sections of structures,
> and operate on multiple structures before requeueing.

Can you suggest a little more specifically what the "dual" is you're
picturing?

[...]
> On the other hand, I played around with switching messagepassing to
> structurelocking in VDO a number of years ago for fun on the side,
> just extremely naively replacing each message passing with releasing a
> mutex on the current set of structures and (trying to) take a mutex on
> the next set of structures, and ran into some complexity around
> certain ordering requirements. I think they were around recovery
> journal entries going into the slab journal and the block map in the
> same order; and also around the use of different priorities for some
> different items. I don't have that code anymore, unfortunately, so I
> don't know how hard it would be to try that experiment again.

Yes, we do have certain ordering requirements in one or two places,
which sort of breaks the mental model of independently processed VIOs.
There are also occasionally non-VIO objects which get queued to invoke
actions on various threads, which I expect might further complicate the
experiment.

Ken

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

