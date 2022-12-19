Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D02FC54EBC
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=afuzCtKrAvZluKSjzWg2BvPYP1JxgN6etR7/oegIBqE=;
	b=ZBToTa219Sz7yAq+yDlT9WtdEpceOXedSAz5BcivtBryW8urQP4vNwH4kEanHD707uejO3
	XlpVQIqtDkgbTcBQEqtkwv9KqkX6NehidjUjXCSHf6qg7YGZMLXjpyw5JfquW8pYzd1L3A
	gMa9zgdeZeI/7y04yVwERxHgGSEskk0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-3EbuHu7RMAuZ9GBjT8OkqA-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: 3EbuHu7RMAuZ9GBjT8OkqA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4534785C6E3;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3554A140EBF5;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40AB4194705B;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5BB22194658D
 for <dm-devel@listman.corp.redhat.com>; Mon, 19 Dec 2022 08:40:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39AE014152F6; Mon, 19 Dec 2022 08:40:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D62C14152F4
 for <dm-devel@redhat.com>; Mon, 19 Dec 2022 08:40:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10D87882822
 for <dm-devel@redhat.com>; Mon, 19 Dec 2022 08:40:20 +0000 (UTC)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-T83Pye3fPKm7_d23dDh4jQ-1; Mon, 19 Dec 2022 03:40:17 -0500
X-MC-Unique: T83Pye3fPKm7_d23dDh4jQ-1
Received: by mail-pg1-f182.google.com with SMTP id v3so5697646pgh.4
 for <dm-devel@redhat.com>; Mon, 19 Dec 2022 00:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=f8+bSmaA0cmp16x26bRQ/cm+4zQqtY1wbwdEpQv5OiY=;
 b=l9UzXzwt22oY3G/ETaGOjBLUbg6hw1Ph8w8DY8IWd9r/Sqrzdb8azhfELxViAcS45B
 J3LswuesdzSF+P/UEJnTOTne4URpMUwpSUA2kCXDvhyZCIxcivYblgbmw1BrF6Tw8Q+n
 s77ixZ0G2W2WPJoWKjhE3xnZceVmLL5c49F6fv6oF0puoURko2IWgOUshCyOPTXpO+zU
 /Aww4NvXll+v9h+K009x1Z6HKVmoAD6w6ciAMXKccOMUCp75P+7E1WgfHL4pEsR5/28R
 FjZxzpJRpIEqxnhFDx+iXsWoy+v89EBi4gDZGnklSwOn0vCx49IzGT3Wlf85tZ0Y9fxC
 Eagg==
X-Gm-Message-State: ANoB5pkHnKggk142HkH12jc30ak4H9UIO5UvVLSWvQzwTGe/mwzyWfVI
 jcHU8EIIBeLHkzmwIgzvXYGw8MTZwxPcVCn3ppVudA==
X-Google-Smtp-Source: AA0mqf6fHrB24kpKRZtxJ/jl4cyycBpONCwoE9u9Hwo5PX1mANCykQgJBY1PwHfLY1yPaXCstzW+unZ0wtSJyelyLd8=
X-Received: by 2002:aa7:9acc:0:b0:577:81cb:4761 with SMTP id
 x12-20020aa79acc000000b0057781cb4761mr9183983pfp.46.1671439216472; Mon, 19
 Dec 2022 00:40:16 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <20221219025404-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221219025404-mutt-send-email-mst@kernel.org>
From: Alvaro Karsz <alvaro.karsz@solid-run.com>
Date: Mon, 19 Dec 2022 10:39:39 +0200
Message-ID: <CAJs=3_CWQ3T1O5RofstwkczpgoJym5X4xBQmdQCtt573sHUOKg@mail.gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
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
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Michael,
Sorry, I had no time to create a new version.
I'll do it today.

Alvaro

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

