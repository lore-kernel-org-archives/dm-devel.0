Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001B6FA3740
	for <dm-devel@archiver.kernel.org>; Mon, 24 Oct 2022 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666631737;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ME91+BQqPMG0o2OmFO+nvY9Zt1mM0l1mFZ7N1ZtnHyU=;
	b=ORySVkUnuFsF1lAOxmDkhbROrfG6YvwCKRqOZOOOGCzJ7K8wE8y0AjmSqNt+Q3GMxDJvy2
	0/kODJNRvLRJWMLjZPdF2cx3PNyENo7eon4/msPJKuSAOvGqsX2mhG3vifTNOpBCPHGqby
	qC2ycZ20jaRKQE8guIlmY/YkKr2QUjA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-puwGzgD_Phup8SOkwc2Dlg-1; Mon, 24 Oct 2022 13:15:32 -0400
X-MC-Unique: puwGzgD_Phup8SOkwc2Dlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7620185A794;
	Mon, 24 Oct 2022 17:15:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF9A240C2089;
	Mon, 24 Oct 2022 17:15:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9CBC1194658F;
	Mon, 24 Oct 2022 17:15:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC0EA194658D
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Oct 2022 17:15:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A140E112132C; Mon, 24 Oct 2022 17:15:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98DC41121315
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 17:15:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7422B1C05ACA
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 17:15:25 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-NBdvPTc5NJGsfSbVl04ZeA-1; Mon, 24 Oct 2022 13:15:16 -0400
X-MC-Unique: NBdvPTc5NJGsfSbVl04ZeA-1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="307468274"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; d="scan'208";a="307468274"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Oct 2022 10:12:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="631334609"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; d="scan'208";a="631334609"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
 by orsmga002.jf.intel.com with ESMTP; 24 Oct 2022 10:12:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 10:12:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 10:12:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 24 Oct 2022 10:12:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 24 Oct 2022 10:12:42 -0700
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MN2PR11MB4582.namprd11.prod.outlook.com
 (2603:10b6:208:265::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 17:12:39 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83%12]) with mapi id 15.20.5746.023; Mon, 24 Oct
 2022 17:12:39 +0000
Date: Mon, 24 Oct 2022 10:12:35 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <6356c783c1813_1d2129457@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
 <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
 <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <20221023220018.GX3600936@dread.disaster.area>
