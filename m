Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABBAC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:16:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D9C1761181
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D9C1761181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-1SGU0x4wPleNthLOPTW61Q-1; Tue, 09 Nov 2021 14:15:57 -0500
X-MC-Unique: 1SGU0x4wPleNthLOPTW61Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17330BAF80;
	Tue,  9 Nov 2021 19:15:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96EDB19C59;
	Tue,  9 Nov 2021 19:15:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EF76D181A1CF;
	Tue,  9 Nov 2021 19:15:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9JFliG013452 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 14:15:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5F9B84047279; Tue,  9 Nov 2021 19:15:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ACAD404727C
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 19:15:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CC58805C2F
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 19:15:47 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-327-oycC19b1NM2qgH_Ud2fGIw-1; Tue, 09 Nov 2021 14:15:43 -0500
X-MC-Unique: oycC19b1NM2qgH_Ud2fGIw-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A9Ix7Ov015325; Tue, 9 Nov 2021 19:15:33 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c6usnnqgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Nov 2021 19:15:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A9J6eZv006306;
	Tue, 9 Nov 2021 19:14:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by userp3020.oracle.com with ESMTP id 3c63ftf86k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Nov 2021 19:14:54 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB4525.namprd10.prod.outlook.com (2603:10b6:a03:2db::6)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15;
	Tue, 9 Nov 2021 19:14:52 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016;
	Tue, 9 Nov 2021 19:14:52 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Thread-Index: AQHX0qwHA1irfgJJPUKt0/SD8Ofb86v60R0AgADFroA=
