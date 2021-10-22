Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFCDC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 00:58:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2A50610FF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 00:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F2A50610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-c7gCz3QwP1KIjaCeeC2V8g-1; Thu, 21 Oct 2021 20:58:33 -0400
X-MC-Unique: c7gCz3QwP1KIjaCeeC2V8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FAB01808317;
	Fri, 22 Oct 2021 00:58:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 245315BAFB;
	Fri, 22 Oct 2021 00:58:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A07A1806D04;
	Fri, 22 Oct 2021 00:58:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19M0wQEm020991 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 20:58:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EB0B72166B2D; Fri, 22 Oct 2021 00:58:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E476D2166B25
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 00:58:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10EBC899EC1
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 00:58:23 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-418-vSNPgQ18Ow650ouio3m3pg-1; Thu, 21 Oct 2021 20:58:19 -0400
X-MC-Unique: vSNPgQ18Ow650ouio3m3pg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19LNig9I019201; Fri, 22 Oct 2021 00:58:08 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqp2rddp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 00:58:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M0u2Fd009049;
	Fri, 22 Oct 2021 00:58:07 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
	by userp3020.oracle.com with ESMTP id 3br8gx11n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 00:58:07 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5533.namprd10.prod.outlook.com (2603:10b6:a03:3f7::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18;
	Fri, 22 Oct 2021 00:58:05 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.018;
	Fri, 22 Oct 2021 00:58:05 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH 5/6] dax,pmem: Add data recovery feature to
	pmem_copy_to/from_iter()
Thread-Index: AQHXxhBDZf3mWOFAa0+X1X7SVQR1/KvdUYMAgADiGQA=
Date: Fri, 22 Oct 2021 00:58:04 +0000
Message-ID: <7dc2445e-4cf0-307c-8ab6-48b886bcf34b@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-6-jane.chu@oracle.com>
	<YXFO8uCgIDoIqTgC@infradead.org>
