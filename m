From: Aaron Bergstralh <bergstralh@wisc.edu>
Subject: Re: RE: Resizing multipath maps: reload ioctl failed:
	Invalidargument
Date: Thu, 25 Oct 2007 10:05:14 -0500
Message-ID: <e52e9cf62b8b.47206a5a@wiscmail.wisc.edu>
References: <000101c81648$917e2980$cf42e3c1@pitagora.it>
	<e3d7f74d16a4a.471f2368@wiscmail.wisc.edu>
	<000001c816f8$90a96460$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <000001c816f8$90a96460$cf42e3c1@pitagora.it>
Content-language: en
Content-disposition: inline
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

> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com 
> > [mailto:dm-devel-bounces@redhat.com] On Behalf Of Aaron Bergstralh
> > Sent: Wednesday, October 24, 2007 5:50 PM
> > 
> > I have used the following in the past when I needed to resize 
> > online. I have only tested this for the round robin selector 
> > but a similar method could also work for other selectors.
> > 
> > #Started with the following dm table
> > dmsetup table m500i_A_lun_4
> > 0 157287936 multipath 0 0 1 1 round-robin 0 2 1 8:80 100 8:160 100
> > 
> > ###Used the following in a script to complete the resize 
> > dmsetup suspend m500i_A_lun_4
> > 
> > #Reload with one device removed and old size dmsetup load 
> > m500i_A_lun_4 <<EOF 0 157287936 multipath 0 0 1 1 round-robin 
> > 0 1 1 8:80 100 EOF dmsetup resume m500i_A_lun_4 dmsetup 
> > suspend m500i_A_lun_4
> > 
> > #Reload with one device removed for all other devices dmsetup 
> > load m500i_A_lun_4 <<EOF 0 157287936 multipath 0 0 1 1 
> > round-robin 0 1 1 8:160 100 EOF dmsetup resume m500i_A_lun_4 
> > dmsetup suspend m500i_A_lun_4
> > 
> > #Reload with all devices and new size
> > dmsetup load m500i_A_lun_4 <<EOF
> > 0 209717248 multipath 0 0 1 1 round-robin 0 2 1 8:80 100 
> > 8:160 100 EOF dmsetup resume m500i_A_lun_4
> > 
> > After the last step everything is able to see the new device 
> > size. I know this isn't an ideal solution but it might be 
> > useful for some people.
> 
> I have an EMC Clariion with four paths (two active and two passive):
> 
> # multipath -ll
> 
> 360060160eb2417004412f146416bdc11
> [size=20 GB][features="0"][hwhandler="1 emc"]
> \_ round-robin 0 [prio=2][active]
>  \_ 0:0:2:200 sdb 8:16  [active][ready]
>  \_ 1:0:4:200 sdk 8:160 [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 0:0:3:200 sde 8:64  [active][ready]
>  \_ 1:0:3:200 sdh 8:112 [active][ready]
> 
> # dmsetup table 360060160eb2417004412f146416bdc11
> 0 41943040 multipath 0 1 emc 2 1 round-robin 0 2 1 8:16 100 8:160 100
> round-robin 0 2 1 8:64 100 8:112 100 0 41943040 multipath 0 1 emc 2 1 round-robin 0 2 1 8:16 100 8:160 100
> round-robin 0 2 1 8:64 100 8:112 100 
> 
> What are the exact order of remove/reload in this case?
> I'd like to understand the logic!

The basic logic behind the table manipulation is to remove one device at a time and then add it back in allowing dm to see the new size of device. When all devices have been removed and reinserted the size of the table can finally be updated.  I haven't tried this with your configuration so if I get it wrong someone please correct me. 

Starting Table:
0 41943040 multipath 0 1 emc 2 1 round-robin 0 2 1 8:16 100 8:160 100 round-robin 0 2 1 8:64 100 8:112 100
Remove sdb:
0 41943040 multipath 0 1 emc 2 1 round-robin 0 1 1 8:160 100 round-robin 0 2 1 8:64 100 8:112 100
Remove sdk reinsert sdb:
0 41943040 multipath 0 1 emc 2 1 round-robin 0 1 1 8:16 100 round-robin 0 2 1 8:64 100 8:112 100
Remove sde reinsert sdk:
0 41943040 multipath 0 1 emc 2 1 round-robin 0 2 1 8:16 100 8:160 100 round-robin 0 1 1 8:112 100
Remove sdh reinsert sde:
0 41943040 multipath 0 1 emc 2 1 round-robin 0 2 1 8:16 100 8:160 100 round-robin 0 1 1 8:64 100
Reinsert sdh and set the new table size:
If you don't know your new size you can grab it from one of the devices with blockdev: /sbin/blockdev --getsize /dev/sdb
0 <newsize> multipath 0 1 emc 2 1 round-robin 0 2 1 8:16 100 8:160 100 round-robin 0 2 1 8:64 100 8:112 100

For each table you will need to complete a suspend, load, resume sequence.

Aaron
