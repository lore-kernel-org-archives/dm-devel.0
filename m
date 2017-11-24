From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm thin: fix NULL pointer exception
	caused	by two concurrent "vgchange -ay -K <vg name>" processes.
Date: Fri, 24 Nov 2017 14:12:59 +0000
Message-ID: <20171124141258.GH5952@agk-dp.fab.redhat.com>
References: <201711241659129513254@sina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201711241659129513254@sina.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "monty_pavel@sina.com" <monty_pavel@sina.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 24, 2017 at 04:59:13PM +0800, monty_pavel@sina.com wrote:
>     All that we need do is to ensure pool_target registering ops
>     is the last ops in dm_thin_init.
 
Any other targets wrong too?  cache?  multipath?  snapshot?

Alasdair
