From: Adam Chasen <adam@chasen.name>
Subject: Re: [Multipath] Round-robin performance limit
Date: Wed, 5 Oct 2011 15:54:35 -0400
Message-ID: <CANtKax+PzU=yVepQh3Kq7NK671-bSpYfms2Xu_YgdXQ0cDG6kA@mail.gmail.com>
References: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
	<20110502072528.GW32595@reaktio.net>
	<BANLkTi=h0AwEy0S4Miv-SYTEu3jF0DXXJQ@mail.gmail.com>
	<1304375238.3134.23.camel@denise.theartistscloset.com>
	<20110503050406.GA11442@us.ibm.com>
	<1304417561.25728.16.camel@denise.theartistscloset.com>
	<CANtKaxLFSvg-iMGJ-fKPM=9HR1ORWOdMoEs2uQJkSGR-JpesYg@mail.gmail.com>
	<CANtKax+RqXJeor4dBzQewWT+k8EG2s63NFYSi=pRN0v3MLPKBA@mail.gmail.com>
	<1317784026.31536.7.camel@denise.theartistscloset.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1317784026.31536.7.camel@denise.theartistscloset.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, jsullivan@opensourcedevel.com
List-Id: dm-devel.ids

John,
I am limited in a similar fashion. I would much prefer to use multibus
multipath, but was unable to achieve bandwidth which would exceed a
single link even though it was spread over the 4 available links. Were
you able to gain even a similar performance of the RAID0 setup with
the multibus multipath?

Thanks,
Adam

On Tue, Oct 4, 2011 at 11:07 PM, John A. Sullivan III
<jsullivan@opensourcedevel.com> wrote:
> On Tue, 2011-10-04 at 16:19 -0400, Adam Chasen wrote:
>> Unfortunately even with playing around with various settings, queues,
>> and other techniques, I was never able to exceed the bandwidth of more
>> than one of the Ethernet links when accessing a single multipathed
>> LUN.
>>
>> When communicating with two different multipathed LUNs, which present
>> as two different multipath devices, I can saturate two links, but it
>> is still a one to one ratio of multipath devices to link saturation.
>>
>> After further research on multipathing, it appears people are using md
>> raid to achieve multipathed devices. My initial testing of using raid0
>> md-raid device produces the behavior I expect of multipathed devices.
>> I can easily saturate both links during read operations.
>>
>> I feel using md-raid is a less elegant solution than using
>> dm-multipath, but it will have to suffice until someone can provide me
>> some additional guidance.
>>
>> Thanks,
>> Adam
> We recently changed from the RAID0 approach to multipath multibus.
> RAID0 did seem to give more even performance over a variety of IO
> patterns but it had a critical flaw. =A0We could not use the snapshot
> capabilities of the SAN because we could never be certain of
> snapshotting the RAID0 disks in a transactionally consistent state. =A0If
> I have four disk in a RAID0 array and snapshot them all, how can I be
> assured that I have not done something like written two of three stripes
> and no parity. =A0This was our singular reason for discarding RAID0 over
> iSCSI for multipath multibus - John
>
>>
>> On Mon, Oct 3, 2011 at 11:08 PM, Adam Chasen <adam@chasen.name> wrote:
>> > Malahal,
>> > After your mentioning bio vs request based I attempted to determine if
>> > my kernel contains the request based mpath. It seems in 2.6.31 all
>> > mpath was switched to request based. I have a kernel 2.6.31+ (actually
>> > .35 and .38), so I believe I have requrest-based mpath.
>> >
>> > All,
>> > There also appears to be a new multipath configuration option
>> > documented in the RHEL 6 beta documentation:
>> > rr_min_io_rq =A0 =A0Specifies the number of I/O requests to route to a=
 path
