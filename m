From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Regression introduced with commit 2a0b4682e09d76
 ("dm: convert dm_dev_internal.count from atomic_t to refcount_t)
Date: Thu, 1 Feb 2018 11:40:02 -0500
Message-ID: <20180201164002.GA30734@redhat.com>
References: <ac8161a5-22b7-4e3a-ad19-a300f1a0ee74@email.android.com>
	<efb3fff2-f777-fe96-bfda-d67b39b578c2@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <efb3fff2-f777-fe96-bfda-d67b39b578c2@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 01 2018 at 11:16am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/01/2018 04:03 PM, Mike Snitzer wrote:
> > Pretty sure that regression was already fixed.
> > 
> > Which code are you looking at?
> > 
> This is actually coming from mkp 4.16/scsi-fixes tree; might be that
> you've fixed it up in the meantime.

Please see:
http://git.kernel.org/linus/afc567a4977b2d798e05153dd131a3c8d4758c0c
