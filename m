Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023122.outbound.protection.outlook.com [40.107.162.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9239443AA8
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249305; cv=fail; b=oL22HrntAuQI11KTfSgWxwx6fbXnUv6w/JelhdfeUBct/5NBIHrZdKy0gAqjjNrjLRa/ieBYrWqetMNuedpLbFuQp/rXAvGYdYtmOiKHrOfYmfQdxs63AQuqayZrh62xJPWUM20m1yhSCkoNrEyLi2zBSd8KrK51eO1S3SnMmWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249305; c=relaxed/simple;
	bh=q/MVEqWlgKOVorB1K8JvfCBqp7OcFr5s4lAVTCgFJiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gnup2JmyfBO6B9FoukXCOGTNweRY5ERtphokmPAQUOMI9bEhs+w2/bUaHYPCyPdJYaCXsqmZ0X1EfkR5eSWafH8/3WGd+cts4EZtv8lqWesp77mJxjtvZlbL0CkGOTGdAPVvBuwHZLBofatGQSMabUTcr3ZPEQ0JUnkbEsjb3TM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=hHVIsBiT; arc=fail smtp.client-ip=40.107.162.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="hHVIsBiT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u/PAKrMkyzxpwGwfyAv22jx52x6fvJvvgtcJcUBZirqtkTIPt49ZH8UG7oZ+Qc7q8wq4/wJs57jLvlxhb6Za0MjgpprRdHvt1BLRtATcNKwlpdLSPcOvNgxv51VczRaiYkvgx8mvQ0PQLBiu8knabkMRbqgscXGZ/5PP1WxPMagGxTqlv2PT3sNexFQehYMPzhwsvfug7a0ibO+YVNLVUcsRPLbx/K9ixOpIOLDn0PufAmB0HYrHjcpP6Iiv7RT/O5ANovLJJm1fLY/wPpweL2mw5A6+W+tYpWphW7X6uZ+yQTUI1tjQ+lcWom7JkuhqIvA0QAMW0NEL+c2+h5ufCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UIDl2lA4X3Frocngxrq4jrzswgsBwNbqPNeNPyM088=;
 b=HH7okyDFxcKosegey8Ug+CO3eq6rja70VUw/QE98HIYupGaZrgNNoUCRY+8Px2ern3SHMA9EK29KHOdaT/O5Fl7GLoUCV7kGCS4/HT0z0wp8Ux+gV2ggp/xCRlJ60IZnm1SMIm2XzRu+lcvgdkvg2+DuCCuqw1zD37w3JbACnOIY81KOFR2+IEUOWclX5ZS0zvaBQdjHPTtnjjIxTrHeBB8JxwiMuwiQi/WkDf/+V9EhH9mZieoI21LNCwTPDYXsyUl3sUX4cnR2+VlmAVRJ9U4k0aLutSnie69aX2OeuFjjR/fVxYezZbndeV9s1Feoy5ydQr9C2LG1ap8UveXvbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UIDl2lA4X3Frocngxrq4jrzswgsBwNbqPNeNPyM088=;
 b=hHVIsBiTo2n5cf7IGu7QKGYTFqhpmCTF9c9MVBLhz0Z5s74GZt4TheCRTV71P+PApUlyPKbHv/5G5HjpOSSOE7UvdlPX77k4yYvPQE345ZsTIpwNO7I9Mp3tjXnD2s/PdhAiQ9GIvshbbl5qeY1kyuVgCopbSTEjw8dY81Ps+eM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
Received: from DB3PR08MB9011.eurprd08.prod.outlook.com (2603:10a6:10:431::12)
 by DBBPR08MB6314.eurprd08.prod.outlook.com (2603:10a6:10:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 14:34:58 +0000
Received: from DB3PR08MB9011.eurprd08.prod.outlook.com
 ([fe80::f6d3:4f5f:88a2:e500]) by DB3PR08MB9011.eurprd08.prod.outlook.com
 ([fe80::f6d3:4f5f:88a2:e500%6]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 14:34:58 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: bmarzins@redhat.com,
	gmazyland@gmail.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Shukai Ni <shukai.ni@kuleuven.be>,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: [PATCH v2 1/1] dm-integrity: replace forgeable discard filler with a keyed sector marker
Date: Tue, 28 Jul 2026 16:33:50 +0200
Message-ID: <20260728143350.44279-2-shukai.ni@kuleuven.be>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728143350.44279-1-shukai.ni@kuleuven.be>
References: <20260728143350.44279-1-shukai.ni@kuleuven.be>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0024.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::12) To DB3PR08MB9011.eurprd08.prod.outlook.com
 (2603:10a6:10:431::12)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB3PR08MB9011:EE_|DBBPR08MB6314:EE_
X-MS-Office365-Filtering-Correlation-Id: 39b96a21-a800-4904-3f67-08deecb5663e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|10070799003|786006|376014|6133799003|11063799006|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	g4oefnScsGBtI5IQz67BbjWhag5iT8OuMrLYlWFkmGZpDVbIDSYxOD136PpSPS0NTZPqgVBh/mXVd6gBjbI80MtTjfIgwLhvNb+nEgkqEs9/MEm3iwiW42pVnQIw0wcgLqAoBNL2OewySKKTuQFmh9kHWlWqCrno7UJc9FNEwsTlB9Q16oYnuOqTLM3+mPI5F4GPcFKUJWqeiJyOiHNnoVUz4a1geyvE/PLsA/Wj+vGoxAzRnDSpnPwb+3FErIxD14GHQmJF8vNH+pODCZ8uvt3irt7scojGrIJGmzE5iPK1q46sDjrnpksA0C7Hd4LTvl99sB9GNbtOo0zj+C22xHl9JPglfFKeIuEiE5ARYKZWWkhqWAzhe0DZ318imn8jHAokKP6GCaOUXihNbcnETJBPUqgYGp5FEsXDoIz5cDBST9zTIcwp1BztTq0MhEWM58lDnWdTPRW8YoLmTL/U771Cqz14wcZnQ+Gzi6T6wDYnoQHuu2MotXFf+2N+FMqg5e9IN+EK/knW69rEQz5xQct/acxmf43ObZPH7t/aOQVWPBoynfbE3Au/LhJdEmgf/eGlksFO0EMvHQTbgVAvkQlJW05UxqsmwJFXzRXdybiSAqK2OJWctMwQTsO7oPs3WTjVPHXzS6R5+R3AZqPbies8q/nskOE5oo++iVxAi/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR08MB9011.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(10070799003)(786006)(376014)(6133799003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pbRfPqWndieqWYoA8S0NZnVFUYhB/MCWJ9J0lTFp/5iWQcOpBGnOn4AXXK0W?=
 =?us-ascii?Q?ZR0qSq2g2lTLm8BdkZXNdtPyAMFGGWNZYAtZ3lnylZMmzyd3NjjT5H5HWFpH?=
 =?us-ascii?Q?Ia1gEPDKA9iDi9cIV36IbV1T/OfUsnyHJsGU/rTrXo9Ch5Q4EX3EjVj+qwEV?=
 =?us-ascii?Q?6vzGK9PBJHK3l2k8jjfXLfTnKi9tFfLd0dN7Jurdx4kSgzaWMNyvOcKpQ9P1?=
 =?us-ascii?Q?6er3Q6Kd9Y5cwcF0uLZ+O/XDSUWZMSQmm2e2flgbtP1yYLjzETTI0vAuhBoO?=
 =?us-ascii?Q?3R1ytW0meIPIgmzh+3ibkueMk3cm0C7xHoJqT0vslvUZSZcR7Tiss3xL57zP?=
 =?us-ascii?Q?Qy2Rvj6MEzbcnLtVVwcXZ8szvqtjcH2fdRcrsHUmZWbKGmh5l2NPjPrXU8Ic?=
 =?us-ascii?Q?nNIThdiGy2EPiKG6m96mEw2JuBbksRZUjIMJxltZrGEVlz0Nl4Rf0X15jyU9?=
 =?us-ascii?Q?bTkrPrHQ7RepsahLfCfqlY4QWQocVG78hIXdt0mk9rQPwYut0Azdc4gwPTZn?=
 =?us-ascii?Q?bra/ulPP3yTz4meZA2bdYwPw2VvWDJ6cnZiNSqkmEpdwm+OsIJA4/de5ur7v?=
 =?us-ascii?Q?inqiq3xyoqdsczk3FtLTnUF0191yMIajfDDOrf/B3ywsFabzxeByHRkhcW6n?=
 =?us-ascii?Q?YiKmAevqIyeKRWB/JAWhvzLgjVeZSRgsHhgfQFWDmFNb8fjFonR/3cFwvDTe?=
 =?us-ascii?Q?P7nu5+ety3Z2b4JHWjKyNuV80+UmPyNxY40/QAfZcDdhKrbqZeQh81iut2I0?=
 =?us-ascii?Q?octeoxP/37f0+BGlfCELuLzMkqX2oSjjrjmev9lO8uaroyav0L6Xvi+5Ktbb?=
 =?us-ascii?Q?x/XLai2oEz6AXYnQSlucN73TQxPS1j029Y+IIeslnE4hExBInugCwRJQLum7?=
 =?us-ascii?Q?vOYnqLeOGtGaYSAW5OK8/tgA9Iu7UV0OTOFXQXALAgcw3RATYSGHBoStkOr6?=
 =?us-ascii?Q?2xIuXdjAPMkVhxBiIFhmGApe9PkQvEzWd9tpa2ebpcuO16Fkas6BV7UKKzyQ?=
 =?us-ascii?Q?Vjq/MNawOjulNXTTVZMhTZIUjWyRSq8yZkZ266+NH2VNZIhPLLPNpJLAz3/y?=
 =?us-ascii?Q?pMpbfJqeVYliBwYGWkyiB2hYroVtSesB6isX2eKspqqvh5UWU16s3GCVImVD?=
 =?us-ascii?Q?LS93brzvUssQuPDZP6kBao7sRDVms87hGbJfqN/ntwhj3fW4WYXzfRVEuYNy?=
 =?us-ascii?Q?dxJB+YYv52JURWLLsQMgSqE/UtLwVJLHkSZ9wByoyiNpu36YN2EAAEKyJcQK?=
 =?us-ascii?Q?yhersqw7JMTGfcIDDscgXDMxtXtnwKAYLjSwE54mxJWYP8R3Y/28oTcU43WO?=
 =?us-ascii?Q?2TURWfqv1iXaHLB6iVzM+0YYmJMLNXt5fArOvEUdphXNcIEAJo7Wuhe+YDYP?=
 =?us-ascii?Q?Wln1NNs7fj2X1TYKwRK/09514j69iqMheuPsbR8928JItYp6Zg0WB6iM8ep3?=
 =?us-ascii?Q?QGgTFTZihb7wTVuTSaRfRxNyXNpiMQT5mfScYhSdkEoq8m9+fqdsMZLQdzIc?=
 =?us-ascii?Q?TH9vJAVzMn4qIckh9JasR//YKPswcv802xz/mWxru7ymjJryzXIB6vH8UR5r?=
 =?us-ascii?Q?x+iH9RNm22kIvaxKP2gj/z/7/+akZFB/3ajDnvCovtfoSNopE0zSmk/QRTWP?=
 =?us-ascii?Q?Ry/ou3AySZ5JVx6/8f9znA4AL8n8XrGs8dBX/0106kFcvgUCH9xwbecMSv5f?=
 =?us-ascii?Q?hVoBlWHXHmDCuGvRptC/gtzEvrmWy+YHHzlkTRU5ADqq8tJrCk19DSagGd1Y?=
 =?us-ascii?Q?zfuvttpnfpRlVQnHwca/2VGMAn68dBBUvoXfdVM0x3eZb/Kw7Fnj?=
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b96a21-a800-4904-3f67-08deecb5663e
X-MS-Exchange-CrossTenant-AuthSource: DB3PR08MB9011.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 14:34:58.2906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANawMsp8owDjoSzNLoa+q+Wo7LtnAaHHiZZImL1edE97kqoqypyzVohMLsCMLM70Gv+AYPvFg3KfULK3sukHKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6314

The discard-block check in dm_integrity_rw_tag() treats a stored tag
of all 0xf6 bytes (DISCARD_FILLER) as proof a block was discarded and
skips HMAC verification. allow_discards is only accepted in
dm-integrity's standalone mode. An attacker with raw write access to
the backing device, but without the integrity key, can stamp any block
with an all-0xf6 tag and have it served as authentic.

Add a new "allow_discards_keyed" target argument that marks discarded
blocks with a keyed checksum of (salt || sector) instead, computed by
integrity_discard_checksum().

Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Shukai Ni <shukai.ni@kuleuven.be>
---
 .../admin-guide/device-mapper/dm-ima.rst      |   7 +-
 .../device-mapper/dm-integrity.rst            |  13 ++
 drivers/md/dm-integrity.c                     | 122 +++++++++++++++---
 3 files changed, 121 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-ima.rst b/Documentation/admin-guide/device-mapper/dm-ima.rst
index a4aa50a82..2a3b50ffb 100644
--- a/Documentation/admin-guide/device-mapper/dm-ima.rst
+++ b/Documentation/admin-guide/device-mapper/dm-ima.rst
@@ -424,7 +424,8 @@ section above) has the following data format for 'integrity' target.
 
  target_attributes := <target_name> "," <target_version> "," <dev_name> "," <start>
                       <tag_size> "," <mode> "," [<meta_device> ","] [<block_size> ","] <recalculate> ","
-                      <allow_discards> "," <fix_padding> "," <fix_hmac> "," <legacy_recalculate> ","
+                      <allow_discards> "," <allow_discards_keyed> "," <fix_padding> "," <fix_hmac> ","
+                      <legacy_recalculate> ","
                       <journal_sectors> "," <interleave_sectors> "," <buffer_sectors> ";"
 
  target_name := "target_name=integrity"
@@ -438,6 +439,7 @@ section above) has the following data format for 'integrity' target.
  block_size := "block_size=" <N>
  recalculate := "recalculate=" <yes_no>
  allow_discards := "allow_discards=" <yes_no>
+ allow_discards_keyed := "allow_discards_keyed=" <yes_no>
  fix_padding := "fix_padding=" <yes_no>
  fix_hmac := "fix_hmac=" <yes_no>
  legacy_recalculate := "legacy_recalculate=" <yes_no>
@@ -455,7 +457,8 @@ section above) has the following data format for 'integrity' target.
  dm_version=4.45.0;
  name=integrity1,uuid=,major=253,minor=1,minor_count=1,num_targets=1;
  target_index=0,target_begin=0,target_len=7856,target_name=integrity,target_version=1.10.0,
