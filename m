From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v06] uapi dm-log-userspace.h: use __u32, __s32, __u64 and
 __s64 from linux/types.h
Date: Sun, 28 Aug 2016 16:07:44 +0000
Message-ID: <BLUPR02MB16830B1D4DF5BEFF21798C6B81EE0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <BLUPR02MB16838BBEFFAA2240A879370E81ED0@BLUPR02MB1683.namprd02.prod.outlook.com>
 <1472366557-5786-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 08/27/16 23:43, Mikko Rapeli wrote:=0A=
> Fixes userspace compilation errors like:=0A=
>=0A=
> linux/dm-log-userspace.h:416:2: error: unknown type name =91uint64_t=92=
=0A=
=0A=
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=0A=
