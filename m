Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 295ADC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 22:19:15 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-nRstEMVRN8OXxcL1LNjmcA-1; Wed, 02 Feb 2022 17:19:11 -0500
X-MC-Unique: nRstEMVRN8OXxcL1LNjmcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5E2B46865;
	Wed,  2 Feb 2022 22:19:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 263E956F79;
	Wed,  2 Feb 2022 22:19:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 716CC1809CB8;
	Wed,  2 Feb 2022 22:19:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212MJ3af022636 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 17:19:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4523440BB2D; Wed,  2 Feb 2022 22:19:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4057E406791
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 22:19:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21B5D802319
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 22:19:03 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-22-yD7NdjHZMfSpsNF22ytB4A-1; Wed, 02 Feb 2022 17:18:59 -0500
X-MC-Unique: yD7NdjHZMfSpsNF22ytB4A-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	212KwYh1003711; Wed, 2 Feb 2022 22:18:43 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9vfm65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 22:18:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212MFl6h122368;
	Wed, 2 Feb 2022 22:18:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by aserp3030.oracle.com with ESMTP id 3dvumj9j5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 22:18:42 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by DM6PR10MB3563.namprd10.prod.outlook.com (2603:10b6:5:154::21) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20;
	Wed, 2 Feb 2022 22:18:39 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 22:18:39 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v5 6/7] dax: add recovery_write to dax_iomap_iter in
	failure path
Thread-Index: AQHYFI6P7d70lHAIX0mg02wePMQ1DayATMGAgACPyoA=
Date: Wed, 2 Feb 2022 22:18:39 +0000
Message-ID: <48bbf3e1-0eeb-5a77-44c7-20d0cfdb8338@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-7-jane.chu@oracle.com>
	<YfqKoZ79CqvW8eLq@infradead.org>
