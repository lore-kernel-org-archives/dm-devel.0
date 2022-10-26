Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A883FA3747
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198331;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4bsqtXoBDjipSXEMfymYx5BhLz0p6PabkGeX3G1ZAsA=;
	b=ER41+PXQRtUjc8OBFNeIZEvtdmnPANhG/cPnUHgK6JxBmO7DMr6ksyEZWVFoxVGDqAUNqB
	gE3rOXZ+irhY83SZBzTrx1dqtsnowaen1k8Jf7ECeCZ874otrbc0A/B9uaeFh+I0UAm4pi
	yuFp2/AWrGvIcqGz9u4VWIJJmOko/hE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-I5v1vUE8OMWpN8fqBeP1Jw-1; Mon, 31 Oct 2022 02:38:48 -0400
X-MC-Unique: I5v1vUE8OMWpN8fqBeP1Jw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 917DE857FAC;
	Mon, 31 Oct 2022 06:38:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9983D2166B2A;
	Mon, 31 Oct 2022 06:38:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A77841946A47;
	Mon, 31 Oct 2022 06:38:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8A971946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Oct 2022 23:22:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC7602024CC5; Wed, 26 Oct 2022 23:22:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C40AA2024CB7
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3A61185A78F
 for <dm-devel@redhat.com>; Wed, 26 Oct 2022 23:22:41 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-CgkP7eAeN7Snq3SH7aKRHg-1; Wed, 26 Oct 2022 19:22:39 -0400
X-MC-Unique: CgkP7eAeN7Snq3SH7aKRHg-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLFsOa022260;
 Wed, 26 Oct 2022 23:20:07 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n8e-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:06 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 29QM46QW009475; Wed, 26 Oct 2022 23:20:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kfagedtfg-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 26 Oct 2022 23:20:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:20:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:04 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Wed, 26 Oct 2022 18:19:37 -0500
