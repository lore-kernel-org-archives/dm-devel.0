From: Frederick Grose <fgrose@gmail.com>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Wed, 30 Nov 2011 16:48:05 -0500
Message-ID: <CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>
References: <4EABE131.8010706@googlemail.com>
	<20111029204947.GU23336@agk-dp.fab.redhat.com>
	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
	<4ED2DF0F.1070108@filteredperception.org>
	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
	<4ED59040.50406@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3972294360035084498=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ED59040.50406@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3972294360035084498==
Content-Type: multipart/alternative; boundary=000e0ce03ada4a0a4004b2fab374

--000e0ce03ada4a0a4004b2fab374
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Nov 29, 2011 at 9:09 PM, Douglas McClendon <
dmc.lists@filteredperception.org> wrote:

> On 11/29/2011 12:22 AM, Frederick Grose wrote:
>
>> On Sun, Nov 27, 2011 at 8:08 PM, Douglas McClendon
>> <dmc.lists@filteredperception.**org <dmc.lists@filteredperception.org>
>> <mailto:dmc.lists@**filteredperception.org<dmc.lists@filteredperception.org>>>
>> wrote:
>>
>>    On 11/27/2011 04:31 PM, Frederick Grose wrote:
>>
>>        On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergon
>>        <agk@redhat.com <mailto:agk@redhat.com>
>>        <mailto:agk@redhat.com <mailto:agk@redhat.com>>> wrote:
>>
>>            markmc did some code that shows how to read the format a few
>>        years
>>            ago here:
>>        http://people.gnome.org/~__**markmc/code/merge-dm-snapshot.**__c<http://people.gnome.org/~__markmc/code/merge-dm-snapshot.__c>
>>        <http://people.gnome.org/~**markmc/code/merge-dm-snapshot.**c<http://people.gnome.org/~markmc/code/merge-dm-snapshot.c>
>> >
>>        <http://people.gnome.org/%__**7Emarkmc/code/merge-dm-__**
>> snapshot.c
>>
>>        <http://people.gnome.org/%**7Emarkmc/code/merge-dm-**snapshot.c<http://people.gnome.org/%7Emarkmc/code/merge-dm-snapshot.c>
>> >>
>>
>>
>>            Otherwise look at dm-snap-persistent.c in the kernel tree.
>>
>>            Alasdair
>>
>>
>>        Users can easily exhaust a LiveUSB snapshot overlay by writing
>>        too many changes to the OS filesystem, such as by performing
>>        a yum update.
>>
>>        Would such an 'exhausted' overlay be amenable to some sort of
>>        data recovery or forensics?
>>
>>        If so, how so; if not, why not?
>>
>>
>>    Can you not mount the exhausted dm snapshot?  If you mean data
>>    recovery or forensics beyond that, please elaborate.
>>
>>    I know I've had issues 'read-only' mounting ext3(2?3?4?) filesystems
>>    before (on actually read-only block devices).  Maybe some flags that
>>    I've forgotten get past that, but worst case you can always fake a
>>    writable device with a 2nd overlay/snapshot going to a writable
>>    device, i.e. if you wanted to let fsck repair things.
>>
>>    -dmc
>>
>>
>> A typical scenario goes like this:
>>
>> A LiveCD is loaded onto a USB device with a relatively small
>> persistent overlay and no separate home.img filesystem.  The user
>> proceeds to use the system and save some information.  They may
>> execute a df command and see that there is lots of space
>> available on the rootfs.  Then they decide to execute a yum
>> update or yum install when there is insufficient space available.
>> (They do not know about dmsetup status.)  Their session will now
>> not shutdown normally. dmsetup status now shows
>>
>> live-rw: 0 8388608 snapshot Invalid.
>>
>> The device fails to complete a subsequent boot attempt.  The
>> startup log shows
>>
>
> You probably know this, but note there is a reset_overlay (or similar)
> boot flag which I think causes the overlay/snapshot to be reset, to get a
> booting system.