In-Reply-To: <YfqKoZ79CqvW8eLq@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51e79358-4566-4684-2b71-08d9e699f6f5
x-ms-traffictypediagnostic: DM6PR10MB3563:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3563D6F707DB8FD8D9F3C4D2F3279@DM6PR10MB3563.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zZmtmqBeUIz0EbZZTqAew+xgvjSGVyUbDAmqxAdTaE9oRJ41SU4hTCgx/rfYZy16RCPxaZhSFSmgu8hig/8AIi3T4WO9pasw02u9fj/yiBhHQRIiXX9KuWL1wj1uRM1DKHQW8YHss3u5gm9sE3kwr2PXILq7nOipRykEolXAMZM6OH2PzqgBcbJPvQLUJNbr350jeqhhSpj8P8VMfWp+MFn56gEihuZHXR7WhhjZAqP7W3u1ceNN9pe1VbM4WZQOjhVfgWvNSPKI7ZU6yRc54oz3ahfHf75a1pJ8NlGm/GfNMfnG52gg0sxW42OoKfEVL+68JvFzS0LpM1pM0Gfnj5ReDeRPBFvRb0Ksxnsqv0ZtwQ3OjRD/82SZddNOBQGVtLu3N9OPgX0ujY8w7e+s1wQ6r6IsRpg9BrxnRlILoIhL5AvcebxIPDu5vlBJfx7WSLW7qTOlEI9khZhkvcymFzHRcQDtO0F3gW7rxTAPOx5nA0mZ4hqwY9nbksBgpwEhYS7AWPSd9QQuNFEJCnSkKI3j1VPbldcBfS+/1yHdN8UTvnYPSpepvTR0Ju6yqnM+uxWbNeKf94y+N/Jg2WJ+AlGrC1GXwhue+hF4T9tw7kFWcU+lB9uVruud0a/vRw7I33AwVE+SWG5RsjLn8AS0+V/d2Yiy8t7ft3+VxQva6M6tCIbwolmvpJtfjMGsdZwgBP0ZQLnqfc1no3mw88m+/P8YflwWkcfqzgHG4XbAqyPdYVLw5Ki/4tZIk3pidM1ZxN5PZFgjS4997ZRR5oa+Ow==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(44832011)(7416002)(2906002)(122000001)(38070700005)(38100700002)(31686004)(4326008)(8676002)(8936002)(64756008)(66556008)(86362001)(5660300002)(66476007)(66446008)(6486002)(6916009)(54906003)(186003)(2616005)(76116006)(316002)(91956017)(31696002)(66946007)(508600001)(71200400001)(36756003)(6512007)(26005)(53546011)(6506007)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dk1LSjlPN2pLcU9xSXFYT3YveHFWSW43dnFoQVY1SXp2SE1zTHJNMjUxM2RB?=
	=?utf-8?B?N2p0TlNvL0xycWx6eXFQNHRPdEFxRnErQ2ZxbTFheTMrQ2Z0YVg2cWZUV2Ft?=
	=?utf-8?B?Q0lpNFh6K3FBMS9RcUdlL1FEZExOWTRzYU9LU2t5R0NSa0dNczhJY0E4YURW?=
	=?utf-8?B?MlpqZ0xtSVNtTnRjbEhMQUx0MWVZRThNWXFZV1lhUjVLZWQ1dGhDSWlWRkZ3?=
	=?utf-8?B?aHAvM0k3Y05BN1F6bHdzc3JzSTB0K1o3WWtDdGdrRUR6cjgzUUJHMDN3TjFj?=
	=?utf-8?B?QnAxTXFnS1I0VytCcTNqT0l6S1hucXVYSGtIZlJtTW9rYjQ5R3M0ejJ5Q2Nl?=
	=?utf-8?B?OS9xTjgrRTJxSDMyenVJb0tuUmNXMUlUU2puWHI5VStHeFVnM1EwUmI3d1NW?=
	=?utf-8?B?b0JmS2kxY0xYNmhFdUQ4blBteUl4K0Zib3Q3akhidlV2dE5mRXRiRHZnVVpv?=
	=?utf-8?B?dkRvbWg4bDgxU0trTjJNdWpOL0xoaHRkZ2JlSGFWSDZuSGh4NFhyREU4TW56?=
	=?utf-8?B?S1dhN1IwcG1JT1d5SUdTVWl2aVdDV0lZSUpxQWl3S2lrSUEyVXloVjhFTzNm?=
	=?utf-8?B?N2xmQW12QmtJRjgwbDh6UTA1eDV6MEtPTDRtWDE3UEJwTC9xVmQ2eHNoMk1w?=
	=?utf-8?B?K3o0TDRNZ05BTi9hMnBrZ1FqWE9EQUpMY0F1TEo5U1h4RFkvQm1paE9qOE0y?=
	=?utf-8?B?dHgwTFVORlR0SmNGbkJaN21TNzRuWEhxZmFwU2U4Y0FaZWxSN0xPc1FoRGFr?=
	=?utf-8?B?L0JDcmxuNGxhZUlPQ0U1eGU3ZGpXYktuVVRsWGVIak9FSThSTnJUV3VVbHMw?=
	=?utf-8?B?eGJGdUVpQ2RvWU55NEJiTCtzOXBoTjc0bytuOC9iblhhZ1Vpc3U3dHJ5UWNE?=
	=?utf-8?B?Y3FjSis5cUdrWlpvZzBrS3dkK1ZEWGJTWFJXQmdUN3Y4emVEMXJubm1vRUdW?=
	=?utf-8?B?SEhmZ2FOTWl3VWdJTUVlU29JTUR2K1BMUFJycGtZK2VUd0xrNVVlRm8wazI0?=
	=?utf-8?B?aXh6cTFQTDN2T01UdlNaVk96SWFGbTBsYzBHZmpCaGR0bDZ3aERpcnB2ZWZR?=
	=?utf-8?B?TjVEMmp1QTVEdkxyOUF3MWlEN1ovZGwzTUxqK0d0VWVVeVM5dysvbjNSd3E0?=
	=?utf-8?B?TkJlTkZhdVU5UnBvRkZiamcxTVRTV0paV0orVWVQNkFDaDBCanZXZ2x2Tm9k?=
	=?utf-8?B?YlZSTFBCdEF0WHVhY3VjKzc1ZzExTmFVY1k5S2ViZXkvMGlYR0o2UlJMUUo4?=
	=?utf-8?B?b2lwUkZqb2dqRlNPZXZSWWtHNGxxWDlmQkFzcDZlYmNrK3FMcENManR4YTl5?=
	=?utf-8?B?bHNTMUZ5aG1UM3k0LzU5anNOeTdNa2FlemxMVENmaTM3L2NiNlhJMWdQUm16?=
	=?utf-8?B?bDJxeG5jZlR3V2xPY3RERE5Lbm0waDBmdmlKTktCbWFwOXhIamZiVjVvc1hl?=
	=?utf-8?B?dktuTlNWVmd0dE1hS3FsdHFKZXNPbitHb1RDTUpUODZsK29nVU9SRkN3WWhI?=
	=?utf-8?B?bVhrM3BoVGwvdk9oQ0dmVjJkbDZUdHZmYlFra2Y1aU4xRHBUZTh4enpETzhR?=
	=?utf-8?B?K29WbTRwUXB5bERzbENuZ0NKMkQxU20rSmE2cHhSbnVTaWQrSGRrQ014Q0Zk?=
	=?utf-8?B?NVFUVG9yRzRsZnlTczJ2ZzhnNVpnMGlsd1pCdU1TRHN6RHpJdWZ4WklzL0xm?=
	=?utf-8?B?ZDcrc2EyR2FWRWpBVFN2cm1IZ2gwenVPTTdId1lDMUQxU0NuY2xBYzBOTmla?=
	=?utf-8?B?UGlqUmp3UTZoZU0vTGZvVGtpbGNLQjhXVE85bEY0VzRpbGZRK2ZEYnMycEVz?=
	=?utf-8?B?YmdUUWlyZ3hmS1NKWW9LVGU1aFB0WmxWRlA0QXlUaEQwbmxLVUVXWkp6S3Zq?=
	=?utf-8?B?cXB5TlRyVmdKemorUXBxT2NXeWROWklhb2R1QkMzeVBLRmdOdjVSSXFmU0JC?=
	=?utf-8?B?Njl6OGVZTitTOXJNQ0FQVm12U2gxV2ZteDcxd0ZsWnpma1RtZ0NIcFpvNjNy?=
	=?utf-8?B?UFQ2WFhHQ3ZmWU1LZkZwT1VScHkxWnNpUDJUTmpQZVRwUjEvallGTXZpMDQy?=
	=?utf-8?B?emEvVnRRckprVkZwcFJoVGRHakhNUVdtTy9FYXNhamVONXBiSmpvcVAxWFVz?=
	=?utf-8?B?MXZtWmo4S2FSME9kOWt2QXplVlNoYjQzcFM5SFo5ZzZ5TThYMkJabGdZY20z?=
	=?utf-8?B?OFE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e79358-4566-4684-2b71-08d9e699f6f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 22:18:39.6345 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XI/zNEfuO7RfryxLH4ESSka+DfflQR5wI+VaUsT5ePL7Znk0bDseVsuctJyOWUYehDI4E1f+YkUGhoz2gErb8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	malwarescore=0 phishscore=0
	mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202020121
