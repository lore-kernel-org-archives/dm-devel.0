Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D579C7EE45
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206953;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ay3GYl0EeGKyQOp8AF6GDJfU5YtZ6scxt36/7UPOvec=;
	b=fKn0OBQCVcyopq/p2l0lFKGnMD4sjBkXWvJ2hvYkHF/QpX0t/D6bLA86YK8ceU5GCYsto2
	vwPhFMy6tOiCktC0POied27wDy6n1wqZLFPDMfKWQA0lq7YQY8RewuivAiPHwNx30Fe7XU
	IRordZNNyp/Lkp3pYhfiY1ik88xad0g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-RzpspmupMgKaMZw16g0Lag-1; Thu, 08 Jun 2023 02:49:12 -0400
X-MC-Unique: RzpspmupMgKaMZw16g0Lag-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8C97381D4CD;
	Thu,  8 Jun 2023 06:49:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C125E4026E1;
	Thu,  8 Jun 2023 06:49:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0477194F24D;
	Thu,  8 Jun 2023 06:48:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 577EB19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 08:20:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3CF4A40D1B68; Wed,  7 Jun 2023 08:20:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3421B40D1B66
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 08:20:21 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15EA53825BA5
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 08:20:21 +0000 (UTC)
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com
 [216.71.155.144]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-td3q4Gb2NeqzdPc7fExW2A-1; Wed, 07 Jun 2023 04:20:18 -0400
X-MC-Unique: td3q4Gb2NeqzdPc7fExW2A-1
X-IronPort-RemoteIP: 104.47.58.169
X-IronPort-MID: 114385224
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:hv9wvqrZruozFl7eaZjqBXfnoBJeBmJaZRIvgKrLsJaIsI4StFCzt
 garIBmPbPiJYGf3fYx/Pti/p0xS7JWDy4BkGgFvqythHyoR+JuZCYyVIHmrMnLJJKUvbq7FA
 +Y2MYCccZ9uHhcwgj/3b9ANeFEljfngqoLUUbKCYWYpA1c/Ek/NsDo788YhmIlknNOlNA2Ev
 NL2sqX3NUSsnjV5KQr40YrawP9UlKq04GtwUmAWP6gR5weAzyZNVfrzGInqR5fGatgMdgKFb
 76rIIGRpgvx4xorA9W5pbf3GmVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0MC+7vw6hjdFpo
 OihgLTrIesf0g8gr8xGO/VQO3kW0aSrY9YrK1Dn2SCY5xWun3cBX5yCpaz5VGEV0r8fPI1Ay
 RAXAAwDa0yqu+G7+u6ES85opu48KszpZYxK7xmMzRmBZRonabbqZvyToPV+jHI3jM0IGuvCb
 c0EbzYpdA7HfxBEJlYQDtQ5gfusgX78NTZfrTp5p4JuuzSVkFM3jeiraYSEEjCJbZw9ckKwv
 GXJ8n6/GhgHHNee1SCE4jSngeqncSbTAdtOT+3lrKQ26LGV7i8MARMbVmWFm/+Wk36TW+thK
 U4K0RN7+MDe82TuFLERRSaQrHOBvzYdXcRRCOww7AyRyqvS7B2dD2JCRTlEAPQvpMUxSBQp2
 0WPktevCT8HmLSaSlqH+7uUpC/0Mi8QRUcZYy4YXwYfy9ruuoc+ilTIVNkLOKKwy9H4Bzz06
 yqHoCg3m/MYistj/6Cy51XOmT+vjpnPUA8u5w/TU36l7wV2f4qsbcqj7l2zxfJBKpuJC1OFu
 3MHs9aR4fpIDpyXkiGJBuIXE9mB4/eDLS2ZglN1GZQl3yqi9mTlfo1K5jx6YkBzPa4saTLvJ
 UPepw5VzJtSJ2exK796ZZqrDMYnxrSmEs7qPs04dfJLa5l1MQWBrCdnYBfJ23i3yRZ916YiJ
 Z2cbMCgS24ADrhqxya3QOFb1qI3wic5xiXYQpWTIwmb7IdyrUW9Ed8tWGZipMhihE9YiG05K
 +piCvY=
