Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3029C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:34:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4142560F5D
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4142560F5D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-V3jHrejDPoKPRNl-HhaIVA-1; Mon, 26 Jul 2021 12:34:46 -0400
X-MC-Unique: V3jHrejDPoKPRNl-HhaIVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4650B87D541;
	Mon, 26 Jul 2021 16:34:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC4025D9D3;
	Mon, 26 Jul 2021 16:34:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 31220180BAB0;
	Mon, 26 Jul 2021 16:34:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16QGXbJ2016681 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Jul 2021 12:33:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2278F10054C8; Mon, 26 Jul 2021 16:33:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DBBE100402C
	for <dm-devel@redhat.com>; Mon, 26 Jul 2021 16:33:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27A9D10AF951
	for <dm-devel@redhat.com>; Mon, 26 Jul 2021 16:33:34 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-513-iwzCdGZoOaeFcWdVN16EJQ-1; Mon, 26 Jul 2021 12:33:30 -0400
X-MC-Unique: iwzCdGZoOaeFcWdVN16EJQ-1
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16QGGT69141727; Mon, 26 Jul 2021 12:33:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3a20e1rkyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 26 Jul 2021 12:33:29 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16QGIUMp147316;
	Mon, 26 Jul 2021 12:33:28 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3a20e1rky0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 26 Jul 2021 12:33:28 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16QGXFkD003110;
	Mon, 26 Jul 2021 16:33:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma01fra.de.ibm.com with ESMTP id 3a0ag8rsgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 26 Jul 2021 16:33:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 16QGUkD925559434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Mon, 26 Jul 2021 16:30:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2596211C04C;
	Mon, 26 Jul 2021 16:33:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B006D11C04A;
	Mon, 26 Jul 2021 16:33:22 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.95.94]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 26 Jul 2021 16:33:22 +0000 (GMT)
Message-ID: <8cea95cdc1349ae60c690c45ddabcd676c5774d2.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, dm-devel@redhat.com,
	agk@redhat.com, snitzer@redhat.com
Date: Mon, 26 Jul 2021 12:33:21 -0400
In-Reply-To: <6b81b92f-7d7b-d198-5056-bab1bcbac522@linux.microsoft.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-8-tusharsu@linux.microsoft.com>
	<205b5336d60aee6b3f33ad67b2d0250e104d6779.camel@linux.ibm.com>
	<6b81b92f-7d7b-d198-5056-bab1bcbac522@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _i1zpNSZi7F2wvEVb4PHQGSMRvpBKdsB
X-Proofpoint-GUID: lxIxJ-YEUw1ZmFrvtUJzKNRV9q4SPX9-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
	definitions=2021-07-26_10:2021-07-26,
	2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 bulkscore=0
	impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
	priorityscore=1501 phishscore=0 clxscore=1015 mlxlogscore=999
	spamscore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260093
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
Cc: nramas@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 7/7] dm: add documentation for IMA
	measurement support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

On Sat, 2021-07-24 at 00:25 -0700, Tushar Sugandhi wrote:
> Hi Mimi,
> 
> 
> > Missing from the document is a way of validating the template data.
> > For example, in the original case of file measurements, the template
> > data contains the file hash, which can be recalculated or verified
> > against an allow list.
> > 
> > Other than re-calculating the template data digest based on the
> > template data, and verifying it against the template data digest in the
> > measurement list, would an attestation server be able to verify the
> > template data itself?
> >
> Yes.
> In the context of device-mapper, EVENT_DATA for 'table_load' would
> contain the key-value pairs for various targets in the table
> (crypt, verity, integrity etc.) which the attestation servers
> should be able to verify against the allowed/expected
> key-value pairs specified in the attestation policy.
> 
> To avoid bloating the IMA log with same data from table_load again,
> we only measure hash of the loaded table in the EVENT_DATA -
> when there is a state change for DM device.
> e.g. when EVENT_NAME is 'device_resume', 'table_clear',
> 'device_remove' etc.
> 
> Since the table clear-text is already present in the EVENT_DATA
> buffer for 'table_load', and is available to attestation servers,
> verifying the corresponding hash values in the
> EVENT_DATA in the subsequent DM events should be possible for
> the attestation servers.
> 
> Please let us know if you need further info.

For regular files with signatures, the file signature is verified
against the file hash, both contained within the template data.  For
the SELinux "critical-data", 
commit 2554a48f4437 ("selinux: measure state and policy capabilities")
contains that information.  Missing from this patch set is information
on how the attestation server could verify the DM critical data.

Does the DM record contain everything needed for the attestion server
to verify the template record?  Are things like the hash algorithm hard
coded?

thanks,

Mimi



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

