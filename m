Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07849C3F6B0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003499;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=myRzwcyd5z8rrd/4EKNxz8DksEy+Spu+YFGP5mYqe3U=;
	b=e2KZ20EdpwSw007PAPKwkHwz4+pNVHfSP7kCC0L/Qo7EaWDLZtgOKYufOd1t9ziTJg24y1
	AV45aU//hog+AElQNH0hpp1Nmt/Yo3k4tg+uFGVK2VWhg5DYQ6/yyvRMQ4VDRrbsEz/lW+
	sbTu2AmhvSLlVq2qq7mgtrTs7DJAeDg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-mF3Sfi1sNkeWuk0D3XN2_g-1; Mon, 08 Aug 2022 20:04:55 -0400
X-MC-Unique: mF3Sfi1sNkeWuk0D3XN2_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A35E2858EED;
	Tue,  9 Aug 2022 00:04:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 872A940CFD0B;
	Tue,  9 Aug 2022 00:04:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 044581946A61;
	Tue,  9 Aug 2022 00:04:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B78EE1946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:04:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A87D01121315; Tue,  9 Aug 2022 00:04:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3CF91121314
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:04:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87954802D2C
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:04:50 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-SHrt679gMqSvETxfTHyUIQ-1; Mon, 08 Aug 2022 20:04:48 -0400
X-MC-Unique: SHrt679gMqSvETxfTHyUIQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGD020677;
 Tue, 9 Aug 2022 00:04:30 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut539w-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:30 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0hLj038089; Tue, 9 Aug 2022 00:04:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hu0n32vhn-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:27 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:03 -0500
