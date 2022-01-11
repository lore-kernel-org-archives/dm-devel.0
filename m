Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41CAAC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 20:57:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-VGi__38lOQWPg9Qv1TKbeA-1; Tue, 11 Jan 2022 15:57:07 -0500
X-MC-Unique: VGi__38lOQWPg9Qv1TKbeA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5BD164141;
	Tue, 11 Jan 2022 20:57:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20B5056F73;
	Tue, 11 Jan 2022 20:57:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 806B11809CB8;
	Tue, 11 Jan 2022 20:57:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20BKuxtN023508 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 15:56:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6047C1410F39; Tue, 11 Jan 2022 20:56:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B3BC1410F38
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 20:56:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D3D11064C75
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 20:56:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-199-cuB5Oxu7Pr67JjncKWC6Vw-1; Tue, 11 Jan 2022 15:56:55 -0500
X-MC-Unique: cuB5Oxu7Pr67JjncKWC6Vw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20BI1guE032058; Tue, 11 Jan 2022 19:00:01 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dgkhx43bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jan 2022 19:00:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20BIpcbv110950;
	Tue, 11 Jan 2022 19:00:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by userp3020.oracle.com with ESMTP id 3df42n7d9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jan 2022 19:00:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3d7::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11;
	Tue, 11 Jan 2022 18:59:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::6814:f6c:b361:7071]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::6814:f6c:b361:7071%8]) with mapi id 15.20.4867.012;
	Tue, 11 Jan 2022 18:59:55 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Tue, 11 Jan 2022 11:59:26 -0700