Message-Id: <20221026231945.6609-12-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:610:e5::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 90901428-e77f-41d4-5b99-08dab7a89cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: F68MeDvrbOutrXL/YTidPwv93FYlas9JOqIZyDKiMKATf/q3rlY4oF0EaCnYfIvHFN3d+uGb168V+xiwu0zCKB6cYfYQEMsXvzN4dnxshQSex5S5ZfFZ0OTghk/JXzFa8w7sRDuV60/NwpXi8X2O7c3GoGdLIzCv7/mXnWrgk2Mg4zl1hplyVRBixcUTtWdV6zJRfVfz9yHbrCNmCWlKZ/PlKXTvwdN/i16CMEgzjcyuYsbo/q8j+n9zn7NP9tPWuzYy1aT5QSlf4rGPTIIQtemq6BccG5EMcUxlspjB+MI2+vZxjWgEc6ix0W3TcqHPM8U8M50hg3lPMDXPqP5QYKimSqv5zzugGbFeJlkGmu5w2iNh+vpVsvxBxdHX5l9sjIvTjokzrWmxchcnoyIqeh19z0gTl497C+QKaPx2WSPQZRa3NI8dPLDSAFIOnMa8TIJSD/k2aSSKdWmSGU9ONwDEJkqeNtqG966lWneL+0T0YlAgAuWQQr09Cp05B6xKF1WTABdeCifSzqC6qwU8RFgVu17K6oVtN+2USn8lKIxlOO/Yz9zQpnBXgiIQ7jlb5SGSou7Pq8zbHPN1aqpSSNR0chUgFTGZ7KGG0HHD7NmWHfSouGBx8vbWBr4m0SgbygT9oMZzOtXWl7vX7kjFx6TgEW1IXxGymti8DeqFA+v2ZO/Y6igTQiVJqgbwEfVAlPtsRh7XvX+Geei+5MEGorbPnXW47reroUjYuSntUQW7HTC9Y6+ROTDOBNKb0Vwi
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ko6haSxRTBrC9n3+OIgG4pLzkQYAGFFX5A13UxafLGmIJ69KhnBjWkrix8YW?=
 =?us-ascii?Q?gSBMwk7UXIPH4Z8NtBXX0ukmD4ypRtxA7qOoxnwGVzvuiPOaQJe39f+YnfIe?=
 =?us-ascii?Q?grYHpa9ZDJL/J/+/L/7kXEJVgO8eMzio0iXP0rr/F/k27OtmcWRFf0o7fZiN?=
 =?us-ascii?Q?wLrX6mmQF9CRTI8OiGY62z+twdmFQykAOgZ+MQx2Zrb2aOyq7YOXaQ6eufdb?=
 =?us-ascii?Q?7vonC6RZFk5OT7ieNDZuzOLgm0uc6ZPexaoC1ljRuQ3/gOTKcKHrDYxFvrkQ?=
 =?us-ascii?Q?3+aJIF8QYxOqVaWfE4/XGGnzXl2Uvgl36W/F6GK1nt6puGxrr/IYZ5NQibA/?=
 =?us-ascii?Q?grGAzZOBd3o7f7g8pSVi5nCbsr8pyr2V8OsHnzI71BSZFXs4Qv6LhtOF3J0J?=
 =?us-ascii?Q?6xCHKTm1ajUCNHzLuTqAzrpIW4C5yzvAoWlykwN5ZYrMGIUyKPl5zemX0/Wy?=
 =?us-ascii?Q?YmQKvRMEy7Z0ABY4d0rgb8vsKwUsIdRom2Dpxpq+oKioijethT6TuzeHFGYc?=
 =?us-ascii?Q?Sl9RRZu60NROb3lyFXzrZo0rExs2zB8FWzc68776fSYhddVkB/d1UWP2zbAE?=
 =?us-ascii?Q?fTJumSYiMCUK4Mihvqm+8wDl4qUD/F1FvMT57OiF2eTCWMK/2vmKziFixGqy?=
 =?us-ascii?Q?fxEJcc1xGEg1Kq9ILV+d36krqbFvKp5SzBNgo6iiNSxRCOGl0z5EadbM+s/d?=
 =?us-ascii?Q?iJNI7a3uDK/nB4kkXt2Vg8cXBnbxfsSa/RpSRyjw6abp9lBnodrT0KZeNmew?=
 =?us-ascii?Q?ed3W18bkBpK9EleovW74go8PBauPAEER2PhCyQI3XbgYiVgXmx5n6hMHhEBF?=
 =?us-ascii?Q?RzW2U9Wj1vOwP3tfhXjghVtGS6SvB5UIq6Y2zVWS3ubAqIJmLmwQ9Wl/klwe?=
 =?us-ascii?Q?wza0fBsz1YrGnonx4R0Opqt1DxtOx0qCjy81zS0+Q33JX6pOJd9O4Hoaw0YW?=
 =?us-ascii?Q?9BGIP0qpv9eg33ePzi+eoB/UTchxnUNioAOZCvsD3ZiGvjb2ugywtFnQ5hMI?=
 =?us-ascii?Q?6HChhlPaGB/6pipUgy7Li+I1QP6sAkkpUEEhRo1gETFApEkNPhN15o7HKb9A?=
 =?us-ascii?Q?IvEzGzba4TYnWb8WolUqqDDvNudu30Uh/vjHAcdb8FGxztYIYPIBXJDqdCfz?=
 =?us-ascii?Q?25miHG7+1jyrzr8sRGTpNVgehhgzLEcwZ10mtpEtQpCM+gReWdYgDeNEosgC?=
 =?us-ascii?Q?YVREXjAyibeb0MTgakOsK3BJkmN0+eGHsM0eTSSlZBrgFwftUJE5VTnBn9XG?=
 =?us-ascii?Q?XEm4fTqJ88EgS/M7emNbhqRI4VnWoYXPW79UHc3RIF9x5LA2kysCzfQGB8v2?=
 =?us-ascii?Q?zJqwxO7keVlUy3xML9EKxtd37Movf1g/B2kEacCrp32m16VP/TqsV856NSSn?=
 =?us-ascii?Q?ig+yfIqN1iHP67ahfKUYaoDWMFeFyvarH3KEAOuulVURIIpHzwIoeVuN2Pox?=
 =?us-ascii?Q?5I10VUz+rX8AeAoeuNcTcvqEeFx5hZKgB5IdJTIm6pZ4n6PCWU5fgE7NnDPZ?=
 =?us-ascii?Q?QPkeoJeGETsYN9Weo7bSmj1uQg6YE0yX77dAliQLyZXqrk12u6zegeZdOZWD?=
 =?us-ascii?Q?/WstmHHoxjNgBs/RYEb4qwPXXnr+DQSzmTlzF9R8i0+WKYuvsJ7xOEAaJCHt?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90901428-e77f-41d4-5b99-08dab7a89cec
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:04.3033 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IaRw7gk1IryZANayDbwEVn3hSDe6N4U/CBZvnGbYManLLjaiyHortr4uIqSVVqjVUVgH5vZvXlK/5DK5xaL5WJpfVo+tVrWhMiZGBdjh7lU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: _K14-oyEsiM4ZPOdDZQ633md61V3N2y0
X-Proofpoint-ORIG-GUID: _K14-oyEsiM4ZPOdDZQ633md61V3N2y0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v3 11/19] nvme: Add pr_ops read_reservation
 support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds support for the pr_ops read_reservation callout by
