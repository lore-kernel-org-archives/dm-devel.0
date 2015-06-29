From: Doug Dumitru <doug@easyco.com>
Subject: Re: Device Mapper Persistent Configuration
Date: Mon, 29 Jun 2015 07:22:49 -0700
Message-ID: <CAFx4rwSWYMNmcZZvb__csTY8jyv+s7Zyep+0mOystDEFOGk6AA@mail.gmail.com>
References: <DUB115-W79BBA138E7A868AB8AA5696AA0@phx.gbl>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5662005253367836880=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DUB115-W79BBA138E7A868AB8AA5696AA0@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Gili B <gilib123@hotmail.com>
List-Id: dm-devel.ids

--===============5662005253367836880==
Content-Type: multipart/alternative; boundary=089e0111d57cc7cc9f0519a8d4a5

--089e0111d57cc7cc9f0519a8d4a5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gili,

For some reason, reply-all did not pick up your email address.  My mistake.

1)  This is usually done from user space.  User space programs can run
really early.  mdadm does this to start software raid sets.  It is probably
possible to scan devices from the module, but a lot of stuff may not be
there yet if you statically load it.  device-mapper block devices are
allowed to "stack", so one of your constituent devices could be /dev/md0,
or crypt target, or a network mount, or who knows.

In terms of "how early" your user space program can run, the answer is that
it can run from initrd before the root file system is even mounted
read/write.

2)  Creating stuff in proc has a number of articles on-line.  I don't have
a link handy right now.  One thing to watch out for is that the proc
interface changed pretty radically in 3.10.0.  Before this, files uses a
simple buffer API.  After this, file use the stock system sequential file
API.  The buffer API had an edge condition deadlock, thus the change.

The "pieces" are proc_mkdir(...) to create a directory (pretty simple), and
here are helper functions from some of my code to create and delete an
actual proc "file".  Note that this code does not use function prototypes,
so RdFn and WtFn should actually be prototyped as:

int ProcRead_vars_stream(struct seq_file *m, void *dev, void *pv)

I use "dev" as a pointer to the "device context" that device mapper uses to
track instances.  Device context is actually a windows driver term for
block filters, which are the analog of a device mapper block filter.  "pv"
is a pointer to more local data.  This can let you write a single proc
handler function, but give it multiple tasks based on the data parameter.

This code is from a really big and convoluted module, so I can't give you
much more of it.


void * _shim_create_proc_seq_entry(char *name, void *parent, int mode, void
*RdFn, void *WtFn, void *dev, void *data, u64 MaxIdx)

{
    struct _PROC_RES *r;

    if ( !( r =3D kzalloc(sizeof(*r), GFP_KERNEL) ) ) return NULL;

    r->file_ops.owner    =3D THIS_MODULE;

    strcpy(r->name, name);
    r->mode       =3D mode;
    r->RdFn       =3D RdFn;
    r->ShowFn     =3D RdFn;
    r->WtFn       =3D WtFn;
    r->dev        =3D dev;
    r->data       =3D data;
    r->ProcParent =3D parent;
    r->MaxIdx     =3D MaxIdx;

    switch ( mode ) {
        case 0 :            // Read only - single access
            r->file_ops.open    =3D _shim_proc_open;
            r->file_ops.read    =3D seq_read;
            r->file_ops.llseek  =3D seq_lseek;
            r->file_ops.release =3D single_release;
            r->ProcHandle =3D proc_create_data(r->name, 0, parent,
&r->file_ops, r);
            break;
        case 1 :            // Read only - multiple access
            r->file_ops.open    =3D _shim_proc_open_mul;
            r->file_ops.read    =3D seq_read;
            r->file_ops.llseek  =3D seq_lseek;
            r->file_ops.release =3D seq_release;

            r->seq_ops.start =3D _shim_proc_seq_start;
            r->seq_ops.next  =3D _shim_proc_seq_next;
            r->seq_ops.stop  =3D _shim_proc_seq_stop;
            r->seq_ops.show  =3D _shim_proc_seq_show;

            r->ProcHandle =3D proc_create_data(r->name, 0, parent,
&r->file_ops, r);
            break;
        case 2 :            // Write only
            BUG();
            break;
        case 3 :            // Read write - single access
            r->file_ops.open    =3D _shim_proc_open;
            r->file_ops.read    =3D seq_read;
            r->file_ops.write   =3D _shim_proc_seq_write;
            r->file_ops.llseek  =3D seq_lseek;
            r->file_ops.release =3D single_release;
            r->ProcHandle =3D proc_create_data(r->name, 0644, parent,
&r->file_ops, r);
            break;
    }

    return r;
}

