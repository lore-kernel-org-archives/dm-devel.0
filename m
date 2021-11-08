Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1467FC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 20:44:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6281610F8
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 20:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A6281610F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-eDuZe78RPkCbs376p_2Gsw-1; Mon, 08 Nov 2021 15:44:20 -0500
X-MC-Unique: eDuZe78RPkCbs376p_2Gsw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55E2A1054F98;
	Mon,  8 Nov 2021 20:44:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C91078B36;
	Mon,  8 Nov 2021 20:44:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 61E2D4EA2A;
	Mon,  8 Nov 2021 20:44:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8Ki8XB026217 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 15:44:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D2267400DB2F; Mon,  8 Nov 2021 20:44:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBBD24010E77
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 20:44:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE314801E6E
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 20:44:08 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-540-Q-jkvBMrMZyugSB8jt1FLQ-1; Mon, 08 Nov 2021 15:44:05 -0500
X-MC-Unique: Q-jkvBMrMZyugSB8jt1FLQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A8JxiuM028580; Mon, 8 Nov 2021 20:43:43 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c6st8pctd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 20:43:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A8Kad7O016545;
	Mon, 8 Nov 2021 20:43:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by userp3020.oracle.com with ESMTP id 3c63frv93q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 20:43:19 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3111.namprd10.prod.outlook.com (2603:10b6:a03:159::28)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Mon, 8 Nov 2021 20:43:16 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016;
	Mon, 8 Nov 2021 20:43:16 +0000
From: Jane Chu <jane.chu@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [PATCH v2 1/2] dax: Introduce normal and recovery dax operation
	modes
Thread-Index: AQHX0qwD5+Ie66qqNUGG2WP/amHP1av1vCQAgARhBgA=
Date: Mon, 8 Nov 2021 20:43:16 +0000
Message-ID: <7c8c71a4-ab7a-080e-1d61-d559003f052f@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-2-jane.chu@oracle.com>
	<20211106015058.GK2237511@magnolia>
