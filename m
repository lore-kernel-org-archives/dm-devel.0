Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F69FC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:19:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-ZPIHYa2OOXS-agaoYEjPcg-1; Thu, 10 Feb 2022 03:18:51 -0500
X-MC-Unique: ZPIHYa2OOXS-agaoYEjPcg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BED61363B1;
	Thu, 10 Feb 2022 08:18:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A30521042A56;
	Thu, 10 Feb 2022 08:18:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 75BDB1806D2D;
	Thu, 10 Feb 2022 08:18:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 219JlXnO002547 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 14:47:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E425D401E76; Wed,  9 Feb 2022 19:47:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E038A401E73
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 19:47:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF47D85A5BC
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 19:47:32 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-244-fTJOZLazNQOK7Q4Fd2EnMQ-1; Wed, 09 Feb 2022 14:47:28 -0500
X-MC-Unique: fTJOZLazNQOK7Q4Fd2EnMQ-1
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	219HXOW5011943; Wed, 9 Feb 2022 19:47:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e4cry2q7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 09 Feb 2022 19:47:27 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219JWATa003689;
	Wed, 9 Feb 2022 19:47:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e4cry2q7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 09 Feb 2022 19:47:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219JhSdb032723;
	Wed, 9 Feb 2022 19:47:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3e1gv9hu90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 09 Feb 2022 19:47:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 219JlNrX45941150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 9 Feb 2022 19:47:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A3534204B;
	Wed,  9 Feb 2022 19:47:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A321942041;
	Wed,  9 Feb 2022 19:47:22 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.91.188])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed,  9 Feb 2022 19:47:22 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  9 Feb 2022 20:47:13 +0100
Message-Id: <20220209194713.56556-3-maier@linux.ibm.com>
In-Reply-To: <20220209194713.56556-1-maier@linux.ibm.com>
References: <20220209194713.56556-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BaSu1YACicJbN9KdxXRRBPZHgQ3fb20W
X-Proofpoint-ORIG-GUID: UzxieFz0hJRvzm7RnHrPlCzOO8r_g2f5
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-09_10,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	spamscore=0
	lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
	phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
	bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
	scancount=1 engine=8.12.0-2201110000 definitions=main-2202090103
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Feb 2022 03:18:24 -0500
Cc: Steffen Maier <maier@linux.ibm.com>,
	ShivaKrishna Merla <shivakrishna.merla@netapp.com>,
	Martin Wilck <martin.wilck@suse.com>
Subject: [dm-devel] [PATCH 2/2] libmultipath: add %L path wildcard for
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
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