In-Reply-To: <20221023220018.GX3600936@dread.disaster.area>
X-ClientProxiedBy: SJ0PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|MN2PR11MB4582:EE_
X-MS-Office365-Filtering-Correlation-Id: c6002ab9-5bde-4c3c-91df-08dab5e2f43c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 6mcT66fr236kFCHPbBb+SJuvS+oYBijY1HIxmlu0iYTPNunIELqTpd75syFM/qW94/8QSQE3hscwnUcXoAp/5C8nJgywExvWxq1H3zuJU83oYIXOEP+x4Uol5wd2fvgEoffaTvLCVn2SEnxGvriPTbAI91lK5KoYrKb+RYvBl6xpIjYSHu+EiyQ901emPJrZgAYU5ZAsD3kQ32x21jAA2ecqBcVWPvHx9RsQOhWONHfkPDWkmpiF4NVAjbNJBO00HSju21mcHLVv0mSTCtKTNcrxGV9aNcdh9D1qcKRDi2eK5xPKsZclKZJjZeFxNad5Gm1HHJuYpbHpbTd9wwAgS9IOkF6F1GzH32gMdG1Y1i18AndpafR9JeXKuDykY37KWZKdl5XujF14o7e9dn/6lH6g2yRkVyRaQsFixX9I5ebkJmb+12/bsCod6j8Fsyy6XhwaKjVVuLSi89Wr6uLxlsPgZRvgBsC/O14H3XxWnUO1E04OQ+qfOXhpDnBl2N41tuhYcWUYSVEGlo6FP2zicgdNXSixAwg1saNUjjMxeiaXIzsbe3TmPnYwP2jZjFq5tQ8AUB6iTJfrmhW6eQxzDI/G666gmzADlc7zP1MOj7NDDuEa+AP6kFr5kDq4+Rg3NZ2+EB0sI2wi6P55oYnL8NLQvdWcY7Q4PZhF35ktpLeBPn8iGBznDtkU1XUAJMr2yOasf8Svs09LWgIGymnoPpZLbvenh80fs8bt6H0EO2tXEwjX2MzCMVGEiWUhUov5Uk3+RCXY64kcw1IGGYP//g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MWHPR1101MB2126.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(66899015)(2906002)(83380400001)(41300700001)(4326008)(110136005)(8676002)(66556008)(66946007)(66476007)(86362001)(8936002)(7416002)(5660300002)(316002)(54906003)(45080400002)(186003)(6512007)(9686003)(26005)(6486002)(966005)(6506007)(478600001)(82960400001)(6666004)(38100700002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVY5VjVsZzRiSy9yQ05IUDhzMGFhUFlhUHBZS2ZPZUF5d1hRWGV4cXpjUWlk?=
 =?utf-8?B?WEJ2V0lnZmNWSTVJQ1ZTZXZ6Z0IvT2tjQWFjS2ROeGJXZ3EzMnorWDh6bHYv?=
 =?utf-8?B?N3ZVb21IMGR5aVc3SHB0WjQ4Q0RXdEc2OFAwMjlCa2dlQ01rK0pLeHpDRFRp?=
 =?utf-8?B?TnErSHFBbFNmNWxNRjNMSUIvOHpRZnlEemhsSzM3WWtsTzZVTGVqTTNzVGNr?=
 =?utf-8?B?YngyVUhQVEhEbTYvT2ZabzFiZDk0WEhWMzkzakJVamxPb1JCcXQ5dlJHYWt6?=
 =?utf-8?B?c0pPRkVzQ0RWOXlLSncrWTJ2bWVNZVBrazgyRkpoOHdLeklxM1pWbmE0NW1V?=
 =?utf-8?B?R28yUjJYdHdNZFV2SWhzQ091b00vSzhXMjlaa21VQjJ1VnlwdEJTK25oUk1P?=
 =?utf-8?B?bWpKVHpDWU40bW93d2FxejVtTkFEckZEbDZZdlp5N0NSSk9tR0lMemZlVE1D?=
 =?utf-8?B?ZkkxQXZtZDFhd0diOFdMMENUQUZHMFU2a0lLajQzS0M2ZHpYM0FYMExacEN2?=
 =?utf-8?B?eENRYjhSSDY3V052VW5BbGFCeU8vSFZJTmFmRzk3SmFoQXdwMFdoSHR3VEVL?=
 =?utf-8?B?anVuUXB5TmdqaHhzZGkrbU9TbEtnTUEvZDNBQlpJUWRvTDF3STVVMEV6MnpV?=
 =?utf-8?B?c0gxcGR2aE5zc2oxVHZQd1dENXFGMURxS3FiZWl6SjN1L1FUd3JXWWRkL0RY?=
 =?utf-8?B?MTQ0Qm11VGNaelQ1cmlSOWgvRDN4Z1V2M1p1blFWaFZPZ1lqQWRLajdBMEZj?=
 =?utf-8?B?Z0hxT3NMd2hwUyt1VjlvQWFEUnBYaWVLZllhenUzRC9rbFhrWEhZRG5RYXVH?=
 =?utf-8?B?NTljVndjdUpmOURJN3FhNm5CZFcvV1U5clNIT2ZTYnJqVnRiU1JDREtzamhU?=
 =?utf-8?B?WVNaZ1dENkdEK0pOeUpKcUFOaWp6Ui9GQVlwMDNlMWFsL3VsNFpvRnI5UXg0?=
 =?utf-8?B?RkZ6akVKUDA4MDFEVnJaLzJCaHRFZUpncHVSamk0NnZuN3JPTkcxbGNMd0d0?=
 =?utf-8?B?bzdidnM4clRmSy81dUsxMG5lSkdORXMvMHJmdjlJMDZNUFhab0hudGJkOTJz?=
 =?utf-8?B?dFErbHUyeENMdGRPSUw3TW9jNCs1Vm8ycWJjMVVaaFkzUHJSTTBReDRzUkh0?=
 =?utf-8?B?cVZnbXVJOXJabXlybnBqRWFna3daZGRWcWFwTXRUdktWYTJiKythcFU5MTVw?=
 =?utf-8?B?Ykx4M0RCcExiL2lsVVNDYWlBZEFZcEo2MlB0STVrRVNGbS9SU3dPZDdEczg3?=
 =?utf-8?B?WlZBNmZRbHo5VFdBOEZIUkZPYk5QQk84a1VUNVptS2EvZURrTk1MVVBKTEsx?=
 =?utf-8?B?SWVJN0xWTjNMZkVYUDd5OUdhT1ZweWRoVmNCT050bUhmWTVWeXk3YjU0RG5M?=
 =?utf-8?B?L3VtVWZTTGUyYmZKdzd0TExrS2pIeDdyQ256MUk5Y1hxZkpnUk9QSnJpNnRp?=
 =?utf-8?B?UHJzU1hreXplbkYvcGxPankvL0FBM3preWtNRS83YnE5eHVkVUZ4c1FjWWtV?=
 =?utf-8?B?elZxWkJ1Skkva1p3VCtlTXNhYkRKdVZJS2E3MS9Obm80K0hkWDhaWjRTVDd4?=
 =?utf-8?B?U3RDTkdrQVVrQ1hWZkFhUmdGMXBNeWljZGVteEZrd2lKRzhZeTB4dkw4eFd4?=
 =?utf-8?B?cC9KS29vc2pLVE1BZUU1Y3BjT3VMeEpiQnFjc1kxQVJHMEYvdlN4aXZ4azVQ?=
 =?utf-8?B?TEswdXVKeFVSbjR2MGVSVStVSTNCSldZTTJTRFFLVVhETld2ZGRVWTdmMTJh?=
 =?utf-8?B?amVvdnpVOGJnMlJITS9GWjc3RG92TDV3ZlV2THJWTHgwY0hZeXVRWUdtUDNF?=
 =?utf-8?B?T21FN1MwWm1uMFk0ay9IdEhNd0Vld21TRnBYQmcxK2R4aE43WkNWMm9XeE1j?=
 =?utf-8?B?RmFnd1RrRXF2Y0lFZnM5MlN6azNVaVVKZVdlU2NtMHlFU1lYU1MyS0tRQjA3?=
 =?utf-8?B?U0JjTnRBczR6WVhRWmtEaTg3WENQUDRMbVFXK25lWEF1eE9vaUZsYlhwQVFS?=
 =?utf-8?B?dzFFazEzMDY3d2ltNUhrSHdtQXV5Vy8rK1F5NVV2NkNyTFlvOVFwaUJIdTlK?=
 =?utf-8?B?cHU0ZTRUc2JBbmswbFlnWW1TcTdLTVZLRVhJaU90MjNZTzh4WkZBcWcxRURT?=
 =?utf-8?B?WTJrL29ZZ0ZQSlY2anRaQ1pMVUVoSXdIMjBWS3dDWC9HdVM0RkZNYUdHamNG?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6002ab9-5bde-4c3c-91df-08dab5e2f43c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 17:12:39.5255 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UljFVLLSrf42kQ93wkN2mXp/yaLzSaKXdCm4xOfzNsbLwn/brLFiN3teIXRRdRQm1jccnwt8tBAWRA+gc2vT6QYIpzjM5dj9cfBdVzbl1fY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4582
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] xfs: fail dax mount if reflink is enabled on
 a partition
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
Cc: "hch@infradead.org" <hch@infradead.org>, toshi.kani@hpe.com,
 dm-devel@redhat.com, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 =?utf-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?utf-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
 =?utf-8?B?R290b3UsIFlhc3Vub3JpL+S6lOWztiDlurfmloc=?= <y-goto@fujitsu.com>,
 Jeff Moyer <jmoyer@redhat.com>, zwisler@kernel.org,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RGF2ZSBDaGlubmVyIHdyb3RlOgo+IE9uIEZyaSwgT2N0IDIxLCAyMDIyIGF0IDA3OjExOjAyUE0g
