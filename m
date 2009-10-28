From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [dm-devel] [PATCH] block: silently error unsupported empty
 barriers too
Date: Wed, 28 Oct 2009 20:19:01 +0000
Message-ID: <1256761141.5830.79.camel@grinch>
References: <1249557257.3721.55.camel@blaa>
	 <20090806114550.GL29899@agk-dp.fab.redhat.com>
	 <Pine.LNX.4.64.0908062148060.8764@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755541AbZJ1Ugk@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0908062148060.8764@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Mark McLoughlin <markmc@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, ". troy.heber"@hp.com
List-Id: dm-devel.ids

On Thu, 2009-08-06 at 21:50 -0400, Mikulas Patocka wrote:
> On Thu, 6 Aug 2009, Alasdair G Kergon wrote:
> 
> > On Thu, Aug 06, 2009 at 12:14:17PM +0100, Mark McLoughlin wrote:
> > > We should error all barriers, even empty barriers, on devices like
> > > virtio_blk which don't support them.
> >  
> > Have you considered whether or not virtio_blk actually needs to
> > support empty barriers?
> > 
> > Alasdair
> 
> This is only for request-based drivers, where it is the responsibility of 
> blk-core to translate barriers. I think the empty barrier request anyway 
> in blk_do_ordered, but with an error message. So the patch changes it to 
> discard it early and queitly. It seems ok.
> 
> Mikulas
> --

This patch seems to have been dropped.  I can reproduce the error using
the following:

     1. Create an LVM logical volume on top of a cciss device (note that
        the cciss driver does not support barriers)
     2. Create an ext3 file system on top of the logical volume
     3. Mount the file-system using -obarrier=1
     4. Copy some files onto the file-system
     5. Run sync (dm_flush is called)

If I apply the patch (with some munging), the 

"end_request: I/O error, dev cciss/cXdY, sector 0"

messages go away.

This is not strictly a regression, given that the problem was introduced
in 2.6.31, but I think it should still be fixed for 2.6.32.

Andrew

-- 
Andrew Patterson
Hewlett-Packard
