From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: bind new table before destroying old
Date: Wed, 11 Nov 2009 08:20:57 -0500
Message-ID: <20091111132056.GA28612@redhat.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091111011652.GK17055@agk-dp.fab.redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 10 2009 at  8:16pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> Questions:
> 
>   Do all the targets correctly flush or push back everything during a
>   suspend (including workqueues)?
> 
>   Do all the targets correctly sync to disk all internal state that
>   needs to be preserved during a suspend?
> 
> In other words, in the case of an already-suspended target, the target
> 'dtr' functions should only be freeing memory and other resources and
> not causing I/O to any of the table's devices.
> 
> All targets are supposed to be behave this way already, but please
> would you check the targets with which you are familiar anyway?
> 
> Alasdair
> 
> 
> From: Alasdair G Kergon <agk@redhat.com>
> 
> When replacing a mapped device's table during a 'resume', delay the
> destruction of the old table until the new one is successfully in place.
> 
> This will make it easier for a later patch to transfer internal state
> information from the old table to the new one (something we do not currently
> support) while giving us more options for reversion if a later part
> of the operation fails.

I have confirmed that this patch allows handover to work within a single
device.

The error recovery, will it be done unilaterally in the DM core (on
preresume failure)?  Or will each target driver need to call a DM core
callback if it'd like recovery?

Mike
