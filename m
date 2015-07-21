From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v2 1/3] PM suspend/hibernate: Call notifier after freezing processes
Date: Wed, 22 Jul 2015 01:03:23 +0200
Message-ID: <CAJZ5v0jGuLTJbsjW3WPe2Y8OgwMgcSSwTRNB8+PWaxwKpSDP-g@mail.gmail.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
	<3179448.TScsKEAuyR@vostro.rjw.lan>
	<20150720073226.GB25910@pali>
	<1715416.hWBvT0iLvO@vostro.rjw.lan>
	<20150722080827.5adcf5f1@noble>
	<CAJZ5v0h-0Jo7A0hmPSfHcZbkRU7wKwVtSqTCCwX1rs=iBE9G5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0h-0Jo7A0hmPSfHcZbkRU7wKwVtSqTCCwX1rs=iBE9G5g@mail.gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Jul 22, 2015 at 1:00 AM, Rafael J. Wysocki <rafael@kernel.org> =
wrote:
> Hi Neil,
>
> On Wed, Jul 22, 2015 at 12:08 AM, NeilBrown <neilb@suse.com> wrote:
>> On Mon, 20 Jul 2015 23:46:32 +0200 "Rafael J. Wysocki"
>> <rjw@rjwysocki.net> wrote:
>>
>>> On Monday, July 20, 2015 09:32:26 AM Pali Roh=C3=A1r wrote:
>>> > On Saturday 18 July 2015 01:27:15 Rafael J. Wysocki wrote:
>>> > > On Thursday, July 16, 2015 09:33:02 AM Pali Roh=C3=A1r wrote:
>>> > > > On Thursday 16 July 2015 03:02:03 Rafael J. Wysocki wrote:
>>> > > > > Also, if you're adding AFTER_FREEZE, it would be good to ad=
d BEFORE_THAW too
>>> > > > > for symmetry.
>>> > > > >
>>> > > >
>>> > > > But there is no use case for BEFORE_THAW. At least it is not =
needed for now.
>>> > >
>>> > > For your use case, a single function pointer would be sufficien=
t too.
>>> > >
>>> >
>>> > What do you mean by single function pointer? kernel/power is part=
 of
>>> > kernel image and dm-crypt is external kernel module.
>>>
>>> Well, if there is a function pointer in the core suspend code initi=
ally set to
>>> NULL and exported to modules such that the dm-crypt code can set it=
 to
>>> something else, that should be sufficient, shouldn't it?
>>
>> As long as the dm-crypt module is never unloaded.
>
> OK, there is a race related to that.
>
>> And as long as no other module could very possible want functionalit=
y like this. Ever.
>
> The point was that there were no other users currently, so dm-crypt i=
s
> going to be the only user for the time being.
>
>> If a module wants to be notified - the providing a notifier chain
>> really seems like the right thing to do...
>
> Well, so please see my last response in this thread. :-)

So it was below: "Anyway, I guess the "post freeze" new one should be
enough for now" which doesn't mean I'm really against the notifier.
Or at least it is not supposed to mean so.  If there's any confusion
related to that, I'm sorry.

Thanks,
Rafael
