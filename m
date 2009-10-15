From: "NeilBrown" <neilb@suse.de>
Subject: Re: Bug on barriers for virtio_blk device - end_request:
 I/O error, dev vda, sector 0
Date: Thu, 15 Oct 2009 22:12:05 +1100
Message-ID: <9a9a41fd6c04a891d8b3c4279903edd9.squirrel@neil.brown.name>
References: <4AD5DC1D.9070002@navynet.it> <4AD5DC1D.9070002@navynet.it>1 2
	<4AD62690.9080408@navynet.it> <200910142232.14837.elendil@planet.nl>
	<4AD6FF9B.6060109@navynet.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AD6FF9B.6060109@navynet.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Massimo Cetra <mcetra@navynet.it>
Cc: Mark McLoughlin <markmc@redhat.com>, Frans Pop <elendil@planet.nl>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, virtualization <virtualization@lists.linux-foundation.org>, dm-devel <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, October 15, 2009 9:55 pm, Massimo Cetra wrote:
> Frans Pop ha scritto:
>> Added CCs for the author of and people CCed on the patch.
>>
>> The patch has been submitted twice (6 Aug, 3 Sept), the first time the=
re
>> was one concern voiced which seems to have been addressed in replies.
>> The
>> second time there were no reactions.
>>
>> The patch seems to work for Massimo...
>
> [CUT]
>
>>> No one listening here ?
>>
>> It helps if you CC the people who maintain the relevant code.
>
> Thanks, Frans.
>
> By the way, where can i find a list of the mantainers of the various ar=
eas
> ?
> I found it some years ago, but it seems i can't find it anymore.
> It's probably under my eyes... but i'm blind.

See http://lwn.net/Articles/356890/
     "Ask a kernel developer, part 2"
(you'll have to wait a week if you aren't a subscriber).

(or try ./scripts/get_maintainer.pl)

NeilBrown

>
> Thanks again
> Massimo
>
