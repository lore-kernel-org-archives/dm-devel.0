From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: fix bug due to nested suspend
Date: Thu, 17 Dec 2015 15:09:51 +1100
Message-ID: <87vb7x90mo.fsf@notabene.neil.brown.name>
References: <alpine.LRH.2.02.1511251216100.17579@file01.intranet.prod.int.rdu2.redhat.com>
	<87vb7z9hbm.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1512160900160.754@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7199843204192676308=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1512160900160.754@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Heinz Mauelshagen <heinzm@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Marian Csontos <mcsontos@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============7199843204192676308==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 17 2015, Mikulas Patocka wrote:

> On Wed, 16 Dec 2015, NeilBrown wrote:
>
>> On Thu, Nov 26 2015, Mikulas Patocka wrote:
>>=20
>> > The patch c7bfced9a6716ff66c9d61f934bb60af08d4688c committed to 4.4-rc=
=20
>> > causes crash in LVM test shell/lvchange-raid.sh. The kernel crashes wi=
th=20
>> > this BUG, the reason is that we attempt to suspend a device that is=20
>> > already suspended. See also=20
>> > https://bugzilla.redhat.com/show_bug.cgi?id=3D1283491
>> >
>> > This patch fixes the bug by introducing functions mddev_nested_suspend=
 and
>> > mddev_nested_resume that can be called when the device is already
>> > suspended. The number of calls to mddev_nested_suspend is kept in the
>> > variable mddev->suspended.
>>=20
>> Hi,
>>  thanks for the report and patch.
>>=20
>> I think I would rather just make mddev_suspend() always nest.
>> It is always called under ->reconfig_mutex or some similar guarentee of
>> being single-threaded in dm-raid, so we don't need an atomic_t.
>>=20
>> Just
>>   mddev_suspend()
>> 	if (mddev->suspended++)
>>         	return;
>>         ...do the suspend.
>>=20
>> and
>>   mddev_resume()
>>        if (--mddev->suspended)
>>        		return;
>>        ... to the resume
>>=20
>> Does that seem reasonable to you?
>
> Yes, it seems OK.
>
> Mikulas

Thanks.  I've revised your original patch to behave as above and will
send to Linus today or tomorrow.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcjWPAAoJEDnsnt1WYoG56+gP/3L+KB9ge9/fy0icGZJQc9iY
iOIlmzhXxdO+7F3oONRdumDMvd1QfTvBt+1IV3GmagUyPoX4tuxdGs1rIaR9AqN+
g0+v2mqo6zbZYLEsgYuKl4yphauV4oPUbOJ3w8qHRYERzoBTTf+Y/0R9R4IoX/bl
Vu0weVJgmtmHvLpegjvUcHQZQNsyBhEoG0MKWzu71T6UMoa1YHCr4LXeT33kdU7q
NZ3RHEgbdiWuxHLKROEJOHH0l/GXqslFJcdtx8HTpnWopMOiSzE9j7wojmL71mlF
xn6thlXDr9RW+yOCLozE/6C2ZXQS1GYGNF+6W50Qqq7bBLFbnruBiYdfulI1ZbuE
5ZRKUeaZxQGWIDFWHxw6cElMLCSo8MO9IVOp42IQTdKKTX2XlaOoMvspMCZTnhUY
YviTEwTgQRqgJnergAMytgSMs84Yj0TryNxmNj9MygFEOmDFBS8kEYUnSwIdiNQV
SJtNa6qNKleD88nf/ye4CeBfkFHLkjeF9qZn7iWw+aaqvcSye370JmypfeflDNF8
nIchpS8ajMwcnIJn/mzXwVdBg3xw/5B3bY9TPkH0IPcyd2pUxt6Sc9ikSMKFESh6
qQT8zE9B7rq1pnxaI6hKHyp9ODw1EjvaHpIQkQCXBTcy4hFyZ1mdmWS5v1GwB8wu
GC0k/ljNxIG5b845NeWS
=0S/x
-----END PGP SIGNATURE-----
--=-=-=--


--===============7199843204192676308==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7199843204192676308==--
