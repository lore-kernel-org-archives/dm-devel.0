From: Bob Gautier <rgautier@redhat.com>
Subject: RE: [Consult-list] Re: dm-multipath has greatthroughput
	but we'd like more!
Date: Tue, 23 May 2006 08:29:16 +0100
Message-ID: <1148369356.20887.19.camel@baggage>
References: <D98EDC8DA509404185E74C0DFA2BF42D1EAC52@sg1255z.corproot.net>
Reply-To: rgautier@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D98EDC8DA509404185E74C0DFA2BF42D1EAC52@sg1255z.corproot.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thomas.vonSteiger@swisscom.com
Cc: nstrug@redhat.com, dm-devel@redhat.com, consult-list@redhat.com
List-Id: dm-devel.ids

On Mon, 2006-05-22 at 19:21 +0200, Thomas.vonSteiger@swisscom.com wrote:
> Interessting Discussion!
> 
> If you are running in a big enterprise SAN then it's possible that your
> server shares the HDS Port with 30 other servers.
> 
> I have done
> "bonnie++ -d /iotest -s 6g -f -n 0 -u root" on AMD LS20 IBM Blade
> 2x2Gb's qla HBA's / 3Gb Mem
> and
> "bonnie++ -d /iotest -s 8g -f -n 0 -u root" on Intel HS20 IBM Blade /
> 2x2Gb's qla HBA's / 4Gb Mem.
> SAN Storage (HDS USP100) with dm-multipath (failover and multibus) for
> ext3 and ext2.
> OS are RHEL4/U3.
> 
> Results are in the att bonnue1.html
> 
> Defaults from /etc/multipath.conf:
> defaults {
>    udev_dir                /dev
>    polling_interval        10
>    selector                "round-robin 0"
>    default_path_grouping_policy   multibus
>    getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>    prio_callout            /bin/true
>    path_checker            readsector0
>    rr_min_io               100
>    rr_weight               priorities
>    failback                immediate
>    no_path_retry           20
>    user_friendly_name      yes
> }
> 
> Thomas
> 
> 
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Nicholas C. Strugnell
> Sent: Thursday, May 18, 2006 11:43 AM
> To: rgautier@redhat.com
> Cc: device-mapper development; consult-list@redhat.com
> Subject: Re: [Consult-list] Re: [dm-devel] dm-multipath has
> greatthroughput but we'd like more!
> 
> On Thu, 2006-05-18 at 10:04 +0200, Nicholas C. Strugnell wrote: 
> > On Thu, 2006-05-18 at 08:44 +0100, Bob Gautier wrote:
> > > On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
> > > > The system bus isn't a limiting factor is it?  64-bit PCI-X will 
> > > > get
> > > > 8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.
> > > > 
> > > > Can your disks sustain that much bandwidth? 10 striped drives 
> > > > might get better than 200MB/s if done right, I suppose.
> > > > 
> > 
> 
> > It might make sense to test raw writes to a device with dd and see if 
> > that gets comparable performance figures - I'll just try that myself 
> > actually.
> 
> write throughput to EVA 8000 (8GB write cache), host DL380 with 2x2Gb/s
> HBAs, 2GB RAM
> 
> testing 4GB files:
> 
> on filesystems: bonnie++ -d /mnt/tmp -s 4g -f -n 0 -u root
> 
> ext3: 129MB/s sd=0.43
> 
> ext2: 202MB/s sd=21.34
> q
> on raw: 216MB/s sd=3.93  (dd if=/dev/zero
> of=/dev/mpath/3600508b4001048ba0000b00001400000 bs=4k count=1048576)
> 
> 
> NB I did not have exclusive access to the SAN or this particular storage
> array - this is a big corp. SAN network under quite heavy load and disk
> array under moderate load - not even sure if I had exclusive access to
> the disks. All values averaged over 20 runs. 
> 
> The very low deviation of write speed on ext3 vs. exr2 or raw is
> interesting - not sure if it means anything.
> 
> In any case, we don't manage to get very close to the theoretical
> throughput of the 2 HBAs, 512MB/s

Thanks both of you for the interesting figures.  It looks like ext3 is
putting a heavier load on a machine than ext2 -- Thomas' CPU load in the
ext3 cases is quite high -- so maybe that's keeping throughput limited.

On the other hand, I still don't see why, if I can drive *two* HBAs at a
total of about 200MB/s, I can only drive *one* at about half that.

By the way, when we did our tests, the SAN was quiet lightly loaded, and
we were watching its write cache level quite closely to ensure we didn't
cause any problems for other users.

Bob G

> 
> Nick
> 
> 
> 