void _shim_remove_proc_seq_entry(void *data)

{
    struct _PROC_RES    *r =3D data;

    remove_proc_entry(r->name, r->ProcParent);
    kfree(r);
}


On Sun, Jun 28, 2015 at 11:42 PM, Gili B <gilib123@hotmail.com> wrote:

> Hi
> I didnt receive the email below, so I've copied and pasted it from the
> archive , sory .
>
> Thanks for the reply ..
> I have a few followup quesions:
> 1) If I use a special signature to identify disks, like in mdraid, why
> must I have a user space tool to discover disks?
> If I want all volumes up and ready during a reboot, I prefer that the
> module do it when it loads.
> A user space program will start too late in the boot process.
> 2)Can you point me to some guide on how to export stuff in proc ?
>
> Thanks
> -gili
>
>
>  On Sun, Jun 28, 2015 at 8:21 AM, Gili B <gilib123 hotmail com> wrote:
>
> hi
>> We are starting working on a new device mapper module which has targets
>> similar
>> to the ones in thin module (pool and thin),  but it adds some additional
>> features.
>> The user should be able to create and use file systems on the thin
>> volumes.
>> I wanted to know what is the recommended  way to make the configuration
>> with dmsetup
>> persistent ?
>>
>
> =E2=80=8BYou should probably use mdraid as an inspiration.  Put a signatu=
re block
> on every member device.  You can then write a user-space tool to scan
> devices and find the collections.  Be sure to use a good "signature" for
> your type of device, plus a good UUID signature so that different
> generations can be identified.
> =E2=80=8B
>
>
>> We want that all file systems will be available after reboot.
>>
>
> =E2=80=8BIf you get the device running early enough, then fstab should be=
 able to
> mount file systems.
> =E2=80=8B
>
>
>> Should we write our own configuration tool?  should we add special
>> configuration files?
>>
>
> =E2=80=8BYou will probably need a user-space tool.  You can probably get =
away with
> no configuration file, but you should again use mdraid as inspiration so
> that your user-space tool gets limits of where to look for member pieces.
> =E2=80=8B
>
>
>> Should the kernel module we write , automatically discover all the
>> configration and initialize accordingly?
>>
>>
>> Regarding debug - Is there a generic way to run dmsetup for example that
>> prints some inside details on the targets? (for example number of
>> outstanding ios, memory used etc)
>>
>
> =E2=80=8BYou can do this three ways.  1)  build in IOCTL into your module=
 that can
> query stuff.  2) export stuff in /sys.  3) export stuff in /proc.  I
> personally like exporting debug stuff into /proc.  Remember that printk i=
s
> your friend.  I have even created "command" file in proc that then dump
> debug information with printk.  If you use /proc, you need to handle
> multiple instances of your mapper.  I use
> /proc/{my_project_name}/{instance_name}/...
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Doug Dumitru
EasyCo LLC

