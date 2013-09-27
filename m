From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Fri, 27 Sep 2013 09:37:42 +0100
Message-ID: <20130927083742.GA683@agk-dp.fab.redhat.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com> <524520B0.6010003@suse.de>
	<52453C76.6060403@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52453C76.6060403@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

But this still dodges the fundamental problem:

  What is the right value to use for the timeout?
  - How long should you wait for a path to (re)appear?
    - In the current model, reinstating a path is a userspace 
      responsibility.

The timeout, as proposed, is being used in two conflicting ways:
  - How long to wait for path recovery when all paths went down
  - How long to wait when the system locks without enough free
    memory even to reinstate a path (because of broken userspace
    code) before having multipath fail queued I/O in a desperate
    attempt at releasing memory to assist recovery
 
The second case should point to a very short timeout.
The first case probably wants a longer one.

In my view the correct approach for the case Frank is discussing is to
use a different trigger to detect the (approaching?) locking up of the
system.   E.g.  should something related to the handling of an out
of memory condition have a hook to instruct multipath to release such
queued I/O?

Alasdair
