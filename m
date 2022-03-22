Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC60C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 22:19:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-kif2KhG-O5qEJ53NOVyXzg-1; Tue, 22 Mar 2022 18:19:51 -0400
X-MC-Unique: kif2KhG-O5qEJ53NOVyXzg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A4AA3804502;
	Tue, 22 Mar 2022 22:19:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1D7540317E;
	Tue, 22 Mar 2022 22:19:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B8141940340;
	Tue, 22 Mar 2022 22:19:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B396A1949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 22:19:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5DC221121333; Tue, 22 Mar 2022 22:19:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 583E31121331
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 22:19:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94710811E7A
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 22:19:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-zbVIdHTDOg6h2D6P97Y4sw-1; Tue, 22 Mar 2022 18:19:36 -0400
X-MC-Unique: zbVIdHTDOg6h2D6P97Y4sw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MKxaMD012125; 
 Tue, 22 Mar 2022 22:19:26 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may
 be forged)) by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0qxj4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 22:19:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
 by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22MMCDxH068420;
 Tue, 22 Mar 2022 22:19:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
 by userp3030.oracle.com with ESMTP id 3ew49r84pe-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 22:19:25 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM6PR10MB2970.namprd10.prod.outlook.com (2603:10b6:5:64::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Tue, 22 Mar
 2022 22:19:23 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%7]) with mapi id 15.20.5102.016; Tue, 22 Mar 2022
 22:19:23 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v6 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Thread-Index: AQHYO1ql070j1sj5n0uvCqd0wwFVgKzLGuoAgADkIwA=
Date: Tue, 22 Mar 2022 22:19:23 +0000
Message-ID: <24879c61-2ca9-491d-d308-ece8e697db30@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-3-jane.chu@oracle.com>
 <YjmMCjDuakvTzRRc@infradead.org>
