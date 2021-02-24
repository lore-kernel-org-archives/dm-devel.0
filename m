Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD00C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 00:44:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07BF864DB1
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 00:44:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07BF864DB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-YATa1wA-M8ai4qcJD4GBvA-1; Tue, 23 Feb 2021 19:44:56 -0500
X-MC-Unique: YATa1wA-M8ai4qcJD4GBvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B30C9803F47;
	Wed, 24 Feb 2021 00:44:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C2BE5E1A7;
	Wed, 24 Feb 2021 00:44:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07D3E4E58E;
	Wed, 24 Feb 2021 00:44:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O0imZF026698 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 19:44:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D8B4F21121A4; Wed, 24 Feb 2021 00:44:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D37832126CA2
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 00:44:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A34F85A59D
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 00:44:46 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-73-25KDDIcDNKicSO-ALhbUnA-1; Tue, 23 Feb 2021 19:44:42 -0500
X-MC-Unique: 25KDDIcDNKicSO-ALhbUnA-1
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	11O0buQc108082; Tue, 23 Feb 2021 19:44:40 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfm5nkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 23 Feb 2021 19:44:40 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11O0ht0b147073;
	Tue, 23 Feb 2021 19:43:55 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfm5njp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 23 Feb 2021 19:43:55 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	11O0RwxR017511; Wed, 24 Feb 2021 00:43:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com
	(d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma02fra.de.ibm.com with ESMTP id 36tt289m58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 24 Feb 2021 00:43:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 11O0houY36110818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 24 Feb 2021 00:43:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B816F42041;
	Wed, 24 Feb 2021 00:43:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 161C242042;
	Wed, 24 Feb 2021 00:43:48 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.211.65.43]) by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 24 Feb 2021 00:43:47 +0000 (GMT)
Message-ID: <0a25f4b7ed53566b13211d5aeea18e7f13f12bd7.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Petr Vorel <pvorel@suse.cz>, ltp@lists.linux.it
Date: Tue, 23 Feb 2021 19:43:46 -0500
In-Reply-To: <20210223225930.27095-1-pvorel@suse.cz>
References: <20210223225930.27095-1-pvorel@suse.cz>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369, 18.0.761
	definitions=2021-02-23_12:2021-02-23,
	2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	impostorscore=0 mlxscore=0
	priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
	phishscore=0
	clxscore=1015 malwarescore=0 adultscore=0 spamscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102240001
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
Cc: snitzer@redhat.com, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	dm-devel@redhat.com, Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org,
	Mimi Zohar <zohar@linux.vnet.ibm.com>, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 0/2]	IMA: Add test for dm-crypt measurement
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Petr,

On Tue, 2021-02-23 at 23:59 +0100, Petr Vorel wrote:
> Hi!
> 
> I updated Tushar's patchset to speedup things.
> 
> Changes v2->v3
> * rename function s/check_ima_ascii_log_for_policy/test_policy_measurement/
> * move tst_res TPASS/TFAIL into test_policy_measurement()
> * drop template=ima-buf (see Lakshmi's patch [1] and discussion about
>   it, it will be removed from ima_keys.sh as well)
> * moved ima_dm_crypt.sh specific changes to second commit
> * further API and style related cleanup
> 
> Could you please check this patchset?

I'm not sure about the status of the associated IMA dm-crypt kernel
patch set.  It hasn't even been reviewed, definitely not upstreamed.  
 I would hold off on upstreaming the associated ltp test.

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

