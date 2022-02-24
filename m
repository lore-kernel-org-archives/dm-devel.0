Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886A6C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 06:26:05 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-tRCYoF1GNdCIfPYkWVUzEw-1; Mon, 28 Feb 2022 01:25:23 -0500
X-MC-Unique: tRCYoF1GNdCIfPYkWVUzEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21E661854E26;
	Mon, 28 Feb 2022 06:25:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2431795A7;
	Mon, 28 Feb 2022 06:25:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 470F61809CB3;
	Mon, 28 Feb 2022 06:25:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21P3io2t002735 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Feb 2022 22:44:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E2BF94010A03; Fri, 25 Feb 2022 03:44:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE206400E114
	for <dm-devel@redhat.com>; Fri, 25 Feb 2022 03:44:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1858106655A
	for <dm-devel@redhat.com>; Fri, 25 Feb 2022 03:44:49 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-97-G_4P0phmMraTjLdwF2iLGA-1; Thu, 24 Feb 2022 22:44:45 -0500
X-MC-Unique: G_4P0phmMraTjLdwF2iLGA-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id
	20220225034442epoutp031d962e134e1ec9dd086e76561e17b0d3~W6p8ClBT02904429044epoutp03c;
	Fri, 25 Feb 2022 03:44:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
	20220225034442epoutp031d962e134e1ec9dd086e76561e17b0d3~W6p8ClBT02904429044epoutp03c
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20220225034441epcas5p1eadca5356fef15af328f1804164ef447~W6p7j0Aax1918519185epcas5p1k;
	Fri, 25 Feb 2022 03:44:41 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4K4bHW4tD4z4x9QT;
	Fri, 25 Feb 2022 03:44:23 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C5.DC.05590.79058126; Fri, 25 Feb 2022 12:44:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20220224121800epcas5p2bdfb52a9ae9e52068b73128cbe1895b7~WuA0NSwEI1060910609epcas5p2f;
	Thu, 24 Feb 2022 12:18:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220224121800epsmtrp2f24affef1a1e089cb16436d2e30fb89c~WuA0Ko9xd2135121351epsmtrp25;
	Thu, 24 Feb 2022 12:18:00 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-de-621850971644
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	66.01.29871.77777126; Thu, 24 Feb 2022 21:17:59 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20220224121755epsmtip18a16fa986ab7cb514bc61b630525edd0~WuAvrUana1457514575epsmtip18;
	Thu, 24 Feb 2022 12:17:55 +0000 (GMT)
