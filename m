From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Re: Problems with path groups in multipath-tools
Date: Fri, 25 Feb 2005 11:43:26 -0500
Message-ID: <87f94c3705022508431733f073@mail.gmail.com>
References: <20050224210918.GA10496@debian.mydomain.bogus>
	<20050225125613.GA6076@debian.mydomain.bogus>
	<87f94c3705022507074134a792@mail.gmail.com>
	<20050225163117.GA8151@debian.mydomain.bogus>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050225163117.GA8151@debian.mydomain.bogus>
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

On Fri, 25 Feb 2005 18:31:18 +0200, Juha Koivisto <Juha.Koivisto@hut.fi> wrote:
> On Fri, Feb 25, 2005 at 10:07:43AM -0500, Greg Freemyer wrote:
> > Your problem is the very first line of your script
> >
> > #/bin/sh
> 
> Uh... yes, I see that very clearly now. You don't want to know how many
> hours I had spent debugging this (and then it turns out to be a simple
> typo). The reason I missed it was that I had tested the script from the
> command line and it worked, so I assumed the problem had to be in the
> multipath tool. (I would have thought bash needs ". scriptname" to
> execute a text file as a script in the current shell, but apparently
> not.)
> 
Actually none of the shells require the #!/bin/sh type of thing if you
are invoking the script from the shell you want to execute it.

The purpose of it is to allow you to invoke the script from somewhere
other than the shell.

A simple example, if you write a csh script, then bash would require
#!/bin/csh to cause the shell to be swapped out.  Without the
#!/bin/csh, bash assumes it is native bash script.

Greg
