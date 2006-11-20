From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.19-rc6 -- dm: possible recursive locking detected
Date: Mon, 20 Nov 2006 09:49:06 +0100
Message-ID: <20061120084906.GB17447@osiris.boeblingen.de.ibm.com>
References: <20061117153003.GB7131@osiris.boeblingen.de.ibm.com>
	<20061117194303.GB4409@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061117194303.GB4409@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 17, 2006 at 07:43:03PM +0000, Alasdair G Kergon wrote:
> On Fri, Nov 17, 2006 at 04:30:03PM +0100, Heiko Carstens wrote:
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.19-rc6-g1b9bb3c1 #28
> > ---------------------------------------------
> > kpartx/945 is trying to acquire lock:
> >  (&md->io_lock){----}, at: [<00000000001f8faa>] dm_request+0x42/0x24c
> > 
> > but task is already holding lock:
> >  (&md->io_lock){----}, at: [<00000000001f8faa>] dm_request+0x42/0x24c
> 
> Known problem - nobody's written a patch to fix it yet to my knowledge,
> but I don't recall any reports of real world lock-ups related to this - just
> several reports of the debug warning messages:-)
> 
> Simply ignore the message for now - or submit a patch that fixes the
> underlying problem:-)

Ignoring would be good, but this problem renders lockdep useless since it
stops working after it found the first possible bug.

While we are at it:

this one is sitting since ages in -mm and probably waiting for your approval:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.19-rc5/2.6.19-rc5-mm2/broken-out/md-dm-reduce-stack-usage-with-stacked-block-devices.patch
