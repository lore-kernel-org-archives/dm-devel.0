Return-Path: <SRS0=+Jjt=MN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1701BC6377B
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 21:17:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 697F261001
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 21:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 697F261001
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-KlwIr_tEMrKzmkHvmmzglA-1; Wed, 21 Jul 2021 17:17:34 -0400
X-MC-Unique: KlwIr_tEMrKzmkHvmmzglA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF1CA107ACF5;
	Wed, 21 Jul 2021 21:17:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0A4A60C5F;
	Wed, 21 Jul 2021 21:17:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 186344BB7C;
	Wed, 21 Jul 2021 21:17:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16LLHNWM022025 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Jul 2021 17:17:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6EAD42028640; Wed, 21 Jul 2021 21:17:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 690FD20D6995
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 21:17:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9036780120D
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 21:17:20 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-526-VyFsHwy7PYadklMKq55p0g-1; Wed, 21 Jul 2021 17:17:18 -0400
X-MC-Unique: VyFsHwy7PYadklMKq55p0g-1
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16LL5rd3087614; Wed, 21 Jul 2021 17:17:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39xs903bak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 21 Jul 2021 17:17:16 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16LL5mQN087418;
	Wed, 21 Jul 2021 17:17:16 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39xs903b9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 21 Jul 2021 17:17:16 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16LLHECm026737;
	Wed, 21 Jul 2021 21:17:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 39vng71qrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 21 Jul 2021 21:17:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com
	[9.149.105.60])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 16LLElB925624832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 21 Jul 2021 21:14:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFA104203F;
	Wed, 21 Jul 2021 21:17:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 648EF42041;
	Wed, 21 Jul 2021 21:17:10 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.57.21]) by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 21 Jul 2021 21:17:10 +0000 (GMT)
Message-ID: <758a4a85e0fb92e8cbc62b218c12b02f9123f640.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 21 Jul 2021 17:17:09 -0400
In-Reply-To: <a6887d022d3943e0ca1efb845270fa715a60b925.camel@linux.ibm.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-2-tusharsu@linux.microsoft.com>
	<713d22788b678c612c5b18edfb8cf849af61ace5.camel@linux.ibm.com>
	<YPhAaAyo8fKXzu5c@redhat.com>
	<a6887d022d3943e0ca1efb845270fa715a60b925.camel@linux.ibm.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d6t4qTRUpBYNec3OWegjUyviTL_3q2J6
X-Proofpoint-ORIG-GUID: w0pjyFOM_vawjBFMbwy4XCSp4Zoynf5y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
	definitions=2021-07-21_10:2021-07-21,
	2021-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	suspectscore=0 spamscore=0
	phishscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
	adultscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 mlxscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107210125
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
Cc: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-07-21 at 12:07 -0400, Mimi Zohar wrote:
> On Wed, 2021-07-21 at 11:42 -0400, Mike Snitzer wrote:
> > On Tue, Jul 20 2021 at 10:12P -0400,
> > Mimi Zohar <zohar@linux.ibm.com> wrote:
> > 
> > > Hi Tushar, Mike, 
> > > 
> > > On Mon, 2021-07-12 at 17:48 -0700, Tushar Sugandhi wrote:
> > > > +struct dm_ima_device_table_metadata {
> > > > +       /*
> > > > +        * Contains data specific to the device which is common across
> > > > +        * all the targets in the table.e.g. name, uuid, major, minor etc.
> > > > +        * The values are stored in comma separated list of key1=val1,key2=val2; pairs
> > > > +        * delimited by a semicolon at the end of the list.
> > > > +        */
> > > > +       char *device_metadata;
> > > > +       unsigned int device_metadata_len;
> > > > +       unsigned int num_targets;
> > > > +
> > > > +       /*
> > > > +        * Contains the sha256 hashs of the IMA measurements of the
> > > > +        * target attributes key-value pairs from the active/inactive tables.
> > > > +        */
> > > 
> > > From past experience hard coding the hash algorithm is really not a
> > > good idea.
> > > 
> > > Mimi
> > > 
> > > > +       char *hash;
> > > > +       unsigned int hash_len;
> > > > +
> > > > +};
> > 
> > Hi Mimi,
> > 
> > The dm-ima.c code is using SHASH_DESC_ON_STACK and then storing the
> > more opaque result via 'hash' and 'hash_len'.
> > 
> > So if/when the dm-ima.c hash algorithm were to change this detail
> > won't change the dm_ima_device_table_metadata structure at all right?
> > But even if changes were needed this is purely an implementation
> > detail correct?  Why might users care which algorithm is used by
> > dm-ima to generate the hashes?
> > 
> > Assuming there is a valid reason for users to care about this, we can
> > improve this aspect as follow-on work.. so I don't consider this a
> > blocker for this patchset at this point.  Please clarify if you feel
> > it should be a blocker.
> 
> This goes back to my question as to if or how the template data in
> these DM critical data records are to be validated by the attestation
> server.   Asumming the hash/hash_len is being stored in the IMA
> measurement list, the less the attestation should need to know about
> the specific kernel version the better.

Hi Mike, Tushar,  Laskshmi,

Perhaps, when defining a new IMA "critical data" record, especially if
you know it's going to change, the critical data should contain a
version number.

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

