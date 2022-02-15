Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD65C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 19:46:23 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-vifSI3vUMvOA6XE9v3KCAA-1; Tue, 15 Feb 2022 14:46:18 -0500
X-MC-Unique: vifSI3vUMvOA6XE9v3KCAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 468AA1006AA0;
	Tue, 15 Feb 2022 19:46:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF06A5DB82;
	Tue, 15 Feb 2022 19:46:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 116954BB7C;
	Tue, 15 Feb 2022 19:46:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FJk7bi002288 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 14:46:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 65BA0145FBAC; Tue, 15 Feb 2022 19:46:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61366145FBA0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 19:46:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 476D5811E78
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 19:46:07 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-558-H7bYa8s4OXKvVSR4yk80pA-1; Tue, 15 Feb 2022 14:46:05 -0500
X-MC-Unique: H7bYa8s4OXKvVSR4yk80pA-1
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21FJGqgS011458; Tue, 15 Feb 2022 19:46:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e8j6rrkag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:04 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FJURe7008560;
	Tue, 15 Feb 2022 19:46:04 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e8j6rrk9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:04 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FJcXUV010214;
	Tue, 15 Feb 2022 19:46:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
	(d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma04ams.nl.ibm.com with ESMTP id 3e64ha2c4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com
	[9.149.105.58])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 21FJk0RV43254100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 15 Feb 2022 19:46:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B2254C04A;
	Tue, 15 Feb 2022 19:46:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB27A4C046;
	Tue, 15 Feb 2022 19:45:59 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.18.90]) by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 15 Feb 2022 19:45:59 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 15 Feb 2022 20:45:47 +0100
Message-Id: <20220215194547.51156-3-maier@linux.ibm.com>
In-Reply-To: <20220215194547.51156-1-maier@linux.ibm.com>
References: <20220215194547.51156-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d2IMRRWLLFoxNB6aB29ScA9pqtr9_vST
X-Proofpoint-ORIG-GUID: 84aEVFvMOChhyZe2ZNQf7gOuPNPvbTSW
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-15_05,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	lowpriorityscore=0
	suspectscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
	bulkscore=0 spamscore=0 phishscore=0 clxscore=1015 adultscore=0
	malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
	scancount=1
	engine=8.12.0-2201110000 definitions=main-2202150113
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Steffen Maier <maier@linux.ibm.com>, Martin Wilck <martin.wilck@suse.com>
Subject: [dm-devel] [PATCH v3 2/2] libmultipath: add %L path wildcard for
	64-bit hex LUN
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

Complements v0.6.0 commit
01ab2a468ea2 ("libmultipath: Add additional path wildcards") as well as
("libmultipath: support host adapter name lookup for s390x ccw bus").

With that we can easily get the full FCP addressing triplet
(HBA, WWPN, FCPLUN) from multipath tools without additional tools
and correlation:

$ multipathd -k'show paths format "%w|%a|%r|%L"'
uuid                             |host adapter|target WWPN       |LUN hex
36005076400820293e8000000000000a0|0.0.5080    |0x500507680b25c449|0x00a0000000000000
36005076400820293e8000000000000a0|0.0.5080    |0x500507680b25c448|0x00a0000000000000
36005076400820293e8000000000000a0|0.0.50c0    |0x500507680b26c449|0x00a0000000000000
36005076400820293e8000000000000a0|0.0.50c0    |0x500507680b26c448|0x00a0000000000000

Likewise, add a field lun_hex for JSON path output.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---

Notes:
    Changes since v1:
    - added 2 Reviewed-by (Ben, Martin)

 libmultipath/print.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 221b515f23d3..4f6146e85fc9 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -96,6 +96,7 @@
 			     "            \"host_wwpn\" : \"%R\",\n" \
 			     "            \"target_wwpn\" : \"%r\",\n" \
 			     "            \"host_adapter\" : \"%a\",\n" \
+			     "            \"lun_hex\" : \"%L\",\n" \
 			     "            \"marginal_st\" : \"%M\""
 
 #define PROGRESS_LEN  10
@@ -451,6 +452,24 @@ snprint_hcil (struct strbuf *buff, const struct path * pp)
 			pp->sg_id.lun);
 }
 
+
+static int
+snprint_path_lunhex (struct strbuf *buff, const struct path * pp)
+{
+	uint64_t lunhex = SCSI_INVALID_LUN, scsilun;
+
+	if (!pp || pp->sg_id.host_no < 0)
+		return print_strbuf(buff, "0x%016" PRIx64, lunhex);
+
+	scsilun = pp->sg_id.lun;
+	/* cf. Linux kernel function int_to_scsilun() */
+	lunhex = ((scsilun & 0x000000000000ffffULL) << 48) |
+		((scsilun & 0x00000000ffff0000ULL) << 16) |
+		((scsilun & 0x0000ffff00000000ULL) >> 16) |
+		((scsilun & 0xffff000000000000ULL) >> 48);
+	return print_strbuf(buff, "0x%016" PRIx64, lunhex);
+}
+
 static int
 snprint_dev (struct strbuf *buff, const struct path * pp)
 {
@@ -842,6 +861,7 @@ static const struct path_data pd[] = {
 	{'0', "failures",      snprint_path_failures},
 	{'P', "protocol",      snprint_path_protocol},
 	{'I', "init_st",       snprint_initialized},
+	{'L', "LUN hex",       snprint_path_lunhex},
 };
 
 static const struct pathgroup_data pgd[] = {
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

