From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 14/16] multipath.rules:
 find_multipaths+ignore_wwids logic
Date: Sat, 20 Jan 2018 21:21:53 -0600
Message-ID: <20180121032153.GA14513@octiron.msp.redhat.com>
References: <20180119002916.10323-1-mwilck@suse.com>
	<20180119002916.10323-15-mwilck@suse.com>
	<20180119181219.GD5638@octiron.msp.redhat.com>
	<1516411258.4005.49.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516411258.4005.49.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

I apologize in advance for how long this is. I feel like that guy who
corners people at parties to talk about politics and won't shut up.  I
will reply to the specific points of your last email later, with much
shorter answers.

I think we are talking past each other a bit here.  I know that in my
last reply I was building on points from my earlier reply without making
that clear enough.  But lets go back to stating the problem in a way we
can agree on, and then see if I can explain my thoughts better from that
common ground.

There are four classes of potential path devices that multipath sees:
        1. blacklisted devices
        2. devices in the wwids file
        3. devices that are neither blacklisted or in the wwids file
           but that you know will be multipathed.
           (basically new devices in the non-find_multipaths case)
        4. devices that are neither blacklisted or in the wwids file
           where don't know if they will be multipathed.
           (basically new devices and single paths in the
            find_multipaths case)

The problem we are trying to deal with is only about the 4th class.  In
the other classes we all agree that multipath and multipathd can get the
correct answer immediately.

There are three subsets of this 4th class of devices:
        4A. The device should not be multipathed
        4B. The device should be multipathed and nothing else wants to
            use it
        4C. The device should be multipathed but something else wants to
            use it

4A: If in reality, the device should not be multipathed, then mutipathd
will never assemble on the device. So there are only two possible
outcomes

        1. The device is not claimed by multipath, and is not
           multipathed
        2. The device is claimed by multipath, but not multipathed

Outcome 1 is the correct one. multipath temporarily claiming a device,
and then unclaiming it in a timely manner is also Outcome 1.

Outcome 2 is very bad.  This was the cause of your "imply -n if
find_mutipaths" patch. This is why RedHat never runs "multipath -u" with
"-i".  If multipath claims a device and multipathd doesn't assemble on
it, nobody can use the device, and the system can become unusable. Even
worse, since we don't have anything like an ignore-these-wwids file
(that's what the blacklist is for, but that's class 1, and we're only
looking at class 4 here) you can hit this every time you discover that
device. This is an outcome that any solution must absolutely avoid.


4B: If in reality, the device should be multipathed and there is nothing
else that wants to use the path device, multipathd should always be able
to assemble on the device.  However, if you run mutipathd with -n, that
is not the case.  Thus, there are four possible outcomes.

        1. The device is not claimed by multipath, and is not
           multipathed
        2. The device is claimed by multipath, but not multipathed
        3. The device is not claimed by multipath, but is multipathed
        4. The device is claimed by multipath and is multipathed

Outcome 1 is the multpathd -n case, working correctly. It is pretty
suboptimal, since you could have safely assembled the multipath device.
However, multipathd couldn't know before-hand that there was nothing
else that wanted to use the device.

Outcome 2 is the multipathd -n case, without synchronization with
mutipath.  This isn't as bad as Outcome 2 in the 4A class, because
nothing wants the device, but there is still no reason for this to ever
happen.

Outcome 3 is a little sloppy, but assuming that multipathd can claim the
device afterwards, it appears completely correct to the user, and will
only happen once. On future boots this device will be in the wwids file
(class 2).

Outcome 4 is the correct one


4C: If in reality, the device should be multipathed but there is
something else that also wants to use the device, there are four
possible outcomes:

        1. The device is not claimed by multipath, and is not
           multipathed
        2. The device is claimed by multipath, but not multipathed
        3. The device is not claimed by multipath, but is multipathed
        4. The device is claimed by multipath and is multipathed

Outcome 1 is suboptimal, since the device really should be multipathed,
but the system will still be usable (albeit, with only a single path to
the storage).  However, this is fixable for future boots, by adding the
wwid to the wwids file.

Outcome 2 is just as bad as Outcome 2 in class 4A. Of course, if the
device is supposed to be multipathed, and is claimed by multipath, it is
very likely that multipathd will assemble on it, so this is an extremely
rare case.

Outcome 3 is the cause of the never actually observed bug I explained in
an earlier eamil. If multipath doesn't claim the device, then whatever
else wants to use it will go ahead and try.  If multipathd comes along
and assembles on the device, that can keep the other user from being
able to actually use the device as it was planning to. The other user
may see the multipth device and try using it after failing on the path
device, but it could simply give up after failing on the path device.  I
want to note that this can only happen if the new multipathable storage
already has metadata on it that is supposed to get autoassembled,
mounted, etc. Further, as both of us have pointed out during this email
thread, multipathd is very unlikely to win this race. It starts later
than other things that use the devices, and find_multipaths has to wait
for two paths to appear before it can start to assemble the device,
while other users can begin right away. Outcome 1 is what happens when
multipathd fails this race.

