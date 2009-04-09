From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Date: Wed, 08 Apr 2009 21:27:20 -0400
Message-ID: <1239240440.11220.3.camel@think.oraclecorp.com>
References: <20090324143034.GW27476@kernel.dk>
	 <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	 <20090324150517.GX27476@kernel.dk>
	 <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	 <20090325152751.GV27476@kernel.dk>
	 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	 <20090326084205.GG27476@kernel.dk>
	 <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	 <20090331104933.GJ5178@kernel.dk>
	 <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	 <20090403081131.GP5178@kernel.dk>
	 <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754981AbZDIB2U@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ak@linux.intel.com
List-Id: dm-devel.ids

On Wed, 2009-04-08 at 09:37 -0400, Mikulas Patocka wrote:

> So there are two ways:
> 
> - either support only what all in-kernel filesystems do. Using barrier 
> reqiests to flush hw cache. You can remove support for barriers with data, 
> leave just zero-data barrier, you can remove ordering restrictions. 
> In-kernel filesystems never overlap barrier with another metadata request 
> (see above why such overlap can't work), so you can freely reorder 
> zero-data barriers and simplify the code ... because all the requests that 
> could be submitted in paralel with the barrier are either for different 
> partition or non-metadata requests to the same partition from prefetch, 
> direct io or so.
> 
> - or you can allow barriers to be used for purposes as I did. And then, 
> there must be clean indicator "this device supports barriers 
> *and*will*support*them*in*the*future*". Currently there is no such 
> indicator.

I'm afraid expecting barriers forever in the future isn't completely
compatible with dm or md.  Both of these allow the storage to change
over time, and the filesystem needs to handle this without corruptions.

-chris
