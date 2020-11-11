Return-Path: <SRS0=f+1/=ER=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C955C388F9
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:45:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B54C820659
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:45:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B54C820659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-CsTdRxvRNW6xp-Z01XLV1Q-1; Wed, 11 Nov 2020 13:45:48 -0500
X-MC-Unique: CsTdRxvRNW6xp-Z01XLV1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B739F87951F;
	Wed, 11 Nov 2020 18:45:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99D0D6EF5F;
	Wed, 11 Nov 2020 18:45:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6FAFB5810F;
	Wed, 11 Nov 2020 18:45:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ABGl2mk000900 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Nov 2020 11:47:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DA5F12166BDD; Wed, 11 Nov 2020 16:47:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4E662166BA3
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 16:46:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84D9490E420
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 16:46:59 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-14-TeRkglYtPzeY3XLVETEixg-1; Wed, 11 Nov 2020 11:46:56 -0500
X-MC-Unique: TeRkglYtPzeY3XLVETEixg-1
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0ABGiUn2183582; Wed, 11 Nov 2020 16:46:54 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by aserp2120.oracle.com with ESMTP id 34nkhm1rrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL); Wed, 11 Nov 2020 16:46:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0ABGit0O102915; Wed, 11 Nov 2020 16:46:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserp3020.oracle.com with ESMTP id 34p5g1x1pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Nov 2020 16:46:54 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ABGkqPe012270;
	Wed, 11 Nov 2020 16:46:52 GMT
Received: from [20.15.0.8] (/73.88.28.6)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Wed, 11 Nov 2020 08:46:52 -0800
To: Mike Snitzer <snitzer@redhat.com>,
	Colin Ian King <colin.king@canonical.com>
References: <c5c17cba-3bf2-ce07-ed7f-6e5b5e71427c@canonical.com>
	<20201111152436.GA22834@redhat.com>
From: Mike Christie <michael.christie@oracle.com>
Message-ID: <3e6c7eb4-c454-98e9-e25c-f4daff19bccb@oracle.com>
Date: Wed, 11 Nov 2020 10:46:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201111152436.GA22834@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	spamscore=0 malwarescore=0
	adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011110099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	priorityscore=1501
	mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
	spamscore=0
	malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011110099
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 11 Nov 2020 13:39:49 -0500
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: rename multipath path selector source files to
 have "dm-ps" prefix
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/11/20 9:24 AM, Mike Snitzer wrote:
> On Wed, Nov 11 2020 at  6:45am -0500,
> Colin Ian King <colin.king@canonical.com> wrote:
> 
>> Hi,
>>
>> Static analysis on linux-next has detected an initialized variable issue
>> with the following recent commit:
>>
>> commit 28784347451fdbf4671ba97018f816041ba2306a
>> Author: Mike Snitzer <snitzer@redhat.com>
>> Date:   Tue Nov 10 13:41:53 2020 -0500
>>
>>      dm: rename multipath path selector source files to have "dm-ps" prefix
>>
>> The analysis is as follows:
>>
>>   43
>> static int ioa_add_path(struct path_selector *ps, struct dm_path *path,
>>   44                        int argc, char **argv, char **error)
>>   45 {
>>   46        struct selector *s = ps->context;
>>   47        struct path_info *pi = NULL;
>>     1. var_decl: Declaring variable cpu without initializer.
>>
>>   48        unsigned int cpu;
>>   49        int ret;
>>   50
>>     2. Condition argc != 1, taking false branch.
>>
>>   51        if (argc != 1) {
>>   52                *error = "io-affinity ps: invalid number of arguments";
>>   53                return -EINVAL;
>>   54        }
>>   55
>>
>>     Uninitialized scalar variable (UNINIT)
>>     3. uninit_use_in_call: Using uninitialized value cpu when calling
>> __cpu_to_node.
>>
>>   56        pi = kzalloc_node(sizeof(*pi), GFP_KERNEL, cpu_to_node(cpu));
>>   57        if (!pi) {
>>   58                *error = "io-affinity ps: Error allocating path context";
>>   59                return -ENOMEM;
>>   60        }
> 
> Valid report, but it focuses on a follow-on commit that is just noise.
> The commit "dm mpath: add IO affinity path selector" is what is in
> quesation, see:
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.11&id=c3d0a31e609e299836fa6ced28cb9ec06b408181__;!!GqivPVa7Brio!KJegykpnucM-IY4IWXzkUVvJeWoxyfPKk8SAwHrcy8iMldT01JwSwV-Jelxc3x0461yv$
> 
> Regardless, Mike Christie, Colin's report has identified a bug.
> 
> Please advise on how you'd like to fix ioa_add_path()'s allocation of
> 'struct path_info'.. pretty sure 'cpu' will default to 0 (on stack)
> despite no explicit initialization... so code "works" but does not
> do so with a specific cpu allocation affinity.
> 

I meant to drop the kzalloc_node and use kzalloc. I had experimented 
with allocating structs on specific nodes, but I didn't see much 
improvement.

Do you prefer I send a patch on top of what's in your branch now, or is 
that like a staging type of branch where you'll drop my original patch 
and want me to resubmit the original patch with the fix integrated?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