Date: Tue, 9 Nov 2021 19:14:52 +0000
Message-ID: <29d2c6ad-003b-8247-4852-00be191db297@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<YYoi2JiwTtmxONvB@infradead.org>
In-Reply-To: <YYoi2JiwTtmxONvB@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65a30664-82b5-458d-d7e6-08d9a3b5351f
x-ms-traffictypediagnostic: SJ0PR10MB4525:
x-microsoft-antispam-prvs: <SJ0PR10MB45257B55DDAE63EBA32E8F69F3929@SJ0PR10MB4525.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: c8hGQz4GNSKv34zm31KpAlxyGoN/TXzt88o4KhwTXWDB87ql5aL+zc0pgxEHNXg8xaIVNQGQWPDI0UocX+eU8NbZwtrOwRQUVLM3W/Zhb8bKAzrVkf/kQnzvFfhtzW6y6HLO20VYQk2WXgVcAwvAOAxtBS1487pwcRse/IDUndhqiSV5ZNBs4Na5REyGl9mSkc5JBmv/doffNFhndSnWgdNZhjcwpoaCwdJXsaH3g6MV8hBawJ0mJ5N0jEgDNrlP2vnLRB88khBbj43sHJNoZV51hzG8JcJ9S1N9MtdK426REbOWXT5lgTt0hXGhlhX785o4I12FNk3ofvqDzx0IC6RlE44lQNU6z28KcrpVpFrbq/0qRxajDtdEIZdi+99mL2FBxl+YEpfIpzNYnuO4gZsg0mtzT6hx2vOYPUKPKIj3yuRwA9XLkSlaeAg55b036pkrSUI/QpwjHmC+xRXjWry6Djt8qnEPd3pZe9MixRmS8AImyAelybzy+Hd+nDaUvtkWfqWN7GgvFeQXbBRqaNVrgetW+HwW9uP+nR6ci2tBiq+kxpHpvglYqDo5Z0vjaqXjxJPnsrk/pVlZnHkDAwdpbAKX4hIFzhteXnve6hiyK7wJg8GA16oQ6lB4tSocGpBdXe38yg68cpzDwk8Tt4ZO80WUydz8CPLbblHa2sWE5NBFDbstSDfcjtKkSqW4+6S/9HZu3/t4TjRzC14UXsqwekyQlYw/96BGnVMQzVUI9Mv8b8AfXVeUhNpMNa2fjgeRZeVe1RIa+eUFWvEPzA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(5660300002)(6916009)(2616005)(66476007)(6486002)(71200400001)(122000001)(54906003)(2906002)(508600001)(64756008)(66446008)(44832011)(66556008)(53546011)(36756003)(6512007)(186003)(76116006)(31686004)(31696002)(26005)(316002)(38100700002)(8936002)(38070700005)(7416002)(83380400001)(86362001)(8676002)(66946007)(4326008)(6506007)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3BYaHBWQXhFb2t6RVF1WDlSK1dUL2dFdFM1bUx5MlNpUkJveXZrbk9oMVJF?=
	=?utf-8?B?blhSM1dhNVlZMkJwRGl1bzBxQTAwb1ltQ2J4UDE2YmNmZGRFc2lMdmxycWxK?=
	=?utf-8?B?cGxUK3ZOTG9GWlZKdjROYVNyQW1vaGM0d2IxN1NzWjJVWGRWZlNCMjJMM2dG?=
	=?utf-8?B?T3VxQnl5NkxSNnZ3VmttVmpQVno3Rk0wMDUrYVVCWW1OeGFlSEdqMHduSExD?=
	=?utf-8?B?UXBzS2UrVHVpU3h0OW9rNGpEWmMxY0UrZUVJUmxiRld6Q0ExSWgxOG9HL1Rk?=
	=?utf-8?B?TzZZbmVEOUkwRE0wWTdzUzI2ZE1pQVdJYnVhellSbzlNUE14ekxtUlNLOUFy?=
	=?utf-8?B?ZlNUSUFDUDZ1bTg1YWNUTisxK2FxaVp1czlNdzFhaGxDeHlIb3VQL0xaT2lD?=
	=?utf-8?B?MXdOUmhLMkRtdHhmS0I4emZueUtuRHY5ZHYxbzhoYUlzNmdlYy9QWW81WWtG?=
	=?utf-8?B?MW1ZMmpxMXNZZDMxWnhkU2pzMW41ZW1wUEJ2NGk5R3VVTkJqM0lTektrenU1?=
	=?utf-8?B?TTh0NkFLaUZsbllTV1VJSFNHNHRVTDgrcVM2aXJaOHJYMTczRkh0VS9lems1?=
	=?utf-8?B?MkloSzRlcm5kNzFLWnVRbDZ0cnBWTEUyVTBpd0lPblIranduMWcwaHJlcHVJ?=
	=?utf-8?B?SnJqZ0duYTkvazE0eWg5dUI5UGhjMXBPRE56Tk01YTRZbmM2N2FYSFdtSHd4?=
	=?utf-8?B?NTUzNEF5c0VNOUMvZE54MjJObVVhbzh5K2lJUnNvQ3o1S3g5LzhOU1Jnd1Ra?=
	=?utf-8?B?OWJoSGl6SlJxZEVHeWk4T291UThETFNuY0QzZ2dmRVByaWdINFBkbWpWbXBz?=
	=?utf-8?B?UkZ5VDg3YVNIYkJqNmFpQ0VNOHJEN0Q2UVRWazJWSS9NUkFsWTRkSlgrMUV6?=
	=?utf-8?B?b1Y0anJmc1F6aVVxdWgrQ3BsMUlUZzhWTyt2ZllINUZ2aHAzZnl6T3lEMzY4?=
	=?utf-8?B?ZkQ4ek9iR1dEWU5RemJuT25NVTBJSkNLeFlDT0FvUU1rb2QydGlmcWs4S1lL?=
	=?utf-8?B?OGlwN0l5SUl2SzdwYjlGVXY3SCsvREtVQmdKVjhqUG1rUDFQdXVOS2hiUVBl?=
	=?utf-8?B?ZDJTWHBpVVM3U2diTWF4MFpqdnhJVmlnNnFGcGFTcnZSUDQ3dm1JM0lZc1J3?=
	=?utf-8?B?TExqQ3h1YmhuUnk5K2x5bEJNZlBJRmhNQ0tvMWt1YXJzMHY2WWYwTzRSZHpT?=
	=?utf-8?B?N3JHbGV5ZU1QblJMNjJRQUhhNjlsVFhhT0Q2Zk9hU05HNTdNQk95d2FFeldW?=
	=?utf-8?B?Zmx1MUxSYUtjNDAydGVUdk5QaVBSR2Mzd2F3LzBobi9mQ3dqNU8yQUJMcFd6?=
	=?utf-8?B?NHhHU3RNOGl6OEx6UUJXRHYwb2FpdmxqNzBsRnNpWnFiWXdwU0ZHT013SEI0?=
	=?utf-8?B?bS9MM1JKb08vT0xKYkQyN3Y4SFJ3ZUt5Q29MZGR0dWtjdTVucDhDRm5mZTNY?=
	=?utf-8?B?NVZ3UVJnSkIwSSs5Q0JzMDhQdHczcjF1NWJ2Z3VuSVZzTkJ1MkovdU50MURG?=
	=?utf-8?B?OUJKNXRmbXhSWlFtaitTVHVzNStKRGRqWG9yUEFOVklDaWpubEg5bmFGbElh?=
	=?utf-8?B?eGNUR2JFS0RkMytYRTZGdXQrRCtoTU93dGM4KzRHSy9NSVp2b2J5aGUvLzEv?=
	=?utf-8?B?aWV4WVAyMzQwMGlNbXI5RGl0Y2RVWTJLMGJnckw5em4rSmUxVWJBazRyUXVa?=
	=?utf-8?B?SENzSjAvcmxtQ3E5RXFCSlVaTWZSNyszNjFDMlI5MUlsTlY4VkdnMHpDT2NK?=
	=?utf-8?B?ZXBIRnFMV2xTV05HdTlZeVpyTlFaQVpQOEorN0JFc0hKWG91M3JoUGhWOVVW?=
	=?utf-8?B?ZlUrZVNEL0UxVlE4T3RxOWhyRXh6WkNyb2hlOHJPNkRxelJzOUYxUVpUNEIx?=
	=?utf-8?B?b0U0Q2VWekpQWEpLRzBHVUMzREh2dmUrclliYnBremYrKzVxTkRWWTFUMlZU?=
	=?utf-8?B?d0F5T05mZXVwMHZrd0loZGViTFdZc0tHekdVazZDUnhhOGxMT0JTQm5ENjRY?=
	=?utf-8?B?cE92N2tHR3ppaTBFcGZJb0ZZOVFsQnVGcFRvRUhwaXRkTHpWakYyVDJBVmRn?=
	=?utf-8?B?L0pwVm1Fek4wdnZTS0kza0NZRC9mRGFlODdlblZOQ2RPeW9WWlVicjVyZUw2?=
	=?utf-8?B?YUdUR0RubWE2K1h5REYyUnZCSFM4ZHNhNk5kR1VCeWR1R21rM3ZWQ1Zvd2pN?=
	=?utf-8?B?eGc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a30664-82b5-458d-d7e6-08d9a3b5351f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 19:14:52.4546 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sP0cAxBWHImFarr1Kypn+udx0rhst0b5wOvN6VN9htbt810CVb+pDoGCin+Hd0AcyKASBXFRvvE/r0ev/r5Usg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4525
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	spamscore=0 mlxscore=0
	bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111090108
