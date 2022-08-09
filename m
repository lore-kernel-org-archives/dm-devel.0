Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52C4C00140
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003526;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MCcNGoo4EGqhGl5lht0YJgQLQ8Z9DdY4fhbkILfHtgI=;
	b=BdLKaNmlWUcoVUi4R/AW6ipNK4gaNviug+M5xcMZk3XrsSe6ADJvxpnRGK58CWZ/p/3La4
	3Xqn9GRMerB7vZXxb3h8a2DXh8yPO6L5uo2hKXEeIcvaRdwyQc9BBi5V8pKjLC7nnmEYhP
	CG1QXYzGPxAhkZnZkKpz7aE4PdGWUIo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-4LfoIfEPMgGvbMbkGT-65A-1; Mon, 08 Aug 2022 20:05:23 -0400
X-MC-Unique: 4LfoIfEPMgGvbMbkGT-65A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39897811E87;
	Tue,  9 Aug 2022 00:05:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2696E40C1288;
	Tue,  9 Aug 2022 00:05:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 061AC1946A50;
	Tue,  9 Aug 2022 00:05:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 624FB1946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:05:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 447DB40315F; Tue,  9 Aug 2022 00:05:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FE4D492C3B
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:05:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4EA385A5B9
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:05:19 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-sNCGsDIxONK0-fVB927-dA-1; Mon, 08 Aug 2022 20:05:17 -0400
X-MC-Unique: sNCGsDIxONK0-fVB927-dA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NxAsO032222;
 Tue, 9 Aug 2022 00:04:52 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155hr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:52 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0h2Q011667; Tue, 9 Aug 2022 00:04:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser26u9w-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:49 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:17 -0500