LTA3MDAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToKPiA+IE9uIFRodSwgT2N0IDIwLCAyMDIyIGF0
IDEwOjE3OjQ1UE0gKzA4MDAsIFlhbmcsIFhpYW8v5p2oIOaZkyB3cm90ZToKPiA+ID4gSW4gYWRk
aXRpb24sIEkgZG9uJ3QgbGlrZSB5b3VyIGlkZWEgYWJvdXQgdGhlIHRlc3QgY2hhbmdlIGJlY2F1
c2UgaXQgd2lsbAo+ID4gPiBtYWtlIGdlbmVyaWMvNDcwIGJlY29tZSB0aGUgc3BlY2lhbCB0ZXN0
IGZvciBYRlMuIERvIHlvdSBrbm93IGlmIHdlIGNhbiBmaXgKPiA+ID4gdGhlIGlzc3VlIGJ5IGNo
YW5naW5nIHRoZSB0ZXN0IGluIGFub3RoZXIgd2F5PyBibGtkaXNjYXJkIC16IGNhbiBmaXggdGhl
Cj4gPiA+IGlzc3VlIGJlY2F1c2UgaXQgZG9lcyB6ZXJvLWZpbGwgcmF0aGVyIHRoYW4gZGlzY2Fy
ZCBvbiB0aGUgYmxvY2sgZGV2aWNlLgo+ID4gPiBIb3dldmVyLCBibGtkaXNjYXJkIC16IHdpbGwg
dGFrZSBhIGxvdCBvZiB0aW1lIHdoZW4gdGhlIGJsb2NrIGRldmljZSBpcwo+ID4gPiBsYXJnZS4K
PiA+IAo+ID4gV2VsbCB3ZSAvY291bGQvIGp1c3QgZG8gdGhhdCB0b28sIGJ1dCB0aGF0IHdpbGwg
c3VjayBpZiB5b3UgaGF2ZSAyVEIgb2YKPiA+IHBtZW0uIDspCj4gPiAKPiA+IE1heWJlIGFzIGFu
IGFsdGVybmF0aXZlIHBhdGggd2UgY291bGQganVzdCBjcmVhdGUgYSB2ZXJ5IHNtYWxsCj4gPiBm
aWxlc3lzdGVtIG9uIHRoZSBwbWVtIGFuZCB0aGVuIGJsa2Rpc2NhcmQgLXogaXQ/Cj4gPiAKPiA+
IFRoYXQgc2FpZCAtLSBkb2VzIHBlcnNpc3RlbnQgbWVtb3J5IGFjdHVhbGx5IGhhdmUgYSBmdXR1
cmU/ICBJbnRlbAo+ID4gc2N1dHRsZWQgdGhlIGVudGlyZSBPcHRhbmUgcHJvZHVjdCwgY3hsLm1l
bSBzb3VuZHMgbGlrZSBleHBhbnNpb24KPiA+IGNoYXNzaXMgZnVsbCBvZiBEUkFNLCBhbmQgZnNk
YXggaXMgaG9ycmlibHkgYnJva2VuIGluIDYuMCAod2VpcmQga2VybmVsCj4gPiBhc3NlcnRzIGV2
ZXJ5d2hlcmUpIGFuZCA2LjEgKGV2ZXJ5IHRpbWUgSSBydW4gZnN0ZXN0cyBub3cgSSBzZWUgbWFz
c2l2ZQo+ID4gZGF0YSBjb3JydXB0aW9uKS4KPiAKPiBZdXAsIEkgc2VlIHRoZSBzYW1lIHRoaW5n
LiBmc2RheCB3YXMgYSB0cmFpbiB3cmVjayBpbiA2LjAgLSBicm9rZW4KPiBvbiBib3RoIGV4dDQg
YW5kIFhGUy4gTm93IHRoYXQgSSBydW4gYSBxdWljayBjaGVjayBvbiA2LjEtcmMxLCBJCj4gZG9u
J3QgdGhpbmsgdGhhdCBoYXMgY2hhbmdlZCBhdCBhbGwgLSBJIHN0aWxsIHNlZSBsb3RzIG9mIGtl
cm5lbAo+IHdhcm5pbmdzLCBkYXRhIGNvcnJ1cHRpb24gYW5kICJYRlNfSU9DX0NMT05FX1JBTkdF
OiBJbnZhbGlkCj4gYXJndW1lbnQiIGVycm9ycy4KPiAKPiBJZiBJIHR1cm4gb2ZmIHJlZmxpbmss
IHRoZW4gaW5zdGVhZCBvZiBkYXRhIGNvcnJ1cHRpb24gSSBnZXQga2VybmVsCj4gd2FybmluZ3Mg
bGlrZSB0aGlzIGZyb20gZnN4IGFuZCBmc3N0cmVzcyB3b3JrbG9hZHM6Cj4gCj4gWzQxNTQ3OC41
NTg0MjZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQo+IFs0MTU0NzguNTYw
NTQ4XSBXQVJOSU5HOiBDUFU6IDEyIFBJRDogMTUxNTI2MCBhdCBmcy9kYXguYzozODAgZGF4X2lu
c2VydF9lbnRyeSsweDJhNS8weDMyMAo+IFs0MTU0NzguNTY0MDI4XSBNb2R1bGVzIGxpbmtlZCBp
bjoKPiBbNDE1NDc4LjU2NTQ4OF0gQ1BVOiAxMiBQSUQ6IDE1MTUyNjAgQ29tbTogZnN4IFRhaW50
ZWQ6IEcgICAgICAgIFcgNi4xLjAtcmMxLWRnYysgIzE2MTUKPiBbNDE1NDc4LjU2OTIyMV0gSGFy
ZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1Mg
MS4xNS4wLTEgMDQvMDEvMjAxNAo+IFs0MTU0NzguNTcyODc2XSBSSVA6IDAwMTA6ZGF4X2luc2Vy
dF9lbnRyeSsweDJhNS8weDMyMAo+IFs0MTU0NzguNTc0OTgwXSBDb2RlOiAwOCA0OCA4MyBjNCAz
MCA1YiA1ZCA0MSA1YyA0MSA1ZCA0MSA1ZSA0MSA1ZiBjMyA0OCA4YiA1OCAyMCA0OCA4ZCA1MyAw
MSBlOSA2NSBmZiBmZiBmZiA0OCA4YiA1OCAyMCA0OCA4ZCA1MyAwMSBlOSA1MCBmZiBmZiBmZiA8
MGY+IDBiIGU5IDcwIGZmIGZmIGZmIDMxIGY2IDRjIDg5IGU3IGU4IGRhIGVlIGE3IDAwIGViIGE0
IDQ4IDgxIGU2Cj4gWzQxNTQ3OC41ODI3NDBdIFJTUDogMDAwMDpmZmZmYzkwMDAyODY3YjcwIEVG
TEFHUzogMDAwMTAwMDIKPiBbNDE1NDc4LjU4NDczMF0gUkFYOiBmZmZmZWEwMDBmMGQwODAwIFJC
WDogMDAwMDAwMDAwMDAwMDAwMSBSQ1g6IDAwMDAwMDAwMDAwMDAwMDEKPiBbNDE1NDc4LjU4NzQ4
N10gUkRYOiBmZmZmZWEwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAzYSBSREk6IGZmZmZl
YTAwMGYwZDA4NDAKPiBbNDE1NDc4LjU5MDEyMl0gUkJQOiAwMDAwMDAwMDAwMDAwMDExIFIwODog
MDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKPiBbNDE1NDc4LjU5MjM4MF0g
UjEwOiBmZmZmODg4ODAwZGM5YzE4IFIxMTogMDAwMDAwMDAwMDAwMDAwMSBSMTI6IGZmZmZjOTAw
MDI4NjdjNTgKPiBbNDE1NDc4LjU5NDg2NV0gUjEzOiBmZmZmODg4ODAwZGM5YzE4IFIxNDogZmZm
ZmM5MDAwMjg2N2UxOCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKPiBbNDE1NDc4LjU5Njk4M10gRlM6
ICAwMDAwN2ZkNzE5ZmEyYjgwKDAwMDApIEdTOmZmZmY4ODg4M2VjMDAwMDAoMDAwMCkga25sR1M6
MDAwMDAwMDAwMDAwMDAwMAo+IFs0MTU0NzguNTk5MzY0XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6
IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzCj4gWzQxNTQ3OC42MDA5MDVdIENSMjogMDAwMDdm
ZDcxYTFhZDY0MCBDUjM6IDAwMDAwMDA1Y2YyNDEwMDYgQ1I0OiAwMDAwMDAwMDAwMDYwZWUwCj4g
WzQxNTQ3OC42MDI4ODNdIENhbGwgVHJhY2U6Cj4gWzQxNTQ3OC42MDM1OThdICA8VEFTSz4KPiBb
NDE1NDc4LjYwNDIyOV0gIGRheF9mYXVsdF9pdGVyKzB4MjQwLzB4NjAwCj4gWzQxNTQ3OC42MDU0
MTBdICBkYXhfaW9tYXBfcHRlX2ZhdWx0KzB4MTljLzB4M2QwCj4gWzQxNTQ3OC42MDY3MDZdICBf
X3hmc19maWxlbWFwX2ZhdWx0KzB4MWRkLzB4MmIwCj4gWzQxNTQ3OC42MDc3NDRdICBfX2RvX2Zh
dWx0KzB4MmUvMHgxZDAKPiBbNDE1NDc4LjYwODU4N10gIF9faGFuZGxlX21tX2ZhdWx0KzB4Y2Vj
LzB4MTdiMAo+IFs0MTU0NzguNjA5NTkzXSAgaGFuZGxlX21tX2ZhdWx0KzB4ZDAvMHgyYTAKPiBb
NDE1NDc4LjYxMDUxN10gIGV4Y19wYWdlX2ZhdWx0KzB4MWQ5LzB4ODEwCj4gWzQxNTQ3OC42MTEz
OThdICBhc21fZXhjX3BhZ2VfZmF1bHQrMHgyMi8weDMwCj4gWzQxNTQ3OC42MTIzMTFdIFJJUDog
MDAzMzoweDdmZDcxYTA0YjliYQo+IFs0MTU0NzguNjEzMTY4XSBDb2RlOiA0ZCAyOSBjMSA0YyAy
OSBjMiA0OCAzYiAxNSBkYiA5NSAxMSAwMCAwZiA4NyBhZiAwMCAwMCAwMCAwZiAxMCAwMSAwZiAx
MCA0OSBmMCAwZiAxMCA1MSBlMCAwZiAxMCA1OSBkMCA0OCA4MyBlOSA0MCA0OCA4MyBlYSA0MCA8
NDE+IDBmIDI5IDAxIDQxIDBmIDI5IDQ5IGYwIDQxIDBmIDI5IDUxIGUwIDQxIDBmIDI5IDU5IGQw
IDQ5IDgzIGU5Cj4gWzQxNTQ3OC42MTcwODNdIFJTUDogMDAyYjowMDAwN2ZmY2YyNzdiZTE4IEVG
TEFHUzogMDAwMTAyMDYKPiBbNDE1NDc4LjYxODIxM10gUkFYOiAwMDAwN2ZkNzFhMWEzZmM1IFJC
WDogMDAwMDAwMDAwMDAwMGZjNSBSQ1g6IDAwMDA3ZmQ3MTlmNWE2MTAKPiBbNDE1NDc4LjYxOTg1
NF0gUkRYOiAwMDAwMDAwMDAwMDA5NjRiIFJTSTogMDAwMDdmZDcxOWY1MGZkNSBSREk6IDAwMDA3
ZmQ3MWExYTNmYzUKPiBbNDE1NDc4LjYyMTI4Nl0gUkJQOiAwMDAwMDAwMDAwMDMwZmM1IFIwODog
MDAwMDAwMDAwMDAwMDAwZSBSMDk6IDAwMDA3ZmQ3MWExYWQ2NDAKPiBbNDE1NDc4LjYyMjczMF0g
UjEwOiAwMDAwMDAwMDAwMDAwMDAxIFIxMTogMDAwMDdmZDcxYTFhZDY0ZSBSMTI6IDAwMDAwMDAw
MDAwMDk2OTkKPiBbNDE1NDc4LjYyNDE2NF0gUjEzOiAwMDAwMDAwMDAwMDBhNjVlIFIxNDogMDAw
MDdmZDcxYTFhMzAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDEKPiBbNDE1NDc4LjYyNTYwMF0gIDwv
VEFTSz4KPiBbNDE1NDc4LjYyNjA4N10gLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBd
LS0tCj4gCj4gRXZlbiBnZW5lcmljLzI0NyBpcyBnZW5lcmF0aW5nIGEgd2FybmluZyBsaWtlIHRo
aXMgZnJvbSB4ZnNfaW8sCj4gd2hpY2ggaXMgYSBtbWFwIHZzIERJTyByYWNlci4gR2l2ZW4gdGhh
dCBESU8gZG9lc24ndCBleGlzdCBmb3IKPiBmc2RheCwgdGhpcyB0ZXN0IHR1cm5zIGludG8ganVz
dCBhIG5vcm1hbCB3cml0ZSgpIHZzIG1tYXAoKSByYWNlci4KPiAKPiBHaXZlbiB0aGVzZSBhcmUg
dGhlIHNhbWUgZnNkYXggaW5mcmFzdHJ1Y3R1cmUgZmFpbHVyZXMgdGhhdCBJCj4gcmVwb3J0ZWQg
Zm9yIDYuMCwgaXQgaXMgYWxzbyBsaWtlbHkgdGhhdCBleHQ0IGlzIHN0aWxsIHRocm93aW5nCj4g
dGhlbS4gSU9Xcywgd2hhdGV2ZXIgZ290IGJyb2tlIGluIHRoZSA2LjAgY3ljbGUgd2Fzbid0IGZp
eGVkIGluIHRoZQo+IDYuMSBjeWNsZS4KPiAKPiA+IEZyYW5rbHkgYXQgdGhpcyBwb2ludCBJJ20g
dGVtcHRlZCBqdXN0IHRvIHR1cm4gb2YgZnNkYXggc3VwcG9ydCBmb3IgWEZTCj4gPiBmb3IgdGhl
IDYuMSBMVFMgYmVjYXVzZSBJIGRvbid0IGhhdmUgdGltZSB0byBmaXggaXQuCj4gCj4gL21lIHNo
cnVncwo+IAo+IEJhY2twb3J0aW5nIGZpeGVzICh3aGVuZXZlciB0aGV5IGNvbWUgYWxvbmcpIGlz
IGEgcHJvYmxlbSBmb3IgdGhlCj4gTFRTIGtlcm5lbCBtYWludGFpbmVyIHRvIGRlYWwgd2l0aCwg
bm90IHRoZSB1cHN0cmVhbSBtYWludGFpbmVyLgo+IAo+IElNTywgdGhlIGlzc3VlIHJpZ2h0IG5v
dyBpcyB0aGF0IHRoZSBEQVggbWFpbnRhaW5lcnMgc2VlbSB0byBoYXZlCj4gbGl0dGxlIGludGVy
ZXN0IGluIGVuc3VyaW5nIHRoYXQgdGhlIEZTREFYIGluZnJhc3RydWN0dXJlIGFjdHVhbGx5Cj4g
d29ya3MgY29ycmVjdGx5LiBJZiBhbnl0aGluZywgdGhleSBzZWVtIHRvIHdhbnQgdG8gbWFrZSB0
aGluZ3MKPiBoYXJkZXIgZm9yIGJsb2NrIGJhc2VkIGZpbGVzeXN0ZW1zIHRvIHVzZSBwbWVtIGRl
dmljZXMgYW5kIGhlbmNlCj4gRlNEQVguIGUuZy4gdGhlIGRpcmVjdGlvbiBvZiB0aGUgREFYIGNv
cmUgYXdheSBmcm9tIGJsb2NrIGludGVyZmFjZXMKPiB0aGF0IGZpbGVzeXN0ZW1zIG5lZWQgZm9y
IHRoZWlyIHVzZXJzcGFjZSB0b29scyB0byBtYW5hZ2UgdGhlCj4gc3RvcmFnZS4KPiAKPiBBdCB3
aGF0IHBvaW50IGRvIHdlIHNpbXBseSBzYXkgInRoZSBleHBlcmltZW50IGZhaWxlZCwgRlNEQVgg
aXMKPiBkZWFkIiBhbmQgcmVtb3ZlIGl0IGZyb20gWEZTIGFsdG9nZXRoZXI/CgpBIGZhaXIgcXVl
c3Rpb24sIGdpdmVuIHRoZSByZWdyZXNzaW9ucyBtYWRlIGl0IGFsbCB0aGUgd2F5IGludG8KdjYu
MC1maW5hbC4gSW4gcmV0cm9zcGVjdCBJIG1hZGUgdGhlIHdyb25nIHByaW9yaXR5IGNhbGwgdG8g
Zm9jdXMgb24gZGF4CnBhZ2UgcmVmZXJlbmNlIGNvdW50aW5nIHRoZXNlIHBhc3Qgd2Vla3MuCgpX
aGVuIEkgZmlyZWQgdXAgdGhlIGRheCB1bml0IHRlc3RzIG9uIHY2LjAtcmMxIEkgZm91bmQgYmFz
aWMgcHJvYmxlbXMKd2l0aCB0aGUgbm90aWZ5IGZhaWx1cmUgcGF0Y2hlcyB0aGF0IGNvbmNlcm5l
ZCBtZSB0aGF0IHRoZXkgaGFkIG5ldmVyCmJlZW4gdGVzdGVkIGFmdGVyIHRoZSBmaW5hbCB2ZXJz
aW9uIHdhcyBtZXJnZWQgWzFdLiBUaGVuIHRoZSByZXN0IG9mIHRoZQpkZXZlbG9wbWVudCBjeWNs
ZSB3YXMgc3BlbnQgZml4aW5nIGRheCByZWZlcmVuY2UgY291bnRpbmcgWzJdLiBUaGF0IHdhcwph
IGxvbmdzdGFuZGluZyB3aXNobGlzdCBpdGVtIGZyb20gZ3VwIGFuZCBmb2xpbyBkZXZlbG9wZXJz
LCBidXQsIGFzIEkKc2FpZCwgdGhhdCBzZWVtcyB0aGUgd3JvbmcgcHJpb3JpdHkgZ2l2ZW4gdGhl
IGxpbmdlcmluZyByZWdyZXNzaW9ucy4gSQp3aWxsIHRha2UgYSBsb29rIHRoZSBjdXJyZW50IGRh
eC14ZnN0ZXN0cyByZWdyZXNzaW9uIGJhY2tsb2cuIFRoYXQgbWF5CmZpbmQgYSBuZWVkIHRvIGNv
bnNpZGVyIHJldmVydGluZyB0aGUgcHJvYmxlbWF0aWMgY29tbWl0cyBkZXBlbmRpbmcgb24Kd2hh
dCBpcyBzdGlsbCBicm9rZW4gaWYgdGhlIGZpeGVzIGFyZSB0cmVuZGluZyB0b3dhcmRzIGJlaW5n
IGludmFzaXZlLgoKWzFdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMTY2MTUzNDI2Nzk4
LjI3NTgyMDEuMTUxMDgyMTE5ODEwMzQ1MTI5OTMuc3RnaXRAZHdpbGxpYTIteGZoLmpmLmludGVs
LmNvbS8KClsyXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzE2NjU3OTE4MTU4NC4yMjM2
NzEwLjE3ODEzNTQ3NDg3MTgzOTgzMjczLnN0Z2l0QGR3aWxsaWEyLXhmaC5qZi5pbnRlbC5jb20v
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

