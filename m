Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C0AFA3744
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198339;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XIRjGvL1hdeWKAT+042AzNu1yRg+iWZUAHkeH78wy0w=;
	b=N0e8Sa3OcBU2aCM2H/AJo0fDrSu3OOedtr/sfSGU+dE1yFxSAzsqEmcLldJ7l57kc+X9hA
	11CKi3hJOKA/2vfZmwe+QzpLEh3NyIW6tUKMDnVGKIzgRw+Iw5VVPxhOLCObHdHe2IjwGw
	1OTR1CIv+daobnqkUOdTUnPjYFVQa8A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-Fv_pYwmFPC6DN59F-3-H3A-1; Mon, 31 Oct 2022 02:38:55 -0400
X-MC-Unique: Fv_pYwmFPC6DN59F-3-H3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E25C1012475;
	Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 085E7111E3FF;
	Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2BF6519465A0;
	Mon, 31 Oct 2022 06:38:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CABDA19465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:22:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF0A239DB3; Wed, 26 Oct 2022 23:22:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B67A817595
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 856A3857AB6
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-lOuExoqwMQqonL9zgGPpcQ-1; Wed, 26 Oct 2022 19:22:11 -0400
X-MC-Unique: lOuExoqwMQqonL9zgGPpcQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM3G31014699;
 Wed, 26 Oct 2022 23:19:57 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0jf0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:19:56 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QM7DOA006899; Wed, 26 Oct 2022 23:19:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfaggdrg5-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:19:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:54 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:30 -0500
