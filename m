From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Thu, 19 Mar 2009 22:11:28 -0700
Message-ID: <7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
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

On Thu, Mar 19, 2009 at 4:04 AM, John A. Sullivan III
<jsullivan@opensourcedevel.com> wrote:
> On Wed, 2009-03-18 at 15:57 -0700, Christopher Chen wrote:
>> Hello, running Centos 5.2 here--
>>
>> The multipathd daemon is very unhappy with any arbritrary script I
>> provide for determining priorities. I see some fuzz in the syslog
>> about ramfs and static binaries.
>>
>> How do I use shell scripts or arbitrary programs for multipathd? I
>> compiled a simple program that spits out "1" and it seems to return
>> appropriately.
>>
>> Also, why does multipath -ll return the appropriate data, namely
>> prio=3D1 (when using my custom statically compiled callout) and
>> multipath -l always returns prio=3D0? Is this an indication of a broke=
n
>> configuration or something else?
>>
>> Cheers
>>
>> cc
>>
> I had the exact same problem and someone kindly explained it on this
> list so thanks to them.
>
> If I understand it correctly, multipathd must be prepared to function i=
f
> it loses access to disk. =A0Therefore, it is designed to not read from
> disk but caches everything it needs in memory. =A0Apparently, it can on=
ly
> cache binaries.
>
> To use a shell script, call it via the shell, i.e., rather than
> shell.script call sh shell.script.
>
> That worked perfectly fine for me. =A0However, I do not know if multipa=
thd
> actually caches shell.script or if it still must read it from disk when
> invoking sh and hence remains vulnerable to loss of disk access. =A0Doe=
s
> anyone know? Thanks - John

John:

Thanks for the reply.

I ended up writing a small C program to do the priority computation for m=
e.

I have two sets of FC-AL shelves attached to two dual-channel Qlogic
cards. That gives me two paths to each disk. I have about 56 spindles
in the current configuration, and am tying them together with md
software raid.

Now, even though each disk says it handles concurrent I/O on each
port, my testing indicates that throughput suffers when using multibus
by about 1/2 (from ~60 MB/sec sustained I/O with failover to 35 MB/sec
when using multibus).

However, with failover, I am effectively using only one channel on
each card. With my custom priority callout, I more or less match the
disks with even numbers to the even numbered scsi channels with a
higher priority. Same with the odd numbered disks and odd numbered
channels. The odds are 2ndary on even and vice versa. It seems to work
rather well, and appears to spread the load nicely.

Thanks again for your help!

--=20
Chris Chen <muffaleta@gmail.com>
"I want the kind of six pack you can't drink."
-- Micah
