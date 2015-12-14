From: E V <eliventer@gmail.com>
Subject: Re: 4.4-rc4 multipath not working?
Date: Mon, 14 Dec 2015 15:57:11 -0500
Message-ID: <CAJtFHUQk5JWtxO=bB1JFRo2cedRmWNEragoYheX4ZRirnYd7Tg@mail.gmail.com>
References: <CAJtFHURrhfUqpqo8RLFRwJV55eAV68q62r71aHpvNH_J_Q=hLA@mail.gmail.com>
	<20151211210010.GA28142@redhat.com>
	<CAJtFHUTSuYZQNkcmDcUwpkPF3JV93OoozMaNP_CbRcL2aDKwMw@mail.gmail.com>
	<20151214185118.GA2369@redhat.com>
	<20151214195422.GH3080@octiron.msp.redhat.com>
	<CAJtFHURTbYHVEuSisiBUnNBZrOs-Kn4B0zsueFDCM=_o6Owqjw@mail.gmail.com>
	<20151214203651.GI3080@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151214203651.GI3080@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Ok, makes sense. Looks like mdadm auto assembled my devices on boot
without the dm-? devices. So mdadm -S freed up the devices and then
restarting multipath tools, and mdadm -A /dev/md/0 /dev/dm-5+...
worked perfect. Guess I just need to figure out how to make the mdadm
assemble take place after multipathd is up on boot. Thanks a lot.

