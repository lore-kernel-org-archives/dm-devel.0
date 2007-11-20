From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: Use LVM on /dev/mapper/diskname and iSCSI
Date: Tue, 20 Nov 2007 09:14:02 -0500 (EST)
Message-ID: <alpine.LRH.0.9999.0711200912560.14385@bogart.boston.redhat.com>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal> <4741D96F.7080502@linpro.no>
	<1195507193.11489.27.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1195507193.11489.27.camel@sanderbal>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "S. J. van Harmelen" <svh@dds.nl>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 19 Nov 2007, S. J. van Harmelen wrote:

> Tore,
> 
> Please take a look at my reply to Malaha. This is also a reply to your
> message...
> 
> Hope you have the time to read it.
> 
> Thanks,
> 
> Sander
> 
> 
> On Mon, 2007-11-19 at 19:43 +0100, Tore Anderson wrote:
> > * S. J. van Harmelen
> > 
> > > Thanks for your help!
> > > 
> > > I executed the pvs command and it did find a few partitions. I use
> > > iSCSI to share the LUN's to a XenSource server, and XenSource creates
> > > the PV's and LV's in order to provision VM's. Didn't think of that,
> > > but that's on the disk of course.


Sander: As a matter of netiquette, please don't top-post.

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426
