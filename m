Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A3BFC43334
	for <dm-devel@archiver.kernel.org>; Mon, 27 Jun 2022 22:33:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-DgYelBf_OMWvEwUavWkF_Q-1; Mon, 27 Jun 2022 18:33:02 -0400
X-MC-Unique: DgYelBf_OMWvEwUavWkF_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFAFA80029D;
	Mon, 27 Jun 2022 22:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A50451121314;
	Mon, 27 Jun 2022 22:32:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D3BB194704A;
	Mon, 27 Jun 2022 22:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6036119466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Jun 2022 22:32:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D2CB40C141F; Mon, 27 Jun 2022 22:32:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 380C8400F8FD
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 22:32:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B84C3C02193
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 22:32:56 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-0wRV1NbZMvKua3m9_HmvMQ-1; Mon, 27 Jun 2022 18:32:54 -0400
X-MC-Unique: 0wRV1NbZMvKua3m9_HmvMQ-1
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="280338057"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; d="scan'208";a="280338057"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Jun 2022 15:31:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; d="scan'208";a="594502569"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
 by fmsmga007.fm.intel.com with ESMTP; 27 Jun 2022 15:31:49 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 15:31:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 27 Jun 2022 15:31:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 27 Jun 2022 15:31:48 -0700
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MN2PR11MB3615.namprd11.prod.outlook.com
 (2603:10b6:208:ec::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Mon, 27 Jun
 2022 22:31:46 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 22:31:46 +0000
Date: Mon, 27 Jun 2022 15:31:42 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>, Kees Cook
 <keescook@chromium.org>, <linux-kernel@vger.kernel.org>
Message-ID: <62ba2fced98ed_103a0e29448@dwillia2-xfh.notmuch>
References: <20220627180432.GA136081@embeddedor>
In-Reply-To: <20220627180432.GA136081@embeddedor>
X-ClientProxiedBy: MW4PR03CA0348.namprd03.prod.outlook.com
 (2603:10b6:303:dc::23) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09857533-95a6-4ce5-821a-08da588cd147
X-MS-TrafficTypeDiagnostic: MN2PR11MB3615:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: I8QxY2dRCssS1nOBaKo6XXukRWcQnmTJH2CTvS1oBWI5m88TdZyePC8+8Y0lOy5CTi+gHMca0W8aiZ/N99wYfzWDT4IwVc4nlPrt+m+R4p2eDFjRwAp5zJ0VpYLntAd+8A00LZQoJik2rjbu5yVMxLfzdAE/sViq6QR/ukrAYU6UH00hT/qjTfq5KJ6RNmBJjkE9wR8YlchdCVQfclNLDMwBRKAceVhlApanN3Kun5MvZcVR3nAEDzee42+78vAUhiTD75bcuXHURf9mM6NWettdBNB+fgoFRuSIfNbpFulswaXgt+/W3zFI5GI6s+IO6P7PaIkaHL5ETfxVXF7R5o8CyVUDydZpe+Wo6FiGJLus4dot7TeZ2i7BumDmuP2aPbFZpX0GbQZu4hursUXqRwE2dMGw5Mf+B4E0s5mE8SNKEUgUaTQbQGCJ+39EGCF8oMg/hVKoYY9RhxhEhjLKAozVDeQ4YIGG0uJOByhFexDi/CUzss4zWm3FPSVVNx4WelTO8Eiasy/iNjTp8PznOSLGYIo42iw/Hjo++nvz4kH45aIuzAYBtK24nNuwNzMbw4sZoThoJKGKwgdXb5MUKX0VZNuO4cSKb3qG94N5aRCJ56Wdc/+RlFCaggvApnHVcVb8WZ2tBa7ELxVh5io/heAz/fk/UX+HQSPPeKz2L/y2wd5VLtSoLAK+t2RnWXIknFIHsQEtJpjJCc3Z5XS3bsdpx9Mhe7/ar6cHw6C6qj10wOiolEM6AzvfHFUUlo6+4Fm/bKWXrtwiCf23irh7lEh8H2PSKKbYuEuqvEmBbfU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MWHPR1101MB2126.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(376002)(396003)(346002)(39860400002)(366004)(6666004)(7416002)(6506007)(41300700001)(38100700002)(8936002)(83380400001)(66946007)(66476007)(7406005)(66556008)(82960400001)(9686003)(26005)(6512007)(5660300002)(6486002)(110136005)(478600001)(8676002)(966005)(2906002)(316002)(4326008)(186003)(86362001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG81TEp2bjd5Ui8vcXRBOE1oT2o4aFh0aE1Ma1hEaHNzOWFKMEpVOEdjc0I3?=
 =?utf-8?B?SWNnYkVSZ2gxcDgwU2twTjF4ZW5PbFcwZHpEZlc3WnBtOXhsVUNMcVhTb2hw?=
 =?utf-8?B?Z1UvTFZkSXdjc3lZU1JpbGhXSDExS2RTcUhFanJHbitxYk5nSzB2TitnUTB1?=
 =?utf-8?B?d3Npa2lreGhFanpCS2Z6WGhuaWtsYldmWXB4eVAyaE9lSG5JNHV0SG9FTG40?=
 =?utf-8?B?elVLZEpIUWZ0K0ZFamlxcHU1Qmw3T1J1VU9CK29Ib0VzanNEK0xad2VyeFM5?=
 =?utf-8?B?c1dUZzh5RE9UR0Y3Wk1mOHpMdS9FUjRTU0VKT0ErU0tGd1pvdng5Wk92WmVP?=
 =?utf-8?B?aGhLVHE5QitoeUVFSmRYd3I1UEJVckw5SXNobnQ3VkNFYzFGM0VWMjR6NHZE?=
 =?utf-8?B?MW5hbUVZR3Q1TGRXQnRIbEYyU3BuRHRzbjFoN25iQ3ZsRkRwTUNiZWpLRGwy?=
 =?utf-8?B?dUlDcnNJZlRWNjZqYzNJY1RPQnhEWTJMN056dkJtK3FMS3NNL1paZ1dtQXQ2?=
 =?utf-8?B?c2toU3JpelZQMm1yVkNiTnZReUROU2thMlN0K3ptc3lqSFpGQTc5dFZ5ZkZH?=
 =?utf-8?B?M1dRNjhzT1NSOHFBRm9lV01xSExNeWJmM0d3L3hoVXNZSVc0N0dTZ1RKSnBZ?=
 =?utf-8?B?T3l5WDhrTlVZTWNYZHI3U2V3TFFTc1hKUGxZTXFNVm1Ga2hFYTNnZmZCcWZV?=
 =?utf-8?B?d29rZjJmN2NUbGh0Y29KR2hBUkdIRHpJc2FCRHkzZjZiMkJMRExhRGtPOWZK?=
 =?utf-8?B?N3VjaFU3aEpNZHFnUC9qY0RJZGwwcUgzT2crTlVnWHI3NEdGanZPVTlna1NY?=
 =?utf-8?B?ZWdsU200UjJWTVBSWW1ENTRUWTFVMmFSbDliV0FTVlJQRCs3UFI2L0JRK2pH?=
 =?utf-8?B?Z1NWQjZGdFh2aGg0ay9FV1paWmtram9tK1M4ZzgwN3h5TThkNis1bHVXTDVP?=
 =?utf-8?B?czlJK1NnR0tNcDQvOXJrdnN6YnEyRHkyNzdiMzA5SWhGV0J0a1h2Q2poc2F3?=
 =?utf-8?B?Ri9DYkJjVm9nQWVjME1ndnFtT3Q3RjFyVEVDM0U1VFd0elBCRnlXUHJWR3Zx?=
 =?utf-8?B?S3kzV3dOM0NqSjRnOUVWdGhTN0hnbTRBOUpnT3cwc3hhTkZEMzBNbkpzbEtJ?=
 =?utf-8?B?Vm5lVE0wbUN4UEdlTHBVWG9QdzRobWdCWStjb2QvcGlPd1JhUnY1UUtHcUUx?=
 =?utf-8?B?blp4NGRWbE5SYTRrRjN1Uy80ZWJoZXBvdnRDWFpMNTZBU2NCci9McTlMelJC?=
 =?utf-8?B?VTlHaGR3cGF5UlEzR3BrSVdRalM3TnJtMXhaQnBnSXNISE9aL1lHS29qQ3RV?=
 =?utf-8?B?dFd6TytkMkVUNmNMa0Z5eHBOSGJ2UXVoZFR1dHdXemhDK29MWXBBQkowaUta?=
 =?utf-8?B?NGVZZnZmOVBaK000TUQzWXk0eG1SazBONFVrYjBuVWcrdmJtK0lQSU80RGpD?=
 =?utf-8?B?YlIwdFZvcTZIMmdyK3diQ25wRWgvV1kzZkZ4U2VyYS84eDBhZHlCYkVPbngx?=
 =?utf-8?B?VUt1WHc0NjNqR0dWM0dEbnZ4cXVscHVlOEF2V2w5Vkw0UnVrNzVjL0h0a1oz?=
 =?utf-8?B?TFlFWWhIWEI3eXFVczlqa2Juc3JZVUZ0ZUtIbHhXWGV6bkloMmw4TXVXK2hm?=
 =?utf-8?B?UDBYQjI4TVB4QlVlcDRQclZ3OFBoeDVPTTNGQnVIZ2VmZE9zcXA0M3M0cHVv?=
 =?utf-8?B?dHRETGgzWFRSQTd1ZHVkRnJiOER6WWFMb2RJbWF1T2RzYXQ1YVd4Zmh3RkFZ?=
 =?utf-8?B?M0NTTVlTdEZmT1FDUm1KRzMwZFh1SWJGMlF2SXpJUmFCTmpEN21jWU90TTNO?=
 =?utf-8?B?OEVTa29FempFTmpYeFdFMTkxa2hrL3hSWUtrUldHZUhxVTRIZVQ4WlhwUUtn?=
 =?utf-8?B?YS92UWZzL21Fc09vRE81TXZaUngzTm93L2tqOENTdHUybUtLYzlPSFozR0NG?=
 =?utf-8?B?VkJZeTlQMHQ2MnVqUEJneFVaNDFEQ3VCdXIvb0dhYnVNcmx4Z2I3dWR2ZWFr?=
 =?utf-8?B?U3FFVHNwb3VmbWxUMUY4TFFCTURWcE1hQmxVUlZzNkJaT241OEJ3Zk5vS2tw?=
 =?utf-8?B?ZlZEU1FmY3BiaG9iUDZIS0lPK1FVTnZOSVU4L2h5bE1qaXZ3ZWYrdXBtMFVw?=
 =?utf-8?B?N2RnT3VrY0Rkc1VYM3BIamw2bDJ1TnRabHlKcXdORXhocDlnWWhBdlBuc0FJ?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09857533-95a6-4ce5-821a-08da588cd147
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 22:31:45.8792 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tff1Ajm5j5IjP8nC+pmHruh1VBM1HYz+iFkTnXnCZrfcWvUa1L/3YXcaJpJFmczORKhoOnLDiSvurI/2Snl4amoFHffRXHppNmqfZrAlNU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH][next] treewide: uapi: Replace zero-length
 arrays with flexible-array members
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
Cc: nvdimm@lists.linux.dev, alsa-devel@alsa-project.org,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-hardening@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, x86@kernel.org,
 kasan-dev@googlegroups.com, lvs-devel@vger.kernel.org, coreteam@netfilter.org,
 v9fs-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, io-uring@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-sctp@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

R3VzdGF2byBBLiBSLiBTaWx2YSB3cm90ZToKPiBUaGVyZSBpcyBhIHJlZ3VsYXIgbmVlZCBpbiB0
aGUga2VybmVsIHRvIHByb3ZpZGUgYSB3YXkgdG8gZGVjbGFyZQo+IGhhdmluZyBhIGR5bmFtaWNh
bGx5IHNpemVkIHNldCBvZiB0cmFpbGluZyBlbGVtZW50cyBpbiBhIHN0cnVjdHVyZS4KPiBLZXJu
ZWwgY29kZSBzaG91bGQgYWx3YXlzIHVzZSDigJxmbGV4aWJsZSBhcnJheSBtZW1iZXJz4oCdWzFd
IGZvciB0aGVzZQo+IGNhc2VzLiBUaGUgb2xkZXIgc3R5bGUgb2Ygb25lLWVsZW1lbnQgb3IgemVy
by1sZW5ndGggYXJyYXlzIHNob3VsZAo+IG5vIGxvbmdlciBiZSB1c2VkWzJdLgo+IAo+IFRoaXMg
Y29kZSB3YXMgdHJhbnNmb3JtZWQgd2l0aCB0aGUgaGVscCBvZiBDb2NjaW5lbGxlOgo+IChsaW51
eC01LjE5LXJjMiQgc3BhdGNoIC0tam9icyAkKGdldGNvbmYgX05QUk9DRVNTT1JTX09OTE4pIC0t
c3AtZmlsZSBzY3JpcHQuY29jY2kgLS1pbmNsdWRlLWhlYWRlcnMgLS1kaXIgLiA+IG91dHB1dC5w
YXRjaCkKPiAKPiBAQAo+IGlkZW50aWZpZXIgUywgbWVtYmVyLCBhcnJheTsKPiB0eXBlIFQxLCBU
MjsKPiBAQAo+IAo+IHN0cnVjdCBTIHsKPiAgIC4uLgo+ICAgVDEgbWVtYmVyOwo+ICAgVDIgYXJy
YXlbCj4gLSAwCj4gICBdOwo+IH07Cj4gCj4gLWZzdHJpY3QtZmxleC1hcnJheXM9MyBpcyBjb21p
bmcgYW5kIHdlIG5lZWQgdG8gbGFuZCB0aGVzZSBjaGFuZ2VzCj4gdG8gcHJldmVudCBpc3N1ZXMg
bGlrZSB0aGVzZSBpbiB0aGUgc2hvcnQgZnV0dXJlOgo+IAo+IC4uL2ZzL21pbml4L2Rpci5jOjMz
NzozOiB3YXJuaW5nOiAnc3RyY3B5JyB3aWxsIGFsd2F5cyBvdmVyZmxvdzsgZGVzdGluYXRpb24g
YnVmZmVyIGhhcyBzaXplIDAsCj4gYnV0IHRoZSBzb3VyY2Ugc3RyaW5nIGhhcyBsZW5ndGggMiAo
aW5jbHVkaW5nIE5VTCBieXRlKSBbLVdmb3J0aWZ5LXNvdXJjZV0KPiAJCXN0cmNweShkZTMtPm5h
bWUsICIuIik7Cj4gCQleCj4gCj4gU2luY2UgdGhlc2UgYXJlIGFsbCBbMF0gdG8gW10gY2hhbmdl
cywgdGhlIHJpc2sgdG8gVUFQSSBpcyBuZWFybHkgemVyby4gSWYKPiB0aGlzIGJyZWFrcyBhbnl0
aGluZywgd2UgY2FuIHVzZSBhIHVuaW9uIHdpdGggYSBuZXcgbWVtYmVyIG5hbWUuCj4gCj4gWzFd
IGh0dHBzOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL0ZsZXhpYmxlX2FycmF5X21lbWJlcgo+IFsy
XSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL3Y1LjE2L3Byb2Nlc3MvZGVwcmVjYXRl
ZC5odG1sI3plcm8tbGVuZ3RoLWFuZC1vbmUtZWxlbWVudC1hcnJheXMKPiAKPiBMaW5rOiBodHRw
czovL2dpdGh1Yi5jb20vS1NQUC9saW51eC9pc3N1ZXMvNzgKPiBCdWlsZC10ZXN0ZWQtYnk6IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvNjJiNjc1ZWMud0tYNkFPWjZjYkU3MXZ0RiUyNWxr
cEBpbnRlbC5jb20vCj4gU2lnbmVkLW9mZi1ieTogR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2
b2Fyc0BrZXJuZWwub3JnPgo+IC0tLQo+IEhpIGFsbCEKPiAKPiBKRllJOiBJJ20gYWRkaW5nIHRo
aXMgdG8gbXkgLW5leHQgdHJlZS4gOikKPiAKWy4uXQo+ICBpbmNsdWRlL3VhcGkvbGludXgvbmRj
dGwuaCAgICAgICAgICAgICAgICAgICAgfCAxMCArLS0KCkZvciBuZGN0bC5oCgpBY2tlZC1ieTog
RGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

