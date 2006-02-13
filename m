From: Stephan =?utf-8?Q?Austerm=C3=BChle?= <au@hcsd.de>
Subject: dm-multipath: multipath setup okay,
	nothing in /dev/disk/by-name
Date: Mon, 13 Feb 2006 16:51:23 +0100 (CET)
Message-ID: <57309.194.39.131.39.1139845883.squirrel@www.hcsd.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,

I've just setup a multipath'd connection to a EMC Clariion CX700. Althoug=
h
the output of "multipath -l" looks right for me (see below), no symlinks
in /dev/disk/by-name appear. Under which circumstances does multipath
create this symlinks and how can I force the creation?

# multipath -l
360060160ff0b16005b24812c3793da11
[size=3D34 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
 \_ 1:0:1:3     sdab 65:176 [active][ready]
 \_ 0:0:1:3     sdl  8:176  [active][ready]
\_ round-robin 0 [enabled]
 \_ 0:0:0:3     sdd  8:48   [active][ready]
 \_ 1:0:0:3     sdt  65:48  [active][ready]

360060160ff0b1600af0fb8533a93da11
[size=3D33 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
 \_ 1:0:1:7     sdaf 65:240 [active][ready]
 \_ 0:0:1:7     sdp  8:240  [active][ready]
\_ round-robin 0 [enabled]
 \_ 0:0:0:7     sdh  8:112  [active][ready]
 \_ 1:0:0:7     sdx  65:112 [active][ready]

[...]

Thanks for your help!

Stephan
