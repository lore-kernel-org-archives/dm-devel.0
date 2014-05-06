From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
	dm-multipath
Date: Tue, 6 May 2014 09:22:11 -0400
Message-ID: <20140506132211.GA22945@redhat.com>
References: <5368ABE8.9050909@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5368ABE8.9050909@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, May 06 2014 at  5:31am -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> Hello,
> 
> Has anyone else perhaps already run into this ?

Not seen this, how easily is it reproduced?

These recent commits are clearly the issue:

e809917735e dm mpath: push back requests instead of queueing
3e9f1be1b40 dm mpath: remove process_queued_ios()

Need to take a closer look at the lockdep splat you provided.
