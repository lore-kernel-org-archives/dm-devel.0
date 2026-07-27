Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021097.outbound.protection.outlook.com [52.101.65.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703D13E3D98
	for <dm-devel@lists.linux.dev>; Mon, 27 Jul 2026 13:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785160137; cv=fail; b=LzmH9+YyhCkZmPdY1VfdiIcWdJ++g0xEMRyG8dYOSc6OFPPC3DRXl8n3ZSznulI3thcaNj4FnS6UJaXaCSJhvqFrzNWNvYzO+o5i4z4d8ANarDouWsjEQFhVEO+JtQcutUu404qs29HyEDk8OYWjfmNImkkdAzHCc+dV1fkk5Gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785160137; c=relaxed/simple;
	bh=FrxSodOdjRbcxWzyETqMfL5w2alsbB1dc87vEF9puok=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=B83KqHfRV0e4B2K6uhCESD1guvom9eWaPM3rPPtjTEDGUJGxt5qxqiEoN8+Z07yHE9ZpgfnMiAcDAY6CW8Aupr96maLQrPRt8ZxGyZFq0vxSXUD+YJF2AxUrF61vV8LTd6d9xHGxNMYC71LPXqTqD6IVybz6ObXIYc0j1NQqAWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=NHn/8edU; arc=fail smtp.client-ip=52.101.65.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="NHn/8edU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HLs/5WbkiMFOLjBJU638ALtK+HWSXYdAQn4RSOFatM3ua+zgNRaeTVjLeVPHb9crIKdr6tifOjq9nVO/9bgaALyU6m5rfyomTjLxH5lGOpGFc4YWFhpmG5/TrA3tn/KuK4A4ftD8ZsD3rmj8QPkJYfaENOldt84MoxiP/0O+dml6kTUwl2ZDRb84l0aDBvgiC35fyhJO23sdGANAoeKyLHCFAQ7N7MQMlVS++8TBck1/REN5aCh2JT10M6sTyE4KohqFo4K/0+uGTx8OPic/ULgpaLFeECaUvRfpQSaFUYCQKUFzpMNktcJePmi1FjcYX324xZr8diN2cI8IJKzPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Kk/dvD13Fuo/Nmxjo3kafGUbLlG1exEty/l3mULmK8=;
 b=cDGn4QdBVw65gL9ldr6xLmbMDVcz22tp3MuYCzlGgJi1Tkh4ZO+2cXCOZOozk15Moc6Zby1UdxqTqr+0MmbEtpKPKAJTSqS1eYR9QDkQjLDTECM/ieQp8PvJdyoffe5EW0O+UQzJBdkHk6E+x/tP6L7vaEsrF1zBEJ4gt4gBAAvo+QPbJhOcDwaXFca4Qrz0MbTiTmjusd+rGvdYJxL7N6lYpYwVr9krno9UTmqe9ALVSv30IaciaJr3V1o0ROzRT2gUTxodl0SohMeyuefibSlaEAXeXvB3V6nIyaSno9VXNQIbjpxIrmq1vUB6vH9GeporppxWCoHNTx5pjfdCzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Kk/dvD13Fuo/Nmxjo3kafGUbLlG1exEty/l3mULmK8=;
 b=NHn/8edU+zo2EuaRH4jxeynk+MIKcynHR/nMGLsitaPmOTkXPz3GUViq0mbMHI1kRjmODAIBm1/eqLh1TlHDfe1Fq1atRx4bYmR6AU6jVfbYVCKJVTyimcD9wao1vguXhFGGj9Er1nxtjmG2RfKU5nMUD5mb5MUEF3ZNW8JQ1jA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com (2603:10a6:20b:5b1::13)
 by DU0PR08MB9298.eurprd08.prod.outlook.com (2603:10a6:10:41d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Mon, 27 Jul
 2026 13:48:50 +0000
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c]) by AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 13:48:50 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: agk@redhat.com,
	snitzer@kernel.org
Cc: mpatocka@redhat.com,
	bmarzins@redhat.com,
	gmazyland@gmail.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Shukai Ni <shukai.ni@kuleuven.be>
