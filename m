Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46746C433F5
	for <dm-devel@archiver.kernel.org>; Sun,  6 Feb 2022 08:13:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-3IMh2tQ1N9-f_k0K4YsWvQ-1; Sun, 06 Feb 2022 03:13:06 -0500
X-MC-Unique: 3IMh2tQ1N9-f_k0K4YsWvQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 582CE1091DA0;
	Sun,  6 Feb 2022 08:13:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45F8110589C3;
	Sun,  6 Feb 2022 08:12:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 472414BB7C;
	Sun,  6 Feb 2022 08:12:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21689VIM018269 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Feb 2022 03:09:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F976401E2D; Sun,  6 Feb 2022 08:09:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A804401E2C
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:09:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE2DB8032EB
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 08:09:30 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-627-zwov9AZ4Pg668xvehSMIQQ-1; Sun, 06 Feb 2022 03:09:28 -0500
X-MC-Unique: zwov9AZ4Pg668xvehSMIQQ-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	2167Co1n027523; Sun, 6 Feb 2022 08:08:56 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e1h4b2jjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:08:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21685ehS134146;
	Sun, 6 Feb 2022 08:08:43 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
	by userp3030.oracle.com with ESMTP id 3e1ebv44dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Feb 2022 08:08:43 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BY5PR10MB3873.namprd10.prod.outlook.com (2603:10b6:a03:1b0::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11;
	Sun, 6 Feb 2022 08:08:40 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4951.018;
	Sun, 6 Feb 2022 08:08:39 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v5 5/7] pmem: add pmem_recovery_write() dax op
Thread-Index: AQHYFI6Ncz9/iVrSZU2vUZQLJAd6lqyC9biAgANCqYA=
Date: Sun, 6 Feb 2022 08:08:39 +0000
Message-ID: <06c5595c-45b3-a58b-74f9-6d2956d61113@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-6-jane.chu@oracle.com>
	<CAPcyv4ip=JZXcQkDOtjcSsD=y7wRJEA0GdYSbx9+UrGCg8BNvQ@mail.gmail.com>
