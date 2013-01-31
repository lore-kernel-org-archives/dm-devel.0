From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Thu, 31 Jan 2013 13:08:53 -0800
Message-ID: <CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg@mail.gmail.com>
References: <20130110175954.GR26407@google.com>
	<20130114223722.GZ26407@google.com>
	<20130114225330.GA1365@redhat.com>
	<20130117022728.GA16148@redhat.com>
	<20130117114104.GJ10411@moria.home.lan>
	<20130130233643.GD12631@moria.home.lan>
	<20130131001020.GA7541@redhat.com>
	<20130131012627.GF12631@moria.home.lan>
	<20130131012747.GG12631@moria.home.lan>
	<20130131014835.GH12631@moria.home.lan>
	<20130131190249.GA12786@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130131190249.GA12786-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jan 31, 2013 at 11:02 AM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Jan 30 2013 at  8:48pm -0500,
> Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Wed, Jan 30, 2013 at 05:27:47PM -0800, Kent Overstreet wrote:
>> > On Wed, Jan 30, 2013 at 05:26:27PM -0800, Kent Overstreet wrote:
>> > > On Wed, Jan 30, 2013 at 07:10:21PM -0500, Mike Snitzer wrote:
>> > > > On Wed, Jan 30 2013 at  6:36pm -0500,
>> > > > Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> > > >
>> > > > > Fixed a bunch of other bugs today too... notably the bug where it'd
>> > > > > crash if you enabled discards. Was there anything else you or anyone
>> > > > > else was hitting?
>> > > >
>> > > > Great, thanks, the other outstanding report was this one:
>> > > > https://lkml.org/lkml/2013/1/17/554
>> > >
>> > > Yep, that was the discard bug I just fixed.
>> >
>> > Err I misread - nope, I missed that one. Taking a look now.
>>
>> Fucking shrinkers, i swear that's one of the most nonsensical APIs I've
>> yet encountered.
>>
>> This is going to take some thought. For now, just disable the shrinker:
>>
>> echo 1 > /sys/fs/bcache/<uuid>/internal/btree_shrinker_disabled
>
> Oddly I don't have a /sys/fs/bcache/<uuid> even though I have created
> /dev/bcache0
>
> The only files I have in /sys/fs/bcache/ are: register  register_quiet

That means you have a backing device registered, but not a cache device
