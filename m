From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: no_path_retry configurable per device basis?
Date: Thu, 14 May 2009 10:54:55 +0200
Message-ID: <561c252c0905140154h79bac5f0l6a5c7745dad26e6e@mail.gmail.com>
References: <561c252c0905130851q221e9febq61cc37f9fe9cee3@mail.gmail.com>
	<1242231573.13505.571.camel@breeves.fab.redhat.com>
	<561c252c0905131035p19ddb6fdp32482feb0b66bf1e@mail.gmail.com>
	<1242238110.13505.579.camel@breeves.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1242238110.13505.579.camel@breeves.fab.redhat.com>
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

ok.
Ach, I missed the "devices" section....
So now my multipath.conf is

blacklist {
        devnode "^cciss!c[0-9]d[0-9]*"
}

defaults {
	user_friendly_names yes
	polling_interval 30
	rr_min_io 100
        no_path_retry queue
}

devices {
	device {
		vendor			"IBM"
		product			"1750500"
		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
                prio_callout            "/sbin/mpath_prio_alua %d"=09
		features		"0"
		hardware_handler	"0"
                path_grouping_policy    group_by_prio
		failback		immediate
		rr_weight		uniform
                path_checker            tur
	  }
}

multipaths {
	multipath {
		wwid			3600507630efe0b0c0000000000000600
		alias			mpath0
	}
[snip]
	multipath {
		wwid			3600507630efe0b0c0000000000000610
		alias			mpath6
                no_path_retry           2
	}
[snip]
}

And after running
multipath
and reboot I get this with
multipath -l

so it seems it remains in "features=3D1 queue_if_no_path" from the
controller point of view....

