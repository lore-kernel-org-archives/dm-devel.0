Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17557C636CC
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 11:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675164193;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G4NfJUbqvUP9fCXVx6SB5B6DZqaKSTUsvhSAAvWiTrk=;
	b=VEmnhp0TGbpU9W+iEmYsdkP3WNOIlex+9qJ7QPE7hCeMlg7Je5n1k3MzbZnxeDDTKPdNkw
	tu2Hp2gv59+0cVDjKvl5M0PDb3wu6DgvX6zebPa7kRTMdgFp8lHmqmQZXoQpmX3b+kz4hk
	Ljy8YIsLLk9hD6J0fmLOo5HUHjbB0jc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-0CCRqg8yNF6vehPFyytiNQ-1; Tue, 31 Jan 2023 06:23:10 -0500
X-MC-Unique: 0CCRqg8yNF6vehPFyytiNQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 848308027F5;
	Tue, 31 Jan 2023 11:23:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B697492C3E;
	Tue, 31 Jan 2023 11:23:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C96A31946589;
	Tue, 31 Jan 2023 11:23:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DCF1D1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 11:22:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA88F4010D2A; Tue, 31 Jan 2023 11:22:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2433401531A
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 11:22:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8448485A5A3
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 11:22:19 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2056.outbound.protection.outlook.com [40.107.22.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-Wu330XO7P9aAjnhyk0VYeQ-1; Tue, 31 Jan 2023 06:22:09 -0500
X-MC-Unique: Wu330XO7P9aAjnhyk0VYeQ-1
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AM6PR06MB5016.eurprd06.prod.outlook.com (2603:10a6:20b:3f::30)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 11:22:07 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::751e:f5cc:76c:f6fb]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::751e:f5cc:76c:f6fb%7]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 11:22:06 +0000
From: Tomas Melin <tomas.melin@vaisala.com>
To: agk@redhat.com,
	snitzer@kernel.org
