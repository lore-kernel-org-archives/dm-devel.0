From: Nikita Danilov <nikita@clusterfs.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Mon, 28 May 2007 15:17:41 +0400
Message-ID: <18010.47701.751118.336431@gargle.gargle.HOWL>
References: <18006.38689.818186.221707@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Neil Brown writes:
 > 

[...]

 > Thus the general sequence might be:
 > 
 >   a/ issue all "preceding writes".
 >   b/ issue the commit write with BIO_RW_BARRIER
 >   c/ wait for the commit to complete.
 >          If it was successful - done.
 >          If it failed other than with EOPNOTSUPP, abort
 >          else continue
 >   d/ wait for all 'preceding writes' to complete
 >   e/ call blkdev_issue_flush
 >   f/ issue commit write without BIO_RW_BARRIER
 >   g/ wait for commit write to complete
 >        if it failed, abort
 >   h/ call blkdev_issue
 >   DONE
 > 
 > steps b and c can be left out if it is known that the device does not
 > support barriers.  The only way to discover this to try and see if it
 > fails.
 > 
 > I don't think any filesystem follows all these steps.

It seems that steps b/ -- h/ are quite generic, and can be implemented
once in a generic code (with some synchronization mechanism like
wait-queue at d/).

Nikita.

[...]

 > 
 > Thank you for your attention.
 > 
 > NeilBrown
 > 

Nikita.
