From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] libmultipath: Increase SERIAL_SIZE to 128
 bytes
Date: Fri, 14 Dec 2018 11:10:47 +0100
Message-ID: <863e67fa8f79ec914d95b113fde56a0e6361de89.camel@suse.de>
References: <cad99184-26da-c914-84cc-1a49e5e8300a@linux.vnet.ibm.com>
	<de82564c105601825c13db1ec309f28d3f50e3b6.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <de82564c105601825c13db1ec309f28d3f50e3b6.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: kylemahl@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Fri, 2018-12-14 at 10:59 +0100, Martin Wilck wrote:
> 
> > Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> Please resend, and add Christophe to the recepients.

And when you do that, please send it in a format that applies to 
the current upstream code base 
(http://git.opensvc.com/multipath-tools/.git ) with "git am". 
IOW: plain text.

Yes, it's a trivial change that Christophe could make by hand, but we
want your authorship and your changelog message.

Martin
