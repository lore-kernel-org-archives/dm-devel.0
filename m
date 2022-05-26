Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D57C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 27 May 2022 06:37:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-k8q6OpFAPjuvsf-vh3j3gg-1; Fri, 27 May 2022 02:37:35 -0400
X-MC-Unique: k8q6OpFAPjuvsf-vh3j3gg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C057D917C03;
	Fri, 27 May 2022 06:37:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 888FE40F4964;
	Fri, 27 May 2022 06:36:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 342E61932125;
	Fri, 27 May 2022 06:36:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9B4FA1947051
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 May 2022 20:10:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 751A663F54; Thu, 26 May 2022 20:10:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EC0C82882
 for <dm-devel@redhat.com>; Thu, 26 May 2022 20:10:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B9CE1C04B44
 for <dm-devel@redhat.com>; Thu, 26 May 2022 20:10:41 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-RSvGJxw9NmGRJ2VHJaGC1w-1; Thu, 26 May 2022 16:10:39 -0400
X-MC-Unique: RSvGJxw9NmGRJ2VHJaGC1w-1
Received: from SN6PR06MB4495.namprd06.prod.outlook.com (2603:10b6:805:92::24)
 by DM8PR06MB7704.namprd06.prod.outlook.com (2603:10b6:8:32::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 20:10:37 +0000
Received: from SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe]) by SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe%3]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 20:10:37 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Martin Wilck <mwilck@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [PATCH 4/9] multipath-tools: add NetApp E-Series NVMe to
 hardware table
Thread-Index: AQHYZ+aiCmhVT7meYkS+M9Uf6jWdcq0lGSiggADdKACAADswwIAAHS6AgAtTFDA=
Date: Thu, 26 May 2022 20:10:36 +0000
Message-ID: <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
 <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
