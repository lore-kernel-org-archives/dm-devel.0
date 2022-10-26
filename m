Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4D0FA374E
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198342;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=35IH8ImRu872RZF+712JU8HzkQx3sB9RA5pSEMOLHE8=;
	b=hCjx/Y7FLUqJC4U/mbZOhNShPsnik7mYI+o8USHPG2hXUUtuSiFib1dC5nkrJlWzAfGQKM
	Lyrgb107s0n0xUc3VsFdmzBPbTrSBF0akefgFRLB4Fb3p5RjwwmXKvSEgEeEZSerzCnZL7
	P/apmi9fLPWLdNU44cU0CryctoAzR+Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-DRe8DU4JNGyeOiWSUgJfog-1; Mon, 31 Oct 2022 02:38:52 -0400
X-MC-Unique: DRe8DU4JNGyeOiWSUgJfog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F589806001;
	Mon, 31 Oct 2022 06:38:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 042CEC154AB;
	Mon, 31 Oct 2022 06:38:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E955194658C;
	Mon, 31 Oct 2022 06:38:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64F6A1946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:23:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56C184B3FC7; Wed, 26 Oct 2022 23:23:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D7EA4B3FC6
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:23:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B11A811E7A
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:23:01 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-7crl4e8dNxOOcqBRmeTbVA-1; Wed, 26 Oct 2022 19:22:59 -0400
X-MC-Unique: 7crl4e8dNxOOcqBRmeTbVA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMITxd014921;
 Wed, 26 Oct 2022 23:20:17 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0aghy6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:17 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QM16LE009431; Wed, 26 Oct 2022 23:20:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfagedtke-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:13 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:43 -0500
