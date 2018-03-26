From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools licenses (was Re: [PATCH]
 multipath-tools: replace FSF address with a www pointer)
Date: Mon, 26 Mar 2018 13:04:47 +0200
Message-ID: <20180326130447.3114ef2f@pentland.suse.de>
References: <20180310205002.3318-1-xose.vazquez@gmail.com>
	<1521495458.3798.138.camel@suse.com>
	<1a0b44c5-c7a6-85fa-b2dd-1bd542efbb76@gmail.com>
	<1521837017.13100.106.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521837017.13100.106.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, fge@redhat.com
List-Id: dm-devel.ids

On Fri, 23 Mar 2018 21:30:17 +0100
Martin Wilck <mwilck@suse.com> wrote:

> On Fr, 2018-03-23 at 19:28 +0100, Xose Vazquez Perez wrote:
> > 
> > https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob_plai
> > n;f=COPYING;hb=HEAD
> > 
> >                   GNU *LIBRARY* GENERAL PUBLIC LICENSE
> >                         Version 2, June 1991
> > 
> > aka "Lesser", but rules are the same as in GPL.  
> 
> Ups, what an embarrassing oversight on my part. I guess my brain just
> couldn't believe what my eyes were seeing.
> 
> > >   
> > https://www.gnu.org/licenses/ is a _generic_ place. There is info
> > about
> > ALL licences and versions.  
> 
> That's not obvious to me. In particular the LPGL v2.0 isn't even
> mentioned there, only LGPL v2.1, and that's quite at the bottom.
> 
> It'd be _far_ more important to agree on consistent licenses
> throughout the code. You quoted the file COPYING, but if you look at
> the actual source files, the situation is a bit more complicated:
> 
> LGPLv2.1:
> libmultipath/mpath_cmd.h
> 
> GPLv2:
> libmultipath/sysfs.c
> libmultipath/uevent.c
> libmultipath/prioritizers/ontap.c
> 
> GPLv2 or later:
> 25 files under libmultipath and kpartx directories.
> 
> GPLv3 or later:
> libdmmp
> 
> BSD license: 
> ./third-party/valgrind/drd.h
> ./third-party/valgrind/valgrind.h
> 
> 137 files don't have an explicit license header and can thus be
> assumed to be covered by the COPYING file (LGPL2.0).
> 
> This is a total mess for potential users of our code. Effectively, the
> GPL parts of libmultipath would cause all of multipath-tools to be
> under GPL rather than LGPLv2.x, because the linking exception of the
> LGPL wouldn't apply to them, forbidding linking non-GPL code with
> libmultipath. The GPLv2 "or later" gives you the choice, so
> libmultipath is effectively under GPLv2 because of sysfs.c and
> uevent.c. Furthermore, libmultipath and libdmmp have incompatible
> licenses, and "there is no legal way to combine code under GPLv2 with
> code under GPLv3 in a single
> program" (https://www.gnu.org/licenses/rms -why-gplv3.html).
> 
> I believe that various files besides the three above contain code
> which has been copied from kernel sources and would thus be under
> GPLv2 (the alua code, for example).
> 
> Again, IANAL, but this looks like a mess that really ought to be
> cleaned up. As long as we don't do that, there's no point in changing
> the address headers.
> 
> It would make sense to generally agree on a GPL version (2, 2 or
> later, 3, 3 or later), and apply LGPL to (some of) the libraries and
> GPL to the tools.
> 
Well, as I'm the one responsible for adding 'sysfs.c' and 'uevent.c' to
multipath-tools I should allowed to change the license there, right?

If so I'm happy to change them to LPGL to make things easier.

Cheers,

Hannes
