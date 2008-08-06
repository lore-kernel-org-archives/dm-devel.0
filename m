From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: [RFC PATCH 0/4] dm core: full barrier support
Date: Wed, 6 Aug 2008 12:05:22 +0200
Message-ID: <20080806100522.GA3142@develbox.linuxbox.cz>
References: <48739A75.1070807@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48739A75.1070807@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: nikola.ciprich@linuxbox.cz, Alasdair G Kergon <agk@redhat.com>, mbroz@redhat.com
List-Id: dm-devel.ids

Hi Milan,
I'd like to ask, what's the current state of barrier support in DM?
Did You get any feedback? Are there any plans for pushing it to
mainline?
thanks a lot in advance
BR
nik

On Tue, Jul 08, 2008 at 06:48:53PM +0200, Milan Broz wrote:
> Hi,
> 
> there was several discussions about supporting barriers
> in device-mapper.
> 
> I wrote this code some time ago, but it never reached dm-devel
> tree. Take this more like RFC and experimental approach
> - maybe there is better way how to handle it. 
> Anyway this implementation works in my tests and is relatively simple.
> 
> [RFC PATCH 1/4] dm core: remove unused code
> 	- just remove never used code, already sent some time ago
> 	in another patchset
> 
> [RFC PATCH 2/4] dm core: add support for empty barriers
> 	- the core implementation of empty barrier support
> 	- implementation for stripe target
> 
> [RFC PATCH 3/4] dm core: add support for barrier bio with payload
> 	- tranform payload to sequence of data bio + empty barrier
> 
> [RFC PATCH 4/4] dm core: wait for barrier in process in suspend
> 	- try to solve the problem that we cannot suspend device
> 	during processing of barrier.
> 
> 
> Notes to implementation:
> 
> * Patches are generated with previously applied bvec_merge
> patches from dm-devel tree (but it should work even without them)
> (removing unnecessary bio split was part of solution)
> 
> * ignoring multipath for now, but it should probably process
> barriers correctly in multipath target
> 
> * barrier is expensive operation, so it should be used
> very rarely, processing (and cost) in DM is equivalent
> to suspending device
> 
> * There are several types of barrier implementation
> in hw drivers (DRAIN,TAGGING, ...) but DM doesn't care about
> it - I think that sending zero-sized barrier to low-lever driver
> is enough to allow its internal logic to decide what to do.
> 
> * DM target is responsible for processing barrier for its devices.
>   (barrier is sent per target not per device).
> 
>   - Only targets know which devices are related to barrier request,
>   and dm-core have no functionality to decide which devices are used
>   in specific targets (!)
> 
>   - Most of targets will probably need no special code to handle
>   zero-sized barrier
> 
>   - implementation is simpler, we can e.g. disable barriers
>   for some type of target (and implement it later)
> 
>   - it must process correctly mapping table reloads
> 
> * DM always send zero-sized barriers, barriers with payload
>   are converted to non-barrier bios with payload
>   + subsequent zero-size barrier
> 
> * All preceding IOs must be processed when barrier is issued
>   - All barriers is processed with down_write(io_lock) locked.
>   Because bios are internally queued per process (in *make_request)
>   this is sufficient to ensuring that all previous IOs are
>   submitted by DM (dm_request runs with down_read, so barrier
>   request will wait till all "readers" are done).
> 
>   - Moreover, after submitting zero barrier, code waits till
>   all processing IOs (per md) are finished before releasing flag.
>   It waits even for reads and barrier itself now.
> 
> * After processing all requests (including all barrier clones)
>   the queued IOs are flushed.
>   - If there is another barrier in queue, operation continues
>   without clearing BLOCK_IO flag (this flag is cleared only
>   when whole queue if flushed and no new barrier is on-the-fly).
> 
> * Some targets do not need changes (linear), others need review
> but should work in general (mirror, crypt, ...)
> 
> Milan
> --
> mbroz@redhat.com
> 
> 
> 
> 
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
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
