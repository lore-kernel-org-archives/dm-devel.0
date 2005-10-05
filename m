From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] [RFC] persistent readable names
Date: Wed, 5 Oct 2005 17:09:23 +0200
Message-ID: <20051005150923.GC6195@free.fr>
References: <4343DFDC.2020701@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4343DFDC.2020701@redhat.com>
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

On Wed, Oct 05, 2005 at 03:14:52PM +0100, Patrick Caulfield wrote:
> This patch is more for discussion than inclusion at the moment. Basically it's
> unrealistic for users with hundreds of disks to alias them all in
> /etc/multipath.conf and the default names are very unwieldy.
> 
> What this patch does is attach a name to any un-aliased path and write that name
> to /etc/multipath.names. The file is read again every time the paths are added
> so they are persistent.
>
It would please old Tru64 fans :/

> There are a small number of possibly contentious things:
>
For one thing, you didn't care to unbork the daemon :)
It tries a mapname (ie alias) to wwid resolution upon map add events.
Unphased mpe vector will unduly fail the lookup.

Regards,
cvaroqui