- dev_name=253:0,start=0,tag_size=32,mode=J,recalculate=n,allow_discards=n,fix_padding=n,
+ dev_name=253:0,start=0,tag_size=32,mode=J,recalculate=n,allow_discards=n,
+ allow_discards_keyed=n,fix_padding=n,
  fix_hmac=n,legacy_recalculate=n,journal_sectors=88,interleave_sectors=32768,buffer_sectors=128;
 
 
diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index c2e18ecc0..9c2130142 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -190,6 +190,19 @@ allow_discards
 	Allow block discard requests (a.k.a. TRIM) for the integrity device.
 	Discards are only allowed to devices using internal hash.
 
+	A discarded block is marked with a constant filler tag that anyone
+	with raw write access to the backing device can forge without the
+	key. Use allow_discards_keyed instead on new volumes.
+
+allow_discards_keyed
+	Like allow_discards, but marks a discarded block with a keyed
+	checksum of the sector number, HMAC_key(salt || sector), instead of
+	the constant filler tag, so it can't be forged without the
+	integrity key.
+
+	Not compatible with volumes that already have discarded blocks
+	marked the old way; only use on a freshly formatted volume.
+
 fix_padding
 	Use a smaller padding of the tag area that is more
 	space-efficient. If this option is not present, large padding is
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 06e805902..03514eb27 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -91,6 +91,7 @@ struct superblock {
 #define SB_FLAG_FIXED_PADDING		0x8
 #define SB_FLAG_FIXED_HMAC		0x10
 #define SB_FLAG_INLINE			0x20
+#define SB_FLAG_DISCARD_KEYED		0x40
 
 #define	JOURNAL_ENTRY_ROUNDUP		8
 
@@ -277,6 +278,7 @@ struct dm_integrity_c {
 	bool recalculate_flag;
 	bool reset_recalculate_flag;
 	bool discard;
+	bool discard_keyed;
 	bool fix_padding;
 	bool fix_hmac;
 	bool legacy_recalculate;
@@ -1414,7 +1416,8 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 {
 	unsigned int hash_offset = 0;
 	unsigned char mismatch_hash = 0;
-	unsigned char mismatch_filler = !ic->discard;
+	bool discard_keyed = ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED);
+	unsigned char mismatch_filler = !ic->discard || discard_keyed;
 
 	do {
 		unsigned char *data, *dp;
@@ -1466,7 +1469,7 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 						}
 						hash_offset = 0;
 						mismatch_hash = 0;
-						mismatch_filler = !ic->discard;
+						mismatch_filler = !ic->discard || discard_keyed;
 					}
 				}
 			}
