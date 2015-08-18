From: Thiago Padilha <tpadilha84@gmail.com>
Subject: Re: Any device mapper target that stores data in files?
Date: Tue, 18 Aug 2015 06:45:07 +0000
Message-ID: <CAAq2XdpJapPakQJ9zyfso6+OfRMCTUSsLmeainXoDQ72TsLeRA@mail.gmail.com>
References: <CAAq2XdoSv34qGewtGKRxUo064dG8mFudxZtw4A_nEUace3KQXQ@mail.gmail.com>
	<CAFx4rwSnVRNvRnwk7CKfxcgHG36HA1HRR07AREd9QhycR89dNQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0647123263251712103=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFx4rwSnVRNvRnwk7CKfxcgHG36HA1HRR07AREd9QhycR89dNQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0647123263251712103==
Content-Type: multipart/alternative; boundary=bcaec501634dcf944e051d90423c

--bcaec501634dcf944e051d90423c
Content-Type: text/plain; charset=UTF-8

The network block device seems like a good fit for what I'm trying to do.

Thanks Doug, I will investigate it.

On Mon, Aug 17, 2015 at 10:51 PM Doug Dumitru <doug@easyco.com> wrote:

> Mr. Padilha,
>
> In general, what you are trying to do is discouraged.  It is possible to
> open and read/write files from kernel space, but the architecture is not
> very portable.  I actually do this all the time, but only for debugging
> traces.
>
> I would recommend another implementation method if you want to implement a
> block device backed by files.  The "Network Block Device" is a project that
> includes a kernel module (nbd.ko) and a user-space server.  The kernel
> module is usable without the user space module and lets you implement a
> decent, multi-threaded, block device completely from user space code.
>
> nbd.ko is reached by opening a master device (which is a character device)
> and then reading/writing commands into the single file handle.  Operations
> are "async" so they multi-thread easily and you can easily implement all of
> the block device functions including new stuff like discard.
>
> Normally, the user-space nature of this would be a performance hit, but if
> you are using the "cloud", the extra latency might not matter much.
>
> Doug Dumitru
> EasyCo LLC
>
>
> On Sun, Aug 16, 2015 at 9:55 PM, Thiago Padilha <tpadilha84@gmail.com>
> wrote:
>
>> Hi
>>
>> First of all, I'm very new on the subject(kernel programming/device
>> mappers/block devices), so forgive if I say anything stupid.
>>
>> I need a device mapper target that stores data in files of fixed sizes,
>> probably defined when the virtual device is first created. For the sake of
>> explanation, lets call this target as "dirdm" and assume there's an
>> userspace tool of the same name that can be used to manage such virtual
>> devices. Now let's say I have an empty directory "/dirdm" and want to
>> create a virtual device with 4k "block size" on top of it:
>>
>>     dirdm create --size 10G --block-size 4k /dirdm
>>
>> After this command is executed, there's a new file with 4k size at
>> /dirdm/0. This file will be used to store the first block of the device.
>> Here are the filenames that represent some blocks of this virtual device:
>>
>> - block 0: 0
>> - block 1: 4096
>> - block 2 8192
>> - block 3: 12288
>> - block 4: 16384
>>
>> That is, each block is stored in a file named after the first byte on the
>> block. Querying a block that has no data written will simply return 0(block
>> files are also initialized with 0), so it behaves like a sparse block
>> device.
>>
>> Is there any device mapper implementation that manages data in a similar
>> manner? Note that these details about filenames or directory structure are
>> not important, all I care about is that the dm target splits data in
>> relatively small files on a directory.
>>
>> The reason for these requirements is to be able to efficiently store
>> arbitrary block devices in a cloud storage service such a google
>> drive/onedrive without syncing a big loop device on every modification(Only
>> files representing affected blocks are modified). One useful application
>> would be to create a big device(such as 100g size) and add luks/ext4 on top
>> of it, which would be a great way to store private data.
>>
>> If there are no existing dm targets matching these requirements, what
>> would be a recommended reading/documentation to get started on implementing
>> this on my own?
>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>
>
>
> --
> Doug Dumitru
> EasyCo LLC
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--bcaec501634dcf944e051d90423c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The network block device seems like a good fit for what I&=
#39;m trying to do.<br><br>Thanks Doug, I will investigate it.<br><br><div =
class=3D"gmail_quote"><div dir=3D"ltr">On Mon, Aug 17, 2015 at 10:51 PM Dou=
g Dumitru &lt;<a href=3D"mailto:doug@easyco.com">doug@easyco.com</a>&gt; wr=
ote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:s=
mall">Mr. Padilha,<br><br></div><div class=3D"gmail_default" style=3D"font-=
family:arial,helvetica,sans-serif;font-size:small">In general, what you are=
 trying to do is discouraged.=C2=A0 It is possible to open and read/write f=
