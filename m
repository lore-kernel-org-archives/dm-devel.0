Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CEFC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 01:41:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 876B261354
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 01:41:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 876B261354
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-LoqlXB-vOmyQBfGkHpSGwQ-1; Thu, 21 Oct 2021 21:41:43 -0400
X-MC-Unique: LoqlXB-vOmyQBfGkHpSGwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D23A3802B52;
	Fri, 22 Oct 2021 01:41:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B48E860862;
	Fri, 22 Oct 2021 01:41:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D0AD4A703;
	Fri, 22 Oct 2021 01:41:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19M1fbg9023055 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 21:41:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 69C3E4010FE2; Fri, 22 Oct 2021 01:41:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63670400DAFD
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 01:41:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4543918A01A5
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 01:41:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-300-bBlEOnV2NMajdZwsMTFWWw-1; Thu, 21 Oct 2021 21:41:33 -0400
X-MC-Unique: bBlEOnV2NMajdZwsMTFWWw-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LNifU4010955; Fri, 22 Oct 2021 01:41:20 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqyprjfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 01:41:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M1VeS3084304;
	Fri, 22 Oct 2021 01:41:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by userp3030.oracle.com with ESMTP id 3bqkv2wm1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 01:41:18 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2518.namprd10.prod.outlook.com (2603:10b6:a02:b8::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18;
	Fri, 22 Oct 2021 01:41:16 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.018;
	Fri, 22 Oct 2021 01:41:16 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: correction: Re: [PATCH 4/6] dm,dax,pmem: prepare
	dax_copy_to/from_iter() APIs with DAXDEV_F_RECOVERY
Thread-Index: AQHXxhA/migZDNV1a0+SBofbRrgPHKvdURMAgADgEICAAA6KAA==
Date: Fri, 22 Oct 2021 01:41:16 +0000
Message-ID: <63e13de0-9167-3176-4d7f-b127bdf9cc07@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-5-jane.chu@oracle.com>
	<YXFOlKWUuwFUJxUZ@infradead.org>
	<325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
In-Reply-To: <325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e39ed84-8a1d-49c6-52b0-08d994fd0a1f
x-ms-traffictypediagnostic: BYAPR10MB2518:
x-microsoft-antispam-prvs: <BYAPR10MB251840E69BC536B2456819DFF3809@BYAPR10MB2518.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +rtzLkF1U+Nk9gDgTiN48YUU5QlA+5Q6JzLcq+698RN6bWEG6d1LArbm4btGJRIJszC/Gos6/ji84A0LjBA928X4hQM8xcpK0sI+2npb15cEv9efC4SoNOxoU/AsCk/tqRzPvCnFUmi3EMgZ+vLtrmgbz2RAuiXeOBnXtVJJOtrJAAeYO6+CA3tVtrarrzCKFcPpvlEeOIiSsnaoqaxLpAEr6IHz1iEiZ2Sa+rfI9T6RHfIY/CxPjNvFDFm/mwo6eX0KnS33QVZUW1W3oig/MpE+Gr8moz/HaSWffHusD0U+nUHFV4sJAj6QW3TVO8wugrCrk4EkgURtmisuCLigS0DJOgyVbhhGoR98Mh9wscZIQAK2EIQweHeyyBXM905S1zBAEXzETJc8yAJlmZEC65Iy7O09W6vhfjKiGhv9nxyOWmMAu1uwSQCcaA4ZqAEuA5u5ra12ghQaRLfcfEjOSpiux5Ri7xigz3OjguF7j+lkbL5R84QFeWzfuGyxiOlB0nystRKeHOANJG6akxWJRu9ng1kn1cWgJ2S4QPb5WuIlcArYFhZLgBDiUb4Pqd4/T3MAxu+AFvIas4HAPk5CXQysyWl3W//Ye3BGUZTs2iB6IZX7qAJR7ZI90HPxLyfLlcFdyAblJH2S3VZlxbohoyMu6AhAptW7HY46srmfk3CW2V2dp8uVf0pWLm5B8H5H5GXbsmRuY+D5K/Mby3nU/I424dFuKSftwFU8hb1s8ppSrN/IaxW6W5rfRkL51CO8E28SdBykuDsU8B3oTJ0R8A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(64756008)(66476007)(508600001)(2616005)(186003)(36756003)(66946007)(71200400001)(66446008)(5660300002)(4326008)(26005)(31686004)(2906002)(7416002)(91956017)(44832011)(66556008)(76116006)(6916009)(31696002)(53546011)(8676002)(316002)(38070700005)(38100700002)(6512007)(122000001)(6506007)(86362001)(8936002)(83380400001)(6486002)(54906003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0RnU1VNOStxZno3dmdLcEhNVWs3Vy9XK1Z6eEE5aFcxVS9BWDBXdnpJQzhD?=
	=?utf-8?B?Wnk0Nmljc1gzNVlIbkpSeUtOZ3pINm9yYTFwTkpJNklmdmtLWHNTRDg4YmJM?=
	=?utf-8?B?K1VKRWZFR0Z6cTVFUVJ5TWt1cWpPR3J4V0k5R0VvZEVSVEtUaEF3cVRveFIy?=
	=?utf-8?B?OG1QZ0lpZ1BVRzlSWUZ6SVNRV0dEbFI2VmdHNnlFZUdCYkZoR2U2SXppSWha?=
	=?utf-8?B?M09jTzdVSUJ3b0dxVjN2MjgzeHBwdjZBamhBcXRRd2pXYkRYVDMwdmNUdzd2?=
	=?utf-8?B?OUdPVklhYkw5M2l4U0ZCQ0dFZU1iekZ5RnM5NGVTSzJKMDBHMUswZDBUdHZL?=
	=?utf-8?B?ekZOUzZDQzlJUE93TDBycC90OGxoZFg1cUxMZVI4b09GNUU2YmVCVEp3dnBC?=
	=?utf-8?B?US9xcWlqNWlLS2JuNjl4bm5iTGE4a3MvaUZUdmk1b2RxRHNBb3F2RXVGeEhN?=
	=?utf-8?B?cGpNZkswbnlIRy9zTXlUNzVyMlJDREN3L05wU2lTR2tiSDlzS1JlSlAxUDgr?=
	=?utf-8?B?cktQVDB6ZFJ6RzhzS1A5N3hpWTA1b0FKK01jYUJpWFFiWW1YelZpRUc1VHQ4?=
	=?utf-8?B?ZTJDemNLNmo0eENvY3NHdzNCL1cvZWwyOXNFb0cwcktjVGdQZmwrb3U5eDM3?=
	=?utf-8?B?NzR4R3N6cE5UNFl2YU42YlF0Mk9Rc3lSb1pWOVBCTzJ1eDJLQmZXcFZ5NHdI?=
	=?utf-8?B?a21IeUpVYkJ4TVVxMHVmYjFSZzlCakFrU1E0UnNrc0UwbUFmNTNhbE9kUk1r?=
	=?utf-8?B?Y05zb0xmbW82TnljL2wxVWpDTkpCRjcvUXRmVTVRQlc3Yll2WjQ5R1YzaFFp?=
	=?utf-8?B?UGVMdW55akx0b0RSUHI3cExIMzlCY0xFVzNaUnZyZTRycE1SZEZhUXIvU3dU?=
	=?utf-8?B?UmhhMk9acTZ3RnhOdmVsdnp2NU5zN0gxTlhOVGV5T2tTZXpLZy9nRTZpMVZ4?=
	=?utf-8?B?UFRNUE9iL1VzZytkYVFjc1Z1OC8xampRbmRSaFdjeDhOcGVUZ2ludG9aTW9J?=
	=?utf-8?B?aVRhNmgzTHJSNS9Wc2RpTjk0emRpaGozWFE5MU8zelp6NjAyTVV2UTNwTHht?=
	=?utf-8?B?cE4vRWVlRHdxM3JHRHlzL3ZNaFU2VGFRc2xTU1B2WVpmYmNHWkNNbS9ianBT?=
	=?utf-8?B?eGVJam9QUWpYeWVTNlYwRUtaTE5pdmVmN05XQmFVOWxuTXM0N2oyOWVDV0xX?=
	=?utf-8?B?SGpEWjNuS3JHK0lEVGlwWlNsU0RaUStQbVYrVklQUVd4UHBOSjkxMTltcE9j?=
	=?utf-8?B?TXk5aG1TZ1QrQ0JTd3h6RFRWKytUVjRCbG95dDBjQjNGblNCNFVKYlB1LzFx?=
	=?utf-8?B?Y01xVHRvN2RaMjJxTmVNWjQrOFVvencvK2dSMFIrZ2tITlNNVS9TK2Fmd0xG?=
	=?utf-8?B?bjZiblZCc3duOWsyTkRwQlJlN1JOV3B6WmlUREZpYlExYnRBRHJESzQzZzFo?=
	=?utf-8?B?U2g3aWhHTFpTZDBEdFBWM085QTR3cXMrTlFzbjB1TEZRazFLalM3K2locmpC?=
	=?utf-8?B?aHZwa2lHVUpvRE1icUVHZHlaVThiSHJWWG5uSStvczJYbkFKWEpBTFJNSElW?=
	=?utf-8?B?NVBvayt3aW5ndDlaeEpkQWJuSUkrc3hZeEJ6WUY3VkZZZ2ZwUjVCcEdwM2NK?=
	=?utf-8?B?d0p6K0xkdzE1RXRneExBZU43ZXJyemNpblNyeXAwV041VVdhY3RpbUl2S2Yr?=
	=?utf-8?B?SmRnZm9jT2hvRTFFaHhNYUZuWlJteHZva2dhK1RNNEwvbzZ4ZUswUEdnVFV1?=
	=?utf-8?B?MzZRWWE4dUxlQkgyOWpzWERGa2tPQy8zNXJKSnNzOGcxN0dVRC8zWmRQaXVn?=
	=?utf-8?B?UndnVFNrYVFPS3FyckRvUnBGb0lHdFJoUTJkYm5ZSnMxZldlUXVydVNkZGNS?=
	=?utf-8?B?MTM5WU11c1IrbTgyMWk5THFmbFRTVWZ6WnRQZHBiTTNZT1RXd3pZNXQwY2Fs?=
	=?utf-8?Q?V/BXhUYGhow=3D?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e39ed84-8a1d-49c6-52b0-08d994fd0a1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 01:41:16.6619 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=0
	malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220006
X-Proofpoint-ORIG-GUID: pyz1KEocIsiAEUmg7QYwNsXKM12udw-e
X-Proofpoint-GUID: pyz1KEocIsiAEUmg7QYwNsXKM12udw-e
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19M1fbg9023055
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
Subject: [dm-devel] correction: Re: [PATCH 4/6] dm, dax,
 pmem: prepare dax_copy_to/from_iter() APIs with DAXDEV_F_RECOVERY
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6A6D15D8636F3B49AFDB786F5470921E@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 5:49 PM, Jane Chu wrote:
> On 10/21/2021 4:27 AM, Christoph Hellwig wrote:
>> On Wed, Oct 20, 2021 at 06:10:57PM -0600, Jane Chu wrote:
>>> Prepare dax_copy_to/from_iter() APIs with DAXDEV_F_RECOVERY flag
>>> such that when the flag is set, the underlying driver implementation
>>> of the APIs may deal with potential poison in a given address
>>> range and read partial data or write after clearing poison.
>>
>> FYI, I've been wondering for a while if we could just kill off these
>> methods entirely.  Basically the driver interaction consists of two
>> parts:
>>
>>    a) wether to use the flushcache/mcsafe variants of the generic helpers
>>    b) actually doing remapping for device mapper
>>
>> to me it seems like we should handle a) with flags in dax_operations,
>> and only have a remap callback for device mapper.  That way we'd avoid
>> the indirect calls for the native case, and also avoid tons of
>> boilerplate code.  "futher decouple DAX from block devices" series
>> already massages the device mapper into a form suitable for such
>> callbacks.
>>
> 
> I've looked through your "futher decouple DAX from block devices" series
> and likes the use of xarray in place of the host hash list.
> Which upstream version is the series based upon?
> If it's based on your development repo, I'd be happy to take a clone
> and rebase my patches on yours if you provide a link. Please let me
> know the best way to cooperate.
> 
> That said, I'm unclear at what you're trying to suggest with respect
> to the 'DAXDEV_F_RECOVERY' flag.  The flag came from upper dax-fs
> call stack to the dm target layer, and the dm targets are equipped
> with handling pmem driver specific task, so it appears that the flag

Apologies. The above line should be
"..., and the dm targets are _not_ equipped with handling pmem driver
specific task,"

-jane


> would need to be passed down to the native pmem layer, right?
> Am I totally missing your point?
> 
> thanks,
> -jane
> 


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

