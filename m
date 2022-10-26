Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A23BFA374C
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vRbgIorSbnAWEPIJ6DBgu5mAOyYvBUrPz78/G7ZFc+o=;
	b=R5dojJT93npzEyCa5gpaQVVMaS6CwJlAkoMfU6hTi+V61SlnTWazTtNxFChYVg4UOA7Guc
	hc59gVnirUfoP0hkwZ5BCyV/giGgZNLhMkWgjuE6iyzQyrCnYKMmXR1f/OahtVnSgm01CN
	8eyGZYZJbqpb1+kRzVg4PWjBYbQmKnU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-gCV_k3JcP1K4BN__0Q_S3g-1; Mon, 31 Oct 2022 02:38:59 -0400
X-MC-Unique: gCV_k3JcP1K4BN__0Q_S3g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20CBD8027EB;
	Mon, 31 Oct 2022 06:38:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C7834B4010;
	Mon, 31 Oct 2022 06:38:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E930719465A0;
	Mon, 31 Oct 2022 06:38:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2D901946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Oct 2022 00:57:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE2CD1415127; Thu, 27 Oct 2022 00:57:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B56901415117
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 00:57:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 946FF811E7A
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 00:57:20 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-FTHyP4m7OB-g-VU1FIOr2A-1; Wed, 26 Oct 2022 20:57:18 -0400
X-MC-Unique: FTHyP4m7OB-g-VU1FIOr2A-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM4n8s014902;
 Wed, 26 Oct 2022 23:19:52 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0aghxb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:19:52 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QMDn5i006678; Wed, 26 Oct 2022 23:19:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfaggdrfa-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:19:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:49 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:27 -0500
Message-Id: <20221026231945.6609-2-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:610:74::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c2bc16e-50a7-4ff8-8bad-08dab7a89451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: uT68YNrk7WdGG8kvQUcO48Y7nRWGDp2xL24UlfQB1Cb2VdyQl20Hg3uVffhzeamrTigTyWiMXxbUiQlbOhESAi7JpkHBfmIHvwhAwGQ0bbH/S80QdDv7ihYYLnt8QgHJh79WY+PtocAjNfHo94KlxD6pi+NWdwna6eb/NdQlzNMv4Y07cKxL9kP4i2U7xwxYa1xGOILRYBXaFfC+dnxqu+L7EmekQ6MHitvX8GWZSbKQ/PpXjyCHWsT7D+hfRGa0pXssM/n3WMJ0UQa3v65/vures81xN8sS4ePVXDX+KBWpS/OmugfKMusLKAlDMdgg3uWDqtIhVY1V6fVGuJb1mk2UTK+PFRVLM9zaSsW5rVGbmC7/56Eaere/g4xcQhgwUoar5lWol5aFl3DaKHK4vdP7v0x4Ti9Lh6GYFklPUEE8fiRhkohk5g7rjttyiBypMjRavpSVWI3RfRctlmSMC0kp6nEVjNu+E1H0a3lakq8EcHHOPTshLGqE7vaynlnA7fniRVlxoYHgEsAKaO7YYZ5/4aDUEcY3hAyfto2sJeXQp9t+/0MgnoQ8FRPgv+JSPheqCCjXAx4MDx2HNVrz5H/r+8HSx/nm0YC2ETQF1R5Wv4RTBysKbmx6BOH20iXqSASRheL2zaVE2DTHKk+qbmPly5sxjxQA5TYpEJnYzPqletMdzpRjLtTzAEUHkadrBmh4gg4aTpti/AzZuOaiyukSq0iBMDgM6fxAKJyFV4bU/RVXzQQSkPcflcHvEEyY
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2aWnUgnhXRP2VKryG1RmaYETXGgHtQ+i460FqJrWDMEegR4tff1RcQ2JAf1j?=
 =?us-ascii?Q?jlc47IauAFWLflVqxDAD0ZtmiOCEboU3F4fnlPC4AslNgVacJpK4x8Hbu69I?=
 =?us-ascii?Q?L/Yqr0Z0GTjEt4hPmEWr4zSgdmAiGgVT+2TgzK2hIiScr2+YZG1oooeUX17o?=
 =?us-ascii?Q?hkp8bSOliPujasjyxIlmJf5Us+gmdskMhOXk+oOXAEwVFxTI4WPO/7XhX+E0?=
 =?us-ascii?Q?cK1V9oxMyk59+MUxXF5Y+en9FOAWKRisZfKEbZXFJy7/IvhpQFsL0jkvSsKL?=
 =?us-ascii?Q?68I19U2z4zGyUUjZO+Da9aEdcsHhYl+yfLN4pAryvSa6w0YIYtiJLZmasTHt?=
 =?us-ascii?Q?5m+7FPh3c3VSvr2jxYDrRWKI++Rmu6vCSCtmUgZXAWk6enewaPiS1/IQX0mK?=
 =?us-ascii?Q?QWyh0X4qnta0m4vhlzXN+CbaalQPlw5ysC2KXOJdXU21zU7W7KZk3coK97pZ?=
 =?us-ascii?Q?tma/Ml05SxEOosCeUUMmfXTwtMN9tTpGzGRaZfKW2Q11jWTgtXHTeZcD5d86?=
 =?us-ascii?Q?TyxSOLjhUd0tdHzW5b3wblTFvGYWqhEBc0kM4/+9X74dMa3GzhMaY3d9mVM8?=
 =?us-ascii?Q?Jnxt6QVPp5mY7eBFN2AzpyQjO5xwZqivZLf6NdFx3wHT71MVoSs60l1nU9u9?=
 =?us-ascii?Q?PTrQf3S7olDMJYvjB7/eJBuq58GqHFfr+UkhopTxa4c6VBHwvI6Si2X0pDYJ?=
 =?us-ascii?Q?TWKrzygSkqwo69XXNxTPw0VrlaXVrhaO8zUn8vWOZYXY86OP23Lnq165hi0A?=
 =?us-ascii?Q?bR4HJN7xncjS3+pZTsKuV98D74naUWIrNOrP/Bq3rMCPwNibMC+w9f2z99Op?=
 =?us-ascii?Q?BCXJapMPMLAFqtD5xU11cuG8c/3GYPn8BgfXdynastRT4bLp4YIxj+eq7lZq?=
 =?us-ascii?Q?1LyQNdfHwANS1AY//plOUDLwZCRQddyelXoksrTgXkai8rOaV/9wo8+/KVm4?=
 =?us-ascii?Q?m1zG/pBt7AMbFpx5Q/2piJ+ZuQeklgPc+V173w5JTyB+mXAHbnHHHgNX4oJQ?=
 =?us-ascii?Q?KYPJVAjDuK6Gs1pER7qDRyGJuSi93DRDOMrn2uqSuxRK//Z4Ktp8/yvqawdA?=
 =?us-ascii?Q?FMkUyVOHMpFV1euBaahROi7zFrzN2cO1ZCK081cZuA4+LMsKWtdM/pXUR+zE?=
 =?us-ascii?Q?8hYGTaKWMC2MHyjPw3M/amfBMYvQLTIVvY5ZBERCVPvtPza1jmaQlx/qy6CY?=
 =?us-ascii?Q?2zmSRZx73dbG0YEy5PeJQnxfGbzZVBtW6QrsLgSgIHjux8J+ZZpc5HmcZccv?=
 =?us-ascii?Q?AI0mDxUHZvp8B6Z8AX76WLns+AS3TrN6gqXsVBnNbihpB+Ezt17G7RTm1rEr?=
 =?us-ascii?Q?fFHKgLdkOzLp7dmd/olAerC06bMWoddCL9NBVF5nrp3vifuLoAv0/IWAgSY0?=
 =?us-ascii?Q?KZo6zx+6CsXUq4dup9TKDYjz6RjnOEtPqmGY4+WYF/TtnDRKOYFr9uI0a5Or?=
 =?us-ascii?Q?h4PQqdDNrdttG3Z79HUqJYWnvUhw8RXCaVGkEkf7vfJx9oEFEGH0Vtje1GoM?=
 =?us-ascii?Q?nppUVtnzs9mN+0kAOo3AnFF+UwFifTMxzSABRiDaAkrl4SThKl1vnjG7PJuY?=
 =?us-ascii?Q?x7RaoEB0uW8AtJHHZG78DXTawfbf/YRKlEx5nWTh33lmj5cGOW425o17W0KJ?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2bc16e-50a7-4ff8-8bad-08dab7a89451
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:49.9294 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJoBroIVgdD5T03wC8sxLC17lMWvFHfnHr/3V0Qo9qxgIDfUFB2YVz8K/2YBaBkihmA3AS/eolz2iGK6iWc5JaN1lW+9oJSbmIKJkA+PqCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: 5850Py0goKJrFpY5EJ4AUfGNkslRckI_
X-Proofpoint-ORIG-GUID: 5850Py0goKJrFpY5EJ4AUfGNkslRckI_
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 01/19] block: Add PR callouts for read keys
 and reservation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add callouts for reading keys and reservations. This allows LIO to support
