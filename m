From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] dm unstriped: rename symbols to conform
 to target name
Date: Thu, 22 Feb 2018 11:41:23 -0500
Message-ID: <20180222164123.GA17147@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
	<04aeb5e9574c6dd402c3a492690043d19fc172e6.1517504857.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <04aeb5e9574c6dd402c3a492690043d19fc172e6.1517504857.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 01 2018 at  1:06pm -0500,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> Rename all "unstripe_" symbol substrings to "unstriped_".
> 
> Rename 'struct unstriped_c' member 'unstripe' to
> more meaningful 'unstriped_idx'
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

dm-stripe.c has comparable differences.  I'd prefer to just leave it.
Not seeing a big benefit to these renames.

Mike
