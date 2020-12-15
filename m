Return-Path: <SRS0=VSmt=FT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02D2C2BB9A
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EED2C2220F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EED2C2220F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-iIMACro5MnmXZZGUjRmfrw-1; Tue, 15 Dec 2020 05:00:16 -0500
X-MC-Unique: iIMACro5MnmXZZGUjRmfrw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99A73107ACF5;
	Tue, 15 Dec 2020 10:00:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74F4B62A22;
	Tue, 15 Dec 2020 10:00:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B73E1809CA0;
	Tue, 15 Dec 2020 10:00:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BF6xPZR022061 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Dec 2020 01:59:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DC7085D20B; Tue, 15 Dec 2020 06:59:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5A4730BA4
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 06:59:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB416800969
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 06:59:23 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-225-p7SW1ccmMDOVEhAOWNEWog-1; Tue, 15 Dec 2020 01:59:19 -0500
X-MC-Unique: p7SW1ccmMDOVEhAOWNEWog-1
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0BF6is6M148114; Tue, 15 Dec 2020 06:51:31 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 35cn9r8xk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL); Tue, 15 Dec 2020 06:51:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0BF6e6Iq070502; Tue, 15 Dec 2020 06:51:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userp3030.oracle.com with ESMTP id 35d7svqjj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Dec 2020 06:51:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BF6pROv024807;
	Tue, 15 Dec 2020 06:51:28 GMT
Received: from [192.168.1.10] (/180.164.31.21)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Mon, 14 Dec 2020 22:51:27 -0800
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>,
	Sergei Shtepa <sergei.shtepa@veeam.com>, hch@lst.de
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com> <20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com> <20201211163049.GC16168@redhat.com>
	<1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
	<208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <cdc3c792-17ac-de61-12ae-74691769fc3c@oracle.com>
Date: Tue, 15 Dec 2020 14:51:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0
	mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012150045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxlogscore=999
	impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
	malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012150045
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Dec 2020 04:59:49 -0500
Cc: "steve@sk2.org" <steve@sk2.org>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@redhat.com, "koct9i@gmail.com" <koct9i@gmail.com>
Subject: Re: [dm-devel] [PATCH 0/3] block: blk_interposer - Block Layer
	Interposer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Folks,

On 12/12/20 12:56 AM, Hannes Reinecke wrote:
> On 12/11/20 5:33 PM, Jens Axboe wrote:
>> On 12/11/20 9:30 AM, Mike Snitzer wrote:
>>> While I still think there needs to be a proper _upstream_ consumer of
>>> blk_interposer as a condition of it going in.. I'll let others make the
>>> call.
>>
>> That's an unequivocal rule.
>>
>>> As such, I'll defer to Jens, Christoph and others on whether your
>>> minimalist blk_interposer hook is acceptable in the near-term.
>>
>> I don't think so, we don't do short term bandaids just to plan on
>> ripping that out when the real functionality is there. IMHO, the dm
>> approach is the way to go - it provides exactly the functionality that
>> is needed in an appropriate way, instead of hacking some "interposer"
>> into the core block layer.
>>
> Which is my plan, too.
> 
> I'll be working with the Veeam folks to present a joint patchset (including the DM bits) for the next round.
> 

Besides the dm approach, do you think Veeam's original requirement is a good
use case of "block/bpf: add eBPF based block layer IO filtering"?
https://lwn.net/ml/bpf/20200812163305.545447-1-leah.rumancik@gmail.com/

Thanks,
Bob

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

