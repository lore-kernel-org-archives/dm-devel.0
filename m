From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: DM-MP cannot be run on either the root or boot device
Date: Mon, 4 Dec 2006 16:00:37 -0600
Message-ID: <20061204220037.GA10678@ether.msp.redhat.com>
References: <EA4ABA1D3EF49C4993A576069C887B2BCCCF23@mail.corp.criadvantage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <EA4ABA1D3EF49C4993A576069C887B2BCCCF23@mail.corp.criadvantage.com>
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

On Thu, Nov 30, 2006 at 03:28:12PM -0700, Wayne Cass wrote:
>    DM-MP cannot be run on either the root or boot device
> 
> 
>    I am booting from a SAN.    Configuration:
> 
>    LUN 1
>            /boot
>            /
>            /var
>            /swap
> 
> 
>    Question:  Can I just blacklist   "/"  and "/boot" ?
> 
>    How do you do it?   I am using a HP  xp-1024   SAN.

There is no easy way to blacklist devices by their e2label filesystem label,
if that's what you mean. You can blacklist the devices that "/" and "/boot" are
on by adding something the following to your /etc/multipath.conf

blacklist {
	...
	wwid <wwid_for_"/">
	wwid <wwid_for_"/boot">
}

You can get the WWIDs for the device by running

# /sbin/scsi_id -g -u -s /block/<devname>

e.g.

[root@cypher-01 ~]# /sbin/scsi_id -g -u -s /block/sda
3600d02300069c9ce09d41c72a4235e00

3600d02300069c9ce09d41c72a4235e00 is the WWID.


Also, multipath can only operate on entire devices. There is no way to blacklist
just a partition of a device.

> 
> 
>    thanks
> 
> 

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