In-Reply-To: <YXFO8uCgIDoIqTgC@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6d8d44b-407b-4b92-aa5e-08d994f70160
x-ms-traffictypediagnostic: SJ0PR10MB5533:
x-microsoft-antispam-prvs: <SJ0PR10MB55339D39C4EBCFDBA7017F0AF3809@SJ0PR10MB5533.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hOgi0DyGwbH35sv/oFAWMdNCy7O87RRueT7u3ksIQ48Ycx7HrFSu1Vn+cAhG6wCvskw4E95YHVKDGLF/98/67Z4hzlSKm7CF86JtDYUIr4qkGkpPEKPBgDAW11YUdQC+VRC9zBWwqvvYbPWuiUbi9JTQ1gYXs18sVmDM0RP1wzTmkhEOWpIMKAInvujPHi5zcFl8MoWrhyd/P94Mlbe4dR/1V8trXCf3LS9+jHDJ49ymVD3FVMcnzL9ypuiEfdNhgi5T8KyQynvUamBLU+6PLupMYBXv3g+Fas/QyGxoyWjM00/mxjmXFPftbxQo0/RZDwqycCzfzTgn/ungMI7ysfrMThvtvnyEP/dYjh1zGKet6BKyJ7XbK4l4TeitIpjh/T9MuDV1GXbm8vH4kGrmhpSf0RIsF6YurVA5Uhioh4pcTJTbHfHayz9/xfSUJX9JLMfS3PeHe39zwETzaZkLe4510zsVfHPSCj3T7E8422AJhm3byq6lCO08jfKP209UIlZmdAeuXmYrTYOV7oIhbgChRnxPLpyuRxhS0dtjdDDVCW0cL6oqus2xByI+Oe/iHmFzVUsnSDoHvO2mObYnHf7dSF8v6D2ZZRC2hcUUH9tHO/ukr+AYXcdwvwOLkVWAzUhueZty8z2/EQmhGj9U7uIYkB4u+dvZZndM5uwoNFNBGLma9vDNzrbJuvp0+rFUoEIQ/ZOcOlCjJ+L5bnhCfNtdVPVFe46vFplG/Hzkeg5Gs2zNtQOT0qXEAsHkbKHgI8R72P6AOzfG91OHzs8ipA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(64756008)(6506007)(4326008)(66446008)(66946007)(66476007)(53546011)(66556008)(71200400001)(186003)(6512007)(2616005)(26005)(4744005)(122000001)(44832011)(508600001)(38100700002)(54906003)(6486002)(5660300002)(38070700005)(86362001)(83380400001)(316002)(2906002)(31696002)(8936002)(7416002)(31686004)(76116006)(6916009)(8676002)(36756003)(91956017)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzZaWXNlUkw3cFp5UkxGZUtVZ1VWaEhnZ21lMWUrKyt6WFEwS012ZkVqcU9q?=
	=?utf-8?B?amc4ZFhVMzQ1Y3Y4RnlsSjN0Q3h3eW9ML05lelN1c2hsU2dkNXd1STA0Y0Ev?=
	=?utf-8?B?NGgvd1FmT2hmNkdqR2MvTCtKYUhndDNwWEloMXpmNXJzOGpUOFhqSWFJK0tl?=
	=?utf-8?B?WVdXUTdtb1NrR3k0SXRteG55aXNHUjhPTm1YQmc2UVBOdm9GbUF0M3JpTGN0?=
	=?utf-8?B?ZDQwNG9DN2Fjc1NHMlkySWZER3hMZk1yS2RJeTQrOVRDd2RoZ3lvYklsbXBl?=
	=?utf-8?B?NmYzV3I2RWt0STI4QUlySG9xbVB0QTQ2b0d6K2ZwOFY3SUx0NlBvMDFzaDRy?=
	=?utf-8?B?a2xUMTJJejdyMENmSEVVZ2ROOXhidDNqOW5RMUFVbXQrc1poSGVBd2l5cWti?=
	=?utf-8?B?RWZhTFV0N0g1djFwNnA3Y1V0aDRFSzdYYU40ZTJwODJCZmo3WHJhSEhNanM2?=
	=?utf-8?B?RnY5RFJXa3o0VG9Fc2ZiK3ZSSitMOTB5YnRUVFdObU80eXB2ajFVWlJCaHNY?=
	=?utf-8?B?Z0s3dzkxSTJPNVVmT3JTNjdKUytwZEp5TURwZERDLzlBaXRlYnppdFFkZDEr?=
	=?utf-8?B?MjBpV1RMK0tkZXNWS2gwVEtmZ1QwL3Z1Z0FrTnRKWmh4S0lKOFpvUkJHYzJx?=
	=?utf-8?B?V0tQMGVremJTQ2xUVnpKSHZYNUJFUTlUTVpOc0VzTWNyQ1pMUFpVRCtkRWRI?=
	=?utf-8?B?dzBnOHlqYTQvbTY3VkduQlVSZzhTVk5sOXFWNUZzNm5yejN3djRGQ3l3blZO?=
	=?utf-8?B?Z0hlZm9iS2JJZTI1ZEVKUjh1Sk5kWkxRdHp1T2VoNEZDOFp2eEpueTIxNU9u?=
	=?utf-8?B?Z1R1d2loSWphQWplaGVYNTgvTVdOTnZaM050Zk9vamROS1RhSnEwczcvdC9n?=
	=?utf-8?B?MVVjSmN1RzVhMXFUU05nV2h5UlkxWjFyMXczTzcyZ3ZKRUdjNDFRdjN4Znc5?=
	=?utf-8?B?Vjg1dlN1RUZZSXlLVTFRT2czVCtBNW1mUUZ0YmUvaEFDMUV1Q1kycDllUFhX?=
	=?utf-8?B?SkFBeUo2Sy9OWFFxL1RRcFpXbXlmOFFYNHY4OUxEdndNTG1jNThoeitHbGZH?=
	=?utf-8?B?TXZCRVJwck1UQ0o1UXJwUjVwT3FGZlVKaWRJQnA3VkRKRURLZkI1WkRKOTlw?=
	=?utf-8?B?VVpaNllyNGk0Y1E2ME5CUFpZSDRrV1VTQkFMcTJsYVFuTkY3MXZNcGNubjF4?=
	=?utf-8?B?ZUZnc2FKdjdYOWsxajBGcWljR0FOL2pCRWV3Mkg1bUVBbWdkaGZpUGF1L210?=
	=?utf-8?B?M1FpTXp5UUxWS1N5L2pMK1BBS1VkOFVBdjZHSE1taHhMWk9ZSWxvUXBPbjdX?=
	=?utf-8?B?c0VLaTFPZ3hHRzc0QWYwVHNCTExNemJmeUMvRzF6cHNscGtrRUVuMDFKMmRz?=
	=?utf-8?B?VXNEN2ZrRnkwalZST1RzOVBFdWJMaEVMOGVha2l2NU5YTGdRK0h4ZDFJWC9i?=
	=?utf-8?B?aFk1ZFlneFNESkRnbHlITGEyOXo0Q1IzSkNMOFJTdG5wSUFZbWphOVBoQis1?=
	=?utf-8?B?L0t6NEtxQm5POUxOMjVaRVIzQUlROVgza2NMNlFFMHVPb0tZa00vMUZSUmdM?=
	=?utf-8?B?cXZxS09RNGYzeFlkbGVmR2FKSXlwaWlLRjh1M3lQT0plZ1pOTXRiRFJnK0J2?=
	=?utf-8?B?WCtmYnFTZFZNQ25MY1BVdnhwT1FlZ2JkL04rWWREK1lYV2FLNU5jekxSakVW?=
	=?utf-8?B?Q0VrTVB2US9sTFNzcjl2cExKYW9DVkEzSk1aQnhpNlNZMlFJeG9WVmtKZVl5?=
	=?utf-8?B?RzFuZGNWR1VSTDFsQnVMbW9PT3JMOUdHNi9BWCtqOHpVTzBoc1oxSVZ1clFK?=
	=?utf-8?B?S0VIZ3N3TVNvRHh6QzI4Q25WSW0rOTYxOHp6ZGx4TTE5MDBYeU1CekhJUlBN?=
	=?utf-8?B?cjBUMldsL1BvaktJSnZJSy9rNlk5ME9laFNFV1FsdDMreUhCUGxlMXlCTnN2?=
	=?utf-8?Q?AexZfnBC4Rg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d8d44b-407b-4b92-aa5e-08d994f70160
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 00:58:04.9764 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220003
X-Proofpoint-ORIG-GUID: Ij43I3ZdzYUBLXJy0ohdiKNp1otPnKOt
X-Proofpoint-GUID: Ij43I3ZdzYUBLXJy0ohdiKNp1otPnKOt
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19M0wQEm020991
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
Subject: Re: [dm-devel] [PATCH 5/6] dax,
 pmem: Add data recovery feature to pmem_copy_to/from_iter()
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
Content-ID: <78623CBF5E60C147ABCF78F18FF23386@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 4:28 AM, Christoph Hellwig wrote:
>> +	if (flags & DAXDEV_F_RECOVERY) {
>> +		lead_off = (unsigned long)addr & ~PAGE_MASK;
>> +		len = PFN_PHYS(PFN_UP(lead_off + bytes));
>> +		if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
>> +			if (lead_off || !(PAGE_ALIGNED(bytes))) {
>> +				dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
>> +					addr, bytes);
>> +				return (size_t) -EIO;
>> +			}
>> +			pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>> +			if (pmem_clear_poison(pmem, pmem_off, bytes) !=
>> +					BLK_STS_OK)
>> +				return (size_t) -EIO;
>> +		}
> 
> Shouldn't this just go down in a separe ->clear_poison operation
> to make the whole thing a little easier to follow?
> 

Do you mean to lift or refactor the above to a helper function so as
to improve the readability of the code?  I can do that, just to confirm.
On the same note, would you prefer to refactor the read path as well?

thanks!
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

