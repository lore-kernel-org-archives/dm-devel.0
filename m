From: Ross Anderson <rosander@dsotm.net>
Subject: Re: multipath 4k partition block issues.
Date: Wed, 04 Sep 2013 18:38:17 -0500
Message-ID: <5227C469.6010200@dsotm.net>
References: <52279FC1.4000707@dsotm.net> <20130904212705.GA28020@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130904212705.GA28020@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Greetings,

>> Greetings,
>>
>>
>> The current git version of multipath-tools doesn't properly handle
>> 4k block sizes and partions creation. There very little verbose
>> output but I will post what I can find. I would appreciate any help
>> getting this working.
>>
>> The raw devices detect the 4k partition.
> Ben Marzinski had a patch to print the table _before_ it was sent to the
> kernel so that we had something to go on beyond "253:6: multipath: error
> getting device"...
>
> As is the output is useless.  We have no idea _why_ it failed to get the
> device (or which device it failed to get).  We can do better here in
> both kernel and userspace error logging.  But chances are multipathd is
> just looking to use multipath on devices that aren't meant for
> multipathing (and they should be blacklisted in the multipath.conf).

I've very carefully blacklisted all the non-mp devices. They are all FC 
from two target devices. Any non EMC device is 4k block. 512 partition 
devices do detect.






>> A manual run of kpartx -a creates the dm points.
> Which distro is this?

This particular machine is a Gentoo disto. I have other debian and 
Ubuntu. Udev v204


>
> So samplelib and sfx4k are 4K devices that have partitions.
>
> [multipathd] sfx4k: load table [0 165076992 multipath 0 0 1 1 service-time 0 2 1 8:192 4 8:144 4]
> [multipathd] samplelib: load table [0 461373440 multipath 0 0 1 1 service-time 0 2 1 65:16 4 8:240 4]
>
> I assume these devices map to sdp and sdr, and likely other devices not
> provided in your log output.  multipathd -ll would be useful.

I realize I trimmed a few of the extra devices out of the list to focus 
down to the main set. Didn't want to flood the list with full logs. 
here's -ll

Thanks

audio (26334336163623562) dm-4 SCST_FIO,audio
size=2.5T features='0' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
   |- 7:0:1:2 sdo 8:224 active ready running
   `- 8:0:1:2 sdp 8:240 active ready running
sfx4k (23836326166643837) dm-2 SCST_FIO,sfx4k
size=79G features='0' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
   |- 7:0:1:0 sdk 8:160 active ready running
   `- 8:0:1:0 sdl 8:176 active ready running
emc-test (36006048000018799014253594d313037) dm-0 EMC ,SYMMETRIX
size=54G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
   |- 7:0:0:0 sdg 8:96  active ready running
   `- 8:0:0:0 sdh 8:112 active ready running
general (26562393662643538) dm-3 SCST_FIO,general
size=600G features='0' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
   |- 7:0:1:1 sdm 8:192 active ready running
   `- 8:0:1:1 sdn 8:208 active ready running
emc-bak (36006048000018799014253594d313238) dm-1 EMC ,SYMMETRIX
size=3.8T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
   |- 7:0:0:1 sdi 8:128 active ready running
   `- 8:0:0:1 sdj 8:144 active ready running
samplelib (26266376537366261) dm-5 SCST_FIO,samplerlib
size=220G features='0' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
   |- 7:0:1:3 sdq 65:0  active ready running
   `- 8:0:1:3 sdr 65:16 active ready running

> Are you certain none-4K devices with partitions are created properly?
> (I think multpathd leans on kpartx to be invoked by udev after the
> multipathd device is established but I could be misrembering).. Could be
> the udev hook isn't working in general?
>
> Mike
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