iles from kernel space, but the architecture is not very portable.=C2=A0 I =
actually do this all the time, but only for debugging traces.<br><br></div>=
<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-seri=
f;font-size:small">I would recommend another implementation method if you w=
ant to implement a block device backed by files.=C2=A0 The &quot;Network Bl=
ock Device&quot; is a project that includes a kernel module (nbd.ko) and a =
user-space server.=C2=A0 The kernel module is usable without the user space=
 module and lets you implement a decent, multi-threaded, block device compl=
etely from user space code.<br><br></div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif;font-size:small">nbd.ko is reach=
ed by opening a master device (which is a character device) and then readin=
g/writing commands into the single file handle.=C2=A0 Operations are &quot;=
async&quot; so they multi-thread easily and you can easily implement all of=
 the block device functions including new stuff like discard.<br></div><div=
 class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;fo=
nt-size:small"><br></div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif;font-size:small">Normally, the user-space nature=
 of this would be a performance hit, but if you are using the &quot;cloud&q=
uot;, the extra latency might not matter much.<br><br></div><div class=3D"g=
mail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:sma=
ll">Doug Dumitru<br></div><div class=3D"gmail_default" style=3D"font-family=
:arial,helvetica,sans-serif;font-size:small">EasyCo LLC<br><br></div></div>=
<div class=3D"gmail_extra"><br><div class=3D"gmail_quote"></div></div><div =
class=3D"gmail_extra"><div class=3D"gmail_quote">On Sun, Aug 16, 2015 at 9:=
55 PM, Thiago Padilha <span dir=3D"ltr">&lt;<a href=3D"mailto:tpadilha84@gm=
ail.com" target=3D"_blank">tpadilha84@gmail.com</a>&gt;</span> wrote:<br></=
div></div><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex"><div dir=3D"ltr"><div><div><div><div><div><div>Hi<br><b=
r></div><div>First of all, I&#39;m very new on the subject(kernel programmi=
ng/device mappers/block devices), so forgive if I say anything stupid.<br><=
br></div>I need a device mapper target that stores data in files of fixed s=
izes, probably defined when the virtual device is first created. For the sa=
ke of explanation, lets call this target as &quot;dirdm&quot; and assume th=
ere&#39;s an userspace tool of the same name that can be used to manage suc=
h virtual devices. Now let&#39;s say I have an empty directory &quot;/dirdm=
&quot; and want to create a virtual device with 4k &quot;block size&quot; o=
n top of it:<br><br></div>=C2=A0=C2=A0=C2=A0 dirdm create --size 10G --bloc=
k-size 4k /dirdm<br><br></div>After this command is executed, there&#39;s a=
 new file with 4k size at /dirdm/0. This file will be used to store the fir=
st block of the device. Here are the filenames that represent some blocks o=
f this virtual device:<br><br></div>- block 0: 0<br></div>- block 1: 4096<b=
r></div>- block 2 8192<br><div><div><div><div>- block 3: 12288<br></div><di=
v>- block 4: 16384<br><br></div><div>That is, each block is stored in a fil=
e named after the first byte on the block. Querying a block that has no dat=
a written will simply return 0(block files are also initialized with 0), so=
 it behaves like a sparse block device.<br><br></div><div>Is there any devi=
ce mapper implementation that manages data in a similar manner? Note that t=
hese details about filenames or directory structure are not important, all =
I care about is that the dm target splits data in relatively small files on=
 a directory.<br><br></div><div>The reason for these requirements is to be =
able to efficiently store arbitrary block devices in a cloud storage servic=
e such a google drive/onedrive without syncing a big loop device on every m=
odification(Only files representing affected blocks are modified). One usef=
ul application would be to create a big device(such as 100g size) and add l=
uks/ext4 on top of it, which would be a great way to store private data.<br=
></div><div><br></div><div>If there are no existing dm targets matching the=
se requirements, what would be a recommended reading/documentation to get s=
tarted on implementing this on my own?<br></div><div></div><div><br></div><=
/div></div></div></div>
<br></blockquote></div></div><div class=3D"gmail_extra"><div class=3D"gmail=
_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex">--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br><br clear=3D"all"><br>-- <br><div>Doug Dumitru<b=
r>EasyCo LLC<br></div>
</div>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
</blockquote></div></div>

--bcaec501634dcf944e051d90423c--


--===============0647123263251712103==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0647123263251712103==--
