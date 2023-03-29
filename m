Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC75AC74A5B
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680158043;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=4AMxHjmkvcycOOnsb1TWVsgrCuy7XqvJgA3FGOqmrqc=;
	b=NaXSXKvAajFG2ynmV9XYLWuF8hYyGaAfsR1cE2QgmHa91cbiSG03aDZK+bz0NBGEn04s3+
	d/lgmFis8nqUVgEjkoXFJOU+GBxBSHk2myoU5uJp9kF9PznrvFkOe1Ur3x/rrIlTqe1LNv
	/RXvyGk0bvYIOKil3j7vFIRr+e3KgIY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-2eaByKXZMOiSeyZNONFJzw-1; Thu, 30 Mar 2023 02:33:07 -0400
X-MC-Unique: 2eaByKXZMOiSeyZNONFJzw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EBDA3822DF7;
	Thu, 30 Mar 2023 06:33:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AD601121330;
	Thu, 30 Mar 2023 06:33:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F8B119452D8;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4EDBA1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 15:32:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3EFF5440DD; Wed, 29 Mar 2023 15:32:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35CC218EC6
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:32:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4667F18E527E
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:32:06 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-9vmMJ1seMSmoIL9QhXGa8w-1; Wed, 29 Mar 2023 11:31:54 -0400
X-MC-Unique: 9vmMJ1seMSmoIL9QhXGa8w-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230329153149epoutp02fb2fd7c1cfd2c1f973754bc761f91acf~Q7Zq5PaHs0052400524epoutp02F
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:31:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230329153149epoutp02fb2fd7c1cfd2c1f973754bc761f91acf~Q7Zq5PaHs0052400524epoutp02F
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230329153149epcas5p437b54757fee362a3440d07c08a7ae3b7~Q7ZqaDJ5R2635826358epcas5p4H;
 Wed, 29 Mar 2023 15:31:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4PmrBW2pdLz4x9Pt; Wed, 29 Mar
 2023 15:31:47 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 E6.DD.10528.3E954246; Thu, 30 Mar 2023 00:31:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230329124320epcas5p10454736bde745b4de754fd513bca7b30~Q5GjozHU20813008130epcas5p1E;
 Wed, 29 Mar 2023 12:43:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230329124320epsmtrp2200bdf3aadaa5cb7c5c9dc4ecf4954ab~Q5GjnsrBH2573425734epsmtrp2U;
 Wed, 29 Mar 2023 12:43:20 +0000 (GMT)
X-AuditID: b6c32a49-e75fa70000012920-d0-642459e3764d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D0.58.18071.86234246; Wed, 29 Mar 2023 21:43:20 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230329124316epsmtip2a58f2078f77962c21ecbb6192f187e71~Q5GgnZnR_1265312653epsmtip2e;
 Wed, 29 Mar 2023 12:43:16 +0000 (GMT)
