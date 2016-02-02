From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: WANTED new maintainer for Linux/md (and mdadm)
Date: Tue, 02 Feb 2016 07:19:58 -0500
Message-ID: <wrfjoabz1ez5.fsf@redhat.com>
References: <87k2o849j5.fsf@notabene.neil.brown.name>
	<569F4505.6060308@intel.com> <87powo2ber.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87powo2ber.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Wed, 27 Jan 2016 10:01:16 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

NeilBrown <neilb@suse.com> writes:
> On Wed, Jan 20 2016, Artur Paszkiewicz wrote:
>>
>> Hi Neil,
>>
>> Thank you for your work and time spent on maintaining MD/mdadm. I would also
>> like to offer help for the emerging maintainership team. I've been
>> working with
>> MD RAID for more than 4 years, mostly testing and developing the IMSM-related
>> parts on behalf of my employer - Intel. I realize that I was not very visible
>> on this mailing list, but I think I have a pretty good knowledge about mdadm
>> and the MD drivers. Now I have Intel's approval to take on maintaining MD RAID
>> as part of my job, not focusing primarily on IMSM. I definitely feel more
>> confident with maintaining mdadm, but I would certainly like to learn more
>> about the kernel MD stack and help with it as much as I can.
>
> Hi Arthur,
>  thanks for all your IMSM work over the years!  It is great that you can
>  continue contributing and do so more broadly.
>
>  For the moment Jes Serensen will be co-ordinating mdadm (once I make a
>  release ... tomorrow?) and Shaohua Li will be looking after the
>  kernel/md side.  I'm sure there is plenty of room for you too though.
>  Only one person (at a time) can queue patches, but several can
>  collaborate at development and support and bug fixing and testing and
>  ....
>  I suggest you find ways to co-ordinate with them.
>
>  This:
>      https://bugzilla.kernel.org/show_bug.cgi?id=108741
>  is currently most important in my mind, but there are other things to
>  do.

Hi Arthur,

I have setup a git repository for mdadm here:
git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git

I'll be relying heavily on your contributions in managing this now that
Neil is leaving it to us. I'll do my best to maintain it in a similar
manner to Neil, albeit I am probably going to screw up a lot more often.

Please fire away those patches and do not be afraid to yell at me if I
get something wrong!

Cheers,
Jes