IronPort-HdrOrdr: A9a23:WsiKNq7f0Egz0g+ZOQPXwPfXdLJyesId70hD6qm+c20tTiX4rb
 HXoB1/73XJYVkqKRQdcLy7Scu9qDbnhP1ICOoqXItKPjOW3FdARbsKheDfKn/bexEWndQtsp
 uIHZIObuEYzmIXsS852mSF+hobr+VvOZrHudvj
X-Talos-CUID: =?us-ascii?q?9a23=3AT63euWr6OM6poj2yUDP1yDHmUfwrdyH08HTdGRO?=
 =?us-ascii?q?HCEFtaJeKT1qSoawxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AelLQ6g5f59TI35LNrYgfmGVZxowr/K2gBUMzr68?=
 =?us-ascii?q?AlNC0GCxJBTWfkh+OF9o=3D?=
X-IronPort-AV: E=Sophos;i="6.00,223,1681185600"; d="scan'208";a="114385224"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO
 NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 07 Jun 2023 04:20:16 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by BLAPR03MB5377.namprd03.prod.outlook.com (2603:10b6:208:285::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 08:20:14 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Wed, 7 Jun 2023
 08:20:13 +0000
Date: Wed, 7 Jun 2023 10:20:08 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZIA9uBJxx2gqA4Cq@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-14-demi@invisiblethingslab.com>
 <ZH7tizoYl8YVFN9B@Air-de-Roger> <ZH9mZGbM32CDmKGF@itl-email>
In-Reply-To: <ZH9mZGbM32CDmKGF@itl-email>
X-ClientProxiedBy: LO2P265CA0465.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::21) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|BLAPR03MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e28df12-13f1-4979-ab8f-08db67300481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: /P8A9dXt53vvMtoJgUcoEVWck6EIwSHohrdPT5QHwZAejjGecYHPtowKl7ZBVfvA6pg1ddK/dkNJzxr0wmC4nnWg9q+a9LFDTBFQJ+Z8H4Ke+va8fkkU7RCZpNwl44/MPCaZJTH7/X7DB2J2AFdRA9MPOPo8BsrZdkfgCmhBsIC1EU4O7s5tRVrvl311JamRJPvTpA5PgMrYHlh4mcRj6MsmX7FJtl6fLFQUseJ/uL+BBQvWPmhMHGxuJ/8UksaKraCnlpIy3tRjW7TGD7Jb9lmVg3jFjv2JHabdLKQvx5ufVvK0bVOPnK9Nx4goYXAYcgFDgdqRfAkVmcHo7nibmJt7y1AohIUwDnqsqqU5bQbco4GpPdNVHao1PdU+trtdo51XMCfig1m0PLPeIfNQBjKIu3I56pXjLchSF0B5+fJ1gvhaxsNdq8caPlXmZ9eRGntz02wLSe7VyRzSWHovq+EyOvvM0cY+ZTUVOWUbUb7U+shpBs+fc3tkrtEfLd6TbSDWnCwRboC1EkdQnYE/uhMfwgwxi/wP8aKdgjE0MLU44deHtF32eGlY+1vxA7sx
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(86362001)(83380400001)(478600001)(54906003)(82960400001)(6666004)(5660300002)(8936002)(8676002)(316002)(66946007)(66476007)(66556008)(4326008)(38100700002)(6916009)(41300700001)(6486002)(2906002)(85182001)(6506007)(6512007)(26005)(9686003)(33716001)(186003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjNlWC9kNk9GR1RRczhNUzYzcWVaUUFOVWVNcnYwb2hmNVMvdGdGVVQyZ3FE?=
 =?utf-8?B?amcwLzdnd3FsMmZ2WlpRT2hZNG9Xb1A1ZUpSbVgyTjdjZTY0em01TkhPRzFL?=
 =?utf-8?B?SzViVmFCWUlpdUMxdjU3c0d2YkRRbTZhUHNvNDI0RWp2ZkFvZDJBVXN1bmxZ?=
 =?utf-8?B?ejNVbHdDUDcwLzd4Y2F3YUJnaDA4QVNoc1pYbGcraHN2cW15enNVMGJuSjN5?=
 =?utf-8?B?RkRHa3pXMm42UDRnVHR2b2xzYTM4OGlpOFpkcy9wYjFQNHFkZnNJRDZXMnBh?=
 =?utf-8?B?Zk95RVR0UCtrVVBZdWh6T3BQODhBcCtubWxrYy9QaStxUy9lUE9nRk9GVTF5?=
 =?utf-8?B?OVRJRG1tZU9vTFJpWHBsb01xRTVMeVNRYmJ2eVg1UDVXNjA1SjYvQkJVbnJw?=
 =?utf-8?B?UEJkTzNPa0dKc015UUZZbDl3WmxlYndXRVhJZ080OWJxc0ZXSjNHMFFlQXJp?=
 =?utf-8?B?RXZ6RWZHczlHVmRhNW1GVnBsRFowSDBNeTlHdzdvUFRKblIyRkhoUmhSYm92?=
 =?utf-8?B?cU1WL0Y4VUFYdVlvWUhvbHd4aTBnN09UdEJDTkd3TnNTSXliU1RiQjhCRC9v?=
 =?utf-8?B?QWoyU01kdHg1b0FBT000eU1RaUpHSEpreUhZOUZMTnNsRG8zUjJCOGhWN1k5?=
 =?utf-8?B?RzVyTmJyanlYdllnSWJyNGE2Rno5N1N3eHFoWCtMd0pManI4dCtMdDd4cXFh?=
 =?utf-8?B?WFB4RFNhQkNkcm40RFVEdjJmdExMU2IyaGxXMm9tQWExbXgvZnBCU3RGQWN3?=
 =?utf-8?B?MkN2SXpRTlJYMGNxNi9CTmMxTWNsTVFSYXgvZDJIVzNKa2p0Y1hHd2lJMVFP?=
 =?utf-8?B?ZVY0TUpHSTA0TFFQZDEvSVN3N2NIZ1NQcFhlTXJrMXJKRWE2M1JXU0JhWmht?=
 =?utf-8?B?WkJ5dmkvcXVaRGpuNVlEUWVQa3hNbWNSR0g2ZmIwR2M3SWluWWRKZ2FjMWMy?=
 =?utf-8?B?SkRTektrd3RBVlpPNjcxRWg3YStNZGdNT1NjcWNSYytnZkN3bzRyUzlxejI2?=
 =?utf-8?B?VUgvdnJLeCtZNlhWVjFjTFhYZERwTFlpbW1OMVpTTzhwUkNUa2l6ejlQV2ps?=
 =?utf-8?B?OGg1WFNJOEIzSm5XV2tEc2t1UFVxcVBiQms2V0RuRTAwRFg5Z3NPalR5Ykho?=
 =?utf-8?B?RlE1K1psT082cEFESDQ2RWxaQUN6OEJCUkJDN3pJSDZhTDZoejVjUS9HcDBp?=
 =?utf-8?B?S1FXK09OQURYUlEvcVU2M3VGQWJKaEw5Q2h1L3pSQXducWRNbHFLMnExRUly?=
 =?utf-8?B?SWlyc1cydkI1OWlEYUxROVRweWxtQmlsbVZHS2xyb0R4MFZaQnNIbm0wVTVx?=
 =?utf-8?B?RzArK0VlK1d5djE0b3ZpQTRPUU5OaEFpODFGVFNva3RqMzVJUG1hQUMvWC8v?=
 =?utf-8?B?Tm04Yng4c1dRQ2RBOUZuYVNCaFVld2hPQWhvNkRNZGFuVjBvSW5kU1FmYk1E?=
 =?utf-8?B?c0M3Yk9pYzlvT2Z1ZlJzR244NThTOHBNTFluVHB4SjM1N0hsMkhCcWorM2Fm?=
 =?utf-8?B?Q1F0SkZ2VGoyeDdvNkpyR3RqSlFWYnFsOXVaZHU1VFRwdlN3endsU21kTlo3?=
 =?utf-8?B?SmNhNmg0QkN6b1hHd0QweU1EcWpWWXlRbzVYSk1ITEN2bE02bGl6Y2ZibFdk?=
 =?utf-8?B?ZG8zREZLaURpN0tzNFQvZnJGYkxSaDRkeGFGQmJCTWhKOU1DdEdHejJIUU4r?=
 =?utf-8?B?N1Y3bmw4Y3g2NTNVR3JDTXFyM3lwSC9hcU03cmtXOGttWkFBQ1Y2N3psWjdF?=
 =?utf-8?B?NkplTytTc0xjRFJpREY4RHQvWk5lZkc2b1dEWVk1Y0NqKzN1ZGpsTnVUOFcr?=
 =?utf-8?B?Z1BFNzBKUHpvMUVlNjg4Zm9BelZjeElYMCtBdHIvdy9UYTRoRlRtTnNJRW94?=
 =?utf-8?B?bENTZTF4UmVRZktGNjhScldYQXlnS2tZTmRJbFZYTkx3ektvL2w4cjFZd0pO?=
 =?utf-8?B?SEdqVDJnckh5TVRwa2paUUxCV28yTnlFOWJJZTVaYkErMS8wVE9yemJtVVBw?=
 =?utf-8?B?VEZ2dExtMGpzc0Zzd2pLbmV2b1loUkF6UWQ5OFVXUkVMMGlidHh5ZUQ5ZGpM?=
 =?utf-8?B?elUyNHl1SWhFdWdXbGpIdGkwNjVPVW94TjhYaDhjUW4xUmx4eUY2WGd3STdo?=
 =?utf-8?B?OVl4NkNBenhWOEd3OWR5WW5KUVJvaFpNa0lMa05oS2xlb3Q3aFYrWFBUUHFE?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RExkQjdNbEtaQURNK0Y1ZlF0b1B1M0xwWTJoV2piZFJ4K3NWaTFPTUF3Z0xt?=
 =?utf-8?B?WVNvVHJiendHdm5DV3VKOGtUaWZlZkVScS9xbXY0TGQyb1ltZmtPbC80RzR3?=
 =?utf-8?B?Wm1yZVh5M3RkTWpsRGp3ekhGVUp6RzFub0NYUDl3alhoZEpOUCtCUGZMZXFS?=
 =?utf-8?B?SWJSS1Y4bG45VElVNWpnVWxtYVRHdlBxYUV1eGNueHNDYk54RDZlQmJ6Q1Rx?=
 =?utf-8?B?cmVybWZaQjRjcG9LMjc2ZGIzM2RVTjVDU0RuYlFlbWxXUnhpcnc1L0VQazU2?=
 =?utf-8?B?U3IyN3lyMnJYQ0pHQWRVeitibUFHOVJva3JRWXN5eFpvc0pQc2FJN09xL2xN?=
 =?utf-8?B?dnZZRVo2TFh6aGxZWFo2eERpeW5KSXZxTDJWTG85Mjl6a09mT1JaVStJbzFI?=
 =?utf-8?B?RjE5Uno3dU54b3ZqcVZpRzZMTitwOUgrZ294YzEwQTNDVG1pTXcxQVFmTHRU?=
 =?utf-8?B?MTBvNjYwZ2RoN2t6UEd4UDJRZkNWaDdNSkdncWVyVzAzM3AvaHZzRERPZ3Ev?=
 =?utf-8?B?aGJQdHZmeFlObDlmbDBZeUNhaDNSMUt4MXNDYW0yMmxGaE1uTUN3R2FNajRD?=
 =?utf-8?B?aFdRRFVqNEVpcVJXbmZBL3BNYXQ5bzUxaDA2ajMyYzdCcDJFOXlWRkt3dm9V?=
 =?utf-8?B?bzVsYkZuS0lUUGxQd0Q4djM2SzFBNW03Rm50alpBeDlGU2Z1ejFmU1ZESHly?=
 =?utf-8?B?M2FrVmJnZzM3L1VlcFUvRlN4TElXbTAvUlArdURNck8xZS80ZCtCa3VTbXho?=
 =?utf-8?B?REZQRVVpRENhQTg0b1U0VDVyd2ZDcFA0MHpEYXU4ZWt5NUUzN1JPdHZlZ0FN?=
 =?utf-8?B?SVdWckgzS1Y2OE5MSitOUHpxdUhiVDkvMlVja1JXTU14ajBCTmpBWDhPNGtp?=
 =?utf-8?B?a1AzeS9hS2Jtb0hjd0ExakkrbXhrQ0lYVHFBZzRlNnNhM3NrcWlneU5CeHV2?=
 =?utf-8?B?bm9CcnF2aFVKcmFMVU8yYVdva0VCMm9mbGx3V1VBSGYyK3l5VVVpelIrWDE5?=
 =?utf-8?B?SEF2TDgwdlZETXdGR29Vd1BsZXBmeTZYNnFnZFlSYmFaU2xhekdpSS9qWWEv?=
 =?utf-8?B?WDhDWC8zTXE5cXc2WGloY1lLdTAyTWNuQ1EwZ2I0a05MMU9kRVRBOFE2OUoz?=
 =?utf-8?B?TnB1MEZreGUvak81eGM1OUJ1RDhHZm9oSjg5U3pycEp6anBxTEQrNGZVbXFW?=
 =?utf-8?B?Rmh6Z0h0RkpadkpFcFhmK1Q3c0VIYXQ5VDMzVWZLSHNpNzRXY20vTTlLRWdm?=
 =?utf-8?B?T3ZZbDVmUklBQkhwWGQ2emNIdEFOMjQ5YnZxMjF1UTRENzNxQT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e28df12-13f1-4979-ab8f-08db67300481
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:20:13.7528 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXjwqB5lyM38IYm0wuzJwV+Q5apU8EH/8zzGlz7twajZP/HMGK5kEwmhtlrnzLo8pygvcxeAS9clLCR4/vd56g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR03MB5377
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:46 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gMDYsIDIwMjMgYXQgMDE6MDE6MjBQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIFR1ZSwgSnVuIDA2LCAyMDIzIGF0IDEwOjI1OjQ3QU0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiBPbiBUdWUsIE1heSAzMCwgMjAyMyBhdCAwNDozMTox
M1BNIC0wNDAwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6Cj4gPiA+IFRoaXMgYWxsb3dzIHNw
ZWNpZnlpbmcgYSBkaXNrIHNlcXVlbmNlIG51bWJlciBpbiBYZW5TdG9yZS4gIElmIGl0IGRvZXMK
PiA+ID4gbm90IG1hdGNoIHRoZSBkaXNrIHNlcXVlbmNlIG51bWJlciBvZiB0aGUgdW5kZXJseWlu
ZyBkZXZpY2UsIHRoZSBkZXZpY2UKPiA+ID4gd2lsbCBub3QgYmUgZXhwb3J0ZWQgYW5kIGEgd2Fy
bmluZyB3aWxsIGJlIGxvZ2dlZC4gIFVzZXJzcGFjZSBjYW4gdXNlCj4gPiA+IHRoaXMgdG8gZWxp
bWluYXRlIHJhY2UgY29uZGl0aW9ucyBkdWUgdG8gbWFqb3IvbWlub3IgbnVtYmVyIHJldXNlLgo+
ID4gPiBPbGQga2VybmVscyBkbyBub3Qgc3VwcG9ydCB0aGUgbmV3IHN5bnRheCwgYnV0IGEgbGF0
ZXIgcGF0Y2ggd2lsbCBhbGxvdwo+ID4gPiB1c2Vyc3BhY2UgdG8gZGlzY292ZXIgdGhhdCB0aGUg
bmV3IHN5bnRheCBpcyBzdXBwb3J0ZWQuCj4gPiA+IAo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBEZW1p
IE1hcmllIE9iZW5vdXIgPGRlbWlAaW52aXNpYmxldGhpbmdzbGFiLmNvbT4KPiA+ID4gLS0tCj4g
PiA+ICBkcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL3hlbmJ1cy5jIHwgMTEyICsrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgODkgaW5zZXJ0aW9ucygr
KSwgMjMgZGVsZXRpb25zKC0pCj4gPiA+IAo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9j
ay94ZW4tYmxrYmFjay94ZW5idXMuYyBiL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2sveGVuYnVz
LmMKPiA+ID4gaW5kZXggNDgwN2FmMWQ1ODA1OTM5NGQ3YTk5MjMzNWRhYmFmMmJjMzkwMTcyMS4u
OWMzZWIxNDhmYmQ4MDJjNzRlNjI2YzNkN2JjZDY5ZGNiMDliZDkyMSAxMDA2NDQKPiA+ID4gLS0t
IGEvZHJpdmVycy9ibG9jay94ZW4tYmxrYmFjay94ZW5idXMuYwo+ID4gPiArKysgYi9kcml2ZXJz
L2Jsb2NrL3hlbi1ibGtiYWNrL3hlbmJ1cy5jCj4gPiA+IEBAIC0yNCw2ICsyNCw3IEBAIHN0cnVj
dCBiYWNrZW5kX2luZm8gewo+ID4gPiAgCXN0cnVjdCB4ZW5idXNfd2F0Y2gJYmFja2VuZF93YXRj
aDsKPiA+ID4gIAl1bnNpZ25lZAkJbWFqb3I7Cj4gPiA+ICAJdW5zaWduZWQJCW1pbm9yOwo+ID4g
PiArCXVuc2lnbmVkIGxvbmcgbG9uZwlkaXNrc2VxOwo+ID4gCj4gPiBTaW5jZSBkaXNrc2VxIGlz
IGRlY2xhcmVkIGFzIHU2NCBpbiBnZW5kaXNrLCBiZXR0ZXIgdXNlIHRoZSBzYW1lIHR5cGUKPiA+
IGhlcmUgdG9vPwo+IAo+IHNpbXBsZV9zdHJ0b3VsbCgpIHJldHVybnMgYW4gdW5zaWduZWQgbG9u
ZyBsb25nLCBhbmQgQyBwZXJtaXRzIHVuc2lnbmVkCj4gbG9uZyBsb25nIHRvIGJlIGxhcmdlciB0
aGFuIDY0IGJpdHMuCgpSaWdodCwgYnV0IHRoZSB0eXBlIG9mIGdlbmRpc2sgaXMgdTY0LiAgSXQn
cyBmaW5lIGlmIHlvdSB3YW50IHRvIHN0b3JlCnRoZSByZXN1bHQgb2Ygc2ltcGxlX3N0cnRvdWxs
KCkgaW50byBhbiB1bnNpZ25lZCBsb25nIGxvbmcgYW5kIGRvCndoYXRldmVyIGNoZWNrcyB0byBh
c3NlcnQgaXQgbWF0Y2hlcyB0aGUgZm9ybWF0IGV4cGVjdGVkIGJ5IGdlbmRpc2ssCmJ1dCB1bHRp
bWF0ZWx5IHRoZSBmaWVsZCB0eXBlIHdvdWxkIGJldHRlciB1c2UgdTY0IGZvciBjb25zaXN0ZW5j
eSBJTU8uCgo+ID4gPiBAQCAtNzI1LDEwICs3NDksNDYgQEAgc3RhdGljIHZvaWQgYmFja2VuZF9j
aGFuZ2VkKHN0cnVjdCB4ZW5idXNfd2F0Y2ggKndhdGNoLAo+ID4gPiAgCQlyZXR1cm47Cj4gPiA+
ICAJfQo+ID4gPiAgCj4gPiA+IC0JaWYgKGJlLT5tYWpvciB8IGJlLT5taW5vcikgewo+ID4gPiAt
CQlpZiAoYmUtPm1ham9yICE9IG1ham9yIHx8IGJlLT5taW5vciAhPSBtaW5vcikKPiA+ID4gLQkJ
CXByX3dhcm4oImNoYW5naW5nIHBoeXNpY2FsIGRldmljZSAoZnJvbSAleDoleCB0byAleDoleCkg
bm90IHN1cHBvcnRlZC5cbiIsCj4gPiA+IC0JCQkJYmUtPm1ham9yLCBiZS0+bWlub3IsIG1ham9y
LCBtaW5vcik7Cj4gPiA+ICsJZGlza3NlcV9zdHIgPSB4ZW5idXNfcmVhZChYQlRfTklMLCBkZXYt
Pm5vZGVuYW1lLCAiZGlza3NlcSIsICZkaXNrc2VxX2xlbik7Cj4gPiA+ICsJaWYgKElTX0VSUihk
aXNrc2VxX3N0cikpIHsKPiA+ID4gKwkJaW50IGVyciA9IFBUUl9FUlIoZGlza3NlcV9zdHIpOwo+
ID4gPiArCQlkaXNrc2VxX3N0ciA9IE5VTEw7Cj4gPiA+ICsKPiA+ID4gKwkJLyoKPiA+ID4gKwkJ
ICogSWYgdGhpcyBkb2VzIG5vdCBleGlzdCwgaXQgbWVhbnMgbGVnYWN5IHVzZXJzcGFjZSB0aGF0
IGRvZXMgbm90Cj4gPiA+ICsJCSAqIHN1cHBvcnQgZGlza3NlcS4KPiA+ID4gKwkJICovCj4gPiA+
ICsJCWlmICh1bmxpa2VseSghWEVOQlVTX0VYSVNUX0VSUihlcnIpKSkgewo+ID4gPiArCQkJeGVu
YnVzX2Rldl9mYXRhbChkZXYsIGVyciwgInJlYWRpbmcgZGlza3NlcSIpOwo+ID4gPiArCQkJcmV0
dXJuOwo+ID4gPiArCQl9Cj4gPiA+ICsJCWRpc2tzZXEgPSAwOwo+ID4gPiArCX0gZWxzZSBpZiAo
ZGlza3NlcV9sZW4gPD0gMCkgewo+ID4gPiArCQl4ZW5idXNfZGV2X2ZhdGFsKGRldiwgLUVGQVVM
VCwgImRpc2tzZXEgbXVzdCBub3QgYmUgZW1wdHkiKTsKPiA+ID4gKwkJZ290byBmYWlsOwo+ID4g
PiArCX0gZWxzZSBpZiAoZGlza3NlcV9sZW4gPiAxNikgewo+ID4gPiArCQl4ZW5idXNfZGV2X2Zh
dGFsKGRldiwgLUVSQU5HRSwgImRpc2tzZXEgdG9vIGxvbmc6IGdvdCAlZCBidXQgbGltaXQgaXMg
MTYiLAo+ID4gPiArCQkJCSBkaXNrc2VxX2xlbik7Cj4gPiA+ICsJCWdvdG8gZmFpbDsKPiA+ID4g
Kwl9IGVsc2UgaWYgKGRpc2tzZXFfc3RyWzBdID09ICcwJykgewo+ID4gPiArCQl4ZW5idXNfZGV2
X2ZhdGFsKGRldiwgLUVSQU5HRSwgImRpc2tzZXEgbXVzdCBub3Qgc3RhcnQgd2l0aCAnMCciKTsK
PiA+ID4gKwkJZ290byBmYWlsOwo+ID4gPiArCX0gZWxzZSB7Cj4gPiA+ICsJCWNoYXIgKmRpc2tz
ZXFfZW5kOwo+ID4gPiArCQlkaXNrc2VxID0gc2ltcGxlX3N0cnRvdWxsKGRpc2tzZXFfc3RyLCAm
ZGlza3NlcV9lbmQsIDE2KTsKPiA+ID4gKwkJaWYgKGRpc2tzZXFfZW5kICE9IGRpc2tzZXFfc3Ry
ICsgZGlza3NlcV9sZW4pIHsKPiA+ID4gKwkJCXhlbmJ1c19kZXZfZmF0YWwoZGV2LCAtRUlOVkFM
LCAiaW52YWxpZCBkaXNrc2VxIik7Cj4gPiA+ICsJCQlnb3RvIGZhaWw7Cj4gPiA+ICsJCX0KPiA+
ID4gKwkJa2ZyZWUoZGlza3NlcV9zdHIpOwo+ID4gPiArCQlkaXNrc2VxX3N0ciA9IE5VTEw7Cj4g
PiA+ICsJfQo+ID4gCj4gPiBXb24ndCBpdCBiZSBzaW1wbGVyIHRvIHVzZSB4ZW5idXNfc2NhbmYo
KSB3aXRoICVsbHggZm9ybWF0dGVyPwo+IAo+IHhlbmJ1c19zY2FuZigpIGRvZXNu4oCZdCBjaGVj
ayBmb3Igb3ZlcmZsb3cgYW5kIGFjY2VwdHMgbG90cyBvZiBqdW5rIGl0Cj4gcmVhbGx5IHNob3Vs
ZCBub3QuICBTaG91bGQgdGhpcyBiZSBmaXhlZCBpbiB4ZW5idXNfc2NhbmYoKT8KClRoYXQgd291
bGQgYmUgbXkgcHJlZmVyZW5jZSwgc28gdGhhdCB5b3UgY2FuIHVzZSBpdCBoZXJlIGluc3RlYWQg
b2YKa2luZCBvZiBvcGVuLWNvZGluZyBpdC4KCj4gPiBBbHNvLCB3ZSBtaWdodCB3YW50IHRvIGZl
dGNoICJwaHlzaWNhbC1kZXZpY2UiIGFuZCAiZGlza3NlcSIgaW5zaWRlCj4gPiB0aGUgc2FtZSB4
ZW5zdG9yZSB0cmFuc2FjdGlvbi4KPiAKPiBTaG91bGQgdGhlIHJlc3Qgb2YgdGhlIHhlbnN0b3Jl
IHJlYWRzIGJlIGluY2x1ZGVkIGluIHRoZSBzYW1lCj4gdHJhbnNhY3Rpb24/CgpJIGd1ZXNzIGl0
IHdvdWxkIG1ha2UgdGhlIGNvZGUgc2ltcGxlciB0byBpbmRlZWQgZmV0Y2ggZXZlcnl0aGluZwpp
bnNpZGUgdGhlIHNhbWUgdHJhbnNhY3Rpb24uCgo+ID4gQWxzbywgeW91IHRpZSB0aGlzIGxvZ2lj
IHRvIHRoZSAicGh5c2ljYWwtZGV2aWNlIiB3YXRjaCwgd2hpY2gKPiA+IHN0cmljdGx5IGltcGxp
ZXMgdGhhdCB0aGUgImRpc2tzZXEiIG5vZGUgbXVzdCBiZSB3cml0dGVuIHRvIHhlbnN0b3JlCj4g
PiBiZWZvcmUgdGhlICJwaHlzaWNhbC1kZXZpY2UiIG5vZGUuICBUaGlzIHNlZW1zIGZyYWdpbGUs
IGJ1dCBJIGRvbid0Cj4gPiBzZWUgbXVjaCBiZXR0ZXIgb3B0aW9ubyBzaW5jZSB0aGUgImRpc2tz
ZXEiIGlzIG9wdGlvbmFsLgo+IAo+IFdoYXQgYWJvdXQgaW5jbHVkaW5nIHRoZSBkaXNrc2VxIGlu
IHRoZSAicGh5c2ljYWwtZGV2aWNlIiBub2RlPyAgUGVyaGFwcwo+IHVzZSBkaXNrc2VxQG1ham9y
Om1pbm9yIHN5bnRheD8KCkhtLCBob3cgd291bGQgeW91IGtub3cgd2hldGhlciB0aGUgYmxrYmFj
ayBpbnN0YW5jZSBpbiB0aGUga2VybmVsCnN1cHBvcnRzIHRoZSBkaXNrc2VxIHN5bnRheCBpbiBw
aHlzaWNhbC1kZXZpY2U/CgpDYW4geW91IGZldGNoIGEgZGlzayB1c2luZyBhIGRpc2tzZXEgaWRl
bnRpZmllcj8KCldoeSBJIHVuZGVyc3RhbmQgdGhhdCB0aGlzIGlzIGFuIGV4dHJhIHNhZmV0eSBj
aGVjayBpbiBvcmRlciB0byBhc3NlcnQKYmxrYmFjayBpcyBvcGVuaW5nIHRoZSBpbnRlbmRlZCBk
ZXZpY2UsIGlzIHRoaXMgYXR0ZW1wdGluZyB0byBmaXggc29tZQpleGlzdGluZyBpc3N1ZT8KCkkn
bSBub3Qgc3VyZSBJIHNlZSBob3cgdGhlIG1ham9yOm1pbm9yIG51bWJlcnMgd291bGQgcG9pbnQg
dG8gYQpkaWZmZXJlbnQgZGV2aWNlIHRoYW4gdGhlIG9uZSBzcGVjaWZpZWQgYnkgdGhlIHRvb2xz
dGFjayB1bmxlc3MgdGhlCmFkbWluIGV4cGxpY2l0bHkgbWVzc2VzIHdpdGggdGhlIGRldmljZXMg
YmVmb3JlIGJsa2JhY2sgaGFzIGdvdCB0aW1lCnRvIG9wZW4gdGhlbS4gIEJ1dCB0aGVuIHRoZSBh
ZG1pbiBjYW4gYWxyZWFkeSBkbyBwcmV0dHkgbXVjaApldmVyeXRoaW5nIGl0IHdhbnRzIHdpdGgg
dGhlIHN5c3RlbS4KClRoYW5rcywgUm9nZXIuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

