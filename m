From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Mon, 28 May 2007 23:45:59 -0700
Message-ID: <20070529064559.GB531679@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <980E945058C35F7E3117FE88@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <980E945058C35F7E3117FE88@timothy-shimmins-power-mac-g5.local>
Sender: linux-raid-owner@vger.kernel.org
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Mon, May 28, 2007 at 02:48:45PM +1000, Timothy Shimmin wrote:
> I'm taking it that the FUA write will just guarantee that that
> particular write has made it to disk on i/o completion
> (and no write cache flush is done).

Correct.  It only applies to that one write command.

jeremy
