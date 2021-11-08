Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F3DC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 20:54:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E635619E0
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 20:54:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E635619E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-J9vY8U61Ple9HhFF3S2C5w-1; Mon, 08 Nov 2021 15:54:39 -0500
X-MC-Unique: J9vY8U61Ple9HhFF3S2C5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94C18102CB29;
	Mon,  8 Nov 2021 20:54:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD02677E26;
	Mon,  8 Nov 2021 20:54:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3AD964EA2A;
	Mon,  8 Nov 2021 20:54:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8Ks2EF026719 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 15:54:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 64BA84047279; Mon,  8 Nov 2021 20:54:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FA124047272
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 20:54:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 412491066558
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 20:54:02 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-571-9wRxoq17Nk-QmTHEfmbA7w-1; Mon, 08 Nov 2021 15:54:00 -0500
X-MC-Unique: 9wRxoq17Nk-QmTHEfmbA7w-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A8JxtMV020162; Mon, 8 Nov 2021 20:53:53 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c6t705uqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 20:53:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A8Kob9c082661;
	Mon, 8 Nov 2021 20:53:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com
	(mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
	by userp3020.oracle.com with ESMTP id 3c63frvq26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 20:53:41 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3d7::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Mon, 8 Nov 2021 20:53:39 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016;
	Mon, 8 Nov 2021 20:53:39 +0000
From: Jane Chu <jane.chu@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Thread-Index: AQHX0qwHA1irfgJJPUKt0/SD8Ofb86v1wA+AgARgAQA=
Date: Mon, 8 Nov 2021 20:53:39 +0000
Message-ID: <b3ed6cbb-4993-7930-6020-635b19ff1273@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<20211106020459.GL2237511@magnolia>
In-Reply-To: <20211106020459.GL2237511@magnolia>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31a5a4ef-df24-4f0d-c091-08d9a2f9d762
x-ms-traffictypediagnostic: SJ0PR10MB5647:
x-microsoft-antispam-prvs: <SJ0PR10MB5647832FB8C6AC9F40604892F3919@SJ0PR10MB5647.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /voTo9tCA052/+TyLr+n1AHcOoMAsqLKXqxtdUWxEcrU5fHnIm02lNKwEPmSewJEIHVcoyTGe4o7b7dBejUNwNbFh+5k1VZUKBexe8OyQ0ToNOsvhb3jUycPLCBdMePedCkVA1gmcgQjMERapORvcG4+ZcSh/PvihUQbQQVpv0B5ok1Xx/nPrCdrfCFOV2SNT04j9YLfxnwYdVAhTfgM20o5TiBnlsuaEaCyQiIYZcULfx5its2dA6i2ExfrplWlqgMmws1VavfqCrw6dlgaEMtHg20UlHOWdYtrb9o46Jx3n8gCazSORovsho+zaAq7M3KZT0hEN8bKIVFCkR6UzQfPA83et2T1ZuMwNVubOqQXKzr+h5KrDEcbMgRvm0eO8l1SX1iX1X8GtEl8TjI/pZeYdJ5eizt1iv9YljO+0vPe5oHh/aszt/oWC2eQl99WSJXSiNaBgXeiZOYMyaFp/36MsjJL4+WzoOFpE55n+FMl8XTRpzr4KfozPa9Rbl1EdNe2mcBU8rWAeaq9IBHKHsx8tyYXmwoDubK9WPGcu/xfuNePzTVanh/166tEKLWDgADvwAbYFTkHPQ92cMt0ApZnzKGZc3Olr968TtvPle6WUXuwoK2EDpnUZ30nll5q2gPRbk0V76ijgZtm8kNEL+XT1chEXhzQMwUtf9468aQsLrHfpjx3+tJzrIIfUf2zTRbfUMg60Qi6LBXdgkGaARABxdIgfHgQYBkdGm3CcTpIiZoUohcPQmaIBAfWozIJwsM+yNi4mnG5/Pxq3kLmIw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2906002)(38100700002)(71200400001)(31686004)(66946007)(91956017)(7416002)(5660300002)(66476007)(316002)(36756003)(6916009)(53546011)(66446008)(66556008)(76116006)(8676002)(122000001)(64756008)(44832011)(8936002)(31696002)(83380400001)(38070700005)(86362001)(6506007)(508600001)(6486002)(4326008)(2616005)(54906003)(186003)(6512007)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGxVdnpSYWhpM1JwVzQyU1RXb2xTeEtRb01zMi9nSlF5Zm11QjJadTZjYXpo?=
	=?utf-8?B?ZURpUUtMRHh6dlRnVnF5OXVHVWRDdkU0eWtYekZnNWJPbDJXMWNoUVJmMEhJ?=
	=?utf-8?B?bU1BamdhUTNtNFE3aE1sZEo5M2lrOCtCTlpqVUJmTU5FbHJpdVFDMzg1MTFt?=
	=?utf-8?B?OVBtZXprM20zd2RWV1NPd25hWUhFZmdUZDcrWUd1ekMxTzVKVE1oUTYyaDFI?=
	=?utf-8?B?aENJMkNRVkRuUkU4QXFycVBrb29GNFNCT0lodXNFSzM0RmMxSVBhT3JjNG5F?=
	=?utf-8?B?aTVOMTJLVzVEV2RCRGZyKzQ3TWlOQ2ZoWElmcWtWVFpmV1p4T1J6M2gzS2FF?=
	=?utf-8?B?ZDF4Y1NsbVV3QVJ3S1NzRzl1TlFmVVJ5OVlHYXR4M3pHYUJkbXZFRDk5bG5P?=
	=?utf-8?B?QndDNE5mcndYbk5xbWFKLzljdlQ1d1pCWkZqVWNHb1VDSlFDWnF1NmNFMzI0?=
	=?utf-8?B?NjhCSGZxNkU1dVZSRjFyWncyQy9LMk5ycEEvWGNKcDhsWFEzdzNOeE1mRnVM?=
	=?utf-8?B?WjhsZEM3Sk13MXFZM25Pby9QMW5QT1pYTmZ4WllXcnZ2aUhPV2hqUE1XQjhi?=
	=?utf-8?B?M0pMRmNhbHg0WXFubWc1RVZIa3RDblBMaDJsUlJhcndLSHA1T1NWNWxoVW9q?=
	=?utf-8?B?ZDBRWXZ3c3ZZZExuVHo5S2tNVzBMZmNKa3BWT3JQSFFWeFJSbnNFY0x4WnVK?=
	=?utf-8?B?Wk9ocWx2R1llVDBTZzZNSnh4aHU3eW1GVGxwbjhLOEtrdmljTm5IbzhoVi93?=
	=?utf-8?B?N2RJeUlLRUZDeEppTDR1WVRiRERjbjBmdC9qbWhLeDRzRGtDZEN1eERrZGtS?=
	=?utf-8?B?WjNoQzFkdHRpV0d5ZkZtSWxWN2lrem91Uzd1Sld5b0o0czJTUHlmdnhqcG1B?=
	=?utf-8?B?YXJiQUZLL3JtelR2bSt4TzZFeUo4M0M4S29UQ2RubmlOYmZrTE1CTkpSdjhF?=
	=?utf-8?B?L1Q0bGcwalc0TTRqdCtsbHRqRFF4U0Z5dE9DcGdwYnZmZVh4R0ZsTlJlUS9z?=
	=?utf-8?B?MkNzdU12eGNXSFl5cVd6NjFCWThCUGxlTWJaQTQ4YTV1SUtDZ2xPT1F3eCsv?=
	=?utf-8?B?ZTdOcUJOeng1cHlRajlQZmhXZm5KanFjOFQ5a2QvNGdhdFNCNnkvdXZuTTUw?=
	=?utf-8?B?Y3FPK1JkdUxWQUJmbWpPU0xWMmJ6ZVUySEkxdy91SlVKMnNFWkQyREpxSWRN?=
	=?utf-8?B?ZFA0S3NkMHI5M2VISUJZTzNLOXdOTTl0OVpwY3JuQ2NiNlQ3V01pOFJFcjlK?=
	=?utf-8?B?NmNTNEpLaDdhMDFMZDBkSXlhZGFnRTg3c2ZVTzBoNmFRKzlPSXVpRlBBd3FC?=
	=?utf-8?B?UGtUeE9JUndod1RoTEZaK1lvd2ViSzJxZmdNbGNUWVkvRkNjYXM3OGNpRktK?=
	=?utf-8?B?TDlWdUhCNkwyWWp1c0h5YWxmb0lDeWtvTjFsdGh4eUFBazBlZHRvN1JsRlN3?=
	=?utf-8?B?aXZYUFI3bm8yMVhJekR4ak5XbDFwb0xvMUJqUTBxY1hjcXU0WWg4Q2s1cjVN?=
	=?utf-8?B?cEJ1RGtWMzkwNGczemhqR1VqbEFsNkNPRHdUSnRtUmgzSTB0QnNHYmpqVS80?=
	=?utf-8?B?VzZROFcrSWkzNmNTZExOUkZ5YUxwd2FGVjBSR1lqckRXckNqaU9KZU9xRElj?=
	=?utf-8?B?TllFN1hyR3NON3VDa2VjSkZpN2VKU0p3NDhZa2hrSEdLOGE4VDJOcHhMcEVr?=
	=?utf-8?B?L1NkSGppMmM2U2U5cGQxNmZ5SGhWZDJ0bWFnZ2I0YTJBTWxqREZKd2oyMy9y?=
	=?utf-8?B?VkZ5RVdtaVU2dmxhU29XVzZDTlRJU21xRmFRdW43TTRCSklrUUxvaWlZVElW?=
	=?utf-8?B?dHRqd3NETGFLQWYwN0dGUFMrdXdpSDdZc0NlczFUWmpidXpxcmIzTXZsT1Rz?=
	=?utf-8?B?VlJmZ0FOVG1OZEdPMk1nd1Q1NVhoaEhvbHR2VjUrMXJ3SmhHbGlXSUdJSUxC?=
	=?utf-8?B?Z0ZSaDlSODdxaFVKN3pMMUxBZ3lpV0lFUWo1YjkrTlBNOGRpcnRVN01TZ0hT?=
	=?utf-8?B?NVlDSTlaVEYwdE5aMlBSOFVvYWpQMDl3UmNBZ092T0RjSFZvUXhkRjdmWGh4?=
	=?utf-8?B?Y3RWZU12WEhqY3pZdUhJZGVteC8xMUpReCtUUFNJbXdhd1ZkTFZ6enBDVmNy?=
	=?utf-8?B?NytKNXU3S0tGUStDZmNUZlRaNDczVmdCNGpYclE3RlByUHlvaTlCdWQvZ3F5?=
	=?utf-8?Q?OVJtvgOFHy2ajlc6kmtfc2vYWcQTMYg+kqKQXBozyazF?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a5a4ef-df24-4f0d-c091-08d9a2f9d762
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 20:53:39.2690 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jO7KYV5UkcCd70VO6WV/dqp5CAaNLLXVwUzoKVOPFXawdWCca3TYi+w+hRumOKdUvOB+pRcd9qGim8Nv6SXg5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	spamscore=0 mlxscore=0
	bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111080123