In-Reply-To: <CAPcyv4ip=JZXcQkDOtjcSsD=y7wRJEA0GdYSbx9+UrGCg8BNvQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2c0dd95-567d-4f0d-71e7-08d9e947e254
x-ms-traffictypediagnostic: BY5PR10MB3873:EE_
x-microsoft-antispam-prvs: <BY5PR10MB3873E62F167F2953C9740D6FF32B9@BY5PR10MB3873.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lDxd7c2FeMWEz3+W6T+QBNsvi47w04R1N2FTESSvnVF69wCg3HF/M9Z49ECke9V9uv7XE4qJbimQHmdmzS3CijnE2xQuSibXLWEBIxzqpkQ/vlBah7PreRq73hY+rd9+XQwZBd2/3dFwoEPRffclWwvBg4ruHD/5yHg1rnoCtKqaDq/lQSw3WIqC0Y2S+kUT4wdp04jeChHR+qQ/Jz/AuasIYS4gtgkRfZFW9eAnxkJMfPe8UIO7D8YU8mhw5oPvIA+DjL5vQqLOXuZKMLe/VVGr3u9dVzv+rUdZ+Z2TEW9ap5VPpDErTTWMZGAkDnjP8FgQqLEZ48/39eaCHlq16mQULwiwEOnwW2ZRpbYpKl1KxJ5pPj3H0YS6uWUUmOKDADrDgL3RQWF7jgaBpZflaEWlDs4nTKBruAyDyYHGgyHyJObAia81iSyeIa1/xcoYgjudET7luJIcinrXgegASYx7yzku2h9tJuMRJL3oU4+AT/pK6/ocbpTpFXsl4NV0U/MaFydTL6VsTfCmhTBrNFChFNffwlCW687rFp2pVAptya7rdzKTUL8Pzs6XBSSZbLNN/A+5DJuNu3e0uy8YSyzHbfP3ucIDcbW8e4N6gTGArQXuQskr9qn6/MfVVF1zhEbBae83HMDSpq3OLGfSCevnFKW3Alpp4ItBDmPI5KtkE6QLngh3eLvbbqLjTnmp2H1jX6+FGopaD4e/lTcWFeSawa+obi4niwz6zrdhrjHfq3v/QCWR3gQ1OoQcn9oKCgps+Gvlw2NB0S15bMEWbQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(38100700002)(186003)(76116006)(66476007)(66946007)(5660300002)(66556008)(66446008)(64756008)(26005)(7416002)(4326008)(83380400001)(8936002)(8676002)(44832011)(54906003)(36756003)(53546011)(508600001)(31696002)(6916009)(6512007)(71200400001)(122000001)(38070700005)(6486002)(2906002)(2616005)(86362001)(6506007)(31686004)(316002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OERPSmd4VnBZSEVFdFQzSHNDQVlBNEdySDE4bGJxK0ROU3ZZUE1rYWlhK2tt?=
	=?utf-8?B?ek1ESHJTT2NKNnZudUVTbXoxSGJHWDI1RmMzUm1wVDkzbjBFM2p5cVpCbEJQ?=
	=?utf-8?B?NkZRS3VYUmdoYWZNQjF2K0ZXdmJQcWRBUWl5MlNDeVRVMEpVQ0xNTUlwWE5E?=
	=?utf-8?B?THRVZit0d0ZkTHA5ZDRHLzMwd0w0d1Z5V3NXc3d6eVhuR3BKclpzMGorZ2wz?=
	=?utf-8?B?RCtRSFVibDVBbDZlemVVb1JGR0swNFd6MDJwWWtzK2NXMnAxNVRsREIyaXJs?=
	=?utf-8?B?QllyMWo0d3NQY05veVQ4Z1VKZmV2aEM0OEErVm9tNDB5clVXL0Z3c0IrQ0VS?=
	=?utf-8?B?WXJ6NnUyMzBKM0NaUXBZbGhBcStLUnVoMVlxd0RsaFpEell3RDJUaFZ2SjRx?=
	=?utf-8?B?K1JzY1AvUzZxUVBRTkhoZ3FYSE82REZNR0FQRGV2MEVNODUzN01JeVJ1NEhP?=
	=?utf-8?B?QUxFZktwSGJMdzNqRU04cWh4OWJveVRqeXhGNGJkWUtCaW5FclNJOENDa1Vn?=
	=?utf-8?B?aUtyZGhOYUhvQlNwUUtjMU9tTkY3SzM0OXR0RXFJVzRiZDhTeGRoNnVTQnhu?=
	=?utf-8?B?dlpUbmtqYWJ0Z0krME5sOVhwRUZoNlZ4MUFKTzFjQjB4ZEdWNi9iZ0RhdnVS?=
	=?utf-8?B?aVIwbVlhaDNKL2pxb0gzb3Z4eFp2Y0dxMEc4a3VQWkF1ZzRjVjRBSTBHTFFT?=
	=?utf-8?B?bnZ6SkEySWFwMEVYMEhBcG95QUk2QkRnTFl5dUtCd1ZBQXNEUUpTRHJyVmRH?=
	=?utf-8?B?V0UyamRsaHpNbU93bnNCK2tjenlwZmFxcXJPZXhMQ0pLR3JxVmRiL1NaUjEr?=
	=?utf-8?B?cjVrNVdSSDBsQldSbEhFZjFsZWxXcFhGejhQZUpuWThJMDNGYUhCVEl6d0pH?=
	=?utf-8?B?MzFMcWZWREZtZ0dlMFphcTBPcEJZU0Joci9jQm1LNVkxTUhUTTFSK0tqY0Nq?=
	=?utf-8?B?UDFJUTUrM2NQMWlmanNKaXoyWlpLa2d6cW9vTTVGaUFub3V4aFJhVnB2ZGZY?=
	=?utf-8?B?UEYzL1hSTjduWnNWMDIrRVAxQUlCZ0JaNEgrVHU2SlZyZU9CTW9SVmIyR2Qr?=
	=?utf-8?B?MkJoWUIveGdjeWpTdHMxcG9hNmpwOTRGc2J4QlA3WVdHLzFsRERZQ0hGbUMw?=
	=?utf-8?B?c1dnbWRGMUJ4a3Zicmdua2NPZlJpNVUvcEdyVlZwbExxaTFyUTVvZUNkWFl3?=
	=?utf-8?B?Yklwb1B0R1Z4bEUzWnV5QkNXUElpNXF6aEx6MVJzc0ZpOXg4dmEzbHJhMERN?=
	=?utf-8?B?OUFMSGtjT01PejlBTVZBRnRQNWR2Y2E3WHl6cnJtSXU0VndsTlB4REJ3U2dI?=
	=?utf-8?B?WG9Ua0Q4WDRIQU5zaUdHZ2c5RTFWalRHbmt6bjA3di9QUDZETHY1VnhVU08y?=
	=?utf-8?B?Yy8rSGxTQ1hwbVJ0dTVoWERnb09EYi9iV2MwdHV6bElsVHpNRkc4aytKYlh4?=
	=?utf-8?B?WWNTSys3Z0hOeUpWZVJTa0lmMG8zRFAzT3RMcFNZZHdJT28xNi91aHpNY1Fl?=
	=?utf-8?B?YldjVXhCTzU0Zm5uWEVhT2lGL1lTWGR4bk93VEVCSnl1c2F4NFhhanhDdnpp?=
	=?utf-8?B?aytQWjkwbDNLeDZRdjREZmJBV0toUHI2dUVlK0ttbHFQMk5rQWFoUE15c1Jq?=
	=?utf-8?B?UXpEWjBKdU9CZFdIK2I0Z2RucTNqekdnSmVNNGdoTVhwVXdxQ1RPcTlTOGN4?=
	=?utf-8?B?QUM5elh6YnZERTdUbXlTNmRDMTk1eXgrSmtDZ1hHWjdlVGJ6ZXE4NE85M0NH?=
	=?utf-8?B?L0N1M0xwZU12OWRxOTRMWVJHNGwxc0tIdFl2ZGpteWhzQ1lod2ZaTC9rTHV1?=
	=?utf-8?B?cnE1WVdNcFNuK1VEUkxuQXZFVGZyOVAxNVhLVm94RHNrVmd3Q0pCY2Zia1pH?=
	=?utf-8?B?U2dzSmdFK09uSTJZZzl3NmI3djFucEhJazZrNURQSEVKaDRIYTNUaXY4a3lP?=
	=?utf-8?B?aFB1Q045eEM0QUc3V1oza1IrSjRGVTgxdXhzZXNZcUpkZVlUaXhoVlh6YnFX?=
	=?utf-8?B?MGVYcHVSNjV4akxqZ1BvNjkrZVhhMXlBTVdMZzlUWGtwVkFTNk5DL2hGcEhI?=
	=?utf-8?B?eUJ1MDNZang0dmtGeVJXc2FGV0ZxT0xqSU9vM0JaZVJDcEl2L2YzZ2dUNy9F?=
	=?utf-8?B?Ny9KS1Q3V2luL3hNUzYxUGtXUzM3NVpUd0xTN3VDR3RGTHRyMDYvVTQ1eVNL?=
	=?utf-8?B?Vmc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c0dd95-567d-4f0d-71e7-08d9e947e254
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2022 08:08:39.7676 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pOdIJrQRPp62xW6K+oLc2PldhLTAotVVCzD8f+YD4zTcp/IK1f3arRwzBZVxKipCzh1XznyFSJw22SRhHxa5Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10249
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 suspectscore=0
	mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202060059
X-Proofpoint-GUID: V6P1lQQa9iPUl6bNxhWhKYn9Do5n0C3Y
X-Proofpoint-ORIG-GUID: V6P1lQQa9iPUl6bNxhWhKYn9Do5n0C3Y
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21689VIM018269
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
Subject: Re: [dm-devel] [PATCH v5 5/7] pmem: add pmem_recovery_write() dax op
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
Content-ID: <683FFC8FE6CB0D428CF89FA9B3B5797A@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/2022 10:21 PM, Dan Williams wrote:
> On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> pmem_recovery_write() consists of clearing poison via DSM,
>> clearing page HWPoison bit, re-state _PAGE_PRESENT bit,
>> cacheflush, write, and finally clearing bad-block record.
>>
>> A competing pread thread is held off during recovery write
>> by the presence of bad-block record. A competing recovery_write
>> thread is serialized by a lock.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   drivers/nvdimm/pmem.c | 82 +++++++++++++++++++++++++++++++++++++++----
>>   drivers/nvdimm/pmem.h |  1 +
>>   2 files changed, 77 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 638e64681db9..f2d6b34d48de 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -69,6 +69,14 @@ static void hwpoison_clear(struct pmem_device *pmem,
>>          }
>>   }
>>
>> +static void pmem_clear_badblocks(struct pmem_device *pmem, sector_t sector,
>> +                               long cleared_blks)
>> +{
>> +       badblocks_clear(&pmem->bb, sector, cleared_blks);
>> +       if (pmem->bb_state)
>> +               sysfs_notify_dirent(pmem->bb_state);
>> +}
>> +
>>   static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
>>                  phys_addr_t offset, unsigned int len)
>>   {
>> @@ -88,9 +96,7 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
>>                  dev_dbg(dev, "%#llx clear %ld sector%s\n",
>>                                  (unsigned long long) sector, cleared,
>>                                  cleared > 1 ? "s" : "");
>> -               badblocks_clear(&pmem->bb, sector, cleared);
>> -               if (pmem->bb_state)
>> -                       sysfs_notify_dirent(pmem->bb_state);
>> +               pmem_clear_badblocks(pmem, sector, cleared);
>>          }
>>
>>          arch_invalidate_pmem(pmem->virt_addr + offset, len);
>> @@ -257,10 +263,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>>   __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>>                  long nr_pages, void **kaddr, pfn_t *pfn)
>>   {
>> +       bool bad_pmem;
>> +       bool do_recovery = false;
>>          resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>>
>> -       if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> -                                       PFN_PHYS(nr_pages))))
>> +       bad_pmem = is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> +                               PFN_PHYS(nr_pages));
>> +       if (bad_pmem && kaddr)
>> +               do_recovery = dax_recovery_started(pmem->dax_dev, kaddr);
>> +       if (bad_pmem && !do_recovery)
>>                  return -EIO;
>>
>>          if (kaddr)
>> @@ -301,10 +312,68 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>>          return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
>>   }
>>
>> +/*
>> + * The recovery write thread started out as a normal pwrite thread and
>> + * when the filesystem was told about potential media error in the
>> + * range, filesystem turns the normal pwrite to a dax_recovery_write.
>> + *
>> + * The recovery write consists of clearing poison via DSM, clearing page
>> + * HWPoison bit, reenable page-wide read-write permission, flush the
>> + * caches and finally write.  A competing pread thread needs to be held
>> + * off during the recovery process since data read back might not be valid.
>> + * And that's achieved by placing the badblock records clearing after
>> + * the completion of the recovery write.
>> + *
>> + * Any competing recovery write thread needs to be serialized, and this is
>> + * done via pmem device level lock .recovery_lock.
>> + */
>>   static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
>>                  void *addr, size_t bytes, struct iov_iter *i)
>>   {
>> -       return 0;
>> +       size_t rc, len, off;
>> +       phys_addr_t pmem_off;
>> +       struct pmem_device *pmem = dax_get_private(dax_dev);
>> +       struct device *dev = pmem->bb.dev;
>> +       sector_t sector;
>> +       long cleared, cleared_blk;
>> +
>> +       mutex_lock(&pmem->recovery_lock);
>> +
>> +       /* If no poison found in the range, go ahead with write */
>> +       off = (unsigned long)addr & ~PAGE_MASK;
>> +       len = PFN_PHYS(PFN_UP(off + bytes));
>> +       if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
>> +               rc = _copy_from_iter_flushcache(addr, bytes, i);
>> +               goto write_done;
>> +       }
> 
> is_bad_pmem() takes a seqlock so it should be safe to move the
> recovery_lock below this point.

