From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath: Path checks on open-iscsi software
	initiators
Date: Fri, 19 Feb 2010 13:23:05 +0100
Message-ID: <4B7E82A9.9050301@suse.de>
References: <1265678289.2221.162.camel@agari.van.xensource.com>	<170fa0d21002082045t5ea45011x25c98fd808758e8@mail.gmail.com>
	<1265692613.2221.459.camel@agari.van.xensource.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1265692613.2221.459.camel@agari.van.xensource.com>
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
List-Id: dm-devel.ids

Daniel Stodden wrote:
> On Mon, 2010-02-08 at 23:45 -0500, Mike Snitzer wrote:
>> On Mon, Feb 8, 2010 at 8:18 PM, Daniel Stodden
>> <daniel.stodden@citrix.com> wrote:
>>> Hi.
>>>
>>> I've recently been spending some time tracing path checks on iSCSI
>>> targets.
>>>
>>> Samples described here were taken with the directio checker on a netapp
>>> lun, but I believe the target kind doesn't matter here, since most of
>>> what I find is rather driven by the initiator side.
>>>
>>> So what I see is:
>>>
>>> 1. The directio checker issues its aio read on sector0.
>>>
>>> 2. The request obviously will block until iscsi is giving up on it.
>>>  This typically happens not before target pings (noop-out ops)
>>>  issued internally by the initiator time out. Look like:
>>>
>>>  iscsid: Nop-out timedout after 15 seconds on connection 1:0
>>>  state (3). Dropping session.
>>>
>>>  (period and timeouts depend on the configuration at hand).
>>>
>>> 3. Session failure still won't unblock the read. This is because the
>>>  iscsi session will enter recovery mode, to avoid failing the
>>>  data path right away. The device will enter blocked state during
>>>  that period.
>>>
>>>  Since I'm provoking a complete failure, this will time out as well,
>>>  but only later:
>>>
>>>  iscsi: session recovery timed out after 15 secs
>>>
>>>  (again, timeouts are iscsid.conf-dependent)
>>>
>>> 4. This will finally unblock the directio check with EIO,
>>>   triggering the path failure.
>>>
>>>
>>> My main issue is that a device sitting on a software iscsi initiator
>>>
>>>  a) performs its own path failure detection and
>>>  b) defers data path operations to mask failures,
>>>    which obviously counteracts a checker based on
>>>    data path operations.
>>>
>>> Kernels somewhere during the 2.6.2x series apparently started to move
>>> part of the session checks into the kernel (apparently including the
>>> noop-out itself, but I don't). One side effect of that is that session
>>> state can be queried via sysfs.
>>>
>>> So right now I'm mainly wondering if a multipath failure driven rather
>>> by polling session state that a data read wouldn't be more effective?
>>>
>>> I've only been browsing part of the iscsi code by now, but I don't see
>>> how data path failures wouldn't relate to session state.
>>>
>>> There's some code attached below to demonstrate that. It presently jumps
>>> through some extra loops to reverse-map fd back to the block device
>>> node, but the basic thing was relatively straightforward to implement.
>>>
>>> Thanks in advance for about any input on that matter.
>>>
>>> Cheers,
>>> Daniel
>>>
>> You might look at the multipath-tools patch included in a fairly
>> recent dm-devel mail titled "[PATCH] Update path_offline() to return
>> device status"
>>
>> The committed patch is available here:
>> http://git.kernel.org/gitweb.cgi?p=3Dlinux/storage/multipath-tools/.git;=
a=3Dcommit;h=3D88c75172cf56e
> =

> Hi Mike.
> =

> Thanks very much for the link.
> =

> I think this stuff is going into the right direction, but judging from =

> the present implementation of path_offline(), =

> =

> http://git.kernel.org/gitweb.cgi?p=3Dlinux/storage/multipath-tools/.git;a=
=3Dblob;f=3Dlibmultipath/discovery.c;h=3D6b99d07452ed6a0e9bc4aaa91f74fda544=
5ed1cc;hb=3DHEAD#l581
> =

> this behavior still matches item 3 described above, or am I mistaken?
> =

> The scsi device will be blocked after the iscsi session already failed.
> =

> My understanding is that this is perfectly intentional -- the initiator
> will block the device while trying to recover the session.
> =

> Which, as even described in the patch, makes the check transition to
> pending in the meantime. The path is, however, already broken.
> =

> So to summarize: What I'm asking about is if path checks based on
> datapath ops aren't rather ineffective if the underlying transport tries
> to mask datapath failures.
> =

Not inefficient as such (provided there is a timeout attached to the checks=
);
only that these tests wouldn't be able to give you any meaningful
information if the timeout occurs.

So the best you can say in these cases is "don't know, try later", for which
the 'pending' state is used in multipath.
And then you'd need another timeout in multipathing after which the 'pendin=
g'
state is interpreted as a failure, as the 'pending' state doesn't have any
information about the expected duration. IE the 'pending' state might indeed
be a permanent state.

So you have three timeouts to deal with:
- path checker issue timeout:
  how long should I wait for the path checker call to return; currently
  hardcoded to 5 nsecs.
- path checker duration timeout:
  how long should I wait for the path checker to complete; currently
  hardcoded to ASYNC_TIMEOUT_SEC.
- pending state duration timeout:
  how long should might a path remain in 'pending' before it is considered
  an error.

If all these timeouts are used and set correctly multipath is able to run
transport-agnostic, ie even a masking of the underlying datapath failures
will be handled properly.
Currently only the 'directio' checker is capable of distinguishing between
the first two timeouts, so that would be the checker of choice here.


I'll have some patches to modify the 'tur' checker also to run asynchronous=
ly,
but I'm not sure if that's the correct way here.
I'd rather prefer to have the 'sg' interface to be capable of using async_io
here. Have to poke Doug Gilbert about it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
