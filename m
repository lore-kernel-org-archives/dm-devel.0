From: Juha Koivisto <Juha.Koivisto@hut.fi>
Subject: Re: Re: Problems with path groups in multipath-tools
Date: Fri, 25 Feb 2005 18:31:18 +0200
Message-ID: <20050225163117.GA8151@debian.mydomain.bogus>
References: <20050224210918.GA10496@debian.mydomain.bogus>
	<20050225125613.GA6076@debian.mydomain.bogus>
	<87f94c3705022507074134a792@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87f94c3705022507074134a792@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Fri, Feb 25, 2005 at 10:07:43AM -0500, Greg Freemyer wrote:
> Your problem is the very first line of your script
> 
> #/bin/sh

Uh... yes, I see that very clearly now. You don't want to know how many
hours I had spent debugging this (and then it turns out to be a simple
typo). The reason I missed it was that I had tested the script from the
command line and it worked, so I assumed the problem had to be in the
multipath tool. (I would have thought bash needs ". scriptname" to
execute a text file as a script in the current shell, but apparently
not.)

Anyway, thanks.

It seems that my original message still hasn't made it to the list, so
I will send it again. Even though the actual problem was solved already,
I noticed some other strangeness (and possibly real bugs), to be
described shortly...

-- 
Juha.Koivisto@hut.fi
