From: Gunter Ohrner <G.Ohrner-6V9naDJErT6662+jY7v6MhvVK+yQ3ZXh@public.gmane.org>
Subject: Re: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in	dm-crypt
Date: Sun, 02 Mar 2008 08:58:52 +0100
Message-ID: <fqdmmv$eov$1@ger.gmane.org>
References: <200802281924.03996.rrs@researchut.com>	<20080228232048.51e28c1d.akpm@linux-foundation.org>	<20080229184649.GJ1788@agk.fab.redhat.com>	<200803010029.18320.rrs@researchut.com> <47C9AEF3.7040507@redhat.com> <47C9AF8F.2050502@redhat.com> <fqcjj9$5bv$1@ger.gmane.org>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <dm-crypt-return-2612-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
Sender: news <news-dbVV3NMTNubNLxjTenLetw@public.gmane.org>
To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Gunter Ohrner wrote:
> * This patch seems to hurt performance, I got much lower thoughput and the

Mh, strange, today I cannot reproduce the performance degradation...

There seem to have been some factors in effect during my yesterday's tests
which I'm not aware of - anyway, currently throughput is fine while running
a 2.6.24.3 kernel with this patch applied.

Greetings,

  Gunter
