From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Fri, 14 Jan 2011 16:38:05 +0900
Message-ID: <4D2FFD5D.9070709@ce.jp.nec.com>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org> <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com> <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com> <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com> <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com> <4D2F1430.50906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2F1430.50906@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>
Cc: Karel Zak <kzak@redhat.com>, device-mapper development <dm-devel@redhat.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On 01/14/11 00:03, Milan Broz wrote:
> On 01/13/2011 03:43 PM, Kay Sievers wrote:
> 
>>> On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
>>>> Maybe, but this was not invented in DM/MD camp:-)
>>>> Probably Kay or Greg can answer why it was done this way?
>>
>> It's not from Greg or Kay. It just appeared some day in the context of dm. :)
> 
> ah, then sorry, I am just confused:-)
> But DM does not need it for operation at all so it must had some other reason.
> (We have dmsetup ls --tree using dm-ioctls for years.)

Sorry. It's from me 5 years ago. :)

See this for backgrounds:
  [PATCH 0/3] sysfs representation of stacked devices (dm/md)
  http://lwn.net/Articles/172689/

And I don't adhere to my implementation if there's better one.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