@@ -1645,7 +1648,8 @@ static void integrity_end_io(struct bio *bio)
 }
 
 static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t sector,
-					    const char *data, unsigned offset, char *result)
+					    const char *data, unsigned offset,
+					    unsigned int len, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
 	SHASH_DESC_ON_STACK(req, ic->internal_shash);
@@ -1674,10 +1678,12 @@ static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t
 		goto failed;
 	}
 
-	r = crypto_shash_update(req, data + offset, ic->sectors_per_block << SECTOR_SHIFT);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_update", r);
-		goto failed;
+	if (likely(len)) {
+		r = crypto_shash_update(req, data + offset, len);
+		if (unlikely(r < 0)) {
+			dm_integrity_io_error(ic, "crypto_shash_update", r);
+			goto failed;
+		}
 	}
 
 	r = crypto_shash_final(req, result);
@@ -1698,7 +1704,8 @@ static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t
 }
 
 static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
-					    sector_t sector, struct page *page, unsigned offset, char *result)
+					    sector_t sector, struct page *page, unsigned offset,
+					    unsigned int len, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
 	struct ahash_request *req;
@@ -1707,6 +1714,7 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 	int r;
 	unsigned int digest_size;
 	unsigned int nbytes = 0;
+	unsigned int nents = 1 + (len ? 1 : 0);
 
 	might_sleep();
 
