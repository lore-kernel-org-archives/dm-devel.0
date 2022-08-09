Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65D0C3F6B0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 00:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660003626;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N+4HmivAdTUk3zb0z1MLXUK+hqFeKwe4ZfsBqFiHBs0=;
	b=iElnF1boi9g8E02QLxhXNOeUkVaa0rYiZVQYzE43w3so1X95nSzs3unkdollp7viO+THE+
	x0YzKo9orLMCQ3oQIKso1o7/YrH/UYomtRhz1BC51qEI2iBkoOWI0of/8UsO4pSL4jddhf
	SdjThywk5kF0q578NY2kx++esBojVEg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-cR-PTWE4MR2JmnI9YGLBKg-1; Mon, 08 Aug 2022 20:07:03 -0400
X-MC-Unique: cR-PTWE4MR2JmnI9YGLBKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A7EA3C0D18E;
	Tue,  9 Aug 2022 00:07:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44221C15BA4;
	Tue,  9 Aug 2022 00:07:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB4031946A6A;
	Tue,  9 Aug 2022 00:07:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B2FD61946A4F
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 00:07:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A72C1400E88D; Tue,  9 Aug 2022 00:07:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A283140B42B5
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:07:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85E4F811E84
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 00:07:00 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-rgJVHwr8Mwy_DhZkFTyS3g-1; Mon, 08 Aug 2022 20:06:58 -0400
X-MC-Unique: rgJVHwr8Mwy_DhZkFTyS3g-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwJlH007174;
 Tue, 9 Aug 2022 00:04:40 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1dr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:40 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 278M0wO8034454; Tue, 9 Aug 2022 00:04:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser2d9y0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 00:04:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:37 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Date: Mon,  8 Aug 2022 19:04:09 -0500