--089e0111d57cc7cc9f0519a8d4a5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Gili,<br><br></div><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">F=
or some reason, reply-all did not pick up your email address.=C2=A0 My mist=
ake.<br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,h=
elvetica,sans-serif;font-size:small">1)=C2=A0 This is usually done from use=
r space.=C2=A0 User space programs can run really early.=C2=A0 mdadm does t=
his to start software raid sets.=C2=A0 It is probably possible to scan devi=
ces from the module, but a lot of stuff may not be there yet if you statica=
lly load it.=C2=A0 device-mapper block devices are allowed to &quot;stack&q=
uot;, so one of your constituent devices could be /dev/md0, or crypt target=
, or a network mount, or who knows.<br><br></div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">In term=
s of &quot;how early&quot; your user space program can run, the answer is t=
hat it can run from initrd before the root file system is even mounted read=
/write.<br><br></div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif;font-size:small">2)=C2=A0 Creating stuff in proc has=
 a number of articles on-line.=C2=A0 I don&#39;t have a link handy right no=
w.=C2=A0 One thing to watch out for is that the proc interface changed pret=
ty radically in 3.10.0.=C2=A0 Before this, files uses a simple buffer API.=
=C2=A0 After this, file use the stock system sequential file API.=C2=A0 The=
 buffer API had an edge condition deadlock, thus the change.<br><br></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
