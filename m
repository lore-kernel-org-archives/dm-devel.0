Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA671C25B08
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003527;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ARZv8/3+alakANZFW3r8j7yPh1884iN5kZV5VaOBI+M=;
	b=IaKVFdjd7pFaXcPJkghASybtvAGMMxS/OnlRoKrAv6BJEoBdzath6ABTCu5oWP1uXejqO7
	P7xrQN1fGza2ETiGShdmLPJdBuATLxiUI0gasyN6SVTFtQe17blmdVzh+mtgIRIUMUglz/
	v0hAponVcnJ3qiTW5kkpa8TVxzrk1fQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-6T4kvIFRNQyNBeR1PgVB8A-1; Mon, 08 Aug 2022 20:05:23 -0400
X-MC-Unique: 6T4kvIFRNQyNBeR1PgVB8A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF42585A58C;
	Tue,  9 Aug 2022 00:05:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD109492C3B;
	Tue,  9 Aug 2022 00:05:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78AA31946A50;
	Tue,  9 Aug 2022 00:05:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DA761946A50
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:05:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7126DC15BA4; Tue,  9 Aug 2022 00:05:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C2A1C15BA3
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:05:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 988E21857F02
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:05:18 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-MGSTGV61MoyE_1FewO0xbQ-1; Mon, 08 Aug 2022 20:05:16 -0400
X-MC-Unique: MGSTGV61MoyE_1FewO0xbQ-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwJlL007174;
 Tue, 9 Aug 2022 00:04:54 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1e7-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:54 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0w1O034406; Tue, 9 Aug 2022 00:04:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser2da23-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:51 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:18 -0500
