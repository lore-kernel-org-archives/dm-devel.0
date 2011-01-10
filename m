From: Jens Kasten <jens@kasten-edv.de>
Subject: Re: trim support (discard)
Date: Mon, 10 Jan 2011 02:50:19 +0100
Message-ID: <1294624219.24957.46.camel@jaschtschik-pc>
References: <1294515916.5136.6.camel@jaschtschik-pc>
	<4D29B7F0.4050001@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D29B7F0.4050001@redhat.com>
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
List-Id: dm-devel.ids

Am Sonntag, den 09.01.2011, 14:28 +0100 schrieb Milan Broz:
> On 01/08/2011 08:45 PM, Jens Kasten wrote:
> > 
> > I use the kernel 2.6.37 with cryptsetup and lvm on a intel ssd. 
> 
> Device-mapper targets supports discards in 2.6.37 with exception
> of dm-crypt target (that's why you see that message).
> 
> Supporting discards in dm-crypt means that information
> about unused blocks is leaked (SSD ususally returns zeroes instead
> of expected random data for discarded blocks) and it it can be
> security problem in some situations.

Thank you, for this information.
About this i have never thought.
   
> We will probably add discard support in dm-crypt later but as optional
> parameter (admin must decide that leaking allocated block info
> is not problem and must explicitly enable it).
> Probably 2.6.39 material.
> 
> > Then i try the wiper.sh script and i get:
> > wiper.sh: Linux SATA SSD TRIM utility, version 3.1, by Mark Lord.
> > /dev/dm-1: unable to reliably determine the underlying physical device
> > name, aborting

Ok, I take a look on the script.

> That seems like bug in that script btw, it should understand DM devices.
> 
> > Its there in near future the discard support on the LVM?
> 
> LVM/DM itself should fully support discards now.
> Exception is stacking with dm-crypt devices.
> 
> Milan
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
