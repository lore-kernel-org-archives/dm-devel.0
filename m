From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: pg failback
Date: Tue, 21 Jun 2005 16:09:48 +0200
Message-ID: <20050621140948.GA10915@averon.dyndns.org>
References: <C2EEB4E538D3DC48BF57F391F422779321AAD9@SRMANNING.eng.emc.com>
	<1119293194.1515.80.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1119293194.1515.80.camel@zezette>
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
List-Id: dm-devel.ids

On Mon, Jun 20, 2005 at 08:46:34PM +0200, christophe varoqui wrote:
> On lun, 2005-06-20 at 14:05 -0400, goggin, edward wrote:
> > Two things with path group failback seem flawed right now.
> > 
> > (1) Looks like it might be possible for a currently disabled path group
> > which is not the highest priority path group to remain disabled even
> > when paths in the group test successfully.  This seems to be possible
> > because the code in switch_pathgroup() called by checkerloop() in
> > multipathd only fails back to the highest priority path group.  Granted
> > that the problem is primarily (__only__) cosmetic since the other group(s)
> > are not being actively used anyway, but it is still misleading to a viewer
> > of
> > "multipath -l" to see disabled path groups which should not be in this
> > state.
> > 
> Yes, this one is on the todo.
> You already raised that point speaking of "kernel/userspace asymmetry"
> if I remember.
> 
Done.

Regards,
cvaroqui
