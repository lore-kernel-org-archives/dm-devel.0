From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] dm-mpath: Fix a race condition in the
	blk-mq path
Date: Wed, 16 Nov 2016 09:56:30 -0500
Message-ID: <20161116145630.GB23071@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<05d83937-9fcc-7bee-8507-fd59ec25ec7f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <05d83937-9fcc-7bee-8507-fd59ec25ec7f@suse.de>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 16 2016 at  2:39am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 11/16/2016 12:31 AM, Bart Van Assche wrote:
> > Hello Mike,
> > 
> > The seven patches in this series is what I came up with while reviewing
> > and testing the dm-mpath single queue and multiqueue code. It would be
> > appreciated if these patches would be considered for inclusion in the
> > upstream kernel.
> > 
> For the whole series:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>

I already took patch 1.

2 - 6 are fluff.  I'll take them, but they don't fix anything.

7 is not acceptable.  It complicates the code for no reason (the
scenario that it is meant to address isn't possible).
