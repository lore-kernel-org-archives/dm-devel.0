From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-writeboost: Progress Report
Date: Mon, 13 Jan 2014 10:09:03 +0000
Message-ID: <20140113100903.GA4984@debian>
References: <52D0F25D.6030904@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52D0F25D.6030904@gmail.com>
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

On Sat, Jan 11, 2014 at 04:27:25PM +0900, Akira Hayakawa wrote:
> Hi, DM Guys, 
> 
> This is the latest progress report of dm-writeboost.

Do you have any benchmarks yet?  Which situations does it out perform
bcache and dm-cache?

> 4. Add some codes to Joe's device-mapper-test-suite
> ---------------------------------------------------
> Joe maintains a testing framework in his Github repo.
> I merged some test codes for Writeboost but I don't work on this project
> recently. I will add more code later.

Thanks for adding to dmtest, you also did a couple of little tidy ups
that were useful to me.

> 5. Add regression tests under testing/ of my Github tree
> --------------------------------------------------------
> Joe's test-suite is really well-designed but it has too many things before stand-by.

I'm not sure what you mean here?

- Joe