Yes, the relevant code for Fedora is here,
http://git.kernel.org/?p=boot/dracut/dracut.git;a=blob;f=modules.d/90dmsquash-live/dmsquash-live-root;hb=HEAD#l101

dd if=/dev/zero of=$OVERLAY_LOOPDEV bs=64k count=1 2>/dev/null

although it seems to need an extra parameter, conv=notrunc
to prevent truncation of the overlay file.

 So the rest of this is with the use-case in mind of trying to recover
> prior contents of the overlay/snapshot in a useful way.
>
>
>
>> mount: /dev/mapper/live-rw: can't read superblock
>>
>> e2fsck /dev/dm-0 shows
>>
>> Buffer I/O error on device dm-0, logical block 0 (and 1, 2, 3, 0)
>> e2fsck: Attempt to read block from the filesystem resulted in
>> short read while trying to open /dev/dm-0
>> Could this be a zero-length partition?
>>
>> I recreated the above scenario on Fedora-16-Live-Desktop
>> installed with an overlay-size-mb of 100.  After updating to ~70%
>> of the overlay, I wrote with
>> dd if=/dev/zero of=/boot/load bs=1M count=10
>> 3 times to exhaust the overlay.
>>
>> With the defective device mounted on a good system, and loop
>> devices set up for ext3fs.img and the overlay file,
>>
>> dmsetup create item --table "0 8388608 snapshot 7:1 7:2 P 8"
>
> dmsetup status reports
>> item: 0 8388608 snapshot Invalid
>>
>
> I don't know what that last line of output specifically means as far as
> subsequent expectations should go, though presumably others on this list
> can elaborate, or worst grep for the message in the code.
>
> Maybe dmsetup is more cooperative with full overlays if they are created
> in read-only mode?(wild guess)
>

I tested this with --readonly added to the
dmsetup create command, both with and without a
-r parameter on the overlay loop device set up command.
Both resulted in the Invalid snapshot report from
dmsetup status.

I.e. there is certainly the expectation that you won't be able to write to
> the device (or at a minimum to any chunk not already in the overlay(?)).
>  So as I mentioned, the way I'd go about it would be to recreate it (I'm
> taking for granted above cmdline is correct), but in read-only mode, then
> either just dup that to a new larger device, or add a second read-write
> snapshot layer on top (pointing to a looped tmpfile somewhere).  Then try
> to mount and/or fsck that.
>

Attempting to mount the Invalid snapshot results in,
mount: /dev/mapper/item: can't read superblock

A second snapshot set up over the first also fails to mount
or e2fsck with the same errors.


> But that presumes that the 'snapshot Invalid' isn't evidence that
> something is preventing even read-only access to the full snapshot.


snapshot Invalid  does seem to prevent even read-only access.


> For that I defer to the people more familiar with the relevent code.
>
>
>
>> e2fsck /dev/dm-0 reports
>>
>> e2fsck 1.41.14 (22-Dec-2010)
>> e2fsck: Attempt to read block from filesystem resulted in short
>> read while trying to open /dev/dm-0
>> Could this be a zero-length partition?
>>
>> A hex editor view of the overlay file shows lots of content with
>> lots of zeros at the end of the file.
>>
>> My questions are these:
>>
>> Might there be a way to edit the overlay file to restore its
>> utility for the information written before the damaging write?
>>
>> If so, how so; if not, why not?
>>
>
> Were it actually the case that full persistent snapshots become unusuable
> (short of 'editing'), that would seem like a bug needing to be fixed.
>
> -dmc
>
> Suitable references would do as well.
>>
>> Thanks!       --Fred
>>
>

--000e0ce03ada4a0a4004b2fab374
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Tue, Nov 29, 2011 at 9:09 PM, Douglas McClend=
on <span dir=3D"ltr">&lt;<a href=3D"mailto:dmc.lists@filteredperception.org=
">dmc.lists@filteredperception.org</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex;">

