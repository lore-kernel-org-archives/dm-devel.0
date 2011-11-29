From: Frederick Grose <fgrose@gmail.com>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Tue, 29 Nov 2011 01:22:16 -0500
Message-ID: <CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
References: <4EABE131.8010706@googlemail.com>
	<20111029204947.GU23336@agk-dp.fab.redhat.com>
	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
	<4ED2DF0F.1070108@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3372351735668760822=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ED2DF0F.1070108@filteredperception.org>
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
List-Id: dm-devel.ids

--===============3372351735668760822==
Content-Type: multipart/alternative; boundary=bcaec52bf0a37670b404b2d9a659

--bcaec52bf0a37670b404b2d9a659
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Nov 27, 2011 at 8:08 PM, Douglas McClendon <
dmc.lists@filteredperception.org> wrote:

> On 11/27/2011 04:31 PM, Frederick Grose wrote:
>
>> On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergon <agk@redhat.com
>> <mailto:agk@redhat.com>> wrote:
>>
>>    markmc did some code that shows how to read the format a few years
>>    ago here:
>>    http://people.gnome.org/~**markmc/code/merge-dm-snapshot.**c<http://people.gnome.org/~markmc/code/merge-dm-snapshot.c>
>>    <http://people.gnome.org/%**7Emarkmc/code/merge-dm-**snapshot.c<http://people.gnome.org/%7Emarkmc/code/merge-dm-snapshot.c>
>> >
>>
>>
>>    Otherwise look at dm-snap-persistent.c in the kernel tree.
>>
>>    Alasdair
>>
>>
>> Users can easily exhaust a LiveUSB snapshot overlay by writing
>> too many changes to the OS filesystem, such as by performing
>> a yum update.
>>
>> Would such an 'exhausted' overlay be amenable to some sort of
>> data recovery or forensics?
>>
>> If so, how so; if not, why not?
>>
>
> Can you not mount the exhausted dm snapshot?  If you mean data recovery or
> forensics beyond that, please elaborate.
>
> I know I've had issues 'read-only' mounting ext3(2?3?4?) filesystems
> before (on actually read-only block devices).  Maybe some flags that I've
> forgotten get past that, but worst case you can always fake a writable
> device with a 2nd overlay/snapshot going to a writable device, i.e. if you
> wanted to let fsck repair things.
>
> -dmc


A typical scenario goes like this:

A LiveCD is loaded onto a USB device with a relatively small
persistent overlay and no separate home.img filesystem.  The user
proceeds to use the system and save some information.  They may
execute a df command and see that there is lots of space
available on the rootfs.  Then they decide to execute a yum
update or yum install when there is insufficient space available.
(They do not know about dmsetup status.)  Their session will now
not shutdown normally. dmsetup status now shows

live-rw: 0 8388608 snapshot Invalid.

The device fails to complete a subsequent boot attempt.  The
startup log shows

mount: /dev/mapper/live-rw: can't read superblock

e2fsck /dev/dm-0 shows

Buffer I/O error on device dm-0, logical block 0 (and 1, 2, 3, 0)
e2fsck: Attempt to read block from the filesystem resulted in
short read while trying to open /dev/dm-0
Could this be a zero-length partition?

I recreated the above scenario on Fedora-16-Live-Desktop
installed with an overlay-size-mb of 100.  After updating to ~70%
of the overlay, I wrote with
dd if=/dev/zero of=/boot/load bs=1M count=10
3 times to exhaust the overlay.

With the defective device mounted on a good system, and loop
devices set up for ext3fs.img and the overlay file,

dmsetup create item --table "0 8388608 snapshot 7:1 7:2 P 8"
reports
item: 0 8388608 snapshot Invalid

e2fsck /dev/dm-0 reports

e2fsck 1.41.14 (22-Dec-2010)
e2fsck: Attempt to read block from filesystem resulted in short
read while trying to open /dev/dm-0
Could this be a zero-length partition?

A hex editor view of the overlay file shows lots of content with
lots of zeros at the end of the file.

My questions are these:

Might there be a way to edit the overlay file to restore its
utility for the information written before the damaging write?

