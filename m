Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4CAC43219
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 21:23:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-JTflO-atOa-lwV1vqN6I4w-1; Wed, 04 May 2022 17:23:31 -0400
X-MC-Unique: JTflO-atOa-lwV1vqN6I4w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 117BB1D33871;
	Wed,  4 May 2022 21:23:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F14EF415F4E;
	Wed,  4 May 2022 21:23:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6C2C91947B91;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 70B741947046
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 16:29:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61BBF15674EE; Wed,  4 May 2022 16:29:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3310E15674EC
 for <dm-devel@redhat.com>; Wed,  4 May 2022 16:29:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B5C9811E80
 for <dm-devel@redhat.com>; Wed,  4 May 2022 16:29:20 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com
 (mail-sgaapc01on2097.outbound.protection.outlook.com [40.107.215.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-zundS2T0O2ezPeoHDCupnA-1; Wed, 04 May 2022 12:29:18 -0400
X-MC-Unique: zundS2T0O2ezPeoHDCupnA-1
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK0PR06MB2466.apcprd06.prod.outlook.com (2603:1096:203:66::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 16:29:12 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08%7]) with mapi id 15.20.5206.014; Wed, 4 May 2022
 16:29:12 +0000
From: Guo Zhengkui <guozhengkui@vivo.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Thu,  5 May 2022 00:28:26 +0800
Message-ID: <20220504162827.9429-1-guozhengkui@vivo.com>
X-ClientProxiedBy: HK2PR03CA0045.apcprd03.prod.outlook.com
 (2603:1096:202:17::15) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c19f9637-187f-4550-5792-08da2deb3895
X-MS-TrafficTypeDiagnostic: HK0PR06MB2466:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB246630C2D278CE0DF5BDA801C7C39@HK0PR06MB2466.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: tGXE4ju8lRfxJnmddZay+S1MDj8G2ZfekYRSiu2yis+bu+xtdA8/Bn2trIRogkE5fCpCTCc7Y42ZLzhlrCxVZI8oJbyLKK3GaIuRlqAQmaEqo+zmpBbjoQdCs5Nh8UyPipNjvfHnfWjUk89BoEzKimfQJyDDFgTH9rvZOcRA/Es/WrkEInA4TSTN4EXjAKSyYp75m1Z1j733kbNv5b81jm/IVg/eAyY75sJNY/r64GoFxxTvdxDJNw6Zw3svQz18o3usftwmdERR9aQR9NpBGpb74e6KlbufoSMrFWgDVafRU4rqu9Dt4ROMlFjO/qBeni7UxePEMqsngSq4dbcTcof6a7KcI43TqRC016rmhfndHTCzGXnBRryi3/U0uegAqnJO7tFtRVluNf48YJCO4ts51pE7v9Mbm0qEHJeFRWmU8Gg+HqYORDozvZXRgt1lPp3lzxgi77N3tyvA67DleJ2JHpoXfEk5EXMjziO2NGyIVpJb6ie6k3UhlVxzoCPgrQWVCV0+F7AAubnccBMhmrnrgIzbc5VKyAif9B3rA3I68fPluAEcJ89iYSfkXI0qZEks95FoiOy0eUaMuLnRZ7di6dEZnPYIxtFhwusa80NbW5lE80RnaFNDLczmvOP259+ZrmnQwNbGVvwQg1Pnvpk2136dFWErlbZT6Bh3yaYPG/rRIcOC9A72O1dsGsWJ3ZscprfTvGuN+d2FPHrTXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:HK2PR06MB3492.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(8936002)(1076003)(66556008)(66476007)(107886003)(52116002)(8676002)(2906002)(4326008)(508600001)(5660300002)(66946007)(38100700002)(6666004)(6486002)(186003)(4744005)(26005)(38350700002)(2616005)(36756003)(86362001)(83380400001)(110136005)(316002)(6512007)(6506007);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JAvUhpwiF5BllO4q6Iv+cNybVLXHaSuknpzNhW+NeEBbdZSy7C6rHKxkfGa5?=
 =?us-ascii?Q?jILodI/zxuFyuMdFLnuzKcPi2EO0okqjXaJsZuH/msHKCx+fkjQ3+9saKL3z?=
 =?us-ascii?Q?FSoq7Cb/SyGzt65/jwB1DdaP0ofvD875DaFud2l9a/qd9Ik5D2uRcYWcvpx/?=
 =?us-ascii?Q?FAeG7b7LrOpqdgC8VyoRqEtiF/mNA2ha0EwsHIjAC9fRFZzqEEy4s4/k8Qy4?=
 =?us-ascii?Q?oUocJ6CVdit9xMivpoRQC70FBMsJRqZ1xFQ08wtUo9/Lq+b3Bm66yvRRY42C?=
 =?us-ascii?Q?MG3sxTqYHAzCIUoaMrQZlzv9OvlzgYgnSVj86ZSXw45p98JnXYwAuaLKUZWz?=
 =?us-ascii?Q?+f82PcRAg0JWIPnFyNdqTCVH5K9DyGJV9teEvkkFk5CTvpkC06E3xtYZr3rU?=
 =?us-ascii?Q?5nXzd1SBgk5ELqfLyS9HrqH8nTLonr4kHGmQpMBGNmJ8BhkNFcORqT+vd2v0?=
 =?us-ascii?Q?rfuaGLUR3R+C/WpDYw5buyUZISU/x0uAJF6HvEGnw5/9Lh1swV9rBBjZ799k?=
 =?us-ascii?Q?x4WhOQo81Vi+AwEM9mPYVZSWJsfS7MYKfjbyDQBndVTOa1YQ6UuCutuARY4H?=
 =?us-ascii?Q?l3V/bw0CjDj3QSX3r7hqQ8ZZ3D9nGF4aXcGzgRfJ/KfUSWBj5PoWiAhVi6wM?=
 =?us-ascii?Q?wTjel3Wi3jrFaOYeFqLqZ6HlosD3ZtsOcxU3PqxzQGkj5b6zhoanpACaLIEC?=
 =?us-ascii?Q?8165DtKQFS/I4TTyaWMXlAl2Z9EKIIalH99zSbDMoHqvjJ6ws1LdrziprR51?=
 =?us-ascii?Q?z8jvfZAOf04UnU5zOZ7K+ei20HZ+9qe0cvpH3O+TK+xsYAPvwUsa1DY9koUS?=
 =?us-ascii?Q?fVbVlCbpil1U7tY2oitONwskrHO+JyXxkE8ZzsR0Mb5Ag5xd1n1ZTea73F4f?=
 =?us-ascii?Q?DwRVjBHgJFvdqZKnAhHgLaXDaOzAUW44a9pZ8IYXqHld5Q2coZluQKjX1a5S?=
 =?us-ascii?Q?GCVhGQ6kmvhfXnmqrLXZm1Kj1xXy0uBys9cqI85GvH9rsnPvhWsiebOFn+04?=
 =?us-ascii?Q?ZJ5N+w+hag7cY1VVPgVYj/PJQS07anZweZreBRl00/gchaZCIUNsNujDnPYH?=
 =?us-ascii?Q?tENh/JD06ylpqifuyoYGuXu9kKf24JAjgXmFjhaffrhJPCMqMn5+BoC9SWNM?=
 =?us-ascii?Q?5l2Q1UrYH7VlzJAMrjeYPXGgbRSVjD3dp/RD7O0zu94PxnAGlqWCZllNwPAP?=
 =?us-ascii?Q?1fFGYaLZR/zhBuXVIBk3EUNbj61DR5137Qb6Fg7PcXxhXmWneAm6xS4dUeCS?=
 =?us-ascii?Q?n3Vzk60WO+sX6P0cbaG/FVXBd4Wj00VyiJqrYrn1M504gM6vC5zoL8lPHBIs?=
 =?us-ascii?Q?ILOPdQjoEVP6TTJl/tOb02glUNpKIpkXYObtOJyFg++WPhdd0TkeSrA0lXzV?=
 =?us-ascii?Q?OA4LA5M43OmqCBKsVxf71T3OfPHKtaTzBUL/H7cUIdB8rLg5os+D82s7NRD8?=
 =?us-ascii?Q?2GPoM3UYYYoJL/YTp6cahStTpwoA0bWi6RKDtjUzhgWIHnlYubGIqln08+2B?=
 =?us-ascii?Q?1k51qaRLlgBJB5VrLqpeApy5hYi1Q0GlEjUpPT1g2xoc36wNi1swgVA1Pqnp?=
 =?us-ascii?Q?Ul02KPx6SZ9J2eZRmtERHGRPOXAsQ5RHIayqTn0omFQMXOUjEUmeXnfZzIcc?=
 =?us-ascii?Q?Vd0HwdZ5m6KrT//1IQpfLRL8nV6hxPxovHNY1YIXEJq/5dqkBNfM3vdoWi7Z?=
 =?us-ascii?Q?vu7BdhZHBmmNnoTvN8G37injENRByi24oPdUwgInRLo18tMRjHkoUluVLpd5?=
 =?us-ascii?Q?ckbRWPxqGw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19f9637-187f-4550-5792-08da2deb3895
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 16:29:12.1534 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJi81VqXLQblMGTbxisS33LLwHvBuWQE8JQYuoWkvrFEqm4HB4lffYN3JLnk0IsJvjt1yANHz1YnVLF7wDJNCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2466
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 04 May 2022 21:23:25 +0000
Subject: [dm-devel] [PATCH] dm cache metadata: fix returnvar.cocci warning
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
Cc: zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix the following coccicheck warning:

drivers/md/dm-cache-metadata.c:1512:5-6: Unneeded variable: "r".
Return "0" on line 1520.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/md/dm-cache-metadata.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 2874f222c313..ab13b7380265 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1509,7 +1509,6 @@ int dm_cache_load_mappings(struct dm_cache_metadata *cmd,
 
 static int __dump_mapping(void *context, uint64_t cblock, void *leaf)
 {
-	int r = 0;
 	__le64 value;
 	dm_oblock_t oblock;
 	unsigned flags;
@@ -1517,7 +1516,7 @@ static int __dump_mapping(void *context, uint64_t cblock, void *leaf)
 	memcpy(&value, leaf, sizeof(value));
 	unpack_value(value, &oblock, &flags);
 
-	return r;
+	return 0;
 }
 
 static int __dump_mappings(struct dm_cache_metadata *cmd)
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