<div class=3D"im">On 11/29/2011 12:22 AM, Frederick Grose wrote:<br>
</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex"><div class=3D"im">
On Sun, Nov 27, 2011 at 8:08 PM, Douglas McClendon<br>
&lt;<a href=3D"mailto:dmc.lists@filteredperception.org" target=3D"_blank">d=
mc.lists@filteredperception.<u></u>org</a><br></div><div class=3D"im">
&lt;mailto:<a href=3D"mailto:dmc.lists@filteredperception.org" target=3D"_b=
lank">dmc.lists@<u></u>filteredperception.org</a>&gt;&gt; wrote:<br>
<br>
 =A0 =A0On 11/27/2011 04:31 PM, Frederick Grose wrote:<br>
<br>
 =A0 =A0 =A0 =A0On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergon<br>
 =A0 =A0 =A0 =A0&lt;<a href=3D"mailto:agk@redhat.com" target=3D"_blank">agk=
@redhat.com</a> &lt;mailto:<a href=3D"mailto:agk@redhat.com" target=3D"_bla=
nk">agk@redhat.com</a>&gt;<br></div><div class=3D"im">
 =A0 =A0 =A0 =A0&lt;mailto:<a href=3D"mailto:agk@redhat.com" target=3D"_bla=
nk">agk@redhat.com</a> &lt;mailto:<a href=3D"mailto:agk@redhat.com" target=
=3D"_blank">agk@redhat.com</a>&gt;&gt;&gt; wrote:<br>
<br>
 =A0 =A0 =A0 =A0 =A0 =A0markmc did some code that shows how to read the for=
mat a few<br>
 =A0 =A0 =A0 =A0years<br>
 =A0 =A0 =A0 =A0 =A0 =A0ago here:<br></div>
 =A0 =A0 =A0 =A0<a href=3D"http://people.gnome.org/~__markmc/code/merge-dm-=
snapshot.__c" target=3D"_blank">http://people.gnome.org/~__<u></u>markmc/co=
de/merge-dm-snapshot.<u></u>__c</a><br>
 =A0 =A0 =A0 =A0&lt;<a href=3D"http://people.gnome.org/~markmc/code/merge-d=
m-snapshot.c" target=3D"_blank">http://people.gnome.org/~<u></u>markmc/code=
/merge-dm-snapshot.<u></u>c</a>&gt;<br>
 =A0 =A0 =A0 =A0&lt;<a href=3D"http://people.gnome.org/%__7Emarkmc/code/mer=
ge-dm-__snapshot.c" target=3D"_blank">http://people.gnome.org/%__<u></u>7Em=
arkmc/code/merge-dm-__<u></u>snapshot.c</a><div><div class=3D"h5"><br>
 =A0 =A0 =A0 =A0&lt;<a href=3D"http://people.gnome.org/%7Emarkmc/code/merge=
-dm-snapshot.c" target=3D"_blank">http://people.gnome.org/%<u></u>7Emarkmc/=
code/merge-dm-<u></u>snapshot.c</a>&gt;&gt;<br>
<br>
<br>
 =A0 =A0 =A0 =A0 =A0 =A0Otherwise look at dm-snap-persistent.c in the kerne=
l tree.<br>
<br>
 =A0 =A0 =A0 =A0 =A0 =A0Alasdair<br>
<br>
<br>
 =A0 =A0 =A0 =A0Users can easily exhaust a LiveUSB snapshot overlay by writ=
ing<br>
 =A0 =A0 =A0 =A0too many changes to the OS filesystem, such as by performin=
g<br>
 =A0 =A0 =A0 =A0a yum update.<br>
<br>
 =A0 =A0 =A0 =A0Would such an &#39;exhausted&#39; overlay be amenable to so=
me sort of<br>
 =A0 =A0 =A0 =A0data recovery or forensics?<br>
<br>
 =A0 =A0 =A0 =A0If so, how so; if not, why not?<br>
