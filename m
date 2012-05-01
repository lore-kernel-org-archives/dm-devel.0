From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 1/2] dm: update max_io_len to support a
	split_io that is not a power of 2
Date: Tue, 1 May 2012 10:42:50 -0500
Message-ID: <148700D3-0A6D-4BAC-B5A3-9F3FD878B2DC@redhat.com>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
	<20120430161043.GB8713@agk-dp.fab.redhat.com>
	<20120430172359.GA19033@redhat.com>
	<20120430183606.GC8713@agk-dp.fab.redhat.com>
	<20120430185952.GA19638@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/mixed; boundary="===============6486627796178438371=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120430185952.GA19638@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


--===============6486627796178438371==
Content-Type: multipart/alternative; boundary=Apple-Mail-1--1049998192


--Apple-Mail-1--1049998192
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Apr 30, 2012, at 1:59 PM, Mike Snitzer wrote:

>>>=20
>>> I cannot see why we'd need a split_io that is larger than 32 bits -- =
a
>>> 32bit split_io can support up to 2TB (2**32 * 512b sectors).  Even
>>> on a LBD (raid) the stripe size (split_io) will not be so large.
>>=20
>> But is that enforced in the raid code or not?
>=20
> No idea, need Jon to weigh in here.  I'm hopeful we can impose 32bit
> within dm-raid and coordinate with Neil on getting the appropriate MD
> code (chunk_sectors) to reflect the reality that 32 bit is adequate.
>=20
>>> But what I think what you're driving at is:=20
>>=20
>> (I'm not convinced the proposed patch has been tested on 32-bit+LBD,
>> attempting to divide by a 64-bit number etc.)
>=20
> Right, it wasn't tested on 32bit.  It'll fail to build due to split_io
> being sector_t.
>=20
>>> is there a benefit/reason to
>>> maintain the old code for some target that won't ever use non power =
of 2
>>> split_io (e.g. dm-raid at the moment)?  I see no point for the =
duality
>>> in the code but I'm open to the idea if you have a specific reason =
in
>>> mind -- are you concerned about perf on more obscure/older hardware?
>>=20
>> EITHER the 32 bit split_io *must* be enforced (after we've convinced
>> ourselves 64 bits will never be required);
>> OR we keep it 64-bit and add some compat code.
>=20
> Yeap, I'm hopeful we can go with the former.
>=20
> Jon, what do you think?

split_io is used by dm-raid to split I/O on 'region_size' and =
'chunk_size' boundaries.  The former is used for bitmap purposes for the =
write intent log (RAID 1/4/5/6).  The later is used by striping targets =
(RAID 4/5/6).  There are some sanity checks.  They must  be power of 2, =
region_size must be larger than 'chunk_size', etc.  However, I don't see =
any enforcement on the size of those numbers.  There probably should be, =
given that 'chunk_sectors'/'stripe_sectors' are 32-bit 'int' types.  =
Additionally, 'chunksize' (the name given for 'region_size' in MD) is a =
32-bit type on disk and 'unsigned long' in memory - with no checking for =
size when the in-memory version is stored on disk.

I think these checks should probably be added, but there would be a =
limitation on the size of arrays imposed, I think.  Neil mentioned that =
the maximum size of a bitmap was (1 << 21) bits.  If the max =
'region_size' is (1 << 32), then the max size device is (1 << 21) * (1 =
<< 32) * (1 << 9) =3D 4 EiB.  I don't think that's a problem.

 brassow


--Apple-Mail-1--1049998192
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On Apr 30, 2012, at 1:59 PM, Mike Snitzer =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><span class=3D"Apple-style-span" style=3D"border-collapse: =
separate; font-family: Helvetica; font-style: normal; font-variant: =
normal; font-weight: normal; letter-spacing: normal; line-height: =
normal; orphans: 2; text-align: -webkit-auto; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; =
"><div><blockquote type=3D"cite"><blockquote type=3D"cite"><br =
class=3D"Apple-interchange-newline">I cannot see why we'd need a =
split_io that is larger than 32 bits -- =
a<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">32bit split_io can support up to 2TB (2**32 * 512b =
sectors). &nbsp;Even<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">on a LBD (raid) the stripe size =
(split_io) will not be so =
large.<br></blockquote></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">But is that =
enforced in the raid code or not?<br></blockquote><br>No idea, need Jon =
to weigh in here. &nbsp;I'm hopeful we can impose 32bit<br>within =
dm-raid and coordinate with Neil on getting the appropriate MD<br>code =
(chunk_sectors) to reflect the reality that 32 bit is =
adequate.<br><br><blockquote type=3D"cite"><blockquote type=3D"cite">But =
what I think what you're driving at is:<span =
class=3D"Apple-converted-space">&nbsp;</span><br></blockquote></blockquote=
><blockquote type=3D"cite"><br></blockquote><blockquote type=3D"cite">(I'm=
 not convinced the proposed patch has been tested on =
32-bit+LBD,<br></blockquote><blockquote type=3D"cite">attempting to =
divide by a 64-bit number etc.)<br></blockquote><br>Right, it wasn't =
tested on 32bit. &nbsp;It'll fail to build due to split_io<br>being =
sector_t.<br><br><blockquote type=3D"cite"><blockquote type=3D"cite">is =
there a benefit/reason to<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">maintain the old code for some =
target that won't ever use non power of =
2<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">split_io (e.g. dm-raid at the moment)? &nbsp;I see no =
point for the duality<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">in the code but I'm open to the =
idea if you have a specific reason =
in<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">mind -- are you concerned about perf on more obscure/older =
hardware?<br></blockquote></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">EITHER the 32 =
bit split_io *must* be enforced (after we've =
convinced<br></blockquote><blockquote type=3D"cite">ourselves 64 bits =
will never be required);<br></blockquote><blockquote type=3D"cite">OR we =
keep it 64-bit and add some compat code.<br></blockquote><br>Yeap, I'm =
hopeful we can go with the former.<br><br>Jon, what do you =
think?</div></span></blockquote><br></div><div>split_io is used by =
dm-raid to split I/O on 'region_size' and 'chunk_size' boundaries. =
&nbsp;The former is used for bitmap purposes for the write intent log =
(RAID 1/4/5/6). &nbsp;The later is used by striping targets (RAID =
4/5/6). &nbsp;There are some sanity checks. &nbsp;They must &nbsp;be =
power of 2, region_size must be larger than 'chunk_size', etc. =
&nbsp;However, I don't see any enforcement on the size of those numbers. =
&nbsp;There probably should be, given that =
'chunk_sectors'/'stripe_sectors' are 32-bit 'int' types. =
&nbsp;Additionally, 'chunksize' (the name given for 'region_size' in MD) =
is a 32-bit type on disk and 'unsigned long' in memory - with no =
checking for size when the in-memory version is stored on =
disk.</div><div><br></div><div>I think these checks should probably be =
added, but there would be a limitation on the size of arrays imposed, I =
think. &nbsp;Neil mentioned that the maximum size of a bitmap was (1 =
&lt;&lt; 21) bits. &nbsp;If the max 'region_size' is (1 &lt;&lt; 32), =
then the max size device is (1 &lt;&lt; 21) * (1 &lt;&lt; 32) * (1 =
&lt;&lt; 9) =3D 4 EiB. &nbsp;I don't think that's a =
problem.</div><div><br></div><div>&nbsp;brassow</div><div><br></div></body=
></html>=

--Apple-Mail-1--1049998192--


--===============6486627796178438371==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6486627796178438371==--
