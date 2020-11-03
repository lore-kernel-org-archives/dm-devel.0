Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8A5C388F9
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:34:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9B7B12080D
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:34:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B7B12080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-1GyYE96UN9e5bXASek9KOA-1; Wed, 04 Nov 2020 02:34:47 -0500
X-MC-Unique: 1GyYE96UN9e5bXASek9KOA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D528803F44;
	Wed,  4 Nov 2020 07:34:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D493D5D9CC;
	Wed,  4 Nov 2020 07:34:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7709F44A71;
	Wed,  4 Nov 2020 07:34:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A3KpOX7014590 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 15:51:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EBDCC200E1E3; Tue,  3 Nov 2020 20:51:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7505208BDDD
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 20:51:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9EA6185A7A2
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 20:51:21 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-100-rZqzWOGEM2q-u86R9qdlKg-1;
	Tue, 03 Nov 2020 15:51:18 -0500
X-MC-Unique: rZqzWOGEM2q-u86R9qdlKg-1
Received: from [192.168.86.21] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id BEE7E20B4905;
	Tue,  3 Nov 2020 12:51:15 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BEE7E20B4905
To: agk@redhat.com, snitzer@redhat.com, Milan Broz <gmazyland@gmail.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <37513b19-f49c-af0c-3c1a-c2d6294d6727@linux.microsoft.com>
Date: Tue, 3 Nov 2020 12:51:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 04 Nov 2020 02:34:40 -0500
Cc: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, dm-devel@redhat.com,
	Tyler Hicks <tyhicks@linux.microsoft.com>
Subject: [dm-devel] Request: reviewing patches related to DM targets
 dm-crypt data measurement using IMA
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hello Alasdair, Mike, Milan, DM Maintainers,

Just a friendly reminder.
Could you please review the following patch series, and provide
comments/feedback?

V4 dm-devel:dm-crypt: infrastructure for measurement of DM target data
using IMA -
https://patchwork.kernel.org/project/linux-integrity/list/?series=366903

With this functionality, Linux kernel subsystem (IMA) will be able to 
measure / attest DM targets' in memory kernel data. The functionality is
aimed to protect the integrity of the important DM target data in the
kernel memory.

I have already addressed feedback from Milan on V3 of this series.
https://patchwork.kernel.org/project/linux-integrity/list/?series=340337

I will be happy to incorporate more feedback from you.

Please let me know if you need more information from our side.

Thanks in advance.

Regards,
Tushar

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