@@ -1720,12 +1728,12 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done, &wait);
 
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
-		sg_init_table(sg, 3);
+		sg_init_table(sg, nents + 1);
 		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
 		nbytes += SALT_SIZE;
 		s++;
 	} else {
-		sg_init_table(sg, 2);
+		sg_init_table(sg, nents);
 	}
 
 	if (likely(!is_vmalloc_addr(&sector_le))) {
@@ -1738,8 +1746,10 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 	nbytes += sizeof(sector_le);
 	s++;
 
-	sg_set_page(s, page, ic->sectors_per_block << SECTOR_SHIFT, offset);
-	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
+	if (likely(len)) {
+		sg_set_page(s, page, len, offset);
+		nbytes += len;
+	}
 
 	ahash_request_set_crypt(req, sg, result, nbytes);
 
@@ -1763,10 +1773,40 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 static void integrity_sector_checksum(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
 				      sector_t sector, const char *data, unsigned offset, char *result)
 {
+	unsigned int len = ic->sectors_per_block << SECTOR_SHIFT;
+
 	if (likely(ic->internal_shash != NULL))
-		integrity_sector_checksum_shash(ic, sector, data, offset, result);
+		integrity_sector_checksum_shash(ic, sector, data, offset, len, result);
 	else
-		integrity_sector_checksum_ahash(ic, ahash_req, sector, (struct page *)data, offset, result);
+		integrity_sector_checksum_ahash(ic, ahash_req, sector, (struct page *)data,
+						 offset, len, result);
+}
+
+/*
+ * Authenticated marker for a discarded block: HMAC_key(salt || sector), with
+ * no data payload. Because a real data tag's input always covers a full
+ * block, its length differs from this marker's, so the two can never
+ * collide structurally, regardless of block content.
+ */
+static void integrity_discard_checksum(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
+				       sector_t sector, char *result)
+{
+	if (likely(ic->internal_shash != NULL))
+		integrity_sector_checksum_shash(ic, sector, NULL, 0, 0, result);
+	else
+		integrity_sector_checksum_ahash(ic, ahash_req, sector, NULL, 0, 0, result);
+}
+
+static void integrity_discard_fill_tags(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
+					unsigned char *checksums, sector_t *sector,
+					unsigned int blocks)
+{
+	unsigned int i;
+
+	for (i = 0; i < blocks; i++) {
+		integrity_discard_checksum(ic, ahash_req, *sector, checksums + i * ic->tag_size);
+		*sector += ic->sectors_per_block;
+	}
 }
 
 static void *integrity_kmap(struct dm_integrity_c *ic, struct page *p)
@@ -1795,6 +1835,29 @@ static void *integrity_identity(struct dm_integrity_c *ic, void *data)
 		return virt_to_page(data);
 }
 
