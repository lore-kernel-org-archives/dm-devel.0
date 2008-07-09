From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Resetting dmsetup open count
Date: Wed, 9 Jul 2008 10:01:32 -0400
Message-ID: <20080709140132.GA30521@mars.virtualiron.com>
References: <486BA12D.5010506@cs.tcd.ie>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <486BA12D.5010506@cs.tcd.ie>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lavinp@cs.tcd.ie, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 02, 2008 at 04:39:25PM +0100, Peter Lavin wrote:
> Dear dmsetup mailers,
>
> I am attempting to remove a LVM in CentOS 5. I am getting the following 
> message...
>
> Can't remove open logical volume "lvm_name"
>
> I can delete the link... /dev/vg01/lvm_name and also delete the associated 
> block... /dev/mapper/vg01-lvm_name.
>
> However, when I attempt to recreate the LVM using the same name (I need to 
> use the same name). I get a message that the LVM already exists. I have 
> traced this to dmsetup, where running dmsetup info vg01-lvm_name reveals...
>
> [root@tg26 mapper]# dmsetup info vg01-lvm_name
> Name: vg01-lvm_name
> State: ACTIVE
> Tables present: LIVE
> Open count: 1  <------- this appears to be the problem
> Event number: 0
> Major, minor: 253, 63
> Number of targets: 1
> UUID: LVM-CT2Hz7dN6TLC3c8DydQ8nIenwjSmA8CI1yrsTLQy7Ip1Cxetz3 JrdQArvsgBqDsj
>
> I may be able to reset this Open count by rebooting the machine but this is 
> the least preferred option. Is there a was of resetting this 'Open count' 
> in the dmsetup records without rebooting the system. My dmsetup version is 
> pre- 4.8.0 so I cannot use the lvmremove -f option.

Did you use 'vgchange --available ln vg01-lvm_name' before trying to
remove it using 'dmsetup' ?