<br>
<br>
 =A0 =A0Can you not mount the exhausted dm snapshot? =A0If you mean data<br=
>
 =A0 =A0recovery or forensics beyond that, please elaborate.<br>
<br>
 =A0 =A0I know I&#39;ve had issues &#39;read-only&#39; mounting ext3(2?3?4?=
) filesystems<br>
 =A0 =A0before (on actually read-only block devices). =A0Maybe some flags t=
hat<br>
 =A0 =A0I&#39;ve forgotten get past that, but worst case you can always fak=
e a<br>
 =A0 =A0writable device with a 2nd overlay/snapshot going to a writable<br>
 =A0 =A0device, i.e. if you wanted to let fsck repair things.<br>
<br>
 =A0 =A0-dmc<br>
<br>
<br>
A typical scenario goes like this:<br>
<br>
A LiveCD is loaded onto a USB device with a relatively small<br>
persistent overlay and no separate home.img filesystem. =A0The user<br>
proceeds to use the system and save some information. =A0They may<br>
execute a df command and see that there is lots of space<br>
available on the rootfs. =A0Then they decide to execute a yum<br>
update or yum install when there is insufficient space available.<br>
(They do not know about dmsetup status.) =A0Their session will now<br>
not shutdown normally. dmsetup status now shows<br>
<br>
live-rw: 0 8388608 snapshot Invalid.<br>
<br>
The device fails to complete a subsequent boot attempt. =A0The<br>
startup log shows<br>
</div></div></blockquote>
<br>
You probably know this, but note there is a reset_overlay (or similar) boot=
 flag which I think causes the overlay/snapshot to be reset, to get a booti=
ng system.</blockquote><div><br></div><div><font face=3D"&#39;courier new&#=
39;, monospace">Yes, the relevant code for Fedora is here,</font></div>

<div><a href=3D"http://git.kernel.org/?p=3Dboot/dracut/dracut.git;a=3Dblob;=
f=3Dmodules.d/90dmsquash-live/dmsquash-live-root;hb=3DHEAD#l101"><font face=
=3D"&#39;courier new&#39;, monospace">http://git.kernel.org/?p=3Dboot/dracu=
t/dracut.git;a=3Dblob;f=3Dmodules.d/90dmsquash-live/dmsquash-live-root;hb=
=3DHEAD#l101</font></a></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<span style=3D"white-space: pre; background-color: rgb(255, 255, 255); "><f=
ont face=3D"&#39;courier new&#39;, monospace">dd=A0if=3D/dev/zero=A0of=3D$O=
VERLAY_LOOPDEV=A0bs=3D64k=A0count=3D1=A02&gt;/dev/null</font></span></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">although it seems to need a=
n extra parameter,=A0conv=3Dnotrunc</font></div><div><font face=3D"&#39;cou=
rier new&#39;, monospace">to prevent truncation of the overlay file.</font>=
</div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex;"> =A0So the rest of this is with the use-case in =
mind of trying to recover prior contents of the overlay/snapshot in a usefu=
l way.<div class=3D"im">

<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
mount: /dev/mapper/live-rw: can&#39;t read superblock<br>
<br>
e2fsck /dev/dm-0 shows<br>
<br>
Buffer I/O error on device dm-0, logical block 0 (and 1, 2, 3, 0)<br>
e2fsck: Attempt to read block from the filesystem resulted in<br>
short read while trying to open /dev/dm-0<br>
Could this be a zero-length partition?<br>
<br>
I recreated the above scenario on Fedora-16-Live-Desktop<br>
installed with an overlay-size-mb of 100. =A0After updating to ~70%<br>
of the overlay, I wrote with<br>
dd if=3D/dev/zero of=3D/boot/load bs=3D1M count=3D10<br>
3 times to exhaust the overlay.<br>
<br>
With the defective device mounted on a good system, and loop<br>
devices set up for ext3fs.img and the overlay file,<br>
<br>
dmsetup create item --table &quot;0 8388608 snapshot 7:1 7:2 P 8&quot;</blo=
ckquote></div></blockquote></div><div class=3D"gmail_quote"><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex;">