>> > before switching to the next path in the current path group, using
>> > request-based device-mapper-multipath. This setting should be used on
>> > systems running current kernels. On systems running kernels older than
>> > 2.6.31, use rr_min_io. The default value is 1.
>> >
>> > http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6-Beta/html=
/DM_Multipath/config_file_multipath.html
>> >
>> > I have not tested using this setting vs rr_min_io yet or even if my
>> > system supports the configuration directive.
>> >
>> > If I trust some of the claims of several VMware ESX iscsi multipath
>> > setups, it is possible (possibly using different software) to gain a
>> > multiplicative throughput by adding additional Ethernet links. This
>> > makes me hopeful that we can do this with open-iscsi and dm-mulitpath
>> > as well.
>> >
>> > It could be something obvious I am missing, but it appears a lot of
>> > people experience this same issue.
>> >
>> > Thanks,
>> > Adam
>> >
>> > On Tue, May 3, 2011 at 6:12 AM, John A. Sullivan III
>> > <jsullivan@opensourcedevel.com> wrote:
>> >> On Mon, 2011-05-02 at 22:04 -0700, Malahal Naineni wrote:
>> >>> John A. Sullivan III [jsullivan@opensourcedevel.com] wrote:
>> >>> > I'm also very curious about your findings on rr_min_io. =A0I canno=
t find
>> >>> > my benchmarks but we tested various settings heavily. =A0I do not =
recall
>> >>> > if we saw more even scaling with 10 or 100. =A0I remember being su=
rprised
>> >>> > that performance with it set to 1 was poor. =A0I would have though=
t that,
>> >>> > in a bonded environment, changing paths per iSCSI command would gi=
ve
>> >>> > optimal performance. =A0Can anyone explain why it does not?
>> >>>
>> >>> rr_min_io of 1 will give poor performance if your multipath kernel
>> >>> module doesn't support request based multipath. In those BIO based
>> >>> multipath, multipath receives 4KB requests. Such requests can't be
>> >>> coalesced if they are sent on different paths.
>> >> <snip>
>> >> Ah, that makes perfect sense and why 3 seems to be the magic number in
>> >> Linux (4000 / 1460 (or whatever IP payload is)). =A0Does that change =
with
>> >> Jumbo frames? In fact, how would that be optimized in Linux?
>> >>
>> >> 9KB seems to be a reasonable common jumbo frame value for various
>> >> vendors and that should contain two pages but, I would guess, Linux
>> >> can't utilize it as each block must be independently acknowledged. Is
>> >> that correct? Thus a frame size of a little over 4KB would be optimal
>> >> for Linux?
>> >>
>> >> Would that mean that rr_min_io of 1 would become optimal? However, if
>> >> each block needs to be acknowledged before the next is sent, I would
>> >> think we are still latency bound, i.e., even if I can send four reque=
sts
>> >> down four separate paths, I cannot send the second until the first has
>> >> been acknowledged and since I can easily place four packets on the sa=
me
>> >> path within the latency period of four packets, multibus gives me
>> >> absolutely no performance advantage for a single iSCSI stream and only
>> >> proves useful as I start multiplexing multiple iSCSI streams.
>> >>
>> >> Is that analysis correct? If so, what constitutes a separate iSCSI
>> >> stream? Are two separate file requests from the same file systems to =
the
>> >> same iSCSI device considered two iSCSI streams and thus can be
>> >> multiplexed and benefit from multipath or are they considered all part
>> >> of the same iSCSI stream? If they are considered one, do they become =
two
>> >> if they reside on different partitions and thus different file system=
s?
>> >> If not, then do we only see multibus performance gains between a sing=
le
>> >> file system host and a single iSCSI host when we use virtualization e=
ach
>> >> with their own iSCSI connection (as opposed to using iSCSI connections
>> >> in the underlying host and exposing them to the virtual machines as
>> >> local storage)?
>> >>
>> >> I hope I'm not hijacking this thread and realize I've asked some
>> >> convoluted questions but optimizing multibus through bonded links for
>> >> single large hosts is still a bit of a mystery to me. =A0Thanks - John
>> >>
>> >> --
>> >> dm-devel mailing list
>> >> dm-devel@redhat.com
>> >> https://www.redhat.com/mailman/listinfo/dm-devel
>> >>
>> >
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