In-Reply-To: <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 432e0299-68bb-4d6c-2422-08da3f53cc57
x-ms-traffictypediagnostic: DM8PR06MB7704:EE_
x-microsoft-antispam-prvs: <DM8PR06MB770420382B800A23CE26B1198CD99@DM8PR06MB7704.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wF/u2HamaQl8IzKt50L8TdH96/6aB50u4rxs4nM2ppDYApob4ApDxri/bS2TKaavjCpZHSOQNXb8IsadtN6phxLSh6FRFNNw31Lu7JgvXzIAzMab0BVPNf278B4eavysFOyG/lwCE8ga7bAAqcg14HEjG22OmQpG18ECVwRvt5ri4RL8PiI00ZDeqpgCGojpOyDKyw+MJHKJBXBaCMS60IHMhZmCZYAajv5/KjWDsWaDCYi4zZs0eLpjd4An10C1chQHoB+ndLuhmUFiKvENB6IeSQa0ns0L77F9tlCJnWHYAFrjm3VVhmAVxxDB/y6XOk6jgGZd6uHglrDKYy5FEuY70qZDFSa0Bd1/y9jlrwTFZ2quoeH1VNC5RsiEPbyNYTAxKZWVm1pCqfTUOlmMQ0m4Knx9iYmomq5bZVMSKbwJxmaS2mxRXIEcOcOTQ0Q5VMjqRhigv1Cm41MKUz41XrU/sGHDlIdoLeiXQnobKR3GTyhDcqcQrLt0RNUPXwAfqeQoEP+yyNCRmu+AeiaOoSNlruPWP6z7BKAKwHnw4FW+U+tff7QNNjGOl1B+KmyK/hM3UYiKHVGhH72SsgbvF0A+7UI+Mn5pp5ubkSg/c3MtlhFeI7ju0vgk8Wuh3ydjVN+xSuT8uDXd/miG7KrkURaluoD2eEVVwdsQ3jD4eRBdwcQA9oHS5P8m71D+K3VyUtO5cur+rhtpdswmuOKbqw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SN6PR06MB4495.namprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(186003)(107886003)(38070700005)(71200400001)(66946007)(55016003)(76116006)(8676002)(4326008)(7696005)(316002)(54906003)(33656002)(52536014)(5660300002)(8936002)(66476007)(86362001)(66556008)(64756008)(66446008)(110136005)(2906002)(26005)(9686003)(6506007)(38100700002)(83380400001)(508600001)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L0dqWw7zN+oJoONALw6Whneqp7zVIh4weDoBh85ZCxe8H1HfJb0lZOqwmSVw?=
 =?us-ascii?Q?eRFDmilMg1Abw/mRQI7dnwlNfSY6F+ZTkV4TfMoPeyvMLKQah7ORNQXPG764?=
 =?us-ascii?Q?pRVVGhepWj2OcxFw6AexfeTfgR87HWiN4Zk7WZGky+ENJIl2SYOVuNmWPqXY?=
 =?us-ascii?Q?jx8g4amlMVbzVhMl649J3T/Zi5JWBDE8cG3AthW40jRFoHpl/Sv1hkLCbbu6?=
 =?us-ascii?Q?ljzIzoLBXUJ0snQx1vueMlZFXVwXfXldHafOIW6MWo582qdry/d9QT1rT6Ez?=
 =?us-ascii?Q?oqy7twSSOqx5cV6IYV3dLjJCOpT19JCcbSRkqx0SjBvIlodnnj0njJzmCaW9?=
 =?us-ascii?Q?pw0l/QGQqvyngx+gHDhCIBG2IzANyYhiMvNbTQgfOcrwqcny6UhwOH9+tEYD?=
 =?us-ascii?Q?gLlUTesBM+mt5dzwq+KRJE/uwuZgklkppTHguVrVoi0nvPCVm7e7ALLg52r2?=
 =?us-ascii?Q?iuNRrYL0AAMDQtwJwcBhnZ5OwCptK9KP+3ZJ2pEU3FNYBPOOOOOnA/Yw0SYx?=
 =?us-ascii?Q?6qgdzO9h7SrC0bLpkP6Xb4uHht6s8IekLwlHLmSDbIL/iE47N4u3JbDvnrGO?=
 =?us-ascii?Q?236bn13G3uO/W/1OURK3o3WBTuEBEgy007O/L5GnnjKJAJ3Om3IlXjiLOR7y?=
 =?us-ascii?Q?Gi17SvjivpUihneCX8eOotpOUDmM1Mbs30cSOYLnPDZ+G3xpW4Nt65t393Q/?=
 =?us-ascii?Q?6uh2fQygdnk02ubZPWme5MjG/ZzCQ8tVQiTItaE6s7aLTTIXeDlRgRhHjbGP?=
 =?us-ascii?Q?ZatcI+orEPp6iXKmH4spIyscJVgJLhel9QHhPamB+h9kmwDxFwBYl0IljB/s?=
 =?us-ascii?Q?GAnnItpvthO7BVfhAoGkH0T0thxml0vFw9yUN89EIP2ToVX7LGD0v8ggg1IP?=
 =?us-ascii?Q?2j0WtBTZNQpCb7k0OlsdwnqyNFLXYfDLvIC3UXNAxRM6mz+Mw8YRh7mSfRkW?=
 =?us-ascii?Q?gp5nu9YEPksQkFgUaAOi/A7u2qTK/aqKg/sWEXigHRDLwZ/GySlgbOAxcbvH?=
 =?us-ascii?Q?krFabXTxGt9HxzmfPEBX/1VWBdWQIuHTMwU0kwpYSXc3WtHgrZc9TGFs+5DG?=
 =?us-ascii?Q?AkTiT9g985xPp3CvLChh6SHrhwwBLGwlzvzfbVG83/KGjt/RpKYvuuBrHP7c?=
 =?us-ascii?Q?7/zX3AC0SvLfGYs1qE2kbFT86zmYc8Pj70KjI48XYFl8M5DsF4228bm6VNSv?=
 =?us-ascii?Q?nN0Wpdk/NK0K6J4mxBnR4m4fUyuB+oI7jovlVrLZI+HwvWy4lwZOSKRqPxgb?=
 =?us-ascii?Q?n3hUNvSHEflq29sDFgP+5S8wXNHbv5Pp7EA2VLo6HHa+2kSdSG72H6iP4qO5?=
 =?us-ascii?Q?Kxfii3S/M9fA0Yuy4Wqti45IyOCIDjAreZPauJZxTk7Ou4zms4P57EChO3kY?=
 =?us-ascii?Q?RcETSfRO9B9MZ+OQwYtSnhiZj0sCPiFtE2OdusKZGYvq/+pIgI/l643un03P?=
 =?us-ascii?Q?CHQCP7kxnv9+j8b2DP8CZzBK6N80WDcUmZg2+Dj/OQEzVT3YzR/oanEx2m5i?=
 =?us-ascii?Q?yFeojMtx8JH26DX5QciTX7AbhuELQhAmpj9WAnJqYhAt5Z9g0/Lvt1R3KtAQ?=
 =?us-ascii?Q?YLZ6tnMkPrcgQ6TPcE3djDfwKf7q9qWWpfvAqSR5ojhPo0EZFf/Lv4MvEHXD?=
 =?us-ascii?Q?SYjTMW6hCyOvOuSGWXUAcA8N0Ems8CtrJWRbEWHWZYeCUdlxaGfz3MSzKs5r?=
 =?us-ascii?Q?L91U/LeBsg3+ERYL/ODmGB/rJZ6aHhv/pyOt1JSMD8r3JbcvXg3xPhCNs8A3?=
 =?us-ascii?Q?wdXMuDwilQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR06MB4495.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432e0299-68bb-4d6c-2422-08da3f53cc57
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 20:10:36.9132 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WYuUslmN1OoT0BVup5QeQsGyFhHEYZMLAKXPAgYcXKeJ0jrUe2+DCEvHbRvZsLvJTJo9plqCspYdaskjiz//yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR06MB7704
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Fri, 27 May 2022 06:36:45 +0000
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
Cc: "George,
 Martin" <Martin.George@netapp.com>, Hannes Reinecke <hare@suse.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Martin Wilck <mwilck@suse.com>
