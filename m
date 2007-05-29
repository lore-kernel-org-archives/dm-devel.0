From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Tue, 29 May 2007 16:03:43 -0400
Message-ID: <465C871F.708@cfl.rr.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070528024559.GA85884050@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

David Chinner wrote:
> Sounds good to me, but how do we test to see if the underlying
> device supports barriers? Do we just assume that they do and
> only change behaviour if -o nobarrier is specified in the mount
> options?

The idea is that ALL block devices will support barriers; if the 
underlying driver doesn't, then the block layer will work around it.

> The use of barriers in XFS assumes the commit write to be on stable
> storage before it returns.  One of the ordering guarantees that we
> need is that the transaction (commit write) is on disk before the
> metadata block containing the change in the transaction is written
> to disk and the current barrier behaviour gives us that.

Barrier != synchronous write, so if XFS relies on that block being on 
the media when the request is completed, then it is broken.  It should 
only care that the ordering of log-data-log is maintained, not exactly 
when each specific request completes.