+static int integrity_recheck_verify_tag(struct dm_integrity_io *dio, char *checksum,
+					char *on_disk_tag, sector_t logical_sector)
+{
+	struct dm_integrity_c *ic = dio->ic;
+	int r;
+
+	if (!(ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)))
+		return dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
+					   &dio->metadata_offset, ic->tag_size, TAG_CMP);
+
+	r = dm_integrity_rw_tag(ic, on_disk_tag, &dio->metadata_block,
+				&dio->metadata_offset, ic->tag_size, TAG_READ);
+	if (unlikely(r))
+		return r;
+
+	r = crypto_memneq(on_disk_tag, checksum, ic->tag_size);
+	if (unlikely(r)) {
+		integrity_discard_checksum(ic, &dio->ahash_req, logical_sector, checksum);
+		r = crypto_memneq(on_disk_tag, checksum, ic->tag_size);
+	}
+	return r;
+}
+
 static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
 {
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
@@ -1820,6 +1883,7 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 			char *mem;
 			char *buffer = page_to_virt(page);
 			unsigned int buffer_offset;
+			char on_disk_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 			int r;
 			struct dm_io_request io_req;
 			struct dm_io_region io_loc;
@@ -1847,8 +1911,8 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 			}
 
 			integrity_sector_checksum(ic, &dio->ahash_req, logical_sector, integrity_identity(ic, buffer), buffer_offset, checksum);
