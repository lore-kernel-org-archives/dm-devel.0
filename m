From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath [PATCH] multipathd adding devices.
Date: Thu, 2 Mar 2006 17:38:13 +0100
Message-ID: <20060302163813.GF14155@pundit>
References: <C2EEB4E538D3DC48BF57F391F422779321B079@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321B079@SRMANNING.eng.emc.com>
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

On Thu, Mar 02, 2006 at 11:28:04AM -0500, egoggin@emc.com wrote:
> On Thu, Mar 02, 2006 at 12:09:31PM +0100, Christophe Varoqui wrote:
> > > On Fri, Feb 24, 2006 at 08:33:29PM -0600, Benjamin Marzinski wrote:
> > > > The way multipathd currently works, if you add a map that 
> > isn't known to
> > > > device mapper from multipathd, the first time you run the 
> > command, it won't
> > > > add the map to the mpvec vector.  With the attached 
> > patch, multipathd will
> > > > initialize the map and add it to the mpvec vector.
> > > > 
> > > How does the current behaviour affects you ?
> > > Is this about races between DM and netlink events ?
> > > 
> > To be more specific, I think the current code rely on the 
> > netlink "map add" event triggered by coalesce_paths() to feed 
> > the mpvec asynchronously.
> > 
> > ... which seems ok to me, but I may miss a point.
> 
> What is the "current" code, the code in the git repository or
> the latest release point multipath-tools-0.4.6.1?  This certainly
> works fine in the code from the git repository.
> 
I was refering to the git HEAD.

Regards,
cvaroqui