> Sent: Thursday, May 19, 2022 9:47 AM
> Hi Steve,
> 
> On Thu, 2022-05-19 at 13:18 +0000, Schremmer, Steven wrote:
> > Martin W,
> >
> > > Steve,
> > >
> > > On Wed, 2022-05-18 at 20:24 +0000, Schremmer, Steven wrote:
> > > >
> > > > Nak. NetApp E-Series only supports these settings in certain
> > > > configurations, and we prefer to handle it via our installation
> > > > documentation.
> > > >
> > >
> > > I don't follow. What harm is done to Netapp if these settings are
> > > included? People can still follow your documentation, the end
> > > result
> > > will be the same... no?
> > >
> > > AFAICS, the only setting above that would only be supported in
> > > certain
> > > configurations is PRIO_ANA, without which GROUP_BY_PRIO doesn't
> > > make
> > > much sense. If the array is configured not to support ANA, this
> > > configuration would lead to error messages and PRIO_UNDEF for all
> > > paths, and thus "imply" multibus topology. Not beautiful, but also
> > > no
> > > big harm done, IMO.
> > >
> > > If it's that you're concerned about, please provide the set of
> > > defaults
> > > you prefer for E-Series, or explictly state that you prefer to run
> > > with
> > > the generic NVMe defaults (const prio, failover policy).
> > >
> > > In general, if vendor-recommended settings are strongly dependent
> > > on
> > > storage configuration, host-side software defaults must try to
> > > match
> > > the storage array's defaults. We shoud do this for E-Series, too.
> > > If
> > > ANA needs to be explicitly enabled on the array by the admin, we
> > > shouldn't enable it by default; but otherwise, we should.
> > >
> > > Martin
> >
> > NVMe-attached E-Series is moving towards only using the native NVMe
> > multipathing in the kernel rather than DM-MP with NVMe. At some point
> > we will stop interoperability testing with NVMe DM-MP and not certify
> > new
> > solutions with it.
> >
> > The set of defaults listed for NVMe E-Series are the correct ones,
> > but I'm not sure
> > they should be included if we aren't going to continue to test the
> > interoperability
> > of NVMe-attached E-Series and DM-MP.
> 
> Thanks for the explanation.
> 
> I believe everyone understands that the fact that the built-in hwtable
> in multipath-tools contains sensible defaults for a given storage array
> does *not* imply that this array has been tested or officially released
> by Netapp (or any storage vendor). If you want, we can add a statement
> of this kind (vendor-neutral) to our man page and/or README.
> 
> It's also understood that Netapp, like the kernel community, recommends
> native multipathing for NVMe, and discourages use of device-mapper
> multipath for NVMe devices. Native multipathing is the kernel default,
> and must be explicitly disabled either at build time or on the kernel
> command line before dm-multipath would even see the devices. IMO it can
> be assumed that a user who employs such a setup knows what she's doing,
> and is aware that the setup doesn't comply with common recommendations.
> 
> Netapp currently publishes configuration recommendations for multipath-
> tools with E-Series and NVMe. Xose's patch simply changes the built-in
> defaults to match these recommendations. We have been doing this for
> years with the intention to improve the "out of the box" experience,
> and it's a good thing.
> 
> If we didn't take this patch, we'd knowingly force suboptimal default
> settings on (admittedly few) users. Who would benefit from that?
> 
> We want to ship multipath-tools with the most reasonable defaults that
> we are aware of. Xose's continued efforts in this area have been
> immensely useful for the community of dm-multipath users. I don't think
> we should give this up. I'd like to encourage everyone to continue
> submitting improvements for the hardware table.
> 
> Regards,
> Martin
> 

Martin,

Sorry for being slow to respond to this. NetApp publishes settings for
multipath-tools for NVMe-attach E-Series for specific distribution versions
that we have qualified. Anyone using these settings outside of these
versions would NOT be in a valid system configuration for NetApp support. Are
reasonable defaults in the hardware table really useful if they cause a user
to follow a path that leads them to an unsupported system configuration?

Thanks,
Steve

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