the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
to optimize it's error handling so it can check if it's getting an error
because there's an existing reservation or if we need to retry different
paths.

Note: This only initially adds the struct definitions in the kernel as I'm
not sure if we wanted to export the interface to userspace yet. read_keys
and read_reservation are exactly what dm-multipath and LIO need, but for a
userspace interface we may want something like SCSI's READ_FULL_STATUS and
NVMe's report reservation commands. Those are overkill for dm/LIO and
READ_FULL_STATUS is sometimes broken for SCSI devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/pr.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/pr.h b/include/linux/pr.h
index 94ceec713afe..55c9ab7a202b 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,6 +4,18 @@
 
 #include <uapi/linux/pr.h>
 
+struct pr_keys {
+	u32	generation;
+	u32	num_keys;
+	u64	keys[];
+};
+
+struct pr_held_reservation {
+	u64		key;
+	u32		generation;
+	enum pr_type	type;
+};
+
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
@@ -14,6 +26,18 @@ struct pr_ops {
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
 			enum pr_type type, bool abort);
 	int (*pr_clear)(struct block_device *bdev, u64 key);
+	/*
+	 * pr_read_keys - Read the registered keys and return them in the
+	 * pr_keys->keys array. The keys array will have been allocated at the
+	 * end of the pr_keys struct and is keys_len bytes. If there are more
+	 * keys than can fit in the array, success will still be returned and
+	 * pr_keys->num_keys will reflect the total number of keys the device
+	 * contains, so the caller can retry with a larger array.
+	 */
+	int (*pr_read_keys)(struct block_device *bdev,
+			struct pr_keys *keys_info, u32 keys_len);
+	int (*pr_read_reservation)(struct block_device *bdev,
+			struct pr_held_reservation *rsv);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