Message-Id: <20220111185930.2601421-4-jane.chu@oracle.com>
In-Reply-To: <20220111185930.2601421-1-jane.chu@oracle.com>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
X-ClientProxiedBy: BY3PR04CA0005.namprd04.prod.outlook.com
	(2603:10b6:a03:217::10) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76ec3292-9b57-435b-fb2d-08d9d5348e02
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5647:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB56473B846789ABB7E9F30D30F3519@SJ0PR10MB5647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: nehgXv/AgvweR3kemRCqUP3R5JRhncYKtXgcW+cScD3gOwFBeGM6nJb37lT9mRGVUwILLoje3lApomZk+8UAlVgm91MteX2JYTozLnbw5y9+cyKl5l8WuZP7l+bizJSVgtTwrT0hZrem1IOWFqguwdevYtuVxmv6CVuP4ioRFBxyKQyd6ADMQKrxJEN81Wi/wD0wLbVbTqcmOJ8jNjLyOWkTYHrvAOZlZLx0p+7DifmrNp6+kxbipOgYbuo/WI5O1ntVMATNdpfUkCzfAVizfwTfm7tnMSf3BssShOiAp7fxfUAhZaEUu655zLzi/woQtNI/qegnL3L5hGN0F6Lcs7gdQ1edBwe+KlebKhPQyh07c16H6lC50/ZIM6tEX1ZC7wAFQ29BMn5X1nQlauy6Dz2buRFTLJm/oo5VL2doGttYzdbp8o1iSRN0gxeDjMkP0MPrWrXpLxrgSRmGLQMIdNYGNTvWdCllCmVYcY9N/aAHCbDpObZms0aWG59Mm6frn6TE9zi4z/WoZ729KETP1WBY++Xf3sUApXe70LQuMJO4tjS2LGsTS57P64tn/V6yUYsn2D2XNwHJNGvmUPWAeQnZ935BgMWA2aEQdJ8PjiKeX7HG/jcbdIXzC02bDO8NZDI9IoBjd5/usI99oTmRJio6HRPsnPdph+kxjKeb0OYCmRfwEvwYhZ6L9qAzRuxu
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(5660300002)(66476007)(508600001)(6512007)(44832011)(66556008)(66946007)(86362001)(83380400001)(1076003)(38100700002)(6486002)(36756003)(316002)(8936002)(6666004)(2616005)(921005)(7416002)(6506007)(2906002)(186003)(52116002)(8676002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JkP1HNOe7bx56TDfbEjiFQsDbDZ0hNnKORzize5DLgOD3xM6fSsLzq6zbCgm?=
	=?us-ascii?Q?F/UwJQGKgjtruKFscoKP19MWB3HfyVDbLwGt+OiOvbDszqy0rpiUQhSa7/1M?=
	=?us-ascii?Q?c0JozcmVxwJOAkLZzOAZSOE9V+Mz2oOn1FiERTE6eybfpyxtvoGYJG3UNnay?=
	=?us-ascii?Q?a9ekBMh88tkP7M44ed68cyIHMa7gMuHQ6ZHJo2jFwH1CKFsXSYNrOvKvKugW?=
	=?us-ascii?Q?f8dfDAt2fpqBqeeF1s6Ux6mLX/wzE9G9oCZLKbTRP50xhSMYckngUefqXNCw?=
	=?us-ascii?Q?RwyoFYsbMAptbDH16aditqNM8sRcNTvGXRp7qJjnO7ltBi9E81TLpvhxN4U7?=
	=?us-ascii?Q?fWtLFqm5O33gnz1mUqiZQOnWqmYCTE1vt0ky+UtHYD1pesv8wK/Xd6Gz58IP?=
	=?us-ascii?Q?DZNfCeypZ9ea7qRw/vpzx/rh/xz5ZLj87z6/HpSms4xS6btD1bEHb3IkNgLn?=
	=?us-ascii?Q?DgohgombLdVzKTBOxjG0DumIW94Kjh5/tItAuF7AHGi+rHNKxaC+LwThtEqP?=
	=?us-ascii?Q?S6vbkJrtw8Wyiwqz+Bhb2oN2lpMketLBuPe2L2ZZuqZcstuxBMLVd9ujkY01?=
	=?us-ascii?Q?ADcDFl7EJMEiwS+lax8sZYSgq6MY9loujwQ+YBak+ZlvZ3nGekBEHWrEz1vu?=
	=?us-ascii?Q?g8JBbjypYA3L/QW1XdatnJ9YPIZzJK2sF7vx6XRB7PpFuspLbP7vlh2fUyVR?=
	=?us-ascii?Q?yqqJCUro04seEHLYgn4ckGX1aiBBgOtUzXn48vL9rcStWg3gWHzeE5aP0rbu?=
	=?us-ascii?Q?QdfvkaOzLUe6eBcl/NqcBryjJrizLHDwaGKJSCYrXqL26w0jjJJR+0n7P4Uj?=
	=?us-ascii?Q?gRe+oAis5v8X2r0zsnBRvq8sw1HbFHPRUchfKVPXG+P0+labHtSQwmnV5UCG?=
	=?us-ascii?Q?NOgg8u9+BC6/KRciHzVospUlWmolq2OcfpVJpcLjTr9BH7zZxh325KjxGuQm?=
	=?us-ascii?Q?qZXR/69rwTzfYlKHgqy/wP+Kt+3zAPgE3oUqEgqTW4Ac5dxkSER7SyRd9I7L?=
	=?us-ascii?Q?a0/uxeI3JExGzwk8O4y9EWvvKYZ/yKSU9Xp1c6HuFurEcd7lUCXuZOUCDh1K?=
	=?us-ascii?Q?OkbFzREyJKdLouC+oFoDCdghzo9jDJG2zRDxqakXi9aaqq9kQhZRekkGCK2Z?=
	=?us-ascii?Q?RoQYJQ6WhjzQwyxjHGZt5fmNcNi9oZqp7l9BL/z4pobipCAhtaGMtKv86HKC?=
	=?us-ascii?Q?iVdcvqttLCqUBBAohyp1kLoqvHMA+UTjz/f4rRkTAJMT66bSE35T74RwaTD7?=
	=?us-ascii?Q?w3prdJ9Iw66mMyTXyoq4SRV0GGhUnT9TPJqSwOVaBnqyAPVQeGk/kw7Or5rQ?=
	=?us-ascii?Q?lsjf5rR4sa0Q3UklGClU/YfovioFSpAUZbTTlQMcFxqyF82D1mySVZVuFlql?=
	=?us-ascii?Q?UUNWDxjLWTL40S+DojaoIB/wAMxrBcXZ9HsiOwylxby24Noyfl4OMKLWNYPF?=
	=?us-ascii?Q?XILWWshe7S23yH41FSNO1Trdq8ofsZhpR8uBTDt0TTbwCR09k0ym++5MgU0i?=
	=?us-ascii?Q?I4/AJ7spdSoLC/Kvg3Qm/qfvnvXaoberKbmihAdcDhFvaJiBYLCuDoe6lV9k?=
	=?us-ascii?Q?OE3QHCBz8GxMZqG9WmPGykW6LrF9jLc0Bf8Dg9D/dphfidqPKJnxl6/Ge08u?=
	=?us-ascii?Q?iapSXx0HXWJXEsU9Q6KALtFD81BvQSDTPF9tbMxiOzHx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ec3292-9b57-435b-fb2d-08d9d5348e02
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 18:59:55.0009 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jf8n3MwflJ9cSgUycG/8ogNbn5WjJrnfF6heofqr4Pggt2DgfWESg2bH8oaqBT7HIp93/ZhExKjQgpFvICGuSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10224
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxscore=0 phishscore=0
	mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2201110101
X-Proofpoint-GUID: UurHFB4B-z4XiL92ZyMri78J8F3bMuYb
X-Proofpoint-ORIG-GUID: UurHFB4B-z4XiL92ZyMri78J8F3bMuYb
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v3 3/7] dm: make dm aware of target's
	DAXDEV_RECOVERY capability
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If one of the MD raid participating target dax device supports
DAXDEV_RECOVERY, then it'll be declared on the whole that the
MD device is capable of DAXDEV_RECOVERY.
And only when the recovery process reaches to the target driver,
it becomes deterministic whether a certain dax address range
maybe recovered, or not.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/md/dm-table.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e43096cfe9e2..8af8a81b6172 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -844,6 +844,36 @@ static bool dm_table_supports_dax(struct dm_table *t,
 	return true;
 }
 
+/* Check whether device is capable of dax poison recovery */
+static int device_poison_recovery_capable(struct dm_target *ti,
+	struct dm_dev *dev, sector_t start, sector_t len, void *data)
+{
+	if (!dev->dax_dev)
+		return false;
+	return dax_recovery_capable(dev->dax_dev);
+}
+
+static bool dm_table_supports_poison_recovery(struct dm_table *t,
+	iterate_devices_callout_fn func)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	/* Check if any DAX target supports poison recovery */
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->type->direct_access)
+			return false;
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, func, NULL))
+			return true;
+	}
+
+	return false;
+}
+
 static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
@@ -2014,6 +2044,9 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
 			set_dax_synchronous(t->md->dax_dev);
+		if (dm_table_supports_poison_recovery(t,
+					device_poison_recovery_capable))
+			set_dax_recovery(t->md->dax_dev);
 	}
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

