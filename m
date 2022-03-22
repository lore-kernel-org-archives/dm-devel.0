Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06218C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 23:05:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-hGaHfiWoNnu5980j-PzyMw-1; Tue, 22 Mar 2022 19:05:39 -0400
X-MC-Unique: hGaHfiWoNnu5980j-PzyMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B2798564EF;
	Tue, 22 Mar 2022 23:05:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3CEB02026614;
	Tue, 22 Mar 2022 23:05:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA24F1940340;
	Tue, 22 Mar 2022 23:05:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D45531949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 23:05:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4296740D2820; Tue, 22 Mar 2022 23:05:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DDBE4010A02
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 23:05:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 203DA38025E4
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 23:05:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-UB0M2_V3Om-IMwahXmPR1A-1; Tue, 22 Mar 2022 19:05:31 -0400
X-MC-Unique: UB0M2_V3Om-IMwahXmPR1A-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MKxOl0031698; 
 Tue, 22 Mar 2022 23:05:13 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss7wyy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 23:05:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
 by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22MN0MwM032944;
 Tue, 22 Mar 2022 23:05:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
 by aserp3020.oracle.com with ESMTP id 3ew701d0kb-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 23:05:11 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by MW5PR10MB5850.namprd10.prod.outlook.com (2603:10b6:303:190::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Tue, 22 Mar
 2022 23:05:10 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%7]) with mapi id 15.20.5102.016; Tue, 22 Mar 2022
 23:05:09 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v6 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Thread-Index: AQHYO1qr0XYuk2dPyEaDqgStF1AJhKzLIC0AgADrq4A=
Date: Tue, 22 Mar 2022 23:05:09 +0000
Message-ID: <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-5-jane.chu@oracle.com>
 <YjmQdJdOWUr2IYIP@infradead.org>
