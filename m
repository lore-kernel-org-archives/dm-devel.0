Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC56C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:42:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-Zp6z0k1lNjGV_6pAv_l6jA-1; Fri, 04 Feb 2022 04:42:08 -0500
X-MC-Unique: Zp6z0k1lNjGV_6pAv_l6jA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A59A363A4;
	Fri,  4 Feb 2022 09:42:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A98B57B6EB;
	Fri,  4 Feb 2022 09:42:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8080B4A7C8;
	Fri,  4 Feb 2022 09:42:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21430i27013385 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 22:00:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B263B492D54; Fri,  4 Feb 2022 03:00:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD1FF492D4A
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 03:00:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F93F85A5BB
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 03:00:44 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-642-60X7BFWLNXyg9mP_jNITKQ-1; Thu, 03 Feb 2022 22:00:42 -0500
X-MC-Unique: 60X7BFWLNXyg9mP_jNITKQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 4 Feb 2022 03:00:41 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.014;
	Fri, 4 Feb 2022 03:00:40 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5pGTuc0vK6aW0WDOYv4vbM4lKx/xVyAgAI7dYCAAAKFAIAAN5GAgAAXUoCAAGVZgA==
Date: Fri, 4 Feb 2022 03:00:40 +0000
Message-ID: <a281a539-6892-d7e2-cff9-57b5f3c22373@nvidia.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<CGME20220201183359uscas1p2d7e48dc4cafed3df60c304a06f2323cd@uscas1p2.samsung.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<20220202060154.GA120951@bgt-140510-bm01>
	<20220203160633.rdwovqoxlbr3nu5u@garbanzo>
	<20220203161534.GA15366@lst.de>
	<YfwuQxS79wl8l/a0@bombadil.infradead.org>
	<alpine.LRH.2.02.2202031532410.12071@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2202031532410.12071@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f614316-f7af-40f7-b303-08d9e78a86d6
