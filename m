Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997F9C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0ACA4611ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0ACA4611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-rLsFjxm9OjeZboRutWNxww-1; Mon, 17 May 2021 03:51:25 -0400
X-MC-Unique: rLsFjxm9OjeZboRutWNxww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61F126D590;
	Mon, 17 May 2021 07:51:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43D9329692;
	Mon, 17 May 2021 07:51:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E72E180B463;
	Mon, 17 May 2021 07:51:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14EApTvW027450 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 May 2021 06:51:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1706F2172F1D; Fri, 14 May 2021 10:51:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 120AB207636A
	for <dm-devel@redhat.com>; Fri, 14 May 2021 10:51:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C4D6101A531
	for <dm-devel@redhat.com>; Fri, 14 May 2021 10:51:26 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-268-1LS-437ZPGugibebyB9lrQ-1; Fri, 14 May 2021 06:51:23 -0400
X-MC-Unique: 1LS-437ZPGugibebyB9lrQ-1
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id
	20210514104428epoutp0440c5f901c93d7c844c8f5d8ebbf4a2fc~_6Pg2Y4Ct2582525825epoutp04X
	for <dm-devel@redhat.com>; Fri, 14 May 2021 10:44:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
	20210514104428epoutp0440c5f901c93d7c844c8f5d8ebbf4a2fc~_6Pg2Y4Ct2582525825epoutp04X
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTP id
	20210514104428epcas1p2137dce660926fb01549871c9f6e3597c~_6PgZ55Hd0555605556epcas1p2M;
	Fri, 14 May 2021 10:44:28 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.165]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4FhQBg1sGtz4x9Px;
	Fri, 14 May 2021 10:44:27 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	64.D4.10258.B845E906; Fri, 14 May 2021 19:44:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20210514104426epcas1p3ee2f22f8e18c961118795c356e6a14ae~_6PfFHYjm1546315463epcas1p3A;
	Fri, 14 May 2021 10:44:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210514104426epsmtrp2b4b61e2a32c20e413f6f376b6f951881~_6PfEO0Pg1199011990epsmtrp2Q;
	Fri, 14 May 2021 10:44:26 +0000 (GMT)
X-AuditID: b6c32a38-419ff70000002812-57-609e548bcb48
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.13.08637.A845E906; Fri, 14 May 2021 19:44:26 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20210514104426epsmtip2751bc9e19e43c18b0a2e5d6b85b92001~_6Pe0Wb0O2557925579epsmtip2T;
	Fri, 14 May 2021 10:44:26 +0000 (GMT)
From: Changheun Lee <nanich.lee@samsung.com>
To: alex_y_xu@yahoo.ca
Date: Fri, 14 May 2021 19:26:14 +0900
Message-Id: <20210514102614.3804-1-nanich.lee@samsung.com>
In-Reply-To: <alpine.LRH.2.02.2105140544010.22439@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxT29j1eX2GwJ0K9NsbVN1kUBVpL8UrELJGZFyULCewPZQlU+gZs
	/bW+VmVmE8U6+RHGwDEpozWOsEgHTobjZwULjLIBiQFGqjBGwMG2CAymDkVYS0vGf9+55/vO
	Od+595JY8AghIrM0BlavUahowh//oXNPZERBsiVNMj4ZgOpGv+Uj29hnBGq5bwWobH4JQw9z
	nxPIPlvhh35sN/PRTVs3D03dMmPI/mAvKreMEmiw5SsCWasf8ZGjNJeHTIVLfDQyUEa8STGD
	Q8eZZvMYnxnsNzL1NXkE833VeabVlUMwF/u6MWbu7jDB9LX18JjF+h2Mw1GNJQacVB3KZBVK
	Vi9mNelaZZYmI44+npR6JFUeI5FGSA+iA7RYo1CzcXR8QmLE0SyV2w0tPq1QGd1HiQqOo6MO
	H9JrjQZWnKnlDHE0q1OqdFKJLpJTqDmjJiMyXauOlUok++VuZpoqs70kB+icQWcb7k775YDW
	gHwgICEVDe/duADygT8ZTDUBmLNk4nuDBQB/G633ZZ66M6WlvHXJyrNnmDdhB9A83++TLAL4
	Zdk87mER1D5Y9PgB4cEhlBAuWZdwDwmj7vOga7LLLx+Q5BbqBLSaKA8Hp8LgVUetnwcHUrGw
	tdMzh6fba3B5vBDzYAGVApunLuJezmbYWz61hjE3J/dOxdpEkBoiYcHqNeAVx8PilSbci7fA
	P3safEVFcHHWTngFBQDmXrYCb1AMYNV0tc+oDC4sLgLPpBi1B95qifIe74TNLyqBt3MQnH1S
	uGYGUoHwyuVgL2UX7Ls0jq33mq5t9lVkoOvShG+ndQAuz3bixUBs3mDIvMGQ+f/O1wFWA4Ss
	jlNnsJxUF73xkuvB2gsPR02g8vF8pAPwSOAAkMTokEDhqYq04EClIvsjVq9N1RtVLOcAcve6
	P8dEoela9xfRGFKl8v0ymQxFxxyIkcvorYEZR86lBVMZCgP7AcvqWP26jkcKRDm8CwfrskNF
	Tvr8Nr7tdMe221srZvCbM21Fh2sox76ql5PtjbWO31d0D+MXXifUe3vlE61hfR/bSxPej7E2
	ZSV1vvPTF98JjtWxA/ey4/IShM4/hsnR8PRfk6mUrrLVr8+0zuiHPn03KdN+paXj6txMlMCZ
	Z/rXETQ3r9sEtxfcYIY/kaVK3uoP8jtnO9Uzu7P42LUkdVfM7pLt11M2/6Ie8f/wPWejC7co
	hUdDxjrqhZKa5d4TFPcCf86F7bA+eRtV/dX1Uuy08S1k6NOFuKKBv++8Yik5s/Bz98lHytXK
	N/zLRSbUtmm3iDCHRb26kjyRHLt8tjH5n9uk4ZtdhRZTgyubxrlMhTQc03OK/wBoL72TagQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJXrcrZF6CwdOLKhbr7qxht1h9t5/N
	YtfF+YwW0z78ZLa43fyLzWLvu9msFsf2z2K3WLn6KJPFk/WzmC323tK2mDnvDpvF5V1z2Czm
	L3vKbnFocjOTRWvPT3aL6+emsTkIeFy+4u2xc9Zddo/LZ0s9Nq3qZPPYvKTeY/fNBjaPpjNH
	mT3e77vK5nFmz3Emj8+b5DwOHVrGHMAdxWWTkpqTWZZapG+XwJWxf1IDY8EJvoot+56zNjDu
	5u5i5OSQEDCR+Pf9OzOILSSwm1HizTxpiLiUxPETb1m7GDmAbGGJw4eLuxi5gEo+MkpMmn6K
	FaSGTUBHou/tLTYQW0RATOLn/J8sIEXMAk+ZJJoWnmIGaRYWCJdouu4EUsMioCox5dBasF5e
	ASuJ3Ydb2SF2yUv8ud8DdgOnQLTEzidNLBD3REn8PXSFGaJeUOLkzCdgcWag+uats5knMArM
	QpKahSS1gJFpFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcIRpae5g3L7qg94hRiYO
	xkOMEhzMSiK8YkmzE4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgST
	ZeLglGpgiqzTW58446l/zvKD8xKXb66vuqC84LR5maFqQnh7fvzVjUePP/R+siYjSonNZ2a2
	o71BRWvtvv33F056ddPfbcVtaZH+nwG/JguVeRqUXv8prF33rD3px1KNg97F7xcV8sf6XXmp
	NcHr95YTaucUyrq3TbFIWeb+6uKJfNOJdoum/b7A9XLWFrfHXa/uTY76FCF5W/eD9XI1vdZ5
	y7gYE1ZybXu/ovZgzC5xQWWjRSGJuiGGZtMzQtPSS04XBnfstXjGoZtb8/6rjyTf4mVKHver
	/fct2h+3Wu3L4QnzTmq1357Z9HB50BvtgPod05qWPlJbf+3rVmMlxpnm9/R3sBqeeXrHed8F
	Q5103m8bVZVYijMSDbWYi4oTAV1pZqQfAwAA
