Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2048.outbound.protection.outlook.com [40.107.117.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1251292F3
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 08:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715846652; cv=fail; b=OpFQms58Zt8u8RNS60RvYqHAjr4MhNf3YbuTlGQ+Y4Ge5PzKeQQtr8OKWbo0WTexF2ajN9GmTOulKyL/VnSQBZCbJUsOQjUEOLsVEfC+nQh/gf9Kbv4L2Tlo6K8aHSYeqAr7enu4C7v75a9wgSBVWL7zbJIo9nlx2VajfNClc2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715846652; c=relaxed/simple;
	bh=Dd2Ne+wYYQlf67SHMr3G51DSNztSqYbRu48pXFAFIJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MbBZzz8ZwVvmJO6IO/33gobw+uzeRvUVTQL2TispImcq0/eryDGO2tFhUnT0SlB04Jt6kOZXkoBwNdTauOPdbYUbeDyNI/MylqXTv8Oi39EDfWWc8EpybIAbw7M1pTNov2ifjzPb0PUvUy9JUc7IBJoqmZ8qvtFRJAUdEqH8vW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=I8rciYIY; arc=fail smtp.client-ip=40.107.117.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="I8rciYIY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqtGC6cM3RUAsKonEwvdk9UxBL7liSesnsVOSHsaKl0G30cLwIi6iENdpq+dN8QRSxZvl4jeaQ0vq81jlCjDLyp2iH5BCDlr00qRd8cVHAZz3iYdDvk1aqj/cybru38fozs1he7WZTtDH0viwEonnwUR3dbuzpHAoEIY8s7QAKxUi/YZrZ8SF+TFuLXwqxVUQ9cYrDwnfZoECxWyut9iwB4CElGDFjqWapC5H8RWi147yK0DjLaPfQdLRqqLBDIOfVkc7IItGLlaCVzVqFJ5sfmlrgZJhuWTobdN672eYfdTjVluwMF3DNnJNDLGQsZOZtgOUonF8Rdy9tB9oSqxdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJNf9BhDEBQw+QBjmIK43ZXJQ02KyxkOt212RsPDMms=;
 b=BkmDZCeNY5XtEYH4GH/u8TNQHPE32bZjO6FY0M2jMFGYqIvBt7cZvnO1xp6vzNOdn2UulL/m5Re3Vjh0UA3rZ0e2vSAZg2WseVxdYnM5s8ZdYrJmzChqKQGxPLZWWFGZvfTzl/uP34ubOt7aG+5yBmvjD4KcyspKL0dLrBgeKix57qw4B9Wjjy/N7qZ4TvZLnbJ41NKRfCfXl9994CsyTk91w9A9BrvBlc0CKVZ9XT8T1MWsUhIlTkiMf1gOKa48LtDOPbKJpe5kmWlNGSIQ5Naa+xcdn9MSjsw8hl8Cf8S7ZKLQjlIn14hn+gF/gBlS9JCetXQnmEmgZ53UlB5+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJNf9BhDEBQw+QBjmIK43ZXJQ02KyxkOt212RsPDMms=;
 b=I8rciYIY/mCtXGfRV4qNlLGwQI7tzjHd1MHg3xtHdRomxN4Bdc+Kq3wwJZbocJa8jD7brZ4zz8wx9qyyvg/rPJZaBOqra2ZlP5ofoGPj7tHG0vbEFtYn5pDWxXMfzC7RyTE09IhgsL0wg9KtFJuBewIvEAr2Qbf3OUMxEFl9B5GY1nJjM4gznAxHCR2dvjryIxxXvr043mFqlo6EEGpLr6z+WGTHkzu35a16UCMyr2QfJjJj4hEDM0Ggvr8dJ46fHSMcg3tmCDVIujRwiHNrNnUIl2JM7We//V1Lx0Q9oHBnzygzOGpqsZtG3YgCE/TjAplmc5kbi3VQgdKruhO8EQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEYPR06MB6830.apcprd06.prod.outlook.com (2603:1096:101:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:04:08 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 08:04:08 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v4 2/5] dm: add __send_empty_flush_bios() helper
Date: Thu, 16 May 2024 16:03:15 +0800
Message-Id: <20240516080318.120231-3-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240516080318.120231-1-yang.yang@vivo.com>
References: <20240516080318.120231-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0201.jpnprd01.prod.outlook.com
 (2603:1096:405:7a::18) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|SEYPR06MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ca4c8f2-ddd8-4f76-ddcb-08dc757ec345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G7D2cXRn8Id9QTO4f/3FIZITsY57g2pap/j6ByjzqLQYutJ3bClekVfrajeM?=
 =?us-ascii?Q?lFZ4CPDBUkplKZV4S+qYzIJp844THlOGea2pCUXkuN2o4fiTbVfEyOzDD3Pf?=
 =?us-ascii?Q?SB7o6xBL704drq4V/tnfX/EeGbUvLKyF9NC2KN2NWunKxDvfKEoCXEJ9CPcY?=
 =?us-ascii?Q?oCxCPbkRtl0G6KI+mIPOF7pq8xS24HKZq86dMCuMynPe1eJM0D9U+3yP6a6C?=
 =?us-ascii?Q?hjylkcHfPamxQRWmZ6/z4KGR56BapOFVf2pDqGc6OasoWxVNlFoA0LlJXkPD?=
 =?us-ascii?Q?8w0RW6w03iM4o9yojcDQIctHUK36ESm5vMN/EDy1Da6MT97WeUqQLCAeau1h?=
 =?us-ascii?Q?i6lPgMw6TcO6XJ8c8goTv2jml2UlVWF4uZ8Bchq0aN5oV8zm5aM5RIKZZQuy?=
 =?us-ascii?Q?0By2NIDA3cPp8U84CjweP4V4/5x4/joB68udJya8NqtvYgWvxEjd6458ODTg?=
 =?us-ascii?Q?HvldGAduvl5YFBkYMCH4maIvCkNdnKzx3Zvwf0MBXSOaWlCuv+GimcrPezfp?=
 =?us-ascii?Q?1gcn4cgFxGNbrsDBpdC1EFSdNMcY5GmTmRglhtJbRWk2lvhnzoKXb6afezrv?=
 =?us-ascii?Q?DWxSrrHmdZclXdYYT1UGDlXudyGqpT81HSCz3ew/8gcUQ1OYe/mH3UfWHBAi?=
 =?us-ascii?Q?g4c+mayG/V9nMQdtkPDBMwVWRgx0ejoewxLX82izjXwPxL7Z4KMbkS2OrgSt?=
 =?us-ascii?Q?ZERuHJf/BYu1TUEKMW2TDfj02d2bXA/5kFjv+J7EHHPukgc5vibnFJh+I502?=
 =?us-ascii?Q?ga08noCQnRmkDcObNQWzVcJqv93WpB1eGvFYOo+lwHWVePQ1nBRLUmhf9AT5?=
 =?us-ascii?Q?fRvAw1lbeabABG2UzjxmAajR8AQBJM9qM2CvRQDEXQoLAeuBhjn9H4kTTtzQ?=
 =?us-ascii?Q?UspZFJgjmWVmzE4fIxDEGgGT94shgexhOCaSmD71y7oIq+jeNkqoK9X3Ok7Y?=
 =?us-ascii?Q?w/On28SbhdQNJabD8RotWY23kH6y87v0NHlNj4j5pECHBqnvTLnfW7GnLFcZ?=
 =?us-ascii?Q?vCOkLAZFgFtTlSZQQPuqifKToB1oblvSC5irD2SXSvkMiaDkwlJXJim8z46V?=
 =?us-ascii?Q?lEk/bw7NXEEXTEz/cm8VgQVDSItN1ZEPFTHVx0tqYejYRiwBvDQfSY4uZCoa?=
 =?us-ascii?Q?T1EmIsdhHp9Et7K1wf4zmEq0eAWgIRAekpI4zo9adoMIpHVlpSyOEtpp4oMy?=
 =?us-ascii?Q?+n71alGlCxN0oXcYT1geEoYLbtrgOOfqilln9D3VbvOKVlwII03tKGGGmgM0?=
 =?us-ascii?Q?hff/27HsW7aLL62NnMGsQbolELwLv+WW86fKszP9j3/+q8EaRMlIkeCJW4Sd?=
 =?us-ascii?Q?+NSB/yyVG3GlTCKDrkUeBUUSEPdaY4N9ccfftcOhe3sq3g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4RRaSw4JvBuOZzLT9iHWltq3KEwRoI5TKJfVxa2x3gTKjVxS88GL1sbN7Gwd?=
 =?us-ascii?Q?XwKum1NMlt/bsf37MpDbFKcJppJMnHAloYTQD/0S9Q17P8Lp1WMllPROFbaB?=
 =?us-ascii?Q?UuE5Kbt3+IuuZ1Bf6Gt3nvGpljSkhBh4gv4KrFRNxDFBX/xt+WaN/KUBwQq1?=
 =?us-ascii?Q?azXr0Y/bRpCnFRglPn3BbMpAjICY4az6zdoeQ+SOnK1W7NP4AiJs3AYsuAZi?=
 =?us-ascii?Q?lXdbfKEwbfjKvzZPnBfXXFXeMRWzfYrxlIHWtManBdvt90V2I6ASJbpL2O1b?=
 =?us-ascii?Q?Xpi0AWvYS3Eh5UAFPKtKhbJ3oVEGwDtlvgqWUNilASSJYKFhDqqXvR86YB/s?=
 =?us-ascii?Q?95sIjM1ySL9v0gWaaT1AEpnS25bAhbHtJIW8syUkxWJ7xE8ubTnnWnU7BB1N?=
 =?us-ascii?Q?5AvEd0eh6fqzu7ZA0EKIfDGyCnwLwiXGXzhCMQM2eD8M46h0me7iJdsUIDIj?=
 =?us-ascii?Q?8brHV+2WQHUH/LKMvbmIugT0I1oVpt6mLL92rp/VU/n6m/CysztI3IaY6mWu?=
 =?us-ascii?Q?x1dW3wsm6O4zj1q5aoqqbKuHTQFKAZXR7qXJ5qkoMicVPmAhAdXnDJW/9jqf?=
 =?us-ascii?Q?KgRyI1EcgOcoeJWz4JzIm4EpzXOSlzFCa4kBO6mEbXBNkrVNBzidfgWtof3R?=
 =?us-ascii?Q?FDOQkvDhwJSk4KfNsYvSxerKubWHA/vajPFd1Bmh2z7VmruJZxFDCo7EzoVT?=
 =?us-ascii?Q?k5H8hpv+6jdnxAfASQZvBPDwC+9+Y+7ZrrsGsy6WtVgRpwVOmpCKw2s+1hkF?=
 =?us-ascii?Q?ECFouVmT0CBmQO5o7C/OUPhvDzpsFkJJrr0wL6DCoBEh2PIHWKsNd/QLNa1h?=
 =?us-ascii?Q?pfmAkMljKGVMfFo7mqhq0rb4FaBUIqoR1hfDiPsFLswSyb2XJks0F65u5am6?=
 =?us-ascii?Q?z+owKpFdmmUlzhYf40o/Y0sh0YSDGJfIUujpITwApO+e7kjaGDWV5e3F+nEq?=
 =?us-ascii?Q?/IgB7gYUgXhEGqv9QSktaXA9LCBuQW62hdNSvwy5cZBQIoeNm8PHZjHaXbJk?=
 =?us-ascii?Q?iyMZPTtg0Cl4YKZy04lOXqHaGwuc1yk02+W9EfKnZoTu3dBo22HNjeHaiDDx?=
 =?us-ascii?Q?OUNSeIvG5E/kEH51UoTFnFwRKv43w/ygLc9noejLMtVYH5s6MOmnh5ypYXGS?=
 =?us-ascii?Q?ybLe4UucJKP7cJexbKWF0n5HXpd/Ec19csxJWgzVPTwqKnu81UapnDTOsmf5?=
 =?us-ascii?Q?gidh7QHb7kDxE0SPdTHfWIEo91xKPhFlbj/crgYhYKaJ9PHP0SwbJWwXDteh?=
 =?us-ascii?Q?wFMBvz8YQasrZuq1WtKCsennRnAOqeysFGkkOmEglr0UWoR4/zSCKFHOH4qG?=
 =?us-ascii?Q?b0/DyzE+VPF4B0TPk14UzwaDO7BNcuPeQ15xZOuwkCwfBwwXlIcRkIzi2Dhq?=
 =?us-ascii?Q?XMtLeQ2+ciFED5dDqYURCIF84cLlmI5Y/vhUxtmENRxQk7uSJBW5eU+ipVy9?=
 =?us-ascii?Q?PiLxD0rYA4ADbkXPHxiDvKbnXNqj/kTPTL8AWUMYY0/QRS7NiHoYYBA41x5x?=
 =?us-ascii?Q?iwo5NNDWKIDo72lqan42TTXchH5mG3N/JkmAsBkg1lHUn4nHEQ1815RNlh9S?=
 =?us-ascii?Q?6bh1iukiooauk0jIn2AjTSH2Te1KM2SY2sv6XTxv?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca4c8f2-ddd8-4f76-ddcb-08dc757ec345
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:04:08.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYSe06esEtG9OasYnf3N/tRgFOdogdMsL8M9sIbJQAtl7vUZCW6xE59Fkm9YM7R3/zMAmZJ2/rdz83+xOo/o7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6830

There are no functional changes, the helper will be used in later
patches.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56aa2a8b9d71..25215b93c3cf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1543,6 +1543,20 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
 	return ret;
 }
 
+static void __send_empty_flush_bios(struct dm_table *t, struct dm_target *ti,
+		struct clone_info *ci)
+{
+	unsigned int bios;
+
+	if (unlikely(ti->num_flush_bios == 0))
+		return;
+
+	atomic_add(ti->num_flush_bios, &ci->io->io_count);
+	bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
+			NULL, GFP_NOWAIT);
+	atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+}
+
 static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
@@ -1561,16 +1575,9 @@ static void __send_empty_flush(struct clone_info *ci)
 	ci->io->tio.clone.bi_iter.bi_size = 0;
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
-		unsigned int bios;
 		struct dm_target *ti = dm_table_get_target(t, i);
 
-		if (unlikely(ti->num_flush_bios == 0))
-			continue;
-
-		atomic_add(ti->num_flush_bios, &ci->io->io_count);
-		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
-					     NULL, GFP_NOWAIT);
-		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+		__send_empty_flush_bios(t, ti, ci);
 	}
 
 	/*
-- 
2.34.1

