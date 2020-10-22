Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED85C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3634E222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3634E222EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-gSwUlTTZPCiFdwW07eg5ng-1; Mon, 26 Oct 2020 03:20:24 -0400
X-MC-Unique: gSwUlTTZPCiFdwW07eg5ng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EE5D8049D3;
	Mon, 26 Oct 2020 07:20:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE67B6EF46;
	Mon, 26 Oct 2020 07:20:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E7631832FC5;
	Mon, 26 Oct 2020 07:20:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09MLFvDG016664 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Oct 2020 17:15:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2F9B72063239; Thu, 22 Oct 2020 21:15:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A8A5206401F
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 21:15:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1335385829B
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 21:15:55 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-239-zp7ki3xZOZy5dbF2iTkw0w-1; Thu, 22 Oct 2020 17:15:52 -0400
X-MC-Unique: zp7ki3xZOZy5dbF2iTkw0w-1
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	09ML23pZ103440; Thu, 22 Oct 2020 17:15:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34b0nag2gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 17:15:51 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09ML22E4103346;
	Thu, 22 Oct 2020 17:15:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34b0nag2fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 17:15:50 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	09MLDL8e032562; Thu, 22 Oct 2020 21:15:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 348d5qw29a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 21:15:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 09MLFkXZ31654314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 22 Oct 2020 21:15:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 976F311C04C;
	Thu, 22 Oct 2020 21:15:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 537DF11C050;
	Thu, 22 Oct 2020 21:15:43 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.54.44]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2020 21:15:43 +0000 (GMT)
Message-ID: <37aa4e6f5db6c53f4021f829ec09388d55d28208.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com
Date: Thu, 22 Oct 2020 17:15:42 -0400
In-Reply-To: <20200923192011.5293-5-tusharsu@linux.microsoft.com>
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
	<20200923192011.5293-5-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235, 18.0.737
	definitions=2020-10-22_15:2020-10-20,
	2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxlogscore=999 phishscore=0
	spamscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
	adultscore=0
	bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2010220131
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
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 4/6] IMA: add policy to measure critical
 data from kernel components
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

The above Subject line should be truncated to "IMA: add policy to
measure critical data".    

On Wed, 2020-09-23 at 12:20 -0700, Tushar Sugandhi wrote:
> There would be several candidate kernel components suitable for IMA
> measurement. Not all of them would have support for IMA measurement.

This intro is besides the point.  The patch description should describe
what is meant by "critical data".

> Also, system administrators may not want to measure data for all of
> them, even when they support IMA measurement.
> An IMA policy option 
> specific to various kernel components is needed to measure their
> respective critical data.
> 
> This policy option needs to be constrained to measure data for
> specific kernel components that are specified as input values to the
> policy option.
> 
> Add a new IMA policy option - "data_sources:=" to allow measuring
> various critical kernel components. This policy option would enable the
> system administrators to limit the measurement to the components
> listed in "data_sources:=", if the components support IMA measurement.
> 
> The new policy option "data_sources:=" is different from the existing
> policy option "keyrings:=". 
> 
> In case of "keyrings:=", a policy may measure all keyrings (when
> "keyrings:=" option is not provided for func KEY_CHECK), or may
> constrain which keyrings need to be measured (when "keyrings:=" option
> is provided for func KEY_CHECK).
> 
> But unlike "keyrings:=", the entries in "data_sources:=" would have
> different data format. Further, the components listed in
> "data_sources:=" need to be modified to call IMA to measure their
> data. Therefore, unlike "keyrings:=", IMA shouldn't measure all of the
> components by default, when "data_sources:=" is not specified. Because
> measuring non-vetted components just by specifying them as a policy
> option value may impact the overall reliability of the system.
> 
> To address this, "data_sources:=" should be a mandatory policy option
> for func=CRITICAL_DATA. This func is introduced in the 5th patch in this
> series). And the compile-time vetting functionality described above is
> introduced in the 6th patch in this series.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>

I don't understand what you mean by "non-vetted" components, nor how
measuring critical data may impact the overall reliability of the
system.

The system owner or adminstrator defines what they want to measure,
including "critical data", based on the policy rules.  They might
decide that they want to constrain which "critical data" is measured by
specifying "data_sources:=", but that decision is their perogative.  
The default should allow measuring all critical data.

 A simple example of "critical data" could be some in memory structure,
along the lines of __ro_after_init, or hash of the memory structure. 
Once the data structure is initialized, the "critical data" measurement
shouldn't change.    From the attestation server perspective, the IMA
measurement list would contain a single record unless the critical data
changes.  The attestation server doesn't need to know anything about
the initial value, just that it has changed in order to trigger some
sort alert.

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

