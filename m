From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: another multipath deadlock involving fs-writeback
Date: Thu, 24 Mar 2005 22:26:46 +0000
Message-ID: <20050324222645.GY19749@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A866@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A866@SRMANNING.eng.emc.com>
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
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>, 'Christophe Varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Thu, Mar 24, 2005 at 05:18:23PM -0500, goggin, edward wrote:
> call to bdget_disk() is the problem, this one called from __dev_status()
> called from table_status().
 
It should probably be setting the recent DM_SKIP_BDGET_FLAG 
on every? dm ioctl.

i.e. call dm_task_no_open_count() in libdevmapper prior to dm_task_run().

Alasdair
-- 
agk@redhat.com