Message-Id: <20221026231945.6609-18-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR18CA0056.namprd18.prod.outlook.com
 (2603:10b6:610:55::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: f8e73db1-0960-4c91-aee7-08dab7a8a26f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ogIpKGBPYN/E5Dwp0fiQ4C0FPkLtBBqL4Mz4WmBk9v6oDN6crSQKB9xJD9q8INpmG2EL8BFoaOjqFGLYtbF62Bnz+j3MvIndnmqxOizR3KQDw2hSJhOH4Dj7Saffk/W6S9TkfXOH/9BkIuC3xPI9M6Nn6ZrC7HrM5P2cwwQyoXlxJm06t8+zlyCCow4aRb8wot2cUXTt1trKedTnFXZfpW3x+uQbdUVplyOX95Tx+xPrERPUzLfrKAuNsOqLlob/uNr8BAWY1MHBY9UmIaDyiiq7TiTpfnsxqXfLSniSzcaLKiCcca7ugRS7q58+p41nqbXr5+rQ9T2Cl4Ja3snaKuK1ABTB+nP7KZ1solMA7D3OzSQ/KBvFPQkvsoK+m/iLZFIxtAgEJFlrHQpWrMojGUqjk6UyC14J8EcGt2aNb54PrausZAeBKFtlI6lUi9RvlwaIH9jwoOzj6KhGcz+M9019hijdkPR+uJKhIDJV6FN/c9Q5TrabOTrPAR7QJCac0vH/8F2a6g1YAdSbgV8MDQM1712fC/krXQO9zT7IzgLuH2VI161xK5BSxOdgOjP60pyuFsY30UrxHt+xw/+2o4QxC4R5RLxN9uZimEmKku6Wqb/2n4MrrI9Eh0RDpZhFFrJR35fKHq5+MZ2J1CbqM6UmzsHpQ2dWQKL8zVhBQxRpfLYp6YX/bl73f0FSeXnoPu9Gl1prY+PNAC3RZ+U+rgNOmVjFHuce69qH4e5+ObYe1M+O3MlDbcDwRTcA+Qf5
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P81LKLKe762S9GHcoZNqOsoGuL1Vw/UCy8Wu+5p6gFK4eKyjEIlmb3pVtHIZ?=
 =?us-ascii?Q?3+KfI53a1KvHdncYRqP9IfeT4RaOpI8k2hDNStXIOFOQE1ysG/8jzeLnTE9g?=
 =?us-ascii?Q?YcP1tTeE7KMudLKtSb9X5p8CQ8XYBh/bibdIqpujENh/VmzuCXYKRh1VaSOc?=
 =?us-ascii?Q?z4tON+L2vhwgsBbeaKDoEPar+URG8WD1O83ahZTg59bgfdYOl6nOoNQR9pQk?=
 =?us-ascii?Q?xsrmwcyz/cRgWeOnW4xl8y+leV/1tTSDvWUuUTxdX71NqDahCgd6nc8fz8Qd?=
 =?us-ascii?Q?M+JS2tmbQO6uyUPM49wghBmXGqau+2fhwz0thEuKQc1WARPOXhqdIzXeoi1G?=
 =?us-ascii?Q?WhUK089+RANyuIdlPYJs3oyFKZ647/WNlOYsFU9K+x4gkrQewEDl4fz/Ubc6?=
 =?us-ascii?Q?LPQEX70iTWLVrmtqzV050wOZED7+L3ALOLbKFBNK/o78nUYJs5Y17XYKta+/?=
 =?us-ascii?Q?uhblp5RSz8wojZ5FjRVKNjW/qiST9QQQ7Nk8vdcsWb9mmF6JS5sgcny+oLdL?=
 =?us-ascii?Q?LS4khaq1MUxzPTQ4hZ9MJlDI8iblVaF6voXO/nRoQ9fHc8KdQ4VY8x/Tau4Y?=
 =?us-ascii?Q?VDJ+nlYjiHjU0whDN/nF4GqXxNkSsyHBssq+reuzZ89I2qeuH/2abvMEJTOI?=
 =?us-ascii?Q?K9ay0rcQNA/Fks9VP+LfVCp9FzsWcXfQdoHsAMMq5gyXGmRHgxPQcg/Kb2VW?=
 =?us-ascii?Q?kzqNczBBohs8xfQ72pSpNVW0sOcFv5nFtQ6b8CUHT76FYyxqxcgSSbjsewpT?=
 =?us-ascii?Q?x7xNUEK4bIjuO0PNJPsmHfP8TaBqA3tL1xh06eCURswO5bQdHsuvm70cRnRc?=
 =?us-ascii?Q?HP6j8qsOXJS6sUEA9cMYK11gAh6kgcZX5IkB5wcHVhm1kgw+PbTW3tNYigPD?=
 =?us-ascii?Q?BPm54b5iajTZe6NbI/gzQ46DmF7gt6P+DU0UT08NusSuvsqL77BfkTrmeqvL?=
 =?us-ascii?Q?uij3TurEvR46nSjS+gZfBZzKcrBj3ozq7JXa4Td+pfXqtChrF8rTWcMt6X/m?=
 =?us-ascii?Q?NRn1Rdmi78pIUZm4a/+abLN00ood2RmqLLUKmrDd0Tg0WoqIUSxfiUY+WfPc?=
 =?us-ascii?Q?2SUQ08gA33B0kFbZa7R/pqvqpaJy15o8TyiLIIj5lF/+KSpKUVnoGl52ocWq?=
 =?us-ascii?Q?Nu8JtsoMFCCk765MRX726TuthdIZU+it34OcDNGyJ9nuU+W/50ykj2wtuRaQ?=
 =?us-ascii?Q?R8bjx7PcRUcqV+I5jd0wroqNGB1Dm4ThzMbZsQZQjA1uq7OK8664Iy8Sj1HL?=
 =?us-ascii?Q?vPFCpF190jYZKKd1A2o0dcvOiGOEBLPaVPgXGDTiK62AnLfAbkRgoyg3nmd5?=
 =?us-ascii?Q?ePXf0PWkXmXZnVPfgmw1Qo/5Xy0IztRI3AVgOB6FmBtqXehtKJF0woeGfCY9?=
 =?us-ascii?Q?4J4c50+8L71txR5IWOSPTFoYwALYwoMZDMb62o1ZaxMNmAhUivXSiIaJHod4?=
 =?us-ascii?Q?Eet3qNHKhJ/YQ5NEnu5ow0kFSvsYmGGqbHTluBr31n9juH1m+wCx9qHJgWh6?=
 =?us-ascii?Q?/t6LkdTbuchsXxQVm+amuOwGLTUkRTHC+rFhjEIQMOy9/+Nck++ixMA25liN?=
 =?us-ascii?Q?0NWTTNiiIQCxnvbKKazfSEqBdlIepGaGR58lzDZ1SOag1bDJj9Wzqiz+ksPt?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e73db1-0960-4c91-aee7-08dab7a8a26f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:13.5369 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cOYrmjDHEUU2/pQdYYfsTj1UogUrncCSJvRiMU9Hh3o25USYH6pEF1Rc0xAsqeWJ/PJoOExdZxOemvjQcNrMTwReZVXSHt7070oCFc510cM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: R1JEE5MDYzceQnTmmx1GYK9HGhP5uhZn
X-Proofpoint-ORIG-GUID: R1JEE5MDYzceQnTmmx1GYK9HGhP5uhZn
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 17/19] scsi: target: Allow backends to hook
 into PR handling
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
index a1d67554709f..ac85f2b87c4d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3519,6 +3519,26 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
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
@@ -3622,6 +3642,12 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
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
@@ -3663,6 +3689,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
@@ -4020,6 +4047,33 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
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
@@ -4041,6 +4095,11 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
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
@@ -4060,6 +4119,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
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
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

