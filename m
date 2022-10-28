Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BEDFA373D
	for <dm-devel@archiver.kernel.org>; Fri, 28 Oct 2022 01:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666921080;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I2lB68+jqCVGlnEBG9Gio89EfWgKsDzRO1UW2XzUjEE=;
	b=U9CljuSeNNhglmymNNoc528wKzeDIo8bL8lroQ7PgpLe3+1frNOxr2gEINIehjFFHV7abs
	AwDCXP9omNseWDyEvnzL2+4Fj6HVwo4wNA20eE7yVMxnAUvL/aF5URspcjAr/2Fj5IJrMh
	7LsSNc8OHU3iMpJQmBlkj15FYnmM5qU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-8lLbzP7sPDK6TbWEy5p0eQ-1; Thu, 27 Oct 2022 21:37:57 -0400
X-MC-Unique: 8lLbzP7sPDK6TbWEy5p0eQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 814DF380391D;
	Fri, 28 Oct 2022 01:37:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3910140C6EC3;
	Fri, 28 Oct 2022 01:37:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B88019465A4;
	Fri, 28 Oct 2022 01:37:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 157581946597
 for <dm-devel@listman.corp.redhat.com>; Fri, 28 Oct 2022 01:37:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 076A940C2086; Fri, 28 Oct 2022 01:37:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F330C40C206B
 for <dm-devel@redhat.com>; Fri, 28 Oct 2022 01:37:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD4E0185A7A3
 for <dm-devel@redhat.com>; Fri, 28 Oct 2022 01:37:51 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-f30Tz8rFOfeeVv_pNShqxQ-1; Thu, 27 Oct 2022 21:37:48 -0400
X-MC-Unique: f30Tz8rFOfeeVv_pNShqxQ-1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="305994812"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; d="scan'208";a="305994812"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Oct 2022 18:37:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="807660484"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; d="scan'208";a="807660484"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
 by orsmga005.jf.intel.com with ESMTP; 27 Oct 2022 18:37:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:37:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:37:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 18:37:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 18:37:43 -0700
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB4724.namprd11.prod.outlook.com
 (2603:10b6:5:2ad::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 01:37:36 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83%12]) with mapi id 15.20.5746.023; Fri, 28 Oct
 2022 01:37:36 +0000
Date: Thu, 27 Oct 2022 18:37:33 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>, "ruansy.fnst@fujitsu.com"
 <ruansy.fnst@fujitsu.com>
Message-ID: <635b325d25889_6be129446@dwillia2-xfh.jf.intel.com.notmuch>
References: <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <20221023220018.GX3600936@dread.disaster.area>
 <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20221024053109.GY3600936@dread.disaster.area>
 <dd00529c-d3ef-40e3-9dea-834c5203e3df@fujitsu.com>
 <Y1gjQ4wNZr3ve2+K@magnolia> <Y1rzZN0wgLcie47z@magnolia>
