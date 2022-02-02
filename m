Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF69C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 21:21:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-wlPE0jjSOXqm0YK0XhfxSw-1; Wed, 02 Feb 2022 16:21:18 -0500
X-MC-Unique: wlPE0jjSOXqm0YK0XhfxSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8849010BECE7;
	Wed,  2 Feb 2022 21:21:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6EB562D43;
	Wed,  2 Feb 2022 21:21:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17B1E4CA93;
	Wed,  2 Feb 2022 21:21:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212LL5wX018779 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 16:21:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 028C4141DED7; Wed,  2 Feb 2022 21:21:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F16DE141DED6
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:21:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1F61185A79C
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:21:04 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-341-6HT3NJQ3Oa-55UyEFRg3yQ-1; Wed, 02 Feb 2022 16:21:01 -0500
X-MC-Unique: 6HT3NJQ3Oa-55UyEFRg3yQ-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	212KwasE010090; Wed, 2 Feb 2022 21:20:40 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9wf805-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 21:20:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212LBEFf056678;
	Wed, 2 Feb 2022 21:20:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by aserp3020.oracle.com with ESMTP id 3dvwd8yky8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 21:20:38 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by CH2PR10MB4069.namprd10.prod.outlook.com (2603:10b6:610:f::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Wed, 2 Feb 2022 21:20:36 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 21:20:36 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v5 1/7] mce: fix set_mce_nospec to always unmap the whole
	page
Thread-Index: AQHYFI6GHFAsB7tXYk+ZNKUkZMvm/qyARncAgACF2oA=
Date: Wed, 2 Feb 2022 21:20:36 +0000
Message-ID: <d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-2-jane.chu@oracle.com>
	<YfqFWjFcdJSwjRaU@infradead.org>
