From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2] blk: improve order of bio handling in
	generic_make_request()
Date: Sat, 11 Mar 2017 11:47:56 +1100
Message-ID: <87shmkfxkz.fsf@notabene.neil.brown.name>
References: <87h93blz6g.fsf@notabene.neil.brown.name>
	<71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com>
	<87lgsjj9w8.fsf@notabene.neil.brown.name>
	<a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk>
	<87r328j00i.fsf@notabene.neil.brown.name>
	<87d1dphhuy.fsf@notabene.neil.brown.name>
	<58be6551-4aa7-72ee-1616-a1545606d029@kernel.dk>
	<87varhg14d.fsf@notabene.neil.brown.name>
	<CANr6vz8EbRWXq7igGCzRy9JC1Nt=MMma0h8M6nxHQtwiMDa5aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3756041316313884675=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANr6vz8EbRWXq7igGCzRy9JC1Nt=MMma0h8M6nxHQtwiMDa5aQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

--===============3756041316313884675==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

On Fri, Mar 10 2017, Lars Ellenberg wrote:

>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1975,7 +1975,14 @@ generic_make_request_checks(struct bio *bio)
>>   */
>>  blk_qc_t generic_make_request(struct bio *bio)
>>  {
>> -       struct bio_list bio_list_on_stack;
>> +       /*
>> +        * bio_list_on_stack[0] contains bios submitted by the current
>> +        * make_request_fn.
>> +        * bio_list_on_stack[1] contains bios that were submitted before
>> +        * the current make_request_fn, but that haven't been processed
>> +        * yet.
>> +        */
>> +       struct bio_list bio_list_on_stack[2];
>>         blk_qc_t ret = BLK_QC_T_NONE;
>
> May I suggest that, if you intend to assign something that is not a
> plain &(struct bio_list), but a &(struct bio_list[2]),
> you change the task member so it is renamed (current->bio_list vs
> current->bio_lists, plural, is what I did last year).
> Or you will break external modules, silently, and horribly (or,
> rather, they won't notice, but break the kernel).
> Examples of such modules would be DRBD, ZFS, quite possibly others.
>

This is exactly what I didn't in my first draft (bio_list -> bio_lists),
but then I reverted that change because it didn't seem to be worth the
noise.
It isn't much noise, sched.h, bcache/btree.c, md/dm-bufio.c, and
md/raid1.c get minor changes.
But as I'm hoping to get rid of all of those uses, renaming before
removing seemed pointless ... though admittedly that is what I did for
bioset_create().... I wondered about that too.

The example you give later:
	struct bio_list *tmp = current->bio_list;
	current->bio_list = NULL;
	submit_bio()
	current->bio_list = tmp;

won't cause any problem.  Whatever lists the parent generic_make_request
is holding onto will be untouched during the submit_bio() call, and will
be exactly as it expects them when this caller returns.

If some out-of-tree code does anything with ->bio_list that makes sense
with the previous code, then it will still make sense with the new
code. However there will be a few bios that it didn't get too look at.
These will all be bios that were submitted by a device further up the
stack (closer to the filesystem), so they *should* be irrelevant.
I could probably come up with some weird behaviour that might have
worked before but now wouldn't quite work the same way.  But just fixing
bugs can sometimes affect an out-of-tree driver in a strange way because
it was assuming those bugs.

I hope that I'll soon be able to remove punt_bios_to_rescuer and
flush_current_bio_list, after which current->bio_list  can really be
just a list again.  I don't think it is worth changing the name for a
transient situation.

But thanks for the review - it encouraged me to think though the
consequences again and I'm now more confident.
I actually now think that change probably wasn't necessary.  It is
safer though.  It ensures that current functionality isn't removed
without a clear justification.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljDST0ACgkQOeye3VZi
gbnqNRAAjFtXFzd/Bu+z85h3s2hXEZROkDKXsty0fgRGP1+dsGHrZIhouBiqWmqB
spX/Ij+ccbFYOwBWjFM12yz2eWGRqrqyrIPpbh0/T7jNVT5eeD76kmBRdmv2jbl5
1AMa/K5LS4BWhPsxzXOPMTPsV6K3CtoVs9cRmqh8phiWnjqqWhec9PkU/j1B1XBs
oHQDi+QzMe775U8s0hOK8UtxRyb+Do1RlSWr6hW8PfZjybpG3973j5PsvzmDsAYE
cGpirb+IeOlSa9O4Br3pdGIp7P3nJ6EPlkMrl1vLEmDbMzUjNAf+wvq/oppjamAN
FdCF8wa2ydFCaEfiZ5SMnaNtOgnafinn3XzIQuykpQjadvWct63NVy8a96yVm9MN
kfDRyKrTzQfct2Sr91k/u6va58OkpW6GV3ylq6j1bMKCNHOueHJzMc6A9Q5EhQe3
/s0FLc1bW78tRSH2zKhWaaM4N0Lm2bI4WcIFI8jsIP6S2DC8pnVyvricvQ9DAArw
gxG8Wu1FwQljN5bGlnzn/gYWOAQsJ2jhpFs8edHA4hnqUyBv6UdoJ0qxeMIhw7P8
WFjNDRjJ9u/B7RAUBBWs2Z2ACDwIeRko7Zo3NitjRzv70EHUOx5Qc9P8qktj+tmt
T/VoKXloIVG4WIX3+r5v3pFJPmzboW88Y/4cuUmr0uM5gERj3Ho=
=3pLX
-----END PGP SIGNATURE-----
--=-=-=--


--===============3756041316313884675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3756041316313884675==--
