Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EEBC7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686067870;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xmlQOGY/+a7BmAijNXkCD+TDxzlGqHh4GhEWSMWJqbo=;
	b=idFUrfW+dawIkaiZMs6Sm888rCzCZ75WoYSqFw8rmU5e3FR3SQMDU7qGB96P71TQJ48L2w
	G2Zl4R9tCNd/rINtqPR1gy1oSyBZqA9OIvR/v0wAn6hL1QrPsMCfIktaoyqhLbeBnMu/gT
	Lag8zj9XYSyYm5vEWxR8LEcfG6GfizU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-Gb42omJdM4GpKPiwfwCmnw-1; Tue, 06 Jun 2023 12:11:08 -0400
X-MC-Unique: Gb42omJdM4GpKPiwfwCmnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C3138039C4;
	Tue,  6 Jun 2023 16:11:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C49A22026D49;
	Tue,  6 Jun 2023 16:11:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 808D919465BC;
	Tue,  6 Jun 2023 16:11:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CEC019465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 16:11:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 583272166B26; Tue,  6 Jun 2023 16:11:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FB6F2166B25
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:11:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FABB3813F2B
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:11:04 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-ntmvy6r3MIeXlJk6KLratw-1; Tue, 06 Jun 2023 12:11:02 -0400
X-MC-Unique: ntmvy6r3MIeXlJk6KLratw-1
Received: by mail-qt1-f181.google.com with SMTP id
 d75a77b69052e-3f6c0d651adso69128031cf.2
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 09:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686067862; x=1688659862;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=c77FQ3Gb2vrcGihgJEF093Ohpu3iXSY3aGqHmmdBFIM=;
 b=HZrZXTc/uLprsjcJ3ON7Qp2xFySQqptdNKxMn3Q4ck8XNxfj4qhfE8yZrTLcrqt3wx
 n2wzcwwB144PQ8uPzKCRiCtMXGAAdMqmKVASkg+/WPwezrQMuF5nashv8BbcnOerGGV/
 jQheFItcbFnOzLqo0b62E99KZu+CXKDWlkZuIafWqlZqXWqRtOhf9pruKaIjw9585PgP
 EsPRiHbx8r5AMPJOaTrEjWuRBZNxF3W+QIolKeRjFpMT7y0OykO8JIO/KdY5db056JCG
 uqNF9m28rSz68yXD1UYEO6UdSWx2rQh5TUPYxTjNhE2MwNzIaKXdnG10teWUMiyEH6XR
 HXSw==
X-Gm-Message-State: AC+VfDzQtnEnq/KgBCdcBQ0Z+Ar0NI5UnI5fSdzo2b0j5kf1XrxNLQ0C
 UXBReu+kF7JLC+ljJB3FAMEA3Ug=
X-Google-Smtp-Source: ACHHUZ5i75dZP6S4D/vN4PsonNhq015+FVRez3l0K1i/H5iefxLOdjHeanpRg/gCpFGqtrMsWtSrvA==
X-Received: by 2002:a05:622a:19a9:b0:3f8:6cf6:a412 with SMTP id
 u41-20020a05622a19a900b003f86cf6a412mr69476qtc.43.1686067862062; 
 Tue, 06 Jun 2023 09:11:02 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 g1-20020ac87d01000000b003f27719c179sm5620008qtb.69.2023.06.06.09.11.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 09:11:01 -0700 (PDT)
Date: Tue, 6 Jun 2023 12:11:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZH9alEbuNxHNwYYe@redhat.com>
References: <20230601072829.1258286-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230601072829.1258286-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] enforce read-only state at the block layer
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 01 2023 at  3:28P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> I've recently got a report where a file system can write to a read-only
> block device, and while I've not found the root cause yet, it is very
> clear that we should not prevents writes to read-only at all.
> 
> This did in fact get fixed 5 years ago, but Linus reverted it as older
> lvm2 tools relying on this broken behavior.  This series tries to
> restore it, although I'm still worried about thee older lvm2 tools
> to be honest.  Question to the device mapper maintainers:  is the
> any good way to work around that behavior in device mapper if needed
> instead of leaving the core block layer and drivers exposed?

Given the block core change (in patch 3) _and_ old lvm2 code: it'll
obviously fail.

Not sure of a crafty hack to workaround. Hopefully 5 year old lvm2
remains tightly coupled to kernels of the same vintage and we get
lucky moving forward.

So I agree with Linus, worth trying this simple change again and
seeing if there is fallout. Revert/worry about it again as needed.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