X-Proofpoint-GUID: RE3F2MM2jaP60G1ooY-MC4BnFrGTz8AF
X-Proofpoint-ORIG-GUID: RE3F2MM2jaP60G1ooY-MC4BnFrGTz8AF
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A8Ks2EF026719
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
Subject: Re: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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
Content-ID: <AEE376727798434F84CF54E97B027533@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/5/2021 7:04 PM, Darrick J. Wong wrote:
<snip>
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index dc354db22ef9..9b3dac916f22 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1043,6 +1043,7 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>   	if (!ti)
>>   		goto out;
>>   	if (!ti->type->dax_copy_from_iter) {
>> +		WARN_ON(mode == DAX_OP_RECOVERY);
>>   		ret = copy_from_iter(addr, bytes, i);
>>   		goto out;
>>   	}
>> @@ -1067,6 +1068,7 @@ static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>   	if (!ti)
>>   		goto out;
>>   	if (!ti->type->dax_copy_to_iter) {
>> +		WARN_ON(mode == DAX_OP_RECOVERY);
> 
> Maybe just return -EOPNOTSUPP here?
> 
> Warnings are kinda loud.
> 

Indeed.  Looks like the
   "if (!ti->type->dax_copy_to_iter) {"
clause was to allow mixed dax targets in dm, such as dcss, fuse and
virtio_fs targets. These targets either don't export
.dax_copy_from/to_iter, or don't need to.
And their .dax_direct_access don't check poison, and can't repair
poison anyway.

I think these targets may safely ignore the flag.  However, returning
-EOPNOTSUPP is helpful to catch future bug, such as someone add a
method to detect poison, but didn't add a method to clear poison, in
that case, we fail the call.

Dan, do you have a preference?

thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

