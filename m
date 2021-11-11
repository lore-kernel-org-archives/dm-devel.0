Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51391C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 05:23:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 962E360F6E
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 05:23:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 962E360F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-RgIjRpOyP9qqgFwHC2ndiA-1; Fri, 12 Nov 2021 00:23:24 -0500
X-MC-Unique: RgIjRpOyP9qqgFwHC2ndiA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1358B1006AA1;
	Fri, 12 Nov 2021 05:23:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 966C260C17;
	Fri, 12 Nov 2021 05:23:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4BC144A703;
	Fri, 12 Nov 2021 05:23:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB8Info022051 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 03:18:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 495EF1121319; Thu, 11 Nov 2021 08:18:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43F701121318
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:18:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A20A80231D
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:18:41 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-518-S1LenVc-OfGCc7DYOmrJvA-1; Thu, 11 Nov 2021 03:18:37 -0500
X-MC-Unique: S1LenVc-OfGCc7DYOmrJvA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1727.namprd12.prod.outlook.com (2603:10b6:300:107::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 11 Nov 2021 08:18:32 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 08:18:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
Thread-Index: AQHX0UfJUBDssfv+ckmT1a3v6/33Gavy9LOAgAAlMQCAAId1gIAKZYUA
Date: Thu, 11 Nov 2021 08:18:31 +0000
Message-ID: <1a4074a0-0826-1687-fe06-0f078b06aae0@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104071439.GA21927@lst.de>
	<661bcadd-a030-4a72-81ae-ef15080f0241@nvidia.com>
	<20211104173235.GI2237511@magnolia>
In-Reply-To: <20211104173235.GI2237511@magnolia>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b1a03d6-b77d-43dc-1ed1-08d9a4ebd956
x-ms-traffictypediagnostic: MWHPR12MB1727:
x-microsoft-antispam-prvs: <MWHPR12MB1727C03C36E54A9ECBC2E353A3949@MWHPR12MB1727.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zNIj3o2scKGCWxXb0yv63RL/IsdRZNWvMzm/Rdc35pixonlR9HhvXdl7V8cI1F7dA0vHnPEQtJeUHw+wt+25TF8BwKGONIdyZuWIRpfoglr/Emo0kP8v+71Ix+LnJCzWPqZ69Dco6cbPwZ6D7J5ubahH8oWfwzqBzztt22JNEqCpdv73oV3qB0FflfIwlzr7oAIa/qSt4JLH/Z2p5eaDBtXDZuwSQy1UNouPLu2kSqznQobrfo6Vk7fKiqXiUV5dmUaLk75fIAMobbzAD6lmNFKa9n9jKMiNAcOx6UYktO80fNhPBB2Hb0PORVfirDN0ndT9syWkorSSuTxF8xRYqTTAZdwCdPwkEVFWdV/m0Jv+soY2p5wijg+uzYnDHUidc0rgHXnfZgoQAQ9rN6JDR+JgjKaz44lv1ZpXmXQnMeFiKX6jxSE4eOLwlSRREHVqkwG+KojY/8DZievybzXml4J1yHeCRVUPAMKf3dCZJkRgmNjWTcxZ7+PfrcJCzBX0PT3eUW8I++hknIBTFLevG1tVzFuGSKPoIYMkBtOFgC/wu7/HErfr75wubl5MOiy+oprYC9k4WFtJVabp6KdbIjQFQ3Q+lMMUIKRaK6aY902dwlx7HxlPvwGnEiilzoJ/KnGkPwJaN2jFvw9tGxamGHszN1x+eEVcTm2mzL9c79tdc+keDD6hT0r3UuztPuFZS+EzpsZ7twlrwv6VZkiqekQl6COXqQGbLMZbEE6OOfkuD9CX2nRHIz0XfV2ojeqxENj70xS6CdUP/tJmFCrDwQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(66946007)(53546011)(6916009)(36756003)(31686004)(6506007)(86362001)(122000001)(2616005)(4326008)(5660300002)(76116006)(6512007)(38100700002)(508600001)(316002)(54906003)(71200400001)(6486002)(31696002)(186003)(8676002)(64756008)(8936002)(83380400001)(66446008)(66556008)(7406005)(66476007)(7416002)(2906002)(38070700005)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L21wRm1WcVVaYm1nOHhIaHFwZHo5NHhyMlUyWjhGU2hzQmhidDlhMTVaV2xQ?=
	=?utf-8?B?QXpoYmNianJEdlpobUZxQ0JSWjIxeVVweWlIVVpFaEU1OEVZT0lIV3RBVmhx?=
	=?utf-8?B?VEwzMFJxOVlCZWVyd0FkbFpSODNueHduc3R4eTR1V1hJQUdua0xwekk2T0NE?=
	=?utf-8?B?S2x6SWhSU2hiU2xhMW9rR0QxZ2FsU2l4ZU9tczhXR0NzZHBaOHFkTmo4TG9k?=
	=?utf-8?B?aVR2Z1d5cXFyS1pEblJlK0hQN3NJYUpueU5iOEg2WHBSQ0VGVUY4NjdxTWJp?=
	=?utf-8?B?K0NLSDVPc0NEbWNBSTlXaU8vOG9PTkUyVGlwb0xmRy9LUm1paU9abFY1cDMx?=
	=?utf-8?B?OFJrbGhRSDBtS1hUTk5QYzF6VC81aWRwaGNhTjQ0VmNOOUxqMGVzMVZkenRF?=
	=?utf-8?B?OWxzQW9YRVdvUStTekFneVc2clQ3bmRtNGhhV3JQMVc1RE1tWTVWdkNwQk9K?=
	=?utf-8?B?TmdhNStGbFFzYmJ0S0h1MytTY0tZeDk2d3ZGUWJNaC8vbjZCVGY2b2pheXR3?=
	=?utf-8?B?Q3BQZHJubm9rdXFXc25DMzNZMTF4QnlGZE5IbG04eXZhSVRyK1lkUGlnRWxx?=
	=?utf-8?B?Q2NDOHd6TnRVSlVIY0VNUGRhOGxLZ25wRm5WMkVCb1g3UDhMSEcya2hMbjJC?=
	=?utf-8?B?dVFRdU85Ynlkc1JMUk9kMDFWVHhiYkVzcDNEbktVZzVuTnRON0hqMXRYQUs4?=
	=?utf-8?B?NS9hNTZZZlpqSFRBRjRkbUxBZHFKeSsyY2hzWEtoZ2d6bk9NeVRqUWJ2ZlFK?=
	=?utf-8?B?TEduejBkWHVBdWlFR3pEQVl5TEY0Sk5TMjhUNnNLVmNMNGY4M1QwMnNlSE93?=
	=?utf-8?B?enQ3VjllbzBLUnZUcmEydlNsSDU4cXNUanByYzl1TUtlcVJSemlvRExsUWdN?=
	=?utf-8?B?ZkpKb0JzN3cvU05Wd0YyenlQem1lYTJ6S21KOVdXclNCbmp1cDFNdi9hdC9P?=
	=?utf-8?B?N2lWWjQ4TnRYNVRMZGR3aTE4OTV5WVNUVldacXE3Rk14cjA0TzhyRFYyaHgr?=
	=?utf-8?B?WlU4NGlpN3BFeVZaamVrcDhZWksza3R2cnVNdWM1OGJTamRyVUkvSis5VHBW?=
	=?utf-8?B?eXpnb1RDaVdPZjRSUWNDOWlzS1hhQmRoRFJWc1MzYmJucHo1YVdWZTVxeXV6?=
	=?utf-8?B?THByN2lPdys4WkRsWnloeFVudm5UdW9QK2hCd1ZzUlgvbGYybjdaZW5MUU5B?=
	=?utf-8?B?YzNremlTMEppZmM2VnhWT1JUMzBsM3hrblZoTjd0NWZVUDNyMnRvMkY1cnY4?=
	=?utf-8?B?SHN5aFltdHRhSjdxaUFpUG5iVVc4UUh2RmtNNEU2VFdGcUxCanlBOXdwTEdZ?=
	=?utf-8?B?ME83ellTeURYNk1QU1FXUnp4YmJGOEJHUFZiMGdFSS9BV2NLTEwwTFhnR0pn?=
	=?utf-8?B?WVAwZXpIOVFWVFF4QWNwTU9XQVY5NExPRTFYVFFiUmN2MGQ4TWdWaldSL2hK?=
	=?utf-8?B?Tzg5TldTQkxhM0ZaYTE3NGQ1ZjhjSSt4RHc4cExia3ZZM0Y4dC85VVN4bGl3?=
	=?utf-8?B?NGlSVmNIK0V6d0Rub0kyTCs3amhiRVlGNitJWnJzRWU0OHZ6RDJscDVXQk5l?=
	=?utf-8?B?MlJWb1hYN3NTL2Rucmtsd3ViMVF0Y29JZ3F2Y3ZZSWtFWVQwamIyeDFFb3lE?=
	=?utf-8?B?Y1NXWDFzb1FqdzFreVljVFVLdU9uVS9SQ3g1dzgyaDY3K1lVb2lUZkMvdDBP?=
	=?utf-8?B?QmhLUFBxT243OHhpSmJib3hmNE9zUTNJSEVKK2kyNmFZTTE1NnFLdVVLV3pj?=
	=?utf-8?B?RHlTdUMrRDdFMzJtL2hJWU1Mc3lrWnFrbVk1Z2ZJWkRwZXFHUm54Si9lSDQ4?=
	=?utf-8?B?VVRobWZ6VEpNRG9EaTcrL0ZYTEgvc0YxVEJxemJVRk0zdi8yblNqWUJReFEv?=
	=?utf-8?B?ZDYxWVFQMXFFS3ZXcHloWS9YeC9QN1JBLzlCaWdFclRPcGxWMTIwdHg3a3Vi?=
	=?utf-8?B?VDRWYWdudFJra0VoTXRmeEZ0ZWdIV2c5VHlya1VJQ1pSQ2ZGaUVwbG1rRE10?=
	=?utf-8?B?ZUZyVTlkTGQ3VjBWbUxRWjYzS0N0Zm5nWHhRUVdiZEE1ano1S1B6YkVRZk9O?=
	=?utf-8?B?UnkrVzJVcVNMeS9sWVkyWXljWDQ1OEY4T045ekNUSmcvNFp0bEUyZlYyeFpr?=
	=?utf-8?B?ak5mWGlMdi9aR3JXNmQ2aHhZMWNDdEV6YUU3bnh1S2FzZ0owc29Wb2RTbnN4?=
	=?utf-8?B?Tk5mT3lQM2dHM2hUaE5nWG42WS83U2tZTFZUUlhIZ01vNW41ZC9kTy9tMGd6?=
	=?utf-8?Q?vHZKaRCKyTGlVZYFMsyr/H+bcwR0ZKEBRtqDort1HA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1a03d6-b77d-43dc-1ed1-08d9a4ebd956
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:18:31.8106 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JJYBYnpOmdeZBVmOndnxVUpLWEMkwhVNpFJjkJA+Txu6rMcoYzesmwy8Mv90DUjgitRtJry8Bh6v9nGgmC/mGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1727
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AB8Info022051
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 12 Nov 2021 00:23:13 -0500
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	Christoph Hellwig <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	"javier@javigon.com" <javier@javigon.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"osandov@fb.com" <osandov@fb.com>,
	"danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F32F88974F175047A4B3EDC7344C37C4@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/4/2021 10:32 AM, Darrick J. Wong wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Thu, Nov 04, 2021 at 09:27:50AM +0000, Chaitanya Kulkarni wrote:
>> On 11/4/2021 12:14 AM, Christoph Hellwig wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> What is the actual use case here?
>>>
>>
>> One of the immediate use-case is to use this interface with XFS
>> scrubbing infrastructure [1] (by replacing any SCSI calls e.g. sg_io()
>> with BLKVERIFY ioctl() calls corresponding to REQ_OP_VERIFY) and
>> eventually allow and extend other file systems to use it for scrubbing.
> 
> FWIW it /would/ be a win to have a general blkdev ioctl to do this,
> rather than shoving SCSI commands through /dev/sg, which (obviously)
> doesn't work when dm and friends are in use.  I hadn't bothered to wire
> up xfs_scrub to NVME COMPARE because none of my devices support it and
> tbh I was holding out for this kind of interface anyway. ;)
> 

Yes, it is not possible without a new interface and impossible for dm
and friends.

> I also wonder if it would be useful (since we're already having a
> discussion elsewhere about data integrity syscalls for pmem) to be able
> to call this sort of thing against files?  In which case we'd want
> another preadv2 flag or something, and then plumb all that through the
> vfs/iomap as needed?
> 
> --D
> 

As part of a complete picture we once we get the block layer part stable
in the upstream how about implementing fsverify command like utility
that will work similar to fstrim so user can verify the critical files
with plumbing of VFS and iomap ?

Or is there other way that is more suitable ?

>> [1] man xfs_scrub :-
>> -x     Read all file data extents to look for disk errors.
>>                 xfs_scrub will issue O_DIRECT reads to the block device
>>                 directly.  If the block device is a SCSI disk, it will
>>                 instead issue READ VERIFY commands directly to the disk.
>>                 If media errors are found, the error report will include
>>                 the disk offset, in bytes.  If the media errors affect a
>>                 file, the report will also include the inode number and
>>                 file offset, in bytes.  These actions will confirm that
>>                 all file data blocks can be read from storage.
>>
>>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

