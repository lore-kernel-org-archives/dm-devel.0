Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 611D2C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 23:46:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-yAom8FP3PkipGCsjFMljsg-1; Tue, 22 Mar 2022 19:46:05 -0400
X-MC-Unique: yAom8FP3PkipGCsjFMljsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC72085A5BC;
	Tue, 22 Mar 2022 23:46:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7E7C1121331;
	Tue, 22 Mar 2022 23:46:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 721B81940340;
	Tue, 22 Mar 2022 23:46:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22AFF1949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 23:46:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D70B4C202CA; Tue, 22 Mar 2022 23:46:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D19D2C202C9
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 23:46:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B407885A5BE
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 23:46:00 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-pb-KsG2rNeCw3qvWcUhNdw-1; Tue, 22 Mar 2022 19:45:57 -0400
X-MC-Unique: pb-KsG2rNeCw3qvWcUhNdw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MKxOsj017238; 
 Tue, 22 Mar 2022 23:45:42 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcqu8x-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 23:45:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
 by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22MNaOZB087024;
 Tue, 22 Mar 2022 23:45:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
 by aserp3020.oracle.com with ESMTP id 3ew701dcs1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 23:45:40 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BN6PR10MB1876.namprd10.prod.outlook.com (2603:10b6:404:ff::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 22 Mar
 2022 23:45:38 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%7]) with mapi id 15.20.5102.016; Tue, 22 Mar 2022
 23:45:38 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v6 5/6] pmem: refactor pmem_clear_poison()
Thread-Index: AQHYO1qtZS40sRPvMkmJ+l2u68rXNKzLHcWAgAD5YYA=
Date: Tue, 22 Mar 2022 23:45:38 +0000
Message-ID: <20fba522-c978-8d6b-5498-8e768897a129@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-6-jane.chu@oracle.com>
 <YjmOb0dSY9GG/Q6r@infradead.org>
