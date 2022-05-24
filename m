Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985B8C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 12:25:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-8vYLkbC8Olex-6g0Fk0tkg-1; Tue, 24 May 2022 08:25:25 -0400
X-MC-Unique: 8vYLkbC8Olex-6g0Fk0tkg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AE24811E76;
	Tue, 24 May 2022 12:25:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C061C27E8A;
	Tue, 24 May 2022 12:25:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0CAA9194E102;
	Tue, 24 May 2022 12:25:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D9FD194E101
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 12:25:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D2BAFC27E8F; Tue, 24 May 2022 12:25:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE764C27E8A
 for <dm-devel@redhat.com>; Tue, 24 May 2022 12:25:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3AAC2999B22
 for <dm-devel@redhat.com>; Tue, 24 May 2022 12:25:19 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60069.outbound.protection.outlook.com [40.107.6.69]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-2hqvPbuzPBC02Fru-75dMA-1; Tue, 24 May 2022 08:25:18 -0400
X-MC-Unique: 2hqvPbuzPBC02Fru-75dMA-1
Received: from VI1PR0602MB3629.eurprd06.prod.outlook.com (2603:10a6:803:5::20)
 by AM0PR06MB5635.eurprd06.prod.outlook.com (2603:10a6:208:118::31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Tue, 24 May
 2022 12:25:15 +0000
Received: from VI1PR0602MB3629.eurprd06.prod.outlook.com
 ([fe80::b571:4513:8033:9c56]) by VI1PR0602MB3629.eurprd06.prod.outlook.com
 ([fe80::b571:4513:8033:9c56%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 12:25:15 +0000
From: Tomas Melin <tomas.melin@vaisala.com>
To: dm-devel@redhat.com
Date: Tue, 24 May 2022 15:23:46 +0300
Message-ID: <20220524122346.126308-1-tomas.melin@vaisala.com>
X-ClientProxiedBy: GV3P280CA0056.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::10) To VI1PR0602MB3629.eurprd06.prod.outlook.com
 (2603:10a6:803:5::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f190a714-7d18-4814-d25b-08da3d8074a2
X-MS-TrafficTypeDiagnostic: AM0PR06MB5635:EE_
X-Microsoft-Antispam-PRVS: <AM0PR06MB5635B606ED37915A94E4CBA9FDD79@AM0PR06MB5635.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ihjK1Dxp+ndO83GRmPbyEuunGwnK9v3p3dJiXrqEyMzK4FSEHQ8EaLpcN4TI8c3CCCFuCQMvb9+UwVWztbfqt5aW2T1mWr951dvOZlMxeQ4hMoLE3BsFCFtv98rXtiS+DuvUyqpFksCnoo6HYhnsmC05jC2ZuQ1iP/j7CjlbStxcmxgVpsMLJ3j74PFWUbLSSmMqsGkpUatv2PxZiRxEJbM5+FfO8Yisg4wf4auLvsdj0+yaVt5Eu46BECbNWj2aEzZyr7r0VXg5ICV49LGkR71UjCh3+8HHU+EosSnBtPRWW8/2MY3CJJlVme0UteCpID8VeBwK6TICzg5IyrFplT6wFtyFgIrbXoABHJr1TejvG1D8pWQ57UJ6nNj7+A1WDWqQCTwZBSKvxTJmhdkxS4VrxDjKFvCgV9T3W6j47pYtSAqPLGqk2mIfH3acO9BMcYLJmaQ3SuXpof4F1pybHnuJ2gDhJFZNUxenzxqJ7fdIsLqLysCdAWLPq2TmcHt3dE23IyiCRP+7E8yqII9nuD9sJTlTw6aTBgLHy5C9r5RGvevKJsfTk2pAZ+98DqP4RHnXfTzthaVWnZzPkmV8qoy4gmh8qXrEJywj/v76ZvZ1Mmwde0z3z/VVbqGIka6zeu8hHH4VRM7I8v0aEU3Fiv9zVSy5nLitgk4zZjThuoUDdqifyjTXc7W2tyfcIep9rJhYzowcCSJg+87c94V4Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR0602MB3629.eurprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(186003)(1076003)(36756003)(44832011)(26005)(107886003)(2616005)(8936002)(5660300002)(2906002)(83380400001)(316002)(86362001)(6512007)(6506007)(6486002)(508600001)(6666004)(38100700002)(38350700002)(8676002)(4326008)(66556008)(66476007)(66946007)(54906003)(6916009)(52116002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?08hBQWYQdeWlv7VJpA6b42Z65WdBfQujpWv43Bif2bJVedRgXQuPIkal+6iH?=
 =?us-ascii?Q?ndkac9BRbmzVy/25qrXg7yK8Sm0wVcv25LxARBU6mMglrkjdgb6aWauDwKpL?=
 =?us-ascii?Q?H6HwVWMHbX2DV7mAz2BW9bawy9KPAmfaUty4tXIiYO0NCP9amp3sZ4JJ29aU?=
 =?us-ascii?Q?KaTg3YGPLMy+SzeKk1EFqSGiU6GGJAigSSeMh2xCoe6IH+6AVNaj8n3D+2G2?=
 =?us-ascii?Q?/z1r+hldhyciz4UJMKOP0ql9zBwv7ZH/YBAokQDI9kLuG/M4m0mCSVOrJzPu?=
 =?us-ascii?Q?5s8QICdEUut9ANjs+gJxJGIj76uIOrg5pQcPgVm62NOjoVLq93n8XzbvC+8d?=
 =?us-ascii?Q?v+WxfPEXKnrvu8llV7WmMPyu83JiHVrmz3n29CdNZBBrWzmNaVtYWo1jbopp?=
 =?us-ascii?Q?8znn/+uw9RlPpX6+LxduUCO4QF2l8+TVcKSczMn/FQmPs54X6Bf4d0+Gefxa?=
 =?us-ascii?Q?36Gmvc1Kg1leWwkJuI3KAQ0XGI/ECCajhnHdNJWo47KuzKTqRdV04je6X7tc?=
 =?us-ascii?Q?paNiEfpe+RsKbs94WbtxsNJxthX8tRcLi811UHGc9PcCHbPzC7ajFTjyZg1c?=
 =?us-ascii?Q?syQMLWg8Md7bmE6YtPQHOf8PxKaAn37RTzvWbQwLl0V4D24mVHPZDrobO/Qn?=
 =?us-ascii?Q?N1DCL6WPXxQQ49bwHOELojaXaGb9Yun0MGgXCU2FB6+MTpBqeUiS6p9xNqVn?=
 =?us-ascii?Q?v8AXJ0XCdQlMHBMK0ro1HE71ddWrwX3Ff2H+2lZc1SPLS/nFSXIofE9teKDO?=
 =?us-ascii?Q?X28pJkkq7duO3nzdXAvlnAMAyouWbGiPc1qkNEJTl3qjisHY7BpgkVvARptM?=
 =?us-ascii?Q?LV1bsIey/lSAhleuYLGH3nistpZUwrfV0HVZWsl4m1dJ4W2huX1iAgjGCYOp?=
 =?us-ascii?Q?S9EFNlAQY8lxLvtsdSIg1+sV4/gwAfgjvKb2ajX+nhc+Eyedrpxw5LGId0kN?=
 =?us-ascii?Q?mVfw9wePJB5qEdxG/gOjPy92p/1p4JhO6l0jNgNiQwnH/IUYlvWZMtx+ZdTy?=
 =?us-ascii?Q?s8+Ti27MWBD3wjoEJOxA3vCS5cObWwcsV/BCwAKj35wGTM7YtviH9F9yYmdo?=
 =?us-ascii?Q?E7PPKyajRYShALLuHcF6mKbpARXrCa6HhcwSzLgKCu/t55JNkH8dcCciblhi?=
 =?us-ascii?Q?YYjlCm+CDU+Ltcsa9Q9XVGtKIWHM/daTdJ5J6/mBBQ/q6GzyjvO1Ov8lsKS4?=
 =?us-ascii?Q?ZxH2/dwBtje9bDWmCEppELx/Bbw0F6R2Orrn0eRFlpCJL3ABwuOyFyXtwIWl?=
 =?us-ascii?Q?8Fmn89AhvIclhWGxAxBlrA38W+Ov4nw3RLDKhm05VGGF/r7ierfGFM6hwF/q?=
 =?us-ascii?Q?wUHu7oU6pkBfF/3MLf6lQTHhtrppVv6nNNnZW9Oj+4KM9cqvoVQEmHRthAEr?=
 =?us-ascii?Q?fZJcKKu6ayj9pAj3jn/AjqqYj1hz0Bim9Upj8OnWxb09yGqjmBBNd0Ae/+73?=
 =?us-ascii?Q?V2vX8/gkssE6sAGPkxI1hGbA+/sj8c0GXSO9R5Wv3v1ZLyxkPfqjaosqZUE6?=
 =?us-ascii?Q?dtZeSZmoeXMy9Za46so1PVU+tfWAN17ms583z/PZxHY0LbGkjw6S8jo0dS4Z?=
 =?us-ascii?Q?/gT1R7YvMsjLJLc3vKQV6hCJVPzwA7rSDuwDrvtRhUbxkZBB0avjKd/kLH1E?=
 =?us-ascii?Q?JIctj+q7iOPyTgzggcWu9vvvrwxuLgHpbVxZcAYaI7gzNU7aJr3GOZsuHpKP?=
 =?us-ascii?Q?0T2N1oA/+I3HBnTIG39GQ3+Ucwlgh9U+YeweAGAG2whqQHg3AonTVgxjHvi8?=
 =?us-ascii?Q?/Kw8+eCAWJ72O8KzG+TmZ8GOM+4cZHc=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f190a714-7d18-4814-d25b-08da3d8074a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0602MB3629.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 12:25:15.0313 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5upOfEItiMJXjFs/xtcJ6Y+sZ2j4GryXOZDclV/CwrYeDABL05CCVo5uNQI9k4rcO9YLP5NnwB5DJ0uRfiEniQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB5635
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH] device-mapper: fix race with async mmc
 initialization
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
Cc: Tomas Melin <tomas.melin@vaisala.com>,
 Tuomas Pennanen <tuomas.pennanen@vaisala.com>, snitzer@kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Tuomas Pennanen <tuomas.pennanen@vaisala.com>

Device mapper may fail to find mmc device during boot due to the probing
time needed to initialize certain emmc chips.

Probing of the emmc chip happens asynchronously related to
initialization of the device mapper targets, for example dm-verity, and
it may happen that device mapper may try to get the underlying device
before it's available.

Fix the race by introducing a wait loop to the device mapper, which is
similar to how rootfs mount is done, when "rootwait" kernel parameter is
being used.

Signed-off-by: Tuomas Pennanen <tuomas.pennanen@vaisala.com>
Tested-by: Tomas Melin <tomas.melin@vaisala.com>
---
 drivers/md/dm-table.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a37c7b763643..26c5f4d8a977 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -22,6 +22,7 @@
 #include <linux/blk-mq.h>
 #include <linux/mount.h>
 #include <linux/dax.h>
+#include <linux/async.h>
 
 #define DM_MSG_PREFIX "table"
 
@@ -349,6 +350,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 	int r;
 	dev_t dev;
 	unsigned int major, minor;
+	unsigned long timeout;
 	char dummy;
 	struct dm_dev_internal *dd;
 	struct dm_table *t = ti->table;
@@ -362,8 +364,16 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			return -EOVERFLOW;
 	} else {
 		dev = dm_get_dev_t(path);
-		if (!dev)
-			return -ENODEV;
+		/* wait for any asynchronous scanning to complete */
+		if (!dev) {
+			DMINFO("Waiting for device %s...", path);
+			timeout = jiffies + (60 * HZ);
+			while (!dev && time_before(jiffies, timeout)) {
+				msleep(5);
+				dev = dm_get_dev_t(path);
+			}
+			async_synchronize_full();
+		}
 	}
 
 	dd = find_device(&t->devices, dev);
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

