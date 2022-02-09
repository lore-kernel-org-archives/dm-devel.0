Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F247AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:19:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-s8cn9VNIOJqZmXUImeBeQg-1; Thu, 10 Feb 2022 03:18:33 -0500
X-MC-Unique: s8cn9VNIOJqZmXUImeBeQg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEF2F1091DA1;
	Thu, 10 Feb 2022 08:18:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BC857AB5A;
	Thu, 10 Feb 2022 08:18:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A4BD94BB7C;
	Thu, 10 Feb 2022 08:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2198ibCL019512 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 03:44:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AB90C40885AC; Wed,  9 Feb 2022 08:44:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A650D40885A0
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:44:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DDD5811E7A
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:44:37 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
	(mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-37-Yxu2EBfSN063RkTcDgKYCg-1; Wed, 09 Feb 2022 03:44:36 -0500
X-MC-Unique: Yxu2EBfSN063RkTcDgKYCg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by DM6PR12MB2777.namprd12.prod.outlook.com (2603:10b6:5:51::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Wed, 9 Feb 2022 08:44:33 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.019;
	Wed, 9 Feb 2022 08:44:33 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"haris.iqbal@ionos.com" <haris.iqbal@ionos.com>, "jinpu.wang@ionos.com"
	<jinpu.wang@ionos.com>, "manoj@linux.ibm.com" <manoj@linux.ibm.com>,
	"mrochs@linux.ibm.com" <mrochs@linux.ibm.com>, "ukrishn@linux.ibm.com"
	<ukrishn@linux.ibm.com>
Thread-Topic: [PATCH 3/7] rnbd: drop WRITE_SAME support
Thread-Index: AQHYHY8UywJTZo1AcUql7juiGTDZU6yK52UA
Date: Wed, 9 Feb 2022 08:44:32 +0000
Message-ID: <4614572e-4de5-258d-7367-4d5a6cfbca3d@nvidia.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-4-hch@lst.de>
In-Reply-To: <20220209082828.2629273-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efcfc72a-a48d-4f42-f6f7-08d9eba864f3
x-ms-traffictypediagnostic: DM6PR12MB2777:EE_
x-microsoft-antispam-prvs: <DM6PR12MB2777CD238D8F5192D170C32BA32E9@DM6PR12MB2777.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:398
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4x407/tdaLbm1ebpye7fiOuCD1b/EjSB0o41AlMRFV0A7yh9mLNG0hSs8rOYzMQ9kej/RMSwfjWKDVFGkZYieFjTi00vlJjdCTrzfW6aVfmw0mm3/HgAljPldDloufJpHtK9AKe15OnG0SmkO11n1RAfBjS6pSA7dHxCHtxrEKOXwbtqik4aU9MYOEZWV256D6YxRFaj94Kqal4FD0muIV7Zxam6WiSGS8s5twEQvoi0zzLPMkSm4Gve3boepgKyxtAjEkSjmKet2J7zu41lCbhKSB46nWn5wdXnwmorR8hlokVahVUQhUh5c+pfJ30AUzqaRJVw7qoqAKgSPF9G9Lkhmk92fswhTU8PzDAde8FThVp5UnVQ1vHxZK7skkb/DA7TiGjNL4X6QWL+CUw+Jj0Hz/oT4fKbQG14i8iTUA89XeiyjDysw/oJeqa5cYO7fFv6CGCHa+K3s7Tx8lU814VSRmBZMPUHoZ+ehC+YB1ADpi896vADp5GtTcJBk4WG5NpvwPNXpwdlJzHt2Ybfp0kkoFbMiS+q9yOtqcaTn0ptce6I8Wg8LVv+ng+tyb6b2LMRb61/QLmeFYQBPWKoEQOhL6OMNQHdYWmVa0KqRBm9OIUVtut7JnyzoCJZ31X/v7pTkmQLmlFPN+cAVUnb53V67UfeBt8laprgmCCoUpxlVPe3FXzGE2L+9ANCMrffeWqfkJPL8rw+u4HYKPSZbj+kBG2wv8KK7yfvV+lIXuK9B8DPt08iXGb2IsMqEFKigZmq0w36a6CkJT8qiVnQzi96VY5h9ub05XEcKAhWbpc=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(86362001)(8676002)(36756003)(6506007)(5660300002)(122000001)(4326008)(7416002)(31686004)(6512007)(6486002)(2906002)(71200400001)(558084003)(2616005)(76116006)(66446008)(38070700005)(91956017)(31696002)(508600001)(38100700002)(921005)(110136005)(66946007)(316002)(66476007)(66556008)(64756008)(53546011)(8936002)(54906003)(186003)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTBML0x6QTlpZ2FoM2JVL1U4b0lnUzVmRS9wYTBRUjQ2VkpDZEpZWnNYVVVs?=
	=?utf-8?B?NUR4RjB3ZGZFSGV4eWRjcWpoVm9XOVRwV2VsNlp5MmdOTjhpOFJQT1FzN085?=
	=?utf-8?B?MkVJczJSNDA1cEpWOHNvV2pHSHEvbTNTTUpvSGIrbjR0bEhKKzlaZlg0Rjll?=
	=?utf-8?B?MzM4SnpDTXgzRHBsZ3Z3aVRORVE0Q3ErYW9GM0M1Q3dnclMzaEJXSS9Eazc3?=
	=?utf-8?B?VDBRNmRybUc1TE9GRlRmY0lma0dtWE1UZkhRK2JZSDBwcVBxMjZzbmk5Ky95?=
	=?utf-8?B?bDdpa0N1K3N4TUVuc21aRVJ0NXAyTk54TFdMOFNUV3Y0ZXdWMEpRbm4rc3Ft?=
	=?utf-8?B?UkpZQWh6WndzcjArMXRhajh0WTlMM3lNdUh6enJRQjN4TFBObEVic1BramQ4?=
	=?utf-8?B?Q0xCVmRCYzFFQUU0UGd3MGFIT3ZCZTVYK0FCelozUmdDeHRodk5wa2JuUkFa?=
	=?utf-8?B?VnBCSUZibW9WT2tvTER0aWNGWmlJQ3RGVVZ4NlBlbXB2Njdkd25xS2JEVmNu?=
	=?utf-8?B?VWJ0SmVLY2lIRkNkWGd5WkF2b2U5QndUaFJZNDVYeXVsL3hmUEVXdk55eGpY?=
	=?utf-8?B?VHh2NzlhVmpVK0pSUHA0eHpYSGtOWFVvdU83Rmhrc3dTVk1IU2plbzZKZFli?=
	=?utf-8?B?a0x3YUdIbE9Wd0VsVlNndzJYeTRrRE5aSnpLUm9OeTZBOFVTSVd4K05SM3Vq?=
	=?utf-8?B?NEg3ZzVwU2dYVGwzdE9ORXdteFM2clUyYmxESkJKQjJNOVU0UUlxUHdqUzlW?=
	=?utf-8?B?M0tsMUhVV3ZlTU5rZm93VXhTeThISStQQUV1L1lONXdiNU5nL2x2T3RZSWJr?=
	=?utf-8?B?OHhJNWMxbEdlSGowaXlUdGpzb1AxeWl3V2I3cHBkUSs1M2p1Z1hYNWRwb0FT?=
	=?utf-8?B?NDk2c1RuWnBHSXd2NDBrbG9NS202WStVcGRQZDliUEtUZFlBZmNTK3B4NGd4?=
	=?utf-8?B?SzE1NEd3dDJBTEJHYThuR2VsdHFMcUFVZGV2VXpBT2dDZmE5Nk4vMlFaN0Ji?=
	=?utf-8?B?eW1LOG1yYzdISTYwT3FFbDV0dzdVR083cm9HR01MR1BFVlEyb3k4SlRDYnYy?=
	=?utf-8?B?ZmlEMWNVaE00RUFyeDB1QUpxTHdjU2QvZ2p5Q0RFWSt1eWdxbDdxWGtCSTcy?=
	=?utf-8?B?Si8xeWg4N21OSTF5VTkrMzJJdlB4TGxDcW9YNHUraGgzNzdUeFFLa2FBOTNY?=
	=?utf-8?B?ZzhucWlzZzVxZmNvZXY0ZGNINDNDYkplRTNCQlRXVEwyelBlY2N6dkM5ck8x?=
	=?utf-8?B?eEMrUjFuU1pKaTNQVEZtcVdFSCtBRXRyYzJUVW0zNThkNzlPWFhjMzBtdG82?=
	=?utf-8?B?Y2tNRmNuT2w2QVBMY3ZHbEthd1luVWg4RFVzaDZqTTg0TEZ4YndORmY4YS9C?=
	=?utf-8?B?OFNBaThSaHA1cml3cTNEZ3VYMkVKNXAzVHhWYlJXbTNWK0JWMjdZVXFpU3lx?=
	=?utf-8?B?YzdDNkUvWWtNUll5bGhEMUd2dkJvbzdId0Z3MmE4d0NtaE01bnV3dWZyRmxw?=
	=?utf-8?B?akJzaEo3WmJmZnJTQ3BUOVY0amJOdTgwaitTQXVqaXJONk15SXUwYjRpaUtK?=
	=?utf-8?B?b0tqZ3hGSTFLWS9SMHRoZVk0S1lpZkFlempYMFFsMDBISE5sS1JQQTRmaFZJ?=
	=?utf-8?B?a2JhMEdYRStxVndrSVBZL1dtNmJnSmtpRkJ4QUhpdHJUVzkzSFl2QURCVVU4?=
	=?utf-8?B?NThxeVc0VGgvSGxmNGpidnI5a3psV1o4RUZHNWdQMmMzbEw1aFJqeTdoWHNE?=
	=?utf-8?B?N1pERm1Jb0pnSmRQU1k5YXZ4QUFJS0Rkc0VmcnVoYTFBdGlqLzk2OVpWM0wz?=
	=?utf-8?B?OURnNk5jQVdvTkFhMitONzRwWnhCLzB6cjlqSm03RXFzdERwMG9lMXBqSXZ1?=
	=?utf-8?B?UVZLMEJwaDloNEdIVHBZTE1Cd20rdEFBclhqQU5SemtFL0RwU2hLRFA1c2E5?=
	=?utf-8?B?bFlsS3l0WlV1WXhFdEU0a3pEQ2hpcDhhaU9mZVJJRUFkaDZJVUhWWmZYSVIx?=
	=?utf-8?B?SUg5QWMxT2tESEVwRGpjQkYwWUhwL3FobCtXSURVNGVkUXk3ZmpXSVB4VHpJ?=
	=?utf-8?B?Y1VxUTg4Z3ROdkNtQk9Ick5KRStnTEwvVFJiRExzZWtFMUs3VEMreHpMY1Fy?=
	=?utf-8?B?a2NZaHBQWGs1T2NGYmJ0Mmg5ajliYkpWbmdIZWtBK0pvcUk4STVDZmlLRENr?=
	=?utf-8?Q?xUQ60Nm5vJuT9i98/LJn2Tpb/MdTkxsfsTRQNIBeaedz?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efcfc72a-a48d-4f42-f6f7-08d9eba864f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:44:32.9441 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBmW5eGUuzNqL4eLlqHghqny/b4JCHvG6jWWDA7PLPIaZcdgDZUEm6cbOr3FgU2X07CoPWlPA+rmu5jAiSDPkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2777
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2198ibCL019512
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Feb 2022 03:18:24 -0500
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [dm-devel] [PATCH 3/7] rnbd: drop WRITE_SAME support
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
Content-ID: <9451388EB42582449CCC4E48A98FF695@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/9/22 12:28 AM, Christoph Hellwig wrote:
> REQ_OP_WRITE_SAME was only ever submitted by the legacy Linux zeroing
> code, which has switched to use REQ_OP_WRITE_ZEROES long before rnbd was
> even merged.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

