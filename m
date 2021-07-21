Return-Path: <SRS0=+Jjt=MN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA01C636C8
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:12:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 95A2961175
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 02:12:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95A2961175
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-TjmPWLl3O6mPcAnjz-FPsw-1; Tue, 20 Jul 2021 22:12:42 -0400
X-MC-Unique: TjmPWLl3O6mPcAnjz-FPsw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC6491084F4B;
	Wed, 21 Jul 2021 02:12:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A55C519C59;
	Wed, 21 Jul 2021 02:12:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA3084E9F5;
	Wed, 21 Jul 2021 02:12:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16L2CVXJ021889 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Jul 2021 22:12:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DF7E32063238; Wed, 21 Jul 2021 02:12:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAF6D2063FE5
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 02:12:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C0E11857F00
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 02:12:29 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-360-2iABop76PVG7icqHvzF8OA-1; Tue, 20 Jul 2021 22:12:24 -0400
X-MC-Unique: 2iABop76PVG7icqHvzF8OA-1
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16L24nUv166445; Tue, 20 Jul 2021 22:12:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39x9qt90wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 20 Jul 2021 22:12:23 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16L24rQo166933;
	Tue, 20 Jul 2021 22:12:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39x9qt90wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 20 Jul 2021 22:12:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16L26nwS030998;
	Wed, 21 Jul 2021 02:12:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma04ams.nl.ibm.com with ESMTP id 39upu89m1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 21 Jul 2021 02:12:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 16L29rnT33292672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 21 Jul 2021 02:09:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 201A642047;
	Wed, 21 Jul 2021 02:12:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B2144203F;
	Wed, 21 Jul 2021 02:12:17 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.1.44]) by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 21 Jul 2021 02:12:17 +0000 (GMT)
Message-ID: <713d22788b678c612c5b18edfb8cf849af61ace5.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, dm-devel@redhat.com,
	agk@redhat.com, snitzer@redhat.com
Date: Tue, 20 Jul 2021 22:12:16 -0400
In-Reply-To: <20210713004904.8808-2-tusharsu@linux.microsoft.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-2-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 79jdo0nO-QNTfHHtwpfqzOtWJRvrHkbh
X-Proofpoint-GUID: dzlqLIGBHHubEGGg21U5TUE-vA9LHnpt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
	definitions=2021-07-20_15:2021-07-19,
	2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	lowpriorityscore=0 mlxscore=0
	suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0
	impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501
	clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107210010
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
Cc: nramas@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/7] dm: measure data on table load
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar, Mike, 

On Mon, 2021-07-12 at 17:48 -0700, Tushar Sugandhi wrote:
> +struct dm_ima_device_table_metadata {
> +       /*
> +        * Contains data specific to the device which is common across
> +        * all the targets in the table.e.g. name, uuid, major, minor etc.
> +        * The values are stored in comma separated list of key1=val1,key2=val2; pairs
> +        * delimited by a semicolon at the end of the list.
> +        */
> +       char *device_metadata;
> +       unsigned int device_metadata_len;
> +       unsigned int num_targets;
> +
> +       /*
> +        * Contains the sha256 hashs of the IMA measurements of the
> +        * target attributes key-value pairs from the active/inactive tables.
> +        */

>From past experience hard coding the hash algorithm is really not a
good idea.

Mimi

> +       char *hash;
> +       unsigned int hash_len;
> +
> +};


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

