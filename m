From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm thin metadata: clarify __open_device
 functionality and fix callers
Date: Tue, 10 Jan 2012 10:31:05 +0000
Message-ID: <20120110103104.GA5981@ubuntu>
References: <1326141188-2172-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1326141188-2172-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 09, 2012 at 03:33:08PM -0500, Mike Snitzer wrote:
> The __open_device() error path of __create_thin() and __create_snap()
> will call __close_device() even if td was not initialized by
> __open_device().
>
> Clearly define what callers should expect from __open_device()'s
> return.
>
> Also, remove redundant 'td->changed = 1' in __create_thin() --
> __open_device() with create=1 will have set td->changed on successful
> return.

Hi Mike,

This looks like a code review patch, and as such I ACK it.

I don't think it changes any behaviour though.  Both create_thin and
create_snapshot hold a mutex when they run, and the first thing they
do is check for the existence of the device.

        r = dm_btree_lookup(&pmd->details_info, pmd->details_root,
                            &key, &details_le);
        if (!r)
                return -EEXIST;

I don't think there's a race on creation?

We need to focus on reproducing Kabi's issue.

- Joe
