From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: more multipath deadlocks -- this time involving
	memory
Date: Tue, 22 Mar 2005 20:38:57 +0000
Message-ID: <20050322203857.GM19749@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A856@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A856@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 21, 2005 at 09:34:20PM -0500, goggin, edward wrote:
> I see three separate instances of the problem being plausible, 

We went through similar issues with lvm2's pvmove (on 2.4) and eventually 
fixed it such that we could no longer lock up the machine while testing 
under low memory.  That's not to say we covered every possible problem
though.

> The first problem scenario involves a deadlock between multipathd and
> syslogd.  

By default, pvmove turns off logging during the critical sections of code.
[There's an option to turn it back on if you need it. I also did some
work on code to log to pre-allocated filespace with O_DIRECT.]

> The second scenario involves the potential for multipathd,
> multipath,
> or any of the executables invoked by multipath to be deadlocked trying doing
> synchronous page reclamation while allocating memory pages for user or
> kernel heap memory in a system with a high degree of memory contention

pvmove avoids allocating memory (incl. extending stack) in critical
sections.  (It pre-allocates sufficient locked memory in advance.)

Alasdair
-- 
agk@redhat.com