<div class=3D"im"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">dmsetup status reports<br>
item: 0 8388608 snapshot Invalid<br>
</blockquote>
<br></div>
I don&#39;t know what that last line of output specifically means as far as=
 subsequent expectations should go, though presumably others on this list c=
an elaborate, or worst grep for the message in the code.<br>
<br>
Maybe dmsetup is more cooperative with full overlays if they are created in=
 read-only mode?(wild guess)<br></blockquote><div><br></div><div><font face=
=3D"&#39;courier new&#39;, monospace">I tested this with --readonly added t=
o the</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace">dmsetup create command=
, both with and without a</font></div><div><font face=3D"&#39;courier new&#=
39;, monospace">-r parameter on the overlay loop device set up command.</fo=
nt></div>

<div><font face=3D"&#39;courier new&#39;, monospace">Both resulted in the I=
nvalid snapshot report from</font></div><div><font face=3D"&#39;courier new=
&#39;, monospace">dmsetup status.</font></div><div><font face=3D"&#39;couri=
er new&#39;, monospace"><br>

</font></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex;">I.e. there is certainly the ex=
pectation that you won&#39;t be able to write to the device (or at a minimu=
m to any chunk not already in the overlay(?)). =A0So as I mentioned, the wa=
y I&#39;d go about it would be to recreate it (I&#39;m taking for granted a=
bove cmdline is correct), but in read-only mode, then either just dup that =
to a new larger device, or add a second read-write snapshot layer on top (p=
ointing to a looped tmpfile somewhere). =A0Then try to mount and/or fsck th=
at.<br>

</blockquote><div>=A0</div><div><font face=3D"&#39;courier new&#39;, monosp=
ace">Attempting to mount the Invalid snapshot results in,</font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">mount: /dev/mapper/item: ca=
n&#39;t read superblock</font></div>

<div><font face=3D"&#39;courier new&#39;, monospace"><br></font></div><div>=
<font face=3D"&#39;courier new&#39;, monospace">A second snapshot set up ov=
er the first also fails to mount</font></div><div><font face=3D"&#39;courie=
r new&#39;, monospace">or e2fsck with the same errors.</font></div>

<div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex;">But that presumes that the &#=
39;snapshot Invalid&#39; isn&#39;t evidence that something is preventing ev=
en read-only access to the full snapshot.</blockquote>

<div><br></div><div><font face=3D"&#39;courier new&#39;, monospace">snapsho=
t Invalid =A0does seem to prevent even read-only access.</font></div><div>=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;borde=
r-left:1px #ccc solid;padding-left:1ex;">

 For that I defer to the people more familiar with the relevent code.<div c=
lass=3D"im"><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
e2fsck /dev/dm-0 reports<br>
<br>
e2fsck 1.41.14 (22-Dec-2010)<br>
e2fsck: Attempt to read block from filesystem resulted in short<br>
read while trying to open /dev/dm-0<br>
Could this be a zero-length partition?<br>
<br>
A hex editor view of the overlay file shows lots of content with<br>
lots of zeros at the end of the file.<br>
<br>
My questions are these:<br>
<br>
Might there be a way to edit the overlay file to restore its<br>
utility for the information written before the damaging write?<br>
<br>
If so, how so; if not, why not?<br>
</blockquote>
<br></div>
Were it actually the case that full persistent snapshots become unusuable (=
short of &#39;editing&#39;), that would seem like a bug needing to be fixed=
.<br>
<br>
-dmc<br>
<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex"><div class=3D"im">
Suitable references would do as well.<br>
<br>
Thanks! =A0 =A0 =A0 --Fred</div></blockquote></blockquote></div>

--000e0ce03ada4a0a4004b2fab374--


--===============3972294360035084498==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3972294360035084498==--
