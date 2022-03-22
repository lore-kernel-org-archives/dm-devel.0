Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF1A9C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 22:45:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-wHqDB_RgM9yd34ZGYeMNsg-1; Tue, 22 Mar 2022 18:45:26 -0400
X-MC-Unique: wHqDB_RgM9yd34ZGYeMNsg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DCDA802E5B;
	Tue, 22 Mar 2022 22:45:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E6D5C080A8;
	Tue, 22 Mar 2022 22:45:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C35781940340;
	Tue, 22 Mar 2022 22:45:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B35B41949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 22:45:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 91A1740CF919; Tue, 22 Mar 2022 22:45:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AB4140CF917
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 22:45:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B81E1C07825
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 22:45:21 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-DUJ9cqa8Ma6EsAroCuZZsA-1; Tue, 22 Mar 2022 18:45:17 -0400
X-MC-Unique: DUJ9cqa8Ma6EsAroCuZZsA-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MKxfah009756; 
 Tue, 22 Mar 2022 22:45:06 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt81g6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 22:45:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
 by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22MMRF57124098;
 Tue, 22 Mar 2022 22:45:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
 by userp3020.oracle.com with ESMTP id 3exawhw64a-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 22:45:04 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM6PR10MB3962.namprd10.prod.outlook.com (2603:10b6:5:1fb::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 22:45:01 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%7]) with mapi id 15.20.5102.016; Tue, 22 Mar 2022
 22:45:01 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v6 3/6] mce: fix set_mce_nospec to always unmap the whole
 page
Thread-Index: AQHYO1qo97Ua/3iJEUWuhawaHD7cIazLG0oAgADq7oA=
Date: Tue, 22 Mar 2022 22:45:01 +0000
Message-ID: <fb1ca254-3e7d-0931-2bfa-8f7f27b7d4fd@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-4-jane.chu@oracle.com>
 <YjmMWvDRUHE08T+a@infradead.org>
