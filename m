Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D282C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 19:46:23 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-NVYFOm1bMfWRkKySBlUi2g-1; Tue, 15 Feb 2022 14:46:18 -0500
X-MC-Unique: NVYFOm1bMfWRkKySBlUi2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3E761091DA1;
	Tue, 15 Feb 2022 19:46:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13A6145D8C;
	Tue, 15 Feb 2022 19:46:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C6614CA93;
	Tue, 15 Feb 2022 19:46:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FJkAkK002298 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 14:46:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 74EC02026990; Tue, 15 Feb 2022 19:46:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F6182026D2D
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 19:46:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37EB129AA2E6
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 19:46:07 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-376-ZW22sBAYPbCKI3ke8q7isQ-1; Tue, 15 Feb 2022 14:46:03 -0500
X-MC-Unique: ZW22sBAYPbCKI3ke8q7isQ-1
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21FJc63c018920; Tue, 15 Feb 2022 19:46:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e8hvdrpuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:02 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FJgfo8001973;
	Tue, 15 Feb 2022 19:46:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e8hvdrpug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FJccMP008687;
	Tue, 15 Feb 2022 19:46:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma06ams.nl.ibm.com with ESMTP id 3e645jtf1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com
	[9.149.105.58])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 21FJjvXZ30015866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 15 Feb 2022 19:45:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5ED94C046;
	Tue, 15 Feb 2022 19:45:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E05B4C040;
	Tue, 15 Feb 2022 19:45:57 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.18.90]) by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 15 Feb 2022 19:45:57 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 15 Feb 2022 20:45:45 +0100
Message-Id: <20220215194547.51156-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nWucUaVhEnMUnj2WwMDtGNZfyKBTc3mb
X-Proofpoint-ORIG-GUID: z3pn-9zbNi0Q8oQHAZxBPCeSnW3RubrG
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-15_05,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	suspectscore=0 spamscore=0
	priorityscore=1501 mlxlogscore=999 mlxscore=0 clxscore=1015
	malwarescore=0
	bulkscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
	impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202150113
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
Subject: [dm-devel] [PATCH v3 0/2] multipath-tools: FCP addressing display
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

 libmultipath/discovery.c | 79 ++++++++++++++++++++--------------------
 libmultipath/discovery.h |  1 -
 libmultipath/print.c     | 20 ++++++++++
 3 files changed, 59 insertions(+), 41 deletions(-)


base-commit: 70602364987e27739b5521d94d684993d877157a
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