On Mon, Dec 14, 2015 at 3:36 PM, Benjamin Marzinski <bmarzins@redhat.com> wrote:
> On Mon, Dec 14, 2015 at 03:09:50PM -0500, E V wrote:
>> Ok stop and start of multipathd now with path_selector "queue-length
>> 0" in defaults changes the map, but things still fail. Would a reboot
>> be in order, or just the start stop of multipath should clear it up?
>
> You don't need to reboot. You can see from the output that the change
> has already taken effect.  Could you post the output of
>
> # tail /var/log/messages
>
> right after you run the multipath command.  Most likely you will see
> messages like
>
> Dec 14 08:49:56 ask-07 kernel: device-mapper: table: 253:7: multipath:
> error getting device
> Dec 14 08:49:56 ask-07 kernel: device-mapper: ioctl: error adding target
> to table
>
> This usually means that one of the paths devices (In your case 8:48 or
> 65:176) or a partition of one of those devices is already in use.  It
> could be a partition in use by another device-mapper device, or possibly
> a filesystem is already mounted on the device. At any rate, if you free
> up the device from whatever has exclusively grabbed it, multipath should
> be able to set up on it.
>
> -Ben
>
>>
>> mpathc: selector = queue-length 0 (config file default)
>> mpathc: features = 0 (config file default)
>> mpathc: hwhandler = 0 (internal default)
>> mpathc: rr_weight = 1 (internal default)
>> mpathc: minio = 1 rq (config file default)
>> mpathc: no_path_retry = 0 (internal default)
>> mpathc: fast_io_fail_tmo = 5 (config file default)
>> mpathc: retain_attached_hw_handler = 1 (config file default)
>> sdd: No SAS end device for 'end_device-1:0'
>> sdab: No SAS end device for 'end_device-1:1'
>> mpathc: remove queue_if_no_path from '0'
>> mpathc: assembled map [0 0 2 1 queue-length 0 1 1 8:48 1 queue-length
>> 0 1 1 65:176 1]
>> mpathc: set ACT_CREATE (map does not exist)
>> mpathc: domap (0) failure for create/reload map
>> mpathc: ignoring map
>>
>> On Mon, Dec 14, 2015 at 2:54 PM, Benjamin Marzinski <bmarzins@redhat.com> wrote:
>> > Mike is correct about the malformed table. looking at your ouput, I see
>> >
>> >> > mpathc: selector = queue_length (config file default)
>> >
>> > This means that you likely have
>> >
>> > path_selector "queue_length"
>> >
>> > in the defaults section of /etc/multipath.conf
>> >
>> > This should be
>> >
>> > path_selector "queue-length 0"
>> >
>> > With both a dash instead of an underscore, and a zero to let the kernel
>> > know that this selector takes no arguments.
>> >
>> > multipath does some sanity checking on the config values, but it
>> > definitely could be better.  For instance, on the values like this, that
>> > it simply passes to the kernel as a string, it doesn't do any.
>> >
>> > -Ben
>> >
>> > On Mon, Dec 14, 2015 at 01:51:18PM -0500, Mike Snitzer wrote:
>> >> On Mon, Dec 14 2015 at 11:55am -0500,
>> >> E V <eliventer@gmail.com> wrote:
>> >>
>> >> > On Fri, Dec 11, 2015 at 4:00 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>> >> > > On Fri, Dec 11 2015 at 12:23pm -0500,
>> >> > > E V <eliventer@gmail.com> wrote:
>> >> > >
>> >> > >> Just tried booting 4.4-rc4 on a system with using the mptsas driver:
>> >> > >> LSISAS3008: FWVersion(03.00.08.00), ChipRevision(0x02), BiosVersion(05.07.02.00)
>> >> > >>
>> >> > >> And multipath doesn't seem to be working, dmesg has lots of these:
>> >> > >>
>> >> > >> device-mapper: table: 254:2: multipath: unknown path selector type
>> >> > >> device-mapper: ioctl: error adding target to table
>> >> > >
>> >> > > You compile the path selector module you're attempting to use?
>> >> > Yes as far as I can tell, here are the _DM_ config options in my config:
>> >> > CONFIG_BLK_DEV_DM_BUILTIN=y
>> >> > # CONFIG_DM_MQ_DEFAULT is not set
>> >> > # CONFIG_DM_DEBUG is not set
>> >> > # CONFIG_DM_CRYPT is not set
>> >> > # CONFIG_DM_SNAPSHOT is not set
>> >> > # CONFIG_DM_THIN_PROVISIONING is not set
>> >> > # CONFIG_DM_CACHE is not set
>> >> > # CONFIG_DM_ERA is not set
>> >> > # CONFIG_DM_MIRROR is not set
>> >> > CONFIG_DM_RAID=m
>> >> > # CONFIG_DM_ZERO is not set
>> >> > CONFIG_DM_MULTIPATH=y
>> >> > CONFIG_DM_MULTIPATH_QL=y
>> >> > # CONFIG_DM_MULTIPATH_ST is not set
>> >> > # CONFIG_DM_DELAY is not set
>> >> > CONFIG_DM_UEVENT=y
>> >> > # CONFIG_DM_FLAKEY is not set
>> >> > # CONFIG_DM_VERITY is not set
>> >> > # CONFIG_DM_SWITCH is not set
>> >> > # CONFIG_DM_LOG_WRITES is not set
>> >> >
>> >> >
>> >> > >> Is it expected to work? and any suggestions on getting it to work,
>> >> > >
>> >> > > Yes, no reason dm-multipath shouldn't work (other than user error).
>> >> > Entirely possible, this is my first multipath setup.
>> >> >
>> >> > > Figure out what the multipath table load line that failed to load
>> >> > > (verbose logging with multipathd?) and make sure you have the
>> >> > > corresponding path selector modules enabled in your .config
>> >> >
>> >> > Running multipathd with -v3 shows this in it's output, trimming 1st
>> >> > few columns for the 1st mpath device in the output. Doesn't mean much
>> >> > to me, other then I see the queue_length selector is set as expected:
>> >> > read /etc/multipath.conf
>> >> > multipath.conf line 8, duplicate keyword: defaults
>> >> > loading /lib/multipath/libcheckdirectio.so checker
>> >> > loading /lib/multipath/libprioconst.so prioritizer
>> >> > set open fds limit to 1048576/1048576
>> >> > sdab: ownership set to mpathc
>> >> > sdab: not found in pathvec
>> >> > sdab: mask = 0xc
>> >> > sdab: path state = running
>> >> > sdab: get_state
>> >> > directio: starting new request
>> >> > directio: io finished 4096/0
>> >> > sdab: state = up
>> >> > sdab: const prio = 1
>> >> > mpathc: pgfailback = -1 (config file default)
>> >> > mpathc: pgpolicy = failover (internal default)
>> >> > mpathc: selector = queue_length (config file default)
>> >> > mpathc: features = 0 (config file default)
>> >> > mpathc: hwhandler = 0 (internal default)
>> >> > mpathc: rr_weight = 1 (internal default)
>> >> > mpathc: minio = 1 rq (config file default)
>> >> > mpathc: no_path_retry = 0 (internal default)
>> >> > mpathc: fast_io_fail_tmo = 5 (config file default)
>> >> > mpathc: retain_attached_hw_handler = 1 (config file default)
>> >> > sdd: No SAS end device for 'end_device-1:0'
>> >> > sdab: No SAS end device for 'end_device-1:1'
>> >> > mpathc: remove queue_if_no_path from '0'
>> >> > mpathc: assembled map [0 0 2 1 queue_length 1 1 8:48 1 queue_length 1 1 65:176 1]
>> >>
>> >> This table looks malformed.
>> >>
>> >> Expected format is (from drivers/md/dm-mpath.c):
>> >>
>> >> /*-----------------------------------------------------------------
>> >>  * Constructor/argument parsing:
>> >>  * <#multipath feature args> [<arg>]*
>> >>  * <#hw_handler args> [hw_handler [<arg>]*]
>> >>  * <#priority groups>
>> >>  * <initial priority group>
>> >>  *     [<selector> <#selector args> [<arg>]*
>> >>  *      <#paths> <#per-path selector args>
>> >>  *         [<path> [<arg>]* ]+ ]+
>> >>  *---------------------------------------------------------------*/
>> >>
>> >> So in your case, breaking the map into logical sections, it is:
>> >>
>> >> 0 0 2 1
>> >>
>> >>   <#multipath feature args> = 0
>> >>   <#hw_handler args> = 0
>> >>   <#priority groups> = 2
>> >>   <initial priority group> = 1
>> >>
>> >> queue_length 1 1 8:48 1
>> >>
>> >>      <selector> = queue_length
>> >>      <#selector args> = 1 <BUT NO SELECTOR ARG!?>
>> >>      <#paths> = 1 <path> = 8:48 <arg> = 1
>> >>
>> >> queue_length 1 1 65:176 1
>> >>
>> >>      <selector> = queue_length <#selector args> = 1 <BUT NO SELECTOR ARG!?>
>> >>      <#paths> = 1 <path> = 65:176 <arg> = 1
>> >>
>> >> What do you have in your multipath.conf for 'path_selector'?
>> >>
>> >> AFAIK, it should be: path_selector queue-length 0
>> >>
>> >> (cc'ing Ben in case you need more multipath.conf help)