;font-size:small">The &quot;pieces&quot; are proc_mkdir(...) to create a di=
rectory (pretty simple), and here are helper functions from some of my code=
 to create and delete an actual proc &quot;file&quot;.=C2=A0 Note that this=
 code does not use function prototypes, so RdFn and WtFn should actually be=
 prototyped as:<br><br>int ProcRead_vars_stream(struct seq_file *m, void *d=
ev, void *pv)<br><br></div><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif;font-size:small">I use &quot;dev&quot; as a po=
inter to the &quot;device context&quot; that device mapper uses to track in=
stances.=C2=A0 Device context is actually a windows driver term for block f=
ilters, which are the analog of a device mapper block filter.=C2=A0 &quot;p=
v&quot; is a pointer to more local data.=C2=A0 This can let you write a sin=
gle proc handler function, but give it multiple tasks based on the data par=
ameter.<br></div><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small"><br></div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;font-size:small">This code =
is from a really big and convoluted module, so I can&#39;t give you much mo=
re of it.<br></div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif;font-size:small"><br><br></div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">void=
 * _shim_create_proc_seq_entry(char *name, void *parent, int mode, void *Rd=
Fn, void *WtFn, void *dev, void *data, u64 MaxIdx)<br><br>{<br>=C2=A0=C2=A0=
=C2=A0 struct _PROC_RES *r;<br><br>=C2=A0=C2=A0=C2=A0 if ( !( r =3D kzalloc=
(sizeof(*r), GFP_KERNEL) ) ) return NULL;<br><br>=C2=A0=C2=A0=C2=A0 r-&gt;f=
ile_ops.owner=C2=A0=C2=A0=C2=A0 =3D THIS_MODULE;<br><br>=C2=A0=C2=A0=C2=A0 =
strcpy(r-&gt;name, name);<br>=C2=A0=C2=A0=C2=A0 r-&gt;mode=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =3D mode;<br>=C2=A0=C2=A0=C2=A0 r-&gt;RdFn=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D RdFn;<br>=C2=A0=C2=A0=C2=A0 r-&gt;ShowFn=C2=
=A0=C2=A0=C2=A0=C2=A0 =3D RdFn;<br>=C2=A0=C2=A0=C2=A0 r-&gt;WtFn=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D WtFn;<br>=C2=A0=C2=A0=C2=A0 r-&gt;dev=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D dev;<br>=C2=A0=C2=A0=C2=A0 r-&gt;d=
ata=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D data;<br>=C2=A0=C2=A0=C2=A0 r-&=
gt;ProcParent =3D parent;<br>=C2=A0=C2=A0=C2=A0 r-&gt;MaxIdx=C2=A0=C2=A0=C2=
=A0=C2=A0 =3D MaxIdx;<br><br>=C2=A0=C2=A0=C2=A0 switch ( mode ) {<br>=C2=A0=
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 case 0 :=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 // Read only - single access<br>=C2=A0=C2=A0=C2=A0 =
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;file_ops.open=C2=A0=C2=A0=C2=A0=
 =3D _shim_proc_open;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 r-&gt;file_ops.read=C2=A0=C2=A0=C2=A0 =3D seq_read;<br>=C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;file_ops.llseek=C2=A0 =
=3D seq_lseek;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =
r-&gt;file_ops.release =3D single_release;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;ProcHandle =3D proc_create_data(r-&gt;na=
me, 0, parent, &amp;r-&gt;file_ops, r);<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0=C2=A0 break;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 c=
ase 1 :=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 // Read onl=
y - multiple access<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 r-&gt;file_ops.open=C2=A0=C2=A0=C2=A0 =3D _shim_proc_open_mul;<br>=
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;file_ops.rea=
d=C2=A0=C2=A0=C2=A0 =3D seq_read;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =
=C2=A0=C2=A0=C2=A0 r-&gt;file_ops.llseek=C2=A0 =3D seq_lseek;<br>=C2=A0=C2=
=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;file_ops.release =3D =
seq_release;<br><br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 r-&gt;seq_ops.start =3D _shim_proc_seq_start;<br>=C2=A0=C2=A0=C2=A0 =C2=
=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;seq_ops.next=C2=A0 =3D _shim_proc_=
seq_next;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt=
;seq_ops.stop=C2=A0 =3D _shim_proc_seq_stop;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;seq_ops.show=C2=A0 =3D _shim_proc_seq=
_show;<br><br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&g=
t;ProcHandle =3D proc_create_data(r-&gt;name, 0, parent, &amp;r-&gt;file_op=
s, r);<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 break;<b=
r>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 case 2 :=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 // Write only<br>=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 BUG();<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0=C2=A0 break;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 c=
ase 3 :=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 // Read wri=
te - single access<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 r-&gt;file_ops.open=C2=A0=C2=A0=C2=A0 =3D _shim_proc_open;<br>=C2=A0=C2=
=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;file_ops.read=C2=A0=
=C2=A0=C2=A0 =3D seq_read;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0 r-&gt;file_ops.write=C2=A0=C2=A0 =3D _shim_proc_seq_write;<br>=
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;file_ops.lls=
eek=C2=A0 =3D seq_lseek;<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0 r-&gt;file_ops.release =3D single_release;<br>=C2=A0=C2=A0=C2=A0 =
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 r-&gt;ProcHandle =3D proc_create_data=
(r-&gt;name, 0644, parent, &amp;r-&gt;file_ops, r);<br>=C2=A0=C2=A0=C2=A0 =
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 break;<br>=C2=A0=C2=A0=C2=A0 }<br><br=
>=C2=A0=C2=A0=C2=A0 return r;<br>}<br><br>void _shim_remove_proc_seq_entry(=
void *data)<br><br>{<br>=C2=A0=C2=A0=C2=A0 struct _PROC_RES=C2=A0=C2=A0=C2=
=A0 *r =3D data;<br><br>=C2=A0=C2=A0=C2=A0 remove_proc_entry(r-&gt;name, r-=
&gt;ProcParent);<br>=C2=A0=C2=A0=C2=A0 kfree(r);<br>}<br></div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-siz=
e:small"><br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail=
_quote">On Sun, Jun 28, 2015 at 11:42 PM, Gili B <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:gilib123@hotmail.com" target=3D"_blank">gilib123@hotmail.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">


<div><div dir=3D"ltr">Hi<br>I didnt receive the email below, so I&#39;ve co=
pied and pasted it from the archive , sory .<br>=C2=A0<br>Thanks for the re=
ply ..<br>I have a few followup quesions:<br>1) If I use a special signatur=
e to identify disks, like in mdraid, why must I have a user space tool to d=
iscover disks?<br>If I want all volumes up and ready during a reboot, I pre=
fer that the module do it when it loads.<br>A user space program will start=
 too late in the boot process.<br>2)Can you point me to some guide on how t=
