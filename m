From: seth vidal <skvidal@linux.duke.edu>
Subject: failover time and failback time
Date: Sat, 26 Aug 2006 13:35:23 -0400
Message-ID: <1156613723.13298.18.camel@cutter>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, 
 my setup is this:
  Dell Poweredge 1850s running qlogic qla2340 adapters 2 of them plugged
into a dual fabric san. I have 4, 128GB luns available. They are being
sent out to both adapters. They are on an EVA8000 - it shows up as
hsv210. We've been relatively picky about parts to make sure we're using
supported hardware.

We're running Centos 4.3 and the only odd part is that I'm currently
running with qlogic's driver from their site version 8.01.05.

I've disabled the driver-based failover support using the module option.

We're only using this driver for two reasons:
1. sansurfer cli supports it.
2. it was recommended to be used.

However, I'm not wed to using this driver versus the one in the kernel.
So, I am open to suggestions.

Here is the problem  I'm seeing:

I've got two luns active and defined in my /etc/multipathd.conf file:
devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}

## Use user friendly names, instead of using WWIDs as names.
defaults {
        user_friendly_names yes
        polling_interval 1

}
multipaths {
        multipath {
                wwid
3600508b40010764b0000b00003660000
                alias                   "lun2"
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           queue
        }
        multipath {
                wwid
3600508b40010764b0000b000036b0000
                alias                   "lun3"
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           queue
        }
}

I've set one up using failover and one using multibus. I did this to
benchmark and play with the failure modes so I could become more
familiar with them if they were to occur in non-testing environments.

I format the devices, mount them and I start running tiobench on them to
give them something to do.

multipath -ll shows:

lun3 (3600508b40010764b0000b000036b0000)
[size=128 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [prio=240][active]
 \_ 2:0:2:3 sdac 65:192 [failed][ready]
 \_ 2:0:3:3 sdag 66:0   [failed][ready]
 \_ 1:0:0:3 sde  8:64   [active][ready]
 \_ 1:0:1:3 sdi  8:128  [active][ready]
 \_ 1:0:2:3 sdm  8:192  [active][ready]
 \_ 1:0:3:3 sdq  65:0   [active][ready]
 \_ 2:0:0:3 sdu  65:64  [failed][ready]
 \_ 2:0:1:3 sdy  65:128 [failed][ready]

lun2 (3600508b40010764b0000b00003660000)
[size=128 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [prio=10][enabled]
 \_ 2:0:2:2 sdab 65:176 [active][ready]
\_ round-robin 0 [prio=10][enabled]
 \_ 2:0:3:2 sdaf 65:240 [active][ready]
\_ round-robin 0 [prio=50][active]
 \_ 1:0:0:2 sdd  8:48   [active][ready]
\_ round-robin 0 [prio=50][enabled]
 \_ 1:0:1:2 sdh  8:112  [active][ready]
\_ round-robin 0 [prio=10][enabled]
 \_ 1:0:2:2 sdl  8:176  [active][ready]
\_ round-robin 0 [prio=10][enabled]
 \_ 1:0:3:2 sdp  8:240  [active][ready]
\_ round-robin 0 [prio=50][enabled]
 \_ 2:0:0:2 sdt  65:48  [active][ready]
\_ round-robin 0 [prio=50][enabled]
 \_ 2:0:1:2 sdx  65:112 [active][ready]


which is what I'd expect to see. Lun2 is using failover, lun3 using
multibus.

Then I yank one connection on one of the cards in the back of the
system.
I watch dmesg and I see:
qla2300 0000:03:0b.0: LOOP DOWN detected (2).

At this point I would expect multipathd to fail out the paths connected
and continue happily. 

But then I see this:

Aug 26 13:02:36 kernel: qla2300 0000:03:0b.0: LOOP DOWN detected (2).
Aug 26 13:04:06 kernel: SCSI error : <2 0 0 3> return code = 0x10000
Aug 26 13:04:06 kernel: end_request: I/O error, dev sdu, sector 12073512
Aug 26 13:04:06 kernel: device-mapper: dm-multipath: Failing path 65:64.
Aug 26 13:04:07 kernel: end_request: I/O error, dev sdu, sector 12073520
Aug 26 13:04:07 kernel: SCSI error : <2 0 0 3> return code = 0x10000
Aug 26 13:04:07 kernel: end_request: I/O error, dev sdu, sector 12074536
Aug 26 13:04:07 kernel: end_request: I/O error, dev sdu, sector 12074544
Aug 26 13:04:07 kernel: SCSI error : <2 0 0 3> return code = 0x10000
Aug 26 13:04:07 kernel: end_request: I/O error, dev sdu, sector 12075560
Aug 26 13:04:07 kernel: end_request: I/O error, dev sdu, sector 12075568
.... Repeat for a while.
Aug 26 13:07:15  kernel: device-mapper: dm-multipath: Failing path 66:0.
Aug 26 13:07:15  kernel: SCSI error : <2 0 2 3> return code = 0x10000
Aug 26 13:07:15  kernel: end_request: I/O error, dev sdac, sector
9061176
Aug 26 13:07:16  kernel: end_request: I/O error, dev sdac, sector
9061184
Aug 26 13:07:16  kernel: device-mapper: dm-multipath: Failing path
65:192.
Aug 26 13:07:16  kernel: SCSI error : <2 0 1 3> return code = 0x10000
Aug 26 13:07:16  kernel: end_request: I/O error, dev sdy, sector 9061176
Aug 26 13:07:16  kernel: end_request: I/O error, dev sdy, sector 9061184
Aug 26 13:07:16  kernel: device-mapper: dm-multipath: Failing path
65:128.

At which point the device/mount point becomes accessible again and all
is happy.

First - why does it take so long and should I be seeing so many scsi
errors? which error is 0x10000?

Next, After the device has failed over I plug the connection back in and
I see:
Aug 26 13:08:42 kernel: qla2300 0000:03:0b.0: LOOP UP detected (2 Gbps).

Great - it noticed it was back. Now it should failback. Except I wait
and wait and it never seems to failback. It only fails back when I run
'multipath' then everything is fine, or at least seems to be.


So my issues are: 
1. why does it take so long to failover and what can I do about it?
2. why does it seem like it doesn't want to failback?

I've gone through the archives of this list and nothing here seems
immediately applicable, though I think I've learned more about san's and
multipath capabilities from reading the list archives than I've learned
in any number of books. :)

Thank you,
-sv
