Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285CDC433C1
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 11:55:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E9D16192B
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 11:55:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E9D16192B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-C7DRpwvHNam_ManroJe8Xw-1; Mon, 29 Mar 2021 07:55:54 -0400
X-MC-Unique: C7DRpwvHNam_ManroJe8Xw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA345802B62;
	Mon, 29 Mar 2021 11:55:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8300C6064B;
	Mon, 29 Mar 2021 11:55:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6C35A1809C84;
	Mon, 29 Mar 2021 11:55:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12PG7jkQ029090 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 12:07:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 754722026D64; Thu, 25 Mar 2021 16:07:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CAC02026D6B
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 16:07:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED0F28015B9
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 16:07:40 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-308-Zkk2S_9JM5OOol8kuSHFiQ-1; Thu, 25 Mar 2021 12:07:38 -0400
X-MC-Unique: Zkk2S_9JM5OOol8kuSHFiQ-1
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	12PG4h07133713
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 12:07:37 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 37gpm5dv78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT)
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 12:07:37 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PG50MA137450
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 12:07:37 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com
	[149.81.74.107])
	by mx0a-001b2d01.pphosted.com with ESMTP id 37gpm5dv6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 25 Mar 2021 12:07:36 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id
	12PG7Yn4031466; Thu, 25 Mar 2021 16:07:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03fra.de.ibm.com with ESMTP id 37d9bptwkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 25 Mar 2021 16:07:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com
	[9.149.105.60])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 12PG7WkL30212444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 25 Mar 2021 16:07:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37F974203F;
	Thu, 25 Mar 2021 16:07:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 244E842041;
	Thu, 25 Mar 2021 16:07:32 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.175.248])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
	Thu, 25 Mar 2021 16:07:32 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
	(envelope-from <bblock@linux.ibm.com>)
	id 1lPSWB-000Nzf-HB; Thu, 25 Mar 2021 17:07:31 +0100
Date: Thu, 25 Mar 2021 17:07:31 +0100
From: Benjamin Block <bblock@linux.ibm.com>
To: Erwin van Londen <erwin@erwinvanlonden.net>
Message-ID: <YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
In-Reply-To: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
X-TM-AS-GCONF: 00
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369, 18.0.761
	definitions=2021-03-25_04:2021-03-24,
	2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	adultscore=0 clxscore=1011
	impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
	phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103250114
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0a-001b2d01.pphosted.com id 12PG4h07133713
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12PG7jkQ029090
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 29 Mar 2021 07:55:44 -0400
Cc: Muneendra <muneendra.kumar@broadcom.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2021 at 05:52:33PM +1000, Erwin van Londen wrote:
> Hello All,
>=20
> Just wondering if there were any plans to incorporate FPIN
> congestion/latency notifications in dm-multipath to disperse IO over
> non-affected paths.
>=20

For whats worth, general support in Kernel for a new path state in
answer to existing FPIN notifications was added earlier this year:
https://lore.kernel.org/linux-scsi/1609969748-17684-1-git-send-email-muneen=
dra.kumar@broadcom.com/T/

But this only adds a new port-state and support of it for one particular
driver (lpfc). Not aware of any other driver supporting this new state
yet, but I might have missed it. Also, the port-state is not set in
kernel, but has to be set by something external, unlike with RSCNs,
where we set the state in the kernel.

What it does, once a path is set into 'Marginal' state, is to not retry
commands on the same shaky path, once it already failed one time
already.

As far as dm-multipath is concerned, I asked that as well when this
patch series was developed:
https://lore.kernel.org/linux-scsi/20201002162633.GA8365@t480-pf1aa2c2/
Hannes answered that in the thread:
https://lore.kernel.org/linux-scsi/ca995d96-608b-39b9-8ded-4a6dd7598660@sus=
e.de/

Not sure what happened in between, didn't see anything on the mpath
topic yet.


--=20
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Sys=
tems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/pri=
vacy
Vorsitz. AufsR.: Gregor Pillen         /        Gesch=E4ftsf=FChrung: Dirk =
Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: AmtsG Stuttgart, HRB =
243294


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

