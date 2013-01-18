From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Date: Fri, 18 Jan 2013 12:36:42 -0600
Message-ID: <50F9963A.2080608@warr.net>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD> <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD> <20130116104546.GA3869@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD> <20130117132620.GA2438@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD> <50F844A3.9020300@warr.net> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD> <50F970A3.4000403@warr.net> <20130118161135.GA3118@raspberrypi> <50F97C0F.9010405@warr.net> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345-AQg6BlXVjylhNUoibfp7lHKnxlUjViKd@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids


On 01/18/2013 11:44 AM, Amit Kale wrote:
>> As much as I dislike Oracle that is one of my primary applications.  I
>> > am attempting to get one of my customers to setup an Oracle instance
>> > that is modular in that I can move the storage around to fit a
>> > particular hardware setup and have a consistent benchmark that they use
>> > in the real world to gauge performance.  One of them is a debit card
>> > transaction clearing entity on multi-TB databases so latency REALLY
>> > matters there.  
> I am curious as to how SSD latency matters so much in the overall transaction times.
>
> We do a lot of performance measurements using SQL database benchmarks. Transaction times vary a lot depending on location of data, complexity of the transaction etc. Typically TPM (transactions per minute) is of primary interest for TPC-C.
>

It's not specifically SSD latency.  It's I/O transaction latency that
matters.  This particular application is very sensitive to that because
it is literally someone standing at a POS terminal swiping a
debit/credit card.  You only have a couple of seconds after the PIN is
entered for the transaction to go through your network, application
server to authorize against a DB and back to the POS.

The entire I/O stack on the DB is only a small time-slice of that round
trip.  Your 99th percentile needs to be under 20ms on the DB storage
side.  If your worst case DB I/O goes beyond 300ms it is considered an
outage because the POS transaction fails.  So it obviously takes allot
of planning and optimization work on the DB itself to get good
tablespace layout to even get into the realm where you can have that
predictable of latency with multi-million dollar FC storage frames. 

One of my goals is to be able to offer this level of I/O service on
commodity hardware.  Simplify the scope of hardware, reduce the number
of points of failure, make the systems more portable, reduce or
eliminate dependence on any specific vendor below the application and
save money.  Not to mention reduce the number of fingers that can point
away from themselves saying it is someone elses problem to find fault.

Allot of the pieces are already out there.  A good block caching target
is one of the missing pieces to help fill the ever growing canyon
between non-block device system performance and storage.  What they have
done with L2ARC and SLOG in ZFS/Solaris is good but it has some serious
short comings in other areas that DM/MD/LVM do extremely well.

I appreciate all of the brilliant work all of you guys do and hopefully
I can contribute a little bit of usefulness to this effort.

Thank you,

Jason