In-Reply-To: <20211106015058.GK2237511@magnolia>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f22a845-faee-473e-e207-08d9a2f86451
x-ms-traffictypediagnostic: BYAPR10MB3111:
x-microsoft-antispam-prvs: <BYAPR10MB311129F25AB57797C981EFC3F3919@BYAPR10MB3111.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nUgBKSMvnZk6zCBga6XNNkCdNoB+UuMeaSZJ4CMOTk6gnBZfQG9wj8U8sw8wsf8VlSJKjnirqplKKmGTF1uo0sLyCnay9GE9PlPEql+C86xWJ2c9OJPqNW0axtK+gpU+j8TNMz3q1XRPjAjRux9TudJrnscxNA3WBAqlBXD0QhzATfl0QE+PA+O6X3UR1W/2y6rjLgaKH9uYEofY6esbVnuybPc3zqn4DT8lH6C2QXHsXzONZYol2BIJCa4Zm7O6QdVOoJFp7oRHa2O71K2rOrkEzXXogxfIn0jHvkEHdaWEyrAe9lXaH9F+QYQEUFBBJqc625/Ab2XLznPJ5cZCtcM7Lga7oBe+ZBEJt/fi+9+VWJCtk8zR9piR2hwKdsII7DV+CF8WR/muqiIviHEJadiFRlhQNmSjPAPjUDdpItIs1Rs+YqnhDSMki4KjgizNTE7mD3Y0slX1ONrKfy4uCKTOgavC7e5cMHUXHNxNrVrdDHCl7LaXY+/kSDX+wVexGJaHK8d1b0oZQk5598YncT8nPExi979C6sqcKjgZW5Xunvhrui8kuY9FyJtJPIxsHPDCBPkCJ6mtIq3mF32jKxQy1JEEZ3ChIIq0GZZlDEZadjasOqG05q/D/YOMdk0bPqoC5KyfbUgQB/r6whMMU/8IbVMZoSEfmf4uOYRJ3OB67QyaI2y98jg+BtM8ZinASb/D/mxhCjzoHsJ8IJGGMUUKerHyDRnvANdBB2G0yIj525ieAblVfacXiOVult/8CbKyxqLLoufpmB32724QPw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(36756003)(76116006)(31696002)(66476007)(186003)(66556008)(66446008)(83380400001)(6512007)(508600001)(86362001)(31686004)(54906003)(2616005)(122000001)(6506007)(53546011)(64756008)(6916009)(44832011)(4326008)(5660300002)(6486002)(91956017)(66946007)(71200400001)(7416002)(8676002)(38070700005)(316002)(2906002)(38100700002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vjh1ZG9Qb3F6cS9MUzJLN3ZjR3Y4OHdOaGVXRnl3NTNwZFN3TjFQRkRxNWJH?=
	=?utf-8?B?Wm8xQmw1Tk9sM3lvRkhMdDhFS1A2L1dQQXpaTzI2cXFmd3YreE9tblYydDNk?=
	=?utf-8?B?cXhoSUd4bDYxVGxHOGRTQlZMcWhpWmVRc2MwMVUwVGZnVWVpMSttMXYya25Z?=
	=?utf-8?B?RnJ0UU5ZRTlGSCtpK1ljTWRkSkVpQjJlVklYa2lNZXRqcFZWN0FtNHd6L1p1?=
	=?utf-8?B?WlJFUnhMNENQQzFDRmE1VHFwN2RVbUt1YnZWOWxmN2o3UUxHZzhJMWJiUURn?=
	=?utf-8?B?N1NLaUlIbWVjUHoyQ2llY3dxM0ZWYXlQMjdxQ05id1ByMFFoQU5OYVhhNlJK?=
	=?utf-8?B?RGl6eFJxT2RNZFJwc3I3MFZLWitvdEJMRmVYLzBMTUhiVlQydU10UDZiMmE3?=
	=?utf-8?B?dEpwZHVBVVBhZERGaEFUT0xYak5WUkliUmsvWUl1OXZlR3hzdFpmQm1rdkpM?=
	=?utf-8?B?OXhnc0ZFUUdBUTYyOWZxTTNjNDZ1V3BNWTU4OGlFRitmQkViWE0rZE1kaTJF?=
	=?utf-8?B?VmhUQ0Q5V25iK05vOElhREpqMDVsaHppcUxPUnhwOFRHQ1JCZFJtVHZQQzM4?=
	=?utf-8?B?UnFqZTRMTGN2UFJVNUdzTFZQMlpVUVp2aXZ3UWpCUUVQemdJOW9FbGpJU1o0?=
	=?utf-8?B?OFJORzhqbmVidnRXVW9JTnBEQUZ2R2R3ck83OVBsRmIrYXJuVDhEMnVreUpK?=
	=?utf-8?B?bDU1cGdIQklXajRVRUpGVFNCWWJ0NEF0YjVkYUJBTkhsVkdFdE1ybExGdE0x?=
	=?utf-8?B?Tit5dU1ZeXVIRXRmeTJIQ2ZxOGovVWwzQk5QbEcvS3RYWDVTUC84UmdwbkZD?=
	=?utf-8?B?eGtTS28zUDFHODNtOURoWm5IbVlRUnFFR1F1emIrNHlERE9kc3huSytKdVpZ?=
	=?utf-8?B?d0MycVU1L3NESk1mTWFXWnhEbG94U014dFZHRTZYRmZ4NE85Y2FSV2Q4Umlm?=
	=?utf-8?B?Nm5tRi9VRWZIK093VnJDTzRhZWU0VVpid254T1ZNTFlCbjJlWURDR0pheE53?=
	=?utf-8?B?VXUrUGppZ0JUT3NhNy9xM29NYzdiRGpJUFlDZkFBSSs4aHliYjBKeWVid055?=
	=?utf-8?B?Z3UwYkNaRGxrZi9hSlZhUGVpcDdMeWNOU0l4d2tma1czZ0xkNjgrUW5maDZR?=
	=?utf-8?B?ck04VjVuTm5jYzdQVERoY2FGNURHOWIxUUZFRXVZWGJuVjdvTXAzQVFMTE9U?=
	=?utf-8?B?K0g3ZGxmRnNORGJUVjM1aHVieGZlM3dCWWlNMFB4Q2NSaTZTbWNGQ0VBQnNG?=
	=?utf-8?B?dHhXQlRUTVZnNjhYSEs0S25iM21UMDV3Mno2cW1PbW9sQ2plMGF1ODQxVXVj?=
	=?utf-8?B?KzNPcjNudE5WN2xUTElPWEFxNWFBZ0VDM1lINkg1dHA4WnJGRXM4OW9ubWkw?=
	=?utf-8?B?QnpKcGEzYTBqMHJoOHJvQnFXV3BwdXVGTzRKclNSTzZXVlR5MGc0ZHJmQjcr?=
	=?utf-8?B?TnFVeVQzbHphU0syNXdGQlZZTWdVY0J4Mi9jUDJadUVIMC9KdXNkZlZWSXVX?=
	=?utf-8?B?dUJoVFdoRm9hbktRL3cxcU1sMXc5cGQrSmsxRkEyQzFNQUUwVGhaajlVc3VW?=
	=?utf-8?B?WEg5YUx0MktKdk1xaWt3cG5XR3dkZ29Ca1FxUE1CUmkwWGVmVlorcjc1Z3pl?=
	=?utf-8?B?cVdBUUpZTURuRzMwd2FzVFJ5cER0UFI2SkE4bkNxRlMvWlhPeWUyYzYvQk52?=
	=?utf-8?B?TWpqUk9sT24yMUxyc2dNK0ptZnBXa0Zocm5WQzN6SGVFOHJOOHJ0NFUzZWNp?=
	=?utf-8?B?Mnd6N24xVU9aVjBnejdVd0dMc1lOSE40VGtFcTJjQTJGejdYSnZjWGxOZkN6?=
	=?utf-8?B?UnNXMjluSUZXM1VaRjhub29qUCswcHhFMCt0eFprR2xERjlNTGNhcUdqNzJk?=
	=?utf-8?B?SHhYM2djaldrVDQ0aFFtMFp2REVWbUFVWFRHVEFNUjZEYm10OVE3aUFzb2RW?=
	=?utf-8?B?OHhmcWhkM2xFNFR4UWRtSU05ZlJRaWttRi9CVmNhY0NpRlVpaXZsMi9PbVlB?=
	=?utf-8?B?L3J2RHpyaTlueDBlQk56MzlTSnRGSzAzeDl1N0tQRnEzYm95TXVZUk1yc0Z1?=
	=?utf-8?B?QlFFbUgxVG1KZ1I4YVFzSE0wS1RLM2JyN1Y0TkdWRFp2TURUa2V0cnpYeVNp?=
	=?utf-8?B?c2dtMWFuSmZEQy9MLzNWY1dPQlRpN1lYNG5mRDFVU05Sd3VWUHRVWTZacXNv?=
	=?utf-8?Q?7/4/2jTW0m0r98W2Z9mFEwEbOJKHuWvGHvjvl/uriyH8?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f22a845-faee-473e-e207-08d9a2f86451
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 20:43:16.7297 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t/dNnDXsY0YsaOpAX83XqPEeqVlGy2V2s/e4FNrRjoyxqsnQ44jopxLE5+q18GEYn0YjR7kg9S1wXh+HPbN4Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3111
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	spamscore=0 mlxscore=0
	bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111080121
X-Proofpoint-ORIG-GUID: kMM1QFaZcWaPW0Hw3-BQmWgy2LFi2shq
X-Proofpoint-GUID: kMM1QFaZcWaPW0Hw3-BQmWgy2LFi2shq
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A8Ki8XB026217
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dax: Introduce normal and recovery
 dax operation modes
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
Content-ID: <75AD54115B87654589DBDBC573D465C1@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/5/2021 6:50 PM, Darrick J. Wong wrote:
> 
> <snip>
> 
>> diff --git a/include/linux/dax.h b/include/linux/dax.h
>> index 324363b798ec..931586df2905 100644
>> --- a/include/linux/dax.h
>> +++ b/include/linux/dax.h
>> @@ -9,6 +9,10 @@
>>   /* Flag for synchronous flush */
>>   #define DAXDEV_F_SYNC (1UL << 0)
>>   
>> +/* dax operation mode dynamically set by caller */
>> +#define	DAX_OP_NORMAL		0
>> +#define	DAX_OP_RECOVERY		1
> 
> Mostly looks ok to me, but since this is an operation mode, should this
> be an enum instead of an int?

Yeah, I tried enum at first, and then noticed that the
new dax enum type need to be introduced to device-mapper.h
by either include dax.h or define a mirrored enum, and
I wondered if that would be an over kill, so I ended up
settle on #define.

> 
> Granted I also think six arguments is a lot... though I don't really
> see any better way to do this.

Dan has a suggestion, and that'll reduce the number of args to 5.
> 
> (Dunno, I spent all day running internal patches through the process
> gauntlet so this is the remaining 2% of my brain speaking...)

Thanks!
-jane

> 
> --D
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