In-Reply-To: <YfqFWjFcdJSwjRaU@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e30a3f3-94ef-4a13-2ce1-08d9e691dac0
x-ms-traffictypediagnostic: CH2PR10MB4069:EE_
x-microsoft-antispam-prvs: <CH2PR10MB40699A5819058089A3A55A7AF3279@CH2PR10MB4069.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 374/tApiD9yJa8GfqghvmzKOEWSRDH1Q7TQUJcA96yIjbdvEya/41Vysp6kOxTJx0EFXgr8AD2ukSB5S6qn5pGJq+omZnYB3y/Eq8eAcPaYmgsBFDbTKOt9R+HNbdvaMlMDcZprDz7R4rLThScpQ1Rnb99uAXrITppP/kNaG3rAdB6EmytvSFsvF6NaiXSRLSK1q5dYiUp0ysh8BuDkbmkLiN1VNnt384bdAoC5IEv3jcnvyh4cC7toYFFUiJxgOK0sCiYIfGYiKxWHoHnNQ1MyQuQ2k+IRu7M3+pZ4r4W1/JlvwMZboa0uL5SnPz5vS6wTF1Wa5zmKsBDpkHcm8ChAklRBfE9i1/2YSG1qaba38MDNI0CPHhaFJ6H25cpCCJTHKdRMPqMYQp8QgXVCslHELFWwnkXb/XxqrMyBFNf8OQMV2WlwavqCbetnORiRbkVhJM7U4DBdrq52nhZAO+JNXbf54ojpUYvzBJ3UeW9BhXAmFVOu+suAoEmLzojhEQURTDlyG5nDly89U1g67ToeqXGC4BO2Rt5lCaIwTdKr2rsKwQB6FjZVtZ85edJ7MT+U/586VdscDHzbB9ZVMCb/4pkz3ANuEwDWXFDWM8IX2LYvMsH1MLvmB3JdNZ7h6P52QTkzp6DlKMMnWMb3eA2EYYkLtAnp9X73NP/1YvUMHWVW48FwnswbtdIjz7uYhGvwmmxtVuLsZcz6RolNGYNEQa1YhP+eiNJOKdPgOyBHFT8ZX3L4x8RC9mKXeT5MhB6YbosSPbzc8Th/uvANfLw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(508600001)(7416002)(6512007)(31686004)(54906003)(6916009)(122000001)(53546011)(316002)(6486002)(186003)(26005)(36756003)(5660300002)(8936002)(83380400001)(76116006)(66946007)(2906002)(66446008)(64756008)(91956017)(66556008)(66476007)(71200400001)(31696002)(86362001)(8676002)(4326008)(2616005)(38100700002)(6506007)(38070700005)(44832011)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFU2T1RLNXNUM2RCQ3oxOWhldnNTbjA3dzVwRzVNdXhQZk5RU3FXVWpERHhw?=
	=?utf-8?B?R2NjSDltaWlGNEdUUXloa3RKOEZnQ2FqVmlCQ0pPMUx2QlkxZWsrVml6aWZ6?=
	=?utf-8?B?ZmRna3o1VHNkUFZ4dzI5d3MybzhGQU0yZENxUFFoY1VZSXhubXBVcTRBK09y?=
	=?utf-8?B?emVmVjRubjJhOEVZcjdUNjY1Qzk3amJqdVI1OXgzSWxjRTZrS083Yys2MzlQ?=
	=?utf-8?B?cThVME0zczlXTCtTUFNHNjFUYUFYQzcxdHRoYk9Tc2FkeHZDTGY1UC9FaHRH?=
	=?utf-8?B?a3Q4TjZVdUk3aEZWOVEyRFlQNVlDN0hhSWticDFFY0tPQmZ2NXUwb09RdDJx?=
	=?utf-8?B?VmVBQTBEaUhRU3VobWZ1TDRFNG9iajZnZnFsM01KQm5SdUlGdGZYdjRyK0h5?=
	=?utf-8?B?b1lRNE1jUG1LZFhFMzlJOGNuYWUzeXNaSUc5YW1RWGtET1RJdHBHekRIQ1Yy?=
	=?utf-8?B?ZjFyTWhwQk1Hc2V1VG5FdnFmS2E0Mkt5WEcxaWFVRjhmeUZLRStPNnErOGdC?=
	=?utf-8?B?c1I0RGRQSEo0WGJUNXJGMnA5VTVsWnJ4ZWUxR2NzYnZzTEFmSWxmZGNpS0JV?=
	=?utf-8?B?c1hDWGkwejk3YndHZWFLeE1NcHh4N3JjRllhTDVzcGJQTnpZZ1Z3U2RzU085?=
	=?utf-8?B?b2F5bHNtV1R0U2xLaE84UFN0YmdsTHppN29vNW9oZ1lZRjRpbDI2bkpJakh2?=
	=?utf-8?B?SmV2UnM5Z0xLRFUvL1YrdVVWc241NlNyTUVNU2RpSk91aHhpZUpvWkJISFIr?=
	=?utf-8?B?aEtSZjhuWnMrQlF5UGlFN1BRV2NnZFY3NldRNm8yYUlVMHFRMzIzTUt1djZx?=
	=?utf-8?B?UFRCNUVCQjA4RVlKdVRtVzIxSDlXcVJPamcrSUFNTGNOWmpQYXJqWjV3VVA5?=
	=?utf-8?B?Vlo2c2t3dDNRVDZqbUtRL05SbWVvckFtaFZkbkJuWitqTVNnRjRsRklJQnhD?=
	=?utf-8?B?WHZUczlpaXh4NDVDOXFManNWeVpOVUh4Nms3SmxyVTRMN1lDRHo4VjBlSVhD?=
	=?utf-8?B?UERYcnRMU2FZMnVOd0FRL2t6cnNMMFdFUHVjMzJoY0NRakQwZjRsSFVDTFl0?=
	=?utf-8?B?bW9MR3FlWDlRN2RGWHhqUlRiSmlRTkk0VEVmSm03dGZjK1pQc3VOVFJhQmg3?=
	=?utf-8?B?S2NndFRnbC9GTGVEckNPOHduN2pVRHB4emlUYTRBVlIxU2FmaEJSQ09iUVBy?=
	=?utf-8?B?VEtIVWJqbFpDK0VPTFRXVFlVN05sU2RFTFNyenhBVkpzOTBvSmFHRVViVU0w?=
	=?utf-8?B?VTVPQ1cyRDg4NW4yWnpveElqWml6NzJCTmE0Wno2Y0QrNUp3Z1pXaVpMQ1Zr?=
	=?utf-8?B?Y1N1R0ZIVEVtR3VNTzg2cUpiYUVyNCt1a3lEa2FldzNyOFBFbFpPVnlNdXZj?=
	=?utf-8?B?OVFpbEF0RVBuZjQ5YVJ6THQzVDBKTnNHNVdLK3VVR3dGZEhIV0JNd21wSTky?=
	=?utf-8?B?L2x5Wmx2Y1R5cTNwd3ZtZHk1dFZwZW8vc1hjMEVtY1VZTWpnZ0hkL0xMVDJr?=
	=?utf-8?B?SlRYK2dUMmlUbWpOa0RuMXNIcnByUDltUHNLc0hieUdKcFhkQlJ2WGVqNUlv?=
	=?utf-8?B?SGZ1N2tDK2Y0emRBeUQ5YXJua2swZm1iTWZ4elEzQzZBY1g0WVBlY0FvUWo2?=
	=?utf-8?B?WkJQSEY2cW1ZUW10Y3RWRm1sY1Bsb1g1SXZlOVo1eURVN1IwK3lxcWxWam1k?=
	=?utf-8?B?NngzV1BrTlNXbTcvN3ZFYTF1ZW1QTDBEeGZaUEgwR1BzR00vR1FBZ25HTXo2?=
	=?utf-8?B?RUNRaHF0TzduN1Q1MVdQM1ZuUEt1Q2hUNWtmblpERk8rT0x4eTNxR2VER3NJ?=
	=?utf-8?B?blVyMzlDNEVVaVJpL3hpMk1VaUFoQUQrM0JNOXhKTWVOckRMTlpiUVV4TE5E?=
	=?utf-8?B?UHVnZVJRSE5KZ3laVlJtclFzVFVtdUEydFdWVTc0cWUzNm1IeWdINWpjZUpP?=
	=?utf-8?B?RXFTOTlSSHcyVnBNeE92Y3NqUE9DZkNVMFNEZWVrbHlRY2ZZUUk0QWJLSHJB?=
	=?utf-8?B?VXhRZkxFT2F1YUMyZ3h1a1kyOU54Wk4xdEVqbVcwdzBSdExsSk05VElLY2F5?=
	=?utf-8?B?c0l6SmZpOTBwTHBheXJNZ2FDc2ZvV3daazBjMXh5YWpwWFc3cEs4YStqMVpH?=
	=?utf-8?B?YzY0TTFvYlBtSzZQaTFYSG4yY1hNdkU3TzRoNU5VeEpEQndFdTlXZjVmcHJR?=
	=?utf-8?B?Q1E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e30a3f3-94ef-4a13-2ce1-08d9e691dac0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 21:20:36.3059 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8n8EfiZTSrCBNWrYtqHne19HUufWCMCQ7QLZRmIR2GBlr+BcyYgBchwjSlRdorUROD/uHH/NAzw5mponlQbXoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4069
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=777
	adultscore=0
	suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202020116
