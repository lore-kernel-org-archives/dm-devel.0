Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496CCC7EE29
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120539;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WPdigyPDg7azsdm6EE6CLi+QUE44oAn4KVIxdYv9f9o=;
	b=dYkevdLPqo5TIAUzrJimf4Yvtwpi3LEi2+MQVWJGhVNrWC314J3tPrOaytu/k/wf/ZJWTY
	Sy9RsN6MtWLgQOVnpOZYCcQpf98pya8lwVkfGVzeCcpvqbofOGOz0fCrVWchE7eOv/Zieh
	Sch77H4U7vSHI+xMfDvWv6qd/Myp1W4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-V0ak7UkMPnuOZko-05aT8A-1; Wed, 07 Jun 2023 02:48:57 -0400
X-MC-Unique: V0ak7UkMPnuOZko-05aT8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA490280D5AD;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2FB3440E6A5B;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCB6A19451C9;
	Wed,  7 Jun 2023 06:48:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2019919465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 08:27:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38D7A140E956; Tue,  6 Jun 2023 08:27:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F2B3140E955
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:27:06 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAF90858F15
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:27:05 +0000 (UTC)
Received: from esa3.hc3370-68.iphmx.com (esa3.hc3370-68.iphmx.com
 [216.71.145.155]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-m2ikfdFuP6OBYgbp7b2KXg-1; Tue, 06 Jun 2023 04:27:03 -0400
X-MC-Unique: m2ikfdFuP6OBYgbp7b2KXg-1
X-IronPort-RemoteIP: 104.47.57.173
X-IronPort-MID: 111750832
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:gish2KBHVX6dERVW/2vjw5YqxClBgxIJ4kV8jS/XYbTApDh30GAAn
 WpMWW6GOf+IMWf3fdhzaIW+pEtXu57XmtVkQQY4rX1jcSlH+JHPbTi7wuUcHAvJd5GeExg3h
 yk6QoOdRCzhZiaE/n9BCpC48T8nk/nOHuGmYAL9EngZbRd+Tys8gg5Ulec8g4p56fC0GArIs
 t7pyyHlEAbNNwVcbCRMs8pvlDs15K6p4G1A4ARnDRx2lAS2e0c9Xcp3yZ6ZdxMUcqEMdsamS
 uDKyq2O/2+x13/B3fv8z94X2mVTKlLjFVDmZkh+AsBOsTAbzsAG6Y4pNeJ0VKtio27hc+ada
 jl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CA6IoKvn3bEmp1T4E8K0YIw9+ZtL1F15
 94iEjkddDXAoL2N2e78Rbw57igjBJGD0II3nFhFlGicIdN4BJfJTuPN+MNS2yo2ioZWB/HCa
 sEFaD1pKhPdfxlIPVRRA5U79AuqriCnL3sE9xTI+uxuvDO7IA9ZidABNPLPfdOHX4NNl1uwr
 WPa5WXpRBodMbRzzBLcqyvz27efxnmTtIQ6SZ68xvlsx3OqwkNQOTYcFkK3pvinsxvrMz5YA
 wlOksY0loA++UmqZtj7QRyjoXSAswIcWtxfCOkz4keGza+8yw+JDG8JZj1MctorsIk6RlQC3
 1CKt8nkCTxmrPueTnf13qySrC+gNDI9LmIYYyIACwwf7LHLrIR2gh/RQ9JLCqO5jtTpXzr3x
 liiqSEkgrwJgM0j1qOl/EvGiTahupjISAEu4gzdGGmi62tRYI+jepzt41zc5vVoMomUVB+Cs
 WIClszY6/oBZbmJlSqQUKAOEauv6vKtLjLRmxhsEoMn+jDr/GSsFahA7Tc7KEp3P8IsfT7yf
 FSVqQ5X/IVUPnahcelweY3ZNigx5a3pFNCgWvWKaNNLO8F1bFXeo3ooYlOM1WfwlkRqibs4J
 ZqQbcerCzAdFLhjyz21Aewa1NfH2xwD+I8afrijpzzP7FZUTCT9pWstWLdWUt0E0Q==
IronPort-HdrOrdr: A9a23:wzmv/61mzcaVTEqa1bBtyAqjBEIkLtp133Aq2lEZdPU0SKGlfg
 6V/cjztCWE7wr5PUtLpTnuAsa9qB/nm6KdpLNhXotKPzOW3FdATrsD0WKK+VSJdxEWtNQtt5
 uIG5IUNDSaNykesS77ijPIb+rJwrO8gd+VbTG19QYSceloAZsQnjuQEmygYytLrJEtP+tCKH
 KbjPA33gaISDAsQemQIGIKZOTHr82jruOaXfZXbyRXkDVnlFmTmcXHLyQ=
X-Talos-CUID: =?us-ascii?q?9a23=3AXoS0B2uAlCd2/5G0TONMSkzG6Isocmfz/EzCAXW?=
 =?us-ascii?q?CAHZzbf6yFmSJpORrxp8=3D?=
X-Talos-MUID: 9a23:OKrIWQQK3nNJ5AQ5RXSxpzVSM8EvzZ2qJwM8up9FosWDNDJJbmI=
X-IronPort-AV: E=Sophos;i="6.00,219,1681185600"; d="scan'208";a="111750832"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jun 2023 04:25:59 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by DM6PR03MB5308.namprd03.prod.outlook.com (2603:10b6:5:242::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 08:25:55 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 08:25:54 +0000
Date: Tue, 6 Jun 2023 10:25:47 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZH7tizoYl8YVFN9B@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-14-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-14-demi@invisiblethingslab.com>
X-ClientProxiedBy: LO4P265CA0219.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::17) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|DM6PR03MB5308:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d30dcc-8727-4d37-4d2f-08db6667a542
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: yQfiE2eRWyLzULR/YF5wrRtVLtDSjzM0xQMZB8ZRbogcztppoGGlX/NGq8ZXHY6ANsPo9LNHTzfTP3DLdjQFglTNZc6qcNpa+LHpFo5u0tt1KK7ArEbpiUqs/0nlBfO8GCWEP+l24/twCCK+3Vfrrw8alRmUDa2m2GABQHMN3q8umLgbS9itdLjQo2k2dw8W/Y22PLERhYGtTDQejR3dL8DdOD4cKOGbx4rEnyenxmTdlyrOLvrlOfdtyJkFZqOBdETbAuSgDi3BAwDrYklIlhJIRbzgVAoTCuhV1IoxkJeYoGgV2h2IQw4hbCZvpX4qmAzw9rIUx/T/tVJpVKi7f8B4XJjdhHwxXTUDvSPKw1wuDfRpV/JuTpwsRx0wzhWaVyXDD1rynsBW4b+PRmat4C3oRbZGUtDRCtaR/KoZX15NYBX/A+oa3LCiK+nmpZdZjcSSNCjTnX4UUy0Gipwxkt/S7BrS9+L0UlCrvu6T/yx2hmA7T4uN9iCO/gLQdM3sev5nRgMpCJRYcvwqJkxKeUI7XVGEEsMxWEwErog3W4rCmnTv9Jw3a+S88MLZ9Krd
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(7916004)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199021)(6666004)(82960400001)(2906002)(66556008)(6486002)(66946007)(66476007)(54906003)(85182001)(8936002)(8676002)(5660300002)(38100700002)(86362001)(41300700001)(6916009)(316002)(4326008)(478600001)(33716001)(9686003)(26005)(6512007)(6506007)(186003)(83380400001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3Z2SjNkOE9BVXhpM2lLNXd4NXdheXNnTjlTWGlWZVVPbzdZbjdlNHBmN0M3?=
 =?utf-8?B?SE5lQnFOdy9kZnFjcWlHeVc2UGhrQW5CNHFtVVNGSDVQdHZxQjRaZ0w1NkFS?=
 =?utf-8?B?dVU0VHdFSmlGMFFHVUxVY0pHSTJnTERsRUNzRXVRL3I4eXZGVktRTW9jMWJB?=
 =?utf-8?B?cktmSU4rMS9mZHhYTXlVR00vNDRYS0o1Nys5Q2ZmeEFiRmFFNUJNSjI0MXRZ?=
 =?utf-8?B?MTJKMFNxNktJNk1YQUoyQVovemJTajcwYnNvTXNjUXRFdWhySUVLdCtOakxy?=
 =?utf-8?B?NGJ1SHlndDlqMFZ5OXh5OHNFRWh1OGxiVHlvWGkwbFJiR3R6Und0YmFkb3pU?=
 =?utf-8?B?bzVRUGtyVk0vRW9sQWhKZnFMbEh6cWhoSGlQZnpQYzMyUlg1ZCtkR3dCTmZP?=
 =?utf-8?B?V3Y0NjE3aThwQ0RNKzQvVVlIak1uUzFnZUttVCszVmYreHRia25kaDBobTdj?=
 =?utf-8?B?WmNtQ1dKSFRnRy9GU3JuNGNVTEtYYUM1dHF4ZElHRWdJb24vaDkwbnR5S080?=
 =?utf-8?B?S1RiWHZOOEF6d0hoQTZ3bHBaQnJic3g4NTJaOWpkd2hCR2kyNmNxMFVvL0hX?=
 =?utf-8?B?MGowUXFYWVNTdXVkZW4vcEtJSlFCaENzNVZzTFFUT3hLVm1hZzdoMk1rSys5?=
 =?utf-8?B?TGduMVVvVS9VdHl6Ri95S0tKcHYvTmtwRzU3YjdZZ1pQSlpIaWVVQnByVUk2?=
 =?utf-8?B?ZFdMU0l1VklsTDNyOFVzWkF1Z0k4WFdIYkJZUzN1d0ZBQUtuTmtrNFE4THB5?=
 =?utf-8?B?V0x0a1ZkYzFhNTFYaHg3b3JuWXRhalBBUkpjS0pLVkZUYlhaYzd5TEdvU3I1?=
 =?utf-8?B?TE55Vm4wM1licDFLZmFrR2FJQTIwNnU5SHpXN3NsYy9maFM3aXFpc2JuTjhO?=
 =?utf-8?B?eG1ublRZQ2R0ZzFxQUJqTG5zTmZ5VTJiV200eitmb0JkQk1td2Irc2lhVSsz?=
 =?utf-8?B?RVROeWtDYk9pcC9wMTI5SUszTEMzS1JYbVBackprZVBXTUNZLzBLWlZzNTY4?=
 =?utf-8?B?dGxTQ3RxK29EZDBzQ3QxUWR5Tjh2MmljbWd4amJidzF0cXBLa2pHSHVWMTVL?=
 =?utf-8?B?WXZPRks4QkdnaXVhWFl0aXlZRllnS3pFcG1xMWlBTzZqWVpDZUJlU3dtYlB4?=
 =?utf-8?B?aWk0RGRSSHZEQ2Q0MlZ2Mnl0d3BiZnZQVWczU0w4UXl4WmZPeXVoU0E1SkRp?=
 =?utf-8?B?eE9QNGtlUHplUTRoUHlSNUZYcmlXaW8ybU9ER0RXdWhhSUVicXFtb0JUelN0?=
 =?utf-8?B?bnk0ZitDUkhXVVJ6R2JHR1lHOVMzTzFWM0R0VllYdjRlanpITGZ5T3l2TWsy?=
 =?utf-8?B?ZTBQcTAyUGgwczdCTFNmVnBURXE3RiszNGJPRm5mUTQzWDFCL3I2TEF3YjlU?=
 =?utf-8?B?cGw5dTROTmJPT2pWNFZEY3FvK2pVSmIyNjBZTFZ4elEvY3V4Y0l4RWhDWFox?=
 =?utf-8?B?ZnNWb2ZUMDUydU9XK0RObWQ0T2src1hDTm5EMWhubWFaMmFyTVUrcWMvbWUr?=
 =?utf-8?B?SzBZY0NTSlI1d3FuTnkwbUdjYXhVT3ZjakUvUkluZGE0ZlBJNmNDTUNRSXlv?=
 =?utf-8?B?NmVDT1hmS014WG85dUFqZ0oweGphOTRLOTdRR1V4NXA5N1JKb3daeS9Xbk1p?=
 =?utf-8?B?TEZHTlZ3bUFKK3hyT3lxZ0p2NFRLb2hVVlFLbUE2d2QySXVmRnFSakpnWXo3?=
 =?utf-8?B?VTZ0TGxUZDVCbFovT2l2QUVhSHl5Zm9JNkM3eDl3NUJJdDZMcUtuK3VGWjFv?=
 =?utf-8?B?TTRmeG9Vd29saTRqSHZ0RW9tdTkzOEkzMUZTckJhcUE1MUJjL3BHa1BQRzF4?=
 =?utf-8?B?MmtORnJENzN1YklzaDlaeWo5bmZLeVE3ODd2R1VjS0p2Vjk1THBmRmUrS2hV?=
 =?utf-8?B?NE1GOUFVaTVmQjBRV0ZDWDIwWndUaW1HT2JScTdRZnp4V3dpck1oU0Q5blQ4?=
 =?utf-8?B?S09sWGxnZW1ZZ0szeWhzRG1Rc3lDbUVlSXlhdkdIa1JoSEsxWGY4QThjRVRY?=
 =?utf-8?B?UmhPYUhuL3N3TjdONzVLOEFyR2hua2ZVTTV4bm55aGFGUzBwY2RTS0M2dk5B?=
 =?utf-8?B?ZDN5UXpvMEpXT0dnVG1seFRqS3JyQ251Z0VnWVNVS3ZjbkhrNEsxZjFxN1hP?=
 =?utf-8?Q?nAstgFIOFOF5YKexr1FfrhLu/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RVRhUmRYLy9RMy90RkxzTTZES0VOY0hnY2dqbk5ibVI5ckFnNlU5ZUl6Nytv?=
 =?utf-8?B?b2orRk00SjFMelRBOXN3N2Y3MnZ6WGxGTHJSUGppcDE0YXUzSVQrYVJSWkdN?=
 =?utf-8?B?azA1eW1rSy9MMkltcG94M3FESUM0UEpaVGE0RG5xbFc2YytWSDIycSt4Qzdu?=
 =?utf-8?B?MWJpdlBqTU1zL2YrbVpLYUFZVHZhN1RnS1NrV3pMS3JMaE1qcFN6emN5OHgv?=
 =?utf-8?B?SjVlNjFMdWhZRDBVdmIvMXhvR0JOUERPZTFFcFB3clJRM1FEQkRlSVJOdU9r?=
 =?utf-8?B?Q0hQOTdCUWtsanorVWZ1NXhuQm1hblBXSmtPY2s0cFFnZlA5REY5RzZwUjha?=
 =?utf-8?B?Rk5PNnlqdVAxQ09mTmdZOFV3OEt2Uko5N0J2WkJ0YUdiMUczdHcxeERYKy8x?=
 =?utf-8?B?cnFRaEhPZ0xUMExVeGFTRGFBVXkrWGh3NHpvYlovWVUyR25aeTJiejFnd2xB?=
 =?utf-8?B?aTZrMEVqZzlMTXNweTluU3dzUy9JUHAzQTdUSkRrTHRrdFVxMHdkeWYvRGZR?=
 =?utf-8?B?SEFNa1RwSlpRNWVmb013Y3BlaDVCY01BR3R6UUhZK1RkM3ljcjYzQk45NjR1?=
 =?utf-8?B?VEU0UE9zS0VuU2lEQmNGbkJZNFVONy9nNWorYTl2dXJLVGFtRGtOcXUzbzRo?=
 =?utf-8?B?VnRhREJ3eXdpSS9ZcTVtWU5UR29wVUpIR3R5UVpDZ2lSOFlYUFpWWW1GTzJL?=
 =?utf-8?B?R2V5YS91SVFOc004cjJyVEdubkhSNVBhLzlCL2c0aE1yN3hOY1pSczh2UmVa?=
 =?utf-8?B?L1BZcitPeWpxTG9NNzNlSmxYNHBuMURJVkRhcExjK2NJSW42dyt0eGQwM3Vq?=
 =?utf-8?B?MGtQRlowNXRzV2N0M0pMNHFFUHVUZzZYbWxZeTJSc2wwYjdkdkhDR3dKOHdT?=
 =?utf-8?B?dDduVmVkQnZpa2hGZVlDdStTRjdGU2wvQXFyWWN1bERxdU01NGc1VHNVT0V4?=
 =?utf-8?B?M3pkNUU1VFhxaWpUZzNPbWNMVGRyVExyWVhENmVMTW04VnRuVnRURDJGR3lj?=
 =?utf-8?B?RXU4QUtaMlZ0aFRhS2FDNlVaQ05mVGQ1VkdBNTZURXhUQzgvSHAyT2VIaGsx?=
 =?utf-8?B?WWo0djEvMEllVFh4WW1KbFBvL3lwTHIwdE9udDhqSEd5L2dUTUM3RnpqZkxR?=
 =?utf-8?B?NVYrVkdxR0VJUnJVNU85ZU9UbjFYUjZPMmg1aFd3ejN4M2VEU0o1clcyMHpB?=
 =?utf-8?B?WjB0cU5vNVA4Qi9zM3ZySkg1UVE0NHBqcGh4WUpQRDRnckV1cHB0bXdGV3dn?=
 =?utf-8?B?dllYY3BUWkdGZ2VMYlBzWUtldm5OelBCR0RhcVVqK0MvNXpvdz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d30dcc-8727-4d37-4d2f-08db6667a542
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:25:54.6929 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGFVu0uWekN3jz7Iin+Ce83liwSBfVJErQKYuGGpxUT1nqK0iSVAeL9RZahHrqh+rt5NZtDH75Y179Gfeq5seQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5308
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:48:52 +0000
Subject: Re: [dm-devel] [PATCH v2 13/16] xen-blkback: Implement diskseq
 checks
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 30, 2023 at 04:31:13PM -0400, Demi Marie Obenour wrote:
> This allows specifying a disk sequence number in XenStore.  If it does
> not match the disk sequence number of the underlying device, the device
> will not be exported and a warning will be logged.  Userspace can use
> this to eliminate race conditions due to major/minor number reuse.
> Old kernels do not support the new syntax, but a later patch will allow
> userspace to discover that the new syntax is supported.
> 
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> ---
>  drivers/block/xen-blkback/xenbus.c | 112 +++++++++++++++++++++++------
>  1 file changed, 89 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 4807af1d58059394d7a992335dabaf2bc3901721..9c3eb148fbd802c74e626c3d7bcd69dcb09bd921 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -24,6 +24,7 @@ struct backend_info {
>  	struct xenbus_watch	backend_watch;
>  	unsigned		major;
>  	unsigned		minor;
> +	unsigned long long	diskseq;

Since diskseq is declared as u64 in gendisk, better use the same type
here too?

>  	char			*mode;
>  };
>  
> @@ -479,7 +480,7 @@ static void xen_vbd_free(struct xen_vbd *vbd)
>  
>  static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
>  			  unsigned major, unsigned minor, int readonly,
> -			  int cdrom)
> +			  bool cdrom, u64 diskseq)
>  {
>  	struct xen_vbd *vbd;
>  	struct block_device *bdev;
> @@ -507,6 +508,26 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
>  		xen_vbd_free(vbd);
>  		return -ENOENT;
>  	}
> +
> +	if (diskseq) {
> +		struct gendisk *disk = bdev->bd_disk;

const.

> +
> +		if (unlikely(disk == NULL)) {
> +			pr_err("%s: device %08x has no gendisk\n",
> +			       __func__, vbd->pdevice);
> +			xen_vbd_free(vbd);
> +			return -EFAULT;

ENODEV or ENOENT might be more accurate IMO.

> +		}
> +
> +		if (unlikely(disk->diskseq != diskseq)) {
> +			pr_warn("%s: device %08x has incorrect sequence "
> +				"number 0x%llx (expected 0x%llx)\n",

I prefer %#llx, and likely pr_err like above.  Also I think it's now
preferred to not split printed lines, so that `grep "has incorrect
sequence number" ...` can find the instance.

> +				__func__, vbd->pdevice, disk->diskseq, diskseq);
> +			xen_vbd_free(vbd);
> +			return -ENODEV;
> +		}
> +	}
> +
>  	vbd->size = vbd_sz(vbd);
>  
>  	if (cdrom || disk_to_cdi(vbd->bdev->bd_disk))
> @@ -707,6 +728,9 @@ static void backend_changed(struct xenbus_watch *watch,
>  	int cdrom = 0;
>  	unsigned long handle;
>  	char *device_type;
> +	char *diskseq_str = NULL;

const, and I think there's no need to init to NULL.

> +	int diskseq_len;

unsigned int

> +	unsigned long long diskseq;

u64

>  
>  	pr_debug("%s %p %d\n", __func__, dev, dev->otherend_id);
>  
> @@ -725,10 +749,46 @@ static void backend_changed(struct xenbus_watch *watch,
>  		return;
>  	}
>  
> -	if (be->major | be->minor) {
> -		if (be->major != major || be->minor != minor)
> -			pr_warn("changing physical device (from %x:%x to %x:%x) not supported.\n",
> -				be->major, be->minor, major, minor);
> +	diskseq_str = xenbus_read(XBT_NIL, dev->nodename, "diskseq", &diskseq_len);
> +	if (IS_ERR(diskseq_str)) {
> +		int err = PTR_ERR(diskseq_str);
> +		diskseq_str = NULL;
> +
> +		/*
> +		 * If this does not exist, it means legacy userspace that does not
> +		 * support diskseq.
> +		 */
> +		if (unlikely(!XENBUS_EXIST_ERR(err))) {
> +			xenbus_dev_fatal(dev, err, "reading diskseq");
> +			return;
> +		}
> +		diskseq = 0;
> +	} else if (diskseq_len <= 0) {
> +		xenbus_dev_fatal(dev, -EFAULT, "diskseq must not be empty");
> +		goto fail;
> +	} else if (diskseq_len > 16) {
> +		xenbus_dev_fatal(dev, -ERANGE, "diskseq too long: got %d but limit is 16",
> +				 diskseq_len);
> +		goto fail;
> +	} else if (diskseq_str[0] == '0') {
> +		xenbus_dev_fatal(dev, -ERANGE, "diskseq must not start with '0'");
> +		goto fail;
> +	} else {
> +		char *diskseq_end;
> +		diskseq = simple_strtoull(diskseq_str, &diskseq_end, 16);
> +		if (diskseq_end != diskseq_str + diskseq_len) {
> +			xenbus_dev_fatal(dev, -EINVAL, "invalid diskseq");
> +			goto fail;
> +		}
> +		kfree(diskseq_str);
> +		diskseq_str = NULL;
> +	}

Won't it be simpler to use xenbus_scanf() with %llx formatter?

Also, we might want to fetch "physical-device" and "diskseq" inside
the same xenstore transaction.

Also, you tie this logic to the "physical-device" watch, which
strictly implies that the "diskseq" node must be written to xenstore
before the "physical-device" node.  This seems fragile, but I don't
see much better optiono since the "diskseq" is optional.

The node and its behaviour should be documented in blkif.h.

> +	if (be->major | be->minor | be->diskseq) {
> +		if (be->major != major || be->minor != minor || be->diskseq != diskseq)
> +			pr_warn("changing physical device (from %x:%x:%llx to %x:%x:%llx)"
> +				" not supported.\n",
> +				be->major, be->minor, be->diskseq, major, minor, diskseq);
>  		return;

You are leaking diskseq_str here, and in all the error cases between
here and up to the call to xen_vbd_create().

It might be better to simnply free diskseq_str once you are done with
the processing, and have set diskseq.

Otherwise see my suggestion of using xenbus_scanf().

Thanks, Roger.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

