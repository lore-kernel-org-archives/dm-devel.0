From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Date: Thu, 17 Jan 2013 12:36:19 -0600
Message-ID: <50F844A3.9020300@warr.net>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD> <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD> <20130116104546.GA3869@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD> <20130117132620.GA2438@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248-AQg6BlXVjylhNUoibfp7lHKnxlUjViKd@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Cc: "thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids


On 01/17/2013 11:53 AM, Amit Kale wrote:
>>> 9. Performance - Throughput is generally most important. Latency is
>> >   also one more performance comparison point. Performance under
>> >   different load classes can be measured.
>> > 
>> >   I think latency is more important than throughput.  Spindles are
>> >   pretty good at throughput.  In fact the mq policy tries to spot when
>> >   we're doing large linear ios and stops hit counting; best leave this
>> >   stuff on the spindle.
> I disagree. Latency is taken care of automatically when the number of application threads rises.
>

Can you explain what you mean by that in a little more detail?

As an enterprise level user I see both as important overall.  However,
the biggest driving factor in wanting a cache device in front of any
sort of target in my use cases is to hide latency as the number of
threads reading and writing to the backing device go up.  So for me the
cache is basically a tier stage where your ability to keep dirty blocks
on it is determined by the specific use case.