calling the NVMe Reservation Report helper. It then parses that info to
detect if there is a reservation and if there is then convert the
returned info to a pr_ops pr_held_reservation struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 79 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 5c4611d15d9c..87a0aaf811f4 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -30,6 +30,18 @@ static enum nvme_pr_type nvme_pr_type_from_blk(enum pr_type type)
 	return 0;
 }
 
+static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nvme_pr_types); i++) {
+		if (nvme_pr_types[i].nvme_type == type)
+			return nvme_pr_types[i].blk_type;
+	}
+
+	return 0;
+}
+
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 		struct nvme_command *c, u8 *data, unsigned int data_len)
 {
@@ -194,6 +206,72 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
+static int nvme_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_reservation_status tmp_status, *status;
+	int ret, i, num_regs;
+	u32 data_len;
+	bool eds;
+	u8 *data;
+
+	memset(resv, 0, sizeof(*resv));
+retry:
+	/*
+	 * Get the number of registrations so we know how big to allocate
+	 * the response buffer.
+	 */
+	ret = nvme_pr_resv_report(bdev, (u8 *)&tmp_status, sizeof(tmp_status),
+				  &eds);
+	if (ret)
+		return 0;
+
+	num_regs = get_unaligned_le16(&tmp_status.regctl);
+	if (!num_regs) {
+		resv->generation = le32_to_cpu(tmp_status.gen);
+		return 0;
+	}
+
+	data_len = sizeof(*status) +
+			num_regs * sizeof(struct nvme_registered_ctrl_ext);
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	if (ret)
+		goto free_data;
+	status = (struct nvme_reservation_status *)data;
+
+	if (num_regs != get_unaligned_le16(&status->regctl)) {
+		kfree(data);
+		goto retry;
+	}
+
+	resv->generation = le32_to_cpu(status->gen);
+	resv->type = block_pr_type_from_nvme(status->rtype);
+
+	for (i = 0; i < num_regs; i++) {
+		if (eds) {
+			if (status->regctl_eds[i].rcsts) {
+				resv->key =
+					le64_to_cpu(status->regctl_eds[i].rkey);
+				break;
+			}
+		} else {
+			if (status->regctl_ds[i].rcsts) {
+				resv->key =
+					le64_to_cpu(status->regctl_ds[i].rkey);
+				break;
+			}
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
@@ -201,4 +279,5 @@ const struct pr_ops nvme_pr_ops = {
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
 	.pr_read_keys	= nvme_pr_read_keys,
+	.pr_read_reservation = nvme_pr_read_reservation,
 };
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