Message-Id: <20221026231945.6609-5-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:610:74::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 4268b3b1-7c2f-47dd-1ec7-08dab7a8973e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: d3LqOwSGJ2gGy2ILbgz9rxjLBv3cS26OQgehEjXWZRTO+8FXz5bAUqXYh9B+cfaCA+YPT97U66ruu6ZD3sPeg4u0vOTBfF/liJkwdIgr63UZwTe9tLJs2Hq2q/eXjQFpQ4jhlCU6mDu0VBEQbRjfH/Q8/IlCsP0HohHIPkJWQPk9mnTv7LrqIqFylEHbL3AV7Nmd456EGI2y2XvZjIjCYc6yzS2b8ukvAySPVH5qqLTsf/K/gSU2h5UxKz1eg99wISkJ9rEpWsctx/hC0E7iPJxRXmvXxeUwEPneSmOtrsle+1aaXWqlMa9yodeQHU6gqA9XG8I9s0dGRfHNUoyQ9zcBdrrwPNl4GY3n4K8EzH+GqYgjgRtMx2ucx2PphyQRG0u6uy3eCtMdWINZztX9bFgX7Xsd7ujb3GZj0aj+S8nZFcBldJfmEsbv2bgtQrmIdY3B6+10LW9NVgz0wfvxS2HBgKgSC9rd/5/yQALUSKtqUim0dVjFjdw1INgouse2nw2qe7rdeEwRgphtdlTJ24j0Zp4d3BTMx8cQ8MZqo4+SFNWEM6kxWmW5Q7m7RE+fe5LcQBmXBm7Shi5StynIbWRU2WYEHs7pmQNXgxD4fjAfExp95nLV3f7wBQLPD2gOcLyHAWtLfyCz3u4fGYAjif/5CTFlnm4WFboxtTK6gvCKXdektYv/GpqAlOmfgfhHcCKhJJ5Nn5nOzMJJWGhyQiTWDJ71bzBympRwlvOpKe9NKgjBkRlnzmOYDhs6a+X6
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+mEVVXEnp0I5EH/A4pg7DyJwrXanlgrPM7XDuoskSXl+ebeeGp27xpHqIO8?=
 =?us-ascii?Q?kno4EPlTbhVSgBdOHymLr7OElchBM4cUeHadCa3pIY4I8hc9HzVP1fXKaMrj?=
 =?us-ascii?Q?0dvh3nritlGfQv0fEQa7I/6PcLG2gvreXtfiSUXtN8AfiP+Ap8RZPa73hYVE?=
 =?us-ascii?Q?E01x9AeUqWdqZIad65fA1XAgboWcOc6inb/a0AMhhKZE3Pa/HzOJLb34xNTr?=
 =?us-ascii?Q?X2x+W3uAc8Kbm5rrBKmAv1RwAh5PwFijhstM0C3t/W4DGsg+CdKysqKz2BRW?=
 =?us-ascii?Q?75HlJ0tBkh2V8g4HobbCX0+ahEV5LJI+aNgojN9BI2ZlwSd4cTJEzt7HaCKG?=
 =?us-ascii?Q?z/vpD1U1b0mrrlKAkplXUxz6Qj4bhq6JW7noFVdqfy2LZeerOG7FFFlApFJY?=
 =?us-ascii?Q?Q2+/T3gWJv5Mai3JTPRYWCfoIdHEIiqDBjuItXN8MdxbrXsm2olv7ihqTfVf?=
 =?us-ascii?Q?MbumOdAK543TapCscMFE2CSEv6Npl5oMjAL7pMjqCW+eIfBAvV+UlDbepMcX?=
 =?us-ascii?Q?zRodNR8eHK6u/8MN/uBG3YL3gsAGPJ+91jpKjki0mzGoVlmoBYDyuocVqUTQ?=
 =?us-ascii?Q?pDMi80LqQ5GKAUESONWKTyilClwR9vBegvqIJqCeONn/lKI4fN6M98el8W0g?=
 =?us-ascii?Q?fWMeEQoqaTKy73fsl2yRvW6eU2FlPOoyWTlW3d/Mn7Me97trHX6e0NI7+Ucr?=
 =?us-ascii?Q?0SyIHiZprkcOVABQgJZPXUFqf7EBxfUFypxJoOPqBqsHb2HyhPyFKHh+Jl6l?=
 =?us-ascii?Q?dyj8y+OIpHZvF9y43V6L8TGZTqRSsiK+VPioEbb0ShJPFCHqt5H3MSFONw/Q?=
 =?us-ascii?Q?vZatKatGUeErVJ6zLBP3SS0ikFHxCFUNLf+BAxhTdFI//0ArA7OffFjuP2J+?=
 =?us-ascii?Q?hnd//YQ6B6rnXh1HYBpF2a3+Y4ZFV8ojXlmpjuG6WNkE1zMQvE+gy4qxvxuR?=
 =?us-ascii?Q?VghH2XebKzATlcxNcEuzoPYA1QwzOvWRDjW4d+x/3fZqjRzEQK1KuUtnj0QJ?=
 =?us-ascii?Q?SBQTpXpLh+ZXgezeOwshWakaRG/tA8TzNshPTfyw04kWXRUmIo4ObXg0sZcO?=
 =?us-ascii?Q?kqbMPdQ4CFtSioWdKFBVM/Qev3ha8XOjItGtBjjZeAMU9S8IgW0yDh6XJTpb?=
 =?us-ascii?Q?LU1nTPBg0jR40yd+cAwqjEWoCbjcjPNLMzcBLNpkcs3+h3zeXuLaY5tLxm+7?=
 =?us-ascii?Q?Ao+yoTJgaFrpbPLfoh/4TIPLdyh3muGFfkWsxrSN9Q+xax/A7zESD5ll1Qwz?=
 =?us-ascii?Q?wWt4SD5LPB0OoXwtV+/VQE0he72Ya0Qs7SqdArEKFhXyTpqF6deTvKBm6js3?=
 =?us-ascii?Q?0lX6a9gUKTkP4TJgW7QoUn7926SZ8VIeoYam1Xp0lUW8ITEIgWaR4RfstLoW?=
 =?us-ascii?Q?hU6EbRB7sI4bFX56GWTjibADjJZE+KU8W3UTGJQnl7zpfnlSA32Qiw++fY1Q?=
 =?us-ascii?Q?hJRyth6NgN93mpZV2YKD1AKuYpHuKOxCYjw51aaSwfZ3P6aYiUAGptEESPa2?=
 =?us-ascii?Q?mBWqDgDWYJpLfFeIimvkZKD2ZFqou4jry3eY2H5nRvcza2EFBftoWE9yHHvs?=
 =?us-ascii?Q?x/nVFq6UZ0rJ59rsMMvKujO6iKh5TzER8GJwu8oVB01bBc9qF+xai/MLzil+?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4268b3b1-7c2f-47dd-1ec7-08dab7a8973e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:54.7572 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISDdVSXoIBZYmbyQHpcd1GGOxwwExVEnQUhV/od0D5Ni2t8BQj7M+U6Q/UrrK3xpu4VaZLOjJEmDrDi500dT9uVFPhVZvHzceANB8DGuZ6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-ORIG-GUID: _lesu5tDV6ptlLEOxODzWXY3G-xBinMW