Message-Id: <20220809000419.10674-19-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:610:e6::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df5b1605-b635-4f2c-bbcd-08da799ac680
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: SRyUywUhZVQSyOIpFl58obc+FDLbFHv9uBvVQvq1CRJhogEtrigxe6GsLHoxgP2JoHxEUP6m3NDLG6nzNIdH/etD+bw4JIuDZUd4GGbtThPd1mPq/mGU4o43xKK12EH18epGjfbimvnCUyndk7KQA72+2Smh7UvqI3M6qYfKmpdgkVhj7mPyr2ZgrQsEx8O7PIi3AVcilG0+9qlzwZYS7DnflZCH7R1R6JvVUVXU2Ynsix/XTGwMX4EMZAfx7w5udwWizeqykKmGX3/6tWMl3qFzSkWXSeXDIVScX6Q98atSWWPSZXEB1ltMm4pS9bZGbY4CakdsXv6XZPi89LR4IJXGXcnuDOoERoBHREV05MjoIeH7J1g2Jvsw2HPvGPKb5HwqJthHNsgiOzhoI6dXAOlYOSL/O/dPG9ogIHbeu8lHoR2mkwQEBF2uSDr7buvmT6jxV26LcQaCiA6KmtRNlkTIKoZCK+zHoL81P9ND73U5GV4L8rvFDDhjbgCIYqmnB1x8FY0qR654W/1TdwGoXvfbP7SDTBJo5doWM/XTJC3I/+XmYjmMy+HmdaL4bGzqitCMojwPa8Olfxjl0N32lIWoRzmRtQyaDyLauQ+eALFvJUz3ECdHnrzj1VI0foEGS4K/I9Ac7pDlLkNKnh0iGgbqUOWS4Dr6+pWP+NvMV6m9+GSsOCUk3DleJZRC1JQN7SUkWyw5GzQ9MfWyrV8evSBKIUePXi/fxcYcYouUmctRQse7cLBS313hV4dQAjFpGCC48Igu/h52YHYRRRqwvugx6q2cigDdhnXYO3XVhZ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y5E/RdMS9ib1MD3Wq1NEpj4kesMir6PCRPh99lpV5ywUMUKEZ1u+ZBQzLIYo?=
 =?us-ascii?Q?NS+0Ina+EJRSzfsiG6fDhG0+9BiMNqQZCfE2YPbB0NhypagPu/5jKz2nP9om?=
 =?us-ascii?Q?ulg8hOEyve3DdfoJ161g4sTrYCBF2EtpJiJ9kDxSmIzOdf7XSTb1Sd279aLR?=
 =?us-ascii?Q?l95kHflsWveSaAifWjvHvyAR8W5ebrshvrl1NP86LaVJlo/xYvJX6UGi3zJq?=
 =?us-ascii?Q?U4hh/tiTEx42r3o2lNeWuDsT5QYf9CN9+8BkanIXSCYdoWMG2+yMEVbVpmVQ?=
 =?us-ascii?Q?Is6FIYMJrhbBRqYXFQLwq22jnAZevLHgYUba8W+/MZA6W0RR04d6x7EWeKiH?=
 =?us-ascii?Q?2fSEcXOTpkrjIeiXl6ijuhnbbG/TU5uYegMIlbh/OQUrXxJPK9uqa8ljIJT1?=
 =?us-ascii?Q?B7TH8yAbN7vgG0832nRMR/sihrBgofEixRnM8AcwVjBNy4vOA7b9zUgEPBZ3?=
 =?us-ascii?Q?8H1/PNXLrXCqfZeR+/hZsDaskxJX756TcGkoszOY/WhCjMrLMZI4MucDVCyK?=
 =?us-ascii?Q?c07HjqQwmfptC0jgaRzX9Eb2KFDNuK+2sxqrqULM6KDdk5roBKMmR3lVnS/h?=
 =?us-ascii?Q?urPDhsv010DQ00zkT0z799k7oKya+8+rhfaCsS8+mriUOTCCnqT0aomiVojM?=
 =?us-ascii?Q?7QOFt/sHdf4xh3GHXPJ6bC4d/fD54BnwHOoruvXqi5xZUQXYuv/SioA6P8bY?=
 =?us-ascii?Q?I/zy55VqEDwBbHuiY0xmiGyhr8CZT4lUSqz8F/UDy3TG/Q0it4X0ivi4yzoG?=
 =?us-ascii?Q?FBs3gesIj58tdUzHJ7B4o6lfknFWnCOffHwr2pVvzBV/ETwJl0eZq3c8IuVE?=
 =?us-ascii?Q?CtzTRGfDRD7mz7Pg4PrwmH368pE8pQehccOTgYFDjWKxqFnnI7UCm2rL0ek8?=
 =?us-ascii?Q?XYT3lKNCmHgNqcbsD3ViXXkcgysC+QCwDLX35xLaKDmz34P9oUkNrRcZWOuO?=
 =?us-ascii?Q?VmBuNAAbwpFy1T+v0FskDWPvwW7taFWYxrz9dD9V1sB6iU2ZkZ3pZINiSHgN?=
 =?us-ascii?Q?LXrvSGZ3C0QI/yGyGb28MIIG+J+6+/p+uTeOSu9S0khmtG/1VPjkKnPOb+eX?=
 =?us-ascii?Q?0J/uRH1ZgKJR3+9p04mg4GQaWZhzWWMqvzrZ2wV6cl9Vp+X/kr10WYfqv5GW?=
 =?us-ascii?Q?sQPuCy1QzT5rQdbYlTwpn83NSQTvh/5tufUVjyy2kR+VehdvB1Nf8+7W6S6x?=
 =?us-ascii?Q?PWB9KXzOaRc0clzGxkhBs2gGZy0fRm34CB4DXN++Ayf3qUbAl7w4l8U2jw03?=
 =?us-ascii?Q?SVXEfI9ewllcET+lwyDeUFTLKsPYeDRtI3OufJAE7eYlKzukI1gXfStbT8J+?=
 =?us-ascii?Q?2wt1WDrW4Eo22ZqY7bZa3Qt+41LopB/ndkjn9lFr1Uc3LvIIfyGsRXl3HFML?=
 =?us-ascii?Q?C1ewE8ElQAg3fH4QIVL2DxdnCXkLZlKC/rAcDD/gBYPRFjKAYKt6MsjuB/k/?=
 =?us-ascii?Q?9rMUOnTNN+dR+sk4+/QzTAgEq1FYNxpYE2HTkq62kPhvnsN2g4f8V9mEE9tG?=
 =?us-ascii?Q?5MftoIHSndLInx3DNHaikOkEWmxH9sebEjHi+/AGgpMqARa1kyvbxEk0Ybur?=
 =?us-ascii?Q?mqFmdbIubZXiANEBYKOKgTfgBBlnqp9N+/3YaXFjOuxqfjGvf72UuMyNrcKc?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5b1605-b635-4f2c-bbcd-08da799ac680
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:49.0471 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b42WbomUboO9n7kSGgbqTM5OPPgtRD4tBEKekiUrz9fSQzcuPCQ/kJJ1J/xaHj3hgJTsLyNz5s6K0y+DRsivWwbpb2l7eWXEVO6C6QseqQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: N5_fbjBG0w_KIA77jhx5TAnC25NlXBlj
X-Proofpoint-GUID: N5_fbjBG0w_KIA77jhx5TAnC25NlXBlj
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 18/20] scsi: target: Allow backends to hook
 into PR handling.
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For the cases where you want to export a device to a VM via a single
I_T nexus and want to passthrough the PR handling to the physical/real
device you have to use pscsi or tcmu. Both are good for specific uses
however for the case where you want good performance, and are not using
SCSI devices directly (using DM/MD RAID or multipath devices) then we are
out of luck.

