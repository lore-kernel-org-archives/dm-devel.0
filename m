Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2B4200A3
	for <dm-devel@lists.linux.dev>; Wed,  5 Feb 2025 02:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738723020; cv=fail; b=fa1steRN4GZuNwX/qD/utJOGZX1VNPk6TY14C4GJi4tGWAwfHa3GHbKQvzBiYmcLIkr3DvpE4HlPPUglH9JxFpFwz/SX8Vp7kO+uQF/sLjJeT9dFBwMAGNazMzauvAITZUD2mUJgaJS5yeUSfLWpwd2Auf1MTg44Og8B1LYKNyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738723020; c=relaxed/simple;
	bh=/PSJo+jI+2ZQTZB8LxKVpPH1MmEx/0jK9JjTzeGIly8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MceuYWz0pGR4F8hFv8dhE7IlXO1HCOO+m4dI+x6JdokokfPiyhVZBrYdOwcGwNM5E5kdoWXRo7wpU7yveEgKMesBVcCPwAty31gcLaFwr8HN9kCeO6CNswh93UlThPPwOAF7MyCXHTlsRVEn31o48kHA/tl8j3DNBeF2xyiivDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h2MPmdKI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hp/dwM4A; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h2MPmdKI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hp/dwM4A"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBwLd003152;
	Wed, 5 Feb 2025 02:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=RekMmlNvMUnMhK5huR
	JDBph371Z+vPEuYvO1MM0fjI0=; b=h2MPmdKIwk59+3JlvUFjIjVmvqYirCskK+
	wpyvIdxMAmsCIX8k0plUXpZV8vsON2Wa1hWuDK/ql8Gq44++gLA54Q0CnPzaZMp7
	jJUHq4TojO+BZEGikVAi7PlWfzSHfkO1UxkLPiXx4ChoqxOrRL8gsJdOjT5ElCnb
	ZO0dMJiAAFe6IqOnagN3ZwCH1mhJdk9vdDGb8ndm1UAkqY82BXGW0YQNCiiOLgPC
	DwMp1819d8BEwmJHywjankFO9i9TgURUzAtze9Je6/FRkFH8AarI5J0KaFrnHxTz
	dxf7IH7LmELRG7dlVwYQOBvB/CVAkJydPkuGxQnsBE5+EUn7Rjdg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy862pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 02:36:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5151a9bR038996;
	Wed, 5 Feb 2025 02:36:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e8h3eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 02:36:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EK41n0vBUoHrlATcl4PaNkQ7fIMLZYPeifmdrdZ9MtONGUxqSejctpLL3HjbgvXsWjin1nxdSxOgQtw9baMc1aNu0tcj183oN5JwRR6oIVVqml3ZB/uF0+VvMdRedzw1x6R3W4QNbrKC2oIrbpNzlLF4hQbAc0KKK4bSQ5YvEn9xzjWGkPix2wAfKVeYjblvEWgbOs119WpxuMpoSPT9EcqAfNyvls/XQi4GimqWctr++7d0FoN6NAUcBACxs6ImFXWQOHAUrj4bNp4Gz2y6W0FjiN83itDQjpt5TtG499A7/mzS8URVj1+vX6U/7pekntLwiFt/d8OTCEbR38FwSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RekMmlNvMUnMhK5huRJDBph371Z+vPEuYvO1MM0fjI0=;
 b=CqH0yvX93MzGrneoBSCjW0VA4XSh6zJTOUUiE/93hAXpLYmp7YJFtwR6AO17QjGbxU2VlZxzW9YJa/4kI3oIe7LOPJrAR7dCsvtM+BzMMtlNv6vb5jJmlZwgNdd+laHG0X/SYkbr5YGxEu2sxmjJY9tHv9VRMeHBCMpX1Haic5cA47GTQ2S9xJPuCuY/+6iWTlI1uCJOm6E3YvZxrh5zWZuED/Mt42kpR1x88me+k/ASfnLFhiUCL5JiJESIYrYhsl0TybwzcQBJJvm/I9aBsQAzToqTPRshEsWiQT5rmscabrnnNw7sOpwz1EwgYanQMIy3Fmakf/VJMGYbdX1IkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RekMmlNvMUnMhK5huRJDBph371Z+vPEuYvO1MM0fjI0=;
 b=Hp/dwM4A4ObVolw0SpLfAFcXjfPdBFwy7ht09hV+fHmKACRStavlg4zWoObVmBPF3VEslBNQLTVJnEY26+n38oU7AJPkxSDGILwqlsnlf36Do+K429LETzUlllk44tpqGcUhnpLOzaAq0gbMEUGGFiaPOq7M0vunwiZGBFJ1E2k=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4736.namprd10.prod.outlook.com (2603:10b6:a03:2d6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Wed, 5 Feb
 2025 02:36:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 02:36:49 +0000
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka
 <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Zdenek Kabelac
 <zkabelac@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <Z6IbGNYoY6DjjYpG@infradead.org> (Christoph Hellwig's message of
	"Tue, 4 Feb 2025 05:50:16 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ikppdsv3.fsf@ca-mkp.ca.oracle.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
	<Z5CMPdUFNj0SvzpE@infradead.org>
	<e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
	<yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
	<28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
	<yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
	<Z6GsWU9tt6dYfqBL@infradead.org>
	<yq1zfj1eusl.fsf@ca-mkp.ca.oracle.com>
	<Z6IbGNYoY6DjjYpG@infradead.org>
Date: Tue, 04 Feb 2025 21:36:46 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4736:EE_
X-MS-Office365-Filtering-Correlation-Id: 24337711-5139-42f9-7b51-08dd458df0b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/ujV919/qqMF+H3CL7TMJTTswHCgaJhTkQGr7UqgbxFsFqC8fw7lYa2ppKiA?=
 =?us-ascii?Q?O3ZO/QRPaDPCmSCcQNBhZdg0KDjNUVxzS89gu4J0pDAD6sMx5HMKvE75Wkyw?=
 =?us-ascii?Q?ZqrWoSR9O+ZzbhI2W93hqQohoMFEbbUh1llr1vi3gjOATkhwVpOCifTNzsdH?=
 =?us-ascii?Q?TClafSEr8gKj4WkYlvm0pWnYKEkTumJNFBvjFaY+YAhlgxVET0jV5u4pkGCZ?=
 =?us-ascii?Q?LKL9rJB69JuaAX5sfdySv/Vk2pV33Qr5WV1WCLVDTwLskSYZwMdVEYlxV0W7?=
 =?us-ascii?Q?0qnTdGv3DydtT6Enlvy9bd7fo/kmVuZ/6N6BQZB8+2QCr9LcswZ4aW78Vw4d?=
 =?us-ascii?Q?HD9SRdwSZysTURbfx+MzbGUqeuFDC4m8+KcOhFNPuK8J4GlsXynJI86FOgU9?=
 =?us-ascii?Q?NfvKOJ1Iox4OmGW9vh3sfNlcsB+2eq6SA2i6l8LBgOLW0/Qo3mMpwqK4kKIy?=
 =?us-ascii?Q?G0AIQj1ze7OsuzyvyC7pAkq2IJpPakWjgam6XNXG0f91rpRx29etAVt0A5PP?=
 =?us-ascii?Q?95H3LC9BkjpOONEAEfT+92aNn6Vxia+AstCHimeAQtXd3VLAPYVRIaDJdWOa?=
 =?us-ascii?Q?52pcJo086zVlRulRSHCQIQgDydIv4AkfG5jYITfEq4RpdAIVRaA99W44k5C6?=
 =?us-ascii?Q?DuMs6HePj0v6oxc+EKQOpMwTwDN9rLaIH675du+eYB8pO/M8lPUH5xl7TcQE?=
 =?us-ascii?Q?VeGKYovow/gd+SKewb1/7j/2ugXU3BtgCqhW7+8xkAjPPBUkFb4bXmZqWGh+?=
 =?us-ascii?Q?iBkvW5cPllqLFaPgNRV7LYkmuLD8c2gnnNYe9BqdfdHFra6q287VMWyS5MAi?=
 =?us-ascii?Q?wwDWW86BStPTs2tgLFPAcU+MpIi2VP1UuqHx+Egn7cTihKrKWOTbf4QN/MjV?=
 =?us-ascii?Q?UtcHrDzPcJA3GzGgyg1m0wNPXSVrFBQDM2Pfkr18JhGu6edPRo0tPHQw83EM?=
 =?us-ascii?Q?mdZeVLWD6r0djtqy63N4ohmSn+axVXbyP7MiZPbz1+pnH8MKvwtsLP0BFGxC?=
 =?us-ascii?Q?aZGxzKTLquZleT8+8fhDUIEMMVQYZxO2vhdkd8Gl/p8wR0ZjZ5+ygihA2zn1?=
 =?us-ascii?Q?If3AWp3bwXvbR94DbS3DG5BkoVOfMYMC+TEMzPXLG7arKduuXWG0I1pcfbUI?=
 =?us-ascii?Q?NLLhsSa8jyVMmhfQW+g2K9w1Ng7Lf2SKa+zwccDzKM/zG7GVvJnryaRt+uuD?=
 =?us-ascii?Q?aquW3rfYzjJrRXCSo4mZ6r2OtBFkrIahqlsBFKYv+uhQYboLDkRWeL74OgC7?=
 =?us-ascii?Q?VO1v9IC5hx9QHZ74LGaWBSLaKZcr+R0ANs6gMbnb4FnkGauch/8Pa5MfOXp2?=
 =?us-ascii?Q?vagOjI5ZRwZBVbufCZ0CF4U35RIh1otoCnaAXTIMstlBDqEgwsro3pF8i0Le?=
 =?us-ascii?Q?z9Ltzo1fbRAczbjtWOXVXsmfzv6m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l/SxwY9sJSYaVzvRrWK6c6v/1nMyuctsvAUlQrk1nYEKczc2Rjm8fgGzGnFi?=
 =?us-ascii?Q?PEBihaUnqL1bueqhpXU54ZAXw6J9ss8rIB6NdyHqnxMnWUC7krhY6ApjUM1q?=
 =?us-ascii?Q?Sultkt2elCgHei/zIxtzaxC8bQaV7IQwfqkCP4JJL9lhQ5ubzUYS1hjCOgqm?=
 =?us-ascii?Q?O/XaF0wVylPox54A8/BlmvA5AsVUtmWMaLR/R6FXRxFicsxm+mDACUhY/Re6?=
 =?us-ascii?Q?F2A+nwWD5BpAvz+NdeWX9jZzZ56L/yWfrcfnFbTa0hGpYgKYLG7gJKGOPw2U?=
 =?us-ascii?Q?SaXUlrwfjtnos8ccZEv05PHE0ZH21GdGnjIv0Ly06h3hpWV7bg7McvvMFJ+r?=
 =?us-ascii?Q?DL57JopizqzjRp4wPXhJ5F0ol1GcS5L6LIHL9n9Z8xW3mi5QAgrjywiv3iG4?=
 =?us-ascii?Q?L02iFKecl5a9mKGYF+/USwQrX3t6QkfkT5RXJgSdUUqFCuWnfM+OigF+E4Oc?=
 =?us-ascii?Q?xs21v9x43w0Ttf2LcyR2YWImwxxNyLwEL/uyVjsrvAOCPEZRWscj5B+5Ix5A?=
 =?us-ascii?Q?Uzdbo3t1wRegM8JtVNrX0P6X5qmGhrGBhoKC7mjJ/67u+WymQhArRRD0hQ/x?=
 =?us-ascii?Q?/kaPslybAdrO/DbRmaKd2wUYgccpAse0agA6uCfKrATfVon1DDglNw9rU60K?=
 =?us-ascii?Q?5piWyLajpP4rzD1Fbf1zHAfbomyHlYgiACoOA/BZlqQHIT5XdJmwW5jGKtv8?=
 =?us-ascii?Q?bDPYMEJJNBayjdcFAH/qDeVNyM7H3Tj7vdR9Ti7vVV35orJECh/JMuR/vaRu?=
 =?us-ascii?Q?+JC2jDBCy4bpZDCZIAHyT1pLYY/KoBzV/fcJypf0AaAQxoytXciQIVupp8Vd?=
 =?us-ascii?Q?SUWOUX8t7T9ONy8/he88eyoRA4el9M8I8qycTd6j/gXw9gSqnDuDvBsZVFRv?=
 =?us-ascii?Q?9HI6qD6+jkBPa/xqyU0jbRHaEex2TXaE9v9w0Zz+PogXIEvQooz3d1sy9BT/?=
 =?us-ascii?Q?enJLttKpm9G6/eU4Jh1Xo7w/ETc1QGE84dHUaNP20GPVKhwKj+q+lcjmuQvi?=
 =?us-ascii?Q?EPiNoQT/zUYcJkHxg2tISrI8KjQKwL7hL794P2hTjF/yXkn4QduoXriSNsUD?=
 =?us-ascii?Q?hcDW7hkNFMJMMaufLw6GMRxuNN3hk1x93ywIHsEpuJMS/UJySlSlru00r+7F?=
 =?us-ascii?Q?1OY1oUOe5X3LgtgXxnbR1FrEcXWLdMruSlxWS+IfylGxjCNXMNC49dnjpv8L?=
 =?us-ascii?Q?qKp3UbtJ+qTYDURujfFrRrBxpEsJubcI3qJ27M3eXrK+Lu8Fb6RMHtG7XbZk?=
 =?us-ascii?Q?ckMp2/4GpxpD4UPiDYf1D3UiZCdHDK+uHRuPAThb02AZIQ4yWJ1lFlz5Bn0a?=
 =?us-ascii?Q?hYsZ3pJgo5O+vdFwwe379ZDUhEsXwGhrT0t6GVQMsqkVni4VSu0K1lKwoB5A?=
 =?us-ascii?Q?2rwAGYLEdIVfgKGboD0atLpW0nejP7wSEd47lfl/73Ops7G4QzHmZe7fLnHB?=
 =?us-ascii?Q?83hRGQAOrZrTVt80je2I3me/JMLkU+P0wcURcnQV9EAxEw+BVHiCE+ZtDSPl?=
 =?us-ascii?Q?lFGnWJ8SvByxcyaO4RxCatHV3aHGbTHcuKEAeXhdz6sme6h4r2SdO2qdQCBk?=
 =?us-ascii?Q?zHyL2UJOEVqHn7di9s7eAukW0HCzWZ+LprCH0lljKBkVXzfLAFXDPPrJvH6K?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GMzrHOUQxEGAAqI2OlaksJtDMlW3+L5zcSnUHrvra2zHJtJk7LkmoEzay9T0e89BIZqj9x+yzk3XfpBF2FbYvextFuR2OmbCl4pJPEyw3la9HsDsLTO3BSeh4Nn1fa+1rqXQ7lZzRkljGeYVtGoY87zNntESJs1eJD7tVQE8WjROqk8WJrnWpI/XMehhzxVdi7S+WKGLFtdJPpSEfkVAYhXhTpXslQSjlJZirdDPQQ3/F7Ki+Wity796/9Cp9f+4O4uh+B5po47TW4sFvRiogrsCf0/K1q2HNgVeQEbi8MG9f776qU9nNgYGq59r/7s9jiKPDbCWHzaBJRa53mQIUFd/6BVsi1npyrYX5rpDVZ12Lc4mDNQi8LRFjlbUN2xHHVTZrFShYK8CZcMPMGOno/mi1xe0+kE2wl5JYrCEJ8bt4Jv397I4MX/dGM8NsJTOOaesTm5rLsC+nKiCFDo0yS+//ytoFKfKBXAImEBUOACRVzRtc+IvNKqFV+sc1jlrD2PQC1Qi4Z0qDJnwh4rYXvPitAyv1TnOzm+WSQJchhVW4AU8L891cHHkA9fWCIQYowYal/h+zSWKecRx0Kmp+Kg9fmvdkHisuIGEekNHX94=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24337711-5139-42f9-7b51-08dd458df0b9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 02:36:48.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbI4x1aZ6mbLRFgN2Lao93jMi/Gk4/t+M9e7cXXhSlcgtNXAMT9dlKC5GHcugkcU0XknKg+SpAaOnGSkxjeh6XIdpH7XrwXrVj2GlPaM9tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_10,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502050015
X-Proofpoint-GUID: KeecOY9CYAsSUkCPR2GgqZ72WvSDkSdK
X-Proofpoint-ORIG-GUID: KeecOY9CYAsSUkCPR2GgqZ72WvSDkSdK


Christoph,

>> Quite a few SCSI devices report 0xffff to indicate that the optimal
>> transfer length is the same as the maximum transfer length which for
>> low-byte commands is capped at 0xffff. That's where the odd value comes
>> from in some cases.
>
> Hmm, optimal == max is odd,

What they mean to convey is that "device has no constraints". As opposed
to a value of 0 which means "not reported".

-- 
Martin K. Petersen	Oracle Linux Engineering
