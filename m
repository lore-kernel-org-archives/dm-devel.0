Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C41C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 22:03:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-u_Ko6UV8M4iDp4KprWU8pA-1; Wed, 02 Feb 2022 17:03:46 -0500
X-MC-Unique: u_Ko6UV8M4iDp4KprWU8pA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DC161923B88;
	Wed,  2 Feb 2022 22:03:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D82D910429D2;
	Wed,  2 Feb 2022 22:03:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4C2364BB7C;
	Wed,  2 Feb 2022 22:03:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212M3crg020977 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 17:03:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 51BC8141DEE1; Wed,  2 Feb 2022 22:03:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CA07141DED7
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 22:03:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F9C78027FC
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 22:03:38 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-652-mpqJAjsbN--BU28qkNyv-Q-1; Wed, 02 Feb 2022 17:03:33 -0500
X-MC-Unique: mpqJAjsbN--BU28qkNyv-Q-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	212Kwl3x009905; Wed, 2 Feb 2022 22:03:16 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dxjac7d54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 22:03:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212M1SWv098035;
	Wed, 2 Feb 2022 22:03:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by userp3030.oracle.com with ESMTP id 3dvtq3me2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 22:03:15 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11;
	Wed, 2 Feb 2022 22:03:12 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 22:03:12 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v5 4/7] dax: add dax_recovery_write to dax_op and dm
	target type
Thread-Index: AQHYFI6LEOTCAew0QE2MfSX8Pkzm9KyASjoAgACN/wA=
Date: Wed, 2 Feb 2022 22:03:12 +0000
Message-ID: <fba7dc7a-ed09-bb1f-4882-da50fc470c20@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-5-jane.chu@oracle.com>
	<YfqIgliJi0GkviXD@infradead.org>
