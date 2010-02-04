From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 3/4] dm-mpath: separate pg-init handling	from
	process_queued_ios()
Date: Thu, 4 Feb 2010 17:14:27 +0000
Message-ID: <20100204171427.GA7950@agk-dp.fab.redhat.com>
References: <4B665507.8080205@ct.jp.nec.com> <4B6656FF.5000701@ct.jp.nec.com>
	<20100202182437.GI864@agk-dp.fab.redhat.com>
	<4B6AA1F3.5030206@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B6AA1F3.5030206@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 04, 2010 at 07:31:15PM +0900, Kiyoshi Ueda wrote:
> While trying to extend the explanation, I come to think there may be
> better implementation for pg_init refactoring.
> So please wait reviewing dm-mpath-refactor-pg_init-trigger.patch until
> my next update.
> (I think dm-mpath-refactor-pg_init.patch is no problem to apply even
>  at this point.)
 
OK.

Alasdair
