Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DC8C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 06:25:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-Qp5ydtFyO-OH-LyHw4lD0A-1; Mon, 28 Feb 2022 01:25:23 -0500
X-MC-Unique: Qp5ydtFyO-OH-LyHw4lD0A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BEEC1854E21;
	Mon, 28 Feb 2022 06:25:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E07B54EC6E;
	Mon, 28 Feb 2022 06:25:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDC844A701;
	Mon, 28 Feb 2022 06:25:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21P3iQcc002725 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Feb 2022 22:44:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DD7F42026D64; Fri, 25 Feb 2022 03:44:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D83312023434
	for <dm-devel@redhat.com>; Fri, 25 Feb 2022 03:44:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8674529AA382
	for <dm-devel@redhat.com>; Fri, 25 Feb 2022 03:44:21 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-596-i4QCQPqWMdS7cLHktn00NQ-1; Thu, 24 Feb 2022 22:44:17 -0500
X-MC-Unique: i4QCQPqWMdS7cLHktn00NQ-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id
	20220225034414epoutp0450718f72c78f874e0fb57b31c70ccadf~W6phiETuI0602606026epoutp04k;
	Fri, 25 Feb 2022 03:44:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
	20220225034414epoutp0450718f72c78f874e0fb57b31c70ccadf~W6phiETuI0602606026epoutp04k
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20220225034413epcas5p132b963987cc4f7a5cbd9fff0a657529f~W6pg8XAN51032610326epcas5p1o;
	Fri, 25 Feb 2022 03:44:13 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4K4bH82KPqz4x9QG;
	Fri, 25 Feb 2022 03:44:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DA.BC.05590.48058126; Fri, 25 Feb 2022 12:44:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20220224120720epcas5p4437444a45856edbf828bf377207a6f06~Wt3gHzRD_2573725737epcas5p47;
	Thu, 24 Feb 2022 12:07:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220224120719epsmtrp1c47bedc43baaf8c001c483aca859fc23~Wt3gEQOmk0539305393epsmtrp1f;
	Thu, 24 Feb 2022 12:07:19 +0000 (GMT)
X-AuditID: b6c32a4b-723ff700000015d6-a5-621850842539
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	28.30.29871.7F477126; Thu, 24 Feb 2022 21:07:19 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20220224120715epsmtip1faf192d135aed15d61e8c768642ca090~Wt3brgvle0640906409epsmtip1c;
	Thu, 24 Feb 2022 12:07:15 +0000 (GMT)
