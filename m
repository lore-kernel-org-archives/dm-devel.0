From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: what's up with pp_balance_units?
Date: Thu, 28 Apr 2005 22:36:20 +0200
Message-ID: <1114720580.10504.7.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A959@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A959@SRMANNING.eng.emc.com>
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

It's not default because its code path is badly inefficient.

I'll accept design criticism, though I think doing it more efficiently
would recquire some hardware assistance, like the pp_alua does.

Regards,
cvaroqui

On jeu, 2005-04-28 at 14:42 -0400, goggin, edward wrote:
> Just wondering why the pp_balance_units path priority callout is not
> the default get_priority callout instead of /bin/false which simply
> assigns a priority value of 1 to every path.  This seems especially
> true for the symmetric (active-active) storage arrays which by their
> very definition don't have their own built-in preferential paths for a
> logical unit.
> 
> Seems like pp_balance_units assigns a higher priority to paths
> connected to SCSI targets which it anticipates will be under-utilized
> when considering the path accessibility of all mapped devices
> accessible on the same storage system from the same host.
> It will also yield the same results as /bin/false will (that is, all paths
> will have the same priority) in the case where all mapped devices
> on a given storage array are accessible from the same set of targets
> on that array.
> 
> Pp_balance_units does appear to have a deficiency in that it does
> not take into account the impact on these storage system targets
> from other hosts (admitably difficult to do) accessing these same
> (cluster case) or different SCSI logical units.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
