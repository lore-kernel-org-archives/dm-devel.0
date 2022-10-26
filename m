Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0939FA3744
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198330;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0ekhSIK3k1CWLBG8hYlecfJlEePDwzy88thEsrzLvRg=;
	b=NsA+Q9aWXmR5KUnjY70SvxT/PSB9dbzQrVQkgGzbBAKSZuIki1ByDYA6b46zr1sUnYF0F2
	evE4iaIh9fTjXK9G0qQZfzcfX+UAFaVATVOFdspY24qVwZzFTJ+o3TvKlFDj8CRIjORDem
	KuRzPNnEz+N+eQza3sJ62LYxwxurHwA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-r1QQ3sReMRO1cMO124EatA-1; Mon, 31 Oct 2022 02:38:47 -0400
X-MC-Unique: r1QQ3sReMRO1cMO124EatA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 920711019C8A;
	Mon, 31 Oct 2022 06:38:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB5F1C2C7E3;
	Mon, 31 Oct 2022 06:38:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5748D19465A8;
	Mon, 31 Oct 2022 06:38:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFAC119465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:22:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C4E12492B18; Wed, 26 Oct 2022 23:22:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BC3BD492B16
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E1D88027EC
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-fKe0sRz2OzWLDr07k7qM1A-1; Wed, 26 Oct 2022 19:22:34 -0400
X-MC-Unique: fKe0sRz2OzWLDr07k7qM1A-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMW9lD000954;
 Wed, 26 Oct 2022 23:20:17 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7rgsa-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:17 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QLcp5x026565; Wed, 26 Oct 2022 23:20:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfagpdxe1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:15 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:44 -0500
