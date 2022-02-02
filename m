Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57519C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 23:08:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-1UF-aclHPwGn2t5DJEEA4A-1; Wed, 02 Feb 2022 18:08:16 -0500
X-MC-Unique: 1UF-aclHPwGn2t5DJEEA4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94ED41091DBC;
	Wed,  2 Feb 2022 23:08:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 253BF79455;
	Wed,  2 Feb 2022 23:08:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8FD3E1809CB8;
	Wed,  2 Feb 2022 23:08:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212N859U024800 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 18:08:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D49F0400DAF7; Wed,  2 Feb 2022 23:08:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF6C9401013A
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 23:08:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B11C5803D77
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 23:08:05 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-433-UNIyPnV6O8WH7gxqNfFh3w-1; Wed, 02 Feb 2022 18:08:02 -0500
X-MC-Unique: UNIyPnV6O8WH7gxqNfFh3w-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	212KwYAK013006; Wed, 2 Feb 2022 23:07:41 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9fymvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 23:07:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212N0At7141158;
	Wed, 2 Feb 2022 23:07:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by userp3020.oracle.com with ESMTP id 3dvy1tga8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 23:07:40 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BN6PR10MB1955.namprd10.prod.outlook.com (2603:10b6:404:102::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11;
	Wed, 2 Feb 2022 23:07:37 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 23:07:37 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v5 1/7] mce: fix set_mce_nospec to always unmap the whole
	page
Thread-Index: AQHYFI6GHFAsB7tXYk+ZNKUkZMvm/qyARncAgACF2oCAAB3ogA==
Date: Wed, 2 Feb 2022 23:07:37 +0000
Message-ID: <950a3e4e-573c-2d9f-b277-d1283c7256cd@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-2-jane.chu@oracle.com>
	<YfqFWjFcdJSwjRaU@infradead.org>
	<d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