In-Reply-To: <YfqIgliJi0GkviXD@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b73fedee-d94d-45a2-19ae-08d9e697ce81
x-ms-traffictypediagnostic: CO1PR10MB4689:EE_
x-microsoft-antispam-prvs: <CO1PR10MB46899ECBC3CF704FE499F37DF3279@CO1PR10MB4689.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: yenOaRAcMzpmCBHushK7uk3nNhPnE44fd6PxSmCy4dwiC1HG4P8ErsnxPMNuUkDHi4Fx9Frt4RR9gg0wj9g6soLb4Tm23Uj53O81ODkqLUgG1KHwfnCPurVqE0jQEIIKVv5JWyTdmSD5jK9lXSboX5hUZWCfgUTlivfV22XpXIDTi9L/qzR9BUg6VDYgn0MbrdollYEbeuWG/AkSSiH3QSzHybas6hKwg0SZElDkbdHpbpM/Fq2u+THcrlcARO4LHS8QZ1WWWL7A9PdxD6K+WuRj2Z3mYm1MiLIbo0f7TFVc3p3m1IpEmjWJ39jgaTatKyBvUTytWgPfOyH0fUqe83jOdNGKsZmHrRvdeiPOJioVRECGWabJGpAkScjnfqF8MYArGMq0bFxHUbfpGw1+UCm9bEdi95po/HpjxGrmlUVyFwxFhgQh0877O7aeT5VA+LsngHEkIf8S5O7iX2w6Tyo2wv1Dpo3kgn42rIiXvvt678H1ppYjVf9vaZ0b8ixlsDM8jVO44lFMGAbwLhCMShHQvYimVFLs1mo2zFvDPfLcyMAdJefnPa2VKTIbBWTIyN0abfdl+8gdkttJiqKCCBPMpIGW4BJ4EC8RoIBkRpJrDRcl8BXqBpWXmUNBPNwv8EhHjMP7Bav59+o3+b+LPMCOSLhJKDLUC7bIB7+fQCwrVPft/otJ83rp6FWTgMQ26/YBd1eO3D+Ykv1hYPfEH8WG7EzxJRf0lmHdru+vAnD/vXaxXg/aJMaL7WM0q3Kz1Cn6OZJ/xrAZEl+4PAlh2g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(5660300002)(2616005)(31686004)(54906003)(44832011)(122000001)(186003)(316002)(31696002)(7416002)(26005)(508600001)(6916009)(86362001)(36756003)(8676002)(66476007)(38100700002)(91956017)(4326008)(76116006)(38070700005)(66946007)(66556008)(6512007)(6506007)(64756008)(66446008)(53546011)(71200400001)(6486002)(2906002)(8936002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ty8xY0Z3U09hRFFvS0krSWNrby8rWFIzd3pubkhtdDdZdFNvWU9FRjhhdzhj?=
	=?utf-8?B?dXB6OVNZWGtwTXd4UnFaUDJ1dnBnSTRCY09QWWRlbGRiaFovVUNob0w4ZVhJ?=
	=?utf-8?B?eFBJNU8rbW9xNFBSVGlsSmRRQ2JZZlBvTUNSZ05WYW1SdUFQZGk5NGhjUmRX?=
	=?utf-8?B?ZFRLRGg1K2tPazNvK2JEcGNZbkIyRW41aXd1TzNHeVExS1pYaDJxQVYyZkxO?=
	=?utf-8?B?MFRQMnNCY2EwbytvVUhVcTc1cmZ6dSs2RDJ3SVB4SkE0NmRxYy9DOTVrRktK?=
	=?utf-8?B?aUxPd21FNkRLOGFOOFlTdGVMN3NqdkxkUzZVK0VGd1RSZVpMTHVFS2tYMTZm?=
	=?utf-8?B?M0EzM0dmS05FNHN3alNEOVlnNU40ekh1RU9ETGJuQjhuNXVZQ2ovVnJ6Nldw?=
	=?utf-8?B?Q3VjVHpWZk12Q2lvalB5KytDdEp2bTRGNVhtVkM5VDQ3VDRvSEx1aDBJQkFt?=
	=?utf-8?B?TzdvQU52bHphdHJrSXFabGZ5ZmZLNzNDLzQrbUpOSkN6WDFkWDJqejVRWFNp?=
	=?utf-8?B?ajZtcHFkYm1seENob0E3ZkorOUxoMzJXZXNyNW1VZGs2ZkU1M3NBNGdQQXZ0?=
	=?utf-8?B?bWUyZ05oYllTWW5qc2xBWlRQdnUwZ1hzMkg2NEQvOHcxL2F2dXA2WmlFV0FK?=
	=?utf-8?B?QXRpelZaWXMwdGIrcmYva1lpb0pNSmFpdDRvTmNidWJTRzFURjNQcXlLZE5m?=
	=?utf-8?B?VkpZS3pwT2RMd1VNZHVaRHNKRlNmY0xaTDVTdnFkSnRlUVBFTWg5Q0o0UUhl?=
	=?utf-8?B?NlZpWHBhd1NkTUNCcVhNeGx6cGRLejN4V2NKaCtxWWFLdk1ISjEyb2s4SWo2?=
	=?utf-8?B?czZvRktxNWppMURuajNidi9obWVnQlNkZnVYQ0pyYkNIdTgvMmdVUWZOSnRW?=
	=?utf-8?B?UzdXai9Hb0tUUUtYR1ZXKys0Y05wakN6ekk5eDNEaXhDR2IwZkxWeXQya1BM?=
	=?utf-8?B?NE1KTXlCNjh0Y0hFSHhsUlU4cTRMd2Z4dGVoOHBVNEFHQ3pPRkI4SFpyTlRQ?=
	=?utf-8?B?UXBFancydEhZZFpVUDl4a0RDcTBFZERPR25oOWNyOEZpL2tydlArRUtIUTZZ?=
	=?utf-8?B?T284cWFuSmVZbWZYWkwrc0pGQ2E5QlhUVFJWTlEwNFhma1VWMWN3VDhrckp3?=
	=?utf-8?B?ZEU0ODZYZVVtc0JJQ2dER3JsS1loRTVDeFRHNVNLaG5YVk91Yk9Cemw5cDRI?=
	=?utf-8?B?TXBvbFlPQ213SDRFQWlNTzk1U25lRXhxUlFwZXRYUzZkckRmOExaWWxWSDNl?=
	=?utf-8?B?bXp2WFFhMkhVWWI3MHFkWGh2ZXRDc1NvNGZGNlBCWXNiSGJ2enQwdHp2UEh3?=
	=?utf-8?B?MlNXNk1jOWR2R1NMajc4UXkrUW1QZnhIRmJFRWI1bUxRV3g5dTJHTnRTYksy?=
	=?utf-8?B?UUNjVlZDQWYzVGZIZkx5Rjg5QndIWjkzUHFaNVBYRmtHUkFadFNham9leGVW?=
	=?utf-8?B?RGRjajZaVTZIYWh2MVVhYlVUOEgwNUxKaUFyQks1Q0dOZHN5NEdkdEVpeXdB?=
	=?utf-8?B?Q1pPLy9zbXlmb0VNSDl0dEdrUGFxcEowazlaWXdRcDh2RVhuSm8xNy9IaE5K?=
	=?utf-8?B?QVU2YW1Dc0ZqOTQxVkdhZGVVMytEVEJmVU9XQUJlcXRvU3JPQzY0UVJQRjBu?=
	=?utf-8?B?MjU4aUoyTlBYWmo1T2t4UGVPQThrU3FHVm0xWDhUWXVEbTdvUURPd3crYjRY?=
	=?utf-8?B?SkxnL0hQWGY4UmlqY050TDYwSnRNODM1bkdPV2J6V3luamNDazh3Wm50WDdV?=
	=?utf-8?B?NFRoZnRlNHdKT0ptbnBBK2dvZExqZ09LU1Ztd3Mvcmd5N1k0c3BQVm1lZitv?=
	=?utf-8?B?Tk0yUjcrNTdINElrNG1pTUM0OUd6MTlreW04Vmt4OUFIRXNQeFVOdWJJc0hI?=
	=?utf-8?B?ZlYrNHBTU3AvdWVjVVlORVFzN0N4d2NMUlNiNEFFQllzSXgyamZsNDFwZE5x?=
	=?utf-8?B?OVlwdklzSGdIckEzRTlSNjlnOGRUR1ZNQW1NSmNtRWFybzdJcnB3TDRqSzhV?=
	=?utf-8?B?VWt4ajVST0tMNVdEeTI0VkJGNHl0eGN3dSs0dUVOeHhjanhsSFkvZ2FVeTBH?=
	=?utf-8?B?RUFUc2R5QlMveW10L1UzNU50anVPYWRSK3pGa0ZvRE5kQnZlQ3pLRE1yZ0Z6?=
	=?utf-8?B?VXRlTHUxWVN5UmlORjd1TzJPMDBxejJWNG04dHJkVURhQ1ZyZ0FlaElPcEt5?=
	=?utf-8?B?UkE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b73fedee-d94d-45a2-19ae-08d9e697ce81
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 22:03:12.5060 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gdlkKRaFjAN5xOsUchOcq5ReoCQ/aLURaiA3eXJI931B7aPSmtGxr8KchrFf2wRyv4LkNLldEUSI6NOF4BiYaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxlogscore=999
	adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202020119
X-Proofpoint-GUID: ZzgP2TL42LjwBsjlcCysPsqzmLlsPg7H
X-Proofpoint-ORIG-GUID: ZzgP2TL42LjwBsjlcCysPsqzmLlsPg7H
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212M3crg020977
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
Subject: Re: [dm-devel] [PATCH v5 4/7] dax: add dax_recovery_write to dax_op
 and dm target type
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6BF30A4EEDAA2548BE48ED01A4208027@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/2/2022 5:34 AM, Christoph Hellwig wrote:
> On Fri, Jan 28, 2022 at 02:31:47PM -0700, Jane Chu wrote:
>> dax_recovery_write() dax op is only required for DAX device that
>> export DAXDEV_RECOVERY indicating its capability to recover from
>> poisons.
>>
>> DM may be nested, if part of the base dax devices forming a DM
>> device support dax recovery, the DM device is marked with such
>> capability.
> 
> I'd fold this into the previous 2 patches as the flag and method
> are clearly very tightly coupled.

Make sense, will do.

> 
>> +static size_t linear_dax_recovery_write(struct dm_target *ti, pgoff_t pgoff,
>> +	void *addr, size_t bytes, struct iov_iter *i)
> 
> Function line continuations use two tab indentations or alignment after
> the opening brace.

Okay.

> 
>> +{
>> +	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>> +
>> +	if (!dax_recovery_capable(dax_dev))
>> +		return (size_t) -EOPNOTSUPP;
> 
> Returning a negativ errno through an unsigned argument looks dangerous.

Sorry, should be (ssize_t) there.

> 
>> +	/* recovery_write: optional operation. */
> 
> And explanation of what the method is use for might be more useful than
> mentioning that is is optional.

Will add substance to comments.

> 
>> +	size_t (*recovery_write)(struct dax_device *, pgoff_t, void *, size_t,
>> +				struct iov_iter *);
> 
> Spelling out the arguments tends to help readability, but then again
> none of the existing methods does it.

Thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

