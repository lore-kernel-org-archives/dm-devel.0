From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH maybe-for-3.13 01/20] dm thin: initialize
 dm_thin_new_mapping returned by get_next_mapping
Date: Mon, 6 Jan 2014 14:21:45 +0000
Message-ID: <20140106142145.GC6766@debian>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
	<1387582653-13647-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1387582653-13647-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Fri, Dec 20, 2013 at 06:37:14PM -0500, Mike Snitzer wrote:
> As additional members are added to the dm_thin_new_mapping structure
> care should be taken to make sure they get initialized before use.

ACK.

> +	memset(m, 0, sizeof(struct dm_thin_new_mapping));
> +	INIT_LIST_HEAD(&m->list);
> +	m->bio = NULL;

Remove redundant m->bio assignment?
