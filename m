From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: "queue if no paths" infinite recursion when there are
	no paths
Date: Thu, 24 Feb 2005 02:37:32 +0000
Message-ID: <20050224023732.GV14093@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A7CE@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A7CE@SRMANNING.eng.emc.com>
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

On Wed, Feb 23, 2005 at 04:20:15PM -0500, goggin, edward wrote:
> It appears that there is no stopping condition for retrying i/os failed
> via bio_endio() in dispatch_queued_ios().  

Currently they are meant to be requeued down different path - never
down a path already used - so they try all paths then get
errored.  If there's no path available, and m->suspended is set,
nothing is meant to be queued.
I think the bug is the goto requeue that should have tested
for m->suspended first - a test for queue_if_no_path missed when m
->suspended was added.

if (!m->queue_if_no_path &&!m->suspended) {

Alasdair
