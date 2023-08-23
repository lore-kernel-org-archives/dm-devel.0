Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BADE1C3DA6F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Aug 2023 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692809892;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ySPXNtM1EdY7Z+RrZj1jQOJPfeLMRKcm6L9FB+lP0Po=;
	b=CQztqCgjQW/wty4ytoO/lJ3DcFVW/tqqiSKyfiFDEO5kjX1Zp9BeO2XgPKalm+WzN0H2le
	1eo/+v7MJjjHxmI+LU/lpIBmcHW8k94KGSLojXj1/SH1KXl53CJkWgCpadZBLX71r977e/
	Ggp/StZCUD0dcAiVfKEyp0mq8pY7Fqk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-mkHQvlyrOzGGpLn1v-7sog-1; Wed, 23 Aug 2023 12:58:09 -0400
X-MC-Unique: mkHQvlyrOzGGpLn1v-7sog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 878E38015A8;
	Wed, 23 Aug 2023 16:58:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C75C2026D76;
	Wed, 23 Aug 2023 16:58:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 44842194658C;
	Wed, 23 Aug 2023 16:58:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A41441946594
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Aug 2023 16:57:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8EB1C2026D2B; Wed, 23 Aug 2023 16:57:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 868862026D76
 for <dm-devel@redhat.com>; Wed, 23 Aug 2023 16:57:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DC83280D58A
 for <dm-devel@redhat.com>; Wed, 23 Aug 2023 16:57:49 +0000 (UTC)
Received: from outbound-ip7a.ess.barracuda.com
 (outbound-ip7a.ess.barracuda.com [209.222.82.174]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-BhKA_Z8LMOOjnE1FHSvfCw-1; Wed, 23 Aug 2023 12:57:47 -0400
X-MC-Unique: BhKA_Z8LMOOjnE1FHSvfCw-1
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40]) by
 mx-outbound43-234.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2
 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
 Wed, 23 Aug 2023 16:57:35 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by SJ2PR19MB7577.namprd19.prod.outlook.com (2603:10b6:a03:4d2::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.26; Wed, 23 Aug
 2023 16:25:01 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::7f40:bf5d:266a:ddf5]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::7f40:bf5d:266a:ddf5%6]) with mapi id 15.20.6699.020; Wed, 23 Aug 2023
 16:25:00 +0000