In-Reply-To: <Y1rzZN0wgLcie47z@magnolia>
X-ClientProxiedBy: BY3PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:a03:255::31) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM6PR11MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: ddb00ee4-d898-42cd-2289-08dab884fde9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: tizIrgwnhXDWqhz4bX2FCuDtvSky/MGbUGL8dB/gjC8jUviEVY0nNrH+ZkYocaOWlun/lGYd6QnN4HqOSPhjkr6noc77Q9EVi6TCOPjuG1PjvXE+JLU6Spax2FZeohBSFFD+k4YMl9S9Hu5eau9hXWQTzTB5Exo4VBsjBrr32E5Tm+6px7XMyrDR1XPuP8sspewsuzcFBfo7YDyxcOweVWRQbywPcP10X03S8eN4QCf7gANmOJ4nxPmNM02cOoA1xtmUrtSee3b6V/RcFzxQDykd7pYoQ48CkE/7gp21C8bwhe4TNE8f8ewYKpgYuS2YLYLeFkKpcG1fnNsMqmJ/iTJqPCAI4miMkH5ySQDzaTIT9hz1Kfp/bIV3vqhH3zP9j3EZFwlD8ILbnkv8drKspDuMq7COXU6VcfVmAp3r3Pwr+R+mDPwnFMsKskobEMS9tA5kCq3FPrnFGjyVCsPeitLBOMJu3mDibbpYtJx/cAFySQljGZwBgX/9awsnfw6oBCWr92eVjLeq3q51LgmK/wUpyR+b9gab3/WcENk2q1ucdpbSF/mM89JZEtM8J/UrmFpUMshpyeDDb61eD3R9/34xFMzScDCIWDiQLridAI9C2+v+Jc79Z67ULdwkS7gs95eSRpG6wAumvuPyNiB0kFrIzo+v6OBONl6p4TxtLG6Y2ZPJhFLZfRjakIaPebCPBcXGbz3KRx2qBD2fG897Z/q0Cbu/Agr3dusVWcNKRuMm7i91efw2O4wiT47PK2ftd45kMG8qksNLpRrtstjhYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MWHPR1101MB2126.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199015)(66556008)(316002)(38100700002)(41300700001)(83380400001)(6666004)(86362001)(54906003)(110136005)(66946007)(5660300002)(26005)(6512007)(2906002)(186003)(4326008)(7416002)(8936002)(6506007)(9686003)(8676002)(66476007)(478600001)(966005)(6486002)(66899015)(82960400001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXlhT0ZabC9XNWNOVGpnYjRSemRIK21XeXpObk9ScHczbWpqeWw4VElRV1da?=
 =?utf-8?B?aktUMWlveklPTFZIUUlQZ1J3SEJTcmZMM2pyNWVJeWcyMVFQYnoweTI2VkRH?=
 =?utf-8?B?V2lvOXVVYnRhWm81UWxkNG8xZUF5WkgvRlo3bWhBT016ZTV3dGhOSFhIcTBL?=
 =?utf-8?B?eG13cGVCdnR2WkJKWVpJMUtna0lYenFYYmtsOHVNOXQwTkphZS9nelFFZ3lw?=
 =?utf-8?B?b2RSbEVkR285UzVKclB1L2Q2RXdPTEVLbkZhM0ZpS01nNGZUdEUyUWNsM0Zo?=
 =?utf-8?B?SXJKdnVVcUZHUFNLMThiYzRLdTV5NzNENFVGdEJTQ1B4ZnJJQ01QOHVPK1By?=
 =?utf-8?B?anY3VEpDSFN2Y3RJQ2VTVTU2RlhnRjBUWGlNV2lSaVFnc1l0YUgvM1ozQ2Fw?=
 =?utf-8?B?S1BLTno3eUZQTGJadExjd2NGb3VtamZjSlZ1WndtZ1hMcksxTDBvcE1XME56?=
 =?utf-8?B?cFVpMjZkWTBkekh5RXRYOUhrUW1UdGx2NG1lSU5SeGk3OG00OENKM1pydTJX?=
 =?utf-8?B?T1BONldOOHdhMmdDeFhMTThYRVFsNTMyUktOSzdpenNyNk5DcnJYSkNrWWs2?=
 =?utf-8?B?OTRtN21PM0VvVW5Ecm1abVFSWkNVdStBWlBPdFY0Y2htblp6UlM4TktqT1VF?=
 =?utf-8?B?citZWXJ6TzI1YVVGNTJsQXJhWURjV05icE45blN0R1YxaXNLSk5XejFWdGVj?=
 =?utf-8?B?UER6cWIwaGpJdWVRSjhMaEZUa3lUZVQ5aXZEMTloNVFLSWh0ZWkxTHF5dWRO?=
 =?utf-8?B?T21veTBVK0xCOS81V3dNWFlySS9qVE0vZTU4cEk2TXpWdVFTQTZaLzBYaCt4?=
 =?utf-8?B?TXFhOW5IK21NbU9PRXBJZDBkN3ZyZHFqeFJOOGEyZm9rVjllZzZKanRvQnNF?=
 =?utf-8?B?MGdxaEZ2VldMOTl2V25SdXk5NDdxT2xJZkxPUXlRa2k0WWRLa2FTUjNqekQ1?=
 =?utf-8?B?cS92SXJENnRlcUpiRFNjWFp4N2VLT3VKVy95b1ozVVM5dWN2ZmpWMlgvSzVp?=
 =?utf-8?B?SjRCcDVvOHFiVlpoNTY1K21GeVl0c1RzRVRuZnpCQWFzeWtyNTZwYi9BZ1Bj?=
 =?utf-8?B?amErZk44TEprSm1vSmkvMEpONm45UFZkcHh2K3hRa2s3YzZIMUozRHNQR1RJ?=
 =?utf-8?B?bmNyMFgrejBMcFpyM2poRE1PMG8wZWFjQ1FFeGtQTUF0eHNybDFxYmdYenNW?=
 =?utf-8?B?akZQZllEMjR1cjJaMXFrQnQ0RlUxYi9XQjdGQjh2SVo5bFlzV3J4cktaVnpJ?=
 =?utf-8?B?WFhJcEZraC8weXROdDQrZ3J6US83VmR2U0g4MFB2K2xneC9vdWEvbFdsMmVQ?=
 =?utf-8?B?Z0k1ZHVUUHhSaDlVTlBHT1d2SURWRzR2ZmQwdzNUS1ZZTDhpUmdWdDllVHpl?=
 =?utf-8?B?bGRuN1JscFNCZzlXakNEOXBBYXNXWG1pSkNTY05ieVNPU210cFRyc0VkeXJ5?=
 =?utf-8?B?S3orNUlGU2VsZWtWd1VoQlRlSllKQ1lZNENYOVpjMTRFclRsQ2Q1MmNNLzI4?=
 =?utf-8?B?UFh2TjhSQmp4WlhpUURPemtoSVYwRThJU01ZWWI3eDJ6Nm95djRUWDdadUZl?=
 =?utf-8?B?aE93UFBqQVZQZ25wZ1ZQK3hrdWFGbSt5ZVNJV1Bwbks4YXZUc2ZQN2J0OGhO?=
 =?utf-8?B?SUQ2RkYrK1U3R1NoVmlUd2lYWUF0VXFmQUpJVnBpMkdTcFV1TjF0Rmh3Y1Ex?=
 =?utf-8?B?OUlWdytlMzZJeTQ2NWIrNHZuV202OWl5UzM4ZlUzdHIyalIzcGNtNlVsQVhJ?=
 =?utf-8?B?U1lJWFY3SC8rend3UFdJNWNaTlRad1pFdFpBRWhkOEsyM2VaMGF1NHpSTmpF?=
 =?utf-8?B?TExSWS9nK3RjL05GTmorbnNnUTJnUzY0MndqQWlDckFuYWN2WEpIdUVSZzRn?=
 =?utf-8?B?K2ppamdMQWxsVi9QclJoZDhRSGNCckwvbjFrRWRTYVBVN2o3SVkyYk9CYjkz?=
 =?utf-8?B?Y0YrcW9kMFczbDRoNlptUmdVSE9wV3l3VmZRclE2TFY0WXYyclB0Q2tXd1NQ?=
 =?utf-8?B?TlVJWXJIbGpKMnBJYTF5V25tYmMwY01BcnZ5Z21IMC95TkZVTWxxS0R5d0FS?=
 =?utf-8?B?TER3dStPRkVTdEdoRUpkbVNpaE9DSEI5YS9IMjRnNjVpdzFDVVdYbnVDQkZB?=
 =?utf-8?B?NmhQdlg5aWt5bndQYjFMYVo2ampWZUg2YUNIeGoxZjhGZVB6U1Z0UkRqMDBV?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb00ee4-d898-42cd-2289-08dab884fde9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 01:37:36.4579 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9TNKJ+HZQkeJ0CUxUHeA70N4rSe8+3/AmqzuxsnJj/dtadjNQOf7gSER9BrOaGI59Mu2tx1R24S3HOyLKHrE0zADRitPKKNBkjffXC2OkTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4724
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
Cc: "hch@infradead.org" <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>,
 "toshi.kani@hpe.com" <toshi.kani@hpe.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
 Dave Chinner <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yasunori Gotou \(Fujitsu\)" <y-goto@fujitsu.com>,
 Jeff Moyer <jmoyer@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RGFycmljayBKLiBXb25nIHdyb3RlOgo+IFthZGQgdHl0c28gdG8gY2Mgc2luY2UgaGUgYXNrZWQg
YWJvdXQgIkhvdyBkbyB5b3UgYWN0dWFsbHkgL2dldC8gZnNkYXgKPiBtb2RlIHRoZXNlIGRheXM/
IiB0aGlzIG1vcm5pbmddCj4gCj4gT24gVHVlLCBPY3QgMjUsIDIwMjIgYXQgMTA6NTY6MTlBTSAt
MDcwMCwgRGFycmljayBKLiBXb25nIHdyb3RlOgo+ID4gT24gVHVlLCBPY3QgMjUsIDIwMjIgYXQg
MDI6MjY6NTBQTSArMDAwMCwgcnVhbnN5LmZuc3RAZnVqaXRzdS5jb20gd3JvdGU6Cj4gPiA+IAo+
ID4gPiAKPiA+ID4g5ZyoIDIwMjIvMTAvMjQgMTM6MzEsIERhdmUgQ2hpbm5lciDlhpnpgZM6Cj4g
PiA+ID4gT24gTW9uLCBPY3QgMjQsIDIwMjIgYXQgMDM6MTc6NTJBTSArMDAwMCwgcnVhbnN5LmZu
c3RAZnVqaXRzdS5jb20gd3JvdGU6Cj4gPiA+ID4+IOWcqCAyMDIyLzEwLzI0IDY6MDAsIERhdmUg
Q2hpbm5lciDlhpnpgZM6Cj4gPiA+ID4+PiBPbiBGcmksIE9jdCAyMSwgMjAyMiBhdCAwNzoxMTow
MlBNIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4gPiA+ID4+Pj4gT24gVGh1LCBPY3Qg
MjAsIDIwMjIgYXQgMTA6MTc6NDVQTSArMDgwMCwgWWFuZywgWGlhby/mnagg5pmTIHdyb3RlOgo+
ID4gPiA+Pj4+PiBJbiBhZGRpdGlvbiwgSSBkb24ndCBsaWtlIHlvdXIgaWRlYSBhYm91dCB0aGUg
dGVzdCBjaGFuZ2UgYmVjYXVzZSBpdCB3aWxsCj4gPiA+ID4+Pj4+IG1ha2UgZ2VuZXJpYy80NzAg
YmVjb21lIHRoZSBzcGVjaWFsIHRlc3QgZm9yIFhGUy4gRG8geW91IGtub3cgaWYgd2UgY2FuIGZp
eAo+ID4gPiA+Pj4+PiB0aGUgaXNzdWUgYnkgY2hhbmdpbmcgdGhlIHRlc3QgaW4gYW5vdGhlciB3
YXk/IGJsa2Rpc2NhcmQgLXogY2FuIGZpeCB0aGUKPiA+ID4gPj4+Pj4gaXNzdWUgYmVjYXVzZSBp
dCBkb2VzIHplcm8tZmlsbCByYXRoZXIgdGhhbiBkaXNjYXJkIG9uIHRoZSBibG9jayBkZXZpY2Uu
Cj4gPiA+ID4+Pj4+IEhvd2V2ZXIsIGJsa2Rpc2NhcmQgLXogd2lsbCB0YWtlIGEgbG90IG9mIHRp
bWUgd2hlbiB0aGUgYmxvY2sgZGV2aWNlIGlzCj4gPiA+ID4+Pj4+IGxhcmdlLgo+ID4gPiA+Pj4+
Cj4gPiA+ID4+Pj4gV2VsbCB3ZSAvY291bGQvIGp1c3QgZG8gdGhhdCB0b28sIGJ1dCB0aGF0IHdp
bGwgc3VjayBpZiB5b3UgaGF2ZSAyVEIgb2YKPiA+ID4gPj4+PiBwbWVtLiA7KQo+ID4gPiA+Pj4+
Cj4gPiA+ID4+Pj4gTWF5YmUgYXMgYW4gYWx0ZXJuYXRpdmUgcGF0aCB3ZSBjb3VsZCBqdXN0IGNy
ZWF0ZSBhIHZlcnkgc21hbGwKPiA+ID4gPj4+PiBmaWxlc3lzdGVtIG9uIHRoZSBwbWVtIGFuZCB0
aGVuIGJsa2Rpc2NhcmQgLXogaXQ/Cj4gPiA+ID4+Pj4KPiA+ID4gPj4+PiBUaGF0IHNhaWQgLS0g
ZG9lcyBwZXJzaXN0ZW50IG1lbW9yeSBhY3R1YWxseSBoYXZlIGEgZnV0dXJlPyAgSW50ZWwKPiA+
ID4gPj4+PiBzY3V0dGxlZCB0aGUgZW50aXJlIE9wdGFuZSBwcm9kdWN0LCBjeGwubWVtIHNvdW5k
cyBsaWtlIGV4cGFuc2lvbgo+ID4gPiA+Pj4+IGNoYXNzaXMgZnVsbCBvZiBEUkFNLCBhbmQgZnNk
YXggaXMgaG9ycmlibHkgYnJva2VuIGluIDYuMCAod2VpcmQga2VybmVsCj4gPiA+ID4+Pj4gYXNz
ZXJ0cyBldmVyeXdoZXJlKSBhbmQgNi4xIChldmVyeSB0aW1lIEkgcnVuIGZzdGVzdHMgbm93IEkg
c2VlIG1hc3NpdmUKPiA+ID4gPj4+PiBkYXRhIGNvcnJ1cHRpb24pLgo+ID4gPiA+Pj4KPiA+ID4g
Pj4+IFl1cCwgSSBzZWUgdGhlIHNhbWUgdGhpbmcuIGZzZGF4IHdhcyBhIHRyYWluIHdyZWNrIGlu
IDYuMCAtIGJyb2tlbgo+ID4gPiA+Pj4gb24gYm90aCBleHQ0IGFuZCBYRlMuIE5vdyB0aGF0IEkg
cnVuIGEgcXVpY2sgY2hlY2sgb24gNi4xLXJjMSwgSQo+ID4gPiA+Pj4gZG9uJ3QgdGhpbmsgdGhh
dCBoYXMgY2hhbmdlZCBhdCBhbGwgLSBJIHN0aWxsIHNlZSBsb3RzIG9mIGtlcm5lbAo+ID4gPiA+
Pj4gd2FybmluZ3MsIGRhdGEgY29ycnVwdGlvbiBhbmQgIlhGU19JT0NfQ0xPTkVfUkFOR0U6IElu
dmFsaWQKPiA+ID4gPj4+IGFyZ3VtZW50IiBlcnJvcnMuCj4gPiA+ID4+Cj4gPiA+ID4+IEZpcnN0
bHksIEkgdGhpbmsgdGhlICJYRlNfSU9DX0NMT05FX1JBTkdFOiBJbnZhbGlkIGFyZ3VtZW50IiBl
cnJvciBpcwo+ID4gPiA+PiBjYXVzZWQgYnkgdGhlIHJlc3RyaWN0aW9ucyB3aGljaCBwcmV2ZW50
IHJlZmxpbmsgd29yayB0b2dldGhlciB3aXRoIERBWDoKPiA+ID4gPj4KPiA+ID4gPj4gYS4gZnMv
eGZzL3hmc19pb2N0bC5jOjExNDEKPiA+ID4gPj4gLyogRG9uJ3QgYWxsb3cgdXMgdG8gc2V0IERB
WCBtb2RlIGZvciBhIHJlZmxpbmtlZCBmaWxlIGZvciBub3cuICovCj4gPiA+ID4+IGlmICgoZmEt
PmZzeF94ZmxhZ3MgJiBGU19YRkxBR19EQVgpICYmIHhmc19pc19yZWZsaW5rX2lub2RlKGlwKSkK
PiA+ID4gPj4gICAgICAgICAgcmV0dXJuIC1FSU5WQUw7Cj4gPiA+ID4+Cj4gPiA+ID4+IGIuIGZz
L3hmcy94ZnNfaW9wcy5jOjExNzQKPiA+ID4gPj4gLyogT25seSBzdXBwb3J0ZWQgb24gbm9uLXJl
ZmxpbmtlZCBmaWxlcy4gKi8KPiA+ID4gPj4gaWYgKHhmc19pc19yZWZsaW5rX2lub2RlKGlwKSkK
PiA+ID4gPj4gICAgICAgICAgcmV0dXJuIGZhbHNlOwo+ID4gPiA+Pgo+ID4gPiA+PiBUaGVzZSBy
ZXN0cmljdGlvbnMgd2VyZSByZW1vdmVkIGluICJkcm9wIGV4cGVyaW1lbnRhbCB3YXJuaW5nIiBw
YXRjaFsxXS4KPiA+ID4gPj4gICAgSSB0aGluayB0aGV5IHNob3VsZCBiZSBzZXBhcmF0ZWQgZnJv
bSB0aGF0IHBhdGNoLgo+ID4gPiA+Pgo+ID4gPiA+PiBbMV0KPiA+ID4gPj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgteGZzLzE2NjMyMzQwMDItMTctMS1naXQtc2VuZC1lbWFpbC1ydWFu
c3kuZm5zdEBmdWppdHN1LmNvbS8KPiA+ID4gPj4KPiA+ID4gPj4KPiA+ID4gPj4gU2Vjb25kbHks
IGhvdyB0aGUgZGF0YSBjb3JydXB0aW9uIGhhcHBlbmVkPwo+ID4gPiA+IAo+ID4gPiA+IE5vIGlk
ZWEgLSBpIm0ganVzdCByZXBvcnRpbmcgdGhhdCBsb3RzIG9mIGZzeCB0ZXN0cyBmYWlsZWQgd2l0
aCBkYXRhCj4gPiA+ID4gY29ycnVwdGlvbnMuIEkgaGF2ZW4ndCBoYWQgdGltZSB0byBsb29rIGF0
IHdoeSwgSSdtIHN0aWxsIHRyeWluZyB0bwo+ID4gPiA+IHNvcnQgb3V0IHRoZSBmaXggZm9yIGEg
ZGlmZmVyZW50IGRhdGEgY29ycnVwdGlvbi4uLgo+ID4gPiA+IAo+ID4gPiA+PiBPciB3aGljaCBj
YXNlIGZhaWxlZD8KPiA+ID4gPiAKPiA+ID4gPiAqbG90cyogb2YgdGhlbSBmYWlsZWQgd2l0aCBr
ZXJuZWwgd2FybmluZ3Mgd2l0aCByZWZsaW5rIHR1cm5lZCBvZmY6Cj4gPiA+ID4gCj4gPiA+ID4g
U0VDVElPTiAgICAgICAtLSB4ZnNfZGF4X25vcmVmbGluawo+ID4gPiA+ID09PT09PT09PT09PT09
PT09PT09PT09PT0KPiA+ID4gPiBGYWlsdXJlczogZ2VuZXJpYy8wNTEgZ2VuZXJpYy8wNjggZ2Vu
ZXJpYy8wNzUgZ2VuZXJpYy8wODMKPiA+ID4gPiBnZW5lcmljLzExMiBnZW5lcmljLzEyNyBnZW5l
cmljLzE5OCBnZW5lcmljLzIzMSBnZW5lcmljLzI0Nwo+ID4gPiA+IGdlbmVyaWMvMjY5IGdlbmVy
aWMvMjcwIGdlbmVyaWMvMzQwIGdlbmVyaWMvMzQ0IGdlbmVyaWMvMzg4Cj4gPiA+ID4gZ2VuZXJp
Yy80NjEgZ2VuZXJpYy80NzEgZ2VuZXJpYy80NzYgZ2VuZXJpYy81MTkgZ2VuZXJpYy81NjEgeGZz
LzAxMQo+ID4gPiA+IHhmcy8wMTMgeGZzLzA3MyB4ZnMvMjk3IHhmcy8zMDUgeGZzLzUxNyB4ZnMv
NTM4Cj4gPiA+ID4gRmFpbGVkIDI2IG9mIDEwNzkgdGVzdHMKPiA+ID4gPiAKPiA+ID4gPiBBbGwg
b2YgdGhvc2UgZXhjZXB0IHhmcy8wNzMgYW5kIGdlbmVyaWMvNDcxIGFyZSBmYWlsdXJlcyBkdWUg
dG8KPiA+ID4gPiB3YXJuaW5ncyBmb3VuZCBpbiBkbWVzZy4KPiA+ID4gPiAKPiA+ID4gPiBXaXRo
IHJlZmxpbmsgZW5hYmxlZCwgSSB0ZXJtaW5hdGVkIHRoZSBydW4gYWZ0ZXIgZy8wNzUsIGcvMDkx
LCBnLzExMgo+ID4gPiA+IGFuZCBnZW5lcmljLzEyNyByZXBvcnRlZCBmc3ggZGF0YSBjb3JydXB0
aW9ucyBhbmQgZy8wNTEsIGcvMDY4LAo+ID4gPiA+IGcvMDc1IGFuZCBnLzA4MyBoYWQgcmVwb3J0
ZWQga2VybmVsIHdhcm5pbmdzIGluIGRtZXNnLgo+ID4gPiA+IAo+ID4gPiA+PiBDb3VsZAo+ID4g
PiA+PiB5b3UgZ2l2ZSBtZSBtb3JlIGluZm8gKHN1Y2ggYXMgbWtmcyBvcHRpb25zLCB4ZnN0ZXN0
cyBjb25maWdzKT8KPiA+ID4gPiAKPiA+ID4gPiBUaGV5IGFyZSBleGFjdGx5IHRoZSBzYW1lIGFz
IGxhc3QgdGltZSBJIHJlcG9ydGVkIHRoZXNlIHByb2JsZW1zLgo+ID4gPiA+IAo+ID4gPiA+IEZv
ciB0aGUgIm5vIHJlZmxpbmsiIHRlc3QgaXNzdWVzOgo+ID4gPiA+IAo+ID4gPiA+IG1rZnMgb3B0
aW9ucyBhcmUgIi1tIHJlZmxpbms9MCxybWFwYnQ9MSIsIG1vdW50IG9wdGlvbnMgIi1vCj4gPiA+
ID4gZGF4PWFsd2F5cyIgZm9yIGJvdGggZmlsZXN5dGVtcy4gIENvbmZpZyBvdXRwdXQgYXQgc3Rh
cnQgb2YgdGVzdAo+ID4gPiA+IHJ1bjoKPiA+ID4gPiAKPiA+ID4gPiBTRUNUSU9OICAgICAgIC0t
IHhmc19kYXhfbm9yZWZsaW5rCj4gPiA+ID4gRlNUWVAgICAgICAgICAtLSB4ZnMgKGRlYnVnKQo+
ID4gPiA+IFBMQVRGT1JNICAgICAgLS0gTGludXgveDg2XzY0IHRlc3QzIDYuMS4wLXJjMS1kZ2Mr
ICMxNjE1IFNNUCBQUkVFTVBUX0RZTkFNSUMgV2VkIE9jdCAxOSAxMjoyNDoxNiBBRURUIDIwMjIK
PiA+ID4gPiBNS0ZTX09QVElPTlMgIC0tIC1mIC1tIHJlZmxpbms9MCxybWFwYnQ9MSAvZGV2L3Bt
ZW0xCj4gPiA+ID4gTU9VTlRfT1BUSU9OUyAtLSAtbyBkYXg9YWx3YXlzIC1vIGNvbnRleHQ9c3lz
dGVtX3U6b2JqZWN0X3I6cm9vdF90OnMwIC9kZXYvcG1lbTEgL21udC9zY3JhdGNoCj4gPiA+ID4g
Cj4gPiA+ID4gcG1lbSBkZXZpY2VzIGFyZSBhIHBhaXIgb2YgZmFrZSA4R0IgcG1lbSByZWdpb25z
IHNldCB1cCBieSBrZXJuZWwKPiA+ID4gPiBDTEkgdmlhICJtZW1tYXA9OEchMTVHLDhHITI0RyIu
IEkgZG9uJ3QgaGF2ZSBhbnl0aGluZyBzcGVjaWFsIHNldCB1cAo+ID4gPiA+IC0gdGhlIGtlcm5l
bCBjb25maWcgaXMga2VwdCBtaW5pbWFsIGZvciB0aGVzZSBWTXMgLSBhbmQgdGhlIG9ubHkKPiA+
ID4gPiBrZXJuZWwgZGVidWcgb3B0aW9uIEkgaGF2ZSB0dXJuZWQgb24gZm9yIHRoZXNlIHNwZWNp
ZmljIHRlc3QgcnVucyBpcwo+ID4gPiA+IENPTkZJR19YRlNfREVCVUc9eS4KPiA+ID4gCj4gPiA+
IFRoYW5rcyBmb3IgdGhlIGRldGFpbGVkIGluZm8uICBCdXQsIGluIG15IGVudmlyb25tZW50IChh
bmQgbXkgCj4gPiA+IGNvbGxlYWd1ZXMnLCBhbmQgb3VyIHJlYWwgc2VydmVyIHdpdGggRENQTU0p
IHRoZXNlIGZhaWx1cmUgY2FzZXMgKHlvdSAKPiA+ID4gbWVudGlvbmVkIGFib3ZlLCBpbiBkYXgr
bm9uX3JlZmxpbmsgbW9kZSwgd2l0aCBzYW1lIHRlc3Qgb3B0aW9ucykgY2Fubm90IAo+ID4gPiBy
ZXByb2R1Y2UuCj4gPiA+IAo+ID4gPiBIZXJlJ3Mgb3VyIHRlc3QgZW52aXJvbm1lbnQgaW5mbzoK
PiA+ID4gICAtIFJ1YW4ncyBlbnY6IGZlZG9yYSAzNih2Ni4wLXJjMSkgb24ga3ZtLHBtZW0gMng0
RzpmaWxlIGJhY2tlbmRlZAo+ID4gPiAgIC0gWWFuZydzIGVudjogZmVkb3JhIDM1KHY2LjEtcmMx
KSBvbiBrdm0scG1lbSAyeDFHOm1lbW1hcD0xRyExRywxRyEyRwo+ID4gPiAgIC0gU2VydmVyJ3Mg
IDogVWJ1bnR1IDIwLjA0KHY2LjAtcmMxKSByZWFsIG1hY2hpbmUscG1lbSAyeDRHOnJlYWwgRENQ
TU0KPiA+ID4gCj4gPiA+IChUbyBxdWlja2x5IGNvbmZpcm0gdGhlIGRpZmZlcmVuY2UsIEkganVz
dCByYW4gdGhlIGZhaWxlZCAyNiBjYXNlcyB5b3UgCj4gPiA+IG1lbnRpb25lZCBhYm92ZS4pICBF
eGNlcHQgZm9yIGdlbmVyaWMvNDcxIGFuZCBnZW5lcmljLzUxOSwgd2hpY2ggZmFpbGVkIAo+ID4g
PiBldmVuIHdoZW4gZGF4IGlzIG9mZiwgdGhlIHJlc3QgcGFzc2VkLgo+ID4gPiAKPiA+ID4gCj4g
PiA+IFdlIGRvbid0IHdhbnQgZnNkYXggdG8gYmUgdHJ1bmVkIG9mZi4gIFJpZ2h0IG5vdywgSSB0
aGluayB0aGUgbW9zdCAKPiA+ID4gaW1wb3J0YW50IHRoaW5nIGlzIHNvbHZpbmcgdGhlIGZhaWxl
ZCBjYXNlcyBpbiBkYXgrbm9uX3JlZmxpbmsgbW9kZS4gCj4gPiA+IFNvLCBmaXJzdGx5LCBJIGhh
dmUgdG8gcmVwcm9kdWNlIHRob3NlIGZhaWx1cmVzLiAgSXMgdGhlcmUgYW55IHRoaW5nIAo+ID4g
PiB3cm9uZyB3aXRoIG15IHRlc3QgZW52aXJvbm1lbnRzPyAgSSBrb253IHlvdSBhcmUgdXNpbmcg
J21lbW1hcD1YWEchWVlHJyB0byAKPiA+ID4gc2ltdWxhdGUgcG1lbS4gIFNvLCAodG8gRGFycmlj
aykgY291bGQgeW91IHNob3cgbWUgeW91ciBjb25maWcgb2YgZGV2IAo+ID4gPiBlbnZpcm9ubWVu
dCBhbmQgdGhlICd0ZXN0Y2xvdWQnKEkgYW0gZ3Vlc3NpbmcgaXQncyBhIHNlcnZlciB3aXRoIHJl
YWwgCj4gPiA+IG52ZGltbSBqdXN0IGxpa2Ugb3Vycyk/Cj4gPiAKPiA+IE5vcGUuICBTaW5jZSB0
aGUgYW5ub3VuY2VtZW50IG9mIHBtZW0gYXMgYSBwcm9kdWN0LCBJIGhhdmUgaGFkIDE1Cj4gPiBt
aW51dGVzIG9mIGFjY2VzIHRvIG9uZSBwcmVwcm9kdWN0aW9uIHByb3RvdHlwZSBzZXJ2ZXIgd2l0
aCBhY3R1YWwKPiA+IG9wdGFuZSBESU1NcyBpbiB0aGVtLgo+ID4gCj4gPiBJIGhhdmUgL25ldmVy
LyBoYWQgYWNjZXNzIHRvIHJlYWwgaGFyZHdhcmUgdG8gdGVzdCBhbnkgb2YgdGhpcywgc28gaXQn
cwo+ID4gYWxsIGNvbmZpZ3VyZWQgdmlhIGxpYnZpcnQgdG8gc2ltdWxhdGUgcG1lbSBpbiBxZW11
Ogo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgteGZzL1l6WHNhdk9XTVN1d1RCRUNA
bWFnbm9saWEvCj4gPiAKPiA+IC9ydW4vbXRyZGlzay9bZ2hdLm1lbSBhcmUgYm90aCByZWd1bGFy
IGZpbGVzIG9uIGEgdG1wZnMgZmlsZXN5c3RlbToKPiA+IAo+ID4gJCBncmVwIG10cmRpc2sgL3By
b2MvbW91bnRzCj4gPiBub25lIC9ydW4vbXRyZGlzayB0bXBmcyBydyxyZWxhdGltZSxzaXplPTgy
ODk0ODQ4ayxpbm9kZTY0IDAgMAo+ID4gCj4gPiAkIGxzIC1sYSAvcnVuL210cmRpc2svW2doXS5t
ZW0KPiA+IC1ydy1yLS1yLS0gMSBsaWJ2aXJ0LXFlbXUga3ZtIDEwNzM5NTE1MzkyIE9jdCAyNCAx
ODowOSAvcnVuL210cmRpc2svZy5tZW0KPiA+IC1ydy1yLS1yLS0gMSBsaWJ2aXJ0LXFlbXUga3Zt
IDEwNzM5NTE1MzkyIE9jdCAyNCAxOToyOCAvcnVuL210cmRpc2svaC5tZW0KPiAKPiBBbHNvIGZv
cmdvdCB0byBtZW50aW9uIHRoYXQgdGhlIFZNIHdpdGggdGhlIGZha2UgcG1lbSBhdHRhY2hlZCBo
YXMgYQo+IHNjcmlwdCB0byBkbzoKPiAKPiBuZGN0bCBjcmVhdGUtbmFtZXNwYWNlIC0tbW9kZSBm
c2RheCAtLW1hcCBkZXYgLWUgbmFtZXNwYWNlMC4wIC1mCj4gbmRjdGwgY3JlYXRlLW5hbWVzcGFj
ZSAtLW1vZGUgZnNkYXggLS1tYXAgZGV2IC1lIG5hbWVzcGFjZTEuMCAtZgo+IAo+IEV2ZXJ5IHRp
bWUgdGhlIHBtZW0gZGV2aWNlIGdldHMgcmVjcmVhdGVkLCBiZWNhdXNlIGFwcGFyZW50bHkgdGhh
dCdzIHRoZQo+IG9ubHkgd2F5IHRvIGdldCBTX0RBWCBtb2RlIG5vd2FkYXlzPwoKSWYgeW91IGhh
dmUgbm90aWNlZCBhIGNoYW5nZSBoZXJlIGl0IGlzIGR1ZSB0byBWTSBjb25maWd1cmF0aW9uIG5v
dAphbnl0aGluZyBpbiB0aGUgZHJpdmVyLgoKSWYgeW91IGFyZSBpbnRlcmVzdGVkIHRoZXJlIGFy
ZSB0d28gd2F5cyB0byBnZXQgcG1lbSBkZWNsYXJlZCB0aGUgbGVnYWN5CndheSB0aGF0IHByZWRh
dGVzIGFueSBvZiB0aGUgREFYIHdvcmssIHRoZSBrZXJuZWwgY2FsbHMgaXQgRTgyMF9QUkFNLAph
bmQgdGhlIG1vZGVybiB3YXkgYnkgcGxhdGZvcm0gZmlybXdhcmUgdGFibGVzIGxpa2UgQUNQSSBO
RklULiBUaGUKYXNzdW1wdGlvbiB3aXRoIEU4MjBfUFJBTSBpcyB0aGF0IGl0IGlzIGRlYWxpbmcg
d2l0aCBiYXR0ZXJ5IGJhY2tlZApOVkRJTU1zIG9mIHNtYWxsIGNhcGFjaXR5LiBJbiB0aGF0IGNh
c2UgdGhlIC9kZXYvcG1lbSBkZXZpY2UgY2FuIHN1cHBvcnQKREFYIG9wZXJhdGlvbiBieSBkZWZh
dWx0IGJlY2F1c2UgdGhlIG5lY2Vzc2FyeSBtZW1vcnkgZm9yIHRoZSAnc3RydWN0CnBhZ2UnIGFy
cmF5IGZvciB0aGF0IG1lbW9yeSBpcyBsaWtlbHkgc21hbGwuCgpQbGF0Zm9ybSBmaXJtd2FyZSBk
ZWZpbmVkIFBNRU0gY2FuIGJlIHRlcmFieXRlcy4gU28gdGhlIGRyaXZlciBkb2VzIG5vdAplbmFi
bGUgREFYIGJ5IGRlZmF1bHQgYmVjYXVzZSB0aGUgdXNlciBuZWVkcyB0byBtYWtlIHBvbGljeSBj
aG9pY2UgYWJvdXQKYnVybmluZyBnaWdhYnl0ZXMgb2YgRFJBTSBmb3IgdGhhdCBtZXRhZGF0YSwg
b3IgcGxhY2luZyBpdCBpbiBQTUVNIHdoaWNoCmlzIGFidW5kYW50LCBidXQgc2xvd2VyLiBTbyB3
aGF0IEkgc3VzcGVjdCBtaWdodCBiZSBoYXBwZW5pbmcgaXMgeW91cgpjb25maWd1cmF0aW9uIGNo
YW5nZWQgZnJvbSBzb21ldGhpbmcgdGhhdCBhdXRvLWFsbG9jYXRlZCB0aGUgJ3N0cnVjdApwYWdl
JyBhcnJheSwgdG8gc29tZXRoaW5nIHRoYXQgbmVlZGVkIHRob3NlIGNvbW1hbmRzIHlvdSBsaXN0
IGFib3ZlIHRvCmV4cGxpY2l0bHkgb3B0LWluIHRvIHJlc2VydmluZyBzb21lIFBNRU0gY2FwYWNp
dHkgZm9yIHRoZSBwYWdlIG1ldGFkYXRhLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