Date: Wed, 29 Mar 2023 18:12:36 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christian Brauner <brauner@kernel.org>
Message-ID: <20230329124236.GB3895@green5>
MIME-Version: 1.0
In-Reply-To: <20230329-glitter-drainpipe-bdf9d3876ac4@brauner>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTZxjG853Tnh5cuh0B40c7pVSQCXKpK91hA2HTsEMkGY4EM5asNvQI
 ld7Wy3RAMlBgwQSvk8SKsxLDEAQmt3GrSInjFmCTW0A7tlmGg1BuBjTcVjhl8b/f+7zP873f
 JR+Oups4PFyhNtA6tUwpxHaw6tsP+Ac9/8JXHloySZBV3b+i5LnLayhZbruEkdPtC4AsnHuN
 kiu9/Shpcdxkk6OPGhGypfgqQt4rf4yQzXfmEfLxxgxGXrUOA3JiyISQlrFAssXSxSIHmoow
 8nbJBIe0XjuPkA32bEBWTs+yyM4xPtm/1sGO3k0NDB6jTOO9GNVosnGo/j8esKiBXiNVXZaP
 UTV3v6OaR7MwquC8w2nIHWdTsw+HMOpibRmganoyqMXqvVS1fQaJfycpLSKVlslpnYBWJ2vk
 CnVKpPBYgvSINEwSKgoShZMfCAVqmYqOFB6Niw+KUSidVyAUfCNTGp1SvEyvF4YcjtBpjAZa
 kKrRGyKFtFau1Iq1wXqZSm9UpwSracOHotDQQ2FO48m01HVbBUf7u/fZxVtTrCxQ73UBuOGQ
 EMPpATtyAezA3YlmANf7yjGmWADwSUUdyhRLAI5NjbK2IwV1eYBpWABsHxlhMYUdwMqlfvam
 i0X4wYmOV844jmNEIOzZwDdlTyIAniue35qHEmY2vJE7iWw2PAgZbLlZBjaZ6zStTXayGN4J
 u27Yt9iNOAxvvRjibPIuYh98VN+xtRAkqtzgz3n1HGZ7R2FbaxHGsAec6qh16Ty46LC49DPw
 3g+lGBPOAdA0YgJMIwrmdl9CNxklFPBZ/oYrsAde765EGP1tWLBiRxidCxt+3OZ98H6V2eX3
 gsPL2S6mYH+T2XWr8wDeKcpDLgNv0xunM70xj+GD0Ny84GTcyXz40zrO4AFY1RRiBuwy4EVr
 9aoUWh+mFanpM/+/ebJGVQ22PklAbAOw/TkXbAUIDqwA4qjQk7syLJS7c+Wyb9NpnUaqMypp
 vRWEOV/rCsrblaxx/jK1QSoSh4eKJRKJOPx9iUi4m+sf2ZXsTqTIDHQaTWtp3XYOwd14WYhP
 XE7S8bLAj5fzTT4tmePecRECztDXrf57BCWRqrwHF/2CQPpHE4nRrHILnzvelNCVo08/cuK5
 zTCofZoeE1sxXp2InKr1ezfkVN+0Fp0r+GyyRb6Y0VwYk+lfeppfTredtbu/EvT4SCuxyr5r
 tz3jX6ocQbJVji9fMnM8yVD4z/6VxNmZzIN5nZ8MmmrqUw5F+eGtyxlDf/v+1RZf1WJ99q+i
 7ulq/JLDh90kiS4uNb7cW5b9RK90eHyqMssffh7l/VXiTmnA9USt6dJ92xyP79/N9kzAzd83
 wuLRL3+br3k9yFt578VJyVyWWLyasN8t9hfpibdOF91dLVnw98AUQpY+VSYKQHV62X/1GOH8
 rQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Re0hTYRiH+845OzuuRseV7SvLahWYkjrL+LpHN490JcJqXXS2g2abypbZ
 hWi5LLS8pBA4k3KItQladtvSWUxzmukKm5VQgmhmm25W0EVmuY2o/358z/N73xc+Chf0ELOo
 o2nHWWWaVC4iecTDJtHcJSnRC2VRBSMEqn3egqPsIg+Oqt8XksjR9AWga+6fOBrrsOHIPFLG
 Qe+emjDUoCvGkL76GYbqK0Yx9Oz3MImKLd0ADdi1GDL3hKMGcxuBuh5fJ9GNqgEuspRoMGTs
 Pw9QjcNFoNaeYGTzWDnrhUzX662MtreDZEza91zG9uEuwXR1ZDJ1hlySuVd5jql/pyaZfM3I
 hJDTy2FcjXaSKbhvAMy99jPM17oQpq5/GNs1VcJbLWPlR0+wysi1ibyUGmsfkVEw56S5twFT
 gyvCPBBAQXoZzH9wEeQBHiWg6wE0OdoJP5gJqzzNuD9Pg/rxQa5f6gOw0/TBBwh6ERyw/pjI
 FEXS4bD9N+V9nk6HwWzdKOb1cVrHgervRVwvmEZLYUOZAXgzf0LyDLYS/qGjAJZV5uB+EAjb
 Svt9V+AT0tvxIcy7AKeD4a1x34IAei0s/2T3zQyiF8CnD61YEQjU/tfW/tfW/mvfBLgBzGQz
 VIpkhUqcIU5jsyJUUoUqMy054ki6og74vj9ssRE8MrgjLACjgAVAChdN5491i2QCvkx66jSr
 TE9QZspZlQUEU4RIyH+Z15YgoJOlx9ljLJvBKv9SjAqYpcZOeeIyw2HzjgMzeGGTpkpsFyI/
 1airS+QbUby4LcjddJtOYKNNWvdVW+IC6fqLP2zOocrFHcXqXOOj9E3CEuHopU2S2Hxe1Mop
 FTk6zTdnpFPu7MuxXioPjVq+4nKUImb73kT78OvJs1sC95V9rzQ5s2Rxuj2SQ7UpSbuNEpi9
 Des8sI6OjovRWyvGu0I3l3LKm2nxYPeL9qRVGit9NqRYQRmZ/KQQR+r+nV9p7hTqYOodQUHs
 JHt8/fzqz8KPJ1zRM+w/K95sYzqVrkK9dn+rw2GPeeJK5b5a9mukT1PaEnt6du7nyfeHNpht
 S9cEKTby5z3POrxi5dgWQDU2ighVilQchitV0j8NAO+/bQMAAA==
