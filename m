Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F310AC19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 07:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660029410;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TsXV42UR4cGUGoKSQB2nstOFmY9OvOO0GYDj1nNDTx0=;
	b=EzNtJ3jck0qUfXZzxFew7wQFiqLWn+sQwXhdtHl9IE5ffWQomMnhVhP4xUYrw5vlcW4mtl
	ifY4HvtkAclpP/VIs1PVBWaP/22gUsqjxvZZvLQvyAVFlq4ctgvyEpac3MBUiG9fMHNbOA
	UaVabJDvz71rqZAWZOz+XsrzFUBRJzM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508--0AU2UzVOmKVND4wMldjuw-1; Tue, 09 Aug 2022 03:16:47 -0400
X-MC-Unique: -0AU2UzVOmKVND4wMldjuw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 185AA3C0ED57;
	Tue,  9 Aug 2022 07:16:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FD892026D07;
	Tue,  9 Aug 2022 07:16:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77E001946A54;
	Tue,  9 Aug 2022 07:16:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22B7C1946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 07:16:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 075954010E36; Tue,  9 Aug 2022 07:16:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 03D4440C1241
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 07:16:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5F593801FE7
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 07:16:38 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-tyJsSUiUNbmwbYwoJnTh9A-1; Tue, 09 Aug 2022 03:16:36 -0400
X-MC-Unique: tyJsSUiUNbmwbYwoJnTh9A-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id A29FD68AA6; Tue,  9 Aug 2022 09:16:32 +0200 (CEST)
Date: Tue, 9 Aug 2022 09:16:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20220809071632.GA11161@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-15-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220809000419.10674-15-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 14/20] scsi: Retry pr_ops commands if a UA
 is returned.
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com, bvanassche@acm.org,
 martin.petersen@oracle.com, snitzer@kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 08, 2022 at 07:04:13PM -0500, Mike Christie wrote:
> It's common to get a UA when doing PR commands. It could be due to a
> target restarting, transport level relogin or other PR commands like a
> release causing it. The upper layers don't get the sense and in some cases
> have no idea if it's a SCSI device, so this has the sd layer retry.

This seems like another case for the generic in-kernel passthrugh
command retry discussed in the other thread.

Can you split out two series with just bug fixes for nvme and scsi
as I think we should probably get those into 6.0, and then we can
do the actual feature on top of those?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

