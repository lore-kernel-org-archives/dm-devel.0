Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021096.outbound.protection.outlook.com [52.101.65.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E5822338
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 03:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753069792; cv=fail; b=XTv3poaq9VyqZ61xFXzvjnQUw+rcSJgcl/FbSoiD01zArZ/2eP3mesKP2gVKr5r0yDUDprkWUb5q+znOeOpdFUOoCF5Vv530pMkW8NMqLNscn7geqHqEsMsucw4Cw53kQ3IOQgc/2o8dy4426bBDRVIYyEHPG1MvMoTppQB7Whg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753069792; c=relaxed/simple;
	bh=UmD6C0wE1JCyqkLUAJLZVGJwoURcUo//gxSFwp1ZIDc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=H/oE9X+fawhC6nOog4cpdfdKNVVuIRjgW4SrFE5yvKVE5LXLZo4pYIOnfrlayahfW1gTb8vfuhi4cmYFewpgVkeq8fs7VtUd/8KBqkDgqqed0XFc/L29s/WmavlHM3okabOR4FV5lGZPAF0WVqNmTzQizF+B77JimEfFNJUoxgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=z9n6Lxzb; arc=fail smtp.client-ip=52.101.65.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="z9n6Lxzb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bOgHo3IWUQxv727eyZCDEb/h7cvLAG3HphE92X48emHft5xYOngYcbyHvQJuKMGzcL13MwB6BxTJ517y5xP4zs5BBo4DbImvuxKiQSczJdRmDa0gU4fzsy6gTSjvrT8eX81xi6kqH92m/+mlFVDTK2L3ZxhWsVH/exre6MO94Zz8fpVpo3fAtI/lq5kWCYKY8Q+0txNKWdsGbahjqSgnYOfXWADimUc7nB6cF6yMAmQwd0qcZ3tA94n3gK7ei4VeVVccOd52sZX10CqfwcSfZY7BLAQzSXgPvnsnUPMztVIQ1A4lrhFOEes9qF4EleQctvR/uoaNhHi7ni6h2au7Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEpd+KQFBu0nO98X2s9tlXv8nq4HhWAn5HYMhP0MSdw=;
 b=PVMAy6CpJAxr5m/nK+mRH53pAEcwoM1ldXK1cGr+UrOQF1VnBxGFF9jBkURk7NPn/gN6amia2F5NgI2BdnuvT9e+N4ZMz2oU/MZLNbELN6ujASYSvVy4hiXMqDSjs8OOFlxoGlV+PcXY847aDgaPVinGFWveGjI7t60MLR7wteormRzCbStNLxt2yu6bjkpKpZGLme6sQyyQg8xbaga3kOoMYlM1iCodTgH/l91k2Isaaa7QMveAYgbARFaensPHpEkys7crtc+yZfiz5DrMM940UbYo07wzL5lUUHAlJPkTc/rjg8IRsq/q46SFEBAwKIPnIUQFsdgLxI3W/lqamg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEpd+KQFBu0nO98X2s9tlXv8nq4HhWAn5HYMhP0MSdw=;
 b=z9n6LxzbBNSM3qbK9wA2v0JM6oNquIY02oLINWl/GJ3x39lwXhoQjxbmWukUOte9k/q2uSjM1FvGfrDpRJjk+IfxC16xgigsLcfTS+H6dVx1pQbsmCyvBASwdcaizzwYbn4sp5SwfN3zaHS3ds9jeuS4kwm1uzyZt4k3R6b0eHi179XkBJrVUpb1ibhPpTjZB9ZYiaQKXaShJ1iy8YEDgIW+/5eKLkw3VKh4LxhkKZmTUNf8FxkAvjEgPd/YN2jPu8aFcEdxHfYfpKDLklaPmNb224E5KqHLSWlKQdXSOCK1/4M98VPsdv3+tUKPMxq9oxa0rn0eOmmuliXdPV5eQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by PA4PR08MB6192.eurprd08.prod.outlook.com (2603:10a6:102:ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 03:49:46 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::7261:fca8:8c2e:29ce]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::7261:fca8:8c2e:29ce%4]) with mapi id 15.20.8901.023; Mon, 21 Jul 2025
 03:49:46 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Konstantin Khorenko <khorenko@virtuozzo.com>,
	Denis Lunev <den@virtuozzo.com>
