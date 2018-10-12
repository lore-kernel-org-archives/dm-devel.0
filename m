From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] dm flakey: Document "error_writes" feature
Date: Fri, 12 Oct 2018 11:31:54 -0600
Message-ID: <20181012113154.7d2f4a64@lwn.net>
References: <1539073891-7701-1-git-send-email-nborisov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539073891-7701-1-git-send-email-nborisov@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikolay Borisov <nborisov@suse.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, linux-doc@vger.kernel.org
List-Id: dm-devel.ids

On Tue,  9 Oct 2018 11:31:31 +0300
Nikolay Borisov <nborisov@suse.com> wrote:

> Commit ef548c551e72 ("dm flakey: introduce "error_writes" feature")
> added the ability to dm flakey to error out writes in contrast to
> silently dropping it with 'drop_writes'. Unfortunately this feature
> is not currently documented and one has to be either familiar with the
> source code of dm flakey or check out xfstests sources to know of
> this parameter. So document it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied to the docs tree, thanks.

jon
