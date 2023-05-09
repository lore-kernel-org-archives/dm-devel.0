Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 204CAC7EE25
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683651149;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DF0jCtj0q8VYM32iWB/P7HkyrjuyCnuwsH26dSXW1qw=;
	b=VVK/LZA07JMmutclZf6dvRcYxR55P0GbL1kye596iy9WtY1IVPV7CB7HKs99s9cTzAQsaw
	EdceWtR4qRLEH+T3eYlJGFbzruYmIbiBKH8RuP/IX5sxr+Slp32gyrsW7KzIp0dk+/OqUA
	Nywch9Uyw0brNdFTcQIKoAfMxNoqFz4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-_ygrgtnUNcuivH2JbFgU4A-1; Tue, 09 May 2023 12:52:25 -0400
X-MC-Unique: _ygrgtnUNcuivH2JbFgU4A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6AE7293248F;
	Tue,  9 May 2023 16:52:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A5AB6492C13;
	Tue,  9 May 2023 16:52:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 70E5219465BD;
	Tue,  9 May 2023 16:52:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 728B519465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 16:52:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 41F3E63F5F; Tue,  9 May 2023 16:52:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AA7E63F5B
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:52:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CA46805F58
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:52:22 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-ou35mXZUMCyeI6M7NBmMdQ-1; Tue, 09 May 2023 12:52:18 -0400
X-MC-Unique: ou35mXZUMCyeI6M7NBmMdQ-1
Received: by mail-qv1-f48.google.com with SMTP id
 6a1803df08f44-61b58779b93so57663086d6.0
 for <dm-devel@redhat.com>; Tue, 09 May 2023 09:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683651137; x=1686243137;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=9NlCnOkM/MgxA+OhUODaj0DcPdY66ABvKJcAkS48+rQ=;
 b=Vzf+Hqo0XnEmjxajrumvWfZ+b7tS4n1KiYzg2RMbXijCivNC47r4KQK+xbd5axthtj
 m/aeZZEAcKQLCkluaENEeQEOjzSkrwU6mAT5Yg60XuewxWK+kFO1ay1epDEaOAzmcfYJ
 He1NndBMs6gMGF9orWqOMTFa9cEjmOFDfBO3rbVyTAj9ULYHqFFxnXutj7L7QdV0S8f5
 +o2skNTDqp4LUz77H9Xg3DnNA4kPoYFwDDNa8ujldgyxQMfz4YLf5KW8ebT4wpa00Iym
 j6TaY6wHZsD7VyNIe8eh9ntEqA2NjyRuaw7/rk9zi5Jg7ZpiLAYtN/92MFUkw+uRD2cw
 eGZA==
X-Gm-Message-State: AC+VfDwDUayacN+SUbzvEd+qKIGUoaKrsxL8sfslWcHWR0AScbBQS3Aj
 ajFoyapi4P86TgMLPUKnELsxpfI=
X-Google-Smtp-Source: ACHHUZ6sqdNZ2jTWBpQoQUne2HxU2x6SkHvDsQePL/EB6aWKWGfiLRP7QOvsu0TXIL8IYmrE41X/oQ==
X-Received: by 2002:ad4:5ba2:0:b0:61b:6872:1459 with SMTP id
 2-20020ad45ba2000000b0061b68721459mr18704881qvq.49.1683651137572; 
 Tue, 09 May 2023 09:52:17 -0700 (PDT)
Received: from localhost ([217.138.208.150]) by smtp.gmail.com with ESMTPSA id
 ew8-20020a05622a514800b003e635f80e72sm633574qtb.48.2023.05.09.09.52.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 May 2023 09:52:17 -0700 (PDT)
Date: Tue, 9 May 2023 12:52:16 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZFp6QDkSm296+Qm6@redhat.com>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-3-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230506062909.74601-3-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v6 2/5] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, May 06 2023 at  2:29P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> Introduce block request REQ_OP_PROVISION. The intent of this request
> is to request underlying storage to preallocate disk space for the given
> block range. Block devices that support this capability will export
> a provision limit within their request queues.
> 
> This patch also adds the capability to call fallocate() in mode 0
> on block devices, which will send REQ_OP_PROVISION to the block
> device for the specified range,
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

