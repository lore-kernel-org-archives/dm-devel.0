From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: panic in dm_pg_init_complete+0x10
Date: Thu, 10 Mar 2005 16:29:13 +0000
Message-ID: <20050310162913.GS19392@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A804@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A804@SRMANNING.eng.emc.com>
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

On Tue, Mar 08, 2005 at 04:23:59PM -0500, goggin, edward wrote:
> Looks to me like two issues here -- (1) probably should not allow
> concurrent pg_init i/os for the same multipath and 

Some statements that the code should be checked against.

Only one pg_init can happen at once.
  - enforced by pg_init_required only getting set to 1 in one place,
    then set to 0 when the init is issued.
  - BUG? it looks possible for __switch_pg to get called 
    while there's still a pg_init outstanding.

Suspend cannot complete until there is no I/O outstanding, including
any pg_init I/O.
  - queueing is disabled while suspended
  - the last I/O through cannot complete with an error until the last 
    path has failed, which can't happen until the pg_init for its PG
    has completed.

multipath_dtr can only be called when there is no I/O in-flight
  - dm_swap_table checks the device is suspended before calling __unbind
  - BUG? dm_put only calls pre/post suspend but fails to wait for I/O to clear

Alasdair
-- 
agk@redhat.com