Message-Id: <20220809000419.10674-20-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:610:52::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8eb14b18-0d20-426a-2c3b-08da799ac7fe
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: xSXUTXmUpYbqJQhK/E88BfiiElvlS+rZ5thbuRvaJwt5Aob4PIesAmqO3FP52qX1NwYfhCSH9SfOlxqjBWaCdH7x43JI2VeCqnCXdlkktSn1t64gyGM6em2O/0G2akYOKHbwUSsLNtqYmU1U79n/xToCHsNdU+2QE5YmhocpjvRrraU4Vea8VN/jK5T/deYV3ixHY5+HdFmi5Xw6asSjy7H/mUeCTq0GPJRfTlm7KvI+fUaKmSUBmwCIWY4+9Cl5tjTv67nYZbjslZ/495+fj8tTlWfk6scS4swy9Ae+942ltAnWbj8BschON+ehX/V8KsomWooiBnn97KYAjeBp4EkIXbFexgwFEIHRv92j4xZIklAipajoqmNYd+EEa8JuZQ+2xOuO/UGwyOMHiA/6h6MDcTmYJaL3noiZEXi+4Ep3IxecEu6EL0RO1pawCjokggLc1L5AbxwjjSsyLYFrsgGKTjlA2CO7P4U4hh+sVATVSfGI1+F2DpllrrpwVxmu4wlqcawPnBoLPN7/diaJEu01xeA8JdS1Xyimy7wrg9L9nQ3u79czKgE58Z1f2y4wTA6FxuasrDKCASMsPCTungcoLQ1qXHr1z2lWsgMQXYoqDZo3fW1nCeT96jDftDHHaQFJnnPVVOf5eVLcGDQuwsPul2TQUST7exJBHPaQXYAVx/snPxL6dX+C2WwXFg9v1510wudYpn10M5rb+WhQZBLM50Gjy2oez77rA+EtJKyutPcaaiRZwg1kXtTAxL9Pz9uOUAPkshuBJlbHZirlx1I/EPd8evWaSFAvWM3MWw8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mw+H76u5QmxRhNzaqC3RBQipU5R0cWsHES79Peu1Wom/4BAugcm7b3rbMqk8?=
 =?us-ascii?Q?8AIJMKdjFjJ+sB/vL1/qAE6MxnUNoS4ARtANC+tLaOZzGCxCPsVtZbiz0sHA?=
 =?us-ascii?Q?R8ezNQoBUqaeZEtlQKaGOs01JWXeQaAjRS+7Xb3Hj5T6+0SDs5NdesZPJ/Z8?=
 =?us-ascii?Q?zZTfEYNCvPD8g/A/x8Wml1jFOFHZeKuugTpepKDK0sVQtmr6XL72ZX8D0Z+4?=
 =?us-ascii?Q?NHFr7HoyrQR71lppoJuhJL8pJq70DUsIDkpiNO0alKunhrT8G8Qu0duBKcbu?=
 =?us-ascii?Q?yt7juN5XUwcSv9M8i9dOu77/tugRM95+4Qlj9JQ+HtY5oGp8TvpR9x7OW5IA?=
 =?us-ascii?Q?EazKIv13bO1Tg00PEWS75T8WwEOlZpdQMWxoDfsDgRiEmCjSBYpjSbkCL1w7?=
 =?us-ascii?Q?avT86zIaTvYmydymQH8uwPhCdpdXKoh+TgdStxiUHko1AfnArWhBFxF/jKGQ?=
 =?us-ascii?Q?ZFUJ7qFG01R/IS/EuiLk9XClxRqHs5jWQFouyeuB/WAEMF/AjWnrqmRnaTLE?=
 =?us-ascii?Q?se6O9PnUWW0CQ9NFwX2C1+dbhH48RkAAUyfD1il1yltN0xwU422qRRIgaKAm?=
 =?us-ascii?Q?bv95DPr51U3pkPW4bu8SY5wj745HGAwYKqD1jm7XwJABWrGchij81eJJ+vyl?=
 =?us-ascii?Q?+E41+1x/THl/QTKO8sN7yLpbOitl0UeLk6kft2VR6LzZpPgDFG8qgn62Dhn8?=
 =?us-ascii?Q?SkK3fkdTljuxp10UgVnMDOdj9Azh56x8iau3nCiruWWvEv59SgWn1IcBh94b?=
 =?us-ascii?Q?HWREkUCgKwGlCEsSh6X78hNzIFJs3NUXZrshz+tCzslKB2Sm6AmvF1q+EFTH?=
 =?us-ascii?Q?oa3MeSX6DygHBNu0CT0N8jZ95erpKjs59r5c98gN5ZbVj58cKqGgw8dpqMDR?=
 =?us-ascii?Q?LSwNYwFdNSj18J6mlZ4uiT6+lMz6gZtwATOUn5MawYe7jNvZ3/IKxZKlG5mZ?=
 =?us-ascii?Q?R6P1LeIt4EjWKB56lZz7zfncudB2/W3mQkjBylPgQOw7rbB8uoVUIWV4sSVm?=
 =?us-ascii?Q?INJLhUvLbCP20Uo/vzoRiju0mkGZ2V2ZRNz4xuzEm7h2yhi5Uv2A2eU3jRVI?=
 =?us-ascii?Q?Tzz4msqceOLP8SWkAnN00fE2iayCWixL02dXGH8C959s/7GqVtqjM1+xNFnL?=
 =?us-ascii?Q?7OuFmvGyBFxDRIY/Lwm/jqNWJSNDGDip3IDJnICtwAWSRWf3p88rSreJTKzy?=
 =?us-ascii?Q?1OGuBXZ9uPKul/RICgVEn+qGebbFfhtfEQCLY/NCexdsAkLsOKgCmozEYE9H?=
 =?us-ascii?Q?rEAk16qchTxTx/G7m+snlQ71wh2HVUhQNd/Zkk3VT1+8Jwx3XxACArVNOJ5r?=
 =?us-ascii?Q?K3ntcBSzAcygXvCAZnGCle6FdxWaVb1VrsTVOsdWHN7Qv/StlLWCoo/Xa+xK?=
 =?us-ascii?Q?Q4xmH2gCtVl/RUYmIde7gcZ7u1QL3/miB6sDLyWH8FBhqkhFxfz4USsN2OZE?=
 =?us-ascii?Q?a7ki3ST0hdSGII7mTrZCCqWfBDr2sTH8QXxfDAwDI63DB+QKvgxtGuVz6nkW?=
 =?us-ascii?Q?jA7vCEI82bIgAJ1Qar5CFlGjByCKK7RUPltwo/gxA8PPwl9I5Rlhg5mAmCjl?=
 =?us-ascii?Q?FgMMvt7SWuMmUDBWCjAFrQJmxmzS60epEundJUA6LqYSLEA7rGBJWkZUSsRd?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb14b18-0d20-426a-2c3b-08da799ac7fe
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:51.5156 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDGuw/Wz417FlExaHc+bhuSq0y/ZsEiuXtYbx1O6G06u3zYoVPq3QhBBQI3ytUIIZkjfiEeQ/RENsNAfVjSni+b7rcpjh7A0zVu8Y3XP73w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: PY4y6kUInA91WvtEeWojCi2195ABQ2d0
X-Proofpoint-GUID: PY4y6kUInA91WvtEeWojCi2195ABQ2d0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 19/20] scsi: target: Don't support SCSI-2
 RESERVE/RELEASE
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pr_ops don't support SCSI-2 RESERVE/RELEASE so fail them during
parsing.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c14441c89bed..64ac9b92f8cf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1314,12 +1314,25 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
 
-	if (!dev->dev_attrib.emulate_pr &&
-	    ((cdb[0] == PERSISTENT_RESERVE_IN) ||
-	     (cdb[0] == PERSISTENT_RESERVE_OUT) ||
-	     (cdb[0] == RELEASE || cdb[0] == RELEASE_10) ||
-	     (cdb[0] == RESERVE || cdb[0] == RESERVE_10))) {
-		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	switch (cdb[0]) {
+	case RESERVE:
+	case RESERVE_10:
+	case RELEASE:
+	case RELEASE_10:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		/*
+		 * The block layer pr_ops don't support the old RESERVE/RELEASE
+		 * commands.
+		 */
+		if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
 	}
 
 	switch (cdb[0]) {
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