Message-Id: <20220809000419.10674-5-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:610:38::46) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b553e5a-1671-403c-3277-08da799ab9c8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: qBeZ1/C0AVFv2b1X7vO15Wqx7Oi9ABTIEU499SYZkF3F+ssDMfvboFspgfSUppqA/mvq/O15MZvnFtVtHcNHx1AjZxqUyM8mfgj5fzYuC+XO/0xX6uE5oo5b3xcnkraC/OBphkpzHrUIp0G8/wKjSPx72niunTKLOl9P6ZGIl/7mmi8Zqaa+tBDgML1U42xNGrYEPUXQ4kohjpo0lBLYKT5cGYrd0lkQJMyjGNTZ8LP9v0wcCnnwxlPZj0jod3X/2Fyw3nDh3p4Z7VsucN3zfvdkkUtIPraAmpjxaHd0ntITezhHaOwKkreSeERTOvF/GprJ0Gd8wJ15h7ZtToB1xkDRocjBosPbD3I+DpEm59L1MWYyxYWSg7M+2eGm0cJl+YJYkeNePiH+B7SDtTx1vzO7ezhljiGKDpWoo7vqBjuo+oyfRULK4JCy6RGJmlaPpw2GZhnZPmgSut7MuoDSa0q5lk1twbpqOOI+eGdFW+RmG1oSTyhBVa+S5N8Ca21ozX4iPUWHpm63PwvkR4+9fgeAmIcTF4qC7d6slAFVNq7v+maJ3zeEuQ+qu1thu3YQuBnSUvfgslxlZOUMQShrnhIwbIFlY4vkk1fexDCTdeQzoMeEdU4zvs8/Xcw+nouDh93Mj4rqGeavO7XlsHKTo/z10v9krt7BPQ1DHc4KzRZovxI8WD47kQuvM90O1I+11Kxn4APY8x4j7hGZyC5smKv2jGcVBFhHenadk98niPFmE428mUBGqbql6h4serGOuD5cG4e6Mpb3B/c2ufP6jZ/iYxIRZKfpeu3fUgGD9Lw=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q8DYItR18LfX+rGG23l5lC3T270xZy3KHo6C3GJ4GV8pP6AegXahAli8wk9D?=
 =?us-ascii?Q?E1BQWFqoAU8rvb+Ylr+WxCX/ZD0fQMc56cpnzf83+tY0jRTUBUEKnJBePaSE?=
 =?us-ascii?Q?1KLPC5FeTdGLT6Jwnwb3w/hWgNajAp/4I3TsP3n2avpi8R3IWOX0csmUU69n?=
 =?us-ascii?Q?jiY1h8J3WWLwakoSk/OEjYf568T95fCQSxUjQoucwroHazlvxaKvhldlAg02?=
 =?us-ascii?Q?SmSRr8uIeazm2eNJk2HJN4SmhJC8Zvr+36IwKajo5N9oDo9D+6ImIjb7B675?=
 =?us-ascii?Q?4S0JkTd3EC0Jn5/Ep6XxURhhz+RqnH7w7sAuLp+z4PBUfd+YoYLOJxOmprIq?=
 =?us-ascii?Q?5C0VvbZHHQDpS7i8zUSchZIxosymGajeA3sqDor2dRaO7uTEP1w9yW+QS1G1?=
 =?us-ascii?Q?r8KrMuV8E85tWw0iUTLu9LlYaLS6Jv/0r/TtqnUif2rD1NzxQwYWDxXZpvmo?=
 =?us-ascii?Q?i6qkcoUb8/IRsXQNkGpB8VaIRVzEzCpKKMPBVS5W56o4PbItbxH2xC+bSatj?=
 =?us-ascii?Q?qYbwBYNSNuCn+11XEXlKAYrAU4wizHBi3M2PGHfahphT+L0FxwcYrMbls2fV?=
 =?us-ascii?Q?iluqRHMUtCgrMpnwIImsvBD7cV+oMnvhIT2lXGwGVCxQMB6As4qRCAvHNr4g?=
 =?us-ascii?Q?F0uDtOfGRZwGxQEIFU/buNT1AWOSvf8fpsKGbFQygOfN8c55snxdlxg8B3Gg?=
 =?us-ascii?Q?HXv69E0jjeSsFiFfnGczV7Tu/FDT9jQ+RBNfPHMY/7cQy/FNP1AHH/BZZXyr?=
 =?us-ascii?Q?7mPNOUDpdsTpuEIwPORnouU82+GrJkHlBuvqjmJrd2wiFoWsiuGFX9SAdQ9E?=
 =?us-ascii?Q?TQL2Zl5cm9RVcsAoe4Ydd+GLrEunwbslHpDJm1KnFKKMygdQCECkuq6TJqO6?=
 =?us-ascii?Q?l7xfIbjdzUfZhYdSoMgsHB+1e24uTzdg02kFf7gQ9SJmrQOp8QEHExcm/UhY?=
 =?us-ascii?Q?+8GQ2LLZa/ulBG9m6Ipntgjl8tpwPnRuHD+ZDRBqZisYnJDsFE+JKbNlQuyI?=
 =?us-ascii?Q?qLPZ9q3dvng2/cxkUocnNYRvHXU3ls1qEDpP6vIa4Jgso4dCNcPbUX7NS9ms?=
 =?us-ascii?Q?XENwNBqiu0MLnfg1leQ8UzwKBsYiaWaNQ5LVnKwfeflq+u65FZHaybEI/LXT?=
 =?us-ascii?Q?80uL1iRywYqohGsRMImVv7Eh0acGGivQWMnyj7SLjSE/DTJgo2f+nyglWF1z?=
 =?us-ascii?Q?YTH7EWy05v/xSHQ+/Mxu/3h8Xwfdvo/lwtfdtmRepmgJb7HPT2vHnsDtonlh?=
 =?us-ascii?Q?ukTAYpKVpqd0iPXc0e2xkRZPiOGOvEbmjymXB5fEAlIHaSzN2OtBEBORfgha?=
 =?us-ascii?Q?Zd0LRoL0Ari1gbkcAx6eyKCLtS0BIydyUEV6N0QpIGFI2tbhazYmJZOQP5pW?=
 =?us-ascii?Q?JdwlFcBJZpslUOyhEKgh7bhSWBAJSj7hWKQS07SbbVF6C+feo6kpg1+UbgSZ?=
 =?us-ascii?Q?+v9ZD0OVybSGz/uN/MRggaoi+elvwdH183oEPfJZ37QxuJTA3+4TnpihltTx?=
 =?us-ascii?Q?nDp4d6zYuMqNHnllRcz9JkLlBjklA9I4TEMLvG1AfwPnx+Uptblm66RyCwpF?=
 =?us-ascii?Q?3+Yc7le76nGDCqsAPi2ElberLivRAf6TKWssX2qi8TaaOnB6rZFdb87pLCfI?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b553e5a-1671-403c-3277-08da799ab9c8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:27.6269 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9agbnp4WCGuGJMDswSCeErMl0hu/WUKaJ11I2+7E10yMaEoIeg9ydZD2Dy+betCwAssikz6sZQbuLZCheLcyRhWm/Y4ofSXtXlKG2vKjqmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: PhKwCM5YkdKfu68vMR_CzI-sVOpHy0x2
X-Proofpoint-GUID: PhKwCM5YkdKfu68vMR_CzI-sVOpHy0x2
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 04/20] scsi: Add support for block PR read
 keys/reservation.
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds support in sd.c for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c         | 88 +++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h |  5 +++
 2 files changed, 93 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 88ce1464527c..f1d4d0568075 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1683,6 +1683,92 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
+static int sd_pr_in_command(struct block_device *bdev, u8 sa,
+			    unsigned char *data, int data_len)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	u8 cmd[10] = { 0, };
+	int result;
+
+	cmd[0] = PERSISTENT_RESERVE_IN;
+	cmd[1] = sa;
+	put_unaligned_be16(data_len, &cmd[7]);
+
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, data, data_len,
+				  &sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
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
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1757,6 +1843,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_release	= sd_pr_release,
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
+	.pr_read_keys	= sd_pr_read_keys,
+	.pr_read_reservation = sd_pr_read_reservation,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
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
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