Date: Thu, 24 Feb 2022 17:42:58 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220224121258.GB9117@test-zns>
MIME-Version: 1.0
In-Reply-To: <98ddab1b-6702-f121-9fef-0ce185888a1a@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzH59x79+7CDHQDjQPmQAtOyntjlw4glRPD3AZqSGbQ6A+6wp2F
	gN1td0FtJgKJHF7y0AQuJhgVICS6KMNjUQSBeFOLxEuJlzGiyysMUiBgl8b/Pr/v+f5+53d+
	Z34C3GKCbyOIkqlZpYyJEZKmRE3LIUeXvCB4wj2xwBZVdbbhSDu8zEMVD7JIdHFhDUfzd6d4
	KDcrn4+e9/ThSDdtjhr1hTzUv5qEoSnNJoa0P+RiqLyiFUN/lZYA1HBlEUOpXf0YejEhQq2b
	T0mU2zwI0Mx9DkONI05I29hBIF39JRIV/TzDR+l/1JLo9lwjjkrbNzA0lD0DUC/3gkS100kA
	tTy8T6Brc/MEmlvtING3N1YASslY46O+9Xbeew60biCA5sZ7SDonWc+n67gHfLrv4Q2CTi4e
	I2hdTxytuZpK0tU/fk2fHyoFdMNwIkmf6W7F6fylv0k6M1lP0nUp4zx6cWaECLIKjT4cyTIR
	rNKOlYXLI6JkUl9hQHDY+2EST3eRi8gLvS20kzGxrK/QLzDIxT8qZmuSQrt4JiZuSwpiVCqh
	2zuHlfI4NWsXKVepfYWsIiJGIVa4qphYVZxM6ipj1d4id/e3JFvGz6Ij51fP8RVFtqfacp7w
	EoEGpgETAaTEMGW0BEsDpgILqgHAmd47hCFYArBlNMkYPAMwK6mUv5uysnAXNxw0AjiWnM43
	BI8A5KZ68W0XQR2AdxI7eGlAICApJ9i1KdiW91AS+DQjZacqTn3PhxebKnY8llQI7G86sO0x
	o5xhRkUe38Cvwo6CaWKbTSh/qG/L4m3zXsoeNtW07/QNqQJTmPf7vzxDd37wl8wyI1vCx+03
	jV3bwGV9I2lISAdwtXvcmJ0PYHJ2MmlwvQt/065j24xTkVB3+yww6Pvhd53XjLo5zHw+jRl0
	M1h7eZftYWVVsbGONRz8J8nINGzXzZKGEa1gUPNNGcgGttxLz+Neus/AzrC4YYnktiaDU/tg
	6YbAgIdgVb1bMeBdBdasQhUrZVUShYeMPfn/n4fLYzVgZ9ccA2rB5J8Lrs0AE4BmAAW4cI/Z
	1FdWJyzMIpjTX7JKeZgyLoZVNQPJ1m/l4DZ7w+VbyypTh4nEXu5iT09PsZeHp0hoZdYpvc5Y
	UFJGzUazrIJV7uZhAhObREwyUXlv4eM5qbeoX/MoEZa+7jN0ruZXiw0TiS2YDV4sMP/ow8uY
	j/iUFx3qExX4zMEWpxI+De4qcrt1OsE8yJmTbjT0lw/xwuzXRkdwO31LuYuUse38AA/pPmrh
	f3PZ4WDKdOG9ifpX+ruG/S7UWVZCG9PRN2ZZPNR6g3pyvEgekXZJYjc2StkvO03HfnHm8fhR
	gpxwOnLsrLOj7M14cUpgdfHYrf1WS+0Hucn4iNHr7hc++dx0XU2knkwo8eF8B0byxtLVm9wG
	r0wnqZ7Uk0de02hr20ISjvukHxO7UlPIXD7vXeh4pWPfT2kDtdqYcOsmG9whDBuc5HyRxoMR
	EqpIRuSIK1XMfxKftK/0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxiG856vHtBuh+rgRYmZ3cwiuEIV5M2yLGoydhLcNMuyH8syV+QM
	CFBZj4jOqAXGjAUGFrBwUNfqIqF1bmJSwLabVPkoyOhWEVCBbm2Hs2uhE4KEr6WwZf6781zX
	ff96aFyiJzfQOcrDnEqpyJNSkYT5tnTT60VFMRlJA/0p6PveLhxZR56SyDRaRaFzU3M4muzw
	kEhbVS9C8/0DOHJ5X0C2YCOJnM+KMeRpWcaQ9ZIWQ82mTgxNNF0GyGIIYehMnxNDC7/JUedy
	gEJa+32AfIMChmwPEpDV5iCQ6+Z5Cn1zxSdC5UNtFPrRb8NRU/cShoarfQD9LCxQqM1bDNDt
	sUECXfNPEsj/zEGhr67PAFRWMSdCA4vd5K5XWde9dFYY76fYs6VBEdsujIrYgbHrBFuqf0Sw
	rv5CtsV4hmJvfHuKrRluAqxlRE2xJXc7cbb+72mKrSwNUmx72TjJhnwPiP0xH0W+mcnl5Rzh
	VIlvfRqZfXrxPFUwHnd0+us+XA3KozUggoZMMpyZ6sA1IJKWMBYAJ2zNYBXEwiuLd/DVvA42
	L02IViUvgIE/qrEwIJgt8Ce1g9QAmqaYBNi3TIfP65kUGKgoI8I+zlwWQfdj94qzjvkQOm9t
	CTtiZhusMOn+3ZzFoN44g62CKOho8BLhjDPxcHjpTyzcxZmNsGlpZT+CSYPBrioynF9iXoG3
	zN1YNYgSnmsLz7WF/9t6gBtBLFfA52fl8/ICuZIrkvGKfL5QmSU7eCi/Baw8UfzWNtBqnJLZ
	AUYDO4A0Ll0vTvk8OkMizlQc+4JTHTqgKszjeDvYSBPSGLFT4zggYbIUh7lcjivgVP9RjI7Y
	oMb2JJpr6oxHRSfeP3kTDMH9Tw5+ssfXe+L3BPmYT1axbGnbLpgbfsn91XVPR16a3trs36kJ
	lbzxV50sOzXZ4iOrY0Px31E/1JZH7UMX3W7tNvPQx9bi0K7PYgYbPan++853ZtY2THpU14b5
	9+5cvfo4oyjV+bKmK/f4qDJd1qqoh5sbFtYeGzGUzJb2AMAk9doyK6fqTs8lXZwfyUl87Uic
	YcdZfvFLXavYoI59atVvbpSkZdRXcjV77z7xqgN99p4bhC9ZVxs3bUqrkjvmtec+KK5NcIzv
	vtCxV4BwzQVdi+mRITUiOOl+O+AvF8r2tXvenU3f5LQWvmiNfri7R0rw2Qp5PK7iFf8AKN0B
	x7MDAAA=
