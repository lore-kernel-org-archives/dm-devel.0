Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF770C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 18:57:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-aNvk8lAwMm-vy0Rjm_9erg-1; Mon, 14 Feb 2022 13:56:58 -0500
X-MC-Unique: aNvk8lAwMm-vy0Rjm_9erg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09E071006AA3;
	Mon, 14 Feb 2022 18:56:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF38C7EBDE;
	Mon, 14 Feb 2022 18:56:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AFDD51809CBF;
	Mon, 14 Feb 2022 18:56:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21EIuZMm007357 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 13:56:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B0648492D17; Mon, 14 Feb 2022 18:56:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC5F4492CB0
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 18:56:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93CBD811E9B
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 18:56:35 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-600-GBfPkAu3MgOEApnz4XepbQ-1; Mon, 14 Feb 2022 13:56:30 -0500
X-MC-Unique: GBfPkAu3MgOEApnz4XepbQ-1
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21EHr3lV012499; Mon, 14 Feb 2022 18:56:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4e6q4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:29 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EITmBA007178;
	Mon, 14 Feb 2022 18:56:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4e6q4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EIrwg7030275;
	Mon, 14 Feb 2022 18:56:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com
	(d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma04ams.nl.ibm.com with ESMTP id 3e64h9rb60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 21EIuPcq44433824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Mon, 14 Feb 2022 18:56:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 543B111C054;
	Mon, 14 Feb 2022 18:56:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E404311C04A;
	Mon, 14 Feb 2022 18:56:24 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.68.17]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 14 Feb 2022 18:56:24 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 14 Feb 2022 19:55:59 +0100
Message-Id: <20220214185559.28363-3-maier@linux.ibm.com>
In-Reply-To: <20220214185559.28363-1-maier@linux.ibm.com>
References: <20220214185559.28363-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y1rwnFE9hRSIMNKpR8-z-EQFYJpAg_gs
X-Proofpoint-ORIG-GUID: Ptw7erEWCkA7QpB7-y4N9QoEE7JH8EpQ
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	malwarescore=0 bulkscore=0
	adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
	suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
	phishscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202140109
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: Steffen Maier <maier@linux.ibm.com>, Martin Wilck <martin.wilck@suse.com>
Subject: [dm-devel] [PATCH v2 2/2] libmultipath: add %L path wildcard for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