In-Reply-To: <YjmMCjDuakvTzRRc@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0ac9513-06ea-4879-c1bf-08da0c5204ad
x-ms-traffictypediagnostic: DM6PR10MB2970:EE_
x-microsoft-antispam-prvs: <DM6PR10MB297022902A26862389CB3E09F3179@DM6PR10MB2970.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jJpLJwrusjXJVUCffw9AhBFLfOzhBtZS3mBVJMkyr8dipav5tuEHqLo8vMdnwUWQfQ/QnrbJ+dlKWR46krZyedCRtY9JV/G8q4CB1ewyTleceztSplJ4InwFHT2RLF5kbTmzVP2RF5Cw9ro1MyxhHWcq01yssIA4NDUnikdMVEJo+bDzj9VXpqvCQTfGAQPSPXFexZTFHXHdzlCUbaa6l3X1Z1jPCFmr0QsuDKhfhbtzKC0KfRzCQ3upNNXHACj/KQZ2sIYT5tyCG3YRoRgMsDbs32NPGSqPLqV6Txu+kGFbtFT3tte3mAFkowRqRjsilN6qZcXyUaQuMez8McphUvvjyli9Vexn3urXvRClCTVV2m71rzsI5CTjTiUEYOnRsy33KP5Q1ez21sFse6Ne6AIjefku8ZGpinrcx7rE4ziMqvnvezFmJbKr3KDAvJ/J6NBTbOFdHHBGpYRN4FsvL1xFLmvnAEqHQr4/wlMvEMW/TebDDOCqBq0bQQ33deoeHxAPMJrXQxUn/nT6tT1vtOKAgYzGy5ylKADF/UsagxvHe+6WbY6s77I3PrJG/thpaiwCf4I2IGnzwFVGuD22ORyVVPf/e5SqWD7lLKo0CP0f+gRu09nOHxrzMSi+hk+DFhIgxN6sWXsImJHWAEPwO5iYG/3VshQh+YtN2fOUWoJEPCMYAXoVpNn/PaX27ypteEncNkSeV5PwH8dZ9AvZdErklCu6sAhjs+nOPgunDx4OVltYFsgGjmhyGQKK6hgU7dD713FmP6d9m/+xAoSrQg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(71200400001)(6512007)(44832011)(83380400001)(66446008)(64756008)(66946007)(8676002)(66556008)(66476007)(4326008)(76116006)(53546011)(122000001)(6486002)(6506007)(508600001)(2906002)(316002)(31686004)(2616005)(38070700005)(186003)(26005)(8936002)(54906003)(6916009)(5660300002)(38100700002)(4744005)(31696002)(36756003)(86362001)(7416002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3dnYUxvbjJvUVdSb2dEZUxSVFBRSjg0cjFKcTVYUXNlNThXUGZxSWpiNWpl?=
 =?utf-8?B?Vlp1ellzQTl1V2JxNUh5YzlpM0NhbVNmbzZsVFlNK3JnSG5wa1QvLzFQa09K?=
 =?utf-8?B?dzZEb2FUTklmdkYvOGlBczBuQXZybmVjRW5tOUhUeGc1cXpmNGN4dkRZcmJN?=
 =?utf-8?B?SzhoV0c2amovcThoSXYvZTBwTUJvd2ZxN0N6bUdVZkZTWUhVMVlVSEZzQXNP?=
 =?utf-8?B?M3ZsQUtZaEs0Qzd6dmVDUlQySllnK1NaNHlzK1picmdvL2hMdVhoZTJ1SytP?=
 =?utf-8?B?QU9iOTVuUi8zNmowU2NJRHZMT25tcm9jYnBlVDlieFRleGt3MVNVcXdQMTND?=
 =?utf-8?B?QkRLMVkzUlpIZjVwcTYrb0M1N1VXSWsxM2I1K3lsM3phT2VBVlE4ZUVkRkpJ?=
 =?utf-8?B?OWZqSHMza2t1ejV4YTRqTHk5Q0dOUmZrSG1OWnRjNjFHZUxUbkdRU1BwVXda?=
 =?utf-8?B?N0xVRVpqUW02a3JCMzhDUmZNS2MwbEU4a3B4dDBmVjlObThmRjJJaUdIWS9j?=
 =?utf-8?B?YXNoZUdwN1NHcnpySUVsRjF3WW5aY1dqS2hFR1hDd0RQd0dEWjhmWGJJK2pF?=
 =?utf-8?B?YXVCaHIybEFNc1BDamFxdklWUkFNb01rbXVraDNRSWFEeHNaQ09NVm5FNUs5?=
 =?utf-8?B?VEFBckp3OXQ1SWY0bE8vMDBWdDAwQWdtbDBXMmN2SkxWVWdNOFVnaVhJckxu?=
 =?utf-8?B?dlp0YUlIdC94SUdrMlBjVXVaTy9FWXFBcU93OFI4KzVFNW9ESXVxYVdXeFRJ?=
 =?utf-8?B?RC90aUZjM3owc3k0MCtoNkFPK3kvMzYrQ0ZQbnZpRmhkajZiVTIyYWdsL0pU?=
 =?utf-8?B?dWlsT1U1b3RMTWtuNERMcWJsMTBmVTQ5eldXc2lNYkNLZXFXd2I1VkFPdlI5?=
 =?utf-8?B?UmR4VUJjMnFjMG9qc3JTS1dIeDlNclJ0ZmdsQUowL0pxY3lZMlZqRmVOenNm?=
 =?utf-8?B?OXZySGcwMTE1akRIUlcwdm9uSjNIQU9TMzE2aVk5RVFLNm1vZzRGdE9DMXVm?=
 =?utf-8?B?TEg3R0ExRDcrOUpLQU5oZlVUU2xYNUJxNXF1eElkZ0dmRzBrNDNlbzAxUWpr?=
 =?utf-8?B?ZHd2emJQWmtaVGsrRVV3QjBYUW1mYnJEM0tUdUlOV3hMWFR1SFV3MVdqWS9m?=
 =?utf-8?B?UVJqek1qOFo3SXZMNVJuUnFvUGJ4WlBLNThjSFNyVkVidU1uQU92dGV3dEZj?=
 =?utf-8?B?Z1BlYUJpQVJQZUh2Z1g2NGZGOWVLMWwvUUlBeTczS2ZvQkhNTVdoaE9rWlRs?=
 =?utf-8?B?SlByeWhsTDJXWWxWVGc3NHhESHZkUmpZT1JyRVFxam1oZmk5Wk9abVZiWHVN?=
 =?utf-8?B?cWRUSWwxaXVxVkNwdm94UndoMkQ5c0h4UkZ2YWh0cEtldVZmeEUveFZhUDlo?=
 =?utf-8?B?dmlwMFdVem1YdUZPREluTWgwRXEyYXNDc0I0RDYwYVZsQjhKaWFVSjI5N0xS?=
 =?utf-8?B?RXhrQU4vc3c5RGNBUVNHdWJxNlVlZk5MeUxoREhHalhOZDRlZ2k4UEJVL1Ex?=
 =?utf-8?B?WEg5ZGZSKzRra0dVd2JFYnZheTNVajlYbTRNM0tadk1heHNmRFF3S3lhS0Fw?=
 =?utf-8?B?akJDMkYwU0FzQW93dE43KzcwUDlCaTNvaCtZdkZURTg5YXdBci9RK0xjRTBL?=
 =?utf-8?B?VGpDanJsbnpGdnpxblNLZU1aclF0ZkJZWGlrckdGemxCQUFkTlhqNWFDYU00?=
 =?utf-8?B?SDlhSi8vNlkwUkNQcXh5ODNoZ2Q1WHE1NVdwNnFreFZESGpjQjNnbnRmNndY?=
 =?utf-8?B?NnpKSWxSRzg0UGZ1TDU3a0xoRXA5V0tFVDJOV0gyR3UxRzk1cHRNMzNTcDYy?=
 =?utf-8?B?aXJDcVlFT05EOEEyeTVmM2dXL2FVWkwzbHhoaG5veGNXbk9OMjFCNW1ycGFX?=
 =?utf-8?B?MVRXM0JySytuSDB0eStaK2Q2WXBSNmdPaEMrcHdWQjJ2bkI2RHBRemtDZ2lI?=
 =?utf-8?Q?1NGTxqslPKRE4z8D12qYwdcjCxjrLdMT?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ac9513-06ea-4879-c1bf-08da0c5204ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 22:19:23.0913 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fk1Kx61/u3Mf/RpByLp8zojoJiDx2nYCb24z50mrbAs7rp8JlqAeqTJOEjfJwqBJfFVPLQJeaztP2yxu6w9/Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2970
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10294
 signatures=694350
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=851 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220112
X-Proofpoint-GUID: b9i48SWmYCjRP21DO05xMn5nHZr3rWod
X-Proofpoint-ORIG-GUID: b9i48SWmYCjRP21DO05xMn5nHZr3rWod
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v6 2/6] x86/mce: relocate
 set{clear}_mce_nospec() functions
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <43B9F707AFBDBC4D99FE4370CD727EA7@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/22/2022 1:42 AM, Christoph Hellwig wrote:
>> +EXPORT_SYMBOL(set_mce_nospec);
> 
> No need for this export at all.

Indeed, my bad, will remove it.

> 
>> +
>> +/* Restore full speculative operation to the pfn. */
>> +int clear_mce_nospec(unsigned long pfn)
>> +{
>> +	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
>> +}
>> +EXPORT_SYMBOL(clear_mce_nospec);
> 
> And this should be EXPORT_SYMBOL_GPL.

Yes.

Thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