x-ms-traffictypediagnostic: MN2PR12MB4423:EE_
x-microsoft-antispam-prvs: <MN2PR12MB442307FA39C82A3452A3BE6EA3299@MN2PR12MB4423.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eMI77ym5lVmVvvtJte874ebZqEQys5dbJVoTT+Gh8L0RtoR26KH8sO9pxUnR//2PN7LMeG0L1Xiqjpg0sA/m/3LN0bMdulCSv9BDmoM3BW2Knpbpk49LQiAWYeI7IyXnNonJ0S1LmS6LT1iA5o7WSCIbO1UqEFWgjgvo4YNb45WGlvwuFKP0KlOZwOcV7jeqXNmj41UMzLgqo98wvMjkVtoT0MAtdYLj6j7PbDe6TQm/eansI+qe+rVgmUUZyQIkoSJcsJXOdsfhPLxFXjpIzCq/GqvwkphSdLF8TWRX5AIboWZ342ns2x4p6gOaUdw16Y6HMdFf4oLtZjx+4+OV8dgsxyRKIliyG1UgFYCHrrzdN7iH+RfaWWiFOkTB1u/OfQU4AnKQ1APDLFJge3KlEeoyvRbUgalRXHixfJxf3XGPBc87FMIMeAvLdefeqwrE0+F8aCE695xdxzH4bKcMQ2Q3sWo7ySglSLroK/FQWNUOChxIyjwbP4ZjgdEKRqxL9Glp9qkzfqSCgJk5TKX+LAHJTnJxZO41NjVXKGw00VVSaCPdlHpaJWYpHeUH0OSYjriJLscadSs8ObPXKVmgDjv09HQB/k5G98Z/ZSaIxtX6Pu+JsvVFDwBFi83rGR6oXoRv/fd/XWKQMaEIDUtWrNMqIjaE/B4r2UlyY/TciL7aoPg37zRem5l1MFkZwDWul8POsdSXU6hq8cyXCTZi0iEc5wLGMNEZXINVr6pvpOcyCS2ddziRAGmqLQQgP2wt/kWXVk9+t9W6NbQYmNv/2g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(54906003)(7416002)(6916009)(38100700002)(86362001)(122000001)(508600001)(6486002)(5660300002)(31696002)(2906002)(38070700005)(76116006)(316002)(91956017)(66946007)(66556008)(66446008)(64756008)(8936002)(8676002)(4326008)(66476007)(186003)(2616005)(53546011)(71200400001)(6506007)(6512007)(31686004)(36756003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmhaMjFQNHhGUCtvMHROYy9NOTl1Q2xrME10cmxGMWJTU2tEVk10Z0Y0bmh2?=
	=?utf-8?B?TGs4bEM2MGlCaEwveEpRTGdSTjAyWTVOYkNyOUlrQ3A4SXluaW9XdjN5aFNr?=
	=?utf-8?B?RmhxVlVPYXJJbWFZdzdUbkpjVDlDNUcyejc0R1NmK3Nnd041QWFBSzgrYUo5?=
	=?utf-8?B?K1V1TnNteW9qdGxEc0llUmVobitjK01TSDF0ZGJPQmt4ZG5yVkJrMW1wTVFx?=
	=?utf-8?B?aDdRMWdpUXFtTWh4eDdEWk0vdFppdWkyd1ZPd1RpdnFRV1A3bjUvcHVaSWFt?=
	=?utf-8?B?Yno3YTQwcEVRNXpQMHdGSStzaWxVeW9VOEM1a2x1QlB5TDRNOGNrdUhWOHF5?=
	=?utf-8?B?c1Nkb0xQWXdDZWRnQzN0ZTE1SVg0S3JFVFk5RVpROHZsbWxQWTBCNE9STnRn?=
	=?utf-8?B?ZmZjOHBVUzhyQUhIbmJ6eDJPL1FzM0xJTWdia1djV2kyTVVUeU5FdVZXczNi?=
	=?utf-8?B?QmFVOTA1Y0hXVmdWSHhtdDI3Z21FeFFDbFN5RTFiWUZtRFF3YUk1ODFMaFpy?=
	=?utf-8?B?Q0Z0Z3BaOXlUckE5NHcrZVdPQ1ZIbDIvWWZOSkJ3SnZEdDAyckVDc0FRY2hN?=
	=?utf-8?B?cVN6RTdVcUlXNi9HQkduWFJOU0FlWTczUlJ6L0FoZWVwNmRGNVBPbkw4azRP?=
	=?utf-8?B?VUZqVHdIRFNkaEd2dGxqUjNHbzdEWDBJY1BBRU4zWkdZWGl6Y0hhalpHbzlZ?=
	=?utf-8?B?b1AvYnhJdXk5OUM4ZFlLNTkyK3VxNGRVaVJtOEREdlJlKyt0SVNDc2ZwSzZE?=
	=?utf-8?B?bjNSNWdHMFl4eTN4RWpOQUhTOHMxU01iNG5HaEV0ak9GbVN1ZzNaN2U3dmlp?=
	=?utf-8?B?RlNUajFJR05sV3JGVjdpdXdYZ2thbDc2TlZVZWUwdGF4SGtnQUlieUdoQjc2?=
	=?utf-8?B?YUNTMkpEVHRIRWFkK21lN0Y0amtaMGRBZG9MSVlqcC9yWFcwNGFJMjhyNHNN?=
	=?utf-8?B?UGs0ZlhqUHdNWWRSdUdHZFdibi9JVmE3V2Zsb25GTXZyeGQxWmxIRStWTkor?=
	=?utf-8?B?T1hnZmZjZFRSVFVJYWtuR2xyRXdpcEZ5R2UrTE1GVzBEVkFFMUtJRi9tNGNk?=
	=?utf-8?B?WXZnMU9Db012YUsxMWM1UzUwWkFtaUNCVnc4RkdNeWdnb21pNWk3bjZQa0lw?=
	=?utf-8?B?R0tPdVBWYzFTQml1bTBGVnVZVld1MlczZ1FHanVTMUN4QWFieXQyWm9ESFVW?=
	=?utf-8?B?MWhZZU9UV0tleGZJa2NXNjg3citSendyL3F5enhUdjJtWkZHN05hWVZsMTA5?=
	=?utf-8?B?d3JmaE9iUlFFNDBPWjl6UEFPNlFMa0Vua1AvSCtzUDh2RHpPWGhrNlZ3NHB0?=
	=?utf-8?B?QlBUaG9CNG1Ncm1EejJ2WWtibFBaWUdtSGNqeFhDY0pqTDdDWW5IZXNYTGpE?=
	=?utf-8?B?VTc5ZHBPNVpMYXVUMkpVdFl1UStjMkVJdWltZ0IxcGVHbmRVcVdoNWhKMFNW?=
	=?utf-8?B?LzdwOVYvYkZZeERtSG5URzU3MjloVHVPMmV3SjVKU1R4alE1SHlRbXlreHJ2?=
	=?utf-8?B?dWw0aSs5T3RmM3k5UDZhSjRiUWFqOE5nYmxqajhxRjZLUXpEMkZvN0hxa3hQ?=
	=?utf-8?B?bkFneWNMU0ZzdnEwWkZSVW1GbXJCVkhnODVycmhpL2J3cUhYZ3VjNXpuaTdD?=
	=?utf-8?B?azlVYksyZkF4RklHVC85enR3NnlpTUVwcHp4UE1hTUJHSC85b2kvRmtCcnlv?=
	=?utf-8?B?UytRT0FCT25tSXl0ZUcva0dRRVE3cWMyMGhsS1B0ZndpSGxrZ0VpS2FTRlpD?=
	=?utf-8?B?UjhVMWVYMFk4dFFJRXRaU0paNTRYTmxHN1VabUFtVDR3VEN3cjErMUFCdjhD?=
	=?utf-8?B?T2t1Z2RjRnRtc3UzL1M4TzVRK1l1ejJTaTk0djNMUmVLTDhLVHNqUVVKVHVk?=
	=?utf-8?B?NTE4MFQ2NldLd0JML20va2hvYnpGTFJzNERkcGZ1dm5JaWpmbWIzcXF1dzFn?=
	=?utf-8?B?SCtMaWthQ3N4dEtULzE0MERPYWpCTVRVWEROMGNWbXFsV09mYTdtcXNDbDRJ?=
	=?utf-8?B?UnM4S0NmdzFsOFRjYm55Y0pIWXZEZjdGODg3ZjZLMG50VGxWVHlWU1lVSFFj?=
	=?utf-8?B?UGgxSENXM0hBR2ZpZk5FeFBJS3AwRHJWdEdnQ2FoSUlVMk1ZWTRLOUhLbjdy?=
	=?utf-8?B?cWNDZVQvZmZTN2NxL3Uwa0x3VXpCYkxDRWlJMk1yRmNRWTB2eFdEalNTMnJq?=
	=?utf-8?B?NkVlRWdUVmVJTDRqZlZmTjJmeDBCSG5TSDhSTXdYY1hrVXhONERCQkR1R1RQ?=
	=?utf-8?B?aUhDSFdZVHFFUnNYRGhEZjJ3d2xBPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f614316-f7af-40f7-b303-08d9e78a86d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 03:00:40.1950 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U0+FSGbxQAHm4WLzs5DrZHjvnQQaZ1OwOMdeYdvqn9BZynmSRCGvU5MDfbLxjixssci4P1/Py1SzMfW/ehX00A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21430i27013385
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:42 -0500
Cc: Vincent Fu <vincent.fu@samsung.com>, Bart,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Manzanares <a.manzanares@samsung.com>, "osandov@fb.com" <osandov@fb.com>,
	=?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>,
	Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K.
	Petersen" <martin.petersen@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Adam,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
