From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Fri, 14 Jan 2011 16:23:56 +0100
Message-ID: <AANLkTin2WjO4aRbB+x01YxDjKSHF1oc2sJi==f+C7c_s@mail.gmail.com>
References: <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
 <20110113155955.GI16523@nb.net.home> <AANLkTimXkF-JNaU12wLecdszMLZkfTh405tNabzEF4L_@mail.gmail.com>
 <20110114150736.GJ16523@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110114150736.GJ16523@nb.net.home>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Jan 14, 2011 at 16:07, Karel Zak <kzak@redhat.com> wrote:
> On Thu, Jan 13, 2011 at 05:10:02PM +0100, Kay Sievers wrote:
>> On Thu, Jan 13, 2011 at 16:59, Karel Zak <kzak@redhat.com> wrote:
>> > On Thu, Jan 13, 2011 at 03:43:38PM +0100, Kay Sievers wrote:
>> >> On Thu, Jan 13, 2011 at 15:30, Tejun Heo <tj@kernel.org> wrote:
>> >> > On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> =
wrote:
>> >> >> Maybe, but this was not invented in DM/MD camp:-)
>> >> >> Probably Kay or Greg can answer why it was done this way?
>> >>
>> >> It's not from Greg or Kay. It just appeared some day in the conte=
xt of dm. :)
>> >>
>> >> And yes, symlinks *look* nice and simple for the outside, but the=
y are
>> >> not, and have all sorts of problems like non-atomic updates, make=
 it
>> >
>> > =C2=A0Sounds like sysfs implementation problem, right?
>>
>> It's a normal multi-file problem. It can by-definition not be atomic
>> without doing really weird locking things.
>
> =C2=A0BTW, lsblk(8) and libblkid don't depend on the fact that slaves=
/holders
> =C2=A0files are symlinks.
>
> =C2=A0The important thing is the filename (/sys/block/.../slaves/<nam=
e>)
> =C2=A0only. We don't follow the symlinks and we don't use readlink() =
there.
>
> =C2=A0It means that you can replace the symlinks with regular files w=
here
> =C2=A0in the file contents is for example maj:min, etc.

I don't think we really can change anything here, there are more users =
of it.

If we would go changing things here, the file names should never be
the device name but the format "b8:32" for blockdevs, "n22" for the
network ifindex, ... which is the unchangeable unique kernel id -- not
depending on any possible device rename, or fast destroy/re-create or
anything like that.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
