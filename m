From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [dm-devel] [PATCH v05 04/72] dm-log-userspace.h: use __u32, __s32
 and __u64 from linux/types.h
Date: Tue, 23 Aug 2016 14:28:19 +0000
Message-ID: <BY2PR02MB1686A7AFCFDB3D8D0C41A42981EB0@BY2PR02MB1686.namprd02.prod.outlook.com>
References: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
 <1471890809-4383-5-git-send-email-mikko.rapeli@iki.fi>
 <BY2PR02MB16868FAEFEA311312FA688B981EB0@BY2PR02MB1686.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 08/23/16 06:57, Bart Van Assche wrote:=0A=
> On 08/22/16 11:32, Mikko Rapeli wrote:=0A=
>> - * uint32_t (*get_region_size)(struct dm_dirty_log *log);=0A=
>> + * __u32 (*get_region_size)(struct dm_dirty_log *log);=0A=
>=0A=
> uint32_t is a type that is defined by ANSI C but __u32 not. So this=0A=
> change looks wrong to me. Would it have been sufficient to add "#include=
=0A=
> <linux/types.h>" and keep the uint32_t etc. type names?=0A=
=0A=
Answering my own question: adding "#include <linux/types.h>" wouldn't be =
=0A=
sufficient. How about adding the following code that also occurs in a =0A=
few other uapi header files?=0A=
=0A=
#ifndef __KERNEL__=0A=
#include <stdint.h>=0A=
#endif=0A=
#include <linux/types.h>=0A=
=0A=
Bart.=0A=