Date: Thu, 24 Feb 2022 17:32:18 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Message-ID: <20220224120218.GA9117@test-zns>
MIME-Version: 1.0
In-Reply-To: <YhWGDUyQkUcE6itt@bombadil.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH97v39raw1V3x9bNGh1UYyLNS6g+i24yNuxOTsZDsD+PSXeEG
	qqXt2uJrQdE6kgoEqNNBJYrbGAMXngsBSwkWWbW+YB0IBkFG60TCw9eEgHStFxb/+5zvOed3
	zu+cHAEe1M8XCZRqA6tTMyoxGUg0dYSHRZ1KhvtiZ5uXoFrnHzhq7X/OQ5cfFJLo3NQMjiav
	jvCQubCEj1zuJcg2cZ6HuqZPYGikwYuh1h/NGKq63Imhfyp/Ash66SmGTDe7MDQ3LEGd3nES
	me29AHl6LBiy3Y9ArbYbBHJdKSPRxV88fJR3r5lEbWM2HFU65jHUV+QB6I5ljkTN7hMAdQz2
	EKhmbJJAY9M3SJRb/xKg7/Jn+Ojuawfvkw20668k2jJ0m6SLjRN8usXygE/fHawnaGP5AEG7
	bmfRDdUmkm78+Th9pq8S0Nb+HJI+easTp0uevSDpAuMEST/13CfoybYeMnnlngNbM1gmjdUF
	s+pUTZpSnb5NnJSi2KGIl8VKoiQJaIs4WM1kstvE8t3JUTuVKt8QxcEHGVWWT0pm9HpxzEdb
	dZosAxucodEbtolZbZpKK9VG65lMfZY6PVrNGhIlsbGb432BXx/ImG+y4lrXysPuahuRA8xL
	T4MAAaSksK7jCe80CBQEUVYA82qn+X5HEPUMwHPuvZzjXwCdZV28xYznxm6cc9gArCgbJzjj
	EYBT42Vv0gkqBE5MmX1RAgFJRcCbXoFfXk6FwbaiAszPOPWShMV39vhDllFfwq72EL8spCLh
	QP9DHsdL4Y1SN+HnAEoGPeNm0s8rqA2wvcmBcf2UBsICO+RYDk/NmXCOl8Enjt/5HIvgaGEu
	398mpPIAnL41hHFGCYDGIiPJRX0Mu1tfLzSXAUtf5QNOXwvPOmsW9CWwYNa9UFkImy8s8gb4
	W235wjurYe+rEwtMQ4frMckNqAWDDydziSLwgeWt31neqsdxJCy3PiMtvsHg1BpYOS/gMBzW
	XokpB7xqsJrV6jPTWX28Nk7NHvp/4amazAbw5sY2JTWDvx9ORdsBJgB2AAW4eLlwJHvVviBh
	GnPkKKvTKHRZKlZvB/G+XRXjohWpGt+Rqg0KiTQhViqTyaQJcTKJeJXQmV7HBFHpjIE9wLJa
	VreYhwkCRDnY+euNmpCpGHjlqq39pOU49acpvfH2ZlE+KZcOdo72Do+qbN+PtPcqj1XsF2/s
	Xpdm9U6UCszbVyQW79rpdn6z1vFrR1x5nf3IOzse1SSOVBe2HB5N2W06l/3uXJZhPQLVe0OH
	u+4wqy9cP1vpbRl4D42/L4zLeVwBLl47+Fng+vpPncdeK+WENSpUGP5CgcJAoWg4VpmroN3u
	ggRniTlAvKt2/0CusTgKfTv4hcTryeT31DVLPwzNvic6PCSvv3CoaN0PW8581f30qPx0/5rQ
	iMgXlqEg1Uz93QpHTwqTNLbs0rGYjcdDXL2fK8+YrlVV9alno/d7+sLtU0eyj9I1M2JCn8FI
	NuE6PfMfIi36juwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsWy7bCSnO73EvEkg88H9S3WnzrGbLHn5mdW
	i9V3+9kspn34yWzx/uBjVotJ/TPYLS4/4bPY+242q8WFH41MFo83/Wey2LNoEpPFytVHmSye
	L1/MaLF74Ucmi87TF5gs/jw0tDj6/y2bxaRD1xgtnl6dxWSx95a2xZ69J1ksLu+aw2Yxf9lT
	dovu6zvYLPa93stssfz4PyaLGxOeMlqcm/WHzWLHk0ZGi8P3rrJYrHv9nsXi9Y+TbBZtG78y
	WrT2/GS3OP/3OKuDssflK94es+6fZfOY2PyO3WPnrLvsHufvbWTxaF5wh8Xj8tlSj02rOtk8
	Ni+p95h8Yzmjx+6bDWweTWeOMnvM+PSFzaO3+R2bx8ent1g83u+7yhYgFsVlk5Kak1mWWqRv
	l8CV8XrtW7aCySIVL38uYWtgfM3XxcjJISFgIvG5+SJzFyMXh5DAbkaJizNbWSESkhLL/h5h
	hrCFJVb+e84OUfSEUeLw/K+MIAkWAVWJdx8mARVxcLAJaEuc/s8BEhYR0JDYN6GXCaSeWeA3
	m8TGuQfBaoQFwiQuHFAFqeEV0JG4c/MBK9RiJoltk7YyQyQEJU7OfMICYjMLaEnc+PeSCaSX
	WUBaYvk/sPmcAmYST99OYgOxRQWUJQ5sO840gVFwFpLuWUi6ZyF0L2BkXsUomVpQnJueW2xY
	YJiXWq5XnJhbXJqXrpecn7uJEZx+tDR3MG5f9UHvECMTB+MhRgkOZiURXtNCsSQh3pTEyqrU
	ovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamHwNn0S+lbMNubz+sfN1
	7XCuexHyIiFTThYsLfgxoXSFOf81m4SismdJ2a//3BbvW2xj0pyu1PpjbvIdU5cNRpkLmlL5
	7jx4Jn+x7/uRXumeosrdGntajJwM3a7Mm/u4kP3Jqhn7W6TkVfYK8qgqvIqZ2H7D5lBpC3ON
	ZIvkxBQx7ZNKq2ZMEy33vcgVcLeh8Y0E+68zIXGtEVNTVFzUfeOVc6XLnU2lsrXlndd1bGNQ
	cpNwMrvL/sNdZMWUro0dhlbZLBunbF5x+4vBmamLTCIvrXju4tpapuN7VyViG4Osd7f192Oh
	jKxspa5rdM+EtC17Ge0r+FbpbfwmjVy7v9PFwgrfrvgScSfBMkiJpTgj0VCLuag4EQDIVSLd
	rgMAAA==