X-Proofpoint-ORIG-GUID: zMIcUQO9KmfTu9U42XsxB5h7WJss7R4E
X-Proofpoint-GUID: zMIcUQO9KmfTu9U42XsxB5h7WJss7R4E
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A9JFliG013452
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
Subject: Re: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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
Content-ID: <A11647C57E43FE43AC8BEAF54524A2A2@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/8/2021 11:27 PM, Christoph Hellwig wrote:
> On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
>>   static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>   		void *addr, size_t bytes, struct iov_iter *i, int mode)
>>   {
>> +	phys_addr_t pmem_off;
>> +	size_t len, lead_off;
>> +	struct pmem_device *pmem = dax_get_private(dax_dev);
>> +	struct device *dev = pmem->bb.dev;
>> +
>> +	if (unlikely(mode == DAX_OP_RECOVERY)) {
>> +		lead_off = (unsigned long)addr & ~PAGE_MASK;
>> +		len = PFN_PHYS(PFN_UP(lead_off + bytes));
>> +		if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
>> +			if (lead_off || !(PAGE_ALIGNED(bytes))) {
>> +				dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
>> +					addr, bytes);
>> +				return (size_t) -EIO;
>> +			}
>> +			pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>> +			if (pmem_clear_poison(pmem, pmem_off, bytes) !=
>> +						BLK_STS_OK)
>> +				return (size_t) -EIO;
>> +		}
>> +	}
> 
> This is in the wrong spot.  As seen in my WIP series individual drivers
> really should not hook into copying to and from the iter, because it
> really is just one way to write to a nvdimm.  How would dm-writecache
> clear the errors with this scheme?

How does dm-writecache detect and clear errors today?

> 
> So IMHO going back to the separate recovery method as in your previous
> patch really is the way to go.  If/when the 64-bit store happens we
> need to figure out a good way to clear the bad block list for that.
> 
Yeah, the separate .dax_clear_poison API may not be arbitrarily called
though. It must be followed by a 'write' operation, and so, unless we
bind the two operations together, how do we enforce that to avoid
silent data corruption?

thanks!
-jane




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

