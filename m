From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multi-path devices only created in /dev/mapper
Date: Fri, 14 Dec 2007 13:52:02 -0600
Message-ID: <20071214195202.GF25939@ether.msp.redhat.com>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8E9B@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8E9B@exch-2003.incipient.waltham>
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

On Wed, Dec 12, 2007 at 02:37:43PM -0500, Paul Cote wrote:
> 
> 
>    Hi
> 
> 
> 
>    I just recently upgraded a RH server to update 5 and recently noticed that
>    multi-path devices are no longer being created in the /dev/mpath ... but
>    just in /dev/mapper.
> 
>    Has /dev/mpath been deprecated in update 5? ... or is there something else
>    going on?
> 

They should be created in /dev/mpath.  This is done by udev.  Is udev
otherwise working properly.  If you partition the underlying device, do
dm devices get created for the partitions by kpartx?

Also, since the /dev/mapper device nodes exist as soon as the
device is created, and the /dev/mpath symlinks don't get created until
udev gets around to it, you are usually better off simply using the
/dev/mapper names anyways.

-Ben

> 
> 
>    Thanks,
> 
>    Paul

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
