Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B362EC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 23:57:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-1B9kySHNM1awCbZAyCD04A-1; Thu, 14 Apr 2022 19:57:53 -0400
X-MC-Unique: 1B9kySHNM1awCbZAyCD04A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B192A185A794;
	Thu, 14 Apr 2022 23:57:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9BED43E8E7;
	Thu, 14 Apr 2022 23:57:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC881194034A;
	Thu, 14 Apr 2022 23:57:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8CBB6194034A
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 23:57:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32ECA40D017A; Thu, 14 Apr 2022 23:57:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EAE940D0179
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 23:57:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 151F5101AA42
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 23:57:48 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265--nyEIlowPf6hVotggHK_2w-1; Thu, 14 Apr 2022 19:57:46 -0400
X-MC-Unique: -nyEIlowPf6hVotggHK_2w-1
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; d="scan'208";a="198851143"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 07:57:46 +0800
IronPort-SDR: yvHzJ6SF0PI19TscwxI2MU447rwYN//wKK1bs6gpjqa1q8PyvxZy2NHOzEETIN5EGN/sIo4wPv
 pJgJVoW5p9v0igpXQl8HQJqppqWKgs/iqL9o1kS2DhByk5Qebp4wVfy/NuURdNzl2aqerfoPG8
 1nvkZgNwMpcqDTyO9pklg0gvBkBuXMoSJunGz8TGTX1e+xhtNPTjvQBwVTjZo7pgyhXzeRa5Jj
 JnhaMTpCGlO8lk3iEXhauBS9MPul6pWOIdqO//MfN9w1b6yVZ9qtbBMi1Nai930yB/rFy+T21j
 jsQA6oOpYzkyUSEa/v7xiqqB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 14 Apr 2022 16:28:09 -0700
IronPort-SDR: I0fUFCd9eP0eTAYYEJUNOtorGwxhLMdO+KystiWsdwJfBcYtyyWK7tLxuSSRRojlK+Z81uP6BR
 AHm9hppTwrCJS1/CYCQeU0ED4b1zpvvY3XPjwDZqyw4fYkp7hW6L702ySXkxcg0hqCXfaj7E9g
 E8QNIHHLGzulGrYRGVAcMytNhAqiJXj0GqyAivxjBSoAYA+pQkjwx3m/WUOusYXDBQWDle4qTR
 ggqRDBCJclCJAWw2d7KVE2BOfDgx1xLMVkX83xcB8fBcgzyaQ8RYLElLDewthhUsdffWfsPkeR
 k5Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 14 Apr 2022 16:57:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KfbxN5m17z1SHwl
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 16:57:44 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id B9Z6H-AagFUC for <dm-devel@redhat.com>;
 Thu, 14 Apr 2022 16:57:44 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KfbxM4XBmz1Rvlx;
 Thu, 14 Apr 2022 16:57:43 -0700 (PDT)
Message-ID: <335390c8-8ea5-1e77-f5c3-a5d19b274eba@opensource.wdc.com>
Date: Fri, 15 Apr 2022 08:57:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Mike Snitzer <snitzer@kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20220414083436.pweunapygdtuzwaf@shindev>
 <YlhL878nAVPkNK1n@redhat.com> <YlhQKj0iLM8mT+WK@redhat.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlhQKj0iLM8mT+WK@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [bug report] BUG for REQ_OP_WRITE_ZEROES to dm-zoned
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Damien Le Moal <Damien.LeMoal@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/15/22 01:47, Mike Snitzer wrote:
> On Thu, Apr 14 2022 at 12:29P -0400,
> Mike Snitzer <snitzer@kernel.org> wrote:
>  
>> Thanks for the report, I've staged a fix here (btw, your change above
>> needs to be paired with the 2nd hunk of my fix otherwise you won't get
>> the bio split you desire):
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=3dfb6f5e95f26215ca08d348ca2ddb5ea6ea2349
>>
>> I'll be sending this to Linus later today or tomorrow.
> 
> FYI, I revised that commit with further cleanup to not pass
> 'unsigned *len' to alloc_multiple_bios(), this commit is what will be
> sent upstream soon:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=c2228f993c7592783b0a2bf7d169b17dfa4cbe2a

Looks good to me.

Nit: there is a typo in the commit message:

dm_accept_paertial_bio() -> dm_accept_partial_bio()

Feel free to add:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

