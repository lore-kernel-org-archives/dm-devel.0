Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21298C4708E
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mXKIEl+8n4VML5Aqc/oDRKIlAtmc706KZZszoqoceBk=;
	b=UH+8W9XsWaIf7JSfBy1ywPBFLtyK006mbPvlnZ34kaNjIpUyw9K5pxDAZGqEOlsxNSElqU
	DLs99vl13auBk/gvgvDSURxmoQ5G7Ylz2Xm6974+zG7Toe74Rp+oY9NliChHHE4wxBvvNj
	bgGVr2oHJHw4hz1kv9KlYSWudwnuCW8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-NHnT3RL_Nz-p0D0GDiR2qA-1; Wed, 07 Dec 2022 08:37:24 -0500
X-MC-Unique: NHnT3RL_Nz-p0D0GDiR2qA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C12921881213;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE4EB40C206B;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 591FC1946A72;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64FE219465A0
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 18:26:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D2492027062; Tue,  6 Dec 2022 18:26:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1596C2027061
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:26:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9F35811E7A
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:26:29 +0000 (UTC)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
 [209.85.166.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-395-CTQcsWV7O1i8FNj1R1baSQ-1; Tue, 06 Dec 2022 13:26:28 -0500
X-MC-Unique: CTQcsWV7O1i8FNj1R1baSQ-1
Received: by mail-il1-f175.google.com with SMTP id y2so5058191ily.5
 for <dm-devel@redhat.com>; Tue, 06 Dec 2022 10:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=4IgAV0xIyvbwpM5yKjLqn+3xEvTqGQImla8lRmFjooY=;
 b=38uJopvqnf7WvooL941Y3yFqFntVY1Y1noJQNAnmf19bNPXqAmE9mi4Mx6VLQist4M
 /eQftwdcdEWZF3VgdtwWENQMRmsOwV26uldKh60/dTuOBmAaGkzOlIB8/zTCM5P0bvqQ
 Ieg2SkzdWcuA8SzXK3/dT5snLGdM11QTg6T2dTIMJysYAS7AYH6sqw9Ipw5y/iWdmVkQ
 weKlnYOXU00RfMMnSKQWbER4bcuhmCobv6bYFNL1Ils6KUooHAp7K4Pz82XK/B2ujEht
 gko8M91U3grwQnMvkfpvyKzNRacXYoFgscapJC1lFqh+zjwzPNY4U8vJgbtl19Hzypy/
 FO0Q==
X-Gm-Message-State: ANoB5plvMqt5xHG/rXEZIqoyR4hRfsvMgCJGFooZKpObehma5g9mNu7U
 DYz4St6lxNXhzAaaErOVs2WXahBqxvmXL+RJ3EY7Zg==
X-Google-Smtp-Source: AA0mqf4OFLTHTjVrQA6b2z/UjNJEshTdpsFl+xYEou0s/2/0KkWYoGxGNXdyK9Sb1If+AAfg1/RuRv752BxW7M+hQoM=
X-Received: by 2002:a92:d702:0:b0:302:8a13:6744 with SMTP id
 m2-20020a92d702000000b003028a136744mr31558581iln.52.1670351187587; Tue, 06
 Dec 2022 10:26:27 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y49ucLGtCOtnbM0K@fedora> <20221206113744-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221206113744-mutt-send-email-mst@kernel.org>
From: Alvaro Karsz <alvaro.karsz@solid-run.com>
Date: Tue, 6 Dec 2022 20:25:50 +0200
Message-ID: <CAJs=3_CfwV=gzgsM=PseLoigzU+CFOXHk=9Sy-SBro5HHn_uhQ@mail.gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks,
I will fix it in the next version.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