Subject: [PATCH 0/1] dm-integrity: replace forgeable discard filler with a keyed sector marker
Date: Mon, 27 Jul 2026 15:48:40 +0200
Message-ID: <20260727134841.1109615-1-shukai.ni@kuleuven.be>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0525.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::16) To AS8PR08MB8996.eurprd08.prod.outlook.com
 (2603:10a6:20b:5b1::13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR08MB8996:EE_|DU0PR08MB9298:EE_
X-MS-Office365-Filtering-Correlation-Id: 3303860d-cb5b-4073-203b-08deebe5c9d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|786006|10070799003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	p6rFdMQzV/B3RP1e/5nEOiyiWvWV+8nI6shvBsRpEwhWlaRptpLtwPfCEmI6rIk8TdM5s8HGfRnH0mUfqfAIOuN61A+B9FEx9df18NBTeLFVNsLwdAws5Svks9sNB/S+oBAovQqNmV63SAxzVdEmnATId1kIW8QMBwqNCBgeZrersMB58oa65a58JgJHZuHqSdNPkSVNTtpYTLT8nUopxW0FNMyyZE45huRYlYxM21r5QBrHhAS5GjfxGXRtngkYU+Et4tOX6Z8GsAtcqb0igxjhHh+QrZUbEvVzTREXeX/8f26AnPJHPWudyY/M6SeOOQGNCUGeA2/hp9AqaKNKBbG+XX8GHxCTgGg2r9QOxB4xOfmOp6M4gQT58SDRvyJoigaSN6JZi7xB/DC9WxjOI8SOOKZlUH/iUOUAYznwbPFvMv2otqLGjdZlUgOlZlRfaPrnjwvNj5LXxZFGeezlZuuM06Ka2lnbsb48G2Aex31ATaf/oN3o88yi/5VqR2vafRn4NKW2E6nYmqUwoj8yN93X1DtlnLnE/ASkzZ4MRc3/6+nBkIGH2fS0ueP6H6TmyopZP0J8eP+ZjUPUPVUM1CXmeS/IvwRTpTp9K0d1aSOXxu5wkERt2kBaujZnXzmh67phZSrYUEzcYIP/SlyeB6wM38oo/oQuxE5dr/Nv0VQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB8996.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(786006)(10070799003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uC9C6vpzjSfSmsaAMuwuKeyCR0SbgWEnhLe3Kn8G0ekhEwR8gRv0ELZv3Mfc?=
 =?us-ascii?Q?1JIaXDtHHySY3zCuueGvXt6nXsoZ9kYicmlCVpce2ZXrUKPWUJ3KgPbqi/DK?=
 =?us-ascii?Q?X7pAeK8/V+HGYe7Bz1qFy5EtYw1NPFwDgPTnfKVxp4RHBKksGqD0bO5J0H+T?=
 =?us-ascii?Q?PtNpn6sZcAD/O7Rebx1OoK5iIg4xgTF3XuFaG61V0H1hIP2Ymx401T/iYls3?=
 =?us-ascii?Q?W8MNvmJ8jppDQnWkpN/iXSv2EEWByCFdaymcvQNciHzOMR/x2ABEzcbbdrb4?=
 =?us-ascii?Q?NbLvJ7SSRbDURHpZtiZeGL5//6eM0Xx+xCz5P5gDqRETD/aj1E8k4laQs4pl?=
 =?us-ascii?Q?235Xu5E2VV9lr39IhELK/bIsQrIs05Sq6PgvMxLlNA6limMWQm/n2B4nntuh?=
 =?us-ascii?Q?5D34TS58uw0yXAESRo2DyzC+eXhIo0NMNIBLwTOpyWEe02DJLr43c+DxZUzY?=
 =?us-ascii?Q?ZgF4dJoxI+J4yL3N0GEYeIFRnJviERAChfmQTqBQpwIEAI9cQHmi8AFYa4uK?=
 =?us-ascii?Q?4CVVq5jduae+gEcWI3XyJUtUmuSo+Y+QJ34GgErRynCA5y8NnIu5JWfhV6IP?=
 =?us-ascii?Q?lHu+MYU1k2mOTm0KGT87dN+fErXfPmN1INtyS3eWiJOSbjrIC+LqEP896VRz?=
 =?us-ascii?Q?mF6m/7+7Qsybj5CbZwG3KDFQjEjv2MAZ8j1scqsB4hkO8Q9EpThmrOEFmqmA?=
 =?us-ascii?Q?jNYJtNkQrN2GHKR5cwiB3FVGV6UlqErkgizWiJKPFw442cWLyrTQKr4KUPRX?=
 =?us-ascii?Q?HuHBEWbWXY9k5F301FbLGdJDLAl/DfBxpY6Gi0E9+UaFDIQr4l74csB5wQGy?=
 =?us-ascii?Q?IbvCAchRo+75SgLiGXLDpLg4SEurWKcQ5/YYSIDjp0iRahlMb3zwVZb4w/nW?=
 =?us-ascii?Q?z4BLWdf1Hu2e1btRYYQkqYexfQ0mx99I1SfapIliGmqKEqdYxE9q4vfW/T2q?=
 =?us-ascii?Q?z4ezlc7FGCMX/Q1I8YDdIMFSE8aOIx24ByUr1hsNIwgVujtOQX41OH1ERAa/?=
 =?us-ascii?Q?RE3HE9TJC+XUub/B0I+PyczL56x9YwbXK5p60k/RsWe4UhbHBxYPe3TDe3WB?=
 =?us-ascii?Q?Eabu3Cgi7ZFE0VhQ8f+BDHaKouogGyfq5wn8QnvnPgmsAaw3nUlPssBxkXS/?=
 =?us-ascii?Q?E+ZGunxA3rLLVG0AJitLSvbfamW2SNzk37pu/CB2RIO9oxBVyAaVbBczLvwz?=
 =?us-ascii?Q?SdtP1ekRb6K93XNCGYEWe0TqnSYFWlN7w+N89dUwCI9Li3lX4/6N3D1RAJRL?=
 =?us-ascii?Q?0ssxpL/M3wuEn+aaxVyXBRbWvcP2MgP9sduUK3Pqs/Ka2b/VzBxu3AVUnPlU?=
 =?us-ascii?Q?L/H0bqajUzeHd7Vp7OgOOwzYGMWGLogN+PV35zGzCbgKTnCP+1534tTF5LwN?=
 =?us-ascii?Q?jkeJUvOt4+Wr1d0m988LdCeCL7ttdz6ZcFuPohBPlhodJ83VWCdyc2gLzusf?=
 =?us-ascii?Q?xxWkMZA0rl7QXgo7pfknYEMfVt8PD53IhrDn+kFnuGTj117DQg5i3ZXQSAOo?=
 =?us-ascii?Q?jPsMjxol44NrVGgn0ZbQSk3C0J5QlkgovJWprcwfkIBLZ4HhzXp11HY69hsQ?=
 =?us-ascii?Q?T0dhlfIXOspZDoo8gqfSxc128bhkCYdaBAwUw8EczOC9FNQ+GNmKWoxlBHkG?=
 =?us-ascii?Q?Y8F/D3tXpQNSyH6hLT6FiarQPRwNv3bZTLb0y5oTv/ecKVrV21Xj+Wti936E?=
 =?us-ascii?Q?N7raEJdf36A9eCoQ5L6F8JU7GugfjgFQYdw7EWh+YPVI5/S6LeNEPCf+NNk9?=
 =?us-ascii?Q?EuElo0cezDXWWV4U83vwINNmRr4Ihixk9+sGoIuwT8/k9G+lZp27?=
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-Network-Message-Id: 3303860d-cb5b-4073-203b-08deebe5c9d0
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB8996.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 13:48:50.2074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6z9oRzcs+MVSCsYaA7rJ7bOABiNIhTfehWWKIWoFd/UPCjoSFbBokRkkeajji1wWQefdrLrd2PFVJkejd0DqIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9298

dm-integrity's discard support has a keyless bypass. When a device is
opened with --allow-discards, dm_integrity_rw_tag() treats a stored
tag consisting entirely of the constant DISCARD_FILLER (0xf6) as
sufficient proof that the corresponding block was discarded, and
skips the keyed integrity check for it. That constant is public and
needs no key to reproduce, so anyone able to write raw sectors to the
backing device can stamp an arbitrary data block with an all-0xf6 tag and
have its contents served as if they had passed HMAC verification.

The exposure is limited to dm-integrity's standalone cryptographic
authentication mode: discard is only accepted when internal_hash is
configured, so the combined dm-crypt + dm-integrity AEAD setup, where
dm-crypt supplies the tags itself, is not affected.

The attached patch replaces the constant filler with a per-sector
keyed marker: HMAC_key(salt || sector). A real data tag is
HMAC_key(salt || sector || block); because its input always includes
the full block while the discard marker's never does, the two cannot
structurally collide, regardless of block content.

Shukai Ni (1):
  dm-integrity: replace forgeable discard filler with a keyed sector
    marker

 drivers/md/dm-integrity.c | 77 ++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 21 deletions(-)

--
2.53.0
