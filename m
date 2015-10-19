From: Joe Thornber <thornber@redhat.com>
Subject: Re: Fwd: kernel BUG at
 drivers/md/persistent-data/dm-btree-remove.c:182!
Date: Mon, 19 Oct 2015 11:30:58 +0100
Message-ID: <20151019103057.GA14688@rh-vpn>
References: <5624B4B8.1030404@siteground.com> <5624B505.6000406@siteground.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5624B505.6000406@siteground.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikolay Borisov <n.borisov@siteground.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 19, 2015 at 12:16:53PM +0300, Nikolay Borisov wrote:
> [Resending as I had typo in the dm-devel's mailing list the first time]
> 
> Hello, 
> 
> Using kernel 3.12.47 I've hit the aforementioned issue. I'd also like 
> to say that this kernel does include Dennis Yang's patch which 
> supposedly fixes a similar issue 
> (https://www.redhat.com/archives/dm-devel/2015-May/msg00113.html). 


Did you apply this patch or my corrected patch?

https://www.redhat.com/archives/dm-devel/2015-May/msg00123.html

- Joe
