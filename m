From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dmcache RAID1 bug?
Date: Wed, 19 Nov 2014 23:19:47 -0500
Message-ID: <20141120041946.GA15847@redhat.com>
References: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
	<20141117144659.GA29929@redhat.com>
	<CAEZ+n-jJoCS0WqeeiETYf1jAwPJzy+fyEgr_-Qek+7NzS+uERQ@mail.gmail.com>
	<CAEZ+n-i3yP+qO6bVDs8O0CwkJKBNzVBMW6gOtd=dty9ALj_8eQ@mail.gmail.com>
	<CAEZ+n-ha0tFew+807rumUQsk-tqYVyxPUTrGoz0DvdCqLK50Og@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAEZ+n-ha0tFew+807rumUQsk-tqYVyxPUTrGoz0DvdCqLK50Og@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Leonardo Santos <heiligerstein@gmail.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 19 2014 at  4:39pm -0500,
Leonardo Santos <heiligerstein@gmail.com> wrote:

> After run regression tests using 'git bisect', I identify that the error
> was created after commit 8c081b52c6833a30a69ea3bdcef316eccc740c87
> 
> To reproduce this error just:
> - create a raid1 HDDs for origin device;
> - create a cache device with SSDs (could or not be raid)
> - create a metadata device with SSDs (could or not be raid)
> - create a cache device using prior devices
> - kernel crashes.
> 
> I attached the bitseclog and diff file!

Surprising considering I went over that commit multiple times (because
the changes weren't obvious relative to the "No functional change."
assertion in the commit's header).  The __cache_map and cache_map change
to centralize the inc_ds + cell_defer made the __cache_map changes
_seem_ like a difference was being introduced but they still look fine
to me.

Looking again I notice check_for_quiesced_migrations() switched to
an unconditional dm_deferred_entry_dec(); but that is fine because
earlier in check_for_quiesced_migrations() there is an early return if
pb->all_io_entry is NULL.

But could be a more trained eye will see some functional change that may
have been introduced (cc'ing Joe).

Mike
