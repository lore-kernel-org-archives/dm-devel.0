From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
Date: Fri, 19 Aug 2011 12:26:30 +0200
Message-ID: <CAPXgP13KeTnBD+hgf_hM55EiQFsYCxmCwyhRaNZ0rUJpjKK=-g@mail.gmail.com>
References: <4E4CDF44.5080109@redhat.com> <m17h69sr03.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m17h69sr03.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
List-Id: dm-devel.ids

On Fri, Aug 19, 2011 at 11:13, Eric W. Biederman <ebiederm@xmission.com=
> wrote:
> Milan Broz <mbroz@redhat.com> writes:
>> If you run clone() with CLONE_NEWNET (which is chromium using
>> for sanboxing), udev namespace is cloned too (newly registered
>> in uevent_sock_list) and netlink send (except the first in list)
>> fails with -ESRCH.
>>
>> This causes that _every_ call of kobject_uevent_env() return failure=
=2E

> That netlink_ broadcast chooses to treat failure to deliver a packet =
to
> anyone as an error and return -ESRCH is a little peculiar. =C2=A0In g=
eneral
> we don't see that error because when you are testing there is at leas=
t
> one listener on the netlink socket. =C2=A0So as a practical matter I =
think
> we should be ignoring return values of -ESRCH from netlink_broadcast,
> in kobject_uevent_env.

Wouldn't a wrap in netlink_has_listeners() help before we try to send i=
t?

Kay
