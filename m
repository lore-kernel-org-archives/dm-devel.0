From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Setting up a multipath device
Date: Thu, 4 May 2006 16:49:15 +0200
Message-ID: <20060504144915.GA2319@pundit>
References: <445A0AE9.20907@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <445A0AE9.20907@voltaire.com>
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

On Thu, May 04, 2006 at 05:08:41PM +0300, Erez Zilber wrote:
> Hi,
> 
> I'm new to device mapper and trying to set a multipath target:
> 
> I'm connected to the same LUN over iSCSI in 2 paths:
> 
> Here's the output of sg_map:
> sg_map -i -x
> /dev/sg0 3 0 0 0 0 /dev/sda DotHill SANnet II FC 411I
> /dev/sg1 4 0 0 0 0 /dev/sdb DotHill SANnet II FC 411I
> 
> I ran the following command:
> multipath 2 round-robin 1 0 /dev/sda round-robin 1 0 /dev/sdb
> 
Just start multipathd
or run multipath without params

> If I understand correctly, the 1st priority group contains /dev/sda. The 
> 2nd priority group contains /dev/sdb. If /dev/sda fails, traffic should 
> automatically move to /dev/sdb. Is that right?
> 
> Here's the out put of multipath -l:
> 
> 3600c0ff00000000007c1d121c397f503
> [size=10 GB][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][active]
> \_ 3:0:0:0 sda 8:0 [active][undef]
> \_ round-robin 0 [prio=0][enabled]
> \_ 4:0:0:0 sdb 8:16 [active][undef]
> 
> What does 8:0 & 8:16 mean? What is 3600c0ff00000000007c1d121c397f503?
>
8:0 & 8:16 are paths major:minor numbers
3600c0ff00000000007c1d121c397f503 is the multipath name.
consider activating the fancy naming option in the config file.
 
> Now, assuming that what I did so far is ok, how do I use the multipath 
> device? Do I use /dev/sda (or /dev/sdb)?
>
You should use /dev/mapper/3600c0ff00000000007c1d121c397f503
 
Regards,
cvaroqui
