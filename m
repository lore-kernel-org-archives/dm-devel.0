From: Brian Bunker <brian@purestorage.com>
Subject: Fwd:  different LUN numbers under the same dm device
Date: Mon, 11 Jun 2012 17:43:37 -0700
Message-ID: <A5BE0EF6-F8F7-4D53-8D2C-3868864EA6C6@purestorage.com>
References: <E7B02C12-FE4B-48E0-B73A-CA2777AE2D22@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: multipart/mixed; boundary="===============8127519344784984108=="
Return-path: <dm-devel-bounces@redhat.com>
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


--===============8127519344784984108==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_8FD88F21-4858-4866-9444-71592904B49C"


--Apple-Mail=_8FD88F21-4858-4866-9444-71592904B49C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

> Hannes,
>=20
> We send a LIP for really only one reason that we can't get around any =
other way yet. We have a LUN 0 device that is a non data LUN. When you =
zone an initiator to our target, it logs in and interrogates LUN 0. That =
is before we have any data LUN's assigned to that initiator. When we =
assign data LUN's to that initiator, there is no way to notify that =
initiator via the target that something has changed and the initiator =
should again do a REPORT_LUNS. I know that if we had a data LUN that the =
initiator was already seeing we could use a unit attention and sense =
data for this, but since our LUN 0 is not a device, the initiator does =
not send I/O to it beyond its initial login. A rescan that includes a =
LIP is our only way of re logging into the target from the initiator. A =
rescan of existing LUN's would not work in the case of assigning LUN's =
for the first time down a path of initiator that is currently logged =
into the target or one where the rports have been removed because of a =
timeout leaving only the LUN 0 again.
>=20
> Brian
>=20
> On Jun 10, 2012, at 11:38 PM, Hannes Reinecke wrote:
>=20
>> On 06/08/2012 07:18 PM, Brian Bunker wrote:
>>> Mike and all,
>>>=20
>>> Thanks for the information. I think that everyone is on the same =
page now.
>>> The problem comes up for us because we have mostly automated tools
>> processing
>>> this output and they choked when they saw 4 paths even though as
>> Hannes
>>> pointed out 2 are faulty. We changed the automated scripts to look
>> at the
>>> state as well so we will get past this. We were mostly curious why
>> we only
>>> see this occasionally and on some dm devices. I will also change the
>>> rescanning mechanism to use 'rescan-scsi-bus.sh'. I think that we
>> should
>>> use both -r and -i right so that we send a LIP to the FC target?
>>>=20
>> Gnaa. I should have never implemented the '-i' option in the first
>> place. '-i' is just a horrible hack for misbehaving SANs.
>> FC arrays should detect any change in the port mapping themselves,
>> either via RSCNs or if a LIP reset occured.
>> During normal operation LIP should _not_ be necessary; in fact, I
>> would consider it a bug if you do.
>>=20
>>> I think that our current rescan behavior was just to go the=20
>>> /sys/class/fc_host/hostX and echo 1 to issue_lip. To answer all the
>>> questions, yes LUN 10 and LUN 12 did point to the same data LUN on =
the
>>> array not two different ones. If we ever shared NAA numbers for
>> different
>>> LUN's on the array itself we would have a big problem and would see
>>> corruption everywhere.
>>>=20
>> Close, but not banana. 'issue_lip' is in fact a nasty method of
>> invoking a scan, it basically amounts to a card reset.
>>=20
>> The 'correct' way would be to do a
>>=20
>> echo '- - -' > /sys/class/fc_host/hostX/scan
>>=20
>> and then remove all devices for which sg_tur / sg_inq returns an
>> error code.
>> Which is what rescan-scsi-bus.sh -r does.
>>=20
>> But occasionally you're indeed better off by coding it by hand.
>> I know rescan-scsi-bus.sh far too well to recommend it to each and
>> sundry :-)
>>=20
>> Cheers,
>>=20
>> Hannes
>> --=20
>> Dr. Hannes Reinecke		      zSeries & Storage
>> hare@suse.de			      +49 911 74053 688
>> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>=20
> Brian Bunker
> brian@purestorage.com
>=20
>=20
>=20

Brian Bunker
brian@purestorage.com