X-CMS-MailID: 20220224120720epcas5p4437444a45856edbf828bf377207a6f06
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080605epcas5p16868dae515a6355cf9fecf22df4f3c3d
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080605epcas5p16868dae515a6355cf9fecf22df4f3c3d@epcas5p1.samsung.com>
	<20220214080002.18381-3-nj.shetty@samsung.com>
	<20220217090700.b7n33vbkx5s4qbfq@garbanzo>
	<20220217125901.GA3781@test-zns>
	<YhWGDUyQkUcE6itt@bombadil.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Feb 2022 01:25:13 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, Smart <james.smart@broadcom.com>,
	hch@lst.de, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com, James,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 02/10] block: Introduce queue limits for
 copy-offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
	boundary="----w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_b23b0_"

------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_b23b0_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Feb 22, 2022 at 04:55:41PM -0800, Luis Chamberlain wrote:
> On Thu, Feb 17, 2022 at 06:29:01PM +0530, Nitesh Shetty wrote:
> >  Thu, Feb 17, 2022 at 01:07:00AM -0800, Luis Chamberlain wrote:
> > > The subject says limits for copy-offload...
> > > 
> > > On Mon, Feb 14, 2022 at 01:29:52PM +0530, Nitesh Shetty wrote:
> > > > Add device limits as sysfs entries,
> > > >         - copy_offload (RW)
> > > >         - copy_max_bytes (RW)
> > > >         - copy_max_hw_bytes (RO)
> > > >         - copy_max_range_bytes (RW)
> > > >         - copy_max_range_hw_bytes (RO)
> > > >         - copy_max_nr_ranges (RW)
> > > >         - copy_max_nr_ranges_hw (RO)
> > > 
> > > Some of these seem like generic... and also I see a few more max_hw ones
> > > not listed above...
> > >
> > queue_limits and sysfs entries are differently named.
> > All sysfs entries start with copy_* prefix. Also it makes easy to lookup
> > all copy sysfs.
> > For queue limits naming, I tried to following existing queue limit
> > convention (like discard).
> 
> My point was that your subject seems to indicate the changes are just
> for copy-offload, but you seem to be adding generic queue limits as
> well. Is that correct? If so then perhaps the subject should be changed
> or the patch split up.
>
Yeah, queue limits indicates copy offload. I think will make more
readable by adding copy_offload_* prefix.

> > > > +static ssize_t queue_copy_offload_store(struct request_queue *q,
> > > > +				       const char *page, size_t count)
> > > > +{
> > > > +	unsigned long copy_offload;
> > > > +	ssize_t ret = queue_var_store(&copy_offload, page, count);
> > > > +
> > > > +	if (ret < 0)
> > > > +		return ret;
> > > > +
> > > > +	if (copy_offload && !q->limits.max_hw_copy_sectors)
> > > > +		return -EINVAL;
> > > 
> > > 
> > > If the kernel schedules, copy_offload may still be true and
> > > max_hw_copy_sectors may be set to 0. Is that an issue?
> > >
> > 
> > This check ensures that, we dont enable offload if device doesnt support
> > offload. I feel it shouldn't be an issue.
> 
> My point was this:
> 
> CPU1                                       CPU2
> Time
> 1) if (copy_offload 
> 2)    ---> preemption so it schedules      
> 3)    ---> some other high priority task  Sets q->limits.max_hw_copy_sectors to 0
> 4) && !q->limits.max_hw_copy_sectors)
> 
> Can something bad happen if we allow for this?
> 
> 

max_hw_copy_sectors is read only for user. And inside kernel, this is set
only by driver at initialization.


------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_b23b0_
Content-Type: text/plain; charset="utf-8"


------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_b23b0_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_b23b0_--