-			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
-						&dio->metadata_offset, ic->tag_size, TAG_CMP);
+			r = integrity_recheck_verify_tag(dio, checksum, on_disk_tag,
+							 logical_sector);
 			if (r) {
 				if (r > 0) {
 					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
@@ -1914,13 +1978,19 @@ static void integrity_metadata(struct work_struct *w)
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
 			unsigned int max_blocks = max_size / ic->tag_size;
+			sector_t sector = dio->range.logical_sector;
+			bool discard_keyed = ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED);
 
-			memset(checksums, DISCARD_FILLER, max_size);
+			if (!discard_keyed)
+				memset(checksums, DISCARD_FILLER, max_size);
 
 			while (bi_size) {
 				unsigned int this_step_blocks = bi_size >> (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
 
 				this_step_blocks = min(this_step_blocks, max_blocks);
+				if (discard_keyed)
+					integrity_discard_fill_tags(ic, &dio->ahash_req, checksums,
+								    &sector, this_step_blocks);
 				r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
 							this_step_blocks * ic->tag_size, TAG_WRITE);
 				if (unlikely(r)) {
@@ -3795,7 +3865,7 @@ static void dm_integrity_resume(struct dm_target *ti)
 
 	ic->wrote_to_journal = false;
 
-	flags = ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING);
+	flags = ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING | SB_FLAG_DISCARD_KEYED);
 	r = sync_rw_sb(ic, REQ_OP_READ);
 	if (r)
 		dm_integrity_io_error(ic, "reading superblock", r);
@@ -3955,6 +4025,7 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		arg_count += !!ic->journal_mac_alg.alg_string;
 		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0;
 		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) != 0;
