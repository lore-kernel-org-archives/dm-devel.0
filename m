Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9EEEE57DF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 07:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694417310;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=l3zuCf9ebYW6bZdcBigBZv1QHRAl3GHsdH6Xe5sZBbo=;
	b=UObDK1n4MH96iV2PPd0eP/tUc3USoNqtGwfCm5r72x+6k8jH434+xX0yFaxOmjq6ywNkff
	/PSF+ORXNju/W0Y9YBpJlb6S5hbl38CHNtruzLidISG0wcXSMg1bq6eP9FJVJQ4KUp80tA
	4J8Dj1rjdnYI4NMjXzJDsao/07330MI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-otfjb4qnP62_DxWty9ioiQ-1; Mon, 11 Sep 2023 03:28:26 -0400
X-MC-Unique: otfjb4qnP62_DxWty9ioiQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D8433C02B66;
	Mon, 11 Sep 2023 07:28:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9C6810F1BE8;
	Mon, 11 Sep 2023 07:28:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7357819465A0;
	Mon, 11 Sep 2023 07:28:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6F6551946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 07:28:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B10440C2009; Mon, 11 Sep 2023 07:28:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 439D540C2064
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 07:28:17 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E09311C060C4
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 07:28:16 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-LK0S_ybTPlGnDXQjRdJ6nA-1; Mon, 11 Sep 2023 03:28:14 -0400
X-MC-Unique: LK0S_ybTPlGnDXQjRdJ6nA-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230911072811epoutp013875042c69db5d03b5dce8106e46f989~Dx4ybALWy2979229792epoutp013
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 07:28:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230911072811epoutp013875042c69db5d03b5dce8106e46f989~Dx4ybALWy2979229792epoutp013
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230911072810epcas5p1d562705d89cfbb6478ca8b261932bcdc~Dx4x02aCc0929309293epcas5p1H;
 Mon, 11 Sep 2023 07:28:10 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4Rkdbs5Kl4z4x9Q2; Mon, 11 Sep
 2023 07:28:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
 20.82.19094.981CEF46; Mon, 11 Sep 2023 16:28:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230911071326epcas5p3600b9cef197147920fe1e3b4ab2779eb~Dxr5xvs_B1633516335epcas5p3e;
 Mon, 11 Sep 2023 07:13:26 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230911071326epsmtrp14b58900234d6bef91d34adefe1eac313~Dxr5wxixP1320513205epsmtrp1d;
 Mon, 11 Sep 2023 07:13:26 +0000 (GMT)
X-AuditID: b6c32a50-39fff70000004a96-19-64fec189d7e9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 8A.B4.08788.51EBEF46; Mon, 11 Sep 2023 16:13:25 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230911071323epsmtip1e24502945ef6ea5aa939e28947e74d3d~Dxr3KQ5gg0358803588epsmtip1M;
 Mon, 11 Sep 2023 07:13:23 +0000 (GMT)