In-Reply-To: <YjmMWvDRUHE08T+a@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87a385aa-e96a-4b26-5021-08da0c5599d1
x-ms-traffictypediagnostic: DM6PR10MB3962:EE_
x-microsoft-antispam-prvs: <DM6PR10MB39625EFA02DE512E3B6F170FF3179@DM6PR10MB3962.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ETSYTVFdjesuLr8GHCuPkIqMwftlVN8zHgQtFRUYdhsZtWkkQPM2Tl2J+ZY+HH2V2QTJJ3TBKxssDQ1ge+K8YMd/rrpq7/SG0ecRL47NHfk7M0Xlh78KaqKauQWAPBoErIiMXI5fyxzHaBQzL1yUTshKs80pZL7UDmC+2NugYp9B67TMzSIx8k2/9PCMJimzw/z04Noyk1TEVXlT5hNxE5b/Rq2JA9mkbi649CIeOBrl44vF2fX55U6j8JcZobBDWQTbfMUkEXc2Hu9TtdVy7zsKn39+SyGLHRyG3faUvSmVWsgnDd/5NbBYzi8GMxGGhzGTVYbtdn12hOkY4RGHmHcO+0s1v4V55mMJWdijtdWj8W5yKf972P5UkEBpUeqe8IU9k/TJFVJ9YRsRin6ukfnzFiMGvrjiJzimwlipbc77thK72dzkZq4d9dnDVv4mZSgaEurIIqw0sQcmAHvKBdHpC3hR6VXn/Cm20h72JGxF7i+cw4paAquYFqrLX5j1tgGs4UW4WS9mSWYzaX4REnZi6qdtGATnO89vS6IBHyWQn7s2yRgM9EjsvBHsKYOY8nqdEoOj/lCyqAqt6EhuSduvivNVve+D4zk1AwiJJSgB1NBMMUHnnEkZo+ys02Ru18j5KRT0fHOGAwJv4bftL7vG5lxolBWCWGfwZHVz5mfQ7qYUaGBb9hPWSlJPTUFGquk58s7y1zqlo+wxjakZJZR/UZJjTNLmqwlwOEFjs5fKFijlJV/cXu8SG0BFe6cp6FueRpxQmKwdVFdlJEpegGRdeWsFzdSLuRfBI5G1XNF9+i40K4+Y+sir+bxVEO0FJA8MCIRBRO7MfMLG98MLDDUiY1dCHdA+22CGEKQDx08=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(54906003)(6916009)(38070700005)(2616005)(316002)(66946007)(26005)(186003)(76116006)(8676002)(66556008)(86362001)(66446008)(64756008)(31696002)(4326008)(66476007)(71200400001)(2906002)(508600001)(5660300002)(966005)(6486002)(6512007)(122000001)(53546011)(6506007)(8936002)(7416002)(4744005)(31686004)(36756003)(44832011)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3F5OXB5VEhRV1d4Z2NhNVJBMUN0K2twcms0Z2ViVEp6RU1QMGh1MlRsMW1v?=
 =?utf-8?B?K3VVZTNNRXR3NjVsa2lyVWlWY2lBQ1htSXI3bURSRE5QWUNjdGR4dGR2MWtE?=
 =?utf-8?B?eS9vODIyWXh2UndEZ2FuN3VGd1F0Q0FsRHdoU2J6TjFnaDZKcHViUENNcXVp?=
 =?utf-8?B?SWhIaTdzSEpxYnIreDhmbk9SV2x5Y1lwT0Y3b09xbktoMHlJZ0xDZy96N1d1?=
 =?utf-8?B?L0ZESk53b0NaZmlNYk14QlQrUVg0QTlIdWhnclJid09qY1hQWWVPQzVCOXZi?=
 =?utf-8?B?eklsdG1tYVdWeXVkYzRvZzljUXN5RzJpeWlXT25TcDJDZDdqYUxCOW8rTndJ?=
 =?utf-8?B?VFk2RVRIOEozRzBhUllTRGJqNUhxRW9CTVZPK2I3U0NNNVVrbENUblZ1VE1j?=
 =?utf-8?B?eFRUdWlhSkRwQWhpU2Jucmw0WWZJQkxFd2RkTjU0WUVnQTdFOEtZK0FwbDhk?=
 =?utf-8?B?RHJnQXNHalcwWi9jZ2habnhldjUzODEzdE0zeDFneUpDTTh6NEJhMHVGV2lN?=
 =?utf-8?B?WGh3YkxGeWVOVy9ML3ZmVnJ3akZNQ0JManJPWDN2ejBkS3BXMzMrY3FaY0xP?=
 =?utf-8?B?NHQyRGZ2RHh5NkIxaGI0UmpzUmJNT2h1UzZzbHViQ1RwMTl6bjBnRFM5MFBw?=
 =?utf-8?B?Q205NHY2Z01KMGhaNlhQV2VUVFE2Nmp6Nk9nUk1ScThPM1RMZWJGOEtva3ll?=
 =?utf-8?B?WHovcGVGNkYvdTZTei9OM2UvQjQzN29UQnVRU2l3czVzbUIyUnV6N0tsa3Vp?=
 =?utf-8?B?UE5iZkhzWWFsRHJtQ01iZ3BvNlp5Y2JGNGJTSE5heEJJZjJ4MkxEVFFrdlBX?=
 =?utf-8?B?Z0dUYTNsV3ZNUXpHTldyeXNaNUhWTGEvVGJnQ0lQTTlwZDZWS3I2OVUyMU1C?=
 =?utf-8?B?eDdFaFhTTG10bkxSVkNESkxJVm9nSWJBN0VYNkxtNDRSUENkOWZtWGlHU2lo?=
 =?utf-8?B?MjNqKzgyWUZTcTBJalQrblIwYVQzWVFxUHdIclNMb2RKbW9tRlkwcjVwdlNp?=
 =?utf-8?B?MXhsaUE5SDlmYVZIUnRUUTdzTktNYzFKL0Q5dENScDVvRGpOQWxnYk43elFp?=
 =?utf-8?B?czFnalM4bCtGaUNmUFVkbW80SW8wZ0xJR09WSXM5UDZ1REhGM1Y0a1RScGhU?=
 =?utf-8?B?MUxmeWc4UVhyNWFrS1NXRVkwbktjZ0xMOUR6Nnl0M3JkcFpxMWFVN0dXL1lS?=
 =?utf-8?B?U1hJbmgvTlhCUU80SmdEL1VOVWV4ZVRxTjBEUmNqUXRvd0F5dlpUNkVyS3FG?=
 =?utf-8?B?T3F4TVBoT25USUJLbTR4S1NIUFR1dzVrRnU5QUxIWGVEUFQ3MmlDcjRSdFhp?=
 =?utf-8?B?Y1BFYkpodGFadjlPaHJWQUs1ZDdONk1ZSmQyVmRQT09DR0RNK3p5RFNYUVNp?=
 =?utf-8?B?UEdwa2lkM0QwOVhOTTV5azBjRzZzdzZkOFgzcEFaYWZwdDVMQTFoSm9QZkZw?=
 =?utf-8?B?UndreGFPUm5xakhtSEdQQ25JK0duL1VFMWQ0U2FnV2krL0ZnY2tGd08yVjc1?=
 =?utf-8?B?RGhtWWJrMzNUb0hNL3Aremc1NUhJems2RUJVbWRyMEZTRFlJdGV6bkdjQXBZ?=
 =?utf-8?B?VE9tOFl6ajgvODQ1UXlqdmNWNXN0WDV1N1BYSm8vRlNKSVFDcnpqbXRWNFVy?=
 =?utf-8?B?K3lOMmxVU3U5U0RWeGNQZG9qZEJPTzVHaDRzQlB1NFl6R2pzNVZVelBJOSs4?=
 =?utf-8?B?Ujl5c0g0aVRhblgzL0E3QXY5M005UjZUQjd1L3NQWTFtdGQ4WDRITDBZYlNF?=
 =?utf-8?B?SjRsUHBEeEgvdGtBOFlDMHhkdE1XT0NnajlrN25zbDlrb2lQWkJmaWowQlVV?=
 =?utf-8?B?RHgyUENUTlc1TTJ4NVN2eUlzU3RUY3EvMFhrdkVRM1Izb1lWSnJFMjJCZENY?=
 =?utf-8?B?UzdCdGFVb0ZoOTUvcGYyU1RET1MxOXVlbk1BMDJKQXdKR1FZS3pCdDhWNVpW?=
 =?utf-8?Q?cQw2pxNG5WXY3+uDJTxugr753LP8qjUP?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a385aa-e96a-4b26-5021-08da0c5599d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 22:45:01.7950 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfYfq+vqtxoP83FsFQtmHslbIiVfyv+YCtoJWJ1wE9rRAv6lPt2jskstaIPRyVP5JC2QtBmMqnrlpTPj8E/Kyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3962
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10294
 signatures=694350
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0
 mlxlogscore=973 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220113
X-Proofpoint-GUID: jghG1jYHWYVY4M8JLUBdUXEtirWA9OUL
X-Proofpoint-ORIG-GUID: jghG1jYHWYVY4M8JLUBdUXEtirWA9OUL
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v6 3/6] mce: fix set_mce_nospec to always
 unmap the whole page
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <7994CE8F9771B646B18C620474D3926F@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/22/2022 1:44 AM, Christoph Hellwig wrote:
> On Sat, Mar 19, 2022 at 12:28:30AM -0600, Jane Chu wrote:
>> Mark poisoned page as not present, and to reverse the 'np' effect,
>> restate the _PAGE_PRESENT bit. Please refer to discussions here for
>> reason behind the decision.
>> https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
> 
> I think it would be good to summarize the conclusion here instead of
> just linking to it.

Sure, will do.

> 
>> +static int _set_memory_present(unsigned long addr, int numpages)
>> +{
>> +	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
>> +}
> 
> What is the point of this trivial helper with a single caller?
> 

Okay, will remove the helper.

thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

