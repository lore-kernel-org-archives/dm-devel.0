From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath [PATCH] multipathd adding devices.
Date: Thu, 2 Mar 2006 16:41:07 +0100
Message-ID: <20060302154107.GE14155@pundit>
References: <20060225023329.GB18957@ether.msp.redhat.com>
	<20060302110931.GB14155@pundit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060302110931.GB14155@pundit>
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

On Thu, Mar 02, 2006 at 12:09:31PM +0100, Christophe Varoqui wrote:
> On Fri, Feb 24, 2006 at 08:33:29PM -0600, Benjamin Marzinski wrote:
> > The way multipathd currently works, if you add a map that isn't known to
> > device mapper from multipathd, the first time you run the command, it won't
> > add the map to the mpvec vector.  With the attached patch, multipathd will
> > initialize the map and add it to the mpvec vector.
> > 
> How does the current behaviour affects you ?
> Is this about races between DM and netlink events ?
> 
To be more specific, I think the current code rely on the netlink "map add" event triggered by coalesce_paths() to feed the mpvec asynchronously.

... which seems ok to me, but I may miss a point.

Regards,
cvaroqui
