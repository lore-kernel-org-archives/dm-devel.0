Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7688C77B75
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683651223;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4SBRC2m/h7zLV/lD5gX3Vkxuc2LvO1QgmaocDWB/Ct8=;
	b=ATfINdbpois4MSQcMjK15E5DNRPxG/5dL6coVUUD/H0irUyE4sD9yfI153hrMpS8nTDWko
	gFZPZqLI+1XaJp/DQwOuVqXAmfL/6YK8ufGwp5Dj8jyrO9uzPQQEzxHTD9eeuROv69G0Z0
	RlNetzmB66Ot5UeeDppKt8Cmmtk3s3E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-XA5jGqdkMZea64woqjoAXg-1; Tue, 09 May 2023 12:53:39 -0400
X-MC-Unique: XA5jGqdkMZea64woqjoAXg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AB36857DEC;
	Tue,  9 May 2023 16:53:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 182ED63F5F;
	Tue,  9 May 2023 16:53:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C66B619465BD;
	Tue,  9 May 2023 16:53:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B11A19465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 16:53:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 27C8FC084BB; Tue,  9 May 2023 16:53:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 205A2C15BA0
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:53:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D26B21C12F81
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:53:34 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-nkFOAvyyO4Kp1M0hTUuNDQ-1; Tue, 09 May 2023 12:53:00 -0400
X-MC-Unique: nkFOAvyyO4Kp1M0hTUuNDQ-1
Received: by mail-qk1-f179.google.com with SMTP id
 af79cd13be357-7577668cf20so146382085a.1
 for <dm-devel@redhat.com>; Tue, 09 May 2023 09:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683651175; x=1686243175;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=HGP12yp4f/zdeMyz6FmQhXwVLGe13YEnm2DiLQWOfHc=;
 b=TGGGthMv6b+NkW77XzSpq/ovEDyBiMbX/UJFhUpZgvf2RtNHAg+/aQVt2VUDL3XOf9
 ytAY2gkH0h98EQreqpHhmx3KVqudDPRvGvo+FKtkKP+Z42smSJLs25/uM7yhb/ixWgzR
 si24yOsL1QXykEqjX8U15+COONvXscvEetiLHllQqwzkktn2BFN93GrN9EvDNCpfJOOH
 kKhtndk6ZZi7mnoM5XI+X8ZbnZSRCO5mt/aOqGhf+oWNFJBOfGlDFJl+KmyyQls7ZqO4
 nKolVow1myOMEGJ54DVCRN7rgTJFkFnEtONKXSTap6osCcAqnFFkiujxsIb/JTHyagYl
 I5KA==
X-Gm-Message-State: AC+VfDwet7vLdP1vU+aQq2xM3H2XJwJqPTBYkrDuNSPSwGsRgRKMpQTr
 vgOlCqwnHMCsb9fgOOy3rafIij0=
X-Google-Smtp-Source: ACHHUZ60YxoIH2gyoAjnbydVA2DQU48zJWQIwW/0Dh9DydhZKu2onIPJxWL7YRFQz348oUBbEBXSUQ==
X-Received: by 2002:a05:622a:148a:b0:3f2:a8db:3d57 with SMTP id
 t10-20020a05622a148a00b003f2a8db3d57mr23188660qtx.3.1683651174740; 
 Tue, 09 May 2023 09:52:54 -0700 (PDT)
Received: from localhost ([217.138.208.150]) by smtp.gmail.com with ESMTPSA id
 o4-20020ac80244000000b003f38f55e71asm632547qtg.47.2023.05.09.09.52.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 May 2023 09:52:54 -0700 (PDT)
Date: Tue, 9 May 2023 12:52:53 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZFp6ZSwzqk2CIKwu@redhat.com>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-4-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230506062909.74601-4-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 3/5] dm: Add block provisioning support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, May 06 2023 at  2:29P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> Add block provisioning support for device-mapper targets.
> dm-crypt, dm-snap and dm-linear will, by default, passthrough
> REQ_OP_PROVISION requests to the underlying device, if
> supported.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