Message-Id: <20220809000419.10674-11-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:610:e4::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0965737e-6a41-4ce0-aa77-08da799abf71
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: iwkhN4zbMM73KCM4GdHdr7afukkWihCTifjCw5jMKCxXFB8bzB2PJlBLbaLLSCzSsUMZKgiZeOnCiKPgexdvJjnhI7qXXa6hX/0CF42Kadpt0dxC74zsjsopkV0ks1Pn7qGBLK+ooECgA2uouUuH7td3PNyEsfvvLJgScYHCgER4bJP8vEtBFumR2DMsiiX+Lg3C33dXPUv2hiDVfcrCFqMBsVdDfepA+Jtd8RpHg3uhkaqBOVTwk70PwIhnWwRYAg9SB/SOpg2PtPt/7IBVsW2jH7A8wM0Ff033uMb1A53AvIYXO/iAMqXGMU5KivQCrgHtdFP6Cr3IxikwMBKL5ISF7PM5w9D6kLy+pF5xErGeFliW3qvTTogOpNkrhEpR48KPygcNw5Yr6yjecmyPS7S0NO48VBm81w0u9DFkDjPfUKjWhFIhwfmLeAD+C3RE63yiNiXaG8nlFv+3bROnykoA2F9Nw7xG0ZsU8lKVUtyCRD8vGo0/CPx8JkYwSWdnkbsTScb4mtZjY+kVN6/b1ODul88NTfYNy4e/YcZtI/Q0d2C9t5knjeD6cTCkHwXATBzvtXOnDqQt+1ROssik361K3vxlY8i8k9KZz9qltXXwjd2hCOaeIiiR98EPggzns1vMVUNLMfOP7c7J0H7exm2c+nlndPK+fn5fmy+/nijkp8sWrOJNy7Ic1W/vdNoLpe9/MRN6gF1uFzt5QQOqwzYLTBGUslH8XuiyWYMEqohlZl3izppErKxbX2/h35Y+eBpssZVJ2RtPrFCdvyhA3nS72XbedkU66nkunxrMcDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Sv41cQSx4TkA1F05e0eLByN4+jCg7vY5eYzJsFZc0PJ94zEiXKEvTTyvHYw?=
 =?us-ascii?Q?oLQYUkjOqJwYmEYv3K7Wopv9ta3BM+qmQ9NBHQa56gMGlybpDlbefOUrqBhm?=
 =?us-ascii?Q?tfPjyiPYOXvMtPRjh4FA7FJ1+I9K4iYw+as6ifMOWD7QXnegrmF9hbDO2YnU?=
 =?us-ascii?Q?CgV5NbDQTxX3eYstNUyRnbcT6jPznrKX5DX7KJEyI/Eee7X9jYnJ7XXMiP4L?=
 =?us-ascii?Q?sJ45TI5UIFK9k16vJQ3lQ8yG4sYFtACbPq9tIfrXzrQh7ZQgDClEpcgF/520?=
 =?us-ascii?Q?1X9CrEuZvqK5RVOahKYWuWTc7fjwvyvugKj9w6N6AP3B/cPdFJb1z01IxzBQ?=
 =?us-ascii?Q?Mkr5cG9tTKaWtE2x7qEoMh3bWuJXL+lw9347f7QY9eLEhG08xqtymvAL+DYP?=
 =?us-ascii?Q?Kr+OcnV4FDFaUKjrW0OOYVlH2Lj0MJUJeo1DE+91dfwWXo3ynGBH1oHExymn?=
 =?us-ascii?Q?/bMI+pCaMdeL6zHBhmN7g6tvHXmYWaCxTf5VUMhpsWZCpv9WjOraFlKQfgm+?=
 =?us-ascii?Q?dAAOuh9/wKfFBhd3zR8v6ymlg7J0tANEqYkWHMkJr8zDH7ylINGkFKnj7YZc?=
 =?us-ascii?Q?zdgCQN3PTButBEeGtYhcNsYy8xLLMQMqxPKSsir0jUaZ3luUKp30u0qY9w3+?=
 =?us-ascii?Q?nzLlncAciZyZCNdwdQTS9aKA46czFY8CM+w6tNuB7Ayf4df3Ays4vpCTT990?=
 =?us-ascii?Q?TyNFcvZoekIgeDCda1BTIln3tCT2ayVFfbXvPx66PSUgcpAG87qlSTB3gN4A?=
 =?us-ascii?Q?vVrOkjnTgk8Z/huksBH9gi17NyLuyVprA6KeZxukFnpEN+yxs2G7t6juEzLr?=
 =?us-ascii?Q?lCiDc4+MCVwqNbxFvfIbsIhpUb2Vm7Nu004JLcy6wa4hsURpouWZYuF0RjW8?=
 =?us-ascii?Q?d6h8alNLYq2AHzJzLku/BxcCzMWU4Op8TP0aCXoOna/Wl8TbRL1jJ9bLpVKU?=
 =?us-ascii?Q?OOCEMlLnlMxmfSOKqMrslnpjFbVQdhBkt2czM6bCnR++RBMwpWtnh1tcLHjd?=
 =?us-ascii?Q?CRSO6kdVlrFwCEkVlnCLtsXzAwPXR37CaY0EU+kUuZxEVA++C6YP5V55SWFB?=
 =?us-ascii?Q?juucjdJh+BkrOfdM24iSk4n/5rsWkk4kksnye179g9EWRNkrE+ARjDQ0aIuy?=
 =?us-ascii?Q?2hSmYKlWh6NlUGHJjcoltfqGBloOWHUBEHt4NqkFS2LTe3daDSYgOdXKgpCV?=
 =?us-ascii?Q?IZtLIsJzhagJ0Icx2kaNgIEuSfMMPpj6aDNVVKGLGRjpr3CdmO73300q1Xln?=
 =?us-ascii?Q?ds/jI1FamdesoL+QWuiI0cICtmBD894wjJYMi6CHGIJNyEHdlg5HiczStoBy?=
 =?us-ascii?Q?m+x64mG66VniZthbE29r0s8h9NVzXevXYPAGxWDPTq0Q3+zjYq8oFDqnlYT7?=
 =?us-ascii?Q?TO7uwQvxpL6qS6qc9qHCg2rEQKCxoayloYUDZD7px5LpPb7nLrBUHrg8dBUZ?=
 =?us-ascii?Q?XMkxek/atneOUMvTMKjQVFCuYSGTKV8bgDWgbD7N1TB7szVYqeD6iiJi0PFc?=
 =?us-ascii?Q?YeY3XlkvrTxyvIrexzfcZxi/PedEaReL9B/WaZ5ecJdJDouLISA2xlbdpxsS?=
 =?us-ascii?Q?9L4FxrIcS4BlG1NIPZPWsFNLEogsO3CGy21v8NRYURilzzd1NorLdct1xnuR?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0965737e-6a41-4ce0-aa77-08da799abf71
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:37.1730 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zumiu28o+wnRIEOav1QCmuA1P7rbC47Sa8VkqLo6VbQ0YKZmDzdf2mYwtIjpOtWipAndeCKCpUWyoxjCxOBoFjgJTlZSgomNZ1M/e9Zde1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: rXq1RCRo4rKc5f-vg60VMPq0Hx5Y6W63
X-Proofpoint-GUID: rXq1RCRo4rKc5f-vg60VMPq0Hx5Y6W63
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 10/20] nvme: Add pr_ops read_keys support
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds support for the pr_ops read_keys callout by calling the
NVMe Reservation Report helper, then parsing that info to get the
controller's registered keys. Because the callout is only used in the
kernel where the callers do not know about controller/host IDs, the
callout just returns the registered keys which is required by the SCSI PR
in READ KEYS command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 45 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 6b22a5dec122..230e5deca391 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2223,12 +2223,57 @@ static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
 	return ret;
 }
 
+static int nvme_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info, u32 keys_len)
+{
+	struct nvme_reservation_status *status;
+	u32 data_len, num_ret_keys;
+	int ret, i;
+	bool eds;
+	u8 *data;
+
+	/*
+	 * Assume we are using 128-bit host IDs and allocate a buffer large
+	 * enough to get enough keys to fill the return keys buffer.
+	 */
+	num_ret_keys = keys_len / 8;
+	data_len = sizeof(*status) +
+			num_ret_keys * sizeof(struct nvme_registered_ctrl_ext);
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	if (ret)
+		goto free_data;
+
+	status = (struct nvme_reservation_status *)data;
+	keys_info->generation = le32_to_cpu(status->gen);
+	keys_info->num_keys = get_unaligned_le16(&status->regctl);
+
+	num_ret_keys = min(num_ret_keys, keys_info->num_keys);
+	for (i = 0; i < num_ret_keys; i++) {
+		if (eds) {
+			keys_info->keys[i] =
+					le64_to_cpu(status->regctl_eds[i].rkey);
+		} else {
+			keys_info->keys[i] =
+					le64_to_cpu(status->regctl_ds[i].rkey);
+		}
+	}
+
+free_data:
+	kfree(data);
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
 	.pr_release	= nvme_pr_release,
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
+	.pr_read_keys	= nvme_pr_read_keys,
 };
 
 #ifdef CONFIG_BLK_SED_OPAL
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

