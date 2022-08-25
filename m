Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FF4C3F6B0
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661388909;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+6SgG/Ffhth9sh+ae7BhfQetLs3N7391cbdbGO13tcQ=;
	b=chjECklAChmvGbb7AWz0XqSTV+ohTSHPzXlOSRwQomc4NWE8OZMqdRp7p2fXdk9xqX2F7n
	epAWE0sJVvfjqp5qhIvTAQjuvJ1FbygFHKttPO1qYQjWDVhWU/cn+OMPA2slq8h+Hkhl+T
	WtlYuU0vFiRkvYZhCbPMBdtPwMkei1Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-LrV3nW3TMtiBEok4p_PgNA-1; Wed, 24 Aug 2022 20:55:06 -0400
X-MC-Unique: LrV3nW3TMtiBEok4p_PgNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CDC71C006B6;
	Thu, 25 Aug 2022 00:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D254BC15BB3;
	Thu, 25 Aug 2022 00:55:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 83CF91946A5E;
	Thu, 25 Aug 2022 00:55:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 732961946A5A
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 00:15:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 674F9403348; Thu, 25 Aug 2022 00:15:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63109492C3B
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 00:15:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4988785A589
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 00:15:37 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-iGsMMEpvPrWB8YC-YeJyqg-1; Wed, 24 Aug 2022 20:15:35 -0400
X-MC-Unique: iGsMMEpvPrWB8YC-YeJyqg-1
X-IronPort-AV: E=Sophos;i="5.93,261,1654531200"; d="scan'208";a="210094050"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 25 Aug 2022 08:15:32 +0800
IronPort-SDR: LUcqCMDAgKBEqJ7s+6vn1Fxpo6E9dNIuAp5aSYbWCCBhSL3bQmNc9CsLKjPic2/qmGgASU9oL/
 XVy65qy95zJEAfAksnsu0057bGUNEIli5SXObbZMH6AaE1P+gFJAo0te8bIue5GWcYyeb3Rsdo
 HVwbZXs26UzO0QathwQLg8QHG5cfhh4fBa0vAnRxPw/YMrC43r9H2XAceO3Xj5nDOfOeTKmev6
 rHMPp7oBghinPkMc1Kz/bSmGxq7XhNCXLkiw2sF4/S/8DilHcQJ5edkfXKuEMQSyNFixPmS2/W
 DUvEn3cQRPNLnNV0C9Q3F08M
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 24 Aug 2022 16:30:48 -0700
IronPort-SDR: ipBXmalW0M6ra7Z+l055SN8CneMZ1MJRFct8IIIWvSyDREqq6CJV4W1V317FbF3ms4XbZmDZ42
 BBITzucV4r7F4rH5fnPl6zleZl+DzRpyOUzdtIWJpvMYrOP0G7aPJgi+PqQK8Qnq1xpDl73Sp4
 OJCeL4yAP0sw5Ik7dNPeA+y+FYEctN/dq1+2CkfgVwxmfA+4rRdA+wNj6Klh28CqUuhkyjjWFR
 ON6+L1ylOYUJcy95omiCmXYg/PyF3hayjMlN4MOMlrCcZCznNVkLUwJIbBAqcnUwCvIZl7zobg
 VZg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 24 Aug 2022 17:15:32 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MCk500Vbfz1Rwnm
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 17:15:32 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id H11JYKb21lUF for <dm-devel@redhat.com>;
 Wed, 24 Aug 2022 17:15:31 -0700 (PDT)
Received: from [10.89.82.240] (c02drav6md6t.dhcp.fujisawa.hgst.com
 [10.89.82.240])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MCk4x5QNsz1RtVk;
 Wed, 24 Aug 2022 17:15:29 -0700 (PDT)
Message-ID: <589cb29e-d2aa-085f-db83-fa718f4fbef2@opensource.wdc.com>
Date: Wed, 24 Aug 2022 17:15:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
To: Bart Van Assche <bvanassche@acm.org>,
 Adam Manzanares <a.manzanares@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2@uscas1p1.samsung.com>
 <20220522220128.GA347919@bgt-140510-bm01>
 <89b2bb4b-1848-22cc-9814-6cb6726afc18@acm.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <89b2bb4b-1848-22cc-9814-6cb6726afc18@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [ANNOUNCE] CFP: Zoned Storage Microconference -
 Linux Plumbers Conference 2022
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
Cc: Matias Bjorling <Matias.Bjorling@wdc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/08/24 16:43, Bart Van Assche wrote:
> On 5/22/22 15:01, Adam Manzanares wrote:
>> Zoned Storage Devices (SMR HDDs and ZNS SSDs) have demonstrated that they can
>> improve storage capacity, throughput, and latency over conventional storage
>> devices for many workloads. Zoned storage technology is deployed at scale in
>> some of the largest data centers in the world. There's already a
>> well-established set of storage vendors with increasing device availability and
>> a mature software foundation for interacting with zoned storage devices is
>> available. Zoned storage software support is evolving and their is room for
>> increased file-system support and additional userspace applications.
>>
>> The Zoned Storage microconference focuses on evolving the Linux zoned
>> storage ecosystem by improving kernel support, file systems, and applications.
>> In addition, the forum allows us to open the discussion to incorporate and grow
>> the zoned storage community making sure to meet everyone's needs and
>> expectations. Finally, it is an excellent opportunity for anyone interested in
>> zoned storage devices to meet and discuss how we can move the ecosystem forward
>> together.
> 
> Hi Adam,
> 
> On https://lpc.events/event/16/contributions/1147/ I see four speakers 
> but no agenda? Will an agenda be added before the microconference starts?

And the speaker list is not up-to-date either. I am a speaker too :)

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