From: Etienne Aujames <eaujames@ddn.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH] libmultipath: fix max_sectors_kb on adding path
Thread-Index: AQHZ1d5czBNvzSmDAEeju9pYwdVqZg==
Date: Wed, 23 Aug 2023 16:24:59 +0000
Message-ID: <ac898b4b79947c22d510bb365e9b507faac1f016.camel@ddn.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR19MB5570:EE_|SJ2PR19MB7577:EE_
x-ms-office365-filtering-correlation-id: e4356d6b-c9e2-473c-700c-08dba3f57f8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 34VjMMJYUL1EaK2t3Q0n2jiE0NtTvl2wkQBjBbat/VzLW3oI6lgvG1AQgKMNSk7X48JIBA6cEbMHCLdAKJcuo2pjOTLffHAYH17zk1qci0VEqsaLXsXjSxNQ+FXyKA8xBrPbc8lWXaxBHJNl9TEdUOFcOd4tQYamBecvGTmX29oPKEsR3Kwp/ASceAgi2fJVnoNXbsTq6NHGD1lU/7DiAoqszh7T0Tc6bT2reDZGTi2ZBTU4LOkV6njXUgcxovh9kYHs8FdVd6mnF9oozKBoBIbJZTmbVUOWyziDFXM86DW5hCLkXVYSJug0qi0WNErbu2RI6b+NnpxZMQFqYFWhXlmfLOA9KecQQVu0UynYlqGrO5PScB1vABaQFk4My6Co2XYopfD7oV1/1Y3HCs889XxQUXmUaGvtdyyo+xgXF9af7gPzqu97u2lAFnRs38YJjvxz0yOHUMmH31PgfesBHIf+Dj/Woc+/koMnU96Ik8TT9RAICmJF3+mcKKYjt/evT/5lQarhDS3KZPhTJGRzXV2e3ukag/8WDujfLWsiECrlo/UmH6NX1yIQbVT+vKq+ernSeSyXRVej0Kz1K1aHKckaQS+QijPOYgoWfjYvGxlZUmNi6kOd073azAvYh1od
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SA1PR19MB5570.namprd19.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(346002)(136003)(366004)(396003)(376002)(39850400004)(451199024)(186009)(1800799009)(36756003)(478600001)(86362001)(6486002)(6506007)(66476007)(66556008)(316002)(71200400001)(64756008)(6916009)(54906003)(76116006)(91956017)(66946007)(41300700001)(6512007)(38100700002)(8676002)(38070700005)(4326008)(8936002)(122000001)(5660300002)(2616005)(83380400001)(66446008)(2906002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1RRRzhibDBPRXNaTllZbS9FSHo1Z2Z0cGZSMHYvNUY0bmpVK1J3bk90aTkx?=
 =?utf-8?B?eFByRW82QjBqanpPL2FkMkpRNlZOMUNnT2haM29kWlRER3M2YmxuczhwWnow?=
 =?utf-8?B?MFhDSEdPSDhUbVlpNWt0NnkwMmU2ZFMxRkFBbzhJNWRpTzVPdHhTWEd6TGhq?=
 =?utf-8?B?SFk4azhXNUd2ZFJrREVnM0hiWFFzQVAwOVJPWThmaTJiY2padG03bzU4VWtP?=
 =?utf-8?B?ZDc5Vmp2aFNUVWsvUjU4UG81NVp5K2RPYk9QWXp3U2lWN1RnL3M1NFF4bHVC?=
 =?utf-8?B?aHpzSXd3TnRtZndDMmFOUmIxamJDdjEzWXc3VjYySUlTZXRZU1NBYUxwRDZp?=
 =?utf-8?B?V1pLVS82RDVwSmRQN1RIelA0MThjUENCTnFrbGFSM0VNR0pSOUsrZUZSTDlJ?=
 =?utf-8?B?RHk4Njl6ZzJkbDFpV3ZwSkx2R1E0bEVHeXliQnpESWhINjU5cnpYNUhwMEZG?=
 =?utf-8?B?Q3gxSS94WEh0SUJuRE1lcXJwTXNvcWpzV0lLWkM0V0R4cy9JQkpETFlIVWlU?=
 =?utf-8?B?UzYweTI2Lzg5WFBLT09uZjUvc05zSi9vT1Y2WjZXVUdkU24zK0VTZE8rTUNL?=
 =?utf-8?B?Q0g2Sjl0U3J2cWJaQ2FGc2JNUGZxaWlLa0xFNXNRNFJSQUxvbEFoZjRZc0tE?=
 =?utf-8?B?VksyMEc5S1I0eUZpRXBVNTRpUVVrbndXR0t3blpVTXZLZ3B3UTU2b2svTmFE?=
 =?utf-8?B?MjE2aUpBRFQycmVoNkc5a0VQN0xzZGNFNTdvZHRZOGRXK1NJNDNHNmJ6SVZo?=
 =?utf-8?B?NzVqVmpRdFVTbHY4MHhaZUFKZUpsaTV6d3ZVOEFNQ1h0Mm4ya1ovUE5Rcm1U?=
 =?utf-8?B?RUxiOXRZTDdHYWNmNWpTMVBMYVpxZ0Ywc1VZa05jcUwwcjlrQjhsSmtPb1FT?=
 =?utf-8?B?ajd6WmlMcEZ0czF2ZHVYbFIrMEcxYmZiV3NJT2x0Wm1ZU0FtZUREc2NSaVcv?=
 =?utf-8?B?bWVsLzVrQnVKcUpJME8zUUlRRkg4YWNRN1huSW9tTStFVW9MR2Y3YXJ5aXFl?=
 =?utf-8?B?eEtaV0JOQmh6dlJOWkhhUFoxblVkSlJUdlkvOTNxWkRoa3h2RXRpMFRSRnE2?=
 =?utf-8?B?VDMyUlM1UmRINnNUUEsxZ1dZbGlVYkZWYTYwQ2duekZrZ2k4SHpTRWJhNVJX?=
 =?utf-8?B?d2xNSVB5TVI1V0dyR3RudEJSTmtjM1RpZ3JWYWt3cnZDMTIzeitYTlB6Tncz?=
 =?utf-8?B?WE5zUzROYngreXQwZHEwUUJOWjd2czBjd2pWSGpORVZick5mMnExeW5ReDVH?=
 =?utf-8?B?d2w0U1ZoazhxVlRKVFVQalNOSHlVRXpTT2NjeDdVVWM4VGpsRlZWWW82UWtt?=
 =?utf-8?B?SU16T2FjdFpxbHRLc2JrbGZlSjNha0JyME1NTXNJWEg4NWZLbEZDbEIxWU9a?=
 =?utf-8?B?TUx0a1hQaHFkNFhWWE81QW9CMHhJRHY5ZG5reUZwMFFBWWtFNXVKTW55TVhu?=
 =?utf-8?B?S1lXRWRvMFl3Z29jcy82YjhVUGNWaUw2dEl2bU1XUHB0czBoZWd6dUdCdkVI?=
 =?utf-8?B?VGRYWXFwTGJDL1BTajdKRU1rejBBeVZ4TmNielBNSTZnWTBGby9xM1hPNjBL?=
 =?utf-8?B?ai9LWWwxdWQ3SFhMV0ptK0RTTm1IL01FMiswZTZ1WmRxeDdEMHliZnF2bzFx?=
 =?utf-8?B?Y3lZVnJ3VnEvcTM4TEw4Ykd1SE1hTnNzT3h5UFhOSmwxU0dGaDgxSWNNNFhW?=
 =?utf-8?B?cDlabzlyYzBGU05uRGVyU1VKaktaaldQMkFzUEhvT3QzWnY2bUFpTkppbEJa?=
 =?utf-8?B?enZFV3diOXRJY3llTm5lQUJEdEtkTkRHYm1mVXZNYVA5dzZJR2ZzUjM5U0Ju?=
 =?utf-8?B?Zll5MGVhMjFwVG1aTnpobWNiazRBU3pUMmFXOTZBVkFMMUlGOXFZTitBVHdH?=
 =?utf-8?B?YzBCOUxYdCtkNEptTVk0MlloU0xLNDVhRnU3amRnSFVQQUl1ZWN0Q0tvd3VY?=
 =?utf-8?B?eEtRNDk2cWY3RCtjeHZ4M1ZOOFNFSmdzcVphalRqeUxzSko5UXA3aTRvTVcy?=
 =?utf-8?B?aGZubHlGeVB3U1NOd0IwdFJwLy9udkZVb1k1MVZiVEhaTUtSbENISjdkSUZC?=
 =?utf-8?B?MGdLdFQ1RVlScDlCLytoK1hGR3JtTUw3QkxNSjRORFZlYkRIWHR1MmZiYis0?=
 =?utf-8?B?N2VPMUlKQk40VUxyT0c1eWJ2N0pPcnAyZHkrV1lIRkJOVHNkcjdocThGUllT?=
 =?utf-8?Q?j0CYn206cBTipiYl7dJ2R1N6hCPO13jwy3++bswyfnDH?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wQptDC14NaiV823ebZG+3bvAIk1ItrqWTmMdMRsWatc3aUNopAsnjdO8bkAsVz4PhI1qOBYA31AQzuYFL6073nducvt09GvSBp81JFmEeM5XdHjIDi2uP1cr51EEBu3lWithNGcG9S35bp8CeEatzSpF/OVmoqo0s/cUK7grV3t7cygMiCySPux4SOlA+RlNaEDz8S2klcoE5D0UkvcBmyLpQPX/7Tkz1Dg9j7hb3yEEWsDvQXw8kV5Il07k150NiQ6kXyopFzQIgl9iF5epb+3bYMBTZRQsV8BG0E0+rIJBvbL1mycb0gmVeZ71CJhMYH/LsMlJNc8b8v2JMD+ls6EcwEMyLZDOVJtNe/3bMdlztWZJNJWOfdgQYIs8mjd1hvAXy7afEIRmvMaJzNLMmY5svzNi1UZ6mdceHU2Iy3B4cmnizToS36p6dfRWNwjPWGZKi4+ditLvJOgg3K5+OzXmIEKggJ0bsoohh6chBkBZZRY4vSScVTpIrGJZrPsx+cKRG+PAnVDtqgljBbc5fk7xZLE1Kfm9IkYrVzigUpA+MXf8zORllGWiADAWtrzQYMlnNxT3/Xfi/1pY0IP42dDlvAS42tA52gVGPZJTpX3OH7EEXAEd6+rV+eJnfCJVAlWNP19d3XotZBWWloQVEJtCiMDynEJML0o0B0VGPctDXpHe49ZsXKg460G2JkpinHPy30LskQh5lLMFrPCEPCl3Qi6TyqPPkbl705LCRCr9VK9bKTdmn0hUURbGMICbl7GhAvAKAAQrQMWlL+EYy/nDO39TdYOqG6vl0NNvAzFeaw6EPAlRkwLJQXzFJkpU
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4356d6b-c9e2-473c-700c-08dba3f57f8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2023 16:25:00.5213 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QpFrUft7ObRkbvU/O2vHxoQjMCttwTlBl4Lx0ellr6Z1Yhr97utz+HiCVOX31cMgBsGnXxsaOODPIVHw5CDnVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR19MB7577
X-OriginatorOrg: ddn.com
X-BESS-ID: 1692809854-111242-12352-142-1
X-BESS-VER: 2019.1_20230822.1529
X-BESS-Apparent-Source-IP: 104.47.66.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGlsZAVgZQMMk0xTQp1cQi2c
 QgzTzFzDTZyCTFPDXNwMDILNHSKMlIqTYWAATAByNBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2,
 rules version 3.2.2.250340 [from 
 cloudscan20-139.us-east-2b.ess.aws.cudaops.com]
 Rule breakdown below
 pts rule name              description
 ---- ---------------------- --------------------------------
 0.00 BSF_BESS_OUTBOUND      META: BESS Outbound
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of
 KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] libmultipath: fix max_sectors_kb on adding path
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
Cc: "mwilck@suse.com" <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ddn.com
Content-Language: en-US
Content-ID: <96B7A2A26EC565428DA1CD4D1DDB64F1@namprd19.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Etienne AUJAMES <eaujames@ddn.com>

A user can change the value of max_sectors_kb on the multipath device
and its path devices.
So when a path is deleted and then re-added, its value will not be the
same as the multipath device. In that case the IOs could be mis-sized.

On reload, this patch re-apply max_sectors_kb value of the multipath
device on its path devices.

Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
---
 libmultipath/configure.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 4a1c28bb..639c0905 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -593,11 +593,12 @@ sysfs_set_max_sectors_kb(struct multipath *mpp,
int is_reload)
 	ssize_t len;
 	int i, j, ret, err = 0;
 	struct udev_device *udd;
-	int max_sectors_kb;
+	int max_sectors_kb = mpp->max_sectors_kb;
 
-	if (mpp->max_sectors_kb == MAX_SECTORS_KB_UNDEF)
+	/* by default, do not initialize max_sectors_kb on the device
*/
+	if (max_sectors_kb == MAX_SECTORS_KB_UNDEF && !is_reload)
 		return 0;
-	max_sectors_kb = mpp->max_sectors_kb;
+	/* on reload, re-apply the user tuning on all the path devices
*/
 	if (is_reload) {
 		if (!has_dm_info(mpp) &&
 		    dm_get_info(mpp->alias, &mpp->dmi) != 0) {
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

