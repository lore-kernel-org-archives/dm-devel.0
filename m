Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D9CC43217
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-Xy83juPeMrSzI99FB8lm5g-1; Tue, 19 Apr 2022 02:10:35 -0400
X-MC-Unique: Xy83juPeMrSzI99FB8lm5g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55A0580418E;
	Tue, 19 Apr 2022 06:10:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41C6E40FF41A;
	Tue, 19 Apr 2022 06:10:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E63551940376;
	Tue, 19 Apr 2022 06:10:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 177B919451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:46:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E947BC44CD9; Fri, 15 Apr 2022 05:46:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4A73C28109
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:46:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C56F21018AA4
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:46:44 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1anam02on2064.outbound.protection.outlook.com [40.107.96.64]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441--aO8cvr5MUKUt7LfV-1lzA-1; Fri, 15 Apr 2022 01:46:38 -0400
X-MC-Unique: -aO8cvr5MUKUt7LfV-1lzA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM5PR1201MB0169.namprd12.prod.outlook.com (2603:10b6:4:55::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:46:33 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:46:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 22/27] block: refactor discard bio size limiting
Thread-Index: AQHYUITpUnTHchxryEq5+LCXZWuKpazwd0gA
Date: Fri, 15 Apr 2022 05:46:32 +0000
Message-ID: <d3f73a4f-0d45-6627-7878-9b5acd47842f@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-23-hch@lst.de>
In-Reply-To: <20220415045258.199825-23-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9b589c8-cb4a-4ba4-a30a-08da1ea34bfa
x-ms-traffictypediagnostic: DM5PR1201MB0169:EE_
x-microsoft-antispam-prvs: <DM5PR1201MB01695F76C1A4B9A7D05A3F7AA3EE9@DM5PR1201MB0169.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VOFzXF/s96NsYbBCYoyP+Oqyrbo7ZvySarnLRF7ZTp6sy8qxvAl38W1b3iHUqaUeX8qz3GMN+qFT0JGb0/6aWm9O+1hhIvw77xbO2yTllmJhR3Lt7TRH8Ih/6krLUtCDg/KLCzdP6EtLbWyHqJsFOBk9QZi+Jdf7ktdltvMZdfTGcqg/GtsHXgwytDp3/3BHa7RZv4CMTRiforweHkzX6rhZQUbhHXfX3qgCVX6xsn3qBMqbPW72/h3/tu2p+WSmKmb+LaYHADTssjdesb9wusH0HnmLfZC9hd55NDHkhwSEJjghkUvRMFQEsh1KvVKoQrtB4DjUg0ZSApUd63FFA8xt4OcLIcOO4PsN/sjBxXjGQ2cb5r8PVoRu/yNjyv84c9yC8f3gy1R3gnNW1Dqu/ZUkIvw9SiUkDg6U7dY8UbecAYBhZRsHGUtUViHiJYON3dSfvKaGX38RUIGG/yPM8FZYYuawjdoDNL12/MMR+hJLoT/hZdl1lu1rPaZ4VRRpoA1UcaS9qeldpb3c4xeQpV8TgRcsZg90HoAPRNpCSKfJSJsWhFB4kAw1XUX8sXUpXgykfyTR5h1H6A3x3h5VO5n67XpNrSc2Tyf40kCZfPcYlFZKOOT0O/4XuuqIY19aXpXjjtrIodvoM0aI+cWoOvLmovj0zTEANUyleszRXiElvmrFroYc9epemyTr2r52FDFSLyKlBX4s/B4IOrGsWKtBYUWQ9RaofryxfBm47b5nk+dodGVkY4HSgZN+2dDventXpgL6bl654kMamsVYVQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(8676002)(110136005)(71200400001)(64756008)(8936002)(83380400001)(2616005)(31686004)(2906002)(38070700005)(316002)(6506007)(53546011)(6512007)(66446008)(7406005)(122000001)(186003)(7416002)(76116006)(66476007)(66946007)(91956017)(66556008)(508600001)(36756003)(5660300002)(54906003)(38100700002)(6486002)(86362001)(31696002)(558084003)(4326008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVdCWElBQWNxMytqeUo1SThNS2NFL2FaVitHUUNldkxvMDllVVZIbXJhWEhP?=
 =?utf-8?B?YWJWNzBjSDY4TTZQVCtNTXlZVzR1bzNOalJkVVZwTXFtZUt1ajFleFZBUUFr?=
 =?utf-8?B?WnRUM0ZlYU9YOVZ0bWRLaEZKY2MzbjRYVlFuaWliMEZpRkpwOWVmMHRGUU8r?=
 =?utf-8?B?R3BORVRldHVHMi9HVzlxa3Z1Q1JzUmwvYlUwdVhKK08yRTJCeVJ3L2xCUHBs?=
 =?utf-8?B?VHhpSXh5cTVuT0RPYjJZWHMxcVJXV3FxZjQ0QTc5Rys2a0Y0SWgzazdZY1Jy?=
 =?utf-8?B?S2NyWmIxM0VIMFBOWjRVUjlkeUR6VitGUXRiZElSTEQrRXhMa3dOT0ZwdmZv?=
 =?utf-8?B?aGJ4S2pFQ3N5a21FZGR3V0wrOXlTQytVamVOb000cDZ1K0hpL0NMbDlSdmlV?=
 =?utf-8?B?VG1CUXp2eHRud2d2STJxNVYxZllxbTUydFQ3ZkV6S2YydXAycVhDL0ttbEdo?=
 =?utf-8?B?V0xCbi83cW5MenBkWG5vWnNKQVl1YzdDTi9lelljK08rcjdwMEMvT0p4NmpQ?=
 =?utf-8?B?cE1nUjNBOUU4d29MeGxYRFNKYTRsMElKanNwSjdKYktpa0VRWXJOK0tEODJD?=
 =?utf-8?B?SGNkaXJKdlNZQWdQelpJWTlwdStHeU1sekV0d3RPOUlrbHdCTGV1UTV0Ymkx?=
 =?utf-8?B?aWg0eXdjQzhGK0FkVWkybGs0eTQvOWk5UkJSRGp5ME01dmFqdk5QME9tTHdS?=
 =?utf-8?B?a2dNeXZ3aGk5em90aUVSeEdGcFg0SldKQ3hOeWtoQXlFQk90bzdrM3o0R2Z5?=
 =?utf-8?B?OUdGdXJ4N0w3eXlRQWllSWhJR2hNZ25MTFlsaE80emU3UU9WcFZlTTU5eXNQ?=
 =?utf-8?B?OFZ2TUoyY2Nkb1UraHVxY3VlMDdLNjhBUWdEUzk5ZlRhTU9iczRmSjA1c2hC?=
 =?utf-8?B?Y2lqSDdJa2NXclZBSzRYT3RYVlNSQzVJZ2V6RkhadytSRkxzQ1NWbFJUNFAy?=
 =?utf-8?B?T1FlR1FPckR6d2g3bjJWNXl0emJVK1NVYUVaakc2RElBSTB2NDB6SDNKL1dp?=
 =?utf-8?B?MmQ5TmM1b1ZQVTkyVGZraXJaNHNMVkFMeXN5ZGUwMFdjWUZvZmZHdGh4ZmhC?=
 =?utf-8?B?K2JnQjNseU5TZXQxd1hTdHd6T25KYUFsd0h0ODhZcUpINFB0cFBtcGp0L3Qz?=
 =?utf-8?B?Mk5GaXBGbHJVNUJnMCttTm0wZUEzM2t5T0cyLzhOMThyRGpwdG9xQURzMnFF?=
 =?utf-8?B?dDRJRm1UaXIvbUs4MWRQemM2SERMUHI0aDVndEROcVRNTFRpbFNkYktiUE5P?=
 =?utf-8?B?WndUdDlYUW1EeVR4UE85Q0M3dlVza1ptaXdvblVlVnhJbC80S3V1b0Njcjgy?=
 =?utf-8?B?ZnFtKzRTMU5KNEx0ZTR5ZUtCY2ZOcjdVZ2N1VXV5eGJ2eThLbEZaWkxQK3d5?=
 =?utf-8?B?UWQrWS9yRkxISnhPbWRQN25jdmFOSzc4SWhpaGxGQjA2bDFIaUFlL1ZjeEkz?=
 =?utf-8?B?OWxOWEVCZVZwMjFVVm9XeUVIZ3VYVWIxUWphZTMvb3Y4eU1URVluUzFUYTBX?=
 =?utf-8?B?ZkFsVTVqaGJhM1VJbFV6UEE2MGlad2RxYmtuR0tiV29PbU1BYzM5cVZIZVV2?=
 =?utf-8?B?VG16N2NlQ3ZBWk1tbjUrbXVOTDFVY0d3VEMwRlg2N0drTTUvU0dEd2tCZHo1?=
 =?utf-8?B?WVBxT0Q4RFdLRDFKVEVDUGxHbzBVQVNtVmI0cG9HVzhzTWF2RllZRXVybEZt?=
 =?utf-8?B?TGNNNkRLMUZORks3S2w1S1dEL3R4QjB5cnBHUktqd0VVNjlRc1UzeUxsTXpT?=
 =?utf-8?B?MzN0MmdWODMySXVwOTVFTHJxcE5TenVCdUhjemliMzdlbG1SNnNsMjgwbDJZ?=
 =?utf-8?B?TWxRZjFucURhZ1VXV1Zmd3B5VW9HRmdNcnBvVS84YWRBUW9OdGxzVzRFaWRH?=
 =?utf-8?B?TmV1Z0VHSFU2amdPNkxoODBWOUlRaE40Z1hVTUNpNDU0SDIwSkVDYlpXdys3?=
 =?utf-8?B?WEs1S3JMRXNjVGJpMWp5czBMTjZ2RWJzWExyS1JkZ1VCNFQ5TlUxSU93c3NP?=
 =?utf-8?B?Mm91WC9HRmhSejBlRWJFd1F5TnlFcmFQNWdOdDgwR3JvTW5yTWtyOFFSb0Zx?=
 =?utf-8?B?UTNDaFluaHBJU1Zwelg3VEhYU3ZjdmFlallmVVRkQXhjeFZhdlpWSmpyMEw3?=
 =?utf-8?B?dmliaXV0b2V1UzdXbmppby9YUDZVSnRHRTNRaTIwQ1N6Q1pTZFBtamdlY3ZW?=
 =?utf-8?B?bUorTXBOZ1FNY3krQWkzdVJHWnFJSStBcG8vTm8wSHV1TEd4WkZhRk1EN1Fl?=
 =?utf-8?B?MzVKWTR4S2lMYTY0OGtaUW5oUHNrRlBvVkkvUjB5M05teVVnVExvdGRjV0Nj?=
 =?utf-8?B?SElQTElOcHVCRnpKQVY1S1NEUEtUenRhbjdRQWlZWTMwSDIrT0c2UFJpT0t4?=
 =?utf-8?Q?R2jwV8YoRmuWle80=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b589c8-cb4a-4ba4-a30a-08da1ea34bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:46:32.8003 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ASbusO8W34q0zkWuXk1qiivnBz95QaMhMAdwYhU6fcikvNpkn9x0Er0VaGbVy82Z3hkljoFFymMKBrM9EwUVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0169
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 22/27] block: refactor discard bio size
 limiting
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "jfs-discussion@lists.sourceforge.net"
 <jfs-discussion@lists.sourceforge.net>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 Coly Li <colyli@suse.de>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5C40943C50889249AD34D58B6AD3A631@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> Move all the logic to limit the discard bio size into a common helper
> so that it is better documented.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Acked-by: Coly Li <colyli@suse.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