Okay, thanks!

> 
>> +
>> +       /* Not page-aligned range cannot be recovered */
>> +       if (off || !(PAGE_ALIGNED(bytes))) {
>> +               dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
>> +                       addr, bytes);
> 
> fs/dax.c will prevent this from happening, right? It seems like an
> upper layer bug if we get this far into the recovery process without
> checking if a full page is being overwritten.

Yes, at the start of each dax_iomap_iter, the buffer is page aligned. 
However, the underlying dax_copy_from_iter is allowed to return partial 
results, causing the subsequent 'while' loop within dax_iomap_iter to 
continue at not page aligned address. I ran into the situation when I 
played around dax_copy_from_iter, not sure in reality, partial result is 
legitimate, just thought to issue a warning should the situation happen.

> 
>> +               rc = (size_t) -EIO;
>> +               goto write_done;
>> +       }
>> +
>> +       pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>> +       sector = (pmem_off - pmem->data_offset) / 512;
>> +       cleared = nvdimm_clear_poison(dev, pmem->phys_addr + pmem_off, len);
>> +       cleared_blk = cleared / 512;
>> +       if (cleared_blk > 0) {
>> +               hwpoison_clear(pmem, pmem->phys_addr + pmem_off, cleared);
>> +       } else {
>> +               dev_warn(dev, "pmem_recovery_write: cleared_blk: %ld\n",
>> +                       cleared_blk);
>> +               rc = (size_t) -EIO;
>> +               goto write_done;
>> +       }
>> +       arch_invalidate_pmem(pmem->virt_addr + pmem_off, bytes);
>> +       rc = _copy_from_iter_flushcache(addr, bytes, i);
>> +       pmem_clear_badblocks(pmem, sector, cleared_blk);
> 
> This duplicates pmem_clear_poison() can more code be shared between
> the 2 functions?

I'll look into refactoring pmem_clear_poison().
> 
> 
>> +
>> +write_done:
>> +       mutex_unlock(&pmem->recovery_lock);
>> +       return rc;
>>   }
>>
>>   static const struct dax_operations pmem_dax_ops = {
>> @@ -495,6 +564,7 @@ static int pmem_attach_disk(struct device *dev,
>>                  goto out_cleanup_dax;
>>          dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
>>          set_dax_recovery(dax_dev);
>> +       mutex_init(&pmem->recovery_lock);
>>          pmem->dax_dev = dax_dev;
>>
>>          rc = device_add_disk(dev, disk, pmem_attribute_groups);
>> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
>> index 59cfe13ea8a8..971bff7552d6 100644
>> --- a/drivers/nvdimm/pmem.h
>> +++ b/drivers/nvdimm/pmem.h
>> @@ -24,6 +24,7 @@ struct pmem_device {
>>          struct dax_device       *dax_dev;
>>          struct gendisk          *disk;
>>          struct dev_pagemap      pgmap;
>> +       struct mutex            recovery_lock;
>>   };
>>
>>   long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>> --
>> 2.18.4
>>

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

