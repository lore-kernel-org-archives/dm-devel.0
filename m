Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C09C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:54:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9735E64E8A
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:54:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9735E64E8A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-jVPA99vbPy2S9QYya048CQ-1; Tue, 09 Feb 2021 13:54:28 -0500
X-MC-Unique: jVPA99vbPy2S9QYya048CQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 668B4106BB4B;
	Tue,  9 Feb 2021 18:54:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 128E35D9C0;
	Tue,  9 Feb 2021 18:54:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73AA218095CB;
	Tue,  9 Feb 2021 18:54:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119IsJKI001176 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 13:54:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1B807112D438; Tue,  9 Feb 2021 18:54:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17B09112D436
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:54:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00B3E185A793
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:54:17 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-515-DvSqduj9Mv-6f-RtBxxM-Q-1; Tue, 09 Feb 2021 13:54:14 -0500
X-MC-Unique: DvSqduj9Mv-6f-RtBxxM-Q-1
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	119Is76U159528; Tue, 9 Feb 2021 13:54:14 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 36kycu99a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 09 Feb 2021 13:54:14 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119IsDIR160458;
	Tue, 9 Feb 2021 13:54:13 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 36kycu994f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 09 Feb 2021 13:54:13 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	119IkxF4012350; Tue, 9 Feb 2021 18:54:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com
	(d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma02fra.de.ibm.com with ESMTP id 36hjr89x4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 09 Feb 2021 18:54:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
	[9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 119IrwJH27394458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 9 Feb 2021 18:53:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1BCF5204E;
	Tue,  9 Feb 2021 18:53:58 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.79.210])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 75F275204F;
	Tue,  9 Feb 2021 18:53:56 +0000 (GMT)
Message-ID: <38ba5889d517ee010a6bf370f8892059dd7d3bfe.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Tue, 09 Feb 2021 13:53:55 -0500
In-Reply-To: <c5ecccbe-9e23-f297-8a79-2a9dd62a40fb@linux.microsoft.com>
References: <20210130004519.25106-1-tusharsu@linux.microsoft.com>
	<27f73411fc1d6ce6dd16a29344d729d9aa760250.camel@linux.ibm.com>
	<27a4592c3b75861d2b9c8fb1511f593aa987222c.camel@linux.ibm.com>
	<c5ecccbe-9e23-f297-8a79-2a9dd62a40fb@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369, 18.0.737
	definitions=2021-02-09_05:2021-02-09,
	2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	suspectscore=0
	lowpriorityscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
	bulkscore=0
	malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
	priorityscore=1501
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102090086
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
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/3] support for duplicate measurement of
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

On Tue, 2021-02-09 at 10:23 -0800, Tushar Sugandhi wrote:
> > On Mon, 2021-02-08 at 15:22 -0500, Mimi Zohar wrote:
> >> On Fri, 2021-01-29 at 16:45 -0800, Tushar Sugandhi wrote:
> >>> IMA does not measure duplicate buffer data since TPM extend is a very
> >>> expensive operation.  However, in some cases for integrity critical
> >>> data, the measurement of duplicate data is necessary to accurately
> >>> determine the current state of the system.  Eg, SELinux state changing
> >>> from 'audit', to 'enforcing', and back to 'audit' again.  In this
> >>> example, currently, IMA will not measure the last state change to
> >>> 'audit'.  This limits the ability of attestation services to accurately
> >>> determine the current state of the integrity critical data on the
> >>> system.
> >>>
> >>> This series addresses this gap by providing the ability to measure
> >>> duplicate entries for integrity critical data, driven by policy.
> >>
> >> The same reason for re-measuring buffer data is equally applicable to
> >> files.  In both cases, the file or the buffer isn't re-measured if it
> >> already exists in the htable.   Please don't limit this patch set to
> >> just buffer data.
> > 
> Agreed.  I wasn't sure if you wanted the support for files, or other 
> buffer measurement scenarios, except critical data.  So I started the 
> implementation with supporting just critical data.  Happy to extend it 
> to files and other buffer measurement scenarios as you suggested.
> 
> > Instead of making the change on a per measurement rule basis, disabling
> > "htable" would be the simplest way of forcing re-measurements.  All
> > that would be needed is a new Kconfig (e.g. CONFIG_IMA_DISABLE_HTABLE)
> > and the associated test in ima_add_template_entry().
> > 
> Agreed.  Earlier I wasn't sure if you wanted allow_dup support for all 
> the scenarios.  Now that it is clear,  I will implement it as you 
> suggested.  Thank you so much for the pointers.  Appreciate it.

There are two different solutions - per measurement rule, disabling
htable - being discussed.   Disabling htable requires miminumal
changes.  Which version are you thinking of implementing?

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