The following patches allow iblock to mimimally hook into the LIO PR code
and then pass the PR handling to the physical device. Note that like with
the tcmu an pscsi cases it's only supported when you export the device via
one I_T nexus.

This patch adds the initial LIO callouts. The next patch will modify
iblock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_pr.c      | 60 ++++++++++++++++++++++++++++
 include/target/target_core_backend.h |  5 +++
 2 files changed, 65 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3829b61b56c1..1c11f884e12f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3531,6 +3531,26 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	return ret;
 }
 
+static sense_reason_t
+target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
+		     u8 type, bool aptpl, bool all_tg_pt, bool spec_i_pt)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	if (!ops->execute_pr_out) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type,
+				   aptpl, all_tg_pt, spec_i_pt);
+}
+
 /*
  * See spc4r17 section 6.14 Table 170
  */
@@ -3634,6 +3654,12 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_out_pt(cmd, sa, res_key, sa_res_key, type,
+					   aptpl, all_tg_pt, spec_i_pt);
+		goto done;
+	}
+
 	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
@@ -3675,6 +3701,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
@@ -4032,6 +4059,33 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+	unsigned char *buf;
+	sense_reason_t ret;
+
+	if (cmd->data_length < 8) {
+		pr_err("PRIN SA SCSI Data Length: %u too small\n",
+		       cmd->data_length);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (!ops->execute_pr_in) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->execute_pr_in(cmd, cmd->t_task_cdb[1] & 0x1f, buf);
+
+	transport_kunmap_data_sg(cmd);
+	return ret;
+}
+
 sense_reason_t
 target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 {
@@ -4053,6 +4107,11 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 	}
 
+	if (cmd->se_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_in_pt(cmd);
+		goto done;
+	}
+
 	switch (cmd->t_task_cdb[1] & 0x1f) {
 	case PRI_READ_KEYS:
 		ret = core_scsi3_pri_read_keys(cmd);
@@ -4072,6 +4131,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index c5df78959532..84bfdfb14997 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -69,6 +69,11 @@ struct exec_cmd_ops {
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
+	sense_reason_t (*execute_pr_out)(struct se_cmd *cmd, u8 sa, u64 key,
+					 u64 sa_key, u8 type, bool aptpl,
+					 bool all_tg_pt, bool spec_i_pt);
+	sense_reason_t (*execute_pr_in)(struct se_cmd *cmd, u8 sa,
+					unsigned char *param_data);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

