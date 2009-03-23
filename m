From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Sun, 22 Mar 2009 21:42:03 -0700
Message-ID: <425CBF58-2039-455A-B7A4-9314AC1D6463@gmail.com>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (iPhone Mail 5H11)
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090322152730.GC5528@edu.joroinen.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, "Ross S. W. Walker" <rwalker@medallion.com>
List-Id: dm-devel.ids

On Mar 22, 2009, at 8:27, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> wrote:

> On Fri, Mar 20, 2009 at 06:01:23AM -0400, John A. Sullivan III wrote:
>>>
>>> John:
>>>
>>> Thanks for the reply.
>>>
>>> I ended up writing a small C program to do the priority =20
>>> computation for me.
>>>
>>> I have two sets of FC-AL shelves attached to two dual-channel Qlogic
>>> cards. That gives me two paths to each disk. I have about 56 =20
>>> spindles
>>> in the current configuration, and am tying them together with md
>>> software raid.
>>>
>>> Now, even though each disk says it handles concurrent I/O on each
>>> port, my testing indicates that throughput suffers when using =20
>>> multibus
>>> by about 1/2 (from ~60 MB/sec sustained I/O with failover to 35 MB/=20
>>> sec
>>> when using multibus).
>>>
>>> However, with failover, I am effectively using only one channel on
>>> each card. With my custom priority callout, I more or less match the
>>> disks with even numbers to the even numbered scsi channels with a
>>> higher priority. Same with the odd numbered disks and odd numbered
>>> channels. The odds are 2ndary on even and vice versa. It seems to =20
>>> work
>>> rather well, and appears to spread the load nicely.
>>>
>>> Thanks again for your help!
>>>
>> I'm really glad you brought up the performance problem. I had posted
>> about it a few days ago but it seems to have gotten lost.  We are =20
>> really
>> struggling with performance issues when attempting to combine =20
>> multiple
>> paths (in the case of multipath to one big target) or targets (in the
>> case of software RAID0 across several targets) rather than using, in
>> effect, JBODs.  In our case, we are using iSCSI.
>>
>> Like you, we found that using multibus caused almost a linear drop in
>> performance.  Round robin across two paths was half as much as =20
>> aggregate
>> throughput to two separate disks, four paths, one fourth.
>>
>> We also tried striping across the targets with software RAID0 =20
>> combined
>> with failover multipath - roughly the same effect.
>>
>> We really don't want to be forced to treated SAN attached disks as
>> JDOBs.  Has anyone cracked this problem of using them in either =20
>> multibus
>> or RAID0 so we can present them as a single device to the OS and =20
>> still
>> load balance multiple paths.  This is a HUGE problem for us so any =20
>> help
>> is greatly appreciated.  Thanks- John
>
> Hello.
>
> Hmm.. just a guess, but could this be related to the fact that if =20
> your paths
> to the storage are different iSCSI sessions (open-iscsi _doesn't_ =20
> support
> multiple connections per session aka MC/s), then there is a separate =20
> SCSI
> command queue per path.. and if SCSI requests are split across those =20
> queues
> they can get out-of-order and that causes performance drop?
>
> See:
> http://www.nabble.com/round-robin-with-vmware-initiator-and-iscsi-targe=
t-td21958346.html
>
> Especially the reply from Ross (CC). Maybe he has some comments :)
>
> -- Pasi
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

My problem with dm multipath multibus running at half the speed of =20
failover is not with iscsi but with some fibre channel disk shelves =20
I'm treating as a JBOD. I have two loops, and each FC drive is capable =20
of doing concurrent io through both ports.

I am exporting them via iscsi but the performance dropoff I'm seeing =20
is on the local host with the HBAs.

cc
