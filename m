Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C223C43217
	for <dm-devel@archiver.kernel.org>; Wed, 12 Oct 2022 07:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665560007;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fzS64sHhH24FtE/eMbJdbzf0QyHRKuhknETQ7+wdx0s=;
	b=AyZT0VCcB+lv2YgHn+m5PSRfdYft7E3wpNaTwzAL4UdQzr2yel/E+eF8FgtqKbaHCxJ3sp
	ZmZBiU/AR82d4S7HM/spRil8hqn5gzAXI0nRHf9vF90IC2R/JxsJaEDciqaje5l23b7mCG
	2BrtD/UYVlCZ6gVG0V5Fx+XHshfk13s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-WCCoG8nqP5WqhJb2UYjvtA-1; Wed, 12 Oct 2022 03:33:26 -0400
X-MC-Unique: WCCoG8nqP5WqhJb2UYjvtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CEFA800B23;
	Wed, 12 Oct 2022 07:33:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56E7B207AC34;
	Wed, 12 Oct 2022 07:33:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3045419465A0;
	Wed, 12 Oct 2022 07:33:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4C79F1946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Oct 2022 07:23:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21ED342221; Wed, 12 Oct 2022 07:23:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 199A563A57
 for <dm-devel@redhat.com>; Wed, 12 Oct 2022 07:23:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEE27804187
 for <dm-devel@redhat.com>; Wed, 12 Oct 2022 07:23:29 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
 (mail-dbaeur03on2081.outbound.protection.outlook.com [40.107.104.81]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-BAWW7pXfM1WhaisE42i4iw-1; Wed, 12 Oct 2022 03:23:26 -0400
X-MC-Unique: BAWW7pXfM1WhaisE42i4iw-1
Received: from AS4PR04MB9362.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::9)
 by PAXPR04MB8768.eurprd04.prod.outlook.com (2603:10a6:102:20f::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 07:23:24 +0000
Received: from AS4PR04MB9362.eurprd04.prod.outlook.com
 ([fe80::8148:e8d5:18a8:8b1c]) by AS4PR04MB9362.eurprd04.prod.outlook.com
 ([fe80::8148:e8d5:18a8:8b1c%3]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 07:23:24 +0000
From: Lidong Zhong <lidong.zhong@suse.com>
To: dm-devel@redhat.com
Date: Wed, 12 Oct 2022 15:23:16 +0800
Message-ID: <20221012072316.19124-1-lidong.zhong@suse.com>
X-ClientProxiedBy: TYCP286CA0067.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::9) To AS4PR04MB9362.eurprd04.prod.outlook.com
 (2603:10a6:20b:4e7::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR04MB9362:EE_|PAXPR04MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f7d91f1-d9d5-4bcb-765b-08daac22a60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: RySa117AIM7fKv5DSQTAFrLL3erLmpEp0pqLyNEYWQlOCGDRcXPHFyEIHSgEUVnq7kyHYUTZHcMxqfw+GFvjhirK4IvrjvuIrSdx7HPrtkJFzswXw+7hpGEf7VpraT+l7N4kKZmvdugEPOSE44lcKLDtqUeP0J/+5lmuHWWF8BOHaeQhG+Tg0tegZhg3sZwEWoF6aiLh2spQPJt+LUmBKQEjIomFn465c2pIV/jkkvUxWkJBYFbtsK63yFmm2x6avPFBypr+SiCDz0IdKMAQTdUG4NxwrD/9RCCFBjZBgtwPS1zhCt4vHJBICfPt/KjENb6o9/hq5KpdOd/YoMtsTZrUrq5gl3tJ5cO3i89q9VYO5rquXM+e9bIi3VK4UUo1lsGA9aQIj3Tud48Re7mAt4UaAZUhlD9qNJMcgOYcfgxyN7hpf5yPRBCQOLd0+NTqJnDQ69yeKHGr0xBLWvQ0n107DzYhjgbr/Kl5MnohPRoOPrIIjRk9QCcbN9ON5wdxBp+B770C65+64v570k2CfISBxUnWKOEq1O6FlBGbvP0EL0XN+nQSjXe7wqa/FB+lxIIA8X1BoR3sMCuk/yI16Qptu+xqAR1T7T25sybANPeWPh6JY9CDdkvg/x20j05EU0PP8xkYFAQpFUVgkWZaHLFrvM2D6CQTO7qufutcfMBZBsBOpwxvFb2sg4RelGIOfBSaoiKj2/cNx7c0TypX9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS4PR04MB9362.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(8936002)(2906002)(66476007)(66556008)(66946007)(41300700001)(44832011)(5660300002)(8676002)(4326008)(4744005)(36756003)(38100700002)(6512007)(6916009)(6666004)(26005)(186003)(6506007)(478600001)(6486002)(450100002)(316002)(1076003)(2616005)(83380400001)(86362001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ds09cHeZx5Vc3lJZs9sPgwYDZcNmCWeOPwyOjaiNt8S4x8IFaWOoQm5HS+jg?=
 =?us-ascii?Q?c+5Av433L5KuZbiulZwRavDuTqiqXH0uNlhZwnnU+i2HxXGWmpgi4Exe1pYF?=
 =?us-ascii?Q?4zb6AjReHjoTDqjkeJlZfL5D4BWB8u0JONCmYk5u2KS+ipcdeLM8lGXh+hxx?=
 =?us-ascii?Q?yQrfQTBrkPYLrZpsgO5qTimjuOENpRi6othmP8FLG8c8o3zfG7Bf3sjjC43B?=
 =?us-ascii?Q?gyBezUn9xc0OK2W8ll/cPyrsUn7lPSzDVE2/mnjopqxt54SPcIxcGrQQS7Mk?=
 =?us-ascii?Q?FUWFzYqFwQztJucVC+jaMXWS3CXcT0ZQMIvge0HYVv2q7xJn5bP0ZSHIW/Py?=
 =?us-ascii?Q?k23WigKlfXVDnY3T2AsGGk4DGjwJLfX/w5cUZUaiuPdp3Bm71ko/oQaIZGPk?=
 =?us-ascii?Q?zP//JrcCLG5PgnKeSKA30LKa7T28LN35wjxxSwuI5lyY2zmFzHjAzxW/f64O?=
 =?us-ascii?Q?QzqbTb7Rt0kRQbxOBJwym59+x4zIo/AVimaGB2kamoC6BtdhqWp8yerX7+fI?=
 =?us-ascii?Q?GIkl/91VxgEfRANXsNpx5kszoHy7kn2ZYRLnd4zm3P2LkVari+JkEKTPd1uf?=
 =?us-ascii?Q?B0XAGG8PX/GpsV8Foc6e6AIb+aV1/JZcw+mDPNyPtG8APgWu/vaOciYqk5Bm?=
 =?us-ascii?Q?iK5cHRJjR0so6Zqyw3vCeEaXPVEK1gSAjPNn3KPoXcOgcdDHUx7BHDsIJyIt?=
 =?us-ascii?Q?MrZoq4pwXGGDdsV9QXmHdpvR1K2F2yUJ05wvff+suSPNjyEPbSEdGf8rlNrU?=
 =?us-ascii?Q?wzQYlwssg3XuqpmgvDp3N2W2VPXhXjCxL3gKbZVdBhcRjOIMewC3/iMfrc+p?=
 =?us-ascii?Q?egPnzfZTL8F8e7q/W43RA+YnsqHoKRWNBEPwWR6pwg/PU4F7QV8S+VDUjVoD?=
 =?us-ascii?Q?fluJ3Pej4+0k6bIWv+j1ZhNeK9JzvUtoKXE5sx30rvZLYCU3m16AjdhafdA0?=
 =?us-ascii?Q?LJet0ydWX35RcoQ18RLdrTJWi8xj8uuu7iHYWy4DkDgmLSwAYO2QwKZolcCM?=
 =?us-ascii?Q?UXgJnsnV3hK2qnI8eAcavrVnwFT4U41yZnVJgwaaP5ehLkcBOjHyhohzrVXH?=
 =?us-ascii?Q?3KcJULkm1vqdeUDWiQf3pVO24hXM7y/iIH0UfybOE6vaQCqEbX+Tb4QTiBTc?=
 =?us-ascii?Q?NSH9QCYJFQqLh8r2IjVpw6+jBcHc7OuiPwderdHRVCaQw0c1GKmG0B/ump8I?=
 =?us-ascii?Q?NyEW21dD64ExiWAOqFuyRZInDk4twjXKGFccladV9L6YMDS7vf8CGqTCivi2?=
 =?us-ascii?Q?+11EkY0c2gzh3RssmKwDuy/PXZ8k7dTnDn3y7zVK14pwemLOpfXRZYjI7Mvs?=
 =?us-ascii?Q?hLmLPh6NoH0+wUsubFH8VtIjbyOVcHodXmBc+gtg6//Pc5QM5szZIPsHnNU+?=
 =?us-ascii?Q?5aAi4dwTDyNq3TfGK0hL3zTFTbLE0uj8jT9VVqYrcgchXkSIGEKGRUvVEppw?=
 =?us-ascii?Q?UuCBCNh3EzyMDB/OLrgCPSnooYAmkx9nvAAgMIvUCe1EcFx//jWNnyO2Q7Lx?=
 =?us-ascii?Q?572EXXeBHdIGdxuBlUIvgwLP+vibiZYa6yqzmMPW/c89oeyh7yIAiO/MD6Xz?=
 =?us-ascii?Q?VxZqnckbLo52Vt/+Ucam75dorYcbXXs8Rop2ACfm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7d91f1-d9d5-4bcb-765b-08daac22a60e
X-MS-Exchange-CrossTenant-AuthSource: AS4PR04MB9362.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 07:23:24.1958 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3OwpLQBgrRjK9R7Y3DQE//Q6RV1CMNIAPwgUuGuy0rTOomzrtp793D8folanvfxtb86iaE3lkLQmlOFOB7yyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8768
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 12 Oct 2022 07:33:20 +0000
Subject: [dm-devel] [PATCH] multipath: add option -D to manpage
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

commit(5adb0a15 multipath: add option to skip multipathd delegation)
added a new option -D to multipath without updating the manpage.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 multipath/multipath.8 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 4c7e9885..93b6d763 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -223,6 +223,10 @@ The verbosity level also controls the level of log and debug messages printed to
 Dry run, do not create or update devmaps.
 .
 .TP
+.B \-D
+Allow users to skip delegating commands to multipathd.
+.
+.TP
 .B \-e
 Enable all foreign libraries. This overrides the
 .I enable_foreign
-- 
2.35.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