In-Reply-To: <YjmQdJdOWUr2IYIP@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 406b147d-d0de-4949-5d2f-08da0c5869e3
x-ms-traffictypediagnostic: MW5PR10MB5850:EE_
x-microsoft-antispam-prvs: <MW5PR10MB5850BBAD3C4C06E0C2902F04F3179@MW5PR10MB5850.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: b7+226ffVe0zmPNBms6v1ScYF/bbHWzh9IUTdeE86vpRD3DX/H7dcQZLEimA0oYNZuqMY7+4Mqmy9GpYRjIM0LA0y2URIdgD9FMH+pPkS8FEkOb4NSSQ//Hl1++lwKTIiBbXI0/HVNq7k8s6R8yRzzbZLQ+U/f5a6Tb6ok1eGoZdhcYBYJTckxJgK/VdQKptMdBNMiXqH0RFfI32+3sYNVZBQqR+VEeMDBrrA3C5YN6ILwmR7o2TKlifv86CoSH6RcMMtn2uSwr/iUkRlY9RxqRq8RB13WuP/MysHvX7KB2rRDgJ87SYcawokrdq/w+0sYqWuUonFmxJ0wzKz33Oxtu8xZEGxMrhVOxNXL3yb/zX7t0JlQty82rXcmdbPkzNeBgYJw+dl3xoAXhFnWjb7Re4Ql5keXsHnCXC+YiQEJeW/0nlwyKPOiDfgOcoy9HPX3Pjo6ayCU5Ij7vS2NdrJsAawaevS+zzC6vsq7sIPkeB9j/vRrCbOfry/cAd/yP2D1LkKiHWaEbgC2FOEweFIuuTU9DYSsYVnmdf7+lBHYwCodZhFZs8oxVzhNzrd1WPSn8rBF/a8deiZVYCHJTTyBsbprUhle5KSb3eM0jcI820jFJpKscva2n4C7ePdHxn9MweFOXJRzIATs/CKehKIu7cfSP5/XZqPrnOfjDYlmuGdb2+fsIVIaf1GXwSrimBArKp9lF0s1sIW2+aNuYUve/5EeH5hjH/Ud1jNhAximAzXbbwqaRBKLdWBloJ43r1fFQoKT1XNdfysegv355KgEvpglhxoCyiPGKqWZ1InuzuAPpQImyC967QuPvyoY1R+8f7caMb/YNldbmExNu9v05APIXd/yPxoysEXgVmXEryvSmmTNGbFx2VbWe0d2OrtjVyAdL9J6Z9n/pGowPHxA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6916009)(316002)(38070700005)(54906003)(44832011)(7416002)(71200400001)(8676002)(508600001)(966005)(186003)(8936002)(26005)(2906002)(83380400001)(31686004)(2616005)(36756003)(5660300002)(122000001)(64756008)(4326008)(76116006)(91956017)(86362001)(31696002)(6512007)(38100700002)(6486002)(66476007)(6506007)(66946007)(66556008)(66446008)(53546011)(142923001)(21314003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWFIUU9oVGRSMmdQbGphQVdJMFhUajltR0IwajNKbWtOeXRnUFNnMWpEZUpY?=
 =?utf-8?B?RWlRN256c052THJZSWlWeHpXNUNxOTFRL04xbWtqa3BLU2dGc2hWQXB1VjNV?=
 =?utf-8?B?ZVI5RzN5cloxcGtwWFBIVGY1TEQ4V2JUcHA1TWgwRm9ZVEkwdU9XTExudndL?=
 =?utf-8?B?SDNXVldiaTlsSjBrcENmOWROU25RMGl3MWJLaUQycjhqNHp3dVUzTWFxb3E1?=
 =?utf-8?B?a3hHTDZXRXNDSHpnT05VdDBHZXJCR04vWnJuRUc0WFZsOUlROWp5bWJidlN5?=
 =?utf-8?B?SEtCN0xWODZQbldDcTU3NzdjaGxhaWRCc1JaNFdyNDBvaTBQNytxOE41Q0Fr?=
 =?utf-8?B?cmx3R3F5cUhiaVVIaFZoYzZkT1hURGlJREdDWEluQk0zNXRudGVDdk5iOXFR?=
 =?utf-8?B?aW5BcmcwZWpUQ0RBSlZ0NDR2NEtmTzZ6N3ZqcWhjOFdzd0FEVWsvL2VnSFhz?=
 =?utf-8?B?RzFkdzZhVG4ybjdMUlVWa1Vkc29qT2JxMnZiWDRuNGZSand2V1piOXZmaWpO?=
 =?utf-8?B?UXJqQWQ5Unk5OXpNRjNPb00xRy9mVVFLb2xYbHhzZlhrb1NBTEFudjlBNTdD?=
 =?utf-8?B?OFB6TXJwVzRtSGhHRy9yWDhzL0E2THhBU00zYXM0NlVydUxPcmZDVnpXZXVY?=
 =?utf-8?B?dk0rVUpWbGxzRTJYNktCbWNzVFhNK3JnbFRLRHphVDFuam9SZEs2RnZtT04z?=
 =?utf-8?B?aVNteXFMZkV3OExhVkwvZVFkUmpTSXJYR0w0eHl5SXB4NTdpT1hCUEZNOEha?=
 =?utf-8?B?dmRFNFBaWW5rZUFodUx5SU91akY2a0xnVzNSSTdnb01DTGN5aFpoclNNblYw?=
 =?utf-8?B?SnRodkpzM0JHQXZ1N0NNNW1NTTVOUVNMRUdQZkpiZVpmZFNqRGMzVEQvTHVk?=
 =?utf-8?B?QmNQaDRBcUQwSDY1NkQrU0lzODVqSzZTYXVuaXJFYzM4SEFXM1JuRmF3VzJZ?=
 =?utf-8?B?M3R1UG1zbXdHMEE2TkcrRmc4cjNpNURQQjZqbWZXQ0RaU1BxR1ExKy9IN216?=
 =?utf-8?B?OTNxaTZvQytDMUtScC9qaC8rU0xCK0Q4bE9zQkVqM3pZNDNhSkMwL2Jqczd3?=
 =?utf-8?B?LzB2NnhDWStHa2lLTTRvaWc5WGtiblhhWTVleUpHeDlOaXlDMDhwTVJvLzdI?=
 =?utf-8?B?TXZ5KzRhdEw0bmhTY0dVUHJ5cXQxcnBzQXQzSEJ1NjA5UDdkV1VZMnhhbXVa?=
 =?utf-8?B?SHZpK1o5NktkdWhkbndDdW4xYWlqUWp2WHdNZ3dkQkxNdzI5NFhpU21IeTRB?=
 =?utf-8?B?VmxhbjJTcTBNaHJiWUhSYW4vWkFYenBsNmFsT1dXMU5tbXBkWWZQUTdHTFJO?=
 =?utf-8?B?K3lIdzJFUXhGanNhbHF1U2puaG9RT202Tmwrb04rTE9OUWw4M0U1Ty8reE41?=
 =?utf-8?B?Umw1MGlXN3dnYjArUHMxRWMrNDh3bGl0Si8xaUxmalRYQnNvWFJHcUFrTzVP?=
 =?utf-8?B?NlFtd2FmQVNYd2tzZTRMYU5OcjBadlQ0QTJuTzU0Zm1DY0I2YWVlYlVSS0pY?=
 =?utf-8?B?TkxndjZhMFk2aHQrWWVoWDc3UTl1amhkZGd5RjBmSkVnd1FLVnFUaEhtNHhj?=
 =?utf-8?B?eUsyNGl2MEYyTXNCOE1UclE5N0hxa0FUTks3aG5McWgvbzRjendqQmtob0NL?=
 =?utf-8?B?d2VKTU5lZnVsMUIvU2pKK3ZZSlpYSUd2blFvZVF5cXZsVXBkOTh3aXlGREZv?=
 =?utf-8?B?WjRMRjE0Nkk1a1lQY1NhUkZRUkZ1MHpZS0lzdFliVFUrVEdrVVVZZlJ0eWtm?=
 =?utf-8?B?ck1TTklwd1FhQzM4Z1d2Tjdsc1ppVXdtSHBQckw4QUNPVy9nVmEzcGdla25V?=
 =?utf-8?B?cTNJRGlGQ25QMTNnbEgzYWl0M2RXSXhpVnk4cXV1K0pXT2FDbkh1NmcxMFlw?=
 =?utf-8?B?aGtqZjJzMGo0RDlYMlE0WERXR1YrQ2ZIRFpBb3kvbWxUOE5DOUp6akFDS3hj?=
 =?utf-8?Q?cxB685WVmab4tNFUhGFK6yu+q2SXpcSr?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 406b147d-d0de-4949-5d2f-08da0c5869e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 23:05:09.8728 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FkKlthJ90ugHH7KPose51quhfw0uNbH6MO/SW2dgXu+jf/WgHcFfttJ7fzxVUF5bhCd5SWF0edEUYe3mRKeLmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5850
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10294
 signatures=694350
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220115
X-Proofpoint-ORIG-GUID: 6NbL5qVq9lelEGBPcm11rFV6LqMjNJbI
X-Proofpoint-GUID: 6NbL5qVq9lelEGBPcm11rFV6LqMjNJbI
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8F7728E77F62C744B1FAD3F31A66C80D@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/22/2022 2:01 AM, Christoph Hellwig wrote:
> On Sat, Mar 19, 2022 at 12:28:31AM -0600, Jane Chu wrote:
>> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
>> not set by default in dax_direct_access() such that the helper
>> does not translate a pmem range to kernel virtual address if the
>> range contains uncorrectable errors.  When the flag is set,
>> the helper ignores the UEs and return kernel virtual adderss so
>> that the caller may get on with data recovery via write.
> 
> This DAX_RECOVERY doesn't actually seem to be used anywhere here or
> in the subsequent patches.  Did I miss something?

