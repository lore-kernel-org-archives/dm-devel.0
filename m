From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: racing libdevmapper calls
Date: Thu, 20 Oct 2005 16:46:07 +0200
Message-ID: <20051020144607.GB10840@free.fr>
References: <1129674646.7313.15.camel@zezette>
	<20051020143812.GL30611@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051020143812.GL30611@agk.surrey.redhat.com>
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

On Thu, Oct 20, 2005 at 03:38:12PM +0100, Alasdair G Kergon wrote:
> Neither libdevmapper nor dmsetup does any locking.
> 
> It's easy to make the case for dmsetup to include locking - but
> dmsetup is only meant as a diagnostic tool so it's hardly an 
> important feature to add.
> 
> DM_DEVICE_CREATE with a table supplied is *not* an atomic
> operation.  It only exists to provide backwards-compatibility for
> the original version of the ioctls (when it *was* atomic).  It's 
> perfectly OK still to use it when convenient, but you have to 
> remember it's actually performing *two* ioctls:
> 
>   DM_DEV_CREATE
>   DM_TABLE_LOAD
> 
> If you need finer-level control, you may be better off calling
> those two separately i.e. DM_DEVICE_CREATE without a table 
> (if the device doesn't already exist) then DM_DEVICE_RELOAD.
> 
Thanks, this information is very valuable and to the point.

Regards,
cvaroqui
