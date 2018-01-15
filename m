From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Mon, 15 Jan 2018 16:44:24 +0100
Message-ID: <20180115154424.fcjuudt7phxrks6q@jak-x230>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
	<20180112214700.ljxlypo5nar6oh3m@jak-x230>
	<1515795481.9139.8.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1515795481.9139.8.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Device-mapper development mailing list <dm-devel@redhat.com>, Guan Junxiong <guanjunxiong@huawei.com>
List-Id: dm-devel.ids

On Fri, Jan 12, 2018 at 11:18:01PM +0100, Martin Wilck wrote:
> "find_multipaths" is not a silver bullet to kill off multipath-related
> boot problems. It has advantages and disadvantages, depending on the
> use case. Anyway, I'm not aware of general problems with it in the
> later multipath versions.

It was your commit that made it imply -n that caused the test failure :)
I understand your position on that, but reverted it for Ubuntu, because,
while it might be somewhat broken, it's at least the same level of broken
as before.

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
