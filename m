Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80002C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 22:13:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-zgbbse3ZN4GDqM_ywpR_jQ-1; Wed, 02 Feb 2022 17:13:52 -0500
X-MC-Unique: zgbbse3ZN4GDqM_ywpR_jQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B5841091DA1;
	Wed,  2 Feb 2022 22:13:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04C359A32B;
	Wed,  2 Feb 2022 22:13:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12C0B4BB7C;
	Wed,  2 Feb 2022 22:13:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212MDhWn022297 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 17:13:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 317EA1457F16; Wed,  2 Feb 2022 22:13:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C9101457F13
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 22:13:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF64380406A
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 22:13:43 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-203-TsHfVs5KNF2MS6SFTu5B_w-1; Wed, 02 Feb 2022 17:13:39 -0500
X-MC-Unique: TsHfVs5KNF2MS6SFTu5B_w-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	212KwhWZ023474; Wed, 2 Feb 2022 22:13:31 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dxnk2q386-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 22:13:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212MBSEd137607;
	Wed, 2 Feb 2022 22:13:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by userp3030.oracle.com with ESMTP id 3dvtq3mvmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 22:13:29 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by DM6PR10MB2827.namprd10.prod.outlook.com (2603:10b6:5:6e::32) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11;
	Wed, 2 Feb 2022 22:13:26 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 22:13:26 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v5 5/7] pmem: add pmem_recovery_write() dax op
Thread-Index: AQHYFI6Ncz9/iVrSZU2vUZQLJAd6lqyATK0AgACOaAA=
Date: Wed, 2 Feb 2022 22:13:26 +0000
Message-ID: <da884fa0-1cf8-b8d4-ba4b-4a4ebda70355@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-6-jane.chu@oracle.com>
	<YfqKkEB3gBsiuMZt@infradead.org>
