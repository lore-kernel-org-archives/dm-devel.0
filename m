From: Milan Broz <mbroz@redhat.com>
Subject: Re: Bug#648367: device-mapper devices such as dm-crypt
 always have rotational=1;
 should inherit "rotational" setting from underlying devices
Date: Tue, 15 Nov 2011 08:34:18 +0100
Message-ID: <4EC215FA.1090303@redhat.com>
References: <20111110195943.12083.93273.reportbug@leaf>
	<1321232729.3059.42.camel@deadeye> <20111114022644.GB30421@leaf>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111114022644.GB30421@leaf>
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
Cc: 648367@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>, Josh Triplett <josh@joshtriplett.org>
List-Id: dm-devel.ids

On 11/14/2011 03:26 AM, Josh Triplett wrote:
> OK, I suppose I don't actually care what rotational shows for a
> device-mapper device backed by rotating media.  The case I care about:
> when the underlying media has rotational=0, the dm device definitely
> shouldn't have rotational=1.

Rotational flag is inherited in DM core, nothing dm-crypt specific.
And it works (for several kernel releases already):


create test scsi disk (also with discards)
# modprobe scsi_debug dev_size_mb=16 sector_size=512 num_tgts=1 lbpu=1
# grep scsi_debug /sys/block/*/device/model               
/sys/block/sdj/device/model:scsi_debug 

Map some crypt device over it
# echo "password" | cryptsetup create sdj_crypt /dev/sdj

And now see inherited ROTA flag (it is /sys rotational)

# lsblk -t /dev/sdj
NAME               ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE
sdj                        0    512  32768     512     512    0 cfq       128
`-sdj_crypt (dm-0)         0    512  32768     512     512    0           128


Please paste lsblk -t output tree if you think there is a bug, do not blindly
check all dm-X devices queues.

Milan
