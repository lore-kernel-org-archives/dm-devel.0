From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 15:43:38 +0100
Message-ID: <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org>
 <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com> <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Milan Broz <mbroz@redhat.com>, Karel Zak <kzak@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 13, 2011 at 15:30, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
>> Maybe, but this was not invented in DM/MD camp:-)
>> Probably Kay or Greg can answer why it was done this way?

It's not from Greg or Kay. It just appeared some day in the context of =
dm. :)

And yes, symlinks *look* nice and simple for the outside, but they are
not, and have all sorts of problems like non-atomic updates, make it
impossible to ever rename a device (as long as they copy the device
name), and and and .... we should not add more of this.

>> If btrfs internally creates some virtual _block_ device for its pool=
, it should
>> present it here too with slaves/holders. If not, why it should creat=
e any links there?
>
> Yeah, that's the most bothering part for me. =C2=A0The biggest custom=
ers of
> bd_claim are filesystems and all these custom symlinkeries don't do
> nothing for them. =C2=A0It just doesn't make a whole lot of sense to =
me.

Btrfs does not use any blockdev as the master for good reason, and it
can never map its slaves inside of /sys/block. Simple meta-blockdevs
like md/dm just don't fit into modern requirements of a filesystem
(directory snapshots, directory subvolumes, complex raids, hassle-free
resizing, ...)  -- hence btrfs is much more like a network-filesystem
mount than a stream of blocks like a disk, and does not fit at all
into this model.

Kay
