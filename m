From: John Strange <johnstra10@gmail.com>
Subject: Re: noob usage question
Date: Fri, 9 Aug 2013 20:19:24 -0600
Message-ID: <CAH1aXXZHc8rYQUfbQsAXgrjrryLvZb-NfyTEdTx+a9oJSHwc-g@mail.gmail.com>
References: <CAH1aXXbG68BSLqvZeoANUkVykcBnNnTfnPqYbCVke89kBU_WTQ@mail.gmail.com>
	<34D36EB6-401C-4825-8D1E-B277EDD39ACF@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5927404661709480009=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <34D36EB6-401C-4825-8D1E-B277EDD39ACF@redhat.com>
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

--===============5927404661709480009==
Content-Type: multipart/alternative; boundary=047d7b2e141b1b749404e38e85f3

--047d7b2e141b1b749404e38e85f3
Content-Type: text/plain; charset=ISO-8859-1

Yes, I think I do want to create partitions.  My expectation is to create a
mapping based on one or more raw physical device (luns).  There are a
number features I would like implement behind my mapping target driver.  My
understanding is that I can treat the mapping (the target device) as if it
were a raw disk and that I can format it as appropriate for whatever
workload will use it.

For instance... I need to present a device (it would appear to the OS as a
raw block device) composed of ranges of blocks from different devices -
spinning media, ssd, PCIe flash, etc.  My target driver can guarantee a QOS
(throughput, latency, combo) and it will service read requests across the
range of physical media comprising the target.

This target device would appear to the OS as a block device.  The workload
that uses the device might require a filesystem on it, so I need to mount a
FS.

That's what I'm aiming for.  I ran into problems trying to format my target
device so I created a linear mapping and it behaved the same way... could
not put a partition on it or format it.

-john


On Fri, Aug 9, 2013 at 4:22 PM, Brassow Jonathan <jbrassow@redhat.com>wrote:

>
> On Aug 9, 2013, at 4:01 PM, John Strange wrote:
>
> > When I create a linear target, I can't create partitions or format the
> mapped drive.  I get an invalid parameter argument for an ioctl.  I'm
> obviously doing something stupid.  What do I need to do to create
> partitions, format, mount a dm-n?
>
> You don't want to create partitions, do you?
>
> Just create an mapping and use it.  If you need another, create another.
>  Need to remove one, just remove it.
>
> Also, I'm assuming you want to use device-mapper.  If you want persistent
> devices (ones that stick around after a reboot), you may wish to use LVM.
>
>  brassow
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--047d7b2e141b1b749404e38e85f3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Yes, I think I do want to create parti=
tions.=A0 My expectation is to create a mapping based on one or more raw ph=
ysical device (luns).=A0 There are a number features I would like implement=
 behind my mapping target driver.=A0 My understanding is that I can treat t=
he mapping (the target device) as if it were a raw disk and that I can form=
at it as appropriate for whatever workload will use it.<br>
<br></div>For instance... I need to present a device (it would appear to th=
e OS as a raw block device) composed of ranges of blocks from different dev=
ices - spinning media, ssd, PCIe flash, etc.=A0 My target driver can guaran=
tee a QOS (throughput, latency, combo) and it will service read requests ac=
ross the range of physical media comprising the target.<br>
<br></div>This target device would appear to the OS as a block device.=A0 T=
he workload that uses the device might require a filesystem on it, so I nee=
d to mount a FS.<br><br></div>That&#39;s what I&#39;m aiming for.=A0 I ran =
into problems trying to format my target device so I created a linear mappi=
ng and it behaved the same way... could not put a partition on it or format=
 it.<br>
<br></div>-john<br></div><div class=3D"gmail_extra"><br><br><div class=3D"g=
mail_quote">On Fri, Aug 9, 2013 at 4:22 PM, Brassow Jonathan <span dir=3D"l=
tr">&lt;<a href=3D"mailto:jbrassow@redhat.com" target=3D"_blank">jbrassow@r=
edhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im"><br>
On Aug 9, 2013, at 4:01 PM, John Strange wrote:<br>
<br>
&gt; When I create a linear target, I can&#39;t create partitions or format=
 the mapped drive. =A0I get an invalid parameter argument for an ioctl. =A0=
I&#39;m obviously doing something stupid. =A0What do I need to do to create=
 partitions, format, mount a dm-n?<br>

<br>
</div>You don&#39;t want to create partitions, do you?<br>
<br>
Just create an mapping and use it. =A0If you need another, create another. =
=A0Need to remove one, just remove it.<br>
<br>
Also, I&#39;m assuming you want to use device-mapper. =A0If you want persis=
tent devices (ones that stick around after a reboot), you may wish to use L=
VM.<br>
<br>
=A0brassow<br>
<br>
<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--047d7b2e141b1b749404e38e85f3--


--===============5927404661709480009==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5927404661709480009==--
