From: zhangxiao <xiao.zhang@windriver.com>
Subject: Re: The DM_BUFIO_HASH_BITS is defined as 20, any plan to make it
 flexible?
Date: Tue, 2 Dec 2014 16:40:37 +0800
Message-ID: <547D7B05.50406@windriver.com>
References: <547D790E.3070803@windriver.com> <20141202193618.6d3adb22@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141202193618.6d3adb22@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 2014=E5=B9=B412=E6=9C=8802=E6=97=A5 16:36, NeilBrown wrote:
> On Tue, 2 Dec 2014 16:32:14 +0800 zhangxiao <xiao.zhang@windriver.com=
> wrote:
>
>> Hi NeilBrown,
>>
>> See drivers/md/dm-bufio.c as below:
>>     50 /*
>>     51  * Buffer hash
>>     52  */
>>     53 #define DM_BUFIO_HASH_BITS      20
>>     54 #define DM_BUFIO_HASH(block) \
>>     55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
>>     56          ((1 << DM_BUFIO_HASH_BITS) - 1))
>> "drivers/md/dm-bufio.c" 1854L, 45375C
>>
>>
>> DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
>> use case with limited resources. Do we have any plan to make it more
>> flexible? Like module parameter or something else?
>>
>
> Thanks, but this question should be address to:
>
Thank you for your kindly remind. :-)

Regards
Xiao

> DEVICE-MAPPER  (LVM)
> M:	Alasdair Kergon <agk@redhat.com>
> M:	Mike Snitzer <snitzer@redhat.com>
> M:	dm-devel@redhat.com
> L:	dm-devel@redhat.com
> W:	http://sources.redhat.com/dm
> Q:	http://patchwork.kernel.org/project/dm-devel/list/
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/li=
nux-dm.git
> T:	quilt http://people.redhat.com/agk/patches/linux/editing/
> S:	Maintained
> F:	Documentation/device-mapper/
> F:	drivers/md/dm*
> F:	drivers/md/persistent-data/
> F:	include/linux/device-mapper.h
> F:	include/linux/dm-*.h
> F:	include/uapi/linux/dm-*.h
>
> NeilBrown
>
