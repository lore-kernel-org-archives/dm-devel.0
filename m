From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [Question] dm-cache table
Date: Sun, 01 Dec 2013 11:56:40 +0900
Message-ID: <529AA568.5080908@gmail.com>
References: <52932C6F.5000306@gmail.com>
	<20131125120512.GC10831@debian>	<529550BC.2040009@gmail.com>
	<20131127122916.GB18478@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131127122916.GB18478@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

First of all, this is the current Writeboost's table line design:
writeboost <type> <backing dev> <cache dev>
           #optional args [optional args]
	   #tunable args [tunable args] 

There's a constraint.
Joe's device-mapper-test-suite uses table line output to clone a device to test.
This means getting rid of the tunables from the line will make it incapable of
testing _tuned_ device.

As Alasdair said,
there are userland tools that compares the representations of output and what to be input
to avoid unnecessary reload. My first thought is to remove these worthless
optimization.
Other option is to define .table_eq :: String -> Bool method in target and
allow users to use it for that checking where the default behavior is left
as string comparison.

Alasdair's suggestion that the output design is always unique so that
the user can make their input as in matching form and string comparison works.
However, this option will discard the benefit of leaving those arguments
optional because it always need to input full set of arguments.
But, this looks the most sane because the user land tool anyway creates
the full set of arguments (They don't use the default value set
by the target). The optional property of some part of the table line
is only beneficial for those who directly uses dmsetup command.

The drawback of requiring full set of arguments is that
it's hard to add arguments anymore after released for backward-compatibility
but we can deal with this problem by remembering what arguments are
originally input (and the ordering) and includes those in output.

> I guess the status should show what's running, and the table line
> should show what was originally loaded.
My idea can go along with your idea by not including the tunables in
table line output if what was originally loaded included none.

> The other option would be to store the tunables in the metadata, and
> have them only changed via messages (not on the target line).  The
> draw back with this approach is it puts extra work on the userland
> volume management software; either they end up duplicating these
> settings in their own metadata, or have to be able to query them from
> the metadata (remember the volume may not be active).  I suggest you
> go with this approach for now.
This is not about the table design.
Remembering tunables in cache metadata and applying them at resuming
under .ctr sounds nice but userland takes responsible for this setup things
is my opinion.


Akira