[root@orastud2 ~]# multipath -l
[snip]
mpath0 (3600507630efe0b0c0000000000000600) dm-0 IBM,1750500
[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:1:0  sdaa 65:160 [active][undef]
 \_ 1:0:1:0  sdab 65:176 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:0:0  sda  8:0    [active][undef]
 \_ 1:0:0:0  sdd  8:48   [active][undef]
[snip]
mpath6 (3600507630efe0b0c0000000000000610) dm-12 IBM,1750500
[size=3D1.0G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:1:12 sday 67:32  [active][undef]
 \_ 1:0:1:12 sdaz 67:48  [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 1:0:0:12 sdy  65:128 [active][undef]
 \_ 0:0:0:12 sdz  65:144 [active][undef]
[snip]

Can I consider it ok?
I see with
multipath -l -v 3
...
     1:0:0:12 sdy  65:128 0   [undef][undef] IBM,1750500
     0:0:0:12 sdz  65:144 0   [undef][undef] IBM,1750500
params =3D 1 queue_if_no_path 0 2 1 round-robin 0 2 1 66:32 100 66:48 100=
 round-ro
bin 0 2 1 8:128 100 8:144 100
status =3D 2 0 0 0 2 1 A 0 2 0 66:32 A 0 66:48 A 0 E 0 2 0 8:128 A 0 8:14=
4 A 0
mpath2 (3600507630efe0b0c0000000000000602) dm-4 IBM,1750500
[size=3D15G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D0][active]
 \_ 1:0:1:4  sdai 66:32  [active][undef]
 \_ 0:0:1:4  sdaj 66:48  [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:0:4  sdi  8:128  [active][undef]
 \_ 1:0:0:4  sdj  8:144  [active][undef]
...
params =3D 1 queue_if_no_path 0 2 1 round-robin 0 2 1 67:32 100 67:48 100=
 round-ro
bin 0 2 1 65:128 100 65:144 100
status =3D 2 0 0 0 2 1 A 0 2 0 67:32 A 0 67:48 A 0 E 0 2 0 65:128 A 0 65:=
144 A 0
mpath6 (3600507630efe0b0c0000000000000610) dm-12 IBM,1750500
[size=3D1.0G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:1:12 sday 67:32  [active][undef]
 \_ 1:0:1:12 sdaz 67:48  [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 1:0:0:12 sdy  65:128 [active][undef]
 \_ 0:0:0:12 sdz  65:144 [active][undef]

So it seems there is no difference between mpath6 an the other ones??????

btw: if I change multipath.conf and I do nothing but reboot, I will
get the new config, correct?
This because, in my case, in rc.sysinit I have the block
        if ! strstr "$cmdline" nompath && [ -f /etc/multipath.conf -a \
                        -x /sbin/multipath.static ]; then
                modprobe dm-multipath > /dev/null 2>&1
                /sbin/multipath.static -v 0
                if [ -x /sbin/kpartx ]; then
                        /sbin/dmsetup ls --target multipath --exec
"/sbin/kpartx -a -p p"
                fi

that executes the
/sbin/multipath.static
command.
Is this correct?
And in general could I change in any way the multipath.conf and then run =
the
multipath
command or are there any parameters that need reboot?

Thanks for all your help.

Gianluca

On Wed, May 13, 2009 at 8:08 PM, Bryn M. Reeves <bmr@redhat.com> wrote:
> On Wed, 2009-05-13 at 19:35 +0200, Gianluca Cecchi wrote:
>> Thanks for answering.
>> why will I still see queue if_if_no_path?
>
> Because that's how retries are implemented; we enable queuing in the
> device-mapper target and setup a counter. Every time the I/O fails we
> decrement the counter by one. When it hits zero queuing is disabled in
> the kernel and the queued I/Os are permitted to fail. This is different
> to "no_path_retry queue" or "features '1 queue_if_no_path'" because wit=
h
> those options queuing will never be disabled. We keep the I/O in memory
> indefinitely until the paths return (or the host is rebooted).
>
>> Ok for the kb... it was the same I referred to in my qyestion... ;-)
>
> Sorry, didn't spot that ;)
>
>> And what about having a multipath.conf like this?
>>
>> blacklist {
>> =C2=A0 =C2=A0 =C2=A0 devnode "^cciss!c[0-9]d[0-9]*"
>> }
>>
>
> I'd put "no_path_retry queue" in your defaults block since you want it
> for all but one device on this storage:
>
>> defaults {
>> =C2=A0 =C2=A0 =C2=A0 user_friendly_names yes
>> =C2=A0 =C2=A0 =C2=A0 polling_interval 30
>> =C2=A0 =C2=A0 =C2=A0 rr_min_io 100
>> }
>
> The device section must be inside a devices { /*...*/ } block or it
> won't get parsed/recognised:
>
>> =C2=A0 =C2=A0 =C2=A0 device {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"IBM"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "1750500"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 getuid_callout =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0"/sbin/scsi_id -g -u -s /block/%n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 prio_callout =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"/sbin/mpath_prio_alua %d"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hardware_handler =C2=A0=
 =C2=A0 =C2=A0 =C2=A0"0"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_grouping_policy =
=C2=A0 =C2=A0group_by_prio
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 failback =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0immediate
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rr_weight =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uniform
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_checker =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tur
>
> Since you only want this behavior for one LUN, why not set it at the
> multipath level?
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_path_retry 3
>> =C2=A0 =C2=A0 =C2=A0 }
>
>> multipaths {
>> =C2=A0 =C2=A0 =C2=A0 multipath {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wwid =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03600507630efe0b0c0000=
000000000600
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 alias =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpath0
>
> You can probably put this line in your defaults block and only override
> it for the LUN on which you want a max of three retries:
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_path_retry =C2=A0 =
=C2=A0 =C2=A0queue
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 multipath {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wwid =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03600507630efe0b0c0000=
000000000601
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 alias =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpath1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_path_retry =C2=A0 =
=C2=A0 =C2=A0queue
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0[snip]
>> =C2=A0 =C2=A0 =C2=A0 multipath {
>
> I'd probably put the "no_path_retry 3" here:
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wwid =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03600507630efe0b0c0000=
000000000610
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 alias =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpath6
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 [snip]
>> }
>>
>> what would I see with multipath -l?
>>
>> As in defaults for this device there is
>> features 1 queue_if_no_path
>> and there is no other option configurable per "features" key in device
>> section....
>> what would be the effect?
>> Or in other words, can I disable the "features" key for a device....?
>> For example setting fir it the no_path_retry that semms applicable to
>> the device section itself...?
>
> You'll need to remove that features option from the device block as you
> have above, or specify an empty features property like:
>
> features =C2=A0 =C2=A0 =C2=A0 =C2=A0"0"
>
> Regards,
> Bryn.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