X-Proofpoint-GUID: _lesu5tDV6ptlLEOxODzWXY3G-xBinMW
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 04/19] scsi: Add support for block PR read
 keys/reservation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds support in sd.c for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c            | 104 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_block_pr.h |  20 +++++++
 include/scsi/scsi_proto.h    |   5 ++
 3 files changed, 129 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ad9374b07585..86b602399000 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1695,6 +1695,108 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
+static int sd_pr_in_command(struct block_device *bdev, u8 sa,
+			    unsigned char *data, int data_len)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
+	int result;
+
+	put_unaligned_be16(data_len, &cmd[7]);
+
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = data,
+					.buf_len = data_len,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
+	if (scsi_status_is_check_condition(result) &&
+	    scsi_sense_valid(&sshdr)) {
+		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
+		scsi_print_sense_hdr(sdev, NULL, &sshdr);
+	}
+
+	return result;
+}
+
+static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
+			   u32 keys_len)
+{
+	int result, i, data_offset, num_copy_keys;
+	int data_len = keys_len + 8;
+	u8 *data;
+
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len);
+	if (result)
+		goto free_data;
+
+	keys_info->generation = get_unaligned_be32(&data[0]);
+	keys_info->num_keys = get_unaligned_be32(&data[4]) / 8;
+
+	data_offset = 8;
+	num_copy_keys = min(keys_len / 8, keys_info->num_keys);
+
+	for (i = 0; i < num_copy_keys; i++) {
+		keys_info->keys[i] = get_unaligned_be64(&data[data_offset]);
+		data_offset += 8;
+	}
+
+free_data:
+	kfree(data);
+	return result;
+}
+
+static int sd_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	u8 data[24] = { 0, };
+	int result, len;
+
+	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	if (result)
+		return result;
+
+	memset(rsv, 0, sizeof(*rsv));
+	len = get_unaligned_be32(&data[4]);
+	if (!len)
+		return result;
+
+	/* Make sure we have at least the key and type */
+	if (len < 14) {
+		sdev_printk(KERN_INFO, sdev,
+			    "READ RESERVATION failed due to short return buffer of %d bytes\n",
+			    len);
+		return -EINVAL;
+	}
+
+	rsv->generation = get_unaligned_be32(&data[0]);
+	rsv->key = get_unaligned_be64(&data[8]);
+	rsv->type = scsi_pr_type_to_block(data[21] & 0x0f);
+	return 0;
+}
+
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
@@ -1787,6 +1889,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_release	= sd_pr_release,
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
+	.pr_read_keys	= sd_pr_read_keys,
+	.pr_read_reservation = sd_pr_read_reservation,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
index 6e99f844330d..137bf2247273 100644
--- a/include/scsi/scsi_block_pr.h
+++ b/include/scsi/scsi_block_pr.h
@@ -33,4 +33,24 @@ static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
 	}
 };
 
+static inline enum pr_type scsi_pr_type_to_block(enum scsi_pr_type type)
+{
+	switch (type) {
+	case SCSI_PR_WRITE_EXCLUSIVE:
+		return PR_WRITE_EXCLUSIVE;
+	case SCSI_PR_EXCLUSIVE_ACCESS:
+		return PR_EXCLUSIVE_ACCESS;
+	case SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	default:
+		return 0;
+	}
+}
+
 #endif
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c03e35fc382c..0fd6e295375a 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -151,6 +151,11 @@
 #define ZO_FINISH_ZONE	      0x02
 #define ZO_OPEN_ZONE	      0x03
 #define ZO_RESET_WRITE_POINTER 0x04
+/* values for PR in service action */
+#define READ_KEYS             0x00
+#define READ_RESERVATION      0x01
+#define REPORT_CAPABILITES    0x02
+#define READ_FULL_STATUS      0x03
 /* values for variable length command */
 #define XDREAD_32	      0x03
 #define XDWRITE_32	      0x04
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