X-CMS-MailID: 20210514104426epcas1p3ee2f22f8e18c961118795c356e6a14ae
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210514104426epcas1p3ee2f22f8e18c961118795c356e6a14ae
References: <alpine.LRH.2.02.2105140544010.22439@file01.intranet.prod.int.rdu2.redhat.com>
	<CGME20210514104426epcas1p3ee2f22f8e18c961118795c356e6a14ae@epcas1p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14EApTvW027450
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 17 May 2021 03:51:00 -0400
Cc: axboe@kernel.dk, ming.lei@redhat.com, tytso@mit.edu, bvanassche@acm.org,
	bgoncalv@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	hch@lst.de, linux-block@vger.kernel.org, dm-devel@redhat.com,
	yi.zhang@redhat.com, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org, gmazyland@gmail.com
Subject: Re: [dm-devel] regression: data corruption with ext4 on LUKS on
 nvme with torvalds master
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> On 5/13/21 7:15 AM, Theodore Ts'o wrote:
> > On Thu, May 13, 2021 at 06:42:22PM +0900, Changheun Lee wrote:
> >>
> >> Problem might be casued by exhausting of memory. And memory exhausting
> >> would be caused by setting of small bio_max_size. Actually it was not
> >> reproduced in my VM environment at first. But, I reproduced same problem
> >> when bio_max_size is set with 8KB forced. Too many bio allocation would
> >> be occurred by setting of 8KB bio_max_size.
> > 
> > Hmm... I'm not sure how to align your diagnosis with the symptoms in
> > the bug report.  If we were limited by memory, that should slow down
> > the I/O, but we should still be making forward progress, no?  And a
> > forced reboot should not result in data corruption, unless maybe there
> 
> If you use data=writeback, data writes and journal writes are not 
> synchronized. So, it may be possible that a journal write made it through, 
> a data write didn't - the end result would be a file containing random 
> contents that was on the disk.
> 
> Changheun - do you use data=writeback? Did the corruption happen only in 
> newly created files? Or did it corrupt existing files?

Actually I didn't reproduced data corruption. I only reproduced hang during
making ext4 filesystem. Alex, could you check it?

> 
> > was a missing check for a failed memory allocation, causing data to be
> > written to the wrong location, a missing error check leading to the
> > block or file system layer not noticing that a write had failed
> > (although again, memory exhaustion should not lead to failed writes;
> > it might slow us down, sure, but if writes are being failed, something
> > is Badly Going Wrong --- things like writes to the swap device or
> > writes by the page cleaner must succeed, or else Things Would Go Bad
> > In A Hurry).
> 
> Mikulas


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

