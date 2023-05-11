Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5F9C7EE22
	for <dm-devel@archiver.kernel.org>; Thu, 11 May 2023 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683830524;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ukMm93Jt4d7/svxoAlzrWVky52KOZ0/r/rg0WxlTMJM=;
	b=i4z8pMj7cHN0VH53j8+5bOYMX2Tg6P03tDmB2kbwsG2dKSVaZe/SWFPHta+7rGaIbNK1R1
	ZZODPx+8A0g5Iu0+krCPJcyrRaNMjxYyuGpcdOCz7UZzJFAORaH+4BIJOhommrWhAg7FwU
	Ylxed66glz+vdPtcABIBWQcQ9Z0UPmY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-UPQsAOCqMWiQfa3ahsde8Q-1; Thu, 11 May 2023 14:42:01 -0400
X-MC-Unique: UPQsAOCqMWiQfa3ahsde8Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB8E428082A9;
	Thu, 11 May 2023 18:41:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF3BE2166B2A;
	Thu, 11 May 2023 18:41:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88B2B19451E4;
	Thu, 11 May 2023 18:41:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B0FF019451E3
 for <dm-devel@listman.corp.redhat.com>; Thu, 11 May 2023 18:41:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D27B4078907; Thu, 11 May 2023 18:41:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 95D7B4078906
 for <dm-devel@redhat.com>; Thu, 11 May 2023 18:41:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6556A3C0D858
 for <dm-devel@redhat.com>; Thu, 11 May 2023 18:41:54 +0000 (UTC)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-IEOVpn_bPcWxZRB5DQ5l4w-1; Thu, 11 May 2023 14:41:52 -0400
X-MC-Unique: IEOVpn_bPcWxZRB5DQ5l4w-1
Received: by mail-lf1-f48.google.com with SMTP id
 2adb3069b0e04-4f139de8cefso47889876e87.0
 for <dm-devel@redhat.com>; Thu, 11 May 2023 11:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683830510; x=1686422510;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=EXNpWcTP6H1pQM8htJN6FHOkN0yBSnC5c8yBeB4/Occ=;
 b=UiBxf6QTxPqNKzzz/e/EjeZLouqpxxFz5TwKlWI2JU1k2B0yMCWBPduzrgq1Z2OJDP
 0R0Y6l95KYo09OrCJ+PdWA9AyxS6T1k6Z52+aiFFXQ4oxAELCqKkGSv9nhRMx+eHlGF2
 7zn8CR9HLsnpQnsZvgOxe9OZDtbGKDWxlEB+N1T/pciHssmW3uHW/IESIO/vJTBPhq1i
 wFoJYlLAi6oKn9ljMMgYk0gIWRXKcrJiOpILt2G4L9AAnjTnZjSl3G43XRkHXUpDTwj6
 qapeDx17ENSP3HVYfHC70M91D4MdQAP/L63N+k47z1UwWWpuSw8+PPQZ8UDPM7CnQiCC
 NIQw==
X-Gm-Message-State: AC+VfDxcAfCAc9QhnqofDFPWyXuElBeV0seUnId/7oT73CiHclA/MK8U
 vYM9bommDiUaJ3L+XbhUkABikP1Jy+NQWL2WtVfF7ZgICZgAVeME
X-Google-Smtp-Source: ACHHUZ7o0oOKCUABNRdGlAxQ9kBP3d4d/7n6FjW4MzdoT1kqIW8OzM/6yp+owA+77hHFSR6fbujzayqrigNTn6SUz0I=
X-Received: by 2002:a2e:b907:0:b0:2ac:dd01:db90 with SMTP id
 b7-20020a2eb907000000b002acdd01db90mr3262678ljb.10.1683830510350; Thu, 11 May
 2023 11:41:50 -0700 (PDT)
MIME-Version: 1.0
From: Ming Lin <minggr@gmail.com>
Date: Thu, 11 May 2023 11:41:39 -0700
Message-ID: <CAF1ivSZJjVq313Zg9nBF0S3DOun=-Vw8saZGPU5cGrB_woM-8g@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] Does dm-zoned support buffered write?
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi list,

I have an application that needs to use buffered_io to access SMR disk
for good performance.

From "ZBD Support Restrictions" at https://zonedstorage.io/docs/linux/overview
"
Direct IO Writes The kernel page cache does not guarantee that cached
dirty pages will be flushed to a block device in sequential sector
order. This can lead to unaligned write errors if an application uses
buffered writes to write to the sequential write required zones of a
device. To avoid this pitfall, applications that directly use a zoned
block device without a file system should always use direct I/O
operations to write to the sequential write required zones of a
host-managed disk (that is, they should issue write() system calls
with a block device "file open" that uses the O_DIRECT flag).
"

Raw zbd disk only supports direct_io.

Does dm-zoned support buffered io (without O_DIRECT)?

Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