--Apple-Mail=_8FD88F21-4858-4866-9444-71592904B49C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=iso-8859-1

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><div><blockquote type=3D"cite"><div>Hannes,<br><br>We send a LIP for =
really only one reason that we can't get around any other way yet. We =
have a LUN 0 device that is a non data LUN. When you zone an initiator =
to our target, it logs in and interrogates LUN 0. That is before we have =
any data LUN's assigned to that initiator. When we assign data LUN's to =
that initiator, there is no way to notify that initiator via the target =
that something has changed and the initiator should again do a =
REPORT_LUNS. I know that if we had a data LUN that the initiator was =
already seeing we could use a unit attention and sense data for this, =
but since our LUN 0 is not a device, the initiator does not send I/O to =
it beyond its initial login. A rescan that includes a LIP is our only =
way of re logging into the target from the initiator. A rescan of =
existing LUN's would not work in the case of assigning LUN's for the =
first time down a path of initiator that is currently logged into the =
target or one where the rports have been removed because of a timeout =
leaving only the LUN 0 again.<br><br>Brian<br><br>On Jun 10, 2012, at =
11:38 PM, Hannes Reinecke wrote:<br><br><blockquote type=3D"cite">On =
06/08/2012 07:18 PM, Brian Bunker wrote:<br></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">Mike and =
all,<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">Thanks for the information. I =
think that everyone is on the same page =
now.<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">The problem comes up for us because we have mostly =
automated tools<br></blockquote></blockquote><blockquote =
type=3D"cite">processing<br></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">this output and they choked when =
they saw 4 paths even though as<br></blockquote></blockquote><blockquote =
type=3D"cite">Hannes<br></blockquote><blockquote type=3D"cite"><blockquote=
 type=3D"cite">pointed out 2 are faulty. We changed the automated =
scripts to look<br></blockquote></blockquote><blockquote type=3D"cite">at =
the<br></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">state as well so we will get past this. We were mostly =
curious why<br></blockquote></blockquote><blockquote type=3D"cite">we =
only<br></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">see this occasionally and on some dm devices. I will also =
change the<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">rescanning mechanism to use =
'rescan-scsi-bus.sh'. I think that =
we<br></blockquote></blockquote><blockquote =
type=3D"cite">should<br></blockquote><blockquote type=3D"cite"><blockquote=
 type=3D"cite">use both -r and -i right so that we send a LIP to the FC =
target?<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote=
 type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite">Gnaa. I should have never implemented the '-i' option in =
the first<br></blockquote><blockquote type=3D"cite">place. '-i' is just =
a horrible hack for misbehaving SANs.<br></blockquote><blockquote =
type=3D"cite">FC arrays should detect any change in the port mapping =
themselves,<br></blockquote><blockquote type=3D"cite">either via RSCNs =
or if a LIP reset occured.<br></blockquote><blockquote =
type=3D"cite">During normal operation LIP should _not_ be necessary; in =
fact, I<br></blockquote><blockquote type=3D"cite">would consider it a =
bug if you do.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">I think that our current rescan behavior was just to go =
the <br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">/sys/class/fc_host/hostX and echo 1 to issue_lip. To =
answer all the<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">questions, yes LUN 10 and LUN 12 =
did point to the same data LUN on =
the<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">array not two different ones. If we ever shared NAA =
numbers for<br></blockquote></blockquote><blockquote =
type=3D"cite">different<br></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">LUN's on the array itself we =
would have a big problem and would =
see<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">corruption =
everywhere.<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite">Close, but not banana. 'issue_lip' is in fact a nasty =
method of<br></blockquote><blockquote type=3D"cite">invoking a scan, it =
basically amounts to a card reset.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">The 'correct' =
way would be to do a<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">echo '- - -' =
&gt; /sys/class/fc_host/hostX/scan<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">and then remove =
all devices for which sg_tur / sg_inq returns =
an<br></blockquote><blockquote type=3D"cite">error =
code.<br></blockquote><blockquote type=3D"cite">Which is what =
rescan-scsi-bus.sh -r does.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">But =
occasionally you're indeed better off by coding it by =
hand.<br></blockquote><blockquote type=3D"cite">I know =
rescan-scsi-bus.sh far too well to recommend it to each =
and<br></blockquote><blockquote type=3D"cite">sundry =
:-)<br></blockquote><blockquote type=3D"cite"><br></blockquote><blockquote=
 type=3D"cite">Cheers,<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">Hannes<br></blockquote><blockquote type=3D"cite">-- =
<br></blockquote><blockquote type=3D"cite">Dr. Hannes Reinecke<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;zSeries &amp; =
Storage<br></blockquote><blockquote type=3D"cite"><a =
href=3D"mailto:hare@suse.de">hare@suse.de</a><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;+49 911 74053 =
688<br></blockquote><blockquote type=3D"cite">SUSE LINUX Products GmbH, =
Maxfeldstr. 5, 90409 N=FCrnberg<br></blockquote><blockquote =
type=3D"cite">GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG =
N=FCrnberg)<br></blockquote><br>Brian Bunker<br><a =
href=3D"mailto:brian@purestorage.com">brian@purestorage.com</a><br><br><br=
><br></div></blockquote></div><br><div apple-content-edited=3D"true">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
color: rgb(0, 0, 0); font-family: Helvetica; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: 2; text-align: -webkit-auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; "><div>Brian =
Bunker</div><div><a =
href=3D"mailto:brian@purestorage.com">brian@purestorage.com</a></div><div>=
<br></div></span><br class=3D"Apple-interchange-newline">
</div>
<br></body></html>=

--Apple-Mail=_8FD88F21-4858-4866-9444-71592904B49C--


--===============8127519344784984108==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8127519344784984108==--
