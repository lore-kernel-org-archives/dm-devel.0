From: Edward Thornber <thornber@redhat.com>
Subject: Re: dm-persistent-data: free sm_metadata on failed create
Date: Fri, 2 Dec 2016 06:45:56 -0500
Message-ID: <20161202114556.GE5643@roamer.bos.redhat.com>
References: <1480550174-8675-1-git-send-email-bmarzins@redhat.com>
	<20161201105810.GD5643@roamer.bos.redhat.com>
	<20161201164105.GA26457@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20161201164105.GA26457@redhat.com>
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

On Thu, Dec 01, 2016 at 11:41:05AM -0500, Mike Snitzer wrote:
> Staged for 4.10 inclusion with a revised header, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.10&id=b34af3050734ba53a7afa4f3ab9fe9d6bbfbf802

It's not urgent.  In general if something goes wrong with a persistent
data transaction we just abort and roll back.  So there are a lot of
error paths where we don't bother to repair metadata that's in the
doomed transaction.
