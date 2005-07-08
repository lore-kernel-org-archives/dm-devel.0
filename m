From: "goggin, edward" <egoggin@emc.com>
Subject: Re: multipath state between user and kernel space
Date: Thu, 7 Jul 2005 22:11:46 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB49@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, 02 Jul 2005 00:01:09 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> On ven, 2005-07-01 at 17:30 -0400, goggin, edward wrote:
> > 
> > (2) Two path state values, one for user space and one for the kernel
> > resident multipath target driver,
> > will be shown whenever the cached device configuration 
> information is hot.
> > Otherwise, "multipath -l"
> > shows only the kernel driver's path state value since the 
> user space path
> > state value is not displayed
> > if its value is PATH_UNCHECKED which it will be (for 
> "multipath -l") if the
> > saved device configuration
> > cache is not used.
> > 
> > Seems like either one value should always be displayed or 
> two values should
> > always be displayed --
> > I would certainly prefer that only one value be displayed 
> at all times.
> > Seems like a simple change.
> > 
> Like that ?
> 
>  ...

Yes.  Looks good.  Gives a more deterministic look to
"multipath -l" at least.