X-CMS-MailID: 20220224121800epcas5p2bdfb52a9ae9e52068b73128cbe1895b7
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
	<98ddab1b-6702-f121-9fef-0ce185888a1a@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Feb 2022 01:25:13 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, msnitzer@redhat.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, Smart <james.smart@broadcom.com>,
	hch@lst.de, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, javier@javigon.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com, James,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	Luis Chamberlain <mcgrof@kernel.org>, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
	boundary="----.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_b2509_"

------.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_b2509_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Feb 23, 2022 at 10:29:18AM +0900, Damien Le Moal wrote:
> On 2/23/22 09:55, Luis Chamberlain wrote:
> > On Thu, Feb 17, 2022 at 06:29:01PM +0530, Nitesh Shetty wrote:
> >>  Thu, Feb 17, 2022 at 01:07:00AM -0800, Luis Chamberlain wrote:
> >>> The subject says limits for copy-offload...
> >>>
> >>> On Mon, Feb 14, 2022 at 01:29:52PM +0530, Nitesh Shetty wrote:
> >>>> Add device limits as sysfs entries,
> >>>>         - copy_offload (RW)
> >>>>         - copy_max_bytes (RW)
> >>>>         - copy_max_hw_bytes (RO)
> >>>>         - copy_max_range_bytes (RW)
> >>>>         - copy_max_range_hw_bytes (RO)
> >>>>         - copy_max_nr_ranges (RW)
> >>>>         - copy_max_nr_ranges_hw (RO)
> >>>
> >>> Some of these seem like generic... and also I see a few more max_hw ones
> >>> not listed above...
> >>>
> >> queue_limits and sysfs entries are differently named.
> >> All sysfs entries start with copy_* prefix. Also it makes easy to lookup
> >> all copy sysfs.
> >> For queue limits naming, I tried to following existing queue limit
> >> convention (like discard).
> > 
> > My point was that your subject seems to indicate the changes are just
> > for copy-offload, but you seem to be adding generic queue limits as
> > well. Is that correct? If so then perhaps the subject should be changed
> > or the patch split up.
> > 
> >>>> +static ssize_t queue_copy_offload_store(struct request_queue *q,
> >>>> +				       const char *page, size_t count)
> >>>> +{
> >>>> +	unsigned long copy_offload;
> >>>> +	ssize_t ret = queue_var_store(&copy_offload, page, count);
> >>>> +
> >>>> +	if (ret < 0)
> >>>> +		return ret;
> >>>> +
> >>>> +	if (copy_offload && !q->limits.max_hw_copy_sectors)
> >>>> +		return -EINVAL;
> >>>
> >>>
> >>> If the kernel schedules, copy_offload may still be true and
> >>> max_hw_copy_sectors may be set to 0. Is that an issue?
> >>>
> >>
> >> This check ensures that, we dont enable offload if device doesnt support
> >> offload. I feel it shouldn't be an issue.
> > 
> > My point was this:
> > 
> > CPU1                                       CPU2
> > Time
> > 1) if (copy_offload 
> > 2)    ---> preemption so it schedules      
> > 3)    ---> some other high priority task  Sets q->limits.max_hw_copy_sectors to 0
> > 4) && !q->limits.max_hw_copy_sectors)
> > 
> > Can something bad happen if we allow for this?
> 
> max_hw_copy_sectors describes the device capability to offload copy. So
> this is read-only and "max_hw_copy_sectors != 0" means that the device
> supports copy offload (this attribute should really be named
> max_hw_copy_offload_sectors).
>
Yes, it does make sense to change prefix to copy_offload_*, but downside
being sysfs attributes becomes too long.

> The actual loop to issue copy offload BIOs, however, must use the soft
> version of the attribute: max_copy_sectors, which defaults to
> max_hw_copy_sectors if copy offload is truned on and I guess to
> max_sectors for the emulation case.
> 
> Now, with this in mind, I do not see how allowing max_copy_sectors to be
> 0 makes sense. I fail to see why that should be allowed since:
> 1) If copy_offload is true, we will rely on the device and chunk copy
> offload BIOs up to max_copy_sectors
> 2) If copy_offload is false (or device does not support it), emulation
> will be used by issuing read/write BIOs of up to max_copy_sectors.
> 
> Thus max_copy_sectors must always be at least equal to the device
> minimum IO size, that is, the logical block size.

Agreed, if device doesn't suppport offload, soft limit should be based on
limits of READ/WRITE IOs.

--
Nitesh Shetty

------.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_b2509_
Content-Type: text/plain; charset="utf-8"


------.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_b2509_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
------.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_b2509_--