In-Reply-To: <YjmOb0dSY9GG/Q6r@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5232691f-e6c6-494d-abe9-08da0c5e1152
x-ms-traffictypediagnostic: BN6PR10MB1876:EE_
x-microsoft-antispam-prvs: <BN6PR10MB18760863D747759880893611F3179@BN6PR10MB1876.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CQTRBg1ppE7EbOTZV37PHHSUunoAwODf7ZMoNQq60wNNboTlP2MEdQjRUN7craFjGFhoi/HjYAJ6l99kf4hkdHrTBiY0zO3BvGn3OQWkXWsE6Ylroq0mOSjzJL8THfAexp9ciCR1vvqJCTl/VA9Th0yOJ9XnXeojhn3xqZkoWs3cRVvOrlAk+r97fOTg6ethPaNqMKOychD8Hyw5gg8l0vH07Tm1ywjUoNCaS62D3XeCkw6wQAQPx8Y2LqBShXukSCRRcpgq8Tl6YMGZnrO5Ch7lWoRyEOvFBGzS5K1JTwfDwp/IW1RdsdKBkhBP+yuKsAhdCeJIgd918aVn6wnh24lHOtWTPLjpkoJo2F/22YPkPX1q8/fpzGr+vKqdUuPxW1cM3Ba83DItXoLyUeSDPyyHQks2WZgQatTCYASJm5/FdxycHqj7i6xXatj5k+cZfFIxHKT5f+rpA24yP85992zjmEhxlR76MyILyr/LdCQndVTGAT1dm5aWYz5w7dEUUgG7wl+uBwow9c7PpT73NKIqeofclExTQfXVIZ1X4GkP3whOrVxE9koV4xAb73eL/qH04+CXZnXQFv7Lw/aCQrsf4xvG5D1yBsFKdXBdkaaaXgnel3qpBVa3bN0dkE1rHPo96p8yvgRH9It7yDv6bAVuVaEKgDZe6rrsg1nDiP2ekaq9YQAktrjXjGd5ZwIEkFg4injjIf9gF3159so8NPlSuskaqtFwXVl6QV9M+9jb2irgei1Pw45zdaHJ/Ih/jaGT2yNL2AesC3898bAi8Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(7416002)(5660300002)(8936002)(6916009)(54906003)(2616005)(316002)(186003)(91956017)(38100700002)(8676002)(64756008)(66946007)(66476007)(66446008)(66556008)(76116006)(122000001)(53546011)(4326008)(6506007)(83380400001)(6512007)(71200400001)(6486002)(36756003)(508600001)(38070700005)(86362001)(31686004)(31696002)(2906002)(44832011)(26005)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3QyNXJQRmtIMWlsbjVLUFFLUFI1WVpOd1JTcEdHaklsQjAyS1B5UFJJcHp3?=
 =?utf-8?B?UVhaanRIRGRwajVIWXBlQ0xhencrRFNVNVhFTjBHK0I2VDJPVFFWUk15dEow?=
 =?utf-8?B?UlEwNCs2b3FydiszZ29qbEp2YjNZNnh5MnIrZ0FQRUs1Y3E2cnNtWVF2Tm5O?=
 =?utf-8?B?OTF6U3F3MlplV0NSWGR5YklDSVpCTk5JMy9BZ296bVNjK3RHN0NtSENIcVNK?=
 =?utf-8?B?VUlWUWJadk5Dc1Z2NXhrNUdoQURMRWRpMm1HbnVKYmNhRDUzQ1JLeTJJUjl0?=
 =?utf-8?B?MGpBWVFXczBJVDV4d3lqUUUyWmo3M0p1Z2FIMktYRGNvcUtsWURCcTB5QTdO?=
 =?utf-8?B?eDlMOERzOFJwZWtDRXg4Qzc5Z0JQK1JTSExCSFJPOHNpMkUrU3AwdnlWbjRH?=
 =?utf-8?B?TTA5VzdpN0pTakU4OUhST3I5S0hPU3hKamIvYWFzWnJIU2N3MFZCVmZyeUNH?=
 =?utf-8?B?b1hmd29WbkptSTBZVllrQ0hnd1k5STkwNUgxblJub1JCbU4xYzEzZ3ZQd2Na?=
 =?utf-8?B?bldDVW5PUk85RTlET0dpNW9mTXRPZk9nU3kxWHFOc21sajZXZmpmQjVmWUp4?=
 =?utf-8?B?Yzc0VDI5QmowcE1WNWNSZ1o0YldBekR1TnpWbk0xY3h4Zk5BdVhRUzVoMjY2?=
 =?utf-8?B?clN6UUIyVjZEejdadGhvcElzN1lNZlFGQk5yRlBnVTVEUFFRZHFIdFZCMi9K?=
 =?utf-8?B?RDkvUUZhZnFKcmJVVGRBdnlETFI5TWNqdFpVZjd3RW8xTEE1WG8rLzJ1Nk9G?=
 =?utf-8?B?OWExSWRqMmd6ZTg1T09pejZDRzNLMGZ4R0FkdFJiTFpOTkVxd1JyUWxqeVpF?=
 =?utf-8?B?enBvQ1hIK2NCZllOSDI2VHVUL2MwYVBodE85VUdBaGZZZHhXN2swQVJ1TE8y?=
 =?utf-8?B?RVhLUnVkT0lQRllGT0xsL3RHOTFuaHpFeGRjK09qdHN1a1B1dTVod2JQYTZB?=
 =?utf-8?B?c3Z1MjNuMHYxTmVUZGlmWWxzb0lhTG0zQjIyakVXZUEyUHBOVms1Ym9XbG1w?=
 =?utf-8?B?MkozQ3cxTCs1SGtEUnJWTUdsaHJaV1A0VENRMi9DQjJDZE1ZV2d0dXNrTkVa?=
 =?utf-8?B?dEpYSkFOa1lFNXJ1YmhvaDZiZEhySXJoRzU4SVNLaFVlS1JJRFdrbmF4ZFhX?=
 =?utf-8?B?QmVHNmJFcWMxTGI0dVRCRXJGNDl4ZVRPR0k5NzdiYUVMNFFzcGZxOU10dnRU?=
 =?utf-8?B?b3hvVXNQU0l2ZWI0Rnl6cFc0TDV6MURoSnBQb0pDdE5sZGlncVlOOTA2WGcy?=
 =?utf-8?B?ZTlhODltQUpUS3RKSmNXK09udHluQzQ1Wi9IcFU2NjVPM0xiV3ZLN0RkaGxU?=
 =?utf-8?B?ZjRJSHYwaDhsaXRldysrMHZGc0NjUVdqbDU2VjZzRzNvMEZFbkh1aHVCeXRm?=
 =?utf-8?B?Zm5RQi9Ta2twZjdvMnpudVZXd0dJVm9wRm1RSjZzN01HUHRndGcreU9DZThF?=
 =?utf-8?B?ci9DUlRGQnVMYno3YndPeTF1S09hSHFiOHVRVHFCTkJHTzNDMFFTem9UNHgv?=
 =?utf-8?B?WjdEUWZ6Qk5NVGpGR3BwM0RVbW5wSUl4Uy8rSmowck52MUlpY1JCSEM2OCtL?=
 =?utf-8?B?eUwwVlhvQ2ZKRS9uMXBLY0k2RjBJbTUyN3ZTeHBRYWlSV3NsenBzU1RqRmF0?=
 =?utf-8?B?enZibG52NUVuODFTcEoxWlZTS3JXczd6Rm43WnlpOHgwS2RoZzlJTTAyeDhD?=
 =?utf-8?B?eVVQb2theWsvT29tREVSOXVBMXZ1OHhMMitBYmhsYzVlOWo4Ym9pZTJBSFZh?=
 =?utf-8?B?eGRwb3BvdTRUelRYVnhvWVpnYXB3bWhVd0RsVS9nMGk1YmFqNHVXTlhrTHVi?=
 =?utf-8?B?MER5UElxM1J2RWNZYmJwN0lkRDdqYXpEWHdzVy9nSXF6cWE2SnVzcVZwMWFx?=
 =?utf-8?B?bFVTQVBEODRTVUtINGlqbmgzaEk2WHB0QjRiRTk5bE5RemFYMkRRWi9RSHVo?=
 =?utf-8?Q?hB7AGn1GoSWxiC7+3/uhSqBoMPFe7Yyu?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5232691f-e6c6-494d-abe9-08da0c5e1152
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 23:45:38.3123 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiNjwg9cUpAIoL5eBWDHxeu4J6G0j64oteUBkXuysaCChfRgbaF5RiftX4w4hnwIdr+N1c7uS0EZ/CTcCjvg0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1876
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10294
 signatures=694350
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220118
X-Proofpoint-GUID: VXWfLBM5RgYvil34TaZkgkJ6ebVTSQwu
X-Proofpoint-ORIG-GUID: VXWfLBM5RgYvil34TaZkgkJ6ebVTSQwu
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 5/6] pmem: refactor pmem_clear_poison()
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
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <873A5AE97FD1CA45A1362A287DBE5C30@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/22/2022 1:53 AM, Christoph Hellwig wrote:
>> -static void hwpoison_clear(struct pmem_device *pmem,
>> -		phys_addr_t phys, unsigned int len)
>> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>>   {
>> +	return pmem->phys_addr + offset;
>> +}
>> +
>> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
>> +{
>> +	return (offset - pmem->data_offset) / 512;
>> +}
>> +
>> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
>> +{
>> +	return sector * 512 + pmem->data_offset;
>> +}
> 
> The multiplicate / divison using 512 could use shifts using
> SECTOR_SHIFT.

