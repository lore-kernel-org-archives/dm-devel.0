From: "Child, David" <David.Child@ps.net>
Subject: RE: Multipathing with RHEL4 U2 on EMC DMX
Date: Mon, 13 Feb 2006 10:53:53 -0600
Message-ID: <2CF4E90F20CF3C4DBD3A71BD9FA2758D122F77@PSCDALPEXCH03.perotsystems.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

A quick update; I noticed that the string I was using to create the
multipath device was actually for a failover setup, not multibus. I had
been using:

   # echo "0 141419520 multipath 0 0 2 1 round-robin 0 1 1 8:48 1000
round-robin 0 1 1 8:176 1000" | dmsetup create dm2

From what I can see on Christophe's wiki it should have been the
following to get a multibus configuration:

   # echo "0 141419520 multipath 0 0 1 1 round-robin 0 2 1 8:48 1000
8:176 1000" | dmsetup create dm2

The output of 'multipath -l' for this device now appears as;

   dm2 ()
   [size=3D67 GB][features=3D"0"][hwhandler=3D"0"]
   \_ round-robin 0 [enabled]
    \_ 0:0:0:6  sdd 8:48  [active][ready]
    \_ 1:0:0:6  sdl 8:176 [active][ready]

I'm not sure if this will fix any of my issues (primarily the LUN
dropping off), but wanted to send in this update since my original post
had mentioned that I had been thinking about using "failover" instead of
"multibus". In reality I was using "failover". I'll see how it goes with
my multibus setup, but I'm still curious how you get the settings in
/etc/multipath to work. I tried changing the values under the "defaults"
section for 'scsi_id' as seen below, but it still keeps using the same
command as before.


Update: Setting this device for 'multibus' (as listed above) seemed to
make matters worse. Quickly after running any I/O over the multipath
device knocked it offline. I put it back to my original setup (using the
first string I listed) and was able to write quite a bit of data to the
device before it was knocked offline.

Thanks,
David


David Child
Email  David.Child@ps.net


_____________________________________________=20
From: 	Child, David =20
Sent:	Friday, February 10, 2006 8:48 AM
To:	'dm-devel@redhat.com'
Subject:	[dm-devel] Multipathing with RHEL4 U2 on EMC DMX

Hello,

I've just recently connected some HP BL20p G3 blades running RHEL4 U2 up
to a DMX2000 (via McData switches). We didn't get PowerPath and intended
to use device-mapper multipathing. I was able to get things up for the
most part and get devices defined, but have to do that manually. I've
run into a few issues/concerns that I was hoping someone had run across;

Kernel: 2.6.9-22.Elsmp
Multipath tools: multipath-tools-0.4.6.1-1
Device Mapper: device-mapper-1.01.05-01

1. When running 'multipath -v3' I get errors from the getuid_callout
string; "error calling out scsi_id -g -ppre-spc3-83 -u -s /block/sdb".
It doesn't like the "-ppre-spc3-83" part. After some research it appears
that for the DMX (Symmetrix) a more appropriate string would be
"/sbin/scsi_id -g -p 0x80 -u -s /block/sdb". I tried adding that into
the 'defaults' section of /etc/multipath.conf, but it doesn't appear to
pick it up. I've tried restarting multipathd, rebooting, etc. Is there
anyway to get it to take this string? I believe that is part of the
problem I'm having with the next item (#2).

2. In order to have multipath working for my EMC devices I have to
manually create them on system reboot. I simply created a new startup
script for this. Basically I just do; 'echo "0 17677440 multipath 0 0 2
1 round-robin 0 1 1 8:112 1000 round-robin 0 1 1 8:240 1000" | dmsetup
create dm0' for each device. Is that normal to have to do that or is
there a way to do this automatically? I would suspect it has to do with
having a hardware_handler. I thought about the dm-emc handler, but that
appears to only work for the CX/AX/FC family (i.e. Clariion) of arrays
which work nothing like the Symmetrix. Perhaps if I could get the
getuid_callout string working that would help.

3. Early this morning there was a problem on one of the multipath
devices used for Oracle ASM;

	SCSI error : <0 0 0 6> return code =3D 0x20000
	end_request: I/O error, dev sdd, sector 64078960
	end_request: I/O error, dev sdd, sector 64078961
	device-mapper: dm-multipath: Failing path 8:48.
	SCSI error : <1 0 0 6> return code =3D 0x20000
	end_request: I/O error, dev sdl, sector 34888112
	end_request: I/O error, dev sdl, sector 34888113
	device-mapper: dm-multipath: Failing path 8:176.

'multipath -l' showed the device as;

	dm2 ()
	[size=3D67 GB][features=3D"0"][hwhandler=3D"0"]
	\_ round-robin 0 [enabled]
	 \_ 0:0:0:6  sdd 8:48  [failed][ready]
	\_ round-robin 0 [enabled]
	 \_ 1:0:0:6  sdl 8:176 [failed][ready]

The LUNs on this server are shared between three servers and the other
two remained on-line so I know the LUN or paths to the array didn't go
out. Since the other LUNs on this server remained active I know I didn't
loose any HBA connectivity either. The DBAs said they were writing a
bunch of data to it when it dropped off line. I ran a few 'multipath'
and 'dmsetup status' commands to see what was up and it came back online
(it had been "failed" from ~3am to 7am).

Should I try using "failover" instead of "multibus" for my
"path_grouping_policy"? I would like to have it load balance, but
failover is more important.

Sorry for the long-winded post.

Any help would be appreciated.

Thanks,
David

David Child
Email  David.Child@ps.net.
