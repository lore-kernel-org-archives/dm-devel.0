Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2065.outbound.protection.outlook.com [40.107.117.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696A31AED31
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 15:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720106172; cv=fail; b=BK19XgT7b+kYOEzt7hKXzqeubxt5DGVEm9uqajcksYbEasrC+/T4bgv25Slmu2bmmlD7fzj66oWlKaAxcqBFGQR0hgmUSexti3lRborO4wIevnIFqP8+BB8pZcSLd7oNzmjKoPPcQZhhGUUvG6dItYTXHBH9nPQFKYxzAwKxQ2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720106172; c=relaxed/simple;
	bh=nXFinQnBAd1xm/9eHyaw8QejyQvuhEUGNDZH8qEeQDo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=K9/HThJW1fJvqKICsQATgofDJ2XoNSoLg/l/FrUKwaZL5MfoCCYXyx/C/FFEo1RjQzCjz03agTP27y2FiR73wPDOiL+vkDgUwdFlC8sCVsZusz6wKxLqE3Yfa74yHAN+kylBggFIMO+iuhPA1sOuAjkxuEI8YR6SRo4v3raRq2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=gNtwMfCu; arc=fail smtp.client-ip=40.107.117.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="gNtwMfCu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkqaifTQOVJ74t9GRdw/uGJfRh4qDA+CcUwh296usHC/yJtGqoDxK9WCAODZAJlvmxSpKDl1jGVoKOAPuwChpgnzYXoxBq/RJ7yeBpS30vzsYA5f18hn/h3UOvVFRLYN+4w8d00nhMGFvfPck6zpSrTZBnc5RRm1yNFte9/4BlYeT/8siIq09LWEJQBi155iFX9MIRo5ZX7VysHqVKcz2hfGSI+3QpUYP9Z3NE1Mlk2Lil3XS2qQxqj/GBpNRttPkvT+83jeUDMPIQvBpshBzOIHB85Mfzm3iZNbvw31n3vdhsyHxGg3qq9UBqOHgKaIvQNW86hre01ZJTleHqMimA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eays4tzKvtGDLwMumKQ/VatrKrcLB6kYF1i0S6zA740=;
 b=Wxd58hGf9pSysjfRZDzZhWQKy4JGEtrmCePt1wYAty6IMdiP5K7hGfZj+ct76BUOS8T4woaw4RBw/rfF3S3WSw4RWpLlTCCswdm25VUyMiW2cy+sSNcsXBNNOQaiqQ0bxHFzHbAEGgJx/X1ejdH7l2K5rx5AfFh3h/E/ObA6pX9+yHnJJQLBnqU2cLePOJoXs+/jLSXO/I2VmdxiViIBP2Qb7thZvaF0A+3XlOIHaahoXTaE+5oehd2b1m/pXTPEYp/bbvjE/9ebiPm3wVagNjfV4zc0KaC4bh5WdOYCGW0CXzw8jbRulCzXUkEjeSNL9S5tdEQ18DfbWGhM4ScQZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eays4tzKvtGDLwMumKQ/VatrKrcLB6kYF1i0S6zA740=;
 b=gNtwMfCuPl8V2hWC4G7uuDyhu4DQaAFbZvyWBgAfW3C+O6TMu9XNLr65uQLjAtbD+J3St4qCjP8K2KApBFOwLP8si3HT2caSnaM3xLfMktc2HD4riTw0H9tYFGQ2j//iT74OwsIYfsbHA5Ex14FWVw/9p0Xj2SozmTpqWv+bH3QiClh/qVxYwuHgVjFeZM/WJ1pztawLerdxIpcR77ZZY/lvdOe/CNCJAOhz2GCWt5mlN0WtgnNKXLx/oRtD2BLiSabgLbjS3GYmAJUteWbDWSjP8nxy3F3+jMGsPUYuLvOinmDYpb7b31N934l/cJnNfrj9jzACJs2W3oTatP3fzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5022.apcprd06.prod.outlook.com (2603:1096:101:48::5)
 by SEYPR06MB6183.apcprd06.prod.outlook.com (2603:1096:101:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.30; Thu, 4 Jul
 2024 15:16:02 +0000
Received: from SEZPR06MB5022.apcprd06.prod.outlook.com
 ([fe80::710a:6dd4:e9a6:59a7]) by SEZPR06MB5022.apcprd06.prod.outlook.com
 ([fe80::710a:6dd4:e9a6:59a7%6]) with mapi id 15.20.7719.029; Thu, 4 Jul 2024
 15:16:02 +0000
From: Li Dong <lidong@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Cc: opensource.kernel@vivo.com,
	lidong@vivo.com
Subject: [PATCH] dm-table:fix zone block_device not aligned with zonesize
Date: Thu,  4 Jul 2024 23:15:25 +0800
Message-Id: <20240704151549.1365-1-lidong@vivo.com>
X-Mailer: git-send-email 2.31.1.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0187.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::12) To SEZPR06MB5022.apcprd06.prod.outlook.com
 (2603:1096:101:48::5)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5022:EE_|SEYPR06MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: 43d4eb34-be46-4cf9-9eb3-08dc9c3c3783
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8VqtIQYGK1Qc1nGmTcqNnzQbQ2QjOONjGOiuKLJjRjG8JVQVtADHgslz4H0j?=
 =?us-ascii?Q?+gKQbc4o1tF0oyxR4YQnh7BiKmiYJrZu6wMzKH1+DUjRh0OpxzOhFrVHP/zy?=
 =?us-ascii?Q?OdZZV49IGz3bFXwUSnEbNHyl8EHhhLnSJgzoNsd3lxDf4A/awCIK1mWNnK3i?=
 =?us-ascii?Q?V39cqOZ2P2C63Jx4RWYw/xUnS2474ETFdXf5hbwo7zJoteCUYXo5GN/1GVk/?=
 =?us-ascii?Q?XzNhuewxccbol6tsfeVleFq15pO42EHkOCyHc6fdrudgWJzr41a0GQDQYVq4?=
 =?us-ascii?Q?8WyAplALk/fSHmPM8VTj3qGN+1cH6d76D9E2Wn5EIwyuLgT5HrgrIYX/u30R?=
 =?us-ascii?Q?IBChOWog/2MgZLKtEpQLgsoyLErxL+VXv3JdOu3z/6Or5cRGmidSWckoFfcK?=
 =?us-ascii?Q?gycnCbrsJXM6KYiktzXjCA9rPpmoahglA892ePjAAx2A+OvbkL/YNnpcQ+rz?=
 =?us-ascii?Q?9ql/aE1XGi4fZaphAp3oJBNy0aQTIIzUnsM1z/eUcJweobemBVQTbyL83FGj?=
 =?us-ascii?Q?k3CGS4VArB5JeqYmP+psGZ/aLqfbMKx2hL4U40ijrkFdgITHZWc5abyoJ41W?=
 =?us-ascii?Q?wtCWJ0qVNFs/phhNE4JJIro73Bad+ekfrmWJt5B0l0bUGZjUNyAvaIGTo0t1?=
 =?us-ascii?Q?pW4XG/oFkcrtxkEoDADlVezNEYP5poJ9nJzfk+B/U1s5ZvIzJ+117J3CNZKg?=
 =?us-ascii?Q?gQO7vLZobULzxGm2solK7ltoSHFWfMHDYxbSVxLGMQ7+0oXluD0SHu1NpVUU?=
 =?us-ascii?Q?tbnI5W3HukxAyglboPoiDheIwPXFrQZc7v61KlSvitIftRaWbywh8mQu5UC5?=
 =?us-ascii?Q?yBw6SbLBHlfI7rh8281zQEO70CHANiWtjma+tC79oDmrek9e0+cn/xMPa9XE?=
 =?us-ascii?Q?3EkgW+6999tpCUhdFZZDwkoOiT+vNIjzKgKgSG0fWT4IChlv9URCPHqkdtvF?=
 =?us-ascii?Q?cPUEYkQ2sfkQ57REyVL2+8qnj8GWoRVElYwg7LQCvsbNQshNugE4lDtd2wbE?=
 =?us-ascii?Q?tWvdVniEDtyD/sCTH23hcE4O3xbv8q5Gv59JsYHVxUZgIlMldLSfdbG5tWPA?=
 =?us-ascii?Q?MsvJIUu3VOCevECS0VVJYqTTcFbwHCVX1hZzI6oeW6baXOCMBloCenUar2Lu?=
 =?us-ascii?Q?7KogI9jaqlKP0S9FpUPhL7LDXdtcqHLltKXUX8fST12aLOISjlksgO4Ae0HO?=
 =?us-ascii?Q?xzZ4MWsyQUtwzYx3irm/9L/Wddtixa2D8otqz9HKr5OqS4uflrCCmMlDN1Dk?=
 =?us-ascii?Q?zktQ8BY+GiR03V/AwH5hmhoLFjFfQ8qQcrWa51r/ljmGvvPAyrNY/5GJE7TQ?=
 =?us-ascii?Q?XK/Q7MhHbVINprPpWzSZQ/1v4E4ih72nGpBPppwCzk5wZULS97PRsz1EeGwl?=
 =?us-ascii?Q?iFMkm0RlJssTR900WJVJgniQCYoUW/g3MGXmRt4aj/NLZYc1qg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5022.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?elR9i7OJugiua9ULuPV3gCvz9ksTI/OE8jfldAqx5YrV4KCSslJtItmXg2wW?=
 =?us-ascii?Q?/D+lsxTkvsytFI3AxCk83znYjb+WCmE3sjOPMQ/GctQR3BB5crtJWDsvlWpi?=
 =?us-ascii?Q?dhXv4fQMAh5sROa2wXJd3XdgABACBw+hcecaIv91oW0vm5Uz+Y/C1M/l0uT+?=
 =?us-ascii?Q?7meo50ZTo3csoA1En9dzLCiNxlEQZy/JbvVBHppj9emrw424d86suzBzo1au?=
 =?us-ascii?Q?qFmiit/NFaG2Ks4aCV/lBAPQyq0pR+WK+wn29GRiiMCtBl+RzWj3e/nbZJxJ?=
 =?us-ascii?Q?tPX8jYgGAYJ37A4Cv8Oe4Z/Naxf68ccRhvjwKLTVMZ2D2Ubp+QPnDQ1Ymraa?=
 =?us-ascii?Q?DbMQ1Fjg6KNhE4uMP0QqH9TbjBU59srdMC5vTUEd64U3r5yLD/pl6SmXRQao?=
 =?us-ascii?Q?zmpvEWyFjBYypeoYrIF9IW61KYFczr9WcuLTHTtejvQq7A9sraJxGON52vcL?=
 =?us-ascii?Q?R6sP9CwaZqv/ukPKZbSsDJKX+LRwn7N4i+sfZKNaWgV9phSCJuLGZ+j8Vjee?=
 =?us-ascii?Q?nSLriQyj98KSc7EPyaDcbT7wu7Ofi3mYm+nqwzuei+rD6QOuAgpllRGiivDZ?=
 =?us-ascii?Q?XAw9jnswgXwPVYdR3P1gMh7GixKEL3AnpLY8rSFVrEWzVIJk8a6TIfasun83?=
 =?us-ascii?Q?QaTGIe6nKUTH/94zuxoHuj6FAk7tv3HhrFMhROmhGEgCF5NXxPyPJf13rALX?=
 =?us-ascii?Q?hSdBm9XInOCok18tjHYiK6uCfctg/8QLcoDPszQXu4ocT4+8c1VQ6xv9GloW?=
 =?us-ascii?Q?PsObp3wL1GQlcQ33c7ixI5DjggPSOOdV33dK/Wc3uVtfIJQ0kOeZm02CePkE?=
 =?us-ascii?Q?ny8jYn0sg52FYwvQvGv0jZQGI6Y7nSTLDfsmylyIFPSo3F4x+loKgDFuntnO?=
 =?us-ascii?Q?OnGUo2k5PN8YgIJs+cm0s1NLniJ+5xRcA/UYzKDoZmUChMg958WagipyVzhb?=
 =?us-ascii?Q?OZSZ5gVYBCEQSfI6c0fY5W5QqLvcEhl9bDImiF0K1feHQOBdSOT5lyNYh65/?=
 =?us-ascii?Q?YGXIyE8piKiw3trwXpUhpwTA/IH+RsMuGIbZkLoKAPefxokC4L3BxOPgfOsF?=
 =?us-ascii?Q?xmmTjpSGNcdttkDTQekP8yT1lOpF8wvs6czmEFs4FoFdoAj8oyvpFSZ0LS7u?=
 =?us-ascii?Q?Qp/xNC3TvI1GU/WIj3zhPe5L01YKL1VqvwZPaoJ3WQ4igac3GYIVCvjRYpjb?=
 =?us-ascii?Q?H9D++vR+ZFgLUXZPpsWNl1wr5i45XOUecdfTu0s1Z/1Qn52P3tVMgrpuochf?=
 =?us-ascii?Q?5IpV3HAtS2POi8VXkcay+i8rixB7NfyH+TZZ54yEVrc3O4q6ZfAajsBom2BT?=
 =?us-ascii?Q?w9WObxEyBiQmyoQU1uk1Wto1kZjfrIOTSobDdXwvJtoQgET3XmPaHDyrmoD1?=
 =?us-ascii?Q?YjPeDky9eO9kna86GUsUwov/6wpynH9cL3970+64bgz7pi8zoJNCkHwBbQS0?=
 =?us-ascii?Q?Mnb+WrY/3+MDQDgnNhLFuOGntY2mTdw3s95hA/HW5PStE4RW71S57Hzhg2zV?=
 =?us-ascii?Q?B3Hs6VG3wg4TRbLZQcyPs9zLKuqRnTcL9tDo5iOqtI4CNOmYK/fHVxvjZbPY?=
 =?us-ascii?Q?pNnrJ9FJ6F7XynaHxeR5iWy0nWc7BQaY9u3NIw2o?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d4eb34-be46-4cf9-9eb3-08dc9c3c3783
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5022.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 15:16:02.5102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ODh43YV/zriKmtYA4bsMNJER0D5M+vvHUOsqrRce+35B1iuAeG6InokgrsCH8cx3PJqLP+OOclXiSHF+SN7MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6183

For zone block devices, device_area_is_invalid may return an incorrect 
value.

Failure log:
[   19.337657]: device-mapper: table: 254:56: len=836960256 not aligned to
h/w zone size 3244032 of sde
[   19.337665]: device-mapper: core: Cannot calculate initial queue limits
[   19.337667]: device-mapper: ioctl: unable to set up device queue for 
new table.

Actually, the device's zone length is aligned to the zonesize.

Fixes: 5dea271b6d87 ("dm table: pass correct dev area size to device_area_is_valid")
Signed-off-by: Li Dong <lidong@vivo.com>
---
 drivers/md/dm-table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 33b7a1844ed4..0bddae0bee3c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -257,7 +257,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (start & (zone_sectors - 1)) {
+		if (start % zone_sectors) {
 			DMERR("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)start,
@@ -274,7 +274,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (len % zone_sectors) {
 			DMERR("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)len,
-- 
2.31.1.windows.1