Date: Mon, 11 Sep 2023 12:37:24 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20230911070724.GA28177@green245>
MIME-Version: 1.0
In-Reply-To: <cb767dc9-1732-4e31-bcc6-51c187750d66@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH/d3bXi5snZcK4wdMJdds4bEC1bZeHMwpzF0jMsYiCSamdPSO
 EqBt+hjilsDmgOCDhyCZ5SGCgMACoyUElQ4sShUkBpUWms1XAANkMJiIi4Ot5cLif59zzvf8
 zjm/k4Oj/FXMD09T6hiNUpZBYh6crv6gQEHhjVV5eK41kGofHECp1t+LMWq2fxFQE30FgDLP
 VXKp8b6rCNVTdw6hmltvIdQ5iw1Qk6MGhDI7QqhL+Zc5VI/5Dod6cK0Koy42TrpRTdZVhBor
 mQRU2+w8h7rt8KfurVi5n3jR9x51cOgHw3ra2FKI0abLOfT18VyMri8q49JnT85h9MKkg0PP
 /zqK0UWdLYA2DX1L/2XcRhsn/kDieUfTIxWMTM5oAhhlikqepkyNIg99KY2WiiXhQoEwgtpN
 BihlmUwUGRMbLziQluEclQz4Rpahd7riZVotGfZxpEal1zEBCpVWF0UyanmGWqQO1coytXpl
 aqiS0e0RhofvFDuFyemK0vt2VF3ucXykdBzLBVfxU8Adh4QIzt9aRk4BD5xP9AA4/eonwBqL
 AM7bO1GXik+8BLDd+tZGRsU/Z9YzzACuvDZxWWMKwBHTojOC4xziffh3ZZYLMSIEDv27Vs2L
 IOFCgcXNJUeJJxxYarSjLs0WYi9ctnm5kEcI4PP8d11yHuEJ71yY4LjYnfgIGrv7MBd7Eztg
 X5d1rQVIlLnD0WcNa89AIgY+MtJsm1vgjLXTjWU/OF2cv85ZsLn8Csbm/gigwW4AbGAvzBss
 XpsXJRTQUXYXZf1b4fnBNoT1vwPPvp5AWD8Pdtds8A74c3stxrIvtC1/v840rF9+yGG/ZwHA
 geE5tARsN7wxnOGNeix/CGuvL2IG5zwo4Q+bVnEWg2D7tbBawG0Bfoxam5nKpIjVQoGSyfp/
 3ymqTCNYO4Tg+G7Q+stKqAUgOLAAiKOkF09nWZHzeXJZ9glGo5Jq9BmM1gLEzlWVon7eKSrn
 JSl1UqEoIlwkkUhEEbskQtKHN5tXLecTqTIdk84wakazkYfg7n65yOkTFO29K3HrjKLmSY8p
 WvBVZNhJTz6v48yUcD5bX1pUnEN/UHEj7kh/QWPaxeeKzRFNV967f3Ppi98+hfurZmxD+xIa
 /XwTG4aRu53KbP+3b8fZY7+rloJNWNzx6P7sEBhcXDF95GjXq6WxsN6XJTVtUYk/iBPq8c/D
 bpqbljxikyXnI5pnv/Z8kaQXdU/t7tvjSAp8WumVNFejr86KET3uB73ArgtyVBw+FjPTEV3e
 qxzO+4w7MpN1ANv5+IW4cO6Q9bB1KvlYbOX2P+PHa8wJ9px90s22noPWugubmvgO8zatT9zT
 /AbkIHm67mG0pWK000dcMuY7YErCqi7Zng2THK1CJgxGNVrZf9JDBzmRBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWy7bCSnK7ovn8pBi+XW1usP3WM2WL13X42
 i9eHPzFaPDnQzmix991sVoubB3YyWexZNInJYuXqo0wWkw5dY7R4enUWk8XeW9oWC9uWsFjs
 2XuSxeLyrjlsFvOXPWW3WH78H5PFjQlPGS3WvX7PYnHilrTF+b/HWR1EPM7f28jicflsqcem
 VZ1sHpuX1HvsvtnA5rG4bzKrR2/zOzaPj09vsXi833eVzaNvyypGj82nqz0+b5Lz2PTkLVMA
 bxSXTUpqTmZZapG+XQJXRtOlXuaCK+wVPT+esTcwTmLrYuTkkBAwkZj2p4epi5GLQ0hgN6PE
 v5N9TBAJSYllf48wQ9jCEiv/PWeHKHrCKLHr4xKgBAcHi4CqxM/Z5SAmm4C2xOn/HCDlIgJK
 Eh/bD4GVMws8YZGY+/chWLmwgL3E92siICavgK7E8zYxiIkfGSV+d+5gBenlFRCUODnzCQuI
 zSygJXHj30smkHpmAWmJ5f/AxnMKWEts2nEA7HxRAWWJA9uOM01gFJyFpHsWku5ZCN0LGJlX
 MUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEx7GW1g7GPas+6B1iZOJgPMQowcGsJMJb
 cuhvihBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeb697U4QE0hNLUrNTUwtSi2CyTBycUg1MudXf
 4ktYwhKj5qterlRYYhkj3PjHIPCe35bvPAaHbr6K+FfIqGbOuCNXuf1nnJdamsLGgzeVTjm7
 qzM2G9pEmIptakhznnjafEE0/+qTfqd6NSqeKLaV/XK8bvvj5pIdO06um6Z8Y8LzoKTAN5a3
 I+Pif5jERwaezDAQ67T1P3RS2qz32eqsd9kv3nCVB25zfyla+uJ92mrPkB3mh6K9lGc1HZDo
 OVWw5LXHi8xz9RVrSu1vdcyMTpNuY5gcXRMRXXyk94Tdz70pQTby0QH7tVgTu6YGv1hy/uyT
 ljNaimdeva+5Zqh7rEN1/pWEy66lXzat/H17nq3e6tpfrTN3XmZamv5O4MwlzQCWyOtKLMUZ
 iYZazEXFiQBBrOgmUgMAAA==
X-CMS-MailID: 20230911071326epcas5p3600b9cef197147920fe1e3b4ab2779eb
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164407epcas5p3f9e9f33e15d7648fd1381cdfb97d11f2
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164407epcas5p3f9e9f33e15d7648fd1381cdfb97d11f2@epcas5p3.samsung.com>
 <20230906163844.18754-10-nj.shetty@samsung.com>
 <cb767dc9-1732-4e31-bcc6-51c187750d66@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v15 09/12] dm: Add support for copy offload
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, linux-doc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, mcgrof@kernel.org,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----EkYAGCX2vluH006HpQv8E927.wBqYttzOq6t00vxo_cq_k4p=_daab9_"

------EkYAGCX2vluH006HpQv8E927.wBqYttzOq6t00vxo_cq_k4p=_daab9_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Fri, Sep 08, 2023 at 08:13:37AM +0200, Hannes Reinecke wrote:
> On 9/6/23 18:38, Nitesh Shetty wrote:
> > Before enabling copy for dm target, check if underlying devices and
> > dm target support copy. Avoid split happening inside dm target.
> > Fail early if the request needs split, currently splitting copy
> > request is not supported.
> > 
> And here is where I would have expected the emulation to take place;
> didn't you have it in one of the earlier iterations?

No, but it was the other way round.
In dm-kcopyd we used device offload, if that was possible, before using default
dm-mapper copy. It was dropped in the current series,
to streamline the patches and make the series easier to review.

> After all, device-mapper already has the infrastructure for copying
> data between devices, so adding a copy-offload emulation for device-mapper
> should be trivial.
I did not understand this, can you please elaborate ?

Thank you,
Nitesh Shetty

------EkYAGCX2vluH006HpQv8E927.wBqYttzOq6t00vxo_cq_k4p=_daab9_
Content-Type: text/plain; charset="utf-8"


------EkYAGCX2vluH006HpQv8E927.wBqYttzOq6t00vxo_cq_k4p=_daab9_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------EkYAGCX2vluH006HpQv8E927.wBqYttzOq6t00vxo_cq_k4p=_daab9_--