Subject: [PATCH] dm-raid: do not include dm-core.h
Date: Mon, 21 Jul 2025 11:49:13 +0800
Message-ID: <20250721034929.374552-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.50.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KUZPR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:d10:30::19) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|PA4PR08MB6192:EE_
X-MS-Office365-Filtering-Correlation-Id: 00464900-65f1-46d7-25ca-08ddc809a238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QmEtA2M23edIm4iIsR7XdhrMKE8xee8ZP6zB47RM6LJemRk1wjktnVCghcFv?=
 =?us-ascii?Q?5TFWLzTwqaOuTl1e0ljbawNhJ5Ja7XLV1Fqb7aCBJm8wX5kdTbUoYITAQCjt?=
 =?us-ascii?Q?lJ9Fih+u8SOMnb493CPkmES98wLvSzIi1Or/wxP3pCBUqgsZ4nDOqmn+ij4K?=
 =?us-ascii?Q?ncANngHSkiSMbtVcNqRWgDRgvTunEU/6bpecw1A00GRMKzkSz/P+afcu5Xl5?=
 =?us-ascii?Q?nw7/YT8v52fdPu3kuUU7hNNVlMFOGD2iLQ95/eNc819j1bC7t3wsX+qgXy1n?=
 =?us-ascii?Q?Znq/QUbpPmRXh1l1e8My/vHtvvMOdHxJuFiQTZxJYSP31jpXG8pihgNOIctu?=
 =?us-ascii?Q?XMRh55HmHYd3ROV8kHwqr5/fE25zAwpQ8JsKoPRbvI8i5M3KfyfXPyZB8wxV?=
 =?us-ascii?Q?7Dl9+EFdaEFHZHL9ycbQ4iegCDDAY3pNDLBbGSy4P1hTHjy6OerK4q+s9DWY?=
 =?us-ascii?Q?vvmoU1+JEWdGsqo79RZV7qeUoRHh2RzJHGtNOvUSX+onmecT8tbMCXp6aaV8?=
 =?us-ascii?Q?VUSt6GDQkvs5M5Jo2vSEGeobmujfCsKwUR/Ye5EC+tW508sVBcJRl12irY/Y?=
 =?us-ascii?Q?z1WK2CvUUG7USGOB3DLW7eL3hmmnRId0cgJL4iUd+DWz+xbNG1q8vxTvjuQn?=
 =?us-ascii?Q?ATiE7ky1/NcAumgV2Xy6N6LExDUk1iULLChdBx2/AGPHVEfaLkkx/pk+fyr1?=
 =?us-ascii?Q?3O0CVW2WexqQi2gpzmsVyRJe14/NASgFeZ4XeOUfGSRWZZ/6y10j30O1go9M?=
 =?us-ascii?Q?wRGoTLPJ7AsvuWg74R8n6FK86oftU4667G0VyJDYCm1b8MX6lWR6BnaGT5kH?=
 =?us-ascii?Q?KkDd+mLRgrJgjTyS7VTM3lkKdytqPt1unWkg6tMSzv2PSwqk7v87dRjYnlMF?=
 =?us-ascii?Q?UOhCv5KkSXGpJX+n82NIklcppKpclNWEDFpMDB2GxVfLUaIWDHo+/sAdWQql?=
 =?us-ascii?Q?eydBjUhwq4LaPfEyhV7toXLQeTWhHk6+Z5mq8+3Vosn6Dl3NX3/YmuQkn4+S?=
 =?us-ascii?Q?adxzZUpJhjZ3cLArtcshgEZP2URWu96lQ0pyRSnhmAA6tTbQsjANuzGs2O5P?=
 =?us-ascii?Q?X3odmiNHF3lEtVT00TOCs72CCgGKKAIIQ6BZ/v4q0PU0wLUaFDM+knRo179q?=
 =?us-ascii?Q?1iptrm5USbD24TbW5yDtURJjkgHDud1BW/m7l8o9vzHYqwExu6SzCnEOaAL6?=
 =?us-ascii?Q?x0WFSA3S+zprMf+1noEV1Oq39HdXB0Gr1REmOGbRYuNT82w3c4qTivbXWZA7?=
 =?us-ascii?Q?EW1OJw8C8m1Y/kpENnfYSsFbWxHxwH1WNbSCUxtGUXAItEPrcAJPAbyYuq/d?=
 =?us-ascii?Q?sO45rVtntsVh39Aj/vljFGUp4GIls5SdCuNOfwCPOBI2w7E+i5hMXh8+A3YY?=
 =?us-ascii?Q?2LJjEsTnZ9lSUEjqNTNpN3f8qRA2MbtPfznxuGQTSqKbPextGDGHIpx9fSuC?=
 =?us-ascii?Q?z/ifvIAaKH4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JWzWuTyX+I/nU8PorCPXhrymai/wriiGp9rqQBtijCTszRiEYTk3iWJlwyok?=
 =?us-ascii?Q?+gV7UvQfs2Jobk+D6DYDCuWxaYgzCyGpJEG5QpOBEPkiz0BKkZd/vAIkXudw?=
 =?us-ascii?Q?xZVZpuo4XCkso/nwf6MvuC4cm/ad70AJ+CPuDErlzp0Uh3Vg0gSXIHWA7fq1?=
 =?us-ascii?Q?6YtXwkrV2Hw4bgi/SXsjamrkE3qfHh4aK/MXyZ0GJSkyPUnm5Y8PSLxIubWd?=
 =?us-ascii?Q?icx+tiAcswqG78aYh//cGPjokn8ZxZZD9StDCNiROOgfOSCCGWuA6O0/jRyN?=
 =?us-ascii?Q?BNw6Hfbmr0fPgUmDXK8SK4DdjdtdDfbeCPV75dAamEYgAjINedLHWKjrwFxG?=
 =?us-ascii?Q?o/LZq2mULZXPD7KGfZe7D2YG7oj+S+HAyNYWWU2wO90woIgD+S1GAnpaR79n?=
 =?us-ascii?Q?Cru/du1wwH0qU8XkWnY9PiG5xWd01k6Ck7iVZAOAgY+DJ7FP2XwoFwNapRKB?=
 =?us-ascii?Q?YY7e6OkDuIDns4umQfEJ37xVEvzfvdoOdh5S4vJ2ENiZj4gzfueHJBeYo0/O?=
 =?us-ascii?Q?Sh2Zc9J+kVyU5EwA9DU3Ja9N9JQzRGThuwYX4Wf2bHQK9NO5fqc5nCR+qNzS?=
 =?us-ascii?Q?fl81JLoFiBaSFPIikJ4cfDrHSJ3puTug0dK35aS21zwEqiWeVaRVg3TeKq3J?=
 =?us-ascii?Q?ekAHIRyKwP9k10OLZvQFgOEgZMxxfKpB+/eNrYVIs496PCNp3YX6TJh7zfWg?=
 =?us-ascii?Q?qtuXI/A4Dk7qC9y37LzpJtS/I7Ya7AX7bi9jYl9WxIEEdoGyl6dGCaAuOb/J?=
 =?us-ascii?Q?4cc/Cb92CYUDLWvsZTy6F3H0TiMRfVM11NJdGotEhwRBJ28gLhrxtxUZSkDH?=
 =?us-ascii?Q?CbSuHVXCcKZFIXgG0iK8BHSH/Csc3A5P7NVPmsKdoidw/ywBBpcQrJwMCAT5?=
 =?us-ascii?Q?qiOQrFQZuFKzIOe5YQOtp+capHxfTNSD4hrnVtLsHl4scRXBefsPVYACTb3J?=
 =?us-ascii?Q?BYTwVq9NSVbV47SLG3+5PlooUA8jpkeuiN7KoTKIFvs5FlMJW7aANtuWEcTQ?=
 =?us-ascii?Q?9Ad3deIwsh1pDPPkMfxjg+MShJu5t98APifHLx2V2xdjZqC6CcOHXsNhSaIJ?=
 =?us-ascii?Q?5F00mOs1BQn2ZnwDF9siaVZgn6jniQfeFYyED/d2NkBQ93klmomY9V8T9QwE?=
 =?us-ascii?Q?8w1Jg8QvJbxfDPRFPbbaZS6//9MQHRkoVR6eRa5yzFLHMW/PbMlpD83ZCkDc?=
 =?us-ascii?Q?blfvPvsVFBzndQvPVQ+aCt1N7aaUCHlH3OgexSOYqkt8dZGHWFxm3RxXFFrC?=
 =?us-ascii?Q?HI5aAFOVIOWVfnjKPPgmsYMkS6OmQZsD4jG6RGRSwDQkFnouXIqB9TS93eQq?=
 =?us-ascii?Q?zbCSl3z+oiZhrxgMfLUZSZ/EjnleocWugznDSOhyO0hHLXv39ekiaNPmN6Pl?=
 =?us-ascii?Q?YFrZGxwYMv3goRIg4lvh/70n5CQCBVfSNyj2sI90YZpzAZZT6cMNPBhHma6C?=
 =?us-ascii?Q?kKwULAvcVqx7YZIgUNMuTMdP/2VIYz7unBQyZ8LDq0E1D3Alxf94FOkY59y2?=
 =?us-ascii?Q?zdrFDZUT+gia7Rg5lBPdx18ZTiRSKbE4FzdX9joWbcT9tsBngECFA3GrAS2h?=
 =?us-ascii?Q?43y0fgRK5O4H6x8tTDUDTY2+TtcRsDtZr8bmzyghA5o2YPowMFxSZ0C7fhGL?=
 =?us-ascii?Q?epi4cTBkAQREjDVOhcKG7BOG5jL19niKYOEs8Zr0/n8W5k8r/FfcvWjuJ2+r?=
 =?us-ascii?Q?2OD32g=3D=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00464900-65f1-46d7-25ca-08ddc809a238
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 03:49:46.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wW9QgsVlNrVHlS4SPw8pXgyHYM2YDhuMIToEdJag0+NQGcLnxBxoctHuLbKrJfhTMn9OEbPfe2HY2hPzajjByeEDL8wOJSuSsqgbdbzD8ZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6192

In commit 4cc96131afce ("dm: move request-based code out to dm-rq.[hc]")
we have a note: "DM targets should _never_ include dm-core.h!". And it
is not used in any DM targets except dm-raid now, so let's remove it
from dm-raid for consistency, also use special helpers instead of
accessing dm_table and mapper_device fields directly. This change is
merely a cleanup and should not affect functionality.

Fixes: 7168be3c8a6b ("md: record dm-raid gendisk in mddev")
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 drivers/md/dm-raid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e8c0a8c6fb51..4fb5ddf50560 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -14,7 +14,6 @@
 #include "raid5.h"
 #include "raid10.h"
 #include "md-bitmap.h"
-#include "dm-core.h"
 
 #include <linux/device-mapper.h>
 
@@ -3305,7 +3304,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Disable/enable discard support on raid set. */
 	configure_discard_support(rs);
-	rs->md.dm_gendisk = ti->table->md->disk;
+	rs->md.dm_gendisk = dm_disk(dm_table_get_md(ti->table));
 
 	mddev_unlock(&rs->md);
 	return 0;
-- 
2.50.0

