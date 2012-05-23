From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] Add human-readable units modifier to vsnprintf()
Date: Tue, 22 May 2012 23:12:14 -0700
Message-ID: <1337753534.13111.51.camel@joe2Laptop>
References: <cover.1336619038.git.koverstreet@google.com>
	 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	 <20120522211706.GH14339@google.com>
	 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337744190.13111.33.camel@joe2Laptop>
	 <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337749848.13111.40.camel@joe2Laptop>
	 <20120523052236.GA14312@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337751760.13111.47.camel@joe2Laptop>
	 <20120523060435.GD14312@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120523060435.GD14312-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, 2012-05-23 at 02:04 -0400, Kent Overstreet wrote:
> Only trouble is we lose the existing method of specifying the type of
> the integer. 

Hi again Kent.

My first suggestion to you was:
---------------------
> or maybe yet another lib/vsprintf pointer extension
> like %pD with some descriptors after the %pD for
> type, width and precision.
---------------------

For instance, internet addresses use pointer extensions
%pI4 and %pI6 for ipv4 and ipv6 addresses.

> New flag character would make much more sense... if gcc
> could be persuaded.

It can't be so persuaded though.  Maybe a future gcc.
