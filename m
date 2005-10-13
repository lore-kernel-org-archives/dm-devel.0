From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Failback delay in multipathd is 1 second shorter
Date: Thu, 13 Oct 2005 10:34:26 +0200
Message-ID: <20051013083426.GA27041@free.fr>
References: <20051012.155224.104027237.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051012.155224.104027237.k-ueda@ct.jp.nec.com>
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

On Wed, Oct 12, 2005 at 03:52:24PM -0400, Kiyoshi Ueda wrote:
> Hi Christophe,
> 
> Current delay time of defered failback is 1 second shorter than
> "failback" setting in multipath.conf, because defered_failback_tick()
> is called before sleep(1) in checkerloop().
> 
Merged, thanks.
