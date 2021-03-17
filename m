Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52706C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:15:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA5AD64F24
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA5AD64F24
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-IS8ESbCoMgu4gdtKc3yCvQ-1; Thu, 18 Mar 2021 05:15:07 -0400
X-MC-Unique: IS8ESbCoMgu4gdtKc3yCvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2442E1084D68;
	Thu, 18 Mar 2021 09:15:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1B671B5F6;
	Thu, 18 Mar 2021 09:15:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ACAE64A7CA;
	Thu, 18 Mar 2021 09:15:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12H3lf75014157 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 23:47:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7D17BC231A; Wed, 17 Mar 2021 03:47:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 761F9C2318
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 03:47:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5C92185A79C
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 03:47:38 +0000 (UTC)
Received: from esa12.fujitsucc.c3s2.iphmx.com
	(esa12.fujitsucc.c3s2.iphmx.com [216.71.156.125]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-433-uGqJv5z1PBuZP6FMfMXSFw-1;
	Tue, 16 Mar 2021 23:47:36 -0400
X-MC-Unique: uGqJv5z1PBuZP6FMfMXSFw-1
IronPort-SDR: AY2tRktzTmZelxYTOOGv95zO+YHc+MATujKJJHAPOsz1H1YCg36nRHwGE2ZF484D8DlLFFtTn+
	QxdZ1RRKQOj1JHeEaQWbCjsPtGaTxI7HgtCVJxmPZpuvfjwgNZuT9qVA6SI/7fph8jhUqKFxI8
	vEzrl1ApogsqgnEQZWi2+CnGxeUTyF24NigC2X5Ad8XQkWW+ssf8m40qV9GJrmw2l3/KOHY3pb
	obS6vGw/6cyJgssO5kkAuHfMEX1LZ2egd8e1GzkwZtgw49BquMw+EuF1FBvphTVwHzP/WKxKX0
	wxI=
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="28034617"
X-IronPort-AV: E=Sophos;i="5.81,254,1610377200"; d="scan'208";a="28034617"
Received: from mail-ty1jpn01lp2051.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.51])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 12:46:29 +0900
Received: from OSAPR01MB2913.jpnprd01.prod.outlook.com (2603:1096:603:3f::16)
	by OSYPR01MB5445.jpnprd01.prod.outlook.com (2603:1096:604:84::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18;
	Wed, 17 Mar 2021 03:46:26 +0000
Received: from OSAPR01MB2913.jpnprd01.prod.outlook.com
	([fe80::c447:a3af:7d9:f846]) by OSAPR01MB2913.jpnprd01.prod.outlook.com
	([fe80::c447:a3af:7d9:f846%3]) with mapi id 15.20.3933.032;
	Wed, 17 Mar 2021 03:46:26 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: zhong jiang <zhongjiang-ali@linux.alibaba.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH v3 05/11] mm, fsdax: Refactor memory-failure handler for
	dax mapping
Thread-Index: AQHW/gj8oXKCFpjX90yJ/yLnXTVuwqqGKuWAgAGHziA=
Date: Wed, 17 Mar 2021 03:46:25 +0000
Message-ID: <OSAPR01MB2913D9A487C1D55171C5059EF46A9@OSAPR01MB2913.jpnprd01.prod.outlook.com>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-6-ruansy.fnst@cn.fujitsu.com>
	<e1be1767-f9c0-e17a-5c14-22bb2f0ca5aa@linux.alibaba.com>
