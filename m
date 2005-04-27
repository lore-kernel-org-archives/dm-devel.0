From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: what is the current utility in testing active paths
	from multipat hd?
Date: Wed, 27 Apr 2005 18:02:02 +0100
Message-ID: <20050427170202.GM9049@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
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

On receiving an event from the kernel, I think the daemon should:

  compare the current status with the previous status to see what changed;

  add newly-failed paths to its list of failed paths that need retesting;

  immediately test newly-failed paths and schedule further regular 
testing for them;

  if the number of active paths in the currently active PG is getting low,
immediately retest other failed paths in that PG


Periodically the daemon should wake itself up to test the failed paths 
it knows about.

It should also test active paths to preempt problems: if an
inactive path has failed, the admin needs to know the system is
running in a degraded state.

The frequency of the testing should be configurable in severals
ways - it could depend on the size of the system, the
load, the time since each path was last tested, time since 
last successful test of the path, type of hardware (what's the
perfomance impact of a test? e.g. trespass issues), structure containing 
the path (more important to test failed paths in the current PG than other PGs;
if you're using round-robin and you know there's always I/O happening to the
device, it's more important to test active paths in other PGs) etc.

Alasdair
-- 
agk@redhat.com