Message-Id: <20221026231945.6609-19-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR15CA0012.namprd15.prod.outlook.com
 (2603:10b6:610:51::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a24a1f-1df7-4096-9e62-08dab7a8a367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 3p1fNjONomXbw2SPE/0OpzLm2T3pTUTC05bHTEJfaPmT5lS/d5TE7X3F12c7x0td1ceY5VlGMjsWlNOXeNeUKLTjdmbY4kS91x4Qr1CnWrfqedy3rlp9Mt8NlZyG/WycIc5kyUFbNaa72XscRK3BNoaxg5tm3LrEeW7vA6cx4J+YuQ1PKOd6TzOiaGsCOQiF4V+e0BMlv1aOQMqp9hAjaxFKAnYIq5RjeCMPCrOPnjOvwOHgXAQxKIBLfkXM/uIiPJv4bmc0bvOAruhuL0QmD7kI2wBLb4GTfgshcp40lnXVuCWSpXdyEUwscDZ0tYaeVoUzAVrleLtc16SDXHg2lp5YpDTQIHps1/fIoJ+pbEUqUNQGakz59ecKFAUcTyzEQnrPkTN8oDOrF4kPzgYTQjxNfCc2xUO+7+w6Wo2Tue4XTJR+T79Pjj3QzyfvkTiR3PTQdkcc3n3ZykcxhM6aebA22tmXdFu2hkr0uh7cDMOvl5/6w7FS77W/7bJxN5EG9gWhO+0UtCkyHH1oi1IhHoQ9TKBnlvP3xVYpratTqxsiBqIzP4EpRjjVTP4rJi8NXUwJzpuc+GKf5J+dDhY9OcqGRf+8OTCStewj/F6b/aOmAF7c4st1zd8lhd1JEJUe1ZUkblkgqMs3WtPl4YJAMELqZ8oHFcUEmic2XpLKj/SUy5PQyRdm5LTAhSuME0jPXZWdG2UO1Fzg6YSLg3V4vJO4XwiHLKwosrNI2/oGrPlA1TYhT8NPdOWgrTDp70c3
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ejuF9z8BDnOyqfFjYMCyLgnyaMeAzMsWQs244CG7wJGUMIGZT9E4U55OQPwm?=
 =?us-ascii?Q?hrxp8rxryLXaIBFyi190gNPOSyEF1Us2OHGNBL7ILD7ZmVU3obCAfjSaRzTM?=
 =?us-ascii?Q?y3uRtRhvVk6sBPheh+vTTNY+uqO8ovAYlrb9XsdnlX6hjAoBqcR9zoKiLvCb?=
 =?us-ascii?Q?6UtDdbVhbTxqYHLaPdHqieM0CKAZftw0WuatdyfvLnuTxBNXdDUUFTbg9Tlo?=
 =?us-ascii?Q?L2QNcaEiUtOsPiHfyQUDF9DTFdX3C4gMl3cshawwoQ9N2Iru5bfvILRdm80O?=
 =?us-ascii?Q?Wshci4X6peeEW7thgaGkP4g0jgwAcYFCAbBoEJj1/jg446if3fNGUlPA4lQX?=
 =?us-ascii?Q?AB+uDBGfZedmmszvttPB4r9IdaCLYo8j2gG4Isn3CY7NQKNSRNrQ5svoVNry?=
 =?us-ascii?Q?jTaqljxy2MjI3lFQb9pzTvtjZb3ZLNLBtkwUkNYR7huf2gzeGH6tQPD6An08?=
 =?us-ascii?Q?awJFT8AICf9kHqX0QcXuLVjbkel8uriWrZBNYwhwFecCIh/LGvLdCjNrMoEB?=
 =?us-ascii?Q?KkJ+XlHN896zZVSKVIWtvbv3Y4TSCB2PeSB18zlAn9nAOf3qhckZDyc5IVnz?=
 =?us-ascii?Q?q1VFNf4pLkcfhB3pKqnOmWxEfbBjFjRIDRNWc6HPcn8iVJI25huyE65VqulA?=
 =?us-ascii?Q?0d4IsmMDs5P6pDiqK+mD5iw5EaB8YfdYbUK4zZkgzAQoIvhe+Nvy6+1ZtjLW?=
 =?us-ascii?Q?LQmV1A/zp5g9fpVOMMn/I/E3VXk5riiCHWaA+if7NOt04khdPVAFGwBREEFg?=
 =?us-ascii?Q?xSP/uItbhbRKD5mwNxH2mVAE3pqnPREzRx96yKCsH3URvZBrZYXI3K9gOtMq?=
 =?us-ascii?Q?Vqolxv8cMjG6QkSZ9EFv3Z06hE7jfDho642M8Dh6xexcWIGYL5p8Mmqz7COZ?=
 =?us-ascii?Q?MW1cfu9g6XFNEtYtBu9+QzuIVmdmC+IkC96GWdIPY9TK/GsZ+YbpaBuxIRdp?=
 =?us-ascii?Q?CMJINkWzwoEbL4YLusiKVhkTXVwbJHmH2FhcHMVqkNapGfwJ+ESMqZg8BfGM?=
 =?us-ascii?Q?I9lehxDtswGEQ9RqZUWs0dMaoXowzRHOfEn4k2nocSM6IXJX5roG7mcaCps4?=
 =?us-ascii?Q?5I6MU4OyorvrTgVq4dI+qrLzrW3Ji16+EG5lCq6yxr5014HuGHhzxtyH2cRL?=
 =?us-ascii?Q?jXpRsCPDn3BqFyue/G8weIPN897TPeadD9xQbyBUmF/v5Ozg8SVBl8IsqIyh?=
 =?us-ascii?Q?gEKi1t4bIW6q+YZ1g22p+/6iHhE1UcuJdSzLGB7n5Gl26V6cxH1Ctbl15g25?=
 =?us-ascii?Q?KqNS10gs/LBdAeeZoJp4p012Ss6P2aw1iZAcT86Yb+wWtROoQ6ZyghtPAC9n?=
 =?us-ascii?Q?r4KaRTgOyIpiDv8ThGaZgN7UKVtkArgijWY6jGqkNKSQzSrh2Kb0/U3Jm8DS?=
 =?us-ascii?Q?8hJVd3+l8HghtEyLRyIhi+jRz59+a889I637ynVyC8dzinL1FPwLIwk1FJHw?=
 =?us-ascii?Q?YKy2NbJncVF6kX/wm+vwkxsG0CWUVp9k2uMqDnexWoirTiSspJ01kf5LNJ0l?=
 =?us-ascii?Q?Xco5ZVaxzfyRAep600Iar4MyWFwwJIMlBFM1Xr0XHBwG9zHmb6rOw0j7VO/w?=
 =?us-ascii?Q?79oV2d6iCy/1/vaiatF/1vzuCqoqUmObK/5+rJ3b2aoJwr7Zfx8tRypDaj57?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a24a1f-1df7-4096-9e62-08dab7a8a367
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:15.1774 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQh4ndvXNnb3OOrsiCJaJRblVO8OQ2P2E2mGhiae5DHT4e2aEgekrX9ZuHJ6imqpS4ioPd3GXUPJk8R7SsFjZTQEi5d+MUvaJG5c5kN4/4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210260128
X-Proofpoint-GUID: 3LszkXjdZ7d5daBhnFDLUShdnNcJHv5v
X-Proofpoint-ORIG-GUID: 3LszkXjdZ7d5daBhnFDLUShdnNcJHv5v
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 18/19] scsi: target: Don't support SCSI-2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
index 7cca3b15472b..fb5febc437a0 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1320,12 +1320,25 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
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
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

