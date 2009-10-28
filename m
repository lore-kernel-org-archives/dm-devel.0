From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 5/9] rqdm core: simplify suspend code
Date: Wed, 28 Oct 2009 17:39:04 +0000
Message-ID: <20091028173904.GR25303@agk-dp.fab.redhat.com>
References: <4AD7FC11.7030009@ct.jp.nec.com> <4AD7FE16.6050907@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AD7FE16.6050907@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Fri, Oct 16, 2009 at 02:01:10PM +0900, Kiyoshi Ueda wrote:
>   o To keep the old semantics, we need to distinguish which I/Os were
>     queued before/after the suspend invocation.
>     So a special barrier-like request called 'suspend marker' was
>     introduced.

This is the key to the simplification - when dm devices can support
flushing properly (using this barrier support), there is no need for an
additional implementation of 'flush' to be embedded within any
internal suspend logic.

Alasdair
