From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Sat, 17 Jan 2015 16:09:52 -0800
Message-ID: <20150118000952.GB26160@kroah.com>
References: <54A508F7.1020207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <54A508F7.1020207@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: ejt@redhat.com, driverdev-devel@linuxdriverproject.org, dm-devel@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 01, 2015 at 05:44:39PM +0900, Akira Hayakawa wrote:
> This patch adds dm-writeboost to staging tree.
> 
> dm-writeboost is a log-structured SSD-caching driver.
> It caches data in log-structured way on the cache device
> so that the performance is maximized.
> 
> The merit of putting this driver in staging tree is
> to make it possible to get more feedback from users
> and polish the codes.
> 
> v2->v3
> - rebased onto 3.19-rc2
> - Add read-caching support (disabled by default)
>   Several tests are pushed to dmts.
> - An critical bug fix
>   flush_proc shouldn't free the work_struct it's running on.
>   I found this bug while I am testing read-caching.
>   I am not sure why i didn't exhibit before but it's truly a bug.
> - Fully revised the README.
>   Now that we have read-caching support, the old README was completely obsolete.
> - Update TODO
>   Implementing read-caching is done.
> - bump up the copyright year to 2015
> - fix up comments
> 
> 
> Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>

I need an ack from a dm developer before I can take this.

thanks,
greg k-h
