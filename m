From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: linux-next oops
Date: Tue, 9 Oct 2012 19:57:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210091955260.28143@file.rdu.redhat.com>
References: <20121009153003.92EA7801A1@viridian.itc.virginia.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121009153003.92EA7801A1@viridian.itc.virginia.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I pulled linux-next, set up multipath and executed fsync() on it, and 
there was no crash for me.

Mikulas


On Tue, 9 Oct 2012, Bill Pemberton wrote:

> I'm seeing an oops with the patch
> http://people.redhat.com/agk/patches/linux/editing/dm-store-dm_target_io-in-bio-front_pad.patch
> in linux-next (commit 24d047b).
> 
> I'll attach the dmesg output from a crash.  I bisected it down to this
> one patch and verified that reverting it results in a kernel that
> boots normally.  It appears that this will crash any linux-next kernel
> since 20120918 -- I've not tried them all, but I have tried a few.
> 
> The machines where this happens are Dell PowerEdge SC1425
> 
> -- 
> Bill
> 
> 
> 
