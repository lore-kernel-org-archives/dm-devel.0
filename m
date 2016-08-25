From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2] mdopen: Prevent overrunning the devname
	buffer when copying devnm into it for long md names.
Date: Thu, 25 Aug 2016 13:45:23 -0400
Message-ID: <wrfjfups7nf0.fsf@redhat.com>
References: <20160824161044.20887-1-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160824161044.20887-1-robert@leblancnet.us> (Robert LeBlanc's
	message of "Wed, 24 Aug 2016 10:10:44 -0600")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Robert LeBlanc <robert@leblancnet.us> writes:
> Linux allows for 32 character device names. When using the maximum size device name and also
> storing "/dev/", devname needs to be 37 character long to store the complete device name.
> i.e. "/dev/md_abcdefghijklmnopqrstuvwxyz12\0"
>
> Signed-Off: Robert LeBlanc<robert@leblancnet.us>
> ---
>  mdopen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good - I corrected your comment to fit into a proper editor width
of 80 characters, and also fixed up the SOB since it needs to say
Signed-off-by rather than signed-off.

Applied!
Jes
