From: Nauman Rafique <nauman@google.com>
Subject: Re: IO scheduler based IO controller V10
Date: Mon, 5 Oct 2009 11:11:35 -0700
Message-ID: <e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>
References: <4AC6623F.70600@ds.jp.nec.com>
	<20091005.193808.104033719.ryov@valinux.co.jp>
	<20091005123148.GB22143@redhat.com>
	<20091005.235535.193690928.ryov@valinux.co.jp>
	<20091005171023.GG22143@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091005171023.GG22143@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, yoshikawa.takuya@oss.ntt.co.jp, jmoyer@redhat.com, mingo@elte.hu, righi.andrea@gmail.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, m-ikeda@ds.jp.nec.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Oct 5, 2009 at 10:10 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Oct 05, 2009 at 11:55:35PM +0900, Ryo Tsuruta wrote:
>> Hi Vivek,
>>
>> Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Mon, Oct 05, 2009 at 07:38:08PM +0900, Ryo Tsuruta wrote:
>> > > Hi,
>> > >
>> > > Munehiro Ikeda <m-ikeda@ds.jp.nec.com> wrote:
>> > > > Vivek Goyal wrote, on 10/01/2009 10:57 PM:
>> > > > > Before finishing this mail, will throw a whacky idea in the ri=
ng. I was
>> > > > > going through the request based dm-multipath paper. Will it ma=
ke sense
>> > > > > to implement request based dm-ioband? So basically we implemen=
t all the
>> > > > > group scheduling in CFQ and let dm-ioband implement a request =
function
>> > > > > to take the request and break it back into bios. This way we c=
an keep
>> > > > > all the group control at one place and also meet most of the r=
equirements.
>> > > > >
>> > > > > So request based dm-ioband will have a request in hand once th=
at request
>> > > > > has passed group control and prio control. Because dm-ioband i=
s a device
>> > > > > mapper target, one can put it on higher level devices (practic=
ally taking
>> > > > > CFQ at higher level device), and provide fairness there. One c=
an also
>> > > > > put it on those SSDs which don't use IO scheduler (this is kin=
d of forcing
>> > > > > them to use the IO scheduler.)
>> > > > >
>> > > > > I am sure that will be many issues but one big issue I could t=
hink of that
>> > > > > CFQ thinks that there is one device beneath it and dipsatches =
requests
>> > > > > from one queue (in case of idling) and that would kill paralle=
lism at
>> > > > > higher layer and throughput will suffer on many of the dm/md c=
onfigurations.
>> > > > >
>> > > > > Thanks
>> > > > > Vivek
>> > > >
>> > > > As long as using CFQ, your idea is reasonable for me. =A0But how=
 about for
>> > > > other IO schedulers? =A0In my understanding, one of the keys to =
guarantee
>> > > > group isolation in your patch is to have per-group IO scheduler =
internal
>> > > > queue even with as, deadline, and noop scheduler. =A0I think thi=
s is
>> > > > great idea, and to implement generic code for all IO schedulers =
was
>> > > > concluded when we had so many IO scheduler specific proposals.
>> > > > If we will still need per-group IO scheduler internal queues wit=
h
>> > > > request-based dm-ioband, we have to modify elevator layer. =A0It=
 seems
