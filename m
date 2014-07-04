From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 06/12] Make multipath add wwids from kernel
 cmdline mpath.wwids with -A
Date: Fri, 4 Jul 2014 09:12:35 +0200
Message-ID: <CABr-GnfFXLc6NvSk50TaO1f8NKbQzT7j70j8b=L+m4LfswE=tw@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-7-git-send-email-bmarzins@redhat.com>
	<CABr-GnedX62W_U988FjXs4eV+GisRjt_AhPe4J6XhBPzF+_uCw@mail.gmail.com>
	<53B3A0BA.9040502@suse.de>
	<20140702194816.GF10438@dhcp80-209.msp.redhat.com>
	<53B53901.3050606@suse.de>
	<20140703192555.GG10438@dhcp80-209.msp.redhat.com>
	<53B648B5.30209@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5882177361595952967=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53B648B5.30209@suse.de>
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

--===============5882177361595952967==
Content-Type: multipart/alternative; boundary=089e01161982888a8104fd58d957

--089e01161982888a8104fd58d957
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Still tanked in my local git tree.
I'll push them online late this afternoon.



On Fri, Jul 4, 2014 at 8:24 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 07/03/2014 09:25 PM, Benjamin Marzinski wrote:
>
>> On Thu, Jul 03, 2014 at 01:05:37PM +0200, Hannes Reinecke wrote:
>>
>>> On 07/02/2014 09:48 PM, Benjamin Marzinski wrote:
>>>
>>>> On Wed, Jul 02, 2014 at 08:03:38AM +0200, Hannes Reinecke wrote:
>>>>
>>>>> On 07/01/2014 09:22 PM, Christophe Varoqui wrote:
>>>>>
>>>>>> Hannes,
>>>>>>
>>>>>> would you Ack this one, or do you have some other idea for this in
>>>>>> your tree ?
>>>>>>
>>>>>>  Sigh. The whole multipath / systemd / dracut integration
>>>>> is _a mess_.
>>>>> The main problem is that RH and SUSE treat multipath handling
>>>>> differently.
>>>>> (From what I can see. I've still a hard time to understand how
>>>>>   multipath booting works with RH. So there might be errors.)
>>>>>
>>>>> RH is taking a restrictive approach, ie it'll allow only configured
>>>>> multipath devices during boot. IE it'll accept only devices present
>>>>> in '/etc/multipath/wwids' for booting. So when coming across a new
>>>>> wwid multipath won't be setup there, so of course they'll need an
>>>>> additional parameter for that.
>>>>>
>>>>
>>>> That's not strictly true.  multipathd will happily create a multipath
>>>> device on top of any valid scsi devices it finds, but unless those
>>>> devices are in /etc/multipath/wwids, other components, like lvm won't
>>>> know to leave them alone.  This actually isn't an issue during the
>>>> initramfs boot stages because lvm doesn't do autoactivation there.
>>>>
>>>> So, if the device appears in the initramfs portion of boot, we're grea=
t.
>>>>
>>>> The specific issue that prompted this goes like this:
>>>>
>>>> - The iscsi initiator is not setup to run in the initramfs on install
>>>> - Storage is added to the system that makes up a working LV
>>>> - Once the machine boots up, and is past the initramfs, the iscsi
>>>> initiator starts up and discovers the devices.
>>>> - Multipath races with lvmetad and loses
>>>> - Now you have a LV built on top of a single path device, instead of
>>>>    being multipathed (The LV is on top of a partition of the path
>>>>    device, so reassign_maps doesn't work on it)
>>>>
>>>> If you tell the redhat installer that you want to use multipath, this
>>>> causes problems, since it can't disassemble the an arbitrary stack of
>>>> virtual devices.  Eventually, we'll fix that issue, and this won't
>>>> matter anymore, because it will just be able to disassemble the virtua=
l
>>>> device stack, and rerun multipath, to make everything autoassemble in
>>>> the correct order.
>>>>
>>>>  Hmm. Similar to what I've seen here when booting with multipath
>>> enabled and
>>> an empty '/etc/multipath/wwids' file.
>>>
>>> We're having an udev rule calling 'multipath -u' to check if the device
>>> is
>>> eligible for multipathing. If so it'll set the various udev properties =
to
>>> keep LVM and others from working with that device.
>>>
>>> But as 'multipath -u' is be checking /etc/multipath/wwids it will alway=
s
>>> report 'not a multipath device'.
>>> So I would be perfectly happy with 'multipath -u' _not_ checking
>>> /etc/multipath/wwids (or have a switch for doing so).
>>>
>>
>> 'multipath -u'? Do you mean 'multipath -c'?  I do worry that not
>> checking the wwids file could break things were some device appears
>> multipathable, but will never successfully get created for reasons
>> outside of multipath's knowledge.  The wwids file makes sure that this
>> device is multipathable, because it HAS been multipathed before.
>>
>> That being said, I have no objections to a switch to avoid the wwid file
>> check.
>>
>>  Okay, I've send a patch.
>
>
>  Anyway. There is actually a slight inconsistency with the above approach=
:
>>> Multipath is _not_ setup for autoconfiguration; from my understanding
>>> this
>>> was exactly why /etc/multipath/wwids was introduced in the first place.
>>> LVM, on the other hand, is trying to do autoconfiguration.
>>>
>>> Why? I would set either both to autoconfiguration or none.
>>> If I want something different I need to configure the system.
>>>
>>
>> Well, multipath is only not set up to do autoconfiguration because you
>> keep objecting to my find_multipaths patch, which makes multipath only
>> run on devices that have more than one path. With that, you can usually
>> leave the blacklists alone, and you will only get the devices that you
>> want.
>>
>>  Oh, I don't have any objections to that, provided it's configurable
> via the config file.
> Care to send a patch for that?
>
>
>
>>  Can you clarify what the intended usage for /etc/multipath/wwids is?
>>> I was under the impression that it's been introduced to keep
>>> multipath from accepting unconfigured devices ...
>>>
>>
>> Like I mentioned above, it was added to avoid the situations where
>> multipath isn't blacklisted on a device, but is unable to set up on it.
>> We use this to so that 'multipath -c' doesn't claim a device and keep
>> lvm or md from using it when it shouldn't.
>>
>>  Ah, I've been luckier than you, then.
> I keep telling folks that multipath will grab all devices, and the only
> way to modify this is blacklisting devices via /etc/multipath.conf.
> So any system where the above happens is per definition misconfigured :-)
>
> Christophe, what happened to the patches you've said to have applied? I
> haven't seen them showing up in the git repository ...
>
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--089e01161982888a8104fd58d957
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Still tanked in my local git tree.<div>I&#39;ll push them =
online late this afternoon.</div><div><br></div></div><div class=3D"gmail_e=
xtra"><br><br><div class=3D"gmail_quote">On Fri, Jul 4, 2014 at 8:24 AM, Ha=
nnes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=
=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 0=
7/03/2014 09:25 PM, Benjamin Marzinski wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On Thu, Jul 03, 2014 at 01:05:37PM +0200, Hannes Reinecke wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 07/02/2014 09:48 PM, Benjamin Marzinski wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On Wed, Jul 02, 2014 at 08:03:38AM +0200, Hannes Reinecke wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 07/01/2014 09:22 PM, Christophe Varoqui wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hannes,<br>
<br>
would you Ack this one, or do you have some other idea for this in<br>
your tree ?<br>
<br>
</blockquote>
Sigh. The whole multipath / systemd / dracut integration<br>
is _a mess_.<br>
The main problem is that RH and SUSE treat multipath handling differently.<=
br>
(From what I can see. I&#39;ve still a hard time to understand how<br>
=C2=A0 multipath booting works with RH. So there might be errors.)<br>
<br>
RH is taking a restrictive approach, ie it&#39;ll allow only configured<br>
multipath devices during boot. IE it&#39;ll accept only devices present<br>
in &#39;/etc/multipath/wwids&#39; for booting. So when coming across a new<=
br>
wwid multipath won&#39;t be setup there, so of course they&#39;ll need an<b=
r>
additional parameter for that.<br>
</blockquote>
<br>
That&#39;s not strictly true. =C2=A0multipathd will happily create a multip=
ath<br>
device on top of any valid scsi devices it finds, but unless those<br>
devices are in /etc/multipath/wwids, other components, like lvm won&#39;t<b=
r>
know to leave them alone. =C2=A0This actually isn&#39;t an issue during the=
<br>
initramfs boot stages because lvm doesn&#39;t do autoactivation there.<br>
<br>
So, if the device appears in the initramfs portion of boot, we&#39;re great=
.<br>
<br>
The specific issue that prompted this goes like this:<br>
<br>
- The iscsi initiator is not setup to run in the initramfs on install<br>
- Storage is added to the system that makes up a working LV<br>
- Once the machine boots up, and is past the initramfs, the iscsi<br>
initiator starts up and discovers the devices.<br>
- Multipath races with lvmetad and loses<br>
- Now you have a LV built on top of a single path device, instead of<br>
=C2=A0 =C2=A0being multipathed (The LV is on top of a partition of the path=
<br>
=C2=A0 =C2=A0device, so reassign_maps doesn&#39;t work on it)<br>
<br>
If you tell the redhat installer that you want to use multipath, this<br>
causes problems, since it can&#39;t disassemble the an arbitrary stack of<b=
r>
virtual devices. =C2=A0Eventually, we&#39;ll fix that issue, and this won&#=
39;t<br>
matter anymore, because it will just be able to disassemble the virtual<br>
device stack, and rerun multipath, to make everything autoassemble in<br>
the correct order.<br>
<br>
</blockquote>
Hmm. Similar to what I&#39;ve seen here when booting with multipath enabled=
 and<br>
an empty &#39;/etc/multipath/wwids&#39; file.<br>
<br>
We&#39;re having an udev rule calling &#39;multipath -u&#39; to check if th=
e device is<br>
eligible for multipathing. If so it&#39;ll set the various udev properties =
to<br>
keep LVM and others from working with that device.<br>
<br>
But as &#39;multipath -u&#39; is be checking /etc/multipath/wwids it will a=
lways<br>
report &#39;not a multipath device&#39;.<br>
So I would be perfectly happy with &#39;multipath -u&#39; _not_ checking<br=
>
/etc/multipath/wwids (or have a switch for doing so).<br>
</blockquote>
<br>
&#39;multipath -u&#39;? Do you mean &#39;multipath -c&#39;? =C2=A0I do worr=
y that not<br>
checking the wwids file could break things were some device appears<br>
multipathable, but will never successfully get created for reasons<br>
outside of multipath&#39;s knowledge. =C2=A0The wwids file makes sure that =
this<br>
device is multipathable, because it HAS been multipathed before.<br>
<br>
That being said, I have no objections to a switch to avoid the wwid file<br=
>
check.<br>
<br>
</blockquote></div></div>
Okay, I&#39;ve send a patch.<div class=3D""><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Anyway. There is actually a slight inconsistency with the above approach:<b=
r>
Multipath is _not_ setup for autoconfiguration; from my understanding this<=
br>
was exactly why /etc/multipath/wwids was introduced in the first place.<br>
LVM, on the other hand, is trying to do autoconfiguration.<br>
<br>
Why? I would set either both to autoconfiguration or none.<br>
If I want something different I need to configure the system.<br>
</blockquote>
<br>
Well, multipath is only not set up to do autoconfiguration because you<br>
keep objecting to my find_multipaths patch, which makes multipath only<br>
run on devices that have more than one path. With that, you can usually<br>
leave the blacklists alone, and you will only get the devices that you<br>
want.<br>
<br>
</blockquote></div>
Oh, I don&#39;t have any objections to that, provided it&#39;s configurable=
<br>
via the config file.<br>
Care to send a patch for that?<div class=3D""><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Can you clarify what the intended usage for /etc/multipath/wwids is?<br>
I was under the impression that it&#39;s been introduced to keep<br>
multipath from accepting unconfigured devices ...<br>
</blockquote>
<br>
Like I mentioned above, it was added to avoid the situations where<br>
multipath isn&#39;t blacklisted on a device, but is unable to set up on it.=
<br>
We use this to so that &#39;multipath -c&#39; doesn&#39;t claim a device an=
d keep<br>
lvm or md from using it when it shouldn&#39;t.<br>
<br>
</blockquote></div>
Ah, I&#39;ve been luckier than you, then.<br>
I keep telling folks that multipath will grab all devices, and the only way=
 to modify this is blacklisting devices via /etc/multipath.conf.<br>
So any system where the above happens is per definition misconfigured :-)<b=
r>
<br>
Christophe, what happened to the patches you&#39;ve said to have applied? I=
 haven&#39;t seen them showing up in the git repository ...<div class=3D"HO=
EnZb"><div class=3D"h5"><br>
<br>
Cheers,<br>
<br>
Hannes<br>
-- <br>
Dr. Hannes Reinecke =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 zSeries &amp; Storage<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a> =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0<a href=3D"tel:%2B49%20911%2074053%20688" value=3D"+4991174053688=
" target=3D"_blank">+49 911 74053 688</a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)<br=
>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/<u></u>mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--089e01161982888a8104fd58d957--


--===============5882177361595952967==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5882177361595952967==--
