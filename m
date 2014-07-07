From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
	I/O hang
Date: Mon, 07 Jul 2014 15:28:53 +0200
Message-ID: <53BAA095.3010905@acm.org>
References: <53AD6B62.2020407@acm.org> <20140627133345.GA6150@redhat.com>
	<20140702220223.GA23894@redhat.com> <53B56120.8040802@acm.org>
	<20140703140516.GB28104@redhat.com> <53B569E1.1010405@acm.org>
	<20140703150055.GA28518@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020706010005080707070609"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140703150055.GA28518@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------020706010005080707070609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/03/14 17:00, Mike Snitzer wrote:
> On Thu, Jul 03 2014 at 10:34am -0400,
> Bart Van Assche <bvanassche@acm.org> wrote:
> 
>> On 07/03/14 16:05, Mike Snitzer wrote:
>>> How easy would it be to replicate your testbed?  Is it uniquely FIO hw
>>> dependent?  How are you simulating the cable pull tests?
>>>
>>> I'd love to setup a testbed that would enable me to chase this more
>>> interactively rather than punting to you for testing.
>>
>> Hello Mike,
>>
>> The only nonstandard hardware that is required to run my test is a pair
>> of InfiniBand HCA's and an IB cable to connect these back-to-back. The
>> test I ran is as follows:
>> * Let an SRP initiator log in to an SRP target system.
>> * Start multipathd and srpd.
>> * Start a fio data integrity test on the initiator system on top of
>>   /dev/dm-0.
>> * From the target system simulate a cable pull by disabling IB traffic
>>   via the ibportstate command.
>> * After a random delay, unload and reload SCST and the IB stack. This
>>   makes the IB ports operational again.
>> * After a random delay, repeat the previous two steps.
> 
> I'll work on getting some IB cards.  But I _should_ be able to achieve
> the same using iSCSI right?

I'm not sure. There are differences between the SRP and iSCSI initiator
that could matter here, e.g. that the SRP initiator triggers
scsi_remove_host() some time after a path failure occurred but the iSCSI
initiator not. So far I have not yet been able to trigger this issue
with the iSCSI initiator with replacement_timeout = 1 and by using the
following loop to simulate path failures: while true; do iptables -A
INPUT -p tcp --destination-port 3260 -j DROP; sleep 10; iptables -D
INPUT -p tcp --destination-port 3260 -j DROP; sleep 10; done

>> If you want I can send you the scripts I use to run this test and also
>> the instructions that are necessary to build and install the SCST SRP
>> target driver.
> 
> Please do, thanks!

The test I run at the initiator side is as follows:

# modprobe ib_srp
# systemctl restart srpd
# systemctl start multipathd
# mkfs.ext4 -FO ^has_journal /dev/dm-0
# umount /mnt; fsck /dev/dm-0 && mount /dev/dm-0 /mnt && rm -f
/mnt/test* && fio --verify=md5 --rw=randwrite --size=10M --bs=4K
--iodepth=64 --sync=1 --direct=1 --ioengine=libaio --directory=/mnt
--name=test --thread --numjobs=1 --loops=$((10**9))

The script I run at the target side is as follows (should also be
possible with the upstream SRP target driver instead of SCST):
* Download, build and install SCST.
* Create a configuration file (/etc/scst.conf) in which /dev/ram0 is
exported via the vdisk_blockio driver.
* Start SCST.
* Run the attached toggle-ib-port-loop script e.g. as follows:
initiator=${initiator_host_name} toggle-ib-port-loop

Bart.

--------------020706010005080707070609
Content-Type: text/plain; charset=us-ascii;
 name="toggle-ib-port-loop"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="toggle-ib-port-loop"

#!/bin/bash

# How to start this test.
# On the initiator system, run:
# ~bart/bin/reload-srp-initiator
# /etc/init.d/srpd start
# mkfs.ext4 -O ^has_journal /dev/sdb
# /etc/init.d/multipathd start
# umount /mnt; mount /dev/dm-0 /mnt && rm -f /mnt/test* && ~bart/bin/fio-stress-test-6 /mnt 16
# On the target system, run:
# initiator=antec ~bart/software/tools/toggle-ib-port-loop

function port_guid() {
    local gid guid

    gid="$(</sys/class/infiniband/mlx4_0/ports/$1/gids/0)" || return $?
    guid="${gid#fe80:0000:0000:0000}"
    echo "0x${guid//:/}"
}

if [ -z "${initiator}" ]; then
    echo "Error: variable \${initiator} has not been set"
    exit 1
fi

guid1="$(port_guid 1)"
guid2="$(port_guid 2)"

set -x

/etc/init.d/srpd stop
while true; do
    ssh ${initiator} ibportstate -G "$guid1" 1 disable
    ssh ${initiator} ibportstate -G "$guid2" 2 disable
    sleep $((RANDOM*150/32767))
    /etc/init.d/scst stop
    /etc/init.d/opensmd stop
    /etc/init.d/openibd stop
    for m in mlx4_en mlx4_ib mlx4_core; do
	modprobe -r $m
    done
    /etc/init.d/openibd start
    /etc/init.d/opensmd start
    umount /dev/sr1
    ibstat |
        sed -n 's/^[[:blank:]]*Port GUID: 0x\(..\)\(..\)\(..\)....\(..\)\(..\)\(..\)/00:\2:\3:\4:\5:\6/p' |
        while read a; do
	    p="$(cd /sys/class/net && grep -lw $a */address)"
	    if [ -n "$p" ]; then
	        ifup "$(dirname $p)"
	    fi
	done
    /etc/init.d/scst restart
    sleep $((30 + RANDOM*30/32767))
done

--------------020706010005080707070609
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------020706010005080707070609--
