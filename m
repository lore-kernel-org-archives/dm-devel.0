From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: Add del_timer_sync to mddev_suspend (fix
	nasty panic)
Date: Wed, 16 May 2012 21:33:30 -0500
Message-ID: <A30A147C-1292-4326-88E9-426DEA1FC102@redhat.com>
References: <1337141174.4337.8.camel@f14.redhat.com>
	<20120517105032.007f09c7@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/mixed; boundary="===============6230471781188392381=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120517105032.007f09c7@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


--===============6230471781188392381==
Content-Type: multipart/alternative; boundary=Apple-Mail-1-285041950


--Apple-Mail-1-285041950
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On May 16, 2012, at 7:50 PM, NeilBrown wrote:

> On Tue, 15 May 2012 23:06:14 -0500 Jonathan Brassow =
<jbrassow@redhat.com>
> wrote:
>=20
>> Neil,
>>=20
>> I've been seeing some really bad panics take place on dm-raid.c.  =
I've
>> found that it is because the mddev->safemode_timer is firing after =
the
>> mddev structure has been freed.  I've attached a patch to fix the
>> problem below, but I have some questions (outlined in the patch =
header).
>> I also have a debugging patch that prints something during each of =
the
>> suspend stages and when md_write_end resets the timer so that you can
>> see the problem in action - let me know if you want that patch also.
>>=20
>> brassow
>=20
> Hi Jon,
> thanks for the patch.  It looks simple and can clearly fix a problem
> so at this point in the cycle I propose to submit it to Linus as-is, =
even
> though I'm not convinced it is perfect, and you didn't give me a s-o-b =
line.
> See more blow.

Thanks Neil.

> <pet peeve>.
> No Signed-off-by: line?  why is that.
>=20
> "Signed-off-by" *only* means "I certify that I have any necessary =
right to
> submit this patch, and I agree to it being used in the way that all =
other
> code in this project can be used" - only with more words.  See the =
Developer's
> Certificate of Origin 1.1
>=20
> Refusing to add a Signed-off-by: because you don't think the code is =
"ready"
> yet in some sense is just plain wrong.  I never ever want to even see =
a patch
> that doesn't have Signed-off-by, because I don't know if I've been =
given
> permission to use it.
>=20
> Certainly add an 'RFC-by' if you want to say something about the =
quality of
> the patch, but don't for that reason exclude the signed-off-by
> </pet peeve>

"RFC-by" must be some overly clever thing I thought up or saw at one =
point.  i can certainly break that habit.  I had seen that possibly =
setting 'mddev->safemode =3D 2' might be a possible solution.  I was =
also a bit confused if I should pull the 'del_timer_sync' from =
'md_stop_writes'.  This is why I put the RFC in there, but I see your =
meaning.

Thanks,
 brassow=

--Apple-Mail-1-285041950
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On May 16, 2012, at 7:50 PM, NeilBrown wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; ">On Tue, 15 =
May 2012 23:06:14 -0500 Jonathan Brassow &lt;<a =
href=3D"mailto:jbrassow@redhat.com">jbrassow@redhat.com</a>&gt;<br>wrote:<=
br><br><blockquote type=3D"cite">Neil,<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">I've been =
seeing some really bad panics take place on dm-raid.c. =
&nbsp;I've<br></blockquote><blockquote type=3D"cite">found that it is =
because the mddev-&gt;safemode_timer is firing after =
the<br></blockquote><blockquote type=3D"cite">mddev structure has been =
freed. &nbsp;I've attached a patch to fix =
the<br></blockquote><blockquote type=3D"cite">problem below, but I have =
some questions (outlined in the patch =
header).<br></blockquote><blockquote type=3D"cite">I also have a =
debugging patch that prints something during each of =
the<br></blockquote><blockquote type=3D"cite">suspend stages and when =
md_write_end resets the timer so that you =
can<br></blockquote><blockquote type=3D"cite">see the problem in action =
- let me know if you want that patch also.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">brassow<br></blockquote><br>Hi Jon,<br>thanks for the =
patch. &nbsp;It looks simple and can clearly fix a problem<br>so at this =
point in the cycle I propose to submit it to Linus as-is, even<br>though =
I'm not convinced it is perfect, and you didn't give me a s-o-b =
line.<br>See more =
blow.<br></span></blockquote><div><br></div><div>Thanks =
Neil.</div><div><br></div><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; ">&lt;pet =
peeve&gt;.<br>No Signed-off-by: line? &nbsp;why is =
that.<br><br>"Signed-off-by" *only* means "I certify that I have any =
necessary right to<br>submit this patch, and I agree to it being used in =
the way that all other<br>code in this project can be used" - only with =
more words. &nbsp;See the Developer's<br>Certificate of Origin =
1.1<br><br>Refusing to add a Signed-off-by: because you don't think the =
code is "ready"<br>yet in some sense is just plain wrong. &nbsp;I never =
ever want to even see a patch<br>that doesn't have Signed-off-by, =
because I don't know if I've been given<br>permission to use =
it.<br><br>Certainly add an 'RFC-by' if you want to say something about =
the quality of<br>the patch, but don't for that reason exclude the =
signed-off-by<br>&lt;/pet =
peeve&gt;<br></span></blockquote></div><br><div>"RFC-by" must be some =
overly clever thing I thought up or saw at one point. &nbsp;i can =
certainly break that habit. &nbsp;I had seen that possibly setting =
'mddev-&gt;safemode =3D 2' might be a possible solution. &nbsp;I was =
also a bit confused if I should pull the 'del_timer_sync' from =
'md_stop_writes'. &nbsp;This is why I put the RFC in there, but I see =
your =
meaning.</div><div><br></div><div>Thanks,</div><div>&nbsp;brassow</div></b=
ody></html>=

--Apple-Mail-1-285041950--


--===============6230471781188392381==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6230471781188392381==--
