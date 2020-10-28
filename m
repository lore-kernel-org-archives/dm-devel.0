Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D46C55178
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:08:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6D2C206D9
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6D2C206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-9x43-Y-CMe2m9k7JO07N1g-1; Thu, 29 Oct 2020 05:08:08 -0400
X-MC-Unique: 9x43-Y-CMe2m9k7JO07N1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D3B110866B3;
	Thu, 29 Oct 2020 09:08:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 702F35D98C;
	Thu, 29 Oct 2020 09:08:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 43909181A87F;
	Thu, 29 Oct 2020 09:08:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09SG3T0j015884 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Oct 2020 12:03:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4596E1111A7A; Wed, 28 Oct 2020 16:03:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4181C1111A5D
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 16:03:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2A60185A79C
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 16:03:26 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-175-eg7kDmsjNgyYAOgh0JYJhg-1; Wed, 28 Oct 2020 12:03:21 -0400
X-MC-Unique: eg7kDmsjNgyYAOgh0JYJhg-1
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	09SFxC9k007759; Wed, 28 Oct 2020 16:03:21 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by aserp2120.oracle.com with ESMTP id 34cc7m0afj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL); Wed, 28 Oct 2020 16:03:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	09SG0Tls189667; Wed, 28 Oct 2020 16:01:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserp3030.oracle.com with ESMTP id 34cwunrm9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Oct 2020 16:01:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09SG1I8W010605;
	Wed, 28 Oct 2020 16:01:19 GMT
Received: from [20.15.0.202] (/73.88.28.6)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Wed, 28 Oct 2020 09:01:18 -0700
To: Mike Snitzer <snitzer@redhat.com>
References: <1603412870-3627-1-git-send-email-michael.christie@oracle.com>
	<20201027125506.GB13012@redhat.com>
From: Mike Christie <michael.christie@oracle.com>
Message-ID: <1097ab3b-c100-80e1-60fd-d2c300192784@oracle.com>
Date: Wed, 28 Oct 2020 11:01:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201027125506.GB13012@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	mlxscore=0 bulkscore=0
	spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2010280106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
	lowpriorityscore=0 adultscore=0
	malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
	priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2010280106
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 29 Oct 2020 05:07:36 -0400
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/1] dm mpath: add IO affinity path selector
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

On 10/27/20 7:55 AM, Mike Snitzer wrote:
> On Thu, Oct 22 2020 at  8:27pm -0400,
> Mike Christie <michael.christie@oracle.com> wrote:
> 
>> This patch adds a path selector that selects paths based on a CPU to
>> path mapping the user passes in and what CPU we are executing on. The
>> primary user for this PS is where the app is optimized to use specific
>> CPUs so other PSs undo the apps handy work, and the storage and it's
>> transport are not a bottlneck.
>>
>> For these io-affinity PS setups a path's transport/interconnect
>> perf is not going to flucuate a lot and there is no major differences
>> between paths, so QL/HST smarts do not help and RR always messes up
>> what the app is trying to do.
>>
>> On a system with 16 cores, where you have a job per CPU:
>>
>> fio --filename=/dev/dm-0 --direct=1 --rw=randrw --bs=4k \
>> --ioengine=libaio --iodepth=128 --numjobs=16
>>
>> and a dm-multipath device setup where each CPU is mapped to one path:
>>
>> // When in mq mode I had to set dm_mq_nr_hw_queues=$NUM_PATHS.
> 
> OK, the modparam was/is a means to an end but the default of 1 is very
> limiting (especially in that it becomes one-size-fits-all, which isn't
> true, for all dm-multipath devices in the system).
> 
> If you have any ideas for what a sane heuristic would be for
> dm_mq_nr_hw_queues I'm open to suggestions.  But DM target <-> DM core
> <-> early block core interface coordination is "fun". ;)
I do not have any good ideas.


> 
>> // Bio mode also showed similar results.
>> 0 16777216 multipath 0 0 1 1 io-affinity 0 16 1 8:16 1 8:32 2 8:64 4
>> 8:48 8 8:80 10 8:96 20 8:112 40 8:128 80 8:144 100 8:160 200 8:176
>> 400 8:192 800 8:208 1000 8:224 2000 8:240 4000 65:0 8000
>>
>> we can see a IOPs increase of 25%.
> 
> Great. What utility/code are you using to extract the path:cpu affinity?
> Is it array specific?  Which hardware pins IO like this?

It is not specific to an array.

We use it for iscsi. We have fast networks and arrays, but to better 
utilize them you need to use multiple iscsi sessions (tcp 
connection/socket). So you typically set it up like how nvme/tcp does 
its connections/queues by default where that driver will create a TCP 
connection per CPU then map the connection to a hw queue/ctx. For iscsi, 
we set the session's IO xmit thread's affinity, then setup networking so 
the socket/connection's IO is routed to the same CPU. We then create N 
sessions and do multipath over them.

> 
> Will you, or others, be enhancing multipath-tools to allow passing such
> io-affinity DM multipath tables?

Yeah, I am working on that.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

