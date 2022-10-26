Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7910DFA374D
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0f92XE2LfNnhZ0PdgM2RPGVLRoYAepGyix3XJ4azvls=;
	b=GX7gAlR36p/QW7n8XPf6koXZhF+/XLXCbSencw9FsizVoGcjtcq7LyeBg+8gFgpSlIkfCM
	mJQmz91hZ8tQgLWN90aTSVRLjpb/gqq0oLa1f1WaV1TvewObSY9+RKhXK79h4Mrokq9Joi
	7+zunx3wkaVfZdUuUkl6LrEDHR5psdA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-YuIE_diRPAOwLNWLTsFvVQ-1; Mon, 31 Oct 2022 02:38:58 -0400
X-MC-Unique: YuIE_diRPAOwLNWLTsFvVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7865185A794;
	Mon, 31 Oct 2022 06:38:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A2FF8111DCE0;
	Mon, 31 Oct 2022 06:38:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88300194658C;
	Mon, 31 Oct 2022 06:38:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8427A1946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:22:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 69F0AC15BB4; Wed, 26 Oct 2022 23:22:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B4EC15BAB
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2819E85A59D
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:25 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-Fv50B08MPKinYfbwIQk3Hw-1; Wed, 26 Oct 2022 19:22:23 -0400
X-MC-Unique: Fv50B08MPKinYfbwIQk3Hw-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLF2IN022198;
 Wed, 26 Oct 2022 23:20:12 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n8q-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:11 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QLkbbJ006786; Wed, 26 Oct 2022 23:20:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfaggdrr0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:07 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:39 -0500
