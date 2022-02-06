Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28458C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  6 Feb 2022 08:27:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-B_-eS29TP06ysyYVjRPd_A-1; Sun, 06 Feb 2022 03:27:50 -0500
X-MC-Unique: B_-eS29TP06ysyYVjRPd_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7E241006AA4;
	Sun,  6 Feb 2022 08:27:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B85AC7A238;
	Sun,  6 Feb 2022 08:27:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 82C1A4BB7C;
	Sun,  6 Feb 2022 08:27:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2168RhoV020277 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Feb 2022 03:27:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 844FF2166B47; Sun,  6 Feb 2022 08:27:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EB4C2166B26
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:27:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98B721C04B42
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:27:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-8-_nuqhkTJO8irNJ2eFpyrsQ-1; Sun, 06 Feb 2022 03:27:35 -0500
X-MC-Unique: _nuqhkTJO8irNJ2eFpyrsQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	2166FAw4011738; Sun, 6 Feb 2022 08:27:27 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e1hsu2r71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:27:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2168BeEL147451;
	Sun, 6 Feb 2022 08:27:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by userp3030.oracle.com with ESMTP id 3e1ebv4gjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:27:25 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SN6PR10MB3023.namprd10.prod.outlook.com (2603:10b6:805:d2::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18;
	Sun, 6 Feb 2022 08:27:23 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4951.018;
	Sun, 6 Feb 2022 08:27:23 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v5 3/7] dm: make dm aware of target's DAXDEV_RECOVERY
	capability
Thread-Index: AQHYFI6KS6i0Tra94UqRHjnxZwdTsayC6KCAgANU/YA=
Date: Sun, 6 Feb 2022 08:27:23 +0000
Message-ID: <1ae40b1b-9d07-a69c-aed8-e6a6b63b1cc6@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-4-jane.chu@oracle.com>
	<CAPcyv4jw+meUy-DrLgqn_4kPCF2WAZrMJ8Nan4xCncr7-4Y0hw@mail.gmail.com>
