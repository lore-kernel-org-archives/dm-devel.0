From: Milan Broz <mbroz@redhat.com>
Subject: Re: trim support (discard)
Date: Sun, 09 Jan 2011 14:28:16 +0100
Message-ID: <4D29B7F0.4050001@redhat.com>
References: <1294515916.5136.6.camel@jaschtschik-pc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1294515916.5136.6.camel@jaschtschik-pc>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Kasten <jens@kasten-edv.de>
List-Id: dm-devel.ids

On 01/08/2011 08:45 PM, Jens Kasten wrote:
> 
> I use the kernel 2.6.37 with cryptsetup and lvm on a intel ssd. 

Device-mapper targets supports discards in 2.6.37 with exception
of dm-crypt target (that's why you see that message).

Supporting discards in dm-crypt means that information
about unused blocks is leaked (SSD ususally returns zeroes instead
of expected random data for discarded blocks) and it it can be
security problem in some situations.

We will probably add discard support in dm-crypt later but as optional
parameter (admin must decide that leaking allocated block info
is not problem and must explicitly enable it).
Probably 2.6.39 material.

> Then i try the wiper.sh script and i get:
> wiper.sh: Linux SATA SSD TRIM utility, version 3.1, by Mark Lord.
> /dev/dm-1: unable to reliably determine the underlying physical device
> name, aborting

That seems like bug in that script btw, it should understand DM devices.

> Its there in near future the discard support on the LVM?

LVM/DM itself should fully support discards now.
Exception is stacking with dm-crypt devices.

Milan