In-Reply-To: <YfqKkEB3gBsiuMZt@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 468767e2-15d6-40b4-02c3-08d9e6993c57
x-ms-traffictypediagnostic: DM6PR10MB2827:EE_
x-microsoft-antispam-prvs: <DM6PR10MB2827D964FF28340A599BD5EBF3279@DM6PR10MB2827.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XR3XNRu+uguPyZf7P9P6Ky6dqZ5t5zjp8JimUk+iI5Ukmj0BWf/Otap8q6floYFqpe/BhojVXvjsodKh3VuQxWeEA0PXclBpTiQWVv6BT04ZEbM3ms7k51HySSinalzEmCQrxEsjnVTnqWkfNzcqjBHXii2pCPGIe6yPbYfYD6r2Is2QhxbIex5wsxv9xEs2jC1uLfT1TIkpgxh8kjmgg7ulsFOexRCJJDXV6ijlil9zYkNEI0f8On3QlBDAFIlaO3FNcZApYEsJhYZrPvKnjaxIDMpIjxwcSJ6gYtJtifLVM89INygQbBnGOgQqdtD6BXIpyroC01Xq0G6LD5LJCtEMBDb1iOD+Llz3TpDvDJH1V5JcYrDMZpGPS9siA1kWnB5Hckl/mnN6BGQ4flPdkjtyo2Q9cUgo7cOYuv+Y3UMPL02Fvq+HU+b4/8vec3lllnjYJn6EEpwa1QRvEsQyiJ472/DytG+z1FeICZIzwbqZnKrHBxoNJ2reAWxPxpZ8NSQs5rBajvlcQBhoBpMdfCq8MOcWVxtuBLrJj5JNm8bNzdasb2dB4z2g/8IXjsMIDjB73xqCuYqN2R/gnTaOR4o3DkXWDLViOPsQPtipN6G8ZCQFdBEVbhchOAPO99sd85VGLaYWv4KAuz4XG0GNc1DaQKvN29iS+F1WVKmoKJsol62PrZo2aABVx6eMLJCuCKIRLvVaC7e6O3XpQ3ySmrZ9z/LIwORb+HgYp6dEmCD/3dgyd9sdV4iaq8PN8XHvQDhsZ4XlbvicVuaUYa70bA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(31686004)(83380400001)(6486002)(36756003)(26005)(316002)(38070700005)(122000001)(38100700002)(186003)(6916009)(54906003)(76116006)(66556008)(6506007)(53546011)(2906002)(7416002)(64756008)(86362001)(6512007)(66446008)(31696002)(66476007)(44832011)(5660300002)(4326008)(8676002)(8936002)(66946007)(508600001)(2616005)(71200400001)(91956017)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTdyKy9ubS81dVN6cm52Rmk0UU51bWd2ZzNlNU52YmxnMWt2ajNXR1diMXVp?=
	=?utf-8?B?cENjWVNaWVRTYnZsMytqR0dRdXYwQUN0S0J2eHFxTjUyYi81VU9DaUlpVkhz?=
	=?utf-8?B?NXRIUzFkVklQYXhJQVREUXM3YmhPczRDZkwwVmlkTU11TmF2enUvRUp2Z0p4?=
	=?utf-8?B?ck15VlhtTFlEdXR2cVNPWXBJL0dzcVdBNmFhVWxmTi82aStjWmlWenJMUXVU?=
	=?utf-8?B?dUl6S2tGRktZYklRNFc2MXl4UlBHUVp2UkxueEl4QTNUUWlLK2lNUW8wY1Nu?=
	=?utf-8?B?aThGeTgyVDgwK0VRazAwZzVqL1ZoMWFES0YyRWxRZHBTQzQ0MU45RURxQlpS?=
	=?utf-8?B?MDliUzc4Q0ZFeUxDc1pFOW96Y2Z5T3hWOWx3TGRFTEdGbzBXM0RlZ2txM0R6?=
	=?utf-8?B?dmdONU01N1RSR3FveTB5RjhETy8rak9VYjZsZVJoTklpMHFCSE45N09Wc3NQ?=
	=?utf-8?B?SGN6cEY2d1NnOGFKMnJYdTl0bFByWUQ0K3JLenBienhwdmt4Sll1NG81THFo?=
	=?utf-8?B?U3B3Y08rSHd0NVJlOTFNenFRMWxyODcyRm0zaVIxODhHOXRmVVlHU2g5K0U0?=
	=?utf-8?B?VGxkOHpwTkp5dVRRd2w5SEI4NzBIMzZHamNWdDZqbUpIZnFQdURGUi9iQTI2?=
	=?utf-8?B?OTdWV0FkdytMTGNaa2tsRk9uNGY4Y3lZSGZMMG41YW40eHRPRkU4V2lPcWhi?=
	=?utf-8?B?WXR0T0JJNldOTjJaVTVjaGpReldKcTRLU2NBMnpiOGIyQnFsQXRmS0N0aXBW?=
	=?utf-8?B?ZWtFYXFWSnZYdzgzbWpuNG50eElqSmJZRmsxTzRCR2hzOGVWbGxpUnZiZlIx?=
	=?utf-8?B?VnJyaVRyUGUxYkxKOEJMRDNyeGJXOVJSWW1meTNybGc1bE9YUkJnV2YzREFy?=
	=?utf-8?B?OFpOTXVtQnh2MllXK1ZrZWZuYmxJajFCOVY0V3oweGlaNmE0ZndTYitoNEJR?=
	=?utf-8?B?cmlwaG5aZmFiRldIZndnSTlFVDF1cnRzM0ZKQWw0dWhDNUZnSHVwYzkvckxL?=
	=?utf-8?B?NkZOVUcvanBkdjh2Vy9TQ256Tk81WVZkdHB3bFZJNG5rVGt4MXZsOUl6UnZs?=
	=?utf-8?B?V0k2czRTOWxQbU5TOW43VXpvemQ3Y2VkL2xmNnhkNGE1K2tMRjBRWmZrQ0M4?=
	=?utf-8?B?S2xYdXhNR1NIdDNMWHFVYW5TQXBLMVMyZ2lQNVBMTkVuRm0xdWZheDFJWS90?=
	=?utf-8?B?Y24yVlhvNnUza2lxdGJ1N2s0NVdGTnVsaWdVSEY0VHZZT1M3S3g4S0RVV0hR?=
	=?utf-8?B?bk1KUzdBemJqMnlGdHBvZktncmIvSVg0allnR2JCakVvWWkrQjFIZXVldWQ1?=
	=?utf-8?B?OUxFcTdRcFJ0ZnlLcmUrQWxaWFhldEQvQnhXa0pxVDlPbHRsaW1GZFVScjVU?=
	=?utf-8?B?enFoU2cwQjkwR2tNL3BpM1hhWk9FY3NwU05zanYrV2hudEtGZzRLemRmVk5a?=
	=?utf-8?B?NjYxOFlQVHlMUTYzNTFqNXFjdE5rK1U2RG4yQm5CYVdDbUw4YXVTQmdkSDJT?=
	=?utf-8?B?b0J6M0ZCMmhrU1lYMmM1OVA0dVpwQ2IxMmJYeGpBemdUM3JXQzQyQnphV2Ni?=
	=?utf-8?B?N1Y1MFpETU9sd1dKNXgrRlFNcDN6c1Z2bHhUVXBrS0NJV3JQdVpvWURaVVhD?=
	=?utf-8?B?RllXcm13MEcreUUzdk83SFR0UEMyUlRvdXRUMEt4dFA2bzRoNmxub0ljM1VX?=
	=?utf-8?B?QytHTGtEbWxhZzV3SGQ3cXFQTFEyd2RXVy9Ob2FDTjdpK0Vrc0NFVlR1dXAz?=
	=?utf-8?B?bEZnYnZYb05vdmZkdDF4ZFpaVjNIc2tBM3M4T3NDQmR0VDZzamVWWWM2c1ps?=
	=?utf-8?B?TzREaktFUGc4NUN2RFBkenNPbzRkY0RyWGVLNkZ6MnAzeFljcUNjQ3RtWnZs?=
	=?utf-8?B?ZzBFS3d1em9tbVRzWmw0WkFqaEh1VmthMjVrWloxOHhQM0pNTWx5RXVlSTJu?=
	=?utf-8?B?NW5NdEp4MWFwSkc4eUFEWWxrb2pRRks0Qlg0VGJEbFl1WGc2RjNwdFFsTWk0?=
	=?utf-8?B?NytWUnhISmttaTVHWFNYcG1tbjJxbFNWOWVwRk5welJrRFVYbUZRNDd2bnhq?=
	=?utf-8?B?Y0hOTDFqVEEzaElQaHhVNS84elpiMDNucVFxbjE2bmpDTW9yUzRpUEhpaDY3?=
	=?utf-8?B?QldzYUVKTWVIVFZxUnR2TnBNZW1Sc0dTWlZGejFLT1laWVJFNWFSS3JiTUFv?=
	=?utf-8?B?RFE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 468767e2-15d6-40b4-02c3-08d9e6993c57
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 22:13:26.5574 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kjMKnlg0zNpY6JxkEXi6MUentDir/u8rxygzn/HXvmYE+8bvBrtXBs7B6VqL79sY3ki2+gfyqo1jmWKddu17rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2827
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxlogscore=999
	adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202020120