o export stuff in proc ?<br>=C2=A0<br>Thanks<span class=3D"HOEnZb"><font co=
lor=3D"#888888"><br>-gili</font></span><div><div class=3D"h5"><br>=C2=A0<br=
>=C2=A0On Sun, Jun 28, 2015 at 8:21 AM, Gili B <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:gilib123%20hotmail%20com" rel=3D"nofollow" target=3D"_blank">gi=
lib123 hotmail com</a>&gt;</span> wrote:<br><br><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-color=
:rgb(204,204,204);border-left-width:1px;border-left-style:solid"><div><div =
dir=3D"ltr">hi<br>We are starting working on a new device mapper module whi=
ch=C2=A0has targets similar<br>to the ones in thin module (pool and thin),=
=C2=A0 but it adds some additional features.<br>The user should be able to =
create and use file systems on the thin volumes.<br>I wanted to know what=
=C2=A0is the recommended =C2=A0way to make the configuration with dmsetup<b=
r>persistent ?<br></div></div></blockquote><div><br><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;displ=
ay:inline">=E2=80=8BYou should probably use mdraid as an inspiration.=C2=A0=
 Put a signature block on every member device.=C2=A0 You can then write a u=
ser-space tool to scan devices and find the collections.=C2=A0 Be sure to u=
se a good &quot;signature&quot; for your type of device, plus a good UUID s=
ignature so that different generations can be identified.<br>=E2=80=8B</div=
>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;padding-left:1ex;border-left-color:rgb(204,204,204);border-left-width=
:1px;border-left-style:solid"><div><div dir=3D"ltr">We=C2=A0want that all f=
ile systems will be available after reboot.<br></div></div></blockquote><di=
v><br><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,san=
s-serif;font-size:small;display:inline">=E2=80=8BIf you get the device runn=
ing early enough, then fstab should be able to mount file systems.<br>=E2=
=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;padding-left:1ex;border-left-color:rgb(204,204,204);border=
-left-width:1px;border-left-style:solid"><div><div dir=3D"ltr">Should we wr=
ite our own configuration tool? =C2=A0should we add special configuration f=
iles?<br></div></div></blockquote><div><br><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inline=
">=E2=80=8BYou will probably need a user-space tool.=C2=A0 You can probably=
 get away with no configuration file, but you should again use mdraid as in=
spiration so that your user-space tool gets limits of where to look for mem=
ber pieces.<br>=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-color:rgb(2=
04,204,204);border-left-width:1px;border-left-style:solid"><div><div dir=3D=
"ltr">Should the kernel module we write , automatically discover all the co=
nfigration and initialize accordingly?<br>=C2=A0<br>=C2=A0<br>Regarding deb=
ug - Is there a generic way to run dmsetup for example that<br>prints some =
inside details on the targets? (for example number of outstanding ios, memo=
ry used etc)<br></div></div></blockquote><div><br><div class=3D"gmail_defau=
lt" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;display=
:inline">=E2=80=8BYou can do this three ways.=C2=A0 1)=C2=A0 build in IOCTL=
 into your module that can query stuff.=C2=A0 2) export stuff in /sys.=C2=
=A0 3) export stuff in /proc.=C2=A0 I personally like exporting debug stuff=
 into /proc.=C2=A0 Remember that printk is your friend.=C2=A0 I have even c=
reated &quot;command&quot; file in proc that then dump debug information wi=
th printk.=C2=A0 If you use /proc, you need to handle multiple instances of=
 your mapper.=C2=A0 I use /proc/{my_project_name}/{instance_name}/...<br></=
div></div><div><div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif;font-size:small;display:inline">=C2=A0</div></div><div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;f=
ont-size:small;display:inline">=C2=A0</div></div> 		 	   		  </div></div></=
div></div>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail=
_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--089e0111d57cc7cc9f0519a8d4a5--


--===============5662005253367836880==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5662005253367836880==--
