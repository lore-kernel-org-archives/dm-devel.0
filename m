Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F940C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 21:12:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-dBI4zo27N4S4ZA7V5wkeLg-1; Wed, 26 Jan 2022 16:12:12 -0500
X-MC-Unique: dBI4zo27N4S4ZA7V5wkeLg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A92B46860;
	Wed, 26 Jan 2022 21:12:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63BF1E2F0;
	Wed, 26 Jan 2022 21:12:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C6C61809CB9;
	Wed, 26 Jan 2022 21:12:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QLC3Js025997 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 16:12:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4C98140CFD35; Wed, 26 Jan 2022 21:12:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4798440CFD04
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D4A285A5AA
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 21:12:03 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-122-90-X5X36P5-UPk7tS2YQ9g-1; Wed, 26 Jan 2022 16:11:59 -0500
X-MC-Unique: 90-X5X36P5-UPk7tS2YQ9g-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20QKYohX016830; Wed, 26 Jan 2022 21:11:47 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dsy9s77su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:11:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20QL6Ue9020718;
	Wed, 26 Jan 2022 21:11:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by userp3020.oracle.com with ESMTP id 3drbcrx866-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jan 2022 21:11:45 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by DM8PR10MB5494.namprd10.prod.outlook.com (2603:10b6:8:21::5) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4909.10; Wed, 26 Jan 2022 21:11:43 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%4]) with mapi id 15.20.4909.019;
	Wed, 26 Jan 2022 21:11:43 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 26 Jan 2022 14:11:12 -0700
Message-Id: <20220126211116.860012-4-jane.chu@oracle.com>
In-Reply-To: <20220126211116.860012-1-jane.chu@oracle.com>
References: <20220126211116.860012-1-jane.chu@oracle.com>
X-ClientProxiedBy: SA9PR13CA0112.namprd13.prod.outlook.com
	(2603:10b6:806:24::27) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9654b01-5e64-4be3-8a6d-08d9e110743b
