From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes for
 corrupted blocks
Date: Wed, 18 Mar 2015 11:42:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1503181135461.29107@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150316155559.GA32397@google.com>
	<20150317152749.GA24901@redhat.com>
	<20150317160649.GA36193@google.com>
	<20150317180358.GD24901@redhat.com>
	<20150318132453.GA3176@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150318132453.GA3176@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>
Cc: device-mapper development <dm-devel@redhat.com>, wad@chromium.org, msb@chromium.org
List-Id: dm-devel.ids



On Wed, 18 Mar 2015, Sami Tolvanen wrote:

> On Tue, Mar 17, 2015 at 02:03:58PM -0400, Vivek Goyal wrote:
> > Without knowing too much of detail, asking kernel to restart because one
> > block was corrupt sounds little drastic.
>  
> I agree, it's drastic, but in our use case it's necessary, because we have
> critical system data on a verified partition. Depending on which blocks are
> corrupted, the system may no longer be functional at this point.

As a user, I'd rather have half-functioning device where I can at least 
try to recover some data than a non-functioning device that continuously 
reboots.

I hope that you at least turn this feature off after a few reboots and 
give the user a chance to save his data.

Mikulas
