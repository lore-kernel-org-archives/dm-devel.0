From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Wed, 30 May 2007 11:12:37 +0200
Message-ID: <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
References: <18006.38689.818186.221707@notabene.brown>
	 <18010.12472.209452.148229@notabene.brown>
	 <20070528094358.GM25091@agk.fab.redhat.com>
	 <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
	 <20070529220500.GA6513@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070529220500.GA6513@agk.fab.redhat.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Bader <sbader3@googlemail.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

> > in-flight I/O to go to zero?
>
> Something like that is needed for some dm targets to support barriers.
> (We needn't always wait for *all* in-flight I/O.)
> When faced with -EOPNOTSUP, do all callers fall back to a sync in
> the places a barrier would have been used, or are there any more
> sophisticated strategies attempting to optimise code without barriers?
>
If I didn't misunderstand the idea is that no caller will face an
-EOPNOTSUPP in future. IOW every layer or driver somehow makes sure
the right thing happens.

>
> An efficient I/O barrier implementation would not normally involve
> flushing AFAIK: dm surely wouldn't "cause" a higher layer to assume
> stronger semantics than are provided.
>
Seems there are at least two assumptions about what the semantics
exactly _are_. Based on Documentation/block/barriers.txt I understand
a barrier implies ordering and flushing.
But regardless of that, assume the (admittedly constructed) following case:

You got a linear target that consists of two disks. One drive (a)
supports barriers and the other one (b) doesn't. Device-mapper just
maps the requests to the appropriate disk. Now the following sequence
happens:

1. block x gets mapped to drive b
2. block y (with barrier) gets mapped to drive a

Since drive a supports barrier request we don't get -EOPNOTSUPP but
the request with block y might get written before block x since the
disk are independent. I guess the chances of this are quite low since
at some point a barrier request will also hit drive b but for the time
being it might be better to indicate -EOPNOTSUPP right from
device-mapper.

Stefan