If so, how so; if not, why not?

Suitable references would do as well.

Thanks!       --Fred

--bcaec52bf0a37670b404b2d9a659
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Sun, Nov 27, 2011 at 8:08 PM, Douglas McClend=
on <span dir=3D"ltr">&lt;<a href=3D"mailto:dmc.lists@filteredperception.org=
">dmc.lists@filteredperception.org</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex;">

<div class=3D"im">On 11/27/2011 04:31 PM, Frederick Grose wrote:<br>
</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex"><div class=3D"im">
On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergon &lt;<a href=3D"mailto:ag=
k@redhat.com" target=3D"_blank">agk@redhat.com</a><br></div><div class=3D"i=
m">
&lt;mailto:<a href=3D"mailto:agk@redhat.com" target=3D"_blank">agk@redhat.c=
om</a>&gt;&gt; wrote:<br>
<br>
 =A0 =A0markmc did some code that shows how to read the format a few years<=
br>
 =A0 =A0ago here:<br>
 =A0 =A0<a href=3D"http://people.gnome.org/~markmc/code/merge-dm-snapshot.c=
" target=3D"_blank">http://people.gnome.org/~<u></u>markmc/code/merge-dm-sn=
apshot.<u></u>c</a><br></div>
 =A0 =A0&lt;<a href=3D"http://people.gnome.org/%7Emarkmc/code/merge-dm-snap=
shot.c" target=3D"_blank">http://people.gnome.org/%<u></u>7Emarkmc/code/mer=
ge-dm-<u></u>snapshot.c</a>&gt;<div class=3D"im"><br>
<br>
 =A0 =A0Otherwise look at dm-snap-persistent.c in the kernel tree.<br>
<br>
 =A0 =A0Alasdair<br>
<br>
<br>
Users can easily exhaust a LiveUSB snapshot overlay by writing<br>
too many changes to the OS filesystem, such as by performing<br>
a yum update.<br>
<br>
Would such an &#39;exhausted&#39; overlay be amenable to some sort of<br>
data recovery or forensics?<br>
<br>
If so, how so; if not, why not?<br>
</div></blockquote>
<br>
Can you not mount the exhausted dm snapshot? =A0If you mean data recovery o=
r forensics beyond that, please elaborate.<br>
<br>
I know I&#39;ve had issues &#39;read-only&#39; mounting ext3(2?3?4?) filesy=
stems before (on actually read-only block devices). =A0Maybe some flags tha=
t I&#39;ve forgotten get past that, but worst case you can always fake a wr=
itable device with a 2nd overlay/snapshot going to a writable device, i.e. =
if you wanted to let fsck repair things.<br>


<br>
-dmc</blockquote><div><br></div><div><font face=3D"&#39;courier new&#39;, m=
onospace">A typical scenario goes like this:</font></div><div><font face=3D=
"&#39;courier new&#39;, monospace"><br></font></div><div><font face=3D"&#39=
;courier new&#39;, monospace">A LiveCD is loaded onto a USB device with a r=
elatively small</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">persistent overlay and=
 no separate home.img filesystem. =A0The user</font></div><div><font face=
=3D"&#39;courier new&#39;, monospace">proceeds to use the system and save s=
ome information. =A0They may</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">execute a df command a=
nd see that there is lots of space</font></div><div><font face=3D"&#39;cour=
ier new&#39;, monospace">available on the rootfs. =A0Then they decide to ex=
ecute a yum</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">update or yum install =
when there is insufficient space available.</font></div><div><font face=3D"=
&#39;courier new&#39;, monospace">(They do not know about dmsetup status.) =
=A0Their session will now</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">not shutdown normally.=
 dmsetup status now shows</font></div><div><font face=3D"&#39;courier new&#=
39;, monospace"><br></font></div><div><font face=3D"&#39;courier new&#39;, =
monospace">live-rw: 0 8388608 snapshot Invalid.</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">The device fails to complet=
e a subsequent boot attempt. =A0The</font></div><div><font face=3D"&#39;cou=
rier new&#39;, monospace">startup log shows</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">mount: /dev/mapper/live-rw:=
 can&#39;t read superblock</font></div><div><font face=3D"&#39;courier new&=