Content-ID: <8006ECFE16596F4AB76CA6E1CEB451A2@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Mikulas,

On 2/3/22 12:57, Mikulas Patocka wrote:
> 
> 
> On Thu, 3 Feb 2022, Luis Chamberlain wrote:
> 
>> On Thu, Feb 03, 2022 at 05:15:34PM +0100, Christoph Hellwig wrote:
>>> On Thu, Feb 03, 2022 at 08:06:33AM -0800, Luis Chamberlain wrote:
>>>> On Wed, Feb 02, 2022 at 06:01:13AM +0000, Adam Manzanares wrote:
>>>>> BTW I think having the target code be able to implement simple copy without
>>>>> moving data over the fabric would be a great way of showing off the command.
>>>>
>>>> Do you mean this should be implemented instead as a fabrics backend
>>>> instead because fabrics already instantiates and creates a virtual
>>>> nvme device? And so this would mean less code?
>>>
>>> It would be a lot less code.  In fact I don't think we need any new code
>>> at all.  Just using nvme-loop on top of null_blk or brd should be all
>>> that is needed.
>>
>> Mikulas,
>>
>> That begs the question why add this instead of using null_blk with
>> nvme-loop?
>>
>>    Luis
> 
> I think that nvme-debug (the patch 3) doesn't have to be added to the
> kernel.
> 
> Nvme-debug was an old student project that was canceled. I used it because
> it was very easy to add copy offload functionality to it - adding this
> capability took just one function with 43 lines of code (nvme_debug_copy).
> 
> I don't know if someone is interested in continuing the development of
> nvme-debug. If yes, I can continue the development, if not, we can just
> drop it.
> 
> Mikulas
> 

Thanks for explanation seems like we are on the same page, we don't
want any code such as this that is controller specific in the
NVMe repo including target.

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

