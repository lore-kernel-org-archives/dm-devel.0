From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Path check interval in multipathd is 1 second longer
Date: Thu, 13 Oct 2005 10:34:53 +0200
Message-ID: <20051013083453.GB27041@free.fr>
References: <20051012.155002.71083127.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051012.155002.71083127.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Oct 12, 2005 at 03:50:02PM -0400, Kiyoshi Ueda wrote:
> Hi Christophe,
> 
> Current path check interval is 1 second longer than polling_interval
> setting in multipath.conf.
> 
> This bug affects the "no_path_retry" option.
> For example, if no_path_retry is set in 1, retry (== path check) will
> not be launched in no-path situation.
>
Merged, thanks