Nice, will do.

> 
>> +
>> +static void clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
>> +		unsigned int len)
> 
>> +static void clear_bb(struct pmem_device *pmem, sector_t sector, long blks)
> 
> All these functions lack a pmem_ prefix.

Did you mean all of the helpers or just "clear_hwpoison" and "clear_bb"? 
   The reason I ask is that there are existing static helpers without 
pmem_ prefix, just short function names.

> 
>> +static blk_status_t __pmem_clear_poison(struct pmem_device *pmem,
>> +		phys_addr_t offset, unsigned int len,
>> +		unsigned int *blks)
>> +{
>> +	phys_addr_t phys = to_phys(pmem, offset);
>>   	long cleared;
>> +	blk_status_t rc;
>>   
>> +	cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
>> +	*blks = cleared / 512;
>> +	rc = (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;
>> +	if (cleared <= 0 || *blks == 0)
>> +		return rc;
> 
> This look odd.  I think just returing the cleared byte value would
> make much more sense:
> 
> static long __pmem_clear_poison(struct pmem_device *pmem,
> 		phys_addr_t offset, unsigned int len)
> {
> 	long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
> 
> 	if (cleared > 0) {
> 		clear_hwpoison(pmem, offset, cleared);
> 		arch_invalidate_pmem(pmem->virt_addr + offset, len);
> 	}
> 
> 	return cleared;
> }

Yes, this is cleaner, will do.

Thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

