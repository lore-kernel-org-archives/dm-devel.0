From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [Bcache v13 01/16] Only clone bio vecs that are in use
Date: Thu, 10 May 2012 14:42:17 -0700
Message-ID: <CAH+dOxJ2Vi=8Oq1zDZLmqD9-a_wgM=co3+xemw4XBoiDkh_4zg@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
	<20120510213556.GO23768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120510213556.GO23768-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Oh, I never got around to figuring out what needed to be done with the
bio integrity - presumably it'll have to be handled differently
somehow (I'm assuming an index in the integrity bvec is intended to
match up with an index in the regular bvec), but I don't have any way
to test the integrity stuff.

2012/5/10 Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, May 09, 2012 at 11:08:13PM -0400, Kent Overstreet wrote:
>
> [..]
>> -
>> - =A0 =A0 if (bio_integrity(bio)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 bio_integrity_clone(clone, bio, GFP_NOIO, =
bs);
>> -
>> +#if 0
>> + =A0 =A0 if (bio_integrity(bio))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (idx !=3D bio->bi_idx || clone->bi_si=
ze < bio->bi_size)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_integrity_trim(clone=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0bio_sector_offset(bio, idx, 0), len);
>> - =A0 =A0 }
>> -
>> +#endif
>
> Dead/debug code under "#if 0" ?
>
> Thanks
> Vivek
