From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 15:58:15 -0400
Message-ID: <20091002195815.GE4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
	<20091002124921.GA4494@redhat.com>
	<4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	<1254497520.10392.11.camel@marge.simson.net>
	<20091002154020.GC4494@redhat.com>
	<12774.1254502217@turing-police.cc.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <12774.1254502217@turing-police.cc.vt.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Valdis.Kletnieks@vt.edu
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, Corrado Zoccolo <czoccolo@gmail.com>, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Oct 02, 2009 at 12:50:17PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:
> 
> > In that case, Corrado's suggestion of refining it further and disabling idling
> > for seeky process only on non-rotational media (SSD and hardware RAID), makes
> > sense to me.
> 
> Umm... I got petabytes of hardware RAID across the hall that very definitely
> *is* rotating.  Did you mean "SSD and disk systems with big honking caches
> that cover up the rotation"?  Because "RAID" and "big honking caches" are
> not *quite* the same thing, and I can just see that corner case coming out
> to bite somebody on the ass...
>

I guess both. The systems which have big caches and cover up for rotation,
we probably need not idle for seeky process. An in case of big hardware
RAID, having multiple rotating disks, instead of idling and keeping rest
of the disks free, we probably are better off dispatching requests from
next queue (hoping it is going to a different disk altogether).

Thanks
Vivek
