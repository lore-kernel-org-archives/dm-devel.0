Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DAB9C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 18:56:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-M4DN3A-UNyC9iN4ZMj3o4g-1; Mon, 14 Feb 2022 13:56:44 -0500
X-MC-Unique: M4DN3A-UNyC9iN4ZMj3o4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 728151091DA2;
	Mon, 14 Feb 2022 18:56:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8405D3468B;
	Mon, 14 Feb 2022 18:56:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C4744BB7C;
	Mon, 14 Feb 2022 18:56:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21EIuWms007341 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 13:56:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 01D742026D60; Mon, 14 Feb 2022 18:56:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0E752026D69
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 18:56:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 124BC185A79C
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 18:56:29 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-426-tZV3_obuMSiOJsOWzmjCGQ-1; Mon, 14 Feb 2022 13:56:26 -0500
X-MC-Unique: tZV3_obuMSiOJsOWzmjCGQ-1
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21EHbGwU002151; Mon, 14 Feb 2022 18:56:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e7avf7t5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:25 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EIYehq022333;
	Mon, 14 Feb 2022 18:56:24 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e7avf7t52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:24 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EIs4hh002818;
	Mon, 14 Feb 2022 18:56:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma03ams.nl.ibm.com with ESMTP id 3e64h9ra4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 21EIuKe637749148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Mon, 14 Feb 2022 18:56:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A744B11C052;
	Mon, 14 Feb 2022 18:56:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3789011C04A;
	Mon, 14 Feb 2022 18:56:20 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.68.17]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 14 Feb 2022 18:56:20 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 14 Feb 2022 19:55:57 +0100
Message-Id: <20220214185559.28363-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O9EoAr2Zl3vzgHr8Ezjc_aZwrRqhX1sS
X-Proofpoint-ORIG-GUID: -Bg_ht-WcSwrpyKuZq-fxi5cgIS6m08S
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	clxscore=1015
	priorityscore=1501 suspectscore=0 mlxscore=0 lowpriorityscore=0
	mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0 adultscore=0
	bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
	scancount=1
	engine=8.12.0-2201110000 definitions=main-2202140109
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
Cc: Steffen Maier <maier@linux.ibm.com>, Martin Wilck <martin.wilck@suse.com>
Subject: [dm-devel] [PATCH v2 0/2] multipath-tools: FCP addressing display
	support (for s390x)
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

It is quicker and easier than writing some script to correlate
multipath output with other query tooling for FCP addressing.

For patch set version ChangeLog, see indidivual patches.

Steffen Maier (2):
  libmultipath: support host adapter name lookup for s390x ccw bus
  libmultipath: add %L path wildcard for 64-bit hex LUN

 libmultipath/discovery.c | 69 ++++++++++++++++++++++------------------
 libmultipath/discovery.h |  1 -
 libmultipath/print.c     | 20 ++++++++++++
 3 files changed, 58 insertions(+), 32 deletions(-)


base-commit: 70602364987e27739b5521d94d684993d877157a
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