#39;, monospace"><br>

</font></div><div><font face=3D"&#39;courier new&#39;, monospace">e2fsck /d=
ev/dm-0 shows</font></div><div><font face=3D"&#39;courier new&#39;, monospa=
ce"><br></font></div><div><font face=3D"&#39;courier new&#39;, monospace">B=
uffer I/O error on device dm-0, logical block 0 (and 1, 2, 3, 0)</font></di=
v>

<div><font face=3D"&#39;courier new&#39;, monospace">e2fsck: Attempt to rea=
d block from the filesystem resulted in</font></div><div><font face=3D"&#39=
;courier new&#39;, monospace">short read while trying to open /dev/dm-0</fo=
nt></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Could this be a zero-l=
ength partition?</font></div><div><font face=3D"&#39;courier new&#39;, mono=
space"><br></font></div><div><font face=3D"&#39;courier new&#39;, monospace=
">I recreated the above scenario on Fedora-16-Live-Desktop</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">installed with an over=
lay-size-mb of 100. =A0After updating to ~70%</font></div><div><font face=
=3D"&#39;courier new&#39;, monospace">of the overlay, I wrote with</font></=
div>

<div><font face=3D"&#39;courier new&#39;, monospace">dd if=3D/dev/zero of=
=3D/boot/load bs=3D1M count=3D10</font></div><div><font face=3D"&#39;courie=
r new&#39;, monospace">3 times to exhaust the overlay.</font></div><div><fo=
nt face=3D"&#39;courier new&#39;, monospace"><br>

</font></div><div><font face=3D"&#39;courier new&#39;, monospace">With the =
defective device mounted on a good system, and loop</font></div><div><font =
face=3D"&#39;courier new&#39;, monospace">devices set up for ext3fs.img and=
 the overlay file,</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">dmsetup create item --table=
 &quot;0 8388608 snapshot 7:1 7:2 P 8&quot;</font></div><div><font face=3D"=
&#39;courier new&#39;, monospace">reports</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">item: 0 8388608 snapsh=
ot Invalid</font></div><div><font face=3D"&#39;courier new&#39;, monospace"=
><br></font></div><div><font face=3D"&#39;courier new&#39;, monospace">e2fs=
ck /dev/dm-0 reports</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace"><div>e2fsck 1.41.14 (22-Dec=
-2010)</div><div>e2fsck: Attempt to read block from filesystem resulted in =
short</div>

<div>read while trying to open /dev/dm-0</div><div>Could this be a zero-len=
gth partition?</div><div><br></div></font></div><div><font face=3D"&#39;cou=
rier new&#39;, monospace">A hex editor view of the overlay file shows lots =
of content with</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">lots of zeros at the e=
nd of the file.</font></div><div><font face=3D"&#39;courier new&#39;, monos=
pace"><br></font></div><div><font face=3D"&#39;courier new&#39;, monospace"=
>My questions are these:</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">Might there be a way to edi=
t the overlay=A0</font><span style=3D"font-family: &#39;courier new&#39;, m=
onospace; ">file to restore its</span></div>

<div><span style=3D"font-family: &#39;courier new&#39;, monospace; ">utilit=
y for the information written before=A0</span><span style=3D"font-family: &=
#39;courier new&#39;, monospace; ">the damaging write?</span></div><div><fo=
nt face=3D"&#39;courier new&#39;, monospace"><br>

</font></div><div><font face=3D"&#39;courier new&#39;, monospace">If so, ho=
w so; if not, why not?</font></div><div><font face=3D"&#39;courier new&#39;=
, monospace"><br></font></div><div><font face=3D"&#39;courier new&#39;, mon=
ospace">Suitable references would do as well.</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">Thanks! =A0 =A0 =A0 --Fred<=
/font></div><div><span style=3D"font-family: &#39;courier new&#39;, monospa=
ce; "><br>

</span></div><div><font face=3D"&#39;courier new&#39;, monospace"><br></fon=
t></div></div>

--bcaec52bf0a37670b404b2d9a659--


--===============3372351735668760822==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3372351735668760822==--
