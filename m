Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C446C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 16:37:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9FD782482C
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 16:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FD782482C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-itTpJfo8PCqoBosTeY3h0Q-1; Wed, 18 Nov 2020 11:37:33 -0500
X-MC-Unique: itTpJfo8PCqoBosTeY3h0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3D39190D36B;
	Wed, 18 Nov 2020 16:37:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0D9C60853;
	Wed, 18 Nov 2020 16:37:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1394718095C9;
	Wed, 18 Nov 2020 16:37:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AIGbF3L028890 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 11:37:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D2642201EB53; Wed, 18 Nov 2020 16:37:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC91F2022796
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 16:37:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EAEF811E86
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 16:37:13 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-236-6GQidf3CPqSjrDJB58h9Aw-1; Wed, 18 Nov 2020 11:37:10 -0500
X-MC-Unique: 6GQidf3CPqSjrDJB58h9Aw-1
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0AIGXl5C080344; Wed, 18 Nov 2020 11:37:09 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34w4x3wy3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 18 Nov 2020 11:37:09 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AIGZT9r085111;
	Wed, 18 Nov 2020 11:37:09 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.71])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34w4x3wy2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 18 Nov 2020 11:37:09 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0AIGb7Jp003651; Wed, 18 Nov 2020 16:37:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
	(d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma02fra.de.ibm.com with ESMTP id 34t6v8arng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 18 Nov 2020 16:37:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
	[9.149.105.232])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0AIGZnQJ6029992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 18 Nov 2020 16:35:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D990652052;
	Wed, 18 Nov 2020 16:35:49 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.87.122])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 71A5352051;
	Wed, 18 Nov 2020 16:35:49 +0000 (GMT)
To: Mike Snitzer <snitzer@redhat.com>, Randy Dunlap <rdunlap@infradead.org>
References: <20201113225228.20563-1-rdunlap@infradead.org>
	<344abf76-9405-58ba-2dc4-27cab88c974d@de.ibm.com>
	<c29eeb5d-0683-49eb-f729-38b14fac7745@infradead.org>
	<20201117163147.GA27243@redhat.com> <20201118154944.GB545@redhat.com>
	<20201118160748.GA754@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <7ae2b73e-e6e5-3357-11e4-efd93e93ba35@de.ibm.com>
Date: Wed, 18 Nov 2020 17:35:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.3.1
In-Reply-To: <20201118160748.GA754@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-18_04:2020-11-17,
	2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 malwarescore=0
	suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0
	priorityscore=1501 lowpriorityscore=0 mlxlogscore=991 impostorscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011180113
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
Cc: linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] md: dm-writeback: add __noreturn to BUG-ging function
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 18.11.20 17:07, Mike Snitzer wrote:
> On Wed, Nov 18 2020 at 10:49am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> I don't think my suggestion will help.. given it'd still leave
>> persistent_memory_claim() without a return statement.
>>
>> Think it worthwhile to just add a dummy 'return 0;' after the BUG().
> 
> Decided to go with this, now staged for 5.11:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.11&id=a1e4865b4dda7071f3707f7e551289ead66e38b1
> 

Looks like a sane solution. Thank you for following up.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