In-Reply-To: <d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3077c3a2-0fae-4104-3f2f-08d9e6a0ce12
x-ms-traffictypediagnostic: BN6PR10MB1955:EE_
x-microsoft-antispam-prvs: <BN6PR10MB195578A10119D29AFE8398C9F3279@BN6PR10MB1955.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FKwWoDzpONeWPA0Y4LwL1H9KvjI0fuvci7LfNqXIvqNg5nnh9u3Eb3E1d3iiLEltiQNFUQ1tVGA2MymGLPlr/lHg9oGmQyGpBYWUmP7nq4MU7z8rscAAI0lN1+D9IvVKwslSIErpm7nQSjE/bEZ/G4ECc1u0EOAH36yymiAFXdRyFrFKkPssUSnWbIUGqT7UffDoLvzpsSHXTx5V7ZRx579x+hF6utFShAd0rMaPgpSa/h6U2iLurjIDrzmvr/v8MwJNKE+ZCNyusJbi9fEvpS76T1XoaC4xzbMQ7XqpOk85OBOpPGCX5/MZqkdAAHkfzg055qlRyPqygaPh+YhZi3gGvMu/HVnig3mvyoD7NLB7CkvBqHm7M56IivC8ZFayGDMYMYoM1fSPEDNlNVykVDJAK2gLS4VnI9pZTVnxf9UoUOgcVF2bw5hoP/reaiNoWSkXRdizXYaTDdIreJMYxScCIP2PODVtVQLph4hbehHtfJLdJc1vzrocu6pSl97Za6GzaQveVPf7XAK4xs2Fllz8bTLyS/9xDaygBtNZEexZsuZRHa21y8QsqEZ6/Wu84GdRlNnfopKgWWJqy/I9VxHIhoFjhnQV3/W3yjxMjjEidBiznguJkrjQCfEQGn+gT/7UxS1Hz8zIMnjlG0VirJ7d/CnDEYCuuFBgb9iVFoysss6zFIoDBvZkGUfmsGFbjfCM5gCzFBEzy2+4brFTr1CG5daTeDntkSSk+iIaAjWdpRLivIvyIFrF9RpxqtodWA93lBIR7Nnj0dNjvb/Eww==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(5660300002)(54906003)(2616005)(44832011)(31686004)(316002)(31696002)(122000001)(2906002)(508600001)(7416002)(26005)(186003)(6916009)(86362001)(36756003)(6486002)(71200400001)(66476007)(8676002)(66946007)(38100700002)(83380400001)(91956017)(76116006)(4326008)(38070700005)(66556008)(6512007)(64756008)(66446008)(6506007)(53546011)(8936002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVNPaFFQMk1YbXJIV1RHTHhpbFM5SVhXb2l1VVVPdVF2TXVJcGJzSmhxS1li?=
	=?utf-8?B?MGQ5L2NRc25ZVkw4Y1B2VzBId1hQenZWZ1NrbHlvZ3lmK3NMUkxUK3VsQVNh?=
	=?utf-8?B?QXI4SWRoTlNFWkNyUUs1RWNWUVdVVXZxSDk5OWlWTEdHWGhnK093Rm1JcHkv?=
	=?utf-8?B?Mmh3MUY3bWw5aDhVWENxWmdKSHZMbFNBemZ3cmhUbkwvS0lYTGd3OUJPcWN4?=
	=?utf-8?B?TEFkVzVNb2xadHUvTDIxdTdqRDF0Nno2cldUTFRueFMrVWVueUJhVDVkVFpz?=
	=?utf-8?B?bENBV1hzRytKNHhaZmZnR2ZQMlgyd3Y2Zlhhek4rZ1NpM1hreVVTTjRkdStX?=
	=?utf-8?B?MnNyMWV4dnJwUDFPTzlXZ1MveEVmZ1drNVQrK1lsMHBtcE1jK2xaZGhabTdC?=
	=?utf-8?B?bmwxcnBKUStXcEVxYlRtblRIODQ4bDI5QmlsOHF2NG03eTF5RGpBaDl5RVlk?=
	=?utf-8?B?WjBtTEIwRCs1SjQ4TUFCR3Q5RDZseTY1V01GbS9TbGFwNUs3RStkVDMvTTRk?=
	=?utf-8?B?R3pHYUdRRmpOeVliVGZhWEFiTWJZUDZMbTFkYm1OcHNKUEthZXpHVTZGb2ln?=
	=?utf-8?B?eUZsZUovV0RZT3NjNnpnNVpIZFFlNzdpQnd4VGVIRWhzWU1jNGZtTzd5bDZG?=
	=?utf-8?B?Q3kwKzhMTG1YNWx1Njd4ak5pOS9MWlQrN2czK3JqdkQ4czJhSi9QVnFiV2hq?=
	=?utf-8?B?K2g5TUYxUG9BRnNZYVVpRzJNTno2MjRITWQwczFsYUhrYTFPSE5zWEl3Rng4?=
	=?utf-8?B?a1ZSR0hnMFRYY01jc1VoYjROUXR4czZtbHRWME5iKzdIaHpZRVZ0RnEzN05E?=
	=?utf-8?B?WlFBNUNETmxDNDhJdk9tZVozcG0veVZQdWVVdEZ1VFpIYmlKV3NKQkx6Y2p4?=
	=?utf-8?B?ZjhSQTVPeWdKUXZ0V3hRL1VnSnQvclVCUi9ZQ3o2QXIyM3kxS2hXQ2kvdWUr?=
	=?utf-8?B?VndPbTlpdVBFS1NZWktUdUp3OHJHSlNwdGdvUUM3aDdCMXVEWEVmN2JvSkQw?=
	=?utf-8?B?dGgxYmNkN2RaeVljZmJwaDFQMGVTZkpqR1lQaE5xejJsMnRya3o5dXZPOUxi?=
	=?utf-8?B?RytZRFRybk1RM25La2lHVisyRWVncUFlQ0hhK0k0Q0l2RlR2OTl5RzAwOEtU?=
	=?utf-8?B?UytxcWYrS08wR2lkSzVUQVA4bWZtbFo2S2x2em9vU2xFMGVTdE9EL0xXaWxp?=
	=?utf-8?B?K2dTYXpOVkhkdHhhRE5OcC9zeGVqdG5wSmNhV0Y4WkhDeU1Oc0dhaWpDMDJm?=
	=?utf-8?B?bHE2MGhpd281YzRxZW9HVk0xbU5GdVlYY1IxOVVCbklhNVBqL3cwbUV5KzFh?=
	=?utf-8?B?aVhSUnE5YmJvVmRmQmFPenNubTBvb0JLUmVhVUt6NWtFbTVCSk1qRzlpcFBY?=
	=?utf-8?B?TjlOcHNKVG9WYjk5emdkV0R1RmFJcldENGgvR2w2VDc1TkQ3NVR0SUZYZFRn?=
	=?utf-8?B?YldSU0U3SXNGN2RLRU1XR0RTODAyV3lkRXl5MFVJa3I4aDJYUXNaeTRUOUdx?=
	=?utf-8?B?aEk0ck95cUV3WHBqN1FxOGM2TW9jTWJxa2toOUd4MzJpNElaVkRubHJlNWNr?=
	=?utf-8?B?MUh1VmFqWHU0QnZubTg0ME5UUmZtVFNSeFA2ZHVnRUU5SXNFRHhwTndXazJX?=
	=?utf-8?B?dEVDK0Y3c2JVTnFuOEdjNWN1ak05RGZ4VzZ2RDJ1TTRFVW9mR21JRDN0TXMv?=
	=?utf-8?B?SE41bkFTN3N4VHU2NVNPeDFDUmUzMERwWDNLdzc0bDF6aTdFU0dsVnZvUWZB?=
	=?utf-8?B?dWNYR2NqQkMvbjQrcEw3RVNuZW9HSXhFdkhyZEhsUnBsaVdZdW5aWVZ2VkVs?=
	=?utf-8?B?ZUdCZkx0U3hWcWY3VnV0ZHVhOW9tSHRqdlZJTEhWUW5QYW9TZW5kMXNLR0pz?=
	=?utf-8?B?aFhUU3ZBWm5Rd0t6QVBzVmhrOE1sVTlzZGUrRlZoL0FQSGZpWjg5dVBlWGdQ?=
	=?utf-8?B?MCtIWWFxL2E2cEhxdnFJMUp0aUZPb3JFbHpBS3NLcFJpNnBPdTFjVG9IZEo5?=
	=?utf-8?B?Njl3Z0xkYzBzWENIMHJ1YzJHMmVzWFVQUSs4MlR5K2ZJNWVSR3kyWTM0VnVr?=
	=?utf-8?B?RFVsNG9jTE4xU0hTenF1dW9aa29Pc0lLUUNoQjJEUlRyL1JWYk1iclF2UUkv?=
	=?utf-8?B?aWgzZ2VuMFF3NU1KdTlNMlNMMThHYWxqak5FeE5UamtBUC8vazVSa2VDNlVI?=
	=?utf-8?B?VWc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3077c3a2-0fae-4104-3f2f-08d9e6a0ce12
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 23:07:37.5000 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +pDUB6sBDkSahOaLJiwYmn8Mhhz4NKvc1EFJGfszy6IvM+N9C/icIcQ0W+Ad0qPNcniARXf/WF5Ti1PR+EtJVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1955
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxscore=0 spamscore=0
	bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202020125
X-Proofpoint-GUID: 2J4IppWgnVtEhR6wa961RHjlpxxSZiZ_
X-Proofpoint-ORIG-GUID: 2J4IppWgnVtEhR6wa961RHjlpxxSZiZ_
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212N859U024800
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 1/7] mce: fix set_mce_nospec to always
 unmap the whole page
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B22E15EFCFE74341AF8360A8061A986A@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/2/2022 1:20 PM, Jane Chu wrote:
> On 2/2/2022 5:21 AM, Christoph Hellwig wrote:
>>> +static inline int set_mce_nospec(unsigned long pfn)
>>>    {
>>>    	unsigned long decoy_addr;
>>>    	int rc;
>>> @@ -117,10 +113,7 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>>>    	 */
>>>    	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
>>>    
>>> -	if (unmap)
>>> -		rc = set_memory_np(decoy_addr, 1);
>>> -	else
>>> -		rc = set_memory_uc(decoy_addr, 1);
>>> +	rc = set_memory_np(decoy_addr, 1);
>>>    	if (rc)
>>>    		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>>>    	return rc;
>>> @@ -130,7 +123,7 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>>>    /* Restore full speculative operation to the pfn. */
>>>    static inline int clear_mce_nospec(unsigned long pfn)
>>>    {
>>> -	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
>>> +	return _set_memory_present((unsigned long) pfn_to_kaddr(pfn), 1);
>>>    }
>>
>> Wouldn't it make more sense to move these helpers out of line rather
>> than exporting _set_memory_present?
> 
> Do you mean to move
>     return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
> into clear_mce_nospec() for the x86 arch and get rid of _set_memory_present?
> If so, sure I'll do that.

Looks like I can't do that.  It's either exporting 
_set_memory_present(), or exporting change_page_attr_set().  Perhaps the 
former is more conventional?

-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

