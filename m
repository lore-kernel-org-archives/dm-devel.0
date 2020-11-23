Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BA9C63777
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:55:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5CA752073C
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CA752073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-1BXOjNhyMsKwFMoIcIX3dA-1; Tue, 24 Nov 2020 03:54:58 -0500
X-MC-Unique: 1BXOjNhyMsKwFMoIcIX3dA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBAE718C43CC;
	Tue, 24 Nov 2020 08:54:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF8495D9CD;
	Tue, 24 Nov 2020 08:54:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 859545002C;
	Tue, 24 Nov 2020 08:54:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ANJnSVt016947 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Nov 2020 14:49:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F174111287C; Mon, 23 Nov 2020 19:49:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19EC91004037
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 19:49:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F330E811E85
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 19:49:21 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-214-3l2pUfhbNqyz-YvpjC0xow-1; Mon, 23 Nov 2020 14:49:19 -0500
X-MC-Unique: 3l2pUfhbNqyz-YvpjC0xow-1
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0ANJVURA007842; Mon, 23 Nov 2020 14:49:19 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtt4m2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 23 Nov 2020 14:49:18 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ANJVerH008563;
	Mon, 23 Nov 2020 14:49:18 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtt4m20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 23 Nov 2020 14:49:18 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0ANJluVM026535; Mon, 23 Nov 2020 19:49:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 34xth8aurd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 23 Nov 2020 19:49:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
	[9.149.105.232])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0ANJnENL49152498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Mon, 23 Nov 2020 19:49:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D37952051;
	Mon, 23 Nov 2020 19:49:14 +0000 (GMT)
Received: from sig-9-65-241-175.ibm.com (unknown [9.65.241.175])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E380E52057;
	Mon, 23 Nov 2020 19:49:10 +0000 (GMT)
Message-ID: <7990c489ed6fb3ae36978820400b7cf60c55c126.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Date: Mon, 23 Nov 2020 14:49:10 -0500
In-Reply-To: <20201123171800.GA6407@duo.ucw.cz>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
	<20201120124657.GA31468@duo.ucw.cz>
	<aadf6e35-39bc-74d4-6ca3-d708860738a5@linux.microsoft.com>
	<20201122210031.GA26756@amd>
	<d82ad1cac36e948c904300548c64244c145589ee.camel@linux.ibm.com>
	<20201123171800.GA6407@duo.ucw.cz>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-23_17:2020-11-23,
	2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	adultscore=0 clxscore=1015
	mlxscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
	suspectscore=3
	bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
	priorityscore=1501
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011230124
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
X-Mailman-Approved-At: Tue, 24 Nov 2020 03:53:49 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	nramas@linux.microsoft.com, selinux@vger.kernel.org,
	stephen.smalley.work@gmail.com, jmorris@namei.org,
	linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, tyhicks@linux.microsoft.com,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 0/8] IMA: support for measuring kernel
 integrity critical data
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2020-11-23 at 18:18 +0100, Pavel Machek wrote:
> > > Basically every other data structure in kernel is "critical" by your
> > > definition, and you can't really measure them all; some of them change
> > > rather often. Going piecemeal does not really help here.
> > 
> > Agreed, measuring data structures that change is not really applicable.
> > However, measuring data structures that once initialized don't change,
> > does make sense (similar concept to __ro_after_init).  The attestation
> > server doesn't need to know anything about the measurement, other than
> > more than a single measurement is indicative of a problem.
> 
> So, why not simply measure everything that is ro_after_init?

I guess we could, but the original discussion, a long time ago prior to
LSM stacking, was limited to measuring the LSM hooks.

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

