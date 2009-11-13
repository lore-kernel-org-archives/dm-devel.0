From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm: Add accessor dm_table_md_suspended
Date: Fri, 13 Nov 2009 09:19:01 -0500
Message-ID: <20091113141901.GA18455@redhat.com>
References: <20091113080637.17587.64935.stgit@localhost.localdomain>
	<20091113080642.17587.37581.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091113080642.17587.37581.stgit@localhost.localdomain>
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

On Fri, Nov 13 2009 at  3:06am -0500,
Mike Anderson <andmike@linux.vnet.ibm.com> wrote:

> Add a dm_table accessor function to check if md is suspended.
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>

I was thinking of doing then same because I have a need to test if a
table is suspended in the snapshot target.  I stopped short of doing so
but it is clear that it is better to put this generic DM export in place
rather than have each target add their own 'suspended' flag in
presuspend (or some equivalent).

Acked-by: Mike Snitzer <snitzer@redhat.com>
