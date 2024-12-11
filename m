Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2061.outbound.protection.outlook.com [40.107.117.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8661F8AF5
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 02:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733882420; cv=fail; b=ehyK/rdw4RCOWiiD2+lmCLCWWiUHPKiZF42DBIsNwg/r2cWO8ItBTAvFr1lyQ2ocTicstZy1yAXWwdiLnmaJDRxSqjsxP9FcK0QaPaWqbvdphVPPooP2TY/u57iOLAh6PEvV3GSMqP0GXsCXagfYdlEFdozBALTvmQx7jJm5WME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733882420; c=relaxed/simple;
	bh=VdGwUd+LpZqQ42BYsMu6vfLkXTCRZc+Ee2dD0AHO6+U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m1CJDSwmdskTPitnhDhpzCEPptnkDE073fXB21F6j8yZGb8J8GMnPhkshUDXOnuu6SFf2RUCOrBF2cPv3qg5JjfY2QB5P5HPnFd+T8gYyRib+yjZZH5Y7b3jTBkkE/TBZPa0dDWHHEU0xBivnFC8EVJ2/YrVUPZKhrEscawlrhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=GFEgI+6J; arc=fail smtp.client-ip=40.107.117.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="GFEgI+6J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhIM2yTQw6IOdirDsoBo8h1eFz2+RBgQkZtDhj5w29YgCnpVxChDlE+n5tqyhUOZXQuOgGcliObEjGSl6A5YBn8dGLojvPD6630NfKGyCb5PxmXT31/TwrMAffxdQ+x+2srtX8O5vjam/DJbEHG2dmogFkh9+YoR9EjOqhev0O+I4lPr7MA1oJCoFVferA2nhtunPA5VD35G42AVyhf1UWvk5W+16GEHddQZsd0r3ZixDVl0Sa6TY0byhk/2EQd1XlHmteQtufNl72pZ2z2D5HN61wuKFDFMKshesErcIK8ZaGKcTNfhWnNRZH43/QWFOBrdUn4XLeDvyDr0yG7qYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7QbKQ1UxDnqQD5bYGqeciBtvpGi6HLu9NOkf5NJ0nU=;
 b=T3KexdpyqXkPKCQe6IM0m+clu0OVFurnCAPqC//pK6s8GRS8WLYDXAcBGs7NMepRBxah76kYGGQ+ars/IsEqVtGyGjnW/2UbfifxZvkD+THLRXE9yF7WN5PUFFi2vJD/+ywobPHWMT9ILpixwH+3Ux1ndmNszsDnO2uit0z3SwicngFBzm9AadfHIyqMvtD9ONoKdoYVtO26oZ60GZVwnlqIuN13t8jJuZQ8q7hODHvMUefJA35m2jNv38ASJ3dlKDRVIg+4IMgyAyPC2jea7mqa1Q1WWwDJJMSJ3Tt3Fp5E/C2k95D1ZhrAGxldse+mq0mtAwL8gKsl4/ID/nOh9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7QbKQ1UxDnqQD5bYGqeciBtvpGi6HLu9NOkf5NJ0nU=;
 b=GFEgI+6JSWZakn1ovC+fGP7qen+Ka2YkP5xSaiTW1fXtlZQnVE7jQKj7E3ANOf6Paq6+y9r6OtFTSctIBXOPS3oa1PgmJeduiilc7lfz/Nxm1TT0o62qCLBwnOG/iNHZkt+aSeKV6xwBVgeJraIrjoNnWzGKeBNv4PSY3LAMj7o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SEZPR02MB5981.apcprd02.prod.outlook.com (2603:1096:101:79::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Wed, 11 Dec
 2024 02:00:14 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%3]) with mapi id 15.20.8230.016; Wed, 11 Dec 2024
 02:00:14 +0000
Message-ID: <f4d719a1-0fc2-458c-a62d-4eab9bdd10fc@oppo.com>
Date: Wed, 11 Dec 2024 10:00:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: dm-crypt: set max_io_len as chunk_sectors of zoned device
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Damien Le Moal
 <dlemoal@kernel.org>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "ebiggers@google.com" <ebiggers@google.com>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
 <Z0QSqndKs1fyiOmJ@infradead.org>
 <b01f1929-f1bc-4ed6-ae57-dded68f23e26@kernel.org>
 <Z0QVCemvU5_5REWB@infradead.org>
 <ec6f2bb7-95d8-4c1b-9654-4c597e1f0da4@oppo.com> <Z1hqMSI-got7s_Od@kernel.org>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <Z1hqMSI-got7s_Od@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0166.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::22) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SEZPR02MB5981:EE_
