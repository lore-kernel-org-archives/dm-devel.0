From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/3] libmultipath: move filter_property()
 from path_discover() into pathinfo()
Date: Wed, 14 Dec 2016 11:07:18 -0200
Message-ID: <74877e30-eba6-d73f-cbd2-9aa8e5fb0894@linux.vnet.ibm.com>
References: <1481680921-6489-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<1481680921-6489-2-git-send-email-mauricfo@linux.vnet.ibm.com>
	<77bf0fec-a848-93dc-095b-24b70019dd64@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <77bf0fec-a848-93dc-095b-24b70019dd64@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Hannes,

Thanks for reviewing.

On 12/14/2016 05:04 AM, Hannes Reinecke wrote:
> So wouldn't it make more sense to move filter_devnode() into pathinfo(),
> too, to avoid further inconsistencies between _filter_path() and
> pathinfo()?

Agree.

> Especially as it looks that if we need to call filter_devnode() in
> get_refwwid(), too; starting with line 976 we're just calling
> 'store_pathinfo' for the device node, with no check for blacklisted
> devnode at all.
> (Which also goes to explain why I have this mysterious bug where
> blacklisting by device node doesn't properly work ...).
> So moving filter_devnode() in pathinfo would be more sensible and clean
> up the overall programming model.

I see. Ok, changed/submitted v4.  Hope it helps w/ that mysterious bug.

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