>> > > > out of scope of dm.
>> > > > I might miss something...
>> > >
>> > > IIUC, the request based device-mapper could not break back a reque=
st
>> > > into bio, so it could not work with block devices which don't use =
the
>> > > IO scheduler.
>> > >
>> >
>> > I think current request based multipath drvier does not do it but ca=
n't it
>> > be implemented that requests are broken back into bio?
>>
>> I guess it would be hard to implement it, and we need to hold requests
>> and throttle them at there and it would break the ordering by CFQ.
>>
>> > Anyway, I don't feel too strongly about this approach as it might
>> > introduce more serialization at higher layer.
>>
>> Yes, I know it.
>>
>> > > How about adding a callback function to the higher level controlle=
r?
>> > > CFQ calls it when the active queue runs out of time, then the hige=
r
>> > > level controller use it as a trigger or a hint to move IO group, s=
o
>> > > I think a time-based controller could be implemented at higher lev=
el.
>> > >
>> >
>> > Adding a call back should not be a big issue. But that means you are
>> > planning to run only one group at higher layer at one time and I thi=
nk
>> > that's the problem because than we are introducing serialization at =
higher
>> > layer. So any higher level device mapper target which has multiple
>> > physical disks under it, we might be underutilizing these even more =
and
>> > take a big hit on overall throughput.
>> >
>> > The whole design of doing proportional weight at lower layer is opti=
mial
>> > usage of system.
>>
>> But I think that the higher level approch makes easy to configure
>> against striped software raid devices.
>
> How does it make easier to configure in case of higher level controller=
?
>
> In case of lower level design, one just have to create cgroups and assi=
gn
> weights to cgroups. This mininum step will be required in higher level
> controller also. (Even if you get rid of dm-ioband device setup step).
>
>> If one would like to
>> combine some physical disks into one logical device like a dm-linear,
>> I think one should map the IO controller on each physical device and
>> combine them into one logical device.
>>
>
> In fact this sounds like a more complicated step where one has to setup
> one dm-ioband device on top of each physical device. But I am assuming
> that this will go away once you move to per reuqest queue like implemen=
tation.
>
> I think it should be same in principal as my initial implementation of =
IO
> controller on request queue and I stopped development on it because of =
FIFO
> dispatch.
>
> So you seem to be suggesting that you will move dm-ioband to request qu=
eue
> so that setting up additional device setup is gone. You will also enabl=
e
> it to do time based groups policy, so that we don't run into issues on
> seeky media. Will also enable dispatch from one group only at a time so
> that we don't run into isolation issues and can do time accounting
> accruately.

Will that approach solve the problem of doing bandwidth control on
logical devices? What would be the advantages compared to Vivek's
current patches?

>
> If yes, then that has the potential to solve the issue. At higher layer=
 one
> can think of enabling size of IO/number of IO policy both for proportio=
nal
> BW and max BW type of control. At lower level one can enable pure time
> based control on seeky media.
>
> I think this will still left with the issue of prio with-in group as gr=
oup
> control is separate and you will not be maintatinig separate queues for
> each process. Similarly you will also have isseus with read vs write
> ratios as IO schedulers underneath change.
>
> So I will be curious to see that implementation.
>
>> > > My requirements for IO controller are:
>> > > - Implement s a higher level controller, which is located at block
>> > > =A0 layer and bio is grabbed in generic_make_request().
>> >
>> > How are you planning to handle the issue of buffered writes Andrew r=
aised?
>>
>> I think that it would be better to use the higher-level controller
>> along with the memory controller and have limits memory usage for each
>> cgroup. And as Kamezawa-san said, having limits of dirty pages would
>> be better, too.
>>
>
> Ok. So if we plan to co-mount memory controller with per memory group
> dirty_ratio implemented, that can work with both higher level as well a=
s
> low level controller. Not sure if we also require some kind of a per
> memory group flusher thread infrastructure also to make sure higher wei=
ght
> group gets more job done.
>
>> > > - Can work with any type of IO scheduler.
>> > > - Can work with any type of block devices.
>> > > - Support multiple policies, proportional wegiht, max rate, time
>> > > =A0 based, ans so on.
>> > >
>> > > The IO controller mini-summit will be held in next week, and I'm
>> > > looking forard to meet you all and discuss about IO controller.
>> > > https://sourceforge.net/apps/trac/ioband/wiki/iosummit
>> >
>> > Is there a new version of dm-ioband now where you have solved the is=
sue of
>> > sync/async dispatch with-in group? Before meeting at mini-summit, I =
am
>> > trying to run some tests and come up with numbers so that we have mo=
re
>> > clear picture of pros/cons.
>>
>> Yes, I've released new versions of dm-ioband and blkio-cgroup. The new
>> dm-ioband handles sync/async IO requests separately and
>> the write-starve-read issue you pointed out is fixed. I would
>> appreciate it if you would try them.
>> http://sourceforge.net/projects/ioband/files/
>
> Cool. Will get to testing it.
>
> Thanks
> Vivek
>