X-Proofpoint-GUID: M4NsJd-zr0cg1sk-Zh-okqnNlC-UjksB
X-Proofpoint-ORIG-GUID: M4NsJd-zr0cg1sk-Zh-okqnNlC-UjksB
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212MDhWn022297
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
Subject: Re: [dm-devel] [PATCH v5 5/7] pmem: add pmem_recovery_write() dax op
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DD5F84E228DDE4489FFA6E0A4346BDA2@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/2/2022 5:43 AM, Christoph Hellwig wrote:
>> @@ -257,10 +263,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>>   __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>>   		long nr_pages, void **kaddr, pfn_t *pfn)
>>   {
>> +	bool bad_pmem;
>> +	bool do_recovery = false;
>>   	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>>   
>> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> -					PFN_PHYS(nr_pages))))
>> +	bad_pmem = is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> +				PFN_PHYS(nr_pages));
>> +	if (bad_pmem && kaddr)
>> +		do_recovery = dax_recovery_started(pmem->dax_dev, kaddr);
>> +	if (bad_pmem && !do_recovery)
>>   		return -EIO;
> 
> I find the passing of the recovery flag through the address very
> cumbersome.  I remember there was some kind of discussion, but this looks
> pretty ugly.
> 
> Also no need for the bad_pmem variable:
> 
> 	if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, PFN_PHYS(nr_pages)) &&
> 	    (!kaddr | !dax_recovery_started(pmem->dax_dev, kaddr)))
> 		return -EIO;

Okay.

>
> Also:  the !kaddr check could go into dax_recovery_started.  That way
> even if we stick with the overloading kaddr could also be used just for
> the flag if needed.

The !kaddr check is in dax_recovery_started(), and that reminded me the
check should be in dax_prep_recovery() too.

Thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