+		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) != 0;
 		arg_count += ic->legacy_recalculate;
 		DMEMIT("%s %llu %u %c %u", ic->dev->name, ic->start,
 		       ic->tag_size, ic->mode, arg_count);
@@ -3968,6 +4039,8 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" reset_recalculate");
 		if (ic->discard)
 			DMEMIT(" allow_discards");
+		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) != 0)
+			DMEMIT(" allow_discards_keyed");
 		if (ic->mode != 'I')
 			DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
@@ -4017,6 +4090,8 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		DMEMIT(",recalculate=%c", (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) ?
 		       'y' : 'n');
 		DMEMIT(",allow_discards=%c", ic->discard ? 'y' : 'n');
+		DMEMIT(",allow_discards_keyed=%c",
+		       ((ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) != 0) ? 'y' : 'n');
 		DMEMIT(",fix_padding=%c",
 		       ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0) ? 'y' : 'n');
 		DMEMIT(",fix_hmac=%c",
@@ -4178,6 +4253,9 @@ static int initialize_superblock(struct dm_integrity_c *ic,
 		get_random_bytes(ic->sb->salt, SALT_SIZE);
 	}
 
+	if (ic->discard_keyed)
+		ic->sb->flags |= cpu_to_le32(SB_FLAG_DISCARD_KEYED);
+
 	if (!ic->meta_dev) {
 		if (ic->fix_padding)
 			ic->sb->flags |= cpu_to_le32(SB_FLAG_FIXED_PADDING);
@@ -4835,6 +4913,9 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 			ic->reset_recalculate_flag = true;
 		} else if (!strcmp(opt_string, "allow_discards")) {
 			ic->discard = true;
+		} else if (!strcmp(opt_string, "allow_discards_keyed")) {
+			ic->discard = true;
+			ic->discard_keyed = true;
 		} else if (!strcmp(opt_string, "fix_padding")) {
 			ic->fix_padding = true;
 		} else if (!strcmp(opt_string, "fix_hmac")) {
@@ -5212,6 +5293,9 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		ic->sb->recalc_sector = cpu_to_le64(0);
 	}
 
+	if (ic->discard_keyed)
+		ic->sb->flags |= cpu_to_le32(SB_FLAG_DISCARD_KEYED);
+
 	if (ic->internal_hash) {
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc",
 						WQ_MEM_RECLAIM | WQ_PERCPU, 1);
@@ -5430,7 +5514,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 14, 0},
+	.version		= {1, 15, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,
-- 
2.53.0