X-Proofpoint-ORIG-GUID: aXYmKr04kIjfYE-jkRtoz2i4q_3pzTdU
X-Proofpoint-GUID: aXYmKr04kIjfYE-jkRtoz2i4q_3pzTdU
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212LL5wX018779
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <56C7238B3E70A947AC40D5063A519DD5@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/2/2022 5:21 AM, Christoph Hellwig wrote:
>> +static inline int set_mce_nospec(unsigned long pfn)
>>   {
>>   	unsigned long decoy_addr;
>>   	int rc;
>> @@ -117,10 +113,7 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>>   	 */
>>   	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
>>   
>> -	if (unmap)
>> -		rc = set_memory_np(decoy_addr, 1);
>> -	else
>> -		rc = set_memory_uc(decoy_addr, 1);
>> +	rc = set_memory_np(decoy_addr, 1);
>>   	if (rc)
>>   		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>>   	return rc;
>> @@ -130,7 +123,7 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>>   /* Restore full speculative operation to the pfn. */
>>   static inline int clear_mce_nospec(unsigned long pfn)
>>   {
>> -	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
>> +	return _set_memory_present((unsigned long) pfn_to_kaddr(pfn), 1);
>>   }
> 
> Wouldn't it make more sense to move these helpers out of line rather
> than exporting _set_memory_present?

Do you mean to move
   return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
into clear_mce_nospec() for the x86 arch and get rid of _set_memory_present?
If so, sure I'll do that.

> 
>>   /*
>> - * _set_memory_prot is an internal helper for callers that have been passed
>> + * __set_memory_prot is an internal helper for callers that have been passed
> 
> This looks unrelated to the patch.

My bad, will remove the remnant.

thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

