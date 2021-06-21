Return-Path: <SRS0=G5ov=LP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB1EC48BC2
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 18:10:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9C3CB6115B
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 18:10:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C3CB6115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624299015;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/0XnkVvkHQOV6jCqfrZezzcKujblqvTk18TJKwLeobA=;
	b=VawNVipXBoaaE0cOcbSow7jVGdm3BiuIketO4Ks31x9oup+sEQ/ezY1Azqcl9PXmKORKSU
	Qg1/sjDlYGU3rvlnPvAg9wFyyn85QkjrFlVvLEKGV1gpZQExj+lYXFbhqrBIOxTzVen7Mb
	h71JevA4EM2MYYOP1BzRMKg22wMvncQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-h8wJiAKHNRqgCy3NV_LtYg-1; Mon, 21 Jun 2021 14:10:14 -0400
X-MC-Unique: h8wJiAKHNRqgCy3NV_LtYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CF3D19057CD;
	Mon, 21 Jun 2021 18:10:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3D4E1037F24;
	Mon, 21 Jun 2021 18:10:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 352861809C99;
	Mon, 21 Jun 2021 18:10:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15LIA4RY011592 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Jun 2021 14:10:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9E7BE1017CE8; Mon, 21 Jun 2021 18:10:04 +0000 (UTC)
Received: from leontynka.twibright.com (unknown [10.40.192.122])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B5FB1000358;
	Mon, 21 Jun 2021 18:09:56 +0000 (UTC)
Received: from debian3.vm ([192.168.216.2])
	by leontynka.twibright.com with smtp (Exim 4.92)
	(envelope-from <mpatocka@redhat.com>)
	id 1lvOMq-0002wO-3U; Mon, 21 Jun 2021 20:09:53 +0200
Received: by debian3.vm (sSMTP sendmail emulation);
	Mon, 21 Jun 2021 20:09:51 +0200
Message-ID: <20210621180901.669593725@debian3.vm>
User-Agent: quilt/0.66
Date: Mon, 21 Jun 2021 20:09:01 +0200
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	msnitzer@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 0/1] dm writecache: commit just one block,
	not a full page
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike

I suggest to remove the patch 991bd8d7bc78966b4dc427b53a144f276bffcd52
("dm writecache: commit just one block, not a full page") from your
repository and replace it with this patch.

Sub-4k writes have poor performance with most SSDs, so we should make sure
that we write at least 4k.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