X-Proofpoint-ORIG-GUID: WsDzVRlj9c4eMgSzIHB1PW2kPUdOmiEb
X-Proofpoint-GUID: WsDzVRlj9c4eMgSzIHB1PW2kPUdOmiEb
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212MJ3af022636
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
Subject: Re: [dm-devel] [PATCH v5 6/7] dax: add recovery_write to
 dax_iomap_iter in failure path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <ACD42EFAB89ABB438D45A91B16B52257@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/2/2022 5:44 AM, Christoph Hellwig wrote:
> On Fri, Jan 28, 2022 at 02:31:49PM -0700, Jane Chu wrote:
>> +typedef size_t (*iter_func_t)(struct dax_device *dax_dev, pgoff_t pgoff,
>> +		void *addr, size_t bytes, struct iov_iter *i);
>>   static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>   		struct iov_iter *iter)
>>   {
>> @@ -1210,6 +1212,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>>   	ssize_t ret = 0;
>>   	size_t xfer;
>>   	int id;
>> +	iter_func_t write_func = dax_copy_from_iter;
> 
> This use of a function pointer causes indirect call overhead.  A simple
> "bool in_recovery" or do_recovery does the trick in a way that is
> both more readable and generates faster code.

Good point, thanks!

> 
>> +		if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
> 
> No need for the braces.

Did you mean the outer "( )" ?

> 
>>   		if (iov_iter_rw(iter) == WRITE)
>> -			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
>> -					map_len, iter);
>> +			xfer = write_func(dax_dev, pgoff, kaddr, map_len, iter);
>>   		else
>>   			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
>>   					map_len, iter);
> 
> i.e.
> 
> 		if (iov_iter_rw(iter) == READ)
> 			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
> 					map_len, iter);
> 		else if (unlikely(do_recovery))
> 			xfer = dax_recovery_write(dax_dev, pgoff, kaddr,
> 					map_len, iter);
> 		else
> 			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
> 					map_len, iter);
> 

Will do.

Thanks a lot!

-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

