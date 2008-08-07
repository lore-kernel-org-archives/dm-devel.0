From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: [RFC PATCH 0/4] dm core: full barrier support
Date: Thu, 7 Aug 2008 06:38:30 +0200
Message-ID: <20080807043830.GA14595@nik-comp.linuxbox.cz>
References: <48739A75.1070807@redhat.com>
	<20080806100522.GA3142@develbox.linuxbox.cz>
	<48997E09.9040808@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48997E09.9040808@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: nikola.ciprich@linuxbox.cz, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,
and thanks for reply. OK, so I guess it might help if somebody (me:)) starts at least testing and commenting, right?
I'll install it on some of testing machines and report results.
br
nik

> No, there was no feedback.
> 
> Pushing it mainline depends on Alasdair's decision (maintainer of device-mapper).
> (It needs thorough review first and maybe better implementation.)
> 
> Milan
> --
> mbroz@redhat.com
> 
> 
> > thanks a lot in advance
> > BR
> > nik
> > 
> > On Tue, Jul 08, 2008 at 06:48:53PM +0200, Milan Broz wrote:
> >> Hi,
> >>
> >> there was several discussions about supporting barriers
> >> in device-mapper.
> >>
> >> I wrote this code some time ago, but it never reached dm-devel
> >> tree. Take this more like RFC and experimental approach
> >> - maybe there is better way how to handle it. 
> >> Anyway this implementation works in my tests and is relatively simple.
> >>
> >> [RFC PATCH 1/4] dm core: remove unused code
> >> 	- just remove never used code, already sent some time ago
> >> 	in another patchset
> >>
> >> [RFC PATCH 2/4] dm core: add support for empty barriers
> >> 	- the core implementation of empty barrier support
> >> 	- implementation for stripe target
> >>
> >> [RFC PATCH 3/4] dm core: add support for barrier bio with payload
> >> 	- tranform payload to sequence of data bio + empty barrier
> >>
> >> [RFC PATCH 4/4] dm core: wait for barrier in process in suspend
> >> 	- try to solve the problem that we cannot suspend device
> >> 	during processing of barrier.
> 

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