X-MS-Office365-Filtering-Correlation-Id: 246a165e-44d5-4fc0-b5ff-08dd19878d5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2lDYnBMREhMc3YzNmcxZWhOdFNYWEZNcGZmMHZud2Rja2lPYVhxQnUwQlBY?=
 =?utf-8?B?Z1BWeXhPS0NpYmFuL2ZPYnpocjRpMUNxaFgyV3BQZlpQTSt3U1dRT3VPMHhk?=
 =?utf-8?B?YUsrLy9VNEhibTFzSXJqTG1xNlRxYjlvSndBVFk4U29YSDdKZ3doc0Q2NWpH?=
 =?utf-8?B?SjRLZ2xpOGp3ZDRWTlFFd3oxc3liQ2pZZ1dyOHlLa3dqZjdOZDlMWTB2dmtW?=
 =?utf-8?B?UTR5eUhmajlBUEZHVWQ0SHFyd0JMclMwenRKdzl6cmhXRU9NVk1sVkdNbDVj?=
 =?utf-8?B?bjBKSTZZZ3VqTnlzU3A2RnZtZDk0cHlQZjdOZUNGZ0JlYU03dlRmR1dBRzFB?=
 =?utf-8?B?Zjdwa2VTZUtTV09GUTlmUHZsR244cnBFLzRwK21wa3lRU1ozZ2ttYUxERzFM?=
 =?utf-8?B?bEZVZWZHaUFFWXN4S212ZElrZVhiRHRIc3R5cU8xRGRRWDVPNjE3Rmt1SUl6?=
 =?utf-8?B?MXJ2M0dxRlR3TFBPM2hXSUNicFNsb3RrbXc3NXg1c0l1UW9lUXFOM2ljaklN?=
 =?utf-8?B?R0IxNVdqeVNLOU1iZkhBVWx0dGtGZkpsd1I0ZjVUUm90NFZDNFJTSnJ4NXAr?=
 =?utf-8?B?dXpIRWtvZC9PTi84VUw0aTk5dk40bVc0cHpUYzNRMjhlWVF3ODRNR2lZZ0VF?=
 =?utf-8?B?SWpnT0tnMWVzZFNlTUNLS2FUVXlYQloyMHJMcStTVzN0dS9Ud1h2Tmplb213?=
 =?utf-8?B?TFppaHFOVkFXYnYvVzdxMjZEbDB3bkF5bFBDQjU2T05CamllSlNNRFZQNjVM?=
 =?utf-8?B?ZE9vcVE5VGN6SUNuQXNRNDhLY3RqSWxDcWFnNWFkREw2WmcxSENXNVVvSldj?=
 =?utf-8?B?elZpdWIvS2NOcnhlNTJFdlFHUHVtcHBrK0xTUGVSVEtRNFBSazBqOVVYbkNj?=
 =?utf-8?B?RDhBL0pySWVUWDJQMlJSa0JLQW9vYWJSZ01rQ29yWndXUHM4bjE4TE85Qks1?=
 =?utf-8?B?RWg1U200bEtWYmZPcGQweG93b1pkLzNZVFJENGVYMkkvc3QzVC9WYWgxWHZ6?=
 =?utf-8?B?cUl0eCtHKzhwRmtHbFNhaEh0VmJwTHJCdTFJREkrYmFjeVV3NmpqUUpoZXFy?=
 =?utf-8?B?dk11NFVaN0pWODNxVHJFY2xFWEQ0MG5kNnpNV0dzSUcraWhPc2RKN05jdDI4?=
 =?utf-8?B?UmMvNUdIdEphQUFqRXFrdEc3V3RDV3lsUEZIcDkzRjNjMXNJT01idWFkTGV0?=
 =?utf-8?B?bXJzRE5DRk9QYXFLUWtHVjRFc2JUZXVvQ0x5UTVUdjlEUFA4aEU1M3NlS25S?=
 =?utf-8?B?RE1GQUozWWpTZnp3eEoyRTJIUFNyam9pUzh3VWh1aDB0UHRWWWM1NG55dkU5?=
 =?utf-8?B?aWUyam1tN2hIc1VWOU9GSHRsOWFJeVc4MVlxb3RnUmRzVHFsUHl0Nmo0aHFE?=
 =?utf-8?B?YmlaeEpuRFpzTSttRzV3L2xUMXF1eU15a29DMW1RcUg3Y3I4Q2lmVGpHSUVt?=
 =?utf-8?B?UXdyMUlBSFAyWlNUVGIxbFhJSE9Bb3kxRGM3U3FUMkNWbTM0MU0zbmtNUkp4?=
 =?utf-8?B?VUlFQWNxU05ZTFNqK09rVkR6UkViTEhLT1hXQWRFdHI1Rmh4bkxqOFl0ekg3?=
 =?utf-8?B?RCt1OHo1S3I5TkN2QWxYK3lFMnBrbXFIOTZCUks1ZVFrb2VJcFc0MnNCVjFs?=
 =?utf-8?B?eDJBWDFpaU41WGtjN0JJeExEekRnTlhkOFgvck00TUFiWFQ0MFh4eHpTVUZD?=
 =?utf-8?B?aStXNWx1b0JxYlBJN2I1K1puWEtWTldlQzZjR3BPd0gyVnJtT1B2eGFvU2NZ?=
 =?utf-8?B?OUJZQk1Ib2toanBsVGwwTFRTcWVRRFUySWl0UWh6UEI1RituODdYeEx2TFVZ?=
 =?utf-8?B?dXEvRFRvclVxYUlBZDArUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTJkVGhUWW5lUUdUQWVrMlJEdUJ1dHdLRTFpRTBjN2E1dXVRRjFjQmZYLzRj?=
 =?utf-8?B?em14QWw4SGdjcDVoRnNnd0dVU1pwbHNsS3Z1bnlEdjFlbWVha1JpVHhwMTBR?=
 =?utf-8?B?ZEcwOUJBckRIeHB5cVBia1FodllSWmZ4MHY3aWRPdkhibFE3WEt1NUlHcUgx?=
 =?utf-8?B?TUpIMkFHSGFISm1VUlhQbmpITUxBZUx1WlNRU1J0WlVtOVZ6a1hHWDUzYkQ1?=
 =?utf-8?B?ZjVoSDBIMWpPWGZmejV3MU96RXE3cGNQZUhFZXFLWldVeFE4ejlLVmRnMVN1?=
 =?utf-8?B?VUlka05QVzB4ci9zR3dhdFFhWkZxalYzMlpRMGw1Z2g2M3kxKzUzbUpZTnBq?=
 =?utf-8?B?c2hPbGtkOVljRlNGZWpkYTlSYnNXN2RMUnNFVmZENElBUFQrc3pnNE51Zi9E?=
 =?utf-8?B?RUF1bWdHN1YzV2UvZ0h6SXkrWFo1RW9qMmZkSk5PNjBuUExpSzZDa1hOVVo2?=
 =?utf-8?B?V1VtS2V0bW5NRnZsR0tiemgzbHBTR3dpdjZEQWFkOU9NMzg5cW1XcFJSSVFB?=
 =?utf-8?B?a041RksxM2ZxRVA4bHJFSkJTRnZjVFdRakNHeW0xbjI2SXI3Y3RWSG5hNmRx?=
 =?utf-8?B?R3hSakc5VzJPWUVCd083aWlhUG9waHhxVDdJalJyNnIxN3FReXRwZFZ2Vzhz?=
 =?utf-8?B?aEpWQnZzYU9rZ0JCc3BiRWlHTWZtYVVjOVMyNk5RWUVwZVdJS28xVnZweW1u?=
 =?utf-8?B?MnI1NVk2YkpTN3lXNnJSdkRiTUI2akNua01IUFMwcHdQNStOV21maGNFa2tq?=
 =?utf-8?B?YUtTTURscUFqbGJCOG9CVnBtYkRzMWlVM3dTYWExS0kwNzQwamxlVFFROFhB?=
 =?utf-8?B?cW5lOWNTVnV5WkgvUnI0Y3ZmWmZCbk5aV1VSSFBnOWZPOEFoZXBLQnJueUlZ?=
 =?utf-8?B?VWQ5L2JBd1F6ZGxoSkc3ak1ZakE1bWgwOHRydnd3Vng1QW5VTlppV3VxbEVq?=
 =?utf-8?B?VXFaY1UxREJXY1hpS2gyZ1ZJYmFRZkRWQjBvNFloR2F5VDBVbStJN3JKeTJw?=
 =?utf-8?B?M3dqcHU3dVRVaUhQS08xYkpFZmV4WEt2QzVhcWFZd0M2YzgzSVhzMkZvOXE3?=
 =?utf-8?B?MVBqdytZTDdZYkF5VFZQbWJqbUpTVVRGemkzdlU3MWxnb293L3VTOUFWM3lT?=
 =?utf-8?B?ZmlkT0k4cVAyMlNZZ0gyV09MdjM1QVo3dW1aaDAvMnhmVjVweSt6YkwyajFl?=
 =?utf-8?B?THdybm9INU9QVzQwUlJldU9TZGZ6b1lJVGt1cCtPRzRDam4zMnM2RGdLR3lE?=
 =?utf-8?B?S1h5dnRNbDFZQVpmbDRJQ2lRSzJ4RWVWSjhXYk91OW9uRGRJWjlXWXZqWVgz?=
 =?utf-8?B?N1U2R0V4OEZ2MXhyREJXN3BFekE1VGw4MERsYk5hSzNIcmYyR1hhTEZ0emhP?=
 =?utf-8?B?dUxNRTZWTE5QQ3lGaGkyQ2VMMGRtWlAxbEdDS3dNaC9sMkFCVFYvUFRQMXNm?=
 =?utf-8?B?NlFsVCtxbUx1QzNkcGZPQWZ4eE9SVUdYMWN2azVBWTB3aG4xZ2JMTUFOTlJS?=
 =?utf-8?B?aUVNSUliZXFrOGNQOE1ZWG05bkNjKzFpY3huZE1vZHVQclc4SHEyMTJVbzZs?=
 =?utf-8?B?Y3dxQ1FzM3U1MjVBdFBsNEI4bEdqY0Y3RlB2N0hoQmZNeFpDTEx6L3ZHMGMr?=
 =?utf-8?B?RUI5c0VBcnNSVEJGTXMyTStOb0N1bkRYdXltekZld1J0V3NzWU5JSXY0all1?=
 =?utf-8?B?UDRENVdkWXp5SFA4RmNXd0xnZzUraWlNTGpZQVcrWHdYTWxtTzdiQTg3YWhL?=
 =?utf-8?B?aXdaSXNFbnZWcGlteHdEdTlZMFR3b2wyZTB1L3ZqVVY2QnlkejZxR01EaWZ6?=
 =?utf-8?B?eE91dTI1REtZdkhkb3dkMmVPWGpSUWRCT0dMTFZIOW5YOWhBcGQ1UmF5K2pl?=
 =?utf-8?B?WFhmaXpCcTdmb0djQ054M0F5VDRJa1M2cjRMRVppWG5jdmVOeTBCTjhIS0xQ?=
 =?utf-8?B?eEFNTTFvRjBVTHVXUS9QdnNrWjNTRXo2UjhpendpWWd0c2hFRDBRenYxQmx6?=
 =?utf-8?B?SEhYWkRyckhFdm0ydUZyUU5LV3JUNjNYWTZBUDFFRGJiM1FSYnpMalhCd1JE?=
 =?utf-8?B?SU5SNEFzUDVUS3orRVZ6V1YySUJsemhLLzErQm5TTmx0eDV4L2JtZDZPVkE4?=
 =?utf-8?B?VEZ5amFIWS8xd0NENjd0REZOczlJQUFYUkxYdUk0clRSK1NiTHlPTGFucEZs?=
 =?utf-8?B?VFE9PQ==?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 246a165e-44d5-4fc0-b5ff-08dd19878d5f
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 02:00:14.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tGUFvrcmA9pMUdar5Q9+LbD5zK3UUu6HJVZfr5CKKn5xFtdRKLpbmVMaYwBexdnBXn1uwC1Q2j4aPGRQ0Ba/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB5981

