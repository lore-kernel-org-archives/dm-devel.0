From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: CVS pull of device mapper
Date: Mon, 30 Jul 2007 15:46:59 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC012B3964@orsmsx418.amr.corp.intel.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC012B390C@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC012B390C@orsmsx418.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

>-----Original Message-----
>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On
>Behalf Of Wood, Brian J
>Sent: Monday, July 30, 2007 3:21 PM
>To: device-mapper development
>Subject: RE: [dm-devel] CVS pull of device mapper
>
>
>
>Brian Wood
>Intel Corporation
>Digital Enterprise Group
>Manageability & Platform Software Division
>brian.j.wood@intel.com
>
>>-----Original Message-----
>>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
>On
>>Behalf Of Mike Snitzer
>>Sent: Monday, July 30, 2007 2:50 PM
>>To: device-mapper development
>>Subject: Re: [dm-devel] CVS pull of device mapper
>>
>>On 7/30/07, Wood, Brian J <brian.j.wood@intel.com> wrote:
>>> Hello everyone, I've just built a test system with Fedora 7 and am
>>> having a problem with running dmeventd after getting the latest pull
>>> from the CVS tree. From the "make" and "make install" commands
>>> everything is error free, but when I run the dmeventd daemon I get
>this
>>> error:
>>>
>>> /sbin/dmeventd: error while loading shared libraries:
>>> libdevmapper-event.so.1.02: cannot open shared object file: No such
>file
>>> or directory
>>>
>>> I've looked in /lib and there is an instance of
>>> libdevmapper-event.so.1.02 (and a symbolic link named
>>> libdevmapper-event.so), so I'm confused as to why the daemon can't
>find
>>> them? When I run configure the only parameters I'm passing in are
>>> "--enable-debug" and "--enable-dmeventd"
>>
>>Try using ldconfig (-v can be useful) and ldd /sbin/dmeventd
>>
>
>I exported the variable LD_DEBUG=3Dall and found that it's searching the
>/lib64 libraries for the .so (which it should since this is a F7 x86_64
>load). Here is a dump of the output:
>
>/sbin/dmeventd
>      3127:
>      3127:     file=3Dlibdl.so.2 [0];  needed by /sbin/dmeventd [0]
>      3127:     find library=3Dlibdl.so.2 [0]; searching
>      3127:      search cache=3D/etc/ld.so.cache
>      3127:       trying file=3D/lib64/libdl.so.2
>      3127:
>      3127:     file=3Dlibdl.so.2 [0];  generating link map
>      3127:       dynamic: 0x0000003c7ba02da0  base: 0x0000000000000000
>size: 0x0000000000203100
>      3127:         entry: 0x0000003c7b800e10  phdr: 0x0000003c7b800040
>phnum:                  9
>      3127:
>      3127:
>      3127:     file=3Dlibdevmapper.so.1.02 [0];  needed by
/sbin/dmeventd
>[0]
>      3127:     find library=3Dlibdevmapper.so.1.02 [0]; searching
>      3127:      search cache=3D/etc/ld.so.cache
>      3127:       trying file=3D/lib64/libdevmapper.so.1.02
>      3127:
>      3127:     file=3Dlibdevmapper.so.1.02 [0];  generating link map
>      3127:       dynamic: 0x0000003c83011038  base: 0x0000000000000000
>size: 0x00000000002128c8
>      3127:         entry: 0x0000003c82e039f0  phdr: 0x0000003c82e00040
>phnum:                  5
>      3127:
>      3127:
>      3127:     file=3Dlibpthread.so.0 [0];  needed by /sbin/dmeventd [0=
]
>      3127:     find library=3Dlibpthread.so.0 [0]; searching
>      3127:      search cache=3D/etc/ld.so.cache
>      3127:       trying file=3D/lib64/libpthread.so.0
>      3127:
>      3127:     file=3Dlibpthread.so.0 [0];  generating link map
>      3127:       dynamic: 0x0000003c7d614db0  base: 0x0000000000000000
>size: 0x0000000000219370
>      3127:         entry: 0x0000003c7d405720  phdr: 0x0000003c7d400040
>phnum:                  9
>      3127:
>      3127:
>      3127:     file=3Dlibdevmapper-event.so.1.02 [0];  needed by
>/sbin/dmeventd [0]
>      3127:     find library=3Dlibdevmapper-event.so.1.02 [0]; searching
>      3127:      search cache=3D/etc/ld.so.cache
>      3127:      search
>path=3D/lib64/tls/x86_64:/lib64/tls:/lib64/x86_64:/lib64:/usr/lib64/tls/=
x
8
>6_64:/usr/lib64/tls:/usr/lib64/x86_64:/usr/lib64(system search path)
>      3127:       trying
>file=3D/lib64/tls/x86_64/libdevmapper-event.so.1.02
>      3127:       trying file=3D/lib64/tls/libdevmapper-event.so.1.02
>      3127:       trying file=3D/lib64/x86_64/libdevmapper-event.so.1.02
>      3127:       trying file=3D/lib64/libdevmapper-event.so.1.02
>      3127:       trying
>file=3D/usr/lib64/tls/x86_64/libdevmapper-event.so.1.02
>      3127:       trying file=3D/usr/lib64/tls/libdevmapper-event.so.1.0=
2
>      3127:       trying
>file=3D/usr/lib64/x86_64/libdevmapper-event.so.1.02
>      3127:       trying file=3D/usr/lib64/libdevmapper-event.so.1.02
>      3127:
>/sbin/dmeventd: error while loading shared libraries:
>libdevmapper-event.so.1.02: cannot open shared object file: No such
file
>or directory
>
>
>One thing I noticed when building/installing was that my .so is being
put
> into /lib in the stdout messages?
>
>Two questions:
>
>1. How come my ld.so.cache doesn't have this to be searched if the make
>file is putting it there?
>
>2. Why didn't this problem occur on my FC6 x86_64 system? Both were
just
>out of the box systems, so did something change in F7 that I didn't
>realize.
>
>Thanks for the help on this puzzling issue :)
>

In digging in the .configure file I see that the variable "libdir" is
set to /lib if "exec_prefix" is sent in empty. Being completely new to
Linux .configure files (I hope this assumption is on the right track),
but shouldn't there be a check here if we're on an x86_64 system to make
sure the .so is put into the right search directory? Or is there
somewhere that ldconfig should be called to setup the cache? This is
actually pretty interesting and I would love to find out how to diagnose
this if someone is willing to explain it to me :)

Thank you

>>--
>>dm-devel mailing list
>>dm-devel@redhat.com
>>https://www.redhat.com/mailman/listinfo/dm-devel
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
