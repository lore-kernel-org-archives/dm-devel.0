Return-Path: <SRS0=+Jjt=MN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C71C07E9B
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:34:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9AE8C611C1
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AE8C611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-U31upRrgMSmn6N6cU6OeqA-1; Tue, 20 Jul 2021 22:34:18 -0400
X-MC-Unique: U31upRrgMSmn6N6cU6OeqA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4238C1005E4C;
	Wed, 21 Jul 2021 02:34:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1610060843;
	Wed, 21 Jul 2021 02:34:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 276C64EA2A;
	Wed, 21 Jul 2021 02:34:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16L2YAVm023045 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Jul 2021 22:34:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ED58EDAF0A; Wed, 21 Jul 2021 02:34:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7E4EDAF1C
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 02:34:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E1C0811E78
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 02:34:06 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-375-gtPljSQMPFyWJMO1uSp20w-1; Tue, 20 Jul 2021 22:34:03 -0400
X-MC-Unique: gtPljSQMPFyWJMO1uSp20w-1
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16L2XQlm106094; Tue, 20 Jul 2021 22:34:02 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39x7yy3qwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 20 Jul 2021 22:34:02 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16L2Y1QT108360;
	Tue, 20 Jul 2021 22:34:01 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39x7yy3quy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 20 Jul 2021 22:34:01 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16L2GN7w018099;
	Wed, 21 Jul 2021 02:33:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06fra.de.ibm.com with ESMTP id 39upfh8y75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 21 Jul 2021 02:33:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 16L2VXW019530210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 21 Jul 2021 02:31:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7893011C04A;
	Wed, 21 Jul 2021 02:33:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B71BD11C04C;
	Wed, 21 Jul 2021 02:33:53 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.1.44]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 21 Jul 2021 02:33:53 +0000 (GMT)
Message-ID: <205b5336d60aee6b3f33ad67b2d0250e104d6779.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, dm-devel@redhat.com,
	agk@redhat.com, snitzer@redhat.com
Date: Tue, 20 Jul 2021 22:33:52 -0400
In-Reply-To: <20210713004904.8808-8-tusharsu@linux.microsoft.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-8-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: maFkSLTRHPigWgsGhjbcuDWa3yIi1QBN
X-Proofpoint-ORIG-GUID: bSuJgCNjNuyoQE09DKTHa7DqmzA-dGOk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
	definitions=2021-07-20_15:2021-07-19,
	2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	spamscore=0
	lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
	suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
	phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107210012
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar, Mike,

On Mon, 2021-07-12 at 17:49 -0700, Tushar Sugandhi wrote:
> +Then IMA ASCII measurement log has the following format:
> +PCR TEMPLATE_DIGEST TEMPLATE ALG:EVENT_DIGEST EVENT_NAME EVENT_DATA
> +
> +PCR := Platform Configuration Register, in which the values are registered.
> +       This is applicable if TPM chip is in use.
> +TEMPLATE_DIGEST := Template digest of the IMA record.

^TEMPLATE_DATA_DIGEST

> +TEMPLATE := Template that registered the integrity value (e.g. ima-buf).

^TEMPLATE_NAME

The template data format consists of:
> +ALG:EVENT_DIGEST = Algorithm to compute event digest, followed by digest of event data
> +EVENT_NAME := Description of the event (e.g. 'table_load').
> +EVENT_DATA := The event data to be measured.

Missing from the document is a way of validating the template data. 
For example, in the original case of file measurements, the template
data contains the file hash, which can be recalculated or verified
against an allow list.

Other than re-calculating the template data digest based on the
template data, and verifying it against the template data digest in the
measurement list, would an attestation server be able to verify the
template data itself?

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