In-Reply-To: <e1be1767-f9c0-e17a-5c14-22bb2f0ca5aa@linux.alibaba.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [180.96.28.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89035986-5f36-4bb6-ee60-08d8e8f73d93
x-ms-traffictypediagnostic: OSYPR01MB5445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSYPR01MB544586316A108FF9E8858AA3F46A9@OSYPR01MB5445.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: DJgYhbJ97Gq/bvwKOpty3ZzeJ277RNw07ZprwQ71UIjRhht7uN6dTd1DcUfarUhoHe8TIjYVlpba3plT8eMP8CCVzZJ+O9DgJT6bxhGaqCiVkGjfoUJphR1r/1QTqOlyHWWCT+azaqXf9BGYHDJQvRHZO6twLdwvG0ZKSuIrSuGyxVzsnjDqVRYFuHXDxe7/vXNbogGEEPL+eyFVqIjniYovVdYpbOuBw6gEOE425UsqmfI8FL/A4gb1G5PNDT+B0Q6wrZQGEdMfECjmbcTiGhXLixG23GiN0DU2TVZPySQMqMN6yOG4JUg6IPYmgyvE5M5cazAAKDYK5PEOEU0goQo/Oq8OBbu9niQoq+5BZsBgvLgOR8FhKoMuHf/BUCTJyj5qMKGFmxp42l4YP2QlWnlprQU9VtRgZXN7HCjjYnRIjlJWIqV1zSL7FnMxhMVAHRWmMdlJ85OsqhTmf3mjaMBy9OpTW++v7zQIJmWJObfVkZvzOA6jZl/zIdndDHHSu7wpFGg61Vt9ui/OgjYVpdHh9w19rAbOZCP+mk2uwS7Iufb1wxwkLy2LdO1bg0/2
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSAPR01MB2913.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(6506007)(7416002)(186003)(71200400001)(316002)(110136005)(66556008)(54906003)(85182001)(66476007)(7696005)(66446008)(64756008)(86362001)(4326008)(55016002)(52536014)(83380400001)(8936002)(107886003)(26005)(9686003)(478600001)(76116006)(33656002)(66946007)(5660300002)(8676002)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?utf-8?B?MzRBSUtwSWl5cDFmWVArS3hSZkJvNEZvTVZIZlhEUXVmc2VYUXloREpwT0hm?=
	=?utf-8?B?R29kNkQrZDJ2Y21oV3pXTUtjengzZFlWL05paWxXNDNZMXRUQUs5ZERheDFE?=
	=?utf-8?B?MUhhUXN2RDlLSVZVeHFtY2o1bkVuellKRk00NjFJbTh1TGtPKzJ3bkFXRnRi?=
	=?utf-8?B?SXRMUzZicDB4K3lJNFc0cDZCa0xsUGQveW4yanBRYUpOejlsRFFITlBJNk5Q?=
	=?utf-8?B?RFdnWEk0R0pCNzREbE9KSytrYjM0MkxWSk8rcjY5c01yMzRIaC84WlVISFNP?=
	=?utf-8?B?d1k4ZXNieUhCUFdOamgwL0NMUjViVG9oUHFRcE1oQUFkRUo3Y1l2WW9qTysw?=
	=?utf-8?B?cGx0Sk5RZ0xndjhVaHlORjU5YWI4NFBVbjZ3V3F5Rlhjd000a3p3SkJRc0Jq?=
	=?utf-8?B?UHZXNm03VWFZWXNWcjIwT2d0eU1WUlkybktPbzltcmdLNi96a1NnWWJoU0NH?=
	=?utf-8?B?dkg1U2gwaDhSaUxNMEFWeS9UdnM5c28yb3o1S3BNcWV3enJpNXhjcWtTc0tP?=
	=?utf-8?B?SmlWV0Q3cEQ5Smh5aVNQdkRybWVENFFXQkt3ck42OHV2d21JbDFhWVN3MXpF?=
	=?utf-8?B?N3ZvN0hQb3NmUlR0Z0RSR3oyQ21xQ2FYNzgrZHV6SSt5WW53VTRtYXBFN2tL?=
	=?utf-8?B?RHp1OW0wT3RMRHFlNm95alQ2WDg4MUR4dWs4ME55T2k5RHdIRGFnTUNYVTBQ?=
	=?utf-8?B?c0YyM2Z4YURZMzdOUVZ2MFpnbHM4OVI4UWR4dzFGRm9NR3dhL0pseUN6RFhY?=
	=?utf-8?B?K3FRYndvbklLWURZTHpuNHhnR1FWUHc0NnNKK1YzZ211eFBZYlJtTjErVFJp?=
	=?utf-8?B?WHFLT2kxcjBmMnFiSlpYZ0pkUDRoczk4Sm92dVYwdVB4YlBiaGNRR2VJdm1J?=
	=?utf-8?B?L1JxZkJWOEw4QTdWSlNuNjhWejJTUm8rdDh5UVZ2OERXbFYzMW9ZQnBRMjJo?=
	=?utf-8?B?SC8xUVIxTEJLUTZrc1dyTG80SFp3RjZ5OEh5QUh1U0UweXEyeDhBajJRWjJV?=
	=?utf-8?B?ZERtTEdFd3haalNSRTZOU1NTaFVtR3MxcnB3L2RnRUd0clF3bDZta2toVkor?=
	=?utf-8?B?aTRtMG9jT1BwUnBnZysxTUtaZ09tRXBRc1QrTHlxczk4OFRqdjNycmRjRlA4?=
	=?utf-8?B?V0VmQXV5eHA2QWFFTXNyZU9BQjloOUY1UEUvM1RZVTVoS0lzWmp4cGZLbUQz?=
	=?utf-8?B?MHdGMUt3N21mdnlEYTZrU2ZFbFlpTHJNUjVSUlM4elRqMXBiazhCL0kwdWg3?=
	=?utf-8?B?VTFKSE02Vy9rTXA5SzZ6OVZPNmQxWmZrQm9kcndJck01bmFMNkdVSGcwdlNh?=
	=?utf-8?B?TkhjV2UyZ24yUVhJSWdKSy9vbldFSXZJVjhnSmw4bzRZMjY1b2EzL1R5TEE4?=
	=?utf-8?B?UVZrWmZEdW5SM1diM1htUEhyenM5TmNBVFhxaVl5bUYyUXVGNlRmTTZzUTd0?=
	=?utf-8?B?d1NzdzBYWmNreGZDRHVMazlEQkd3QzlEVE9EMkEwTU9wQUY0UTVyYUZxbE95?=
	=?utf-8?B?M1dQdUFxbGVKdndnbzZsYkpLVTJwS0V1M1pVZEJkdGZwanpHSW5ndXV2Vm9m?=
	=?utf-8?B?Zi9TQml4WnJpSjBONFN4NHJhMTlSWGhWNGdnYWpXK0UxNFdJSUYvTGJRaWhm?=
	=?utf-8?B?dGRFYWh0VzA5aWxGSGxuRnQrQ3BTeE10Wkh1YTZpYTZVUHdRRFlqbk1McG9C?=
	=?utf-8?B?WmdncnFsUDhvNUZJdnVXZm84am9QSmo1UE1FMk5uR2ZxenFNemVrUWtEdDlT?=
	=?utf-8?Q?cdLspVQhXufuSIHp1RFk9YiYyfehN2AlLwDyjdg?=
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB2913.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89035986-5f36-4bb6-ee60-08d8e8f73d93
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 03:46:25.9826 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3q7/T8OHRdZP7dVxFUxQjFog5+OAtHOXFrFPBKx1gNqjyC1rNb8WM51223zQJQahybz3n/lUwO1o5QS4qYKXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSYPR01MB5445
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12H3lf75014157
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 18 Mar 2021 05:14:45 -0400
Cc: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>,
	"rgoldwyn@suse.de" <rgoldwyn@suse.de>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"y-goto@fujitsu.com" <y-goto@fujitsu.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 05/11] mm,
 fsdax: Refactor memory-failure handler for dax mapping
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> -----Original Message-----
> From: zhong jiang <zhongjiang-ali@linux.alibaba.com>
> Subject: Re: [PATCH v3 05/11] mm, fsdax: Refactor memory-failure handler for
> dax mapping
> 
> > +int mf_dax_mapping_kill_procs(struct address_space *mapping, pgoff_t
> > +index, int flags) {
> > +	const bool unmap_success = true;
> > +	unsigned long pfn, size = 0;
> > +	struct to_kill *tk;
> > +	LIST_HEAD(to_kill);
> > +	int rc = -EBUSY;
> > +	loff_t start;
> > +
> > +	/* load the pfn of the dax mapping file */
> > +	pfn = dax_load_pfn(mapping, index);
> > +	if (!pfn)
> > +		return rc;
> > +	/*
> > +	 * Unlike System-RAM there is no possibility to swap in a
> > +	 * different physical page at a given virtual address, so all
> > +	 * userspace consumption of ZONE_DEVICE memory necessitates
> > +	 * SIGBUS (i.e. MF_MUST_KILL)
> > +	 */
> > +	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> 
> MF_ACTION_REQUIRED only kill the current execution context. A page can be
> shared when reflink file be mapped by different process. We can not kill all
> process shared the page.  Other process still can access the posioned page ?

AFAIK, the other processes will receive a SIGBUS when accessing this corrupted range.  But I didn't add a testcase for this condition.  I'll test it.  Thanks for pointing out.


--
Thanks,
Ruan Shiyang.

> 
> Thanks,
> zhong jiang
> 
> > +	collect_procs_file(pfn_to_page(pfn), mapping, index, &to_kill,
> > +			   flags & MF_ACTION_REQUIRED);
> > +
> > +	list_for_each_entry(tk, &to_kill, nd)
> > +		if (tk->size_shift)
> > +			size = max(size, 1UL << tk->size_shift);
> > +	if (size) {
> > +		/*
> > +		 * Unmap the largest mapping to avoid breaking up
> > +		 * device-dax mappings which are constant size. The
> > +		 * actual size of the mapping being torn down is
> > +		 * communicated in siginfo, see kill_proc()
> > +		 */
> > +		start = (index << PAGE_SHIFT) & ~(size - 1);
> > +		unmap_mapping_range(mapping, start, start + size, 0);
> > +	}
> > +
> > +	kill_procs(&to_kill, flags & MF_MUST_KILL, !unmap_success,
> > +		   pfn, flags);
> > +	rc = 0;
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(mf_dax_mapping_kill_procs);
> > +
> >   static int memory_failure_hugetlb(unsigned long pfn, int flags)
> >   {
> >   	struct page *p = pfn_to_page(pfn);
> > @@ -1297,7 +1346,7 @@ static int memory_failure_dev_pagemap(unsigned
> long pfn, int flags,
> >   	const bool unmap_success = true;
> >   	unsigned long size = 0;
> >   	struct to_kill *tk;
> > -	LIST_HEAD(tokill);
> > +	LIST_HEAD(to_kill);
> >   	int rc = -EBUSY;
> >   	loff_t start;
> >   	dax_entry_t cookie;
> > @@ -1345,9 +1394,10 @@ static int
> memory_failure_dev_pagemap(unsigned long pfn, int flags,
> >   	 * SIGBUS (i.e. MF_MUST_KILL)
> >   	 */
> >   	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> > -	collect_procs(page, &tokill, flags & MF_ACTION_REQUIRED);
> > +	collect_procs_file(page, page->mapping, page->index, &to_kill,
> > +			   flags & MF_ACTION_REQUIRED);
> >
> > -	list_for_each_entry(tk, &tokill, nd)
> > +	list_for_each_entry(tk, &to_kill, nd)
> >   		if (tk->size_shift)
> >   			size = max(size, 1UL << tk->size_shift);
> >   	if (size) {
> > @@ -1360,7 +1410,7 @@ static int memory_failure_dev_pagemap(unsigned
> long pfn, int flags,
> >   		start = (page->index << PAGE_SHIFT) & ~(size - 1);
> >   		unmap_mapping_range(page->mapping, start, start + size, 0);
> >   	}
> > -	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
> > +	kill_procs(&to_kill, flags & MF_MUST_KILL, !unmap_success, pfn,
> > +flags);
> >   	rc = 0;
> >   unlock:
> >   	dax_unlock_page(page, cookie);
> 


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