In-Reply-To: <CAPcyv4jw+meUy-DrLgqn_4kPCF2WAZrMJ8Nan4xCncr7-4Y0hw@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4bd7189-916d-4f78-3c87-08d9e94a8015
x-ms-traffictypediagnostic: SN6PR10MB3023:EE_
x-microsoft-antispam-prvs: <SN6PR10MB30234C76E263AAA5909016ABF32B9@SN6PR10MB3023.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eceUFfhwXR8OaQOrsJCNqrvDjKgZCTVkZcSCXVv/dZbD7sZ6c5fqEKkovIG3sHb2ZQWYdJVNXRhV0/nrG7JhtwsSROcpPpa0P4HCmZmz8iNeXHjkyIIpvmMRxNg2aY/FR15e/DHPFPn2gRg4Z4OCwou01BqOMqMk0QA3ye/vTPBv2XLk4u/Ao7fHCf5pWbv6vARKYZtccnygZD8ukUPC15X0aybIy8uQJGdDsf4JKkTgyH/T1Yared+L9x3wegzvrMbTiLavuMcIELWZhjmzB+MNPWKG+AU9aWNFWqGgznZL+AcFWPTYWKotjyRXsfQeiu7NWU7INlHWJVGJjkSTRt46o1aG2EAwV5hpdLb2Yj361cFB9tduVQMgk0/wvp47JjgzUZuGSrTaYtSKBdO7DF2cUzvYwWsUxK4LzTkSZQoLjp415VmdDMqrs91zv6/HpegUq/CDPyEA3EZy6R6jv5BsYSk/wr/rQ3qpXyrPaC0Z41JhiYXorxUCWz0/FEjz2+BGjGr1THFtbskzSgUmW+9OJpBrON0t3sH3GurLu4nI1AkTrquHqZ4gvH4SgUUya88QWYcLUtiErjennoJ/u7N5cTnueQaNpvty29AdkrJnq11h5+4+fAY0m+BGllHFHFRvykOxmBmiV1Rz1ZNTd4J+r23OXDyOoCS/uMtardzvvPXJiWCGedGUn3g2IHCrWVQEUcnZhDMhxJMJ7qSAZmE4VwULLaR6PmMlVtNuSPNClRNnzFYlGEYJWDOksNpHTjdh+ykzOwA/fwQ/FHVLXQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(71200400001)(86362001)(26005)(2906002)(508600001)(2616005)(54906003)(186003)(316002)(6916009)(38100700002)(5660300002)(38070700005)(122000001)(4326008)(6506007)(8676002)(66476007)(31696002)(64756008)(66446008)(66556008)(76116006)(44832011)(66946007)(8936002)(6512007)(53546011)(7416002)(31686004)(6486002)(36756003)(83380400001)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmJMZWtpK1dSbVIxYmVTZzJ1SG9VcFhKUThtSU1oazhJK1A1WmZZL1R4eHg2?=
	=?utf-8?B?UmU4YlVEQmpHcVljNUw4aWdHRWRNcmlENXZFYkJEbm5GbkFkVjZSY0VVRGQw?=
	=?utf-8?B?czFXYjJ2T2ZmZ203bm1kb2JGSHUrdml4TlMrVkEvOE9iUnNkYU53WDhGT3py?=
	=?utf-8?B?UlFjZ1BuYk9HZnFNa0IzSXptcnppZGw4V2lLWTRCWVo1MEZhMDU4dlMrcTJx?=
	=?utf-8?B?Tmltd2NxRHU2bmlBTGNLZ3RnQTgzbGdGbjlJNVVpMWJpZ2V2YWduTFhaMU0y?=
	=?utf-8?B?Z0NBdkNQNmVzaFVzSDhrT0JRcWdaNFlWNmt1MkNtT2RpUjF2V1BINEMrLzg4?=
	=?utf-8?B?UldhMFVPU3lZM1NDS1ZDZHhSb1UzUkc4bHh4b05pZndRb3hUYnd0WG1vdkJH?=
	=?utf-8?B?bGR0cC90U1BLMVZNdUttTE5xdjFidFgzaENoekJ2MVFoVGJHR3lKRWZDNmp2?=
	=?utf-8?B?UVVvRERIUFJpZHU4Ry9kSkNiY2xhUTFGS2VWZElGaFJRK09uWjk0bmN1NjNx?=
	=?utf-8?B?RFppc2R5VmJNM25KbVVGQnpvVm5JMGZHZk5LTDJYcU91SzBHNDV3VFh6QXg2?=
	=?utf-8?B?clRybmFxZ0VUdWJoUkxPOHFKTXVZZElHTUE1a2FtM1Ivd2U2NjZzcjgrOTM1?=
	=?utf-8?B?aVJmay84NG8yMjVJb1pJRlFXVUovL3lJcXFHLzF0aU4rcHZYR0dqMDBpNUNp?=
	=?utf-8?B?WHJsTG43Y2lBS0Z1bHdaUXBOdmw0OFRmNHZ2QXRhS29qQjBuZ2tVSEk0eXpv?=
	=?utf-8?B?WUptYXkvQVdNblJYeTVtSG5LclNwOVM2bFJkRzc1R1k3ck1VdGVvdVBXNkdD?=
	=?utf-8?B?NUJOa0RQck5za2c2MkdXVUhiUEVFVDBFeXg4RGVpSFdOaHNNQkFsazFpc3Ju?=
	=?utf-8?B?dHBuWE9Zd1NOcmluWGZ1TXEwSXlSZGRkaDV6eUNmNCtRcm5kTFQwZTFqY3pt?=
	=?utf-8?B?REJCQnJ6Nmd4M2pOcC9zZTd0S2ZkclUwK0VJbE9VN254a3RnY1FPd3U0REVY?=
	=?utf-8?B?OEo3dG8vNVZOSGNzYWZTdFJJZGVaQUhGMDlUMXZPa0hPZkphV3I2VXM0VmRV?=
	=?utf-8?B?MWp1VXNCWlYwQVN4SXBkUmZwWm5JN2FnclhVZC9naStISHBGVE9JaHNOdy8y?=
	=?utf-8?B?WC9RODUzSlNzNExZbHpnR09YcjdUOExad0dhMWVyQ0NOSUpvWkxUY1FvNXV0?=
	=?utf-8?B?eHVPS2Fkb3p0Y3lWVzNsUmZJdkdqaFhKYU56aHd0VDNKTnRkOVdrWFVPY1h6?=
	=?utf-8?B?cUVlU0NUd1REaWd1ejA1V0pIbWZjQmQzenVqRkw2M0hVbUptZXJXZDk3aGx3?=
	=?utf-8?B?aFB5VHFiNFdUUENDOXk4b1FVSVE5bWNVQTBsekRjRy9VendLcXVVcDdldUsz?=
	=?utf-8?B?Yjg3Ky9kdDlBQzdIMGNkSHF0aEVGSTFoRmpmV0hhTkpzNndNTUJPTEZkcXBj?=
	=?utf-8?B?Rk83MDYxTmdSMjlWU1hwa2lmbTQvWXpoOHYrd05WemhpNmZ3OWs5S01hQ3RJ?=
	=?utf-8?B?ODExeDdjN1ZBNnAveHBZbDhSMk96VjkrNG9OUEg3NlBBdGVPcGZvVFNFM3F1?=
	=?utf-8?B?NGV1emdjYTVSSXI2Qy9IMWE4MCs1UmJlTGtqRDdJU1BHNDhNWmY3blFzMVV1?=
	=?utf-8?B?UGFUWW9mTGp1bzdOcUttRUdQSmtIWHl6Vmdxa3dBVUlLL2MzdENRaWRmdllK?=
	=?utf-8?B?L2ZCWExmdWNkUTQ4Z0NnRURQa1M3YVM0Vjl4bGZGUnBobmVtZEFScktLaE5x?=
	=?utf-8?B?YnpHZmZkcnhEZlNydW14dGU2T1ZWQjN6aFRYaHNtUVpWSk5aTG1OL1Z2bTZr?=
	=?utf-8?B?b3U0M2g4dzAzQ1EvdmNnbVVPK3R1ZmpZSlI4dncxNmxTbHNYL25yZEQ4L2ty?=
	=?utf-8?B?NkJ0elMva0I2clN2K3cxSkNoeHdlWFFEQmFCaHBHaXZSbjUzL0VwdTBrMXQ2?=
	=?utf-8?B?QWtPbmRkQWpjc2FZWnYxdXkwRXgwWkYza2xDZnRnZENyVzlXMWZFc1huM0JC?=
	=?utf-8?B?Q3hjVzJFTW05MXMzcUp5bU9SeVlKekVHRnZNTVFWQkNzMG9DTmNJQjVjRVRt?=
	=?utf-8?B?eFZFMW42ZjRVODBKWkRLL2dBdTFpeVNjWVU1SGwrK3RKU0piY2k4MU5LR2ts?=
	=?utf-8?B?dGM1MnRKWTkzZEhOS3RLWlZFNUVyb3ZZNEh2bTJGVHV4NmZYeGx1ckJQcGJt?=
	=?utf-8?B?eWc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4bd7189-916d-4f78-3c87-08d9e94a8015
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2022 08:27:23.4426 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tkm8drB1DxuBUPFqvC2KL8ZG+PmoSPC9hWz5J4WXtW61PSxh1v2wFB6AYmFmj3BCoaip6Ktd9o+7TCuJlWVePQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3023
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10249
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 suspectscore=0
	mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202060060
