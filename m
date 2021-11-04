Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED14C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:18:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4BDE8610FD
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:18:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4BDE8610FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-Vdw1AamwOAq8ix8U8NVhMA-1; Fri, 05 Nov 2021 09:18:18 -0400
X-MC-Unique: Vdw1AamwOAq8ix8U8NVhMA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74BCB7FE81;
	Fri,  5 Nov 2021 13:18:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 567AB19EF9;
	Fri,  5 Nov 2021 13:18:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DC271806D04;
	Fri,  5 Nov 2021 13:18:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A49S4VY020254 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 05:28:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7CA8951DC; Thu,  4 Nov 2021 09:28:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33C4851E3
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 09:28:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45290800159
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 09:28:01 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
	(mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-191-TYycK5lpOly2ScebIKVGfA-1; Thu, 04 Nov 2021 05:27:55 -0400
X-MC-Unique: TYycK5lpOly2ScebIKVGfA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MW3PR12MB4459.namprd12.prod.outlook.com (2603:10b6:303:56::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Thu, 4 Nov 2021 09:27:51 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4649.022;
	Thu, 4 Nov 2021 09:27:51 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
Thread-Index: AQHX0UfJUBDssfv+ckmT1a3v6/33Gavy9LOAgAAlMQA=
Date: Thu, 4 Nov 2021 09:27:50 +0000
Message-ID: <661bcadd-a030-4a72-81ae-ef15080f0241@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104071439.GA21927@lst.de>
In-Reply-To: <20211104071439.GA21927@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98bbf12c-4ee1-4f43-124a-08d99f755fba
x-ms-traffictypediagnostic: MW3PR12MB4459:
x-microsoft-antispam-prvs: <MW3PR12MB4459BE38997B6B1FA77FBFADA38D9@MW3PR12MB4459.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: yUuJ3SFWQxyY+DVgIUZjc9qGr9edCBohngI6/o4rEI6BR2MUHYgb1dq3iiGinaoX/kRNpHdn2AmOE8uz0x9bu7vvTRw71w2tv0rYE0L/UvtDSYGxcQcPKYLh6b14mMYD2QBUJqbkaXI0VXOoWHYQmcB1URlZ3FhMoZ2NlucphDBpadRn+LcU05J9DW3FeI1HUZaIlFoxsc+MN4g6KBjylX6dYh5/VJxv/e58otQ7wGWJBlJn42H5yxwxDLwb4LN3p5tny/n5nOMSNYBzk2jf0kIeUhId9JD6xO1vh9siYxSnxcSURHRiq89z8mhXfotJRCtb9QENVxyTxgoipKYTohnjJM8EG5q4ZYZNZNz6XBoWRGObJhqa08ceZjGp31gR7GoP3kC2h4ERIXZCW7Q3VJ2aSi29kc+jGksRS+iuaCqPAmUUQTltFgH0+3UnvhxBDaaFni8blGsx0MWglD61YaqFU4TS/k+rKyRCQJuKBUMd/ODSW3+fKRCRodb/VcSz52Kec/UUyRXnzaNbFHXfrMRw6X4n+P/tTGrR8f8C5A6v+iukzlFLXLB7V+5ihfblhPSmLMcmmIAyUyyD0TDKDgDrCb1fXBuVUpXPluHTU/wTXAq9j4paApcxZgkrj5OOudZL49RHQJAdJu5zbiSupCYYx3g3HplwpOJBzyoz2N3oaZUSfxN9ugJs8r880ZucZxDzakMha0l8PTBaOsL+6KfoHFI6Zh4OoqM0qSKZ3qgu5RbrfMexi/ZDtytExmi+DAQJg24NGvOovfKkNulZ/g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(54906003)(6512007)(71200400001)(7406005)(2906002)(66946007)(66476007)(38070700005)(186003)(83380400001)(7416002)(5660300002)(66556008)(64756008)(66446008)(91956017)(316002)(508600001)(6486002)(76116006)(8676002)(53546011)(6506007)(31686004)(4326008)(8936002)(122000001)(107886003)(2616005)(31696002)(86362001)(4744005)(36756003)(6916009)(38100700002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmJST3dsZU9qekk5OWFZYVRUMDlEUUVic3dzNUdHRkw0dVN6UjBvZlJ1K1FT?=
	=?utf-8?B?RXo5cU5pYVVSNnBXTGFHWHhyWC9kZjU3N3hyRzNIV3VFTVd3VEY1OHVDdmtt?=
	=?utf-8?B?YVMrb1hacm9FTjd5WWpDbzdLVnR5U1BSbmw1SjhIV0ZIVVRhaTRLY042RUJy?=
	=?utf-8?B?M1hYQ0ZZRXI0ak1PWEJ1bWE0WCsxd3dJMkczUFp2aGxpSi9TdDBoTlRkM0FW?=
	=?utf-8?B?K3gyTWNUdzJrdzRlSTdSTzJOYTRlUGVBSG9LdmloejkrZGNkTXBlaFJ3ODRk?=
	=?utf-8?B?RVJKU0J6TnVJS2ZvK01BejdUU3QydHNUWkozYjZIQjlINXp5VUR6UTlNeFJN?=
	=?utf-8?B?QjNLZk11OUIxR05RUXN4d3BlQ3ZOZ0xrR1JQQldiNTVkRHdOc3lrUUFEelg2?=
	=?utf-8?B?YjRUb3VrN0lxTlFyMHEvWTUxLyswZ0hvQkFGRFl6QlppMTFBajZ2bm9jSUh4?=
	=?utf-8?B?QkN2cC9NaVJ2STVHWEs3bEZQcmNwU21qeTNxNjd6SEZFK3ZRM2tGa1JDVW10?=
	=?utf-8?B?UzZFTXY3UmErSFNjNEprdU5nbnZ0YmxETjN0NUw1OFpVZU5yd2lWbFhNN3c1?=
	=?utf-8?B?TUxSckF4Mi85RlpTbEQ4dVhCcWtVUURLa1RVYmQyNkxJRVBMSXRBV3QwVTgy?=
	=?utf-8?B?SzM1ZWhPbW5aN0k3enNVSmJiRjUwTEJ0bUZTVGV2NnBmRUJwemlTSzcwR0s0?=
	=?utf-8?B?RUxpdlQ4UDhzOHBDaVdwS3NKblZLdDZHSCsrWUlXTGx1WGF5a1ZRWXhIcmRQ?=
	=?utf-8?B?ZCt1dHd3SktkUzUrYlQxbHQycWM3N2Nib0crRUdRb0pxWFFxMFI1VitiWGxC?=
	=?utf-8?B?Yi85V1F3RlhDdkVxS2JPb01PZXBTV2V2SHpqcDQxQnBydGt5QmkxV0UxUW9i?=
	=?utf-8?B?R1RyZGRsM2dzTlo3YStZZWQxbm11SC9RMWlVVU9Kd2x4QmJDU2JJMGgrVGZu?=
	=?utf-8?B?UWRtL0VSeWJQdWdJVDhTRXpSYnJsQ0NRY1VzYkhtbHRWempZdmFIV0gzVlFV?=
	=?utf-8?B?WjNwNWtyTG9GRVhQRUMwdVdlVG1icVdRUHVRYzNjaGpZZjI2Z3dMa3hXcTJp?=
	=?utf-8?B?TXhBSmsrMzlmb0gzTEpnZnFqV0dHa0hOUnlDcWFUN3dFazI3RVZiTkVwcERV?=
	=?utf-8?B?K2xXclhmeloxS2ZWRk9zRld6bHVBcDlSVUdjTjBtZ1NOQ3prVWorYmNycTVI?=
	=?utf-8?B?RXhlTUFGOUlkK01hUHV3Y04vM21EUFZ3bS9Qbzl5L1QzdWo2d0dnVlFIbjh4?=
	=?utf-8?B?M1lYclJialBqeFdhbFhMV2IxQ3lyRjJjeHg0MkIzYmtCaDl4YTRMOHcvdHVB?=
	=?utf-8?B?TTJqU2hSWUIvczIrOFdCUmRENDZYeGZHVGpqWUYrM09LUU1lRTVIVVJHUExr?=
	=?utf-8?B?NXVlMGF2WHNsZDhJUXIzQjZXVDBqQXhpVWZEYWZSVUpReXNkTjJ1Sktvd2lY?=
	=?utf-8?B?L0hNNW5ydTR5LzlaV3ZKU2lLTlVyaWhZQ1lYdVRWQjc0akI4TFZnVXd4V2Np?=
	=?utf-8?B?SkdYN1llV0dLS3dtN1hjRmdlZnZ3cTFrQXpzb0U2dDVqYlc5WG5oWmtXT2c1?=
	=?utf-8?B?dGhTK0hySmRHZVNVbTNpWDk5K01nMTlGYkloUFFheFNGREVRMllNOFBTbkQ4?=
	=?utf-8?B?ZzlYSVoyOTM5V2t4Nnp3SEZqWTMrcSt5cUcyN28zT1lDSG1rMHUybjFXREZ6?=
	=?utf-8?B?M2t4bUFoWTBCamRUVWliR04rZS84K0wyVGdNK2U1QmhiSHIydllPcnZqdEpj?=
	=?utf-8?B?SWtiR0x2dUxCSVZyMVVVR1N5OXBwbWxLY05zckF4S3FQTjNzOSsyeEdVRHRs?=
	=?utf-8?B?NkFsOVFxa0RkcTREbnU5VUs5NDJFZVNXMk96MXA0RS9WNVpVZ052dlR5Snl0?=
	=?utf-8?B?bXM1STR2OEJFajhBalBoSHJUbkVvRjlrTldORDljYVdLc0NaeE00eWZwb0Vy?=
	=?utf-8?B?NTBod3N0bFZIbnVJV1R0TlZMNWswWkp1RUZjTTM1RDBjUlZTc1V0L1dxL2hF?=
	=?utf-8?B?Mjc3Slk5czBvOEpDMlJXcHI4TEZNdm5naGplSE5SUjVCdEtuamthRkkramhk?=
	=?utf-8?B?eVFCdEJRRlJPK21OQzhmUW9oNm5XeTI5Vm1OanVlbWM3c3FlQTMxcytneUYy?=
	=?utf-8?B?S1RITEozNEg0ZmM3VW9VUjVsTTd2WWVNS0hsM25VSFdsVjRlQmNoVHRmeFZW?=
	=?utf-8?B?clNZWGw3VnF0WGRKay9nNnBiY2x5ajBYaDVZRnRxMzZjVjBGa2Y1OSt0bEta?=
	=?utf-8?Q?+/b9t9uwkegYTRi/sGMO5l83UZc6IsmnE8gSXGHbwQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98bbf12c-4ee1-4f43-124a-08d99f755fba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 09:27:51.2077 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o8nQ5+lRSp4ubli4CdCcciY7LidSaFe1BKx5lA48eybEv9N7DUFAnuG9xy43f9xKGZ8B9qCvmyvLQrd3IYx9/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4459
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A49S4VY020254
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 05 Nov 2021 09:15:20 -0400
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"osandov@fb.com" <osandov@fb.com>, "agk@redhat.com" <agk@redhat.com>,
	"javier@javigon.com" <javier@javigon.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"sagi@grimberg.me" <sagi@grimberg.me>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"clm@fb.com" <clm@fb.com>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"jack@suse.com" <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
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
Content-ID: <868F285F0B210D4A90A01CBAF4B97880@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/4/2021 12:14 AM, Christoph Hellwig wrote:
> External email: Use caution opening links or attachments
> 
> 
> What is the actual use case here?
> 

One of the immediate use-case is to use this interface with XFS 
scrubbing infrastructure [1] (by replacing any SCSI calls e.g. sg_io() 
with BLKVERIFY ioctl() calls corresponding to REQ_OP_VERIFY) and 
eventually allow and extend other file systems to use it for scrubbing.

[1] man xfs_scrub :-
-x     Read all file data extents to look for disk errors.
               xfs_scrub will issue O_DIRECT reads to the block device
               directly.  If the block device is a SCSI disk, it will
               instead issue READ VERIFY commands directly to the disk.
               If media errors are found, the error report will include
               the disk offset, in bytes.  If the media errors affect a
               file, the report will also include the inode number and
               file offset, in bytes.  These actions will confirm that
               all file data blocks can be read from storage.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

