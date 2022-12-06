Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0B8C63705
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420248;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cMrJsb3TBF13CooncNX88m+71dLn+hBDyf/6cdqLSrI=;
	b=VNznk8wNtJ/jLpEbaLXaaiKHQzl8+kASvBakKyiLHfwwhUy+cGxr9/bFtkGt4k3lwnOnEY
	767V4lJrjmEUk+19UBjdAr0hHhEqqnoQprbkqatBc4Xbe/rITCR0P5FYBA6X2mftv4D+OR
	ZFxy/ATurryIQo6n9AiAjWLMNv01wis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-USfAuhNiMKy-4PawjfoeLQ-1; Wed, 07 Dec 2022 08:37:25 -0500
X-MC-Unique: USfAuhNiMKy-4PawjfoeLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B922D86F143;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A939FC15BA5;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 733641946A4C;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0191419465B1
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 19:56:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 071F57AE5; Tue,  6 Dec 2022 19:56:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F39E653AA
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 19:56:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3DD085A588
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 19:56:42 +0000 (UTC)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
 [209.85.166.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-395-8YephpGlMk6swoXK0euQRA-1; Tue, 06 Dec 2022 14:56:41 -0500
X-MC-Unique: 8YephpGlMk6swoXK0euQRA-1
Received: by mail-il1-f172.google.com with SMTP id m15so6968715ilq.2
 for <dm-devel@redhat.com>; Tue, 06 Dec 2022 11:56:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Pr5A82QMDS3439cV/l0TiwyD6oe8HTmjdxBAYHIenkw=;
 b=XixAAvxYIGA15JAMItqWgtiTegPh0Zvu1ejpbgSEtefUNgQj5CTarwB1sF1sr9xFJs
 aW774CtSeaJlfUrI5PyYF7FR1svdazuv+PMGdByIS7Q2uIll5aICywtOEmWaDI8JGp2H
 61feADkPkJlbdCTB837D+ErEDTQPsHV4VvjArN2BEJv7IMjH9zIYI8TinGp8MA1pFeK1
 BlLWDOx+CqIoKYIil18IqV2ahlqnxzbWOB03FI6pzdElyH3uVHJaJphmY7QEDrTwvWVs
 2XezSFWxD0p2KjoLs3DisIcQB2oSEHAar9i5n9MShfFaRIaliG3T+oU7tOTVxn6kHv+z
 FCjw==
X-Gm-Message-State: ANoB5plN87h5JYKp5BayULf5FQhucJI+bggM6CdPl6Zci/r90f6mXFbC
 dVdxJoXRlDsgM6dpuEWrMEv7Yna1S1s6n7EKM+6ZSw==
X-Google-Smtp-Source: AA0mqf5weYpfxnfmeNEaWEQd5GuamfhCWZUc6GKCqEjTgjj47RKtDegoyGS/7Ff3WUue6RAch00gS/qlXcQ0t/Pzp84=
X-Received: by 2002:a05:6e02:1c8d:b0:303:71ee:7b6b with SMTP id
 w13-20020a056e021c8d00b0030371ee7b6bmr2852396ill.147.1670356600505; Tue, 06
 Dec 2022 11:56:40 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
In-Reply-To: <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
From: Alvaro Karsz <alvaro.karsz@solid-run.com>
Date: Tue, 6 Dec 2022 21:56:05 +0200
Message-ID: <CAJs=3_CWrO34KBxN_eNVyibRNYUP9tzmywnmq2W+9uMYwbQdBA@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Bart,

> Why does the above data structure only refer to SLC and MLC but not to
> TLC or QLC?

This has been discussed before.
The data structure follows the virtio spec
(https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html)

> How will this data structure be extended without having to introduce a
> new ioctl?

There are no more lifetime parameters defined in the virtio spec.
Please note that this is a virtio block specific ioctl, not a block generic one.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

