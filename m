From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 17:10:02 +0100
Message-ID: <AANLkTimXkF-JNaU12wLecdszMLZkfTh405tNabzEF4L_@mail.gmail.com>
References: <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com> <20110113155955.GI16523@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110113155955.GI16523@nb.net.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 13, 2011 at 16:59, Karel Zak <kzak@redhat.com> wrote:
> On Thu, Jan 13, 2011 at 03:43:38PM +0100, Kay Sievers wrote:
>> On Thu, Jan 13, 2011 at 15:30, Tejun Heo <tj@kernel.org> wrote:
>> > On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wro=
te:
>> >> Maybe, but this was not invented in DM/MD camp:-)
>> >> Probably Kay or Greg can answer why it was done this way?
>>
>> It's not from Greg or Kay. It just appeared some day in the context =
of dm. :)
>>
>> And yes, symlinks *look* nice and simple for the outside, but they a=
re
>> not, and have all sorts of problems like non-atomic updates, make it
>
> =C2=A0Sounds like sysfs implementation problem, right?

It's a normal multi-file problem. It can by-definition not be atomic
without doing really weird locking things.

> =C2=A0If there is noway to fix sysfs then we can add a generic ioctl =
or
> =C2=A0/sys/block/<device>/{slave,holder}_list files with list of
> =C2=A0holders/slaves.

Yeah, we've been there with the btrfs problem. For btrfs it woud
probably need to be something statfs()-like.

> =C2=A0But please, don't force userspace to use *claimer-specific*
> =C2=A0methods to answer *generic questions* like slave/holder depende=
ncies
> =C2=A0between devices.

The links exist only for dm and md so far, I think. It's the classical
multiple-parents-in-a-tree problem. We have that for bonded network
devices and some IO buses too. There is no nice representation for
these reversed-trees-in-the-tree so far.

Kay
