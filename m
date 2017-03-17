From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: remove an impossible condition
Date: Fri, 17 Mar 2017 17:38:19 -0400
Message-ID: <20170317213819.GC6475@redhat.com>
References: <20170317204655.GA28261@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170317204655.GA28261@mwanda>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 17 2017 at  4:46pm -0400,
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Static checkers complain that it doesn't make sense to check if "sval"
> is NULL.  The intention was to check if strchr() returned NULL, but in
> that situation "sval" would be "NULL + 1" so the check doesn't work.  We
> know from the sscanf() that there is a ':' character in the string so
> the check is unnecessary and can be removed.
> 
> Now that the check doesn't depend on "sval" it can be moved earlier
> for readability.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan, I've folded this fix into the original commit, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.12&id=cf22cd5f3afe7335afee5659f7450000e8fa2a15

I didn't add your Signed-off-by though, I can backfill that if you
like.. it is just I didn't want to taint you with all the extensive
changes in that commit.

Mike
