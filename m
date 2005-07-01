From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath state discrepancies between user and
	kernel space
Date: Sat, 02 Jul 2005 00:07:40 +0200
Message-ID: <1120255660.8721.27.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AB3B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB3B@SRMANNING.eng.emc.com>
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

On ven, 2005-07-01 at 17:30 -0400, goggin, edward wrote:
> 
> (1) In the event that automatic path group failback is not configured, which
> value for the highest
> priority path group should be displayed by "multipath -l" -- the one used by
> the multipath target
> driver in the kernel or the path group which is actually the highest
> priority path group at that
> moment in time?  Or both -- or still do (see issue (2) below) for path
> state?
> 
> The notion of highest priority path group in the kernel may be different
> from the actual highest
> priority path group in a case whereby:
> 
> (a)	auto failback is not enabled
> (b) 	all paths to the highest priority path group are failed
> (c) 	multipath is run manually -- causing path group switching to another
> path group
> (d) 	one or more of the paths that were had failed are now made active
> again -- yet
> 	because auto failback is not enabled, this path group is not made
> the highest
> 	priority path group in the kernel, although by definition it is the
> highest priority
> 	path group
> 
Would printing the "PG-summed path priorities" value for each PG meet
your needs/taste ?

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