Outcome 4 is the correct one.

We also know something about the relative frequency of these various
classes (4A, 4B, and 4C). Class 4A devices are seen every single boot
when there are single path devices and find_multipaths is set. Any
solution must do this one right because this is the general case.
Classes 4B and 4C are very rare in comparison. A chunk of users will
never encounter these classes of devices.  I'm not sure how 4B and 4C
compare to each other, but if I had to guess, I would assume that 4B is
more common than 4C.

RedHat's current solution guarantees that you always get Outcome 1 for
4A devices, Outcome 3 for 4B devices, and either Outcome 1 or Outcome 3
for 4C devices (however in practice, 4C Outcome 3 has never been
reported).

SUSE's "imply -n on find_multipaths" solution guarantees that you always
get Outcome 1 for 4A devices, Outcome 1 for 4B devices, and Outcome 1
for 4C devices.

Hopefully we agree on the above analysis. If you think I'm wrong in part
of it, please let me know, because this is what I'm reasoning from. Now
on to your and my proposed solutions.

Your proposed solution guarantees that you always get Outcome 1 for 4A
devices.

After that it gets a little trickier. Your solution involves a timeout,
and that timeout can delay booting if there are 4A devices. Even if we
do the equivalent of "multipath -n" in the initramfs, there are often
still filesystems that need to mount after we switch-root. Those will
get delayed, and the machine may not be usable until they are mounted. I
really do feel that this will not be a rare case at all. You pointed out
that this can be dealt with by decreasing the timeout, even all the way
to 0.  I think that since this timeout is protecting against a problem
in the rare case, by making the common case slower, users will be very
inclined to decrease it.  Thus, it's worth looking at what happens in
the case where the timeout is long enough for multipathd to assemble
the device, and the case where it is not long enough.

When the timeout is long enough for multipathd to have enough time, your
proposed solution guarantees that you will always get Outcome 4 for
class 4B and Outcome 4 for class 4C.

When the timeout is not long enough, Your solution guarantees that you
will get outcome 3 for 4B devices, and either Outcome 1 or Outcome 3 for
4C devices.  However, there is a difference in the 4C case from the
current RedHat solution.  By claiming the path device until the timeout,
you keep the other users from being able to assemble on it, and you give
the addtional paths more time to appear. If your timeout isn't long
enough for multipathd to finish assembling the device, it's very likely
that multipathd is close to being finished to assembling the device.
This means that you make Outcome 3 more likely and Outcome 1 less
likely.

Now let me try to explain my proposed solution a little better than I
did last time. First the rationale. Class 4B and 4C devices are so much
rarer than class 4A devices, that it's not worth slowing down 4A
processing unless we absolutely need to, to avoid the worst case
outcomes for 4B and 4C. Also, for class 4B devices, Outcome 3 and
Outcome 4 are essentially identical to the user.  This means that the
only case where the current RedHat solution is not essentially optimal
is for class 4C devices. Outcome 4 for class 4C devices is what you
called "Nice-to-have", and that's how I feel about it as well. I'm
perfectly fine with Outcome 1 if that's all it takes to make the common
case work as well as possible. The only thing I want to avoid is Outcome
2 and 3. Outcome 2 we already avoid, and Outcome 3 is very rare.  But
by using timeouts, we can make it even rarer, without effecting the
processing of 4A devices at all.

My solution idea is basically a mirror of yours.

At a high level, your solution is:
When you see a "maybe" device, assume it's a "yes" and claim it so that
nothing else can use the device. Then, set a timeout for multipathd to
make use of the device. If that timeout passes, and multipathd hasn't
used the device, go back and unclaim the device so that it's in the
correct state. Then, if something else should use the device, it can.

At a high level, my solution is:
When you see a "maybe" device, assume it's a "no" and don't claim it.
Also, disallow multipathd from using the device. Then, set a timeout for
other things to make use of the device.  When that timeout passes,
mutipathd is no longer disallowed from using that device, so that if
mutipathd should use the device, it can. If multipathd uses the device,
go back and claim the device, so it's in the correct state.

The advantage of your method is that, as long as the timeout is long
enough, you always do the correct thing with multipath devices. The
disadvantage is that the timeout slows down the common case, to make the
rare case correct.

The advantage of my method is that it only slows down the rare case. The
disadvantage is that it will not get the "Nice-to-have" outcome in the
rare case.

I'm working on coding up my solution, which includes a number of the
patches from your solution, but I'm leaving tomorrow for a week of
meetings and conferences, so it might be a little bit it coming.

-Ben
