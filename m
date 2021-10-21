Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37BBC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 18:22:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52DB860D42
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 18:22:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 52DB860D42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-kyDMlc3CPcOJDwMk0ExTuA-1; Thu, 21 Oct 2021 14:22:18 -0400
X-MC-Unique: kyDMlc3CPcOJDwMk0ExTuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0102D1006AA2;
	Thu, 21 Oct 2021 18:22:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CB305C1B4;
	Thu, 21 Oct 2021 18:22:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 479F54A703;
	Thu, 21 Oct 2021 18:22:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LIJg6f016872 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 14:19:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CB8062026D46; Thu, 21 Oct 2021 18:19:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF88A2026D65
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 18:19:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1421480015A
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 18:19:37 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-362-kPmQ5fS6MM2wdQaJfCKaKA-1; Thu, 21 Oct 2021 14:19:26 -0400
X-MC-Unique: kPmQ5fS6MM2wdQaJfCKaKA-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LHpEYb021105; Thu, 21 Oct 2021 18:19:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm6pk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 18:19:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LIFf8J195190;
	Thu, 21 Oct 2021 18:19:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by userp3030.oracle.com with ESMTP id 3bqkv2bxau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 18:19:07 +0000
Received: from CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:9c::17)
	by MW4PR10MB5751.namprd10.prod.outlook.com (2603:10b6:303:18f::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15;
	Thu, 21 Oct 2021 18:19:05 +0000
Received: from CO1PR10MB4418.namprd10.prod.outlook.com
	([fe80::f12e:1d7a:66a3:3b1b]) by
	CO1PR10MB4418.namprd10.prod.outlook.com
	([fe80::f12e:1d7a:66a3:3b1b%5]) with mapi id 15.20.4628.018;
	Thu, 21 Oct 2021 18:19:04 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH 2/6] dax: prepare dax_direct_access() API with
	DAXDEV_F_RECOVERY flag
Thread-Index: AQHXxhA7j61ucpXWPEWf3Oh2VcDl4qvdTxiAgAB1CIA=
Date: Thu, 21 Oct 2021 18:19:04 +0000
Message-ID: <92423340-311b-0799-7a23-2a89201700ed@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-3-jane.chu@oracle.com>
	<YXFM64mFLN8dagrY@infradead.org>