X-CMS-MailID: 20230329124320epcas5p10454736bde745b4de754fd513bca7b30
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4@epcas5p1.samsung.com>
 <20230327084103.21601-5-anuj20.g@samsung.com>
 <20230329-glitter-drainpipe-bdf9d3876ac4@brauner>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: Re: [dm-devel] [PATCH v8 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device.
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 damien.lemoal@opensource.wdc.com, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11875f_"

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11875f_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Mar 29, 2023 at 02:14:40PM +0200, Christian Brauner wrote:
> On Mon, Mar 27, 2023 at 02:10:52PM +0530, Anuj Gupta wrote:
> > From: Nitesh Shetty <nj.shetty@samsung.com>
> > 
> > For direct block device opened with O_DIRECT, use copy_file_range to
> > issue device copy offload, and fallback to generic_copy_file_range incase
> > device copy offload capability is absent.
> > Modify checks to allow bdevs to use copy_file_range.
> > 
> > Suggested-by: Ming Lei <ming.lei@redhat.com>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > ---
> >  block/blk-lib.c        | 22 ++++++++++++++++++++++
> >  block/fops.c           | 20 ++++++++++++++++++++
> >  fs/read_write.c        | 11 +++++++++--
> >  include/linux/blkdev.h |  3 +++
> >  4 files changed, 54 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index a21819e59b29..c288573c7e77 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -475,6 +475,28 @@ static inline bool blk_check_copy_offload(struct request_queue *q_in,
> >  	return blk_queue_copy(q_in) && blk_queue_copy(q_out);
> >  }
> >  
> > +int blkdev_copy_offload(struct block_device *bdev_in, loff_t pos_in,
> > +		      struct block_device *bdev_out, loff_t pos_out, size_t len,
> > +		      cio_iodone_t end_io, void *private, gfp_t gfp_mask)
> > +{
> > +	struct request_queue *in_q = bdev_get_queue(bdev_in);
> > +	struct request_queue *out_q = bdev_get_queue(bdev_out);
> > +	int ret = -EINVAL;
> 
> Why initialize to -EINVAL if blk_copy_sanity_check() initializes it
> right away anyway?
> 

acked.

> > +	bool offload = false;
> 
> Same thing with initializing offload.
> 
acked

> > +
> > +	ret = blk_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len);
> > +	if (ret)
> > +		return ret;
> > +
> > +	offload = blk_check_copy_offload(in_q, out_q);
> > +	if (offload)
> > +		ret = __blk_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
> > +				len, end_io, private, gfp_mask);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(blkdev_copy_offload);
> > +
> >  /*
> >   * @bdev_in:	source block device
> >   * @pos_in:	source offset
> > diff --git a/block/fops.c b/block/fops.c
> > index d2e6be4e3d1c..3b7c05831d5c 100644
> > --- a/block/fops.c
> > +++ b/block/fops.c
> > @@ -611,6 +611,25 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >  	return ret;
> >  }
> >  
> > +static ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				size_t len, unsigned int flags)
> > +{
> > +	struct block_device *in_bdev = I_BDEV(bdev_file_inode(file_in));
> > +	struct block_device *out_bdev = I_BDEV(bdev_file_inode(file_out));
> > +	int comp_len = 0;
> > +
> > +	if ((file_in->f_iocb_flags & IOCB_DIRECT) &&
> > +		(file_out->f_iocb_flags & IOCB_DIRECT))
> > +		comp_len = blkdev_copy_offload(in_bdev, pos_in, out_bdev,
> > +				 pos_out, len, NULL, NULL, GFP_KERNEL);
> > +	if (comp_len != len)
> > +		comp_len = generic_copy_file_range(file_in, pos_in + comp_len,
> > +			file_out, pos_out + comp_len, len - comp_len, flags);
> 
> I'm not deeply familiar with this code but this looks odd. It at least
> seems possible that comp_len could be -EINVAL and len 20 at which point
> you'd be doing len - comp_len aka 20 - 22 = -2 in generic_copy_file_range().

comp_len should be 0 incase of error. We do agree, some function
description needs to be updated. We will recheck this completion path to
make sure not to return negative value, incase of failure.

Thank You,
Nitesh Shetty

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11875f_
Content-Type: text/plain; charset="utf-8"


------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11875f_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_11875f_--

