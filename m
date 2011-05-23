From: "--[ UxBoD ]--" <uxbod@splatnix.net>
Subject: Re: multipath produces a segmentation fault
Date: Mon, 23 May 2011 10:41:50 +0100 (BST)
Message-ID: <133d4f30-8fcc-4127-a96c-ed9d94dd3c58@office.splatnix.net>
References: <2ab11d3c-2038-498b-934f-9730ea010c25@office.splatnix.net>
Reply-To: "--\[ UxBoD \]--" <uxbod@splatnix.net>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2ab11d3c-2038-498b-934f-9730ea010c25@office.splatnix.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

----- Original Message -----
> ----- Original Message -----
> > CentOS 5.3 with kernel 2.6.37.6 and
> > device-mapper-multipath-0.4.7-42.el5_6.2.
> > 
> > When I run multipath -v9 -d I get:
> > 
> > sdg: not found in pathvec
> > sdg: mask = 0x1f
> > Segmentation fault
> > 
> > If I strace the command I see:
> > 
> > stat("/sys/block/sdg/device", {st_mode=S_IFDIR|0755, st_size=0,
> > ...})
> > = 0
> > write(1, "sdg: not found in pathvec\n", 26sdg: not found in pathvec
> > ) = 26
> > write(1, "sdg: mask = 0x1f\n", 17sdg: mask = 0x1f
> > )      = 17
> > readlink("/sys/block/sdg/device", "../../../6:0:0:16"..., 256) = 17
> > lstat("/6:0:0:16", 0x7fff04d304c0)      = -1 ENOENT (No such file
> > or
> > directory)
> > --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> > +++ killed by SIGSEGV +++
> > 
> > Any ideas what is wrong please ?
> > --
> > Thanks, Phil
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> 
> Sorry, type the system is CentOS 5.6.

Any thoughts on what the error could be, please ?
-- 
Thanks, Phil