In-Reply-To: <YXFM64mFLN8dagrY@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8502a437-5472-4bbe-5e78-08d994bf43f7
x-ms-traffictypediagnostic: MW4PR10MB5751:
x-microsoft-antispam-prvs: <MW4PR10MB5751A45E7422D8009314F55EF3BF9@MW4PR10MB5751.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6sF4xhCMbE5zwf8iTc+/z7cSzO8DiDm7oW9uBXPM5wwX5rCfyNaZLoO1eWcaFkaaBxO2/6lL6mPVYcHCvPnWN5QnFYr1UJozFGfQTcsxMkwiUyTpSCA4RMzest24RHie2n2XWFpkYouc/pwzm2uzdHR2fZ4wrQasHx152zXhXPJdVDum95zPP1/TZ8m1X6dqH5qqHoQ8r1eeN3V7FHsdjLE5Tg/Q/pmZIV1Li70hgcWc4BClqKMrWvuAKaTyq8UV2rR/T1qNR1keOIoknp0xO9Im765Jua/tm2b6gf3h3HMg2PnKGtgqRwdvyy3YjqBY4ZtoWTHWzecwKY9aXg3QMmtW2UpJh5FtgNkTIWyqbY4FpPZvQaR8DyxN4BC5HTsFg+fcxFmCtYNYrJXHtmvVujh0bLISwXTSyArtKtC2bPgYQk5mbD+iUCM1JAXcGkyeKevf/smkWhDs/8XmCjNJHi+0cnQZWxFPVLJRluDrmBRXScDU9UBQS2RwD+4jZnyx/qEiV1OY9tYK2Y5fmwxbk9iFwB2JIkFO+td8g5xHJ5rxJLlokX/X7g06unGgEL44z+PQQLXgdMGCTJaAx/smGa/i6bJhji2Y7705cjWCzpaqwh6si6IPA0KG7iU9Re0k1qw94xtuXg6JifvY+Uf1i1Jb4cLXzqmdFxfnsp+Tdd80gk5ywDTBe9bhdz9namcehdgFFhb8cKrGhMZaWVykLvQDBUvNSx40qgv2D8Q37twnzPo5PjxtcUEbc+yvqrE1
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CO1PR10MB4418.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6916009)(38100700002)(36756003)(122000001)(66446008)(44832011)(8936002)(316002)(66476007)(26005)(86362001)(71200400001)(38070700005)(83380400001)(2616005)(4744005)(54906003)(8676002)(53546011)(64756008)(91956017)(76116006)(4326008)(5660300002)(508600001)(6486002)(31696002)(186003)(6512007)(2906002)(7416002)(66946007)(6506007)(66556008)(31686004)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmU2NVVYK29Qc244YXc4cFNNR1Nxd3RkcE00OHdvL0ltK2ovbDNid3NCYUlW?=
	=?utf-8?B?R2xVQlFMYm50QSt6ck5URXlnK0xndm5KU0xkRWVzK2tUZVk1amMyVEhMT0RK?=
	=?utf-8?B?VlZkQzhqaEM5ejRGblJUTGt1ajd4ZTZ2NlRpSitBNngycVNwaXBnOTdtU0Zx?=
	=?utf-8?B?R1o1cEovL0FtS21qaTh0dmlvWEV5dmlrT2tiZGJuMG1QamN1bTdYQmUvWlBR?=
	=?utf-8?B?bWZTUDQySEUvZ1pwNERTQVdGWmFERy9hVlhlaG1JcWtQSVFZeVFyd1h6Tm5s?=
	=?utf-8?B?N2I2ZGZnNUZXOFFvZnpkNWdVWWRTRzRKTDhBcTExWFh2YnRIOTFZYjN4MkJZ?=
	=?utf-8?B?bisxQS9UQVZEUm5MUk5RSVpqVkxZd2VTajE4TmsxVGVlclJTNkJjT1Q1L0Ja?=
	=?utf-8?B?NGNkcHZwUnVCamkwc3YwTmp5SWdXVjVGd0xXTGNYTTVUQXF5NlVNcjFFc2Y1?=
	=?utf-8?B?RUdQRTZENXZuWUhWNEMyVm02aS9xWnNMaHdma1ozVEZnZUZuN1hlSUVzNk9w?=
	=?utf-8?B?bUtBR04vWmw5eUJ2QzJTdjFDT3dpTnowY3F6aDhENFpsV1ZwUFk2eE5ScEp1?=
	=?utf-8?B?b3Y2SUlQbm9OWmZTZTliUnFHdm4xb0NSSDN4OTJEMXd4RTNZTzg3bUxZYkdH?=
	=?utf-8?B?dXRQVUFlSkhFTVIwQ0QzYlBqVjBldGJ2TldFSXVObTlvSWk5M0svcktuNXQ1?=
	=?utf-8?B?amdXTXMxUlBkOXZNWmNsWlNLY3lLUkJSUHoyWUtkeEJxa3NoQm9qblhka0ZL?=
	=?utf-8?B?aFdObWtsVjR6Z3M0ZU02WnFTdXl1bnU1L3psVGp3KzhRSk5TMzZJVHNyL2Q1?=
	=?utf-8?B?T2JXd2JtR3pWN2Ezd25kS3FSN3hIMFNIUTc0U0c5dkdNVG5PVUppMU4zQ1da?=
	=?utf-8?B?cGZXS0l3elBhMkRTTUpETVVRajU0QXliMjF5NUNvUERQdHd2SlMraU41S1hh?=
	=?utf-8?B?c0R0VEZKTzk5Y1pKZkF1OUVoKzU1VENJdGkzZXExRXFFdGJVTE5wOFQ5MlBw?=
	=?utf-8?B?WHk5TzcvZ0pzdkdKUG4yci9MaElVL00zR2hzRzNqOWxPckp2emJ6SjBZWUY0?=
	=?utf-8?B?NFpZc1lYZitxeXFoQzB6SXd6NnpSbFBXZkxhOE5wRjQ4dVBZR2luY21WamV5?=
	=?utf-8?B?WHRsL1psdFlPZVRqUFBEU3FXY1BZMlJUL1c2aEVRaTh4TW8zN1M4NTllcFNz?=
	=?utf-8?B?dkxCWVo5SDJGaDJ4SzdSRk1lWG5yVzlTMldMM1haTGFyK2wwbk9CcUg1d01p?=
	=?utf-8?B?R2N2MXRUSStwYmNkd2oza1Vqbmw2UGNPZkFOZmlBTWU1MnJhcGxTNXlteVJa?=
	=?utf-8?B?cFBkbjMweGcrcUV6NGVtS2o3cEFnaEZKZjNGdTRUbzFlMEthNGZMcmFoZEt3?=
	=?utf-8?B?N3VkYVhPbXdFckZZWTNiOEFOc1lLY09SR3VMV3pjR3hTeHZ2K2NNNGJuNlNL?=
	=?utf-8?B?bk1FeXhQeXhyNDc2YnIxR2lqb3VpdHRjMmZDRmUvcyt5SGROeUJ6WkxwalN4?=
	=?utf-8?B?V1d4dnJsRlhxbE55V1Y2T2YvTEJhOUU4NFB0blFkOEFZUUkrc0lKVlF5cTl1?=
	=?utf-8?B?Qk5UdmhlWm95SUEyYlhreWpHMlM4WnV0VkF6NlpzanFtbEhhTFdtN2dCbG1p?=
	=?utf-8?B?WThRbVR4eFpSSVlqWnB1M0QxcC9iTGxwZEZ0NXNLc0pWa1Jhbkt0Z3V1ajIz?=
	=?utf-8?B?aXc0SFhLZ2Z2T05kTWdOTEpPWmlLS3JQekJBTHA4QjdBZ2RxTjYrQTlITXhY?=
	=?utf-8?B?ZzNoU1VkVE9VYSs0OHROSTZwd3YybHpXUVJ0YlJEaEwzR2FTVi9oSVBJcUlX?=
	=?utf-8?B?cEQ3ai80SEFZVWF0ZENLS1owU1NHdEtsdklsMXIxRk9hV1pjRkRtalZvNVNl?=
	=?utf-8?B?NTRXZStvL2lhMy9LNnlrSk9CS3E3dzJCSndyZEtsQjBoVWc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4418.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8502a437-5472-4bbe-5e78-08d994bf43f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 18:19:04.8639 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5751
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=0
	malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110210092
X-Proofpoint-GUID: f7J5gCBM4XqEoks4YqtXR0VagJcOVeT4
X-Proofpoint-ORIG-GUID: f7J5gCBM4XqEoks4YqtXR0VagJcOVeT4
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19LIJg6f016872
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
Subject: Re: [dm-devel] [PATCH 2/6] dax: prepare dax_direct_access() API
 with DAXDEV_F_RECOVERY flag
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
Content-ID: <66308170408652458EA23C26F716B0EC@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 4:20 AM, Christoph Hellwig wrote:
> On Wed, Oct 20, 2021 at 06:10:55PM -0600, Jane Chu wrote:
>> @@ -156,8 +156,8 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>>   	}
>>   
>>   	id = dax_read_lock();
>> -	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
>> -	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
>> +	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn, 0);
>> +	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn, 0);
> 
> FYI, I have a series killing this code.  But either way please avoid
> these overly long lines.
> 
>>   long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>> -		void **kaddr, pfn_t *pfn)
>> +		void **kaddr, pfn_t *pfn, unsigned long flags)
> 
> API design: I'd usually expect flags before output paramters.
> 

Thanks for the heads up.
Sure, will break long lines and move 'flags' ahead of output parameters.

thanks,
jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