Message-Id: <20221026231945.6609-14-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:610:4d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bac557b-25e3-429f-af4b-08dab7a89ef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 4/queKXzWynAkDsRbmZE4LOypt72kyGy7Ffg0zLvgOZdkt28xkjVW6c7E2O0KgAnEfl2qAc74sDIdscFnFIuVtpk+B6wPUwpjO1sULjKlgq8/347CM67KV+HR0KDf25OphunkNI5c+tpvBGEmyj3Zfp46gqCTi0Aju7C++C3/UTKSUboR4V/jNgqsM2yLYZkdYURMKIkXae1aAQDykgFuK4mnWwojogRqoaab2/VJDvp/3ot9NYlwa+P6nKDT9Cz72w+5ndueAE8SqjZ0oaWEAVomegjq/jGBG90iBVIEunCM6XeFzq+QyncCapdOKiJwjzlBkLJnEvylk2RFhfZ3W747jmt0bWfIUB4Zfg9FJ3ypfkXR1FIQAsqwoI2AdHHfDmGApcejJ7AKRjbwEvJ3b7LHG7yv4yOpQAicH0l/t3RVU0oefLIezf3TR/Z9b81APjxU6Zi5GZejajLH5lMNyWtgTDN4IZVjz7Zy5Loda1E99gM24Tet0KBiHw81lXCiEQ7W+4HWEPm0vgDCNHFEnMsF059fh1+9ES78zSkbO4sqUXBtI4U/D3B1Y8p72kKLe90U3nNyvrf475C6iw7voXqrHNG0vuLVTQnhXPn7Y6HCNPa7Pqzthg0xj4voKztDeJZehMPPSCeUkKamxJ4AhGwxNcdqJZsiJgaRdajQORGtPa6O6cxT/VzaI03c/GJDatBuq8lPkfIzJO6N6B9SflP7D96ls4h34SGiPvVHDj+5scTPDUnPF3nXP60DRoj
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lbIfyVXuWMC5/CHCt/Fjdixlv+BmGASjG9kHrCmiEB9mGutjekg/cmoM1gxp?=
 =?us-ascii?Q?SKA6bSOtuUAv/WTHX8U71T1YesDFgYFDzYpdmvehuHsIS0/uH96UTtQ0ZBO9?=
 =?us-ascii?Q?YulfR3KGu6Opn/SCj5zXSavT7CoRRjBW4uF9W+5vUk0OfTeHnQBXFInF66sp?=
 =?us-ascii?Q?LbO5a2GeG2LO9Flw6J6+2N0TQ/zy2n8Y5QfwIItcWsifH3Jf6J8nxxpkrHqa?=
 =?us-ascii?Q?0lG8L5QU0j1rkEi8MARrs22WmO7hnLofIXrmRgEWdXYkKu5EDxjIYW5XsyOv?=
 =?us-ascii?Q?jPgWCR0wirVpMeChl8fH9sGZAZLvGpoCHAzzohMaAJaoU9QK+VQe2HxILzwc?=
 =?us-ascii?Q?acBq5x2LznzsrNpMsXtygUVSaP5nL/qjNmNZlEEobepbjJWXrFE315ut0Va0?=
 =?us-ascii?Q?XflMhnklH6/KmelM1KV7qc4oh1K1OpuBjrRA85PJlmC1YjrANxROKvSOW0GI?=
 =?us-ascii?Q?lF5VWEpSnvrqzfPbqBlVGVJBYE/SFpaCIx1d4hhIHJD4xxRwegNYGlR8LwtO?=
 =?us-ascii?Q?X+iz4Z6oUdIWwpP3euhherd1WhuSNUg2ZJW+X0HPQwQ1UHQBMdjRy/SkyC1s?=
 =?us-ascii?Q?DRvA7gun1V5AVAAz4GWdxXXrANrbGsdw3UQ2zjEec5udaPekGsRUQfmoHHV5?=
 =?us-ascii?Q?GZOOUFuuMSyuKUWAMlOna89ir6GXelPqlLLGL0Fxy7w8tQGlFMlOb8QZ7Ntk?=
 =?us-ascii?Q?a73S5nl5ICa8GksBp2av460HHOMF2Dk/PGg9zaaMUN5WVNBdjx9ENQBA3JKW?=
 =?us-ascii?Q?tES1oXaWzPbnxhaMCpv/jRGohp2/HNm3EW9m8xEv1hbX/hhAu3VIzydm9OKW?=
 =?us-ascii?Q?K1t4Y2c1Hrf3Bg/Bo55sUiM0Z9c54tClTwRG368bpyI4AraV4r01lo2GPXHc?=
 =?us-ascii?Q?qxgaeUo+Abdu/wGHSgvpUuqXAW93TGjXlcJkxrksAcE8tjOAg14Rl5mSHzH4?=
 =?us-ascii?Q?bbCZCXY3v6pP86DaW085tjXbVdxKN0NKQ5qzc6DCfDau0W64iM4aQuA/nf4L?=
 =?us-ascii?Q?UJtAic/1MWSWnivKKvrH1Ez6Mzfej3bp38Dobe+jwfjWJVlqbVMKzZ+EXNvl?=
 =?us-ascii?Q?b5L7gNZNiv3/iJRNUkrvNo/+d4Rfq7nHHKRn2iYCeo2zrSIesNRkHN8WJ8ou?=
 =?us-ascii?Q?+HSOYhfdG5bw2PdgqpCpYKAjo6rvu69uq0iMgA81KYXKzD0MDnsk5vXSN0jR?=
 =?us-ascii?Q?HqgAdE1oHBAUPqA15IrEm8Sndcbj4BNalxtCD4c/cFLj3SjET/Y0nFkvZ0Tj?=
 =?us-ascii?Q?6ceABrDyjWzTYR83JltnSSemaQpMmQIwCbIYb4GkabZyrpp3Tp5A8gxoObBD?=
 =?us-ascii?Q?pg9uNMDYCp2KVjOU1sx/JvH37ydfpqlHWeMKyteQYu6ahkT64gD0yaYi4WmB?=
 =?us-ascii?Q?XFJl20/umeLYOv3BjekVCiICF0Iit/JlNkLuU1iUI2M1MbebLZHYNma9vU5I?=
 =?us-ascii?Q?vIygrGl++wEY0c7nIAP163pQ3ilj/QFnQ92U6ze0h4Wb5akVBEP67n8fzhR8?=
 =?us-ascii?Q?rIY3qurTL67GPXwkIoDtGYZAtHlzx9fskBN1gofpqP0TwUATE8It6/0nbOM+?=
 =?us-ascii?Q?+fCtLE4vDdlFtBP1TWxk7vp0mOOiUch3cBaevAPnmf7xVN868hMBS5C5Mgvu?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bac557b-25e3-429f-af4b-08dab7a89ef1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:07.6780 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ImsQzYkAjtyRpM5EwdEmjJwiwef7BCRBSBBcYr49MouTJRvA6QXmoHQs1uwNq8fgRtHpBc4kAC1C80jiBPZuzUhnDBVRyHJpVScfMkT08g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: pyF2ic3qb6MF92i4rRWgHLl5ZXiPwyTB
X-Proofpoint-ORIG-GUID: pyF2ic3qb6MF92i4rRWgHLl5ZXiPwyTB
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 13/19] nvme: Have NVMe pr_ops return a
 blk_status_t
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

