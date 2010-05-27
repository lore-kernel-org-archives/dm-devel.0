From: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH v3 2/3] init: boot to device-mapper targets
	without an initr*
Date: Thu, 27 May 2010 06:13:42 -0700
Message-ID: <AANLkTikPMpIdMEgCNqoaIuG02aUWvTgzH2OWIvGnAlaB@mail.gmail.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
	<1274294304-30606-2-git-send-email-wad@chromium.org>
	<E14718F3-E489-4921-8A5D-FAFCF2C8F8FA@cs.tu-berlin.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E14718F3-E489-4921-8A5D-FAFCF2C8F8FA@cs.tu-berlin.de>
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
Cc: Anselm Busse <abusse@cs.tu-berlin.de>
List-Id: dm-devel.ids

On Thu, May 27, 2010 at 12:38 AM, Anselm Busse <abusse@cs.tu-berlin.de> wro=
te:
>> An example dm-linear root with no uuid may look like:
>>
>> root=3D/dev/dm-0 =A0dm=3D"lroot none 0, 0 4096 linear /dev/ubdb 0, 4096 =
4096 linear /dv/ubdc 0"
>>
>> Once udev is started, /dev/dm-0 will become /dev/mapper/lroot.
>
> Hi,
>
> I'm having the problem that the device - for example - won't come availab=
le at "/dev/mapper/lroot" but at "/dev/mapper/lroot ". There is an addition=
al space at the end of the name, which is...lets say not so good. The probl=
em is exists already in the dm_setup_args.name field, so I think is a probl=
em parsing the arguments.
>
> I'm new around here, so I don't know how things work. Should I look into =
the problem myself and post a fix, or will the author of the patch?

Hi Anselm!

I'm new around here too :) There is an off-by-one where it calls
strlcpy(..., len + 1).  I have a new patch to post but have been
traveling and haven't had a chance to get it posted.  I'll try to mail
it out today!

I think that since I have posted the patch but it hasn't yet been
picked up, the best thing (for me) was just to mail the list like you
did and let the author (me) know there is an issue in the patch, and
then see if they are responsive before posting your own patch.  But
maybe someone who isn't new here should respond :)

Needless to say, I'll post a new patch soon.  The fix is:

+       strlcpy(dm_setup_args.name, str, len + 1);  /* includes nul */
becomes
+       strlcpy(dm_setup_args.name, str, len);  /* includes nul */
because I've already incremented len in the previous line.

cheers!
will
