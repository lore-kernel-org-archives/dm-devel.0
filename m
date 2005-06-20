From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: pg failback
Date: Mon, 20 Jun 2005 20:46:34 +0200
Message-ID: <1119293194.1515.80.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AAD9@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AAD9@SRMANNING.eng.emc.com>
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

On lun, 2005-06-20 at 14:05 -0400, goggin, edward wrote:
> Two things with path group failback seem flawed right now.
> 
> (1) Looks like it might be possible for a currently disabled path group
> which is not the highest priority path group to remain disabled even
> when paths in the group test successfully.  This seems to be possible
> because the code in switch_pathgroup() called by checkerloop() in
> multipathd only fails back to the highest priority path group.  Granted
> that the problem is primarily (__only__) cosmetic since the other group(s)
> are not being actively used anyway, but it is still misleading to a viewer
> of
> "multipath -l" to see disabled path groups which should not be in this
> state.
> 
Yes, this one is on the todo.
You already raised that point speaking of "kernel/userspace asymmetry"
if I remember.

> (2) Seems to me that currently disabled path groups should be enabled
> before switching to one anyway.  Doing so will enable the kernel code to
> simply
> reenable a group without initiating a pg_init of "a possibly newly
> determined"
> highest priority path group as is currently done.  Instead, as a performance
> Improvement over the way things are now, the multipathd code can reenable
> path
> groups as need be, and only initiate a switch path group when it determines
> that this is necessary.
> 
Some hardware (StorageWorks HSG, HSV1X0) need the unconditional pg_init
as it is coded right now, so I guess we can't afford this little
optimisation.

Speaking of optimisation, have you witnessed too the ~20% performance
decrease with multi-path PG ?

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