On 2024/12/11 0:20, Mike Snitzer wrote:
> On Mon, Nov 25, 2024 at 03:49:01PM +0800, LongPing Wei wrote:
>> On 2024/11/25 14:11, Christoph Hellwig wrote:
>>> On Mon, Nov 25, 2024 at 03:07:24PM +0900, Damien Le Moal wrote:
>>>> 100% agree. But in this case, dm-crypt sees a single BIO which gets split when
>>>> submitted to the underlying device. But the split issues the requests in
>>>> reverse order, which breaks write ordering.
>>>
>>> I'd like to see verification of this.  People who send these kinds of
>>> odd old kernel reports tend to have weird patches applied to their tree
>>> as well.
>>>
>>> Without an upstream reproducer that actually shows issues I think
>>> this can be safely ignored.
>>>
>> Thanks for your suggestions.
>> I will try to make another patch of fault injection to reproduce it on qemu.
>>
> 
> If/when you do find it is relevant for latest upstream and/or
> 6.6-only: please add a "Fixes:" tag and also be explicit about which
> kernel(s) your fix is applicable to.
> 
> Mike
Hi, Mike

We met this issue only on 6.6 now, as we work on android devices with 
linux-6.6 and zoned storage device.
We will got android devices with linux-6.12 and zoned storage device 
after half a year and then we can try to reproduce it with scheduler 
being set to none.
I have tried to reproduce it with QEMU and nulblk, but failed as our 
test suite is deeply coupled with our android devices.

Thanks
LongPing