Date: Tue, 31 Jan 2023 13:15:52 +0200
Message-ID: <20230131111552.24349-1-tomas.melin@vaisala.com>
X-ClientProxiedBy: GVYP280CA0039.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::21) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0602MB3625:EE_|AM6PR06MB5016:EE_
X-MS-Office365-Filtering-Correlation-Id: 269881d1-c8a0-4169-8a7f-08db037d62be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: HZW4pQwSm61ammh3KTu5sj/vXBz0S6rW/QGYsBg3D3PYV6Xu3q+jIpeewsXIVS3dVRW2+GVD219/DYW/vlA8EKHwxQlc2Mcd3w6PJ4OaWkrNpP0QMAkVGyzn3PY7HERbvtOQOrf/2+uSV1A7nJHUG8ibp8cFEmPHQwENoyC9LZxsS2d+h9VWCoEIJf+k/nNmdy1tf0I07yXffmVWdH1ZWujMzNLzZeqsrFLTzt4sOaREvXGsEA2wrg4LcZxWtkft0vb/VnkQBEnyLgQqOGSHAlZAv9EcxALOdFfJDVEUNaoRX10VEXEJUCIkyzs8XnKQB1UskBibm563aDJ9nOiKvC6JyWZitnXuKvAjEx44Do2j2XvMXt0nr2mifKWdyQsE1MttFQuBQWV3/9HZYLUYjtcRc91lmMJGz2K3gx+yzbFObFxmx7lwafndkcaG4YRKxrLVMSON6OnaPH7SvZmVtQTXpERn1zKK08JbgFvKwIWvXWSvHSoKrCWYu/UUEWw1r9n2wj9qcWViI8JDIjvqqsn2x1u8SqL/vP9G7N6LKtc2ve+ZOPh22hvsoprrT/xPODfItqFYoeB5GKIEQO2VoJk1G0bFHZLZIuxHM2Qm7swoWOfGabb8d5xK1YWWHWc7mwpaRZRAiSxXqa0wlF9dK1wXEI7VdzGOD3fi/xJ3tBTSh79Qug/IUheWzhB23OvMc0UCaRdw3+YnWJ661eM8uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:HE1PR0602MB3625.eurprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199018)(83380400001)(316002)(41300700001)(8936002)(8676002)(4326008)(66556008)(66476007)(66946007)(6666004)(1076003)(107886003)(6506007)(6512007)(478600001)(186003)(26005)(2616005)(6486002)(52116002)(86362001)(36756003)(5660300002)(44832011)(2906002)(4744005)(38100700002)(38350700002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KWPzMgmVrgzh7IF8++O6B4w+/lsHaZ2qekgKnOHnOQDHJL6im9itmTG/uNHl?=
 =?us-ascii?Q?6kY+M9wHT6GaBeAtr0WkU/aKbCwcylMz0e5NguF8xBauXHTVt34r4GqXMNqf?=
 =?us-ascii?Q?44rUX4zmYubTXv6miT7+E02ohgjgA6yOuCv3PdrB7RVbB507uO2LBXvGDUL1?=
 =?us-ascii?Q?DjRmMmT2RP6liL6YlzQdjN0hNCpL26bPrAtxHHcT0jIdL+JE2pAi9ZuqUiHE?=
 =?us-ascii?Q?H+nKJjuHzM30fk4rKdEbjgMGRPNffLPzh3MzFMAoqaZQY+yYeTcXz2LzNeYn?=
 =?us-ascii?Q?LM9wXQZcGKGk7RMiImaRLYJp9S+mUEU6rBHqbJ7tAVQKddjUheIW6jlekApu?=
 =?us-ascii?Q?tzWLvGUrt3ISlZwgDkl9oJHejDrxumAG5gfsvVBAiZwQ+iNfCDomR6E/803v?=
 =?us-ascii?Q?fMSrDxC2fe1Yem6/CPVhY0PjfuPRhRVIpxnpJgs1YYZZ4H2SSn3aa4Aev51m?=
 =?us-ascii?Q?y+wzRUTGjJ09Xqs758ml8CxthoeLE7e7Mr/Kp5wDuxyhDSNwa2Vo18OBJSEs?=
 =?us-ascii?Q?JEgqMzr68H0ijd1vGdigUAUV3sYbp/UZihhx7EmJ5cqJrboFdjvM7Qw6TgiX?=
 =?us-ascii?Q?RCLGPE6hhiAZ/wWbHzgNltwXKmy6fyHLgGtF6ocaCauZvh/A8r1FZfFrRTdl?=
 =?us-ascii?Q?8zbPppESWmSkqQXJafYFm4/Eg4RKXpbISzRZl+xy3qIPYirkFaY8D5T2re9a?=
 =?us-ascii?Q?lyi+AIjCIPa9+gqzbYpx7Ds0z+bEy1bANGzfz3AEcFE3prYelgDoPHAsxiGt?=
 =?us-ascii?Q?5UQiDYQRn0ubMA3kP7hgO4+EZHHLPbTlSM+IabzTRlPejmLe4cIOrygAILVT?=
 =?us-ascii?Q?83cNl6ccHtScXuhbm5quJbnNH0mTLDbT7PdgVWjks9wZAAaQbLxVcAVcYkov?=
 =?us-ascii?Q?Lj6jeB1UQaOq8Bz84fIAaztdN+uVue5B7Fh5Xii9WPVdW0o52HcCVWwvgBQg?=
 =?us-ascii?Q?PLEpV1Er81NC0+WT9CkXK6BvlO5+XrZyQbdXDZJ3msQhYXOxxeXeAyQ97UvI?=
 =?us-ascii?Q?akJPnjm3thHCC8fwygMTJG5QLU4XkhMu7vxH3bLDHimwB1cnFhy/KafnM6jU?=
 =?us-ascii?Q?8LQlXQSLe00rwWSl/XMJXOv6vrLm/19cDNsO5BZQexUXuOFkEashtgG3eGq9?=
 =?us-ascii?Q?1OQanRqzBWn3goa3IbcOUnmm23phLE33Ks0uUsQ/uDjy8fspsXRCS0IiqzTC?=
 =?us-ascii?Q?1eLyUa8DiBe58hPuVauPHo0bzaWuISQNUH++Sf4XwtXH8048WYPxcB+TMELQ?=
 =?us-ascii?Q?hHCMyaU4uRX4LASGEuwKEPgQ+VxDP72rFJuzmszsBT3HKNohJrWFnLV3WDkt?=
 =?us-ascii?Q?2c/1lI0SjMohuFbuzFbuSyActgYHbOFjx/4Y5wLpCsnb+bMS1E7L1y+gFb+9?=
 =?us-ascii?Q?/ZC3cG0XJOclzXevWeQha/fhQn+HvrLVo9odpeeLAN4I1IgmRrw5DQ9S8Pfq?=
 =?us-ascii?Q?8oO6kuwc22MdmQV9U0oos2yLU5YzrZx20dQ397mUOlK66oH2Gn9mcRRz10bS?=
 =?us-ascii?Q?CXlV+g95v8IK1xKXIZq7cHVs+UWv2xvssMUJ6GOIAiBZ3WSY2LCa/yUVvrMZ?=
 =?us-ascii?Q?sK9eQkUcQR5cr4nXk4WsBeHduW8iL9ywnzYAAR2jIqq0ppt3AwobpkjHt9fj?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 269881d1-c8a0-4169-8a7f-08db037d62be
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 11:22:06.7694 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BB1MJM8EvsxQCAQLm+x2qEpFMQ9bS08DM6OdquE3JB40AzupSyOSSwsVDVt8ceigubRTZSvel8QlDJ+J47o+lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR06MB5016
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] md: dm-table: ensure dev_t is initialized
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
Cc: dm-devel@redhat.com, Tomas Melin <tomas.melin@vaisala.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Avoid returning uninitialized value in case
lookup fails.

Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8fc44c9f746a..71c59455bf3b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -331,7 +331,7 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
  */
 dev_t dm_get_dev_t(const char *path)
 {
-	dev_t dev;
+	dev_t dev = 0;
 
 	if (lookup_bdev(path, &dev))
 		dev = name_to_dev_t(path);
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