dax_iomap_iter() uses the flag in the same patch,
+               if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
+                       flags |= DAX_RECOVERY;
+                       map_len = dax_direct_access(dax_dev, pgoff, nrpg,
+                                               flags, &kaddr, NULL);


> 
>> Also introduce a new dev_pagemap_ops .recovery_write function.
>> The function is applicable to FSDAX device only. The device
>> page backend driver provides .recovery_write function if the
>> device has underlying mechanism to clear the uncorrectable
>> errors on the fly.
> 
> Why is this not in struct dax_operations?

Per Dan's comments to the v5 series, adding .recovery_write to
dax_operations causes a number of trivial dm targets changes.
Dan suggested that adding .recovery_write to pagemap_ops could
cut short the logistics of figuring out whether the driver backing
up a page is indeed capable of clearing poison. Please see
https://lkml.org/lkml/2022/2/4/31

> 
>>   
>> +size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
>> +		void *addr, size_t bytes, struct iov_iter *iter)
>> +{
>> +	struct dev_pagemap *pgmap = dax_dev->pgmap;
>> +
>> +	if (!pgmap || !pgmap->ops->recovery_write)
>> +		return -EIO;
>> +	return pgmap->ops->recovery_write(pgmap, pgoff, addr, bytes,
>> +				(void *)iter);
> 
> No need to cast a type pointer to a void pointer.  But more importantly
> losing the type information here and passing it as void seems very
> wrong.

include/linux/memremap.h doesn't know struct iov_iter which is defined 
in include/linux/uio.h,  would you prefer to adding include/linux/uio.h 
to include/linux/memremap.h ?

> 
>> +static size_t pmem_recovery_write(struct dev_pagemap *pgmap, pgoff_t pgoff,
>> +		void *addr, size_t bytes, void *iter)
>> +{
>> +	struct pmem_device *pmem = pgmap->owner;
>> +
>> +	dev_warn(pmem->bb.dev, "%s: not yet implemented\n", __func__);
>> +
>> +	/* XXX more later */
>> +	return 0;
>> +}
> 
> This shuld not be added here - the core code can cope with a NULL
> method just fine.

Okay, will remove the XXX line.

> 
>> +		recov = 0;
>> +		flags = 0;
>> +		nrpg = PHYS_PFN(size);
> 
> Please spell out the words.  The recovery flag can also be
> a bool to make the code more readable.

Sure.

> 
>> +		map_len = dax_direct_access(dax_dev, pgoff, nrpg, flags,
>> +					&kaddr, NULL);
>> +		if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
> 
> No need for the inner braces.

Okay.

> 
>> +			flags |= DAX_RECOVERY;
>> +			map_len = dax_direct_access(dax_dev, pgoff, nrpg,
>> +						flags, &kaddr, NULL);
> 
> And noneed for the flags variable at all really.

Okay.
> 
>>   			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
>>   					map_len, iter);
>>   		else
>> @@ -1271,6 +1286,11 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>   		length -= xfer;
>>   		done += xfer;
>>   
>> +		if (recov && (xfer == (ssize_t) -EIO)) {
>> +			pr_warn("dax_recovery_write failed\n");
>> +			ret = -EIO;
>> +			break;
> 
> And no, we can't just use an unsigned variable to communicate a
> negative error code.

Okay, will have dax_recovery_write return 0 in all error cases.

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

