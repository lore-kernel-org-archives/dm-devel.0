From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: device mapper not finding all devices
Date: Wed, 20 Jul 2011 18:27:35 +0200
Message-ID: <CAG2kNCwHL-W_9OCxKZExCtoxXGbHxu9JMO7n1kJqJMHQpWiJfQ@mail.gmail.com>
References: <CA+cRLpLs7CL4VeSw9YNGdTDOUG8mz=TpUuzyP=sWXpLiKywA+A@mail.gmail.com>
	<4E25D21E.8050901@cfl.rr.com>
	<CA+cRLp+MUdBg1J75Mv5BxNm1xrZRG5Cu4v4Y99hShEUONtQ0-Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+cRLp+MUdBg1J75Mv5BxNm1xrZRG5Cu4v4Y99hShEUONtQ0-Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Jul 19, 2011 at 10:48 PM, David Cramblett wrote:
> Thanks for the response. I did figured out the issue a few days ago.
> This was a CentOS 5.6 system, and 2.6.18 was the newest kernel I could
> get for that distribution.

I'm not a kernel expert, but keep in mind that RHEL
2.6.18-238.12.1.el5 kernel is very different from the upstream 2.6.18.
They make their systems ABI compatible throughout the lifetime of the
major version(4.x, 5.x).
So every major version of RHEL (es 5.x, 6.x) fixes the base kernel in
rpm name and then increments only the "-" part after it.
New features are typically not backported to current versions of the
kernel, newer drivers are often back ported (with their bugs too ;-),
assuming the driver existed in the RHEL kernel.
For example RH EL 6.0 was at 2.6.32 when it landed.
Now rh el 6.1 + updates has arrived at least at
2.6.32-131.2.1.el6.x86_64 but it is quite different from the original
kernel.org 2.6.32.
You could issue a command such as

rpm -q --changelog kernel-2.6.18-238.12.1.el5

to see all the patches + backports eventually added to a particular kernel rpm.
You can also download the source rpm and see inside the tgz files all
the patches applied (until the RH EL strategy changes in this respect
due to Oracle and Novell providing recompiled rpms for their
products/support plans...)

HIH,
Gianluca