X-Proofpoint-ORIG-GUID: H1ymnY4MspNDnBKYkGJu9UBwAg65Wz_8
X-Proofpoint-GUID: H1ymnY4MspNDnBKYkGJu9UBwAg65Wz_8
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2168RhoV020277
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>, device-mapper,
	Matthew Wilcox <willy@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Alasdair,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
	Ira" <ira.weiny@intel.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/7] dm: make dm aware of target's
 DAXDEV_RECOVERY capability
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
Content-ID: <3AD509C9AFF26F4B84B0D9D1D02F5D57@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/2022 9:34 PM, Dan Williams wrote:
> On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> If one of the MD raid participating target dax device supports
>> DAXDEV_RECOVERY, then it'll be declared on the whole that the
>> MD device is capable of DAXDEV_RECOVERY.
>> And only when the recovery process reaches to the target driver,
>> it becomes deterministic whether a certain dax address range
>> maybe recovered, or not.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   drivers/md/dm-table.c | 33 +++++++++++++++++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index e43096cfe9e2..8af8a81b6172 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -844,6 +844,36 @@ static bool dm_table_supports_dax(struct dm_table *t,
>>          return true;
>>   }
>>
>> +/* Check whether device is capable of dax poison recovery */
>> +static int device_poison_recovery_capable(struct dm_target *ti,
>> +       struct dm_dev *dev, sector_t start, sector_t len, void *data)
>> +{
>> +       if (!dev->dax_dev)
>> +               return false;
>> +       return dax_recovery_capable(dev->dax_dev);
> 
> Hmm it's not clear to me that dax_recovery_capable is necessary. If a
> dax_dev does not support recovery it can simply fail the
> dax_direct_access() call with the DAX_RECOVERY flag set.
> 
> So all DM needs to worry about is passing the new @flags parameter
> through the stack.

Yeah, given your idea about adding the .recovery_write to pgmap_ops, it 
wouldn't be needed.

thanks,
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

