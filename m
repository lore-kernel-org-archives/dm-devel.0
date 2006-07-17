From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: lockdep warning when nesting dm devices
Date: Mon, 17 Jul 2006 11:16:28 +0200
Message-ID: <1153127808.3062.0.camel@laptopd505.fenrus.org>
References: <m34pxj6rsm.fsf@telia.com>
	 <20060717024519.GA26318@agk.surrey.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750718AbWGQJ0f@vger.kernel.org>
In-Reply-To: <20060717024519.GA26318@agk.surrey.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Milan Broz <mbroz@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Mon, 2006-07-17 at 03:45 +0100, Alasdair G Kergon wrote:
> On Sat, Jul 15, 2006 at 01:17:29PM +0200, Peter Osterlund wrote:
> > # echo "0 10000 linear /dev/loop0 0" | /sbin/dmsetup create test
> > # echo "0 10000 linear /dev/mapper/test 0" | /sbin/dmsetup create test2
>  
> > I get the following warning from the lockdep validator.
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > ---------------------------------------------
> 
> Well at first sight the message is simply pointing out something expected - it
> only say "INFO" after all - viz. recursive use of
> 	down_read(&md->io_lock);

is this indeed the same io_lock? Because if it is it's a serious
deadlock; rwsem's are NOT self-recursive!
