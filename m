From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Wed, 30 May 2007 12:55:14 -0400
Message-ID: <465DAC72.1010201@cfl.rr.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528094358.GM25091@agk.fab.redhat.com>
	<5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
	<20070529220500.GA6513@agk.fab.redhat.com>
	<5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, Stefan Bader <sbader3@googlemail.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Stefan Bader wrote:
> You got a linear target that consists of two disks. One drive (a)
> supports barriers and the other one (b) doesn't. Device-mapper just
> maps the requests to the appropriate disk. Now the following sequence
> happens:
> 
> 1. block x gets mapped to drive b
> 2. block y (with barrier) gets mapped to drive a
> 
> Since drive a supports barrier request we don't get -EOPNOTSUPP but
> the request with block y might get written before block x since the
> disk are independent. I guess the chances of this are quite low since
> at some point a barrier request will also hit drive b but for the time
> being it might be better to indicate -EOPNOTSUPP right from
> device-mapper.

The device mapper needs to ensure that ALL underlying devices get a 
barrier request when one comes down from above, even if it has to 
construct zero length barriers to send to most of them.