X-MS-TrafficTypeDiagnostic: DM8PR10MB5494:EE_
X-Microsoft-Antispam-PRVS: <DM8PR10MB54945C7B2533B1575623097AF3209@DM8PR10MB5494.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: /7u2fgOv1cQvtFOAc6HvFJ0dR4eZ1ubczcLWLyvILeLj30bsdR3tfiDKP48hygVXcfQYO/UpoZgG8qUDMTIOszFmSbocWaIWFwl6gGmm7EzdcCIMKiTq5tn9mMiZwlD/Wi2vBRJkR2OYW6/w0G+dc5J2oJ7qoIBUcuNKYzvnz7AvCiSpQTjdBkz6uts5kCbbwtzNM9mpn/nCmY4Bzh3J64vatJT6T8AJoPNJ7LBpCSJSjVpqUZpGrbN2SLAuaCusn/yPhs17Pf7ribB2bymNzayHASU7fErHqQp/tmQxtl5BMfxWVTgDqbBFGdicFuGW8xfs7ubFQK6l2xEMqLwhdBunUrq+IFO/JfYr/TgollWT9j2x7JUJ6AMrHu6uBl9LRZx/Wbr/xO7hf7XCY5+34DZASmOy30OyCskOFACIgipiKty2k6wlblqLmu6D9+ChxH8TCPfCjCimoqDMC3XaK4tEQ2qLS8on2xLD/oHuzgqtvfMKYmuHfhYR4M9dMIsKUdjckdKPvlP9ZiMoxnR5uIuBX0p8rFWxJVfvnxzdgWuuCxfNVbTL7nffKimF0m/MpICHnTXjtChRHCVe/pwBw24QEMSCdysuxwGF2h15N4b4n5OEMpgV/9Sz9hnzFL2KnhJNf8EyTvP468YCn/Jn+XpNmcafJZXb7YxR5k2xtFml0158/AU8/vYR/mOOVfDa
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66946007)(52116002)(86362001)(186003)(8676002)(6666004)(7416002)(6486002)(1076003)(8936002)(921005)(508600001)(6512007)(66476007)(2906002)(6506007)(83380400001)(2616005)(5660300002)(66556008)(36756003)(44832011)(316002)(38100700002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kiMUGc1gJAUG7UuqQvNVUZCiT/0DH4w8QiRT71EW93ofFogfYhugOu/ppMXA?=
	=?us-ascii?Q?1uypfQF2pH0WrNsm4GaRzlJA6wAQdWnPX6Du7t2UiuZWydYehkLaMgWy6Zvm?=
	=?us-ascii?Q?fY7fWdGvLx8kGit6jcQ3yn77Kp7Y961774byFWxta+Khb5xpFkSiDGFiGIky?=
	=?us-ascii?Q?3n5QiuqEkJGc/p+1znKfWjCgbJCOVW6AkCeb0RI4ra5PFg9rOHX4KqLMpBbu?=
	=?us-ascii?Q?sI0Uz/1pakYm6rVZn9nzEPm6Qxo1lojLYc091JaI2ZhQRsMLyaC5O4JwbfUZ?=
	=?us-ascii?Q?UURRpIW672ENMQObqhWZnDuSXegVxq3xZigaKnMcguOUsc0vaOq43DwQa9aQ?=
	=?us-ascii?Q?MO513J13sKGu6PI7/eGb/GFpU48U5lr2FpFsZyHWSMVe2R+BydWZ4hDGaKc1?=
	=?us-ascii?Q?C2JeGYbvIZEjraWLq+b7Ff/NLhQcHsy4kBhJHxUtyHXrits68gSmmg6ez6Bx?=
	=?us-ascii?Q?BKUkEi7m0tVe3FYtUr/6tfc7EF2vEIM+07u1CNueAZEksi60aB5I5XVgJuJv?=
	=?us-ascii?Q?4iaM9HrjXig5lb6tQgmgyJyL3onNmXGe1ejuGBaiwal/0k+a6qIc1xyt+T/r?=
	=?us-ascii?Q?kes1IwkUcuTpOsbOfzIv9N3u2WensOxbIfQ7Jmq/wpaOUHmNsKRaQqJMxBcX?=
	=?us-ascii?Q?1nKnFAKkTCuWaMnNuiJAK4rpS7fg7Hr+2+pjzigH/8TCctKvT8SCkJnDPDHo?=
	=?us-ascii?Q?n9fK6A2STuhEaZaRdTvYQFkJOOgsnExdPAVrHSSFl+Hstnfn+Ly3bsI54+KG?=
	=?us-ascii?Q?JEigIQIr+PumhHGCE/8uwCynJj0NCgGZdgw4086jeWnXa93HOQoN9cpK3dL3?=
	=?us-ascii?Q?5vdh6nNI/0twWywJ37Xy5gA5hrLunbTrGeJ172YZM2qTxqTi7oE6lxLss9C+?=
	=?us-ascii?Q?kpG902U6UhMrXEuoPVv2zeLL9t9Haa6nV7A+Vxrl3zvIwOjrYvC775jmkGjq?=
	=?us-ascii?Q?KwwD0O4c7aFgSwlLk5WN9oDsNYIIIOvLh54glGckhy6SC5RZLubRvYYzHiWx?=
	=?us-ascii?Q?vOgSYcnbF3UswuhvrkHZqxnuV+VLLVXNv7koJrqpJlb0DNipo2d1aZShtrhI?=
	=?us-ascii?Q?nv/sk4OlcQYTsVWSC8PRQfo1ya2SEzc1gbGJke0EHpJzFt2B/QLqSJI2dP1T?=
	=?us-ascii?Q?Zdc9u8wbRj42Jq9cQOBxh2gukJ1ypgeblKvMl3JJkxiZt0Hj+gFBzx+1BOOC?=
	=?us-ascii?Q?+7q6jlGSDdUXpclROlh9KeIlmYYGU1g1zdbytsYj5IKwpAXwWfSB8Eigs9Xk?=
	=?us-ascii?Q?tw+gie8ERJTg6sgGlnCecKPUF94H0V39JdJzJ3/vyjmo2llz1q7fQalf3PXF?=
	=?us-ascii?Q?dfRqjH7LqiPDg5eGCgRisQMzG6ZVmUjnELTbw5ClXOnlIqMVdZPsRwT8L9z1?=
	=?us-ascii?Q?iiv4HfzBRxCjRA3mpUMbBzTCYdkYb3wbh+2ggre8/pBHQiItYLXe1uZnT7QF?=
	=?us-ascii?Q?SwBhCSgLN6YSYUnEpG+bVYaY6edY2tmMFZK8mhFjRZw2WH6JQR70jCjiiSrG?=
	=?us-ascii?Q?u9e/g27JC0lWTFmNwJVs+PReoP1BOUkBxD2Y/MUwkinjeAoGIXV6FE8JnRzK?=
	=?us-ascii?Q?rnaD+GFmw6ldTtbgA1UaH3mF44grqU6iquY+IWmcju1fxors6PdWzP9oDBnr?=
	=?us-ascii?Q?0wre7espXb399Q0irtqIgRtbjejnzUCEgYl5kYG8av4b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9654b01-5e64-4be3-8a6d-08d9e110743b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 21:11:43.6983 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hvojK836zXGyQAPtezFli5M3b2hIH3YppIAEVg6THJVtvlZGWNT5+8F6sHIPmLp27SezcF5z9Xu1Icwe8D1Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5494
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	mlxscore=0 malwarescore=0
	spamscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201260122
X-Proofpoint-GUID: Lzl3h92bUsjBcfqz76wYdVNlh0HHa5Ii
X-Proofpoint-ORIG-GUID: Lzl3h92bUsjBcfqz76wYdVNlh0HHa5Ii
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v4 3/7] dm: make dm aware of target's
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