If register or reserve hit a reservation conflict upper layers like LIO
need to pass that error to the initiator. To do this it has to know the
device/driver type so it can convert the return code because that's
currently a NVMe specific value. Instead of having the upper layers
figure out the device/driver type and call a NVMe conversion function this
has NVMe do the conversion and return a blk_status_t which the upper
layer knows how to handle.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c |  2 +-
 drivers/nvme/host/nvme.h |  1 +
 drivers/nvme/host/pr.c   | 54 ++++++++++++++++++++++++++--------------
 3 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2de9c42094a6..1fd152a90ed4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -248,7 +248,7 @@ static void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl)
 	nvme_put_ctrl(ctrl);
 }
 
-static blk_status_t nvme_error_status(u16 status)
+blk_status_t nvme_error_status(u16 status)
 {
 	switch (status & 0x7ff) {
 	case NVME_SC_SUCCESS:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index e82be1f1373d..d60da2b8c1c6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -855,6 +855,7 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
+blk_status_t nvme_error_status(u16 status);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
 extern const struct pr_ops nvme_pr_ops;
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 854a26ce55fe..818955c570e3 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -43,7 +43,8 @@ static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 *data, unsigned int data_len)
+		struct nvme_command *c, u8 *data, unsigned int data_len,
+		blk_status_t *blk_stat)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -53,20 +54,28 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 	if (ns) {
 		c->common.nsid = cpu_to_le32(ns->head->ns_id);
 		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+		if (blk_stat && ret >= 0)
+			*blk_stat = nvme_error_status(ret);
 	}
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
 
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 *data, unsigned int data_len)
+		u8 *data, unsigned int data_len, blk_status_t *blk_stat)
 {
+	int ret;
+
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+	ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+	if (blk_stat && ret >= 0)
+		*blk_stat = nvme_error_status(ret);
+	return ret;
 }
 
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
-				u64 key, u64 sa_key, u8 op)
+				u64 key, u64 sa_key, u8 op,
+				blk_status_t *blk_stat)
 {
 	struct nvme_command c = { };
 	u8 data[16] = { 0, };
@@ -80,9 +89,9 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
 		return nvme_send_ns_head_pr_command(bdev, &c, data,
-						    sizeof(data));
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data,
-				       sizeof(data));
+						    sizeof(data), blk_stat);
+	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+				       data, sizeof(data), blk_stat);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
@@ -96,7 +105,8 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 	cdw10 = old ? 2 : 0;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
 	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register,
+			       blk_stat);
 }
 
 static int nvme_pr_reserve(struct block_device *bdev, u64 key,
@@ -109,7 +119,8 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 
 	cdw10 = nvme_pr_type_from_blk(type) << 8;
 	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire,
+			       blk_stat);
 }
 
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
@@ -117,7 +128,8 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 {
 	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (abort ? 2 : 1);
 
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire,
+			       blk_stat);
 }
 
 static int nvme_pr_clear(struct block_device *bdev, u64 key,
@@ -125,7 +137,8 @@ static int nvme_pr_clear(struct block_device *bdev, u64 key,
 {
 	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release,
+			       blk_stat);
 }
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
@@ -133,11 +146,12 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
 {
 	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (key ? 0 : 1 << 3);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release,
+			       blk_stat);
 }
 
 static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
-		u32 data_len, bool *eds)
+		u32 data_len, bool *eds, blk_status_t *blk_stat)
 {
 	struct nvme_command c = { };
 	int ret;
@@ -148,12 +162,16 @@ static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
 	*eds = true;
 
 retry:
+	if (blk_stat)
+		*blk_stat = 0;
+
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len,
+						   blk_stat);
 	else
 		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-					      data, data_len);
+					      data, data_len, blk_stat);
 	if (ret == NVME_SC_HOST_ID_INCONSIST &&
 	    c.common.cdw11 == NVME_EXTENDED_DATA_STRUCT) {
 		c.common.cdw11 = 0;
@@ -184,7 +202,7 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	if (!data)
 		return -ENOMEM;
 
-	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds, blk_stat);
 	if (ret)
 		goto free_data;
 
@@ -224,7 +242,7 @@ static int nvme_pr_read_reservation(struct block_device *bdev,
 	 * the response buffer.
 	 */
 	ret = nvme_pr_resv_report(bdev, (u8 *)&tmp_status, sizeof(tmp_status),
-				  &eds);
+				  &eds, blk_stat);
 	if (ret)
 		return 0;
 
@@ -240,7 +258,7 @@ static int nvme_pr_read_reservation(struct block_device *bdev,
 	if (!data)
 		return -ENOMEM;
 
-	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds, blk_stat);
 	if (ret)
 		goto free_data;
 	status = (struct nvme_reservation_status *)data;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

